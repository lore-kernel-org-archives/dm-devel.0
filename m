Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7032E0B6D
	for <dm-devel@lists.linux.dev>; Tue, 12 Aug 2025 08:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754987117; cv=none; b=m3Y1H4dRSQJU8ZB+svqd6SWI0A4f6TGHLQBgmDEYh/RaZIZvjfIW+Ou3E+8hMMqYLHx1JVmw+TVld8gKzUJkQ0v1JFdnzPe/V/RDxh2yoY2Shl2UnrLZONFK2NrLjmnsODxiLx4nFN5zN9w7JnXRColSX6LUGhhUco3vUfKXckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754987117; c=relaxed/simple;
	bh=tMYI/8ru4P9pomfak8OQV3L4kd7NtkkrpA+IMD8fxFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fJYxXFRkyTXAXf/yskAqI2TOmxdYo/rfGrUgPBbU69xHEs2TnCPUy4F/7vF/+ek9yz4G+3hHigi0Y0Kw8KvlTup2P4we/kFfmSwpKAFo/16qCrqiTl4w9CsPIZsMmPKQIQiT1y2o1djGNxsaer9PTYxS9GYhU65ntpAFihmRdnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wm/vvWpv; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wm/vvWpv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754987106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mb6eyiOSw23hxijP86IP6HYJ2bq+2OcNwodlPzkmtzM=;
	b=Wm/vvWpvXMsmUBnnL20fx0SMNLxQKfMYaCDjsue+c5jQdm/dUQbihOL78fkiw1pJaS5txb
	4q4ZwzphcKN6ATOCOlaxZGuPyTcavW+08ofiO8cDGb3xoSsWaAe4Rmxdmxtiz2akjjzQY6
	R7bfRUqS9wN2pJkRyqDrl3FtJ6YWfXA=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	cengku@gmail.com,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v5 1/1] dm-pcache: add persistent cache target in device-mapper
Date: Tue, 12 Aug 2025 08:24:52 +0000
Message-ID: <20250812082452.2041767-2-dongsheng.yang@linux.dev>
In-Reply-To: <20250812082452.2041767-1-dongsheng.yang@linux.dev>
References: <20250812082452.2041767-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This patch introduces dm-pcache, a new DM target that places a DAX-
capable persistent-memory device in front of any slower block device and
uses it as a high-throughput, low-latency  cache.

Design highlights
-----------------
- DAX data path – data is copied directly between DRAM and the pmem
  mapping, bypassing the block layer’s overhead.

- Segmented, crash-consistent layout
  - all layout metadata are dual-replicated CRC-protected.
  - atomic kset flushes; key replay on mount guarantees cache integrity
    even after power loss.

- Striped multi-tree index
  - Multi‑tree indexing for high parallelism.
  - overlap-resolution logic ensures non-intersecting cached extents.

- Background services
  - write-back worker flushes dirty keys in order, preserving backing-device
    crash consistency. This is important for checkpoint in cloud storage.
  - garbage collector reclaims clean segments when utilisation exceeds a
    tunable threshold.

- Data integrity – optional CRC32 on cached payload; metadata always protected.

Comparison with existing block-level caches
---------------------------------------------------------------------------------------------------------------------------------
| Feature                          | pcache (this patch)             | bcache                        | dm-writecache            |
|----------------------------------|---------------------------------|------------------------------|---------------------------|
| pmem access method               | DAX                             | bio (block I/O)              | DAX                       |
| Write latency (4 K rand-write)   | ~5 µs                           | ~20 µs                       | ~5 µs                     |
| Concurrency                      | multi subtree index             | global index tree            | single tree + wc_lock     |
| IOPS (4K randwrite, 32 numjobs)  | 2.1 M                           | 352 K                        | 283 K                     |
| Read-cache support               | YES                             | YES                          | NO                        |
| Deployment                       | no re-format of backend         | backend devices must be      | no re-format of backend   |
|                                  |                                 | reformatted                  |                           |
| Write-back ordering              | log-structured;                 | no ordering guarantee        | no ordering guarantee     |
|                                  | preserves app-IO-order          |                              |                           |
| Data integrity checks            | metadata + data CRC(optional)   | metadata CRC only            | none                      |
---------------------------------------------------------------------------------------------------------------------------------

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 .../admin-guide/device-mapper/dm-pcache.rst   | 201 ++++
 MAINTAINERS                                   |   8 +
 drivers/md/Kconfig                            |   2 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-pcache/Kconfig                  |  17 +
 drivers/md/dm-pcache/Makefile                 |   3 +
 drivers/md/dm-pcache/backing_dev.c            | 374 ++++++++
 drivers/md/dm-pcache/backing_dev.h            | 100 ++
 drivers/md/dm-pcache/cache.c                  | 445 +++++++++
 drivers/md/dm-pcache/cache.h                  | 632 +++++++++++++
 drivers/md/dm-pcache/cache_dev.c              | 299 ++++++
 drivers/md/dm-pcache/cache_dev.h              |  70 ++
 drivers/md/dm-pcache/cache_gc.c               | 170 ++++
 drivers/md/dm-pcache/cache_key.c              | 888 ++++++++++++++++++
 drivers/md/dm-pcache/cache_req.c              | 835 ++++++++++++++++
 drivers/md/dm-pcache/cache_segment.c          | 293 ++++++
 drivers/md/dm-pcache/cache_writeback.c        | 258 +++++
 drivers/md/dm-pcache/dm_pcache.c              | 497 ++++++++++
 drivers/md/dm-pcache/dm_pcache.h              |  67 ++
 drivers/md/dm-pcache/pcache_internal.h        | 117 +++
 drivers/md/dm-pcache/segment.c                |  61 ++
 drivers/md/dm-pcache/segment.h                |  74 ++
 22 files changed, 5412 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-pcache.rst
 create mode 100644 drivers/md/dm-pcache/Kconfig
 create mode 100644 drivers/md/dm-pcache/Makefile
 create mode 100644 drivers/md/dm-pcache/backing_dev.c
 create mode 100644 drivers/md/dm-pcache/backing_dev.h
 create mode 100644 drivers/md/dm-pcache/cache.c
 create mode 100644 drivers/md/dm-pcache/cache.h
 create mode 100644 drivers/md/dm-pcache/cache_dev.c
 create mode 100644 drivers/md/dm-pcache/cache_dev.h
 create mode 100644 drivers/md/dm-pcache/cache_gc.c
 create mode 100644 drivers/md/dm-pcache/cache_key.c
 create mode 100644 drivers/md/dm-pcache/cache_req.c
 create mode 100644 drivers/md/dm-pcache/cache_segment.c
 create mode 100644 drivers/md/dm-pcache/cache_writeback.c
 create mode 100644 drivers/md/dm-pcache/dm_pcache.c
 create mode 100644 drivers/md/dm-pcache/dm_pcache.h
 create mode 100644 drivers/md/dm-pcache/pcache_internal.h
 create mode 100644 drivers/md/dm-pcache/segment.c
 create mode 100644 drivers/md/dm-pcache/segment.h

diff --git a/Documentation/admin-guide/device-mapper/dm-pcache.rst b/Documentation/admin-guide/device-mapper/dm-pcache.rst
new file mode 100644
index 000000000000..e6433fab7bd6
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/dm-pcache.rst
@@ -0,0 +1,201 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+dm-pcache — Persistent Cache
+=================================
+
+*Author: Dongsheng Yang <dongsheng.yang@linux.dev>*
+
+This document describes *dm-pcache*, a Device-Mapper target that lets a
+byte-addressable *DAX* (persistent-memory, “pmem”) region act as a
+high-performance, crash-persistent cache in front of a slower block
+device.  The code lives in `drivers/md/dm-pcache/`.
+
+Quick feature summary
+=====================
+
+* *Write-back* caching (only mode currently supported).
+* *16 MiB segments* allocated on the pmem device.
+* *Data CRC32* verification (optional, per cache).
+* Crash-safe: every metadata structure is duplicated (`PCACHE_META_INDEX_MAX
+  == 2`) and protected with CRC+sequence numbers.
+* *Multi-tree indexing* (one radix tree per CPU backend) for high PMem
+  parallelism
+* Pure *DAX path* I/O – no extra BIO round-trips
+* *Log-structured write-back* that preserves backend crash-consistency
+
+-------------------------------------------------------------------------------
+Constructor
+===========
+
+::
+
+    pcache <cache_dev> <backing_dev> [<number_of_optional_arguments> <cache_mode writeback> <data_crc true|false>]
+
+=========================  ====================================================
+``cache_dev``               Any DAX-capable block device (``/dev/pmem0``…).
+                            All metadata *and* cached blocks are stored here.
+
+``backing_dev``             The slow block device to be cached.
+
+``cache_mode``              Optional, Only ``writeback`` is accepted at the moment.
+
+``data_crc``                Optional, default to ``false``
+                            ``true``  – store CRC32 for every cached entry and
+                                      verify on reads
+                            ``false`` – skip CRC (faster)
+=========================  ====================================================
+
+Example
+-------
+
+.. code-block:: shell
+
+   dmsetup create pcache_sdb --table \
+     "0 $(blockdev --getsz /dev/sdb) pcache /dev/pmem0 /dev/sdb 4 cache_mode writeback data_crc true"
+
+The first time a pmem device is used, dm-pcache formats it automatically
+(super-block, cache_info, etc.).
+
+-------------------------------------------------------------------------------
+Status line
+===========
+
+``dmsetup status <device>`` (``STATUSTYPE_INFO``) prints:
+
+::
+
+   <sb_flags> <seg_total> <cache_segs> <segs_used> \
+   <gc_percent> <cache_flags> \
+   <key_head_seg>:<key_head_off> \
+   <dirty_tail_seg>:<dirty_tail_off> \
+   <key_tail_seg>:<key_tail_off>
+
+Field meanings
+--------------
+
+===============================  =============================================
+``sb_flags``                     Super-block flags (e.g. endian marker).
+
+``seg_total``                    Number of physical *pmem* segments.
+
+``cache_segs``                   Number of segments used for cache.
+
+``segs_used``                    Segments currently allocated (bitmap weight).
+
+``gc_percent``                   Current GC high-water mark (0-90).
+
+``cache_flags``                  Bit 0 – DATA_CRC enabled
+                                 Bit 1 – INIT_DONE (cache initialised)
+                                 Bits 2-5 – cache mode (0 == WB).
+
+``key_head``                     Where new key-sets are being written.
+
+``dirty_tail``                   First dirty key-set that still needs
+                                 write-back to the backing device.
+
+``key_tail``                     First key-set that may be reclaimed by GC.
+===============================  =============================================
+
+-------------------------------------------------------------------------------
+Messages
+========
+
+*Change GC trigger*
+
+::
+
+   dmsetup message <dev> 0 gc_percent <0-90>
+
+-------------------------------------------------------------------------------
+Theory of operation
+===================
+
+Sub-devices
+-----------
+
+====================  =========================================================
+backing_dev             Any block device (SSD/HDD/loop/LVM, etc.).
+cache_dev               DAX device; must expose direct-access memory.
+====================  =========================================================
+
+Segments and key-sets
+---------------------
+
+* The pmem space is divided into *16 MiB segments*.
+* Each write allocates space from a per-CPU *data_head* inside a segment.
+* A *cache-key* records a logical range on the origin and where it lives
+  inside pmem (segment + offset + generation).
+* 128 keys form a *key-set* (kset); ksets are written sequentially in pmem
+  and are themselves crash-safe (CRC).
+* The pair *(key_tail, dirty_tail)* delimit clean/dirty and live/dead ksets.
+
+Write-back
+----------
+
+Dirty keys are queued into a tree; a background worker copies data
+back to the backing_dev and advances *dirty_tail*.  A FLUSH/FUA bio from the
+upper layers forces an immediate metadata commit.
+
+Garbage collection
+------------------
+
+GC starts when ``segs_used >= seg_total * gc_percent / 100``.  It walks
+from *key_tail*, frees segments whose every key has been invalidated, and
+advances *key_tail*.
+
+CRC verification
+----------------
+
+If ``data_crc is enabled`` dm-pcache computes a CRC32 over every cached data
+range when it is inserted and stores it in the on-media key.  Reads
+validate the CRC before copying to the caller.
+
+-------------------------------------------------------------------------------
+Failure handling
+================
+
+* *pmem media errors* – all metadata copies are read with
+  ``copy_mc_to_kernel``; an uncorrectable error logs and aborts initialisation.
+* *Cache full* – if no free segment can be found, writes return ``-EBUSY``;
+  dm-pcache retries internally (request deferral).
+* *System crash* – on attach, the driver replays ksets from *key_tail* to
+  rebuild the in-core trees; every segment’s generation guards against
+  use-after-free keys.
+
+-------------------------------------------------------------------------------
+Limitations & TODO
+==================
+
+* Only *write-back* mode; other modes planned.
+* Only FIFO cache invalidate; other (LRU, ARC...) planned.
+* Table reload is not supported currently.
+* Discard planned.
+
+-------------------------------------------------------------------------------
+Example workflow
+================
+
+.. code-block:: shell
+
+   # 1.  Create devices
+   dmsetup create pcache_sdb --table \
+     "0 $(blockdev --getsz /dev/sdb) pcache /dev/pmem0 /dev/sdb 4 cache_mode writeback data_crc true"
+
+   # 2.  Put a filesystem on top
+   mkfs.ext4 /dev/mapper/pcache_sdb
+   mount /dev/mapper/pcache_sdb /mnt
+
+   # 3.  Tune GC threshold to 80 %
+   dmsetup message pcache_sdb 0 gc_percent 80
+
+   # 4.  Observe status
+   watch -n1 'dmsetup status pcache_sdb'
+
+   # 5.  Shutdown
+   umount /mnt
+   dmsetup remove pcache_sdb
+
+-------------------------------------------------------------------------------
+``dm-pcache`` is under active development; feedback, bug reports and patches
+are very welcome!
diff --git a/MAINTAINERS b/MAINTAINERS
index c0b444e5fd5a..b273e79befae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6950,6 +6950,14 @@ S:	Maintained
 F:	Documentation/admin-guide/device-mapper/vdo*.rst
 F:	drivers/md/dm-vdo/
 
+DEVICE-MAPPER PCACHE TARGET
+M:	Dongsheng Yang <dongsheng.yang@linux.dev>
+M:	Zheng Gu <cengku@gmail.com>
+L:	dm-devel@lists.linux.dev
+S:	Maintained
+F:	Documentation/admin-guide/device-mapper/dm-pcache.rst
+F:	drivers/md/dm-pcache/
+
 DEVLINK
 M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index ddb37f6670de..cd4d8d1705bb 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -659,4 +659,6 @@ config DM_AUDIT
 
 source "drivers/md/dm-vdo/Kconfig"
 
+source "drivers/md/dm-pcache/Kconfig"
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 87bdfc9fe14c..f91a3133677f 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_DM_RAID)		+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING) += dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 obj-$(CONFIG_DM_VDO)            += dm-vdo/
+obj-$(CONFIG_DM_PCACHE)		+= dm-pcache/
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_SMQ)	+= dm-cache-smq.o
 obj-$(CONFIG_DM_EBS)		+= dm-ebs.o
diff --git a/drivers/md/dm-pcache/Kconfig b/drivers/md/dm-pcache/Kconfig
new file mode 100644
index 000000000000..0e251eca892e
--- /dev/null
+++ b/drivers/md/dm-pcache/Kconfig
@@ -0,0 +1,17 @@
+config DM_PCACHE
+	tristate "Persistent cache for Block Device (Experimental)"
+	depends on BLK_DEV_DM
+	depends on DEV_DAX
+	help
+	  PCACHE provides a mechanism to use persistent memory (e.g., CXL persistent memory,
+	  DAX-enabled devices) as a high-performance cache layer in front of
+	  traditional block devices such as SSDs or HDDs.
+
+	  PCACHE is implemented as a kernel module that integrates with the block
+	  layer and supports direct access (DAX) to persistent memory for low-latency,
+	  byte-addressable caching.
+
+	  Note: This feature is experimental and should be tested thoroughly
+	  before use in production environments.
+
+	  If unsure, say 'N'.
diff --git a/drivers/md/dm-pcache/Makefile b/drivers/md/dm-pcache/Makefile
new file mode 100644
index 000000000000..86776e4acad2
--- /dev/null
+++ b/drivers/md/dm-pcache/Makefile
@@ -0,0 +1,3 @@
+dm-pcache-y := dm_pcache.o cache_dev.o segment.o backing_dev.o cache.o cache_gc.o cache_writeback.o cache_segment.o cache_key.o cache_req.o
+
+obj-m += dm-pcache.o
diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcache/backing_dev.c
new file mode 100644
index 000000000000..dcbebc0d7062
--- /dev/null
+++ b/drivers/md/dm-pcache/backing_dev.c
@@ -0,0 +1,374 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blkdev.h>
+
+#include "../dm-core.h"
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "cache.h"
+#include "dm_pcache.h"
+
+static struct kmem_cache *backing_req_cache;
+static struct kmem_cache *backing_bvec_cache;
+
+static void backing_dev_exit(struct pcache_backing_dev *backing_dev)
+{
+	mempool_exit(&backing_dev->req_pool);
+	mempool_exit(&backing_dev->bvec_pool);
+}
+
+static void req_submit_fn(struct work_struct *work);
+static void req_complete_fn(struct work_struct *work);
+static int backing_dev_init(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	int ret;
+
+	ret = mempool_init_slab_pool(&backing_dev->req_pool, 128, backing_req_cache);
+	if (ret)
+		goto err;
+
+	ret = mempool_init_slab_pool(&backing_dev->bvec_pool, 128, backing_bvec_cache);
+	if (ret)
+		goto req_pool_exit;
+
+	INIT_LIST_HEAD(&backing_dev->submit_list);
+	INIT_LIST_HEAD(&backing_dev->complete_list);
+	spin_lock_init(&backing_dev->submit_lock);
+	spin_lock_init(&backing_dev->complete_lock);
+	INIT_WORK(&backing_dev->req_submit_work, req_submit_fn);
+	INIT_WORK(&backing_dev->req_complete_work, req_complete_fn);
+	atomic_set(&backing_dev->inflight_reqs, 0);
+	init_waitqueue_head(&backing_dev->inflight_wq);
+
+	return 0;
+
+req_pool_exit:
+	mempool_exit(&backing_dev->req_pool);
+err:
+	return ret;
+}
+
+int backing_dev_start(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	int ret;
+
+	ret = backing_dev_init(pcache);
+	if (ret)
+		return ret;
+
+	backing_dev->dev_size = bdev_nr_sectors(backing_dev->dm_dev->bdev);
+
+	return 0;
+}
+
+void backing_dev_stop(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+
+	/*
+	 * There should not be any new request comming, just wait
+	 * inflight requests done.
+	 */
+	wait_event(backing_dev->inflight_wq,
+			atomic_read(&backing_dev->inflight_reqs) == 0);
+
+	flush_work(&backing_dev->req_submit_work);
+	flush_work(&backing_dev->req_complete_work);
+
+	backing_dev_exit(backing_dev);
+}
+
+/* pcache_backing_dev_req functions */
+void backing_dev_req_end(struct pcache_backing_dev_req *backing_req)
+{
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	if (backing_req->end_req)
+		backing_req->end_req(backing_req, backing_req->ret);
+
+	switch (backing_req->type) {
+	case BACKING_DEV_REQ_TYPE_REQ:
+		if (backing_req->req.upper_req)
+			pcache_req_put(backing_req->req.upper_req, backing_req->ret);
+		break;
+	case BACKING_DEV_REQ_TYPE_KMEM:
+		if (backing_req->kmem.bvecs != backing_req->kmem.inline_bvecs)
+			mempool_free(backing_req->kmem.bvecs, &backing_dev->bvec_pool);
+		break;
+	default:
+		BUG();
+	}
+
+	mempool_free(backing_req, &backing_dev->req_pool);
+
+	if (atomic_dec_and_test(&backing_dev->inflight_reqs))
+		wake_up(&backing_dev->inflight_wq);
+}
+
+static void req_complete_fn(struct work_struct *work)
+{
+	struct pcache_backing_dev *backing_dev = container_of(work, struct pcache_backing_dev, req_complete_work);
+	struct pcache_backing_dev_req *backing_req;
+	LIST_HEAD(tmp_list);
+
+	spin_lock_irq(&backing_dev->complete_lock);
+	list_splice_init(&backing_dev->complete_list, &tmp_list);
+	spin_unlock_irq(&backing_dev->complete_lock);
+
+	while (!list_empty(&tmp_list)) {
+		backing_req = list_first_entry(&tmp_list,
+					    struct pcache_backing_dev_req, node);
+		list_del_init(&backing_req->node);
+		backing_dev_req_end(backing_req);
+	}
+}
+
+static void backing_dev_bio_end(struct bio *bio)
+{
+	struct pcache_backing_dev_req *backing_req = bio->bi_private;
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+	unsigned long flags;
+
+	backing_req->ret = bio->bi_status;
+
+	spin_lock_irqsave(&backing_dev->complete_lock, flags);
+	list_move_tail(&backing_req->node, &backing_dev->complete_list);
+	queue_work(BACKING_DEV_TO_PCACHE(backing_dev)->task_wq, &backing_dev->req_complete_work);
+	spin_unlock_irqrestore(&backing_dev->complete_lock, flags);
+}
+
+static void req_submit_fn(struct work_struct *work)
+{
+	struct pcache_backing_dev *backing_dev = container_of(work, struct pcache_backing_dev, req_submit_work);
+	struct pcache_backing_dev_req *backing_req;
+	LIST_HEAD(tmp_list);
+
+	spin_lock(&backing_dev->submit_lock);
+	list_splice_init(&backing_dev->submit_list, &tmp_list);
+	spin_unlock(&backing_dev->submit_lock);
+
+	while (!list_empty(&tmp_list)) {
+		backing_req = list_first_entry(&tmp_list,
+					    struct pcache_backing_dev_req, node);
+		list_del_init(&backing_req->node);
+		submit_bio_noacct(&backing_req->bio);
+	}
+}
+
+void backing_dev_req_submit(struct pcache_backing_dev_req *backing_req, bool direct)
+{
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	if (direct) {
+		submit_bio_noacct(&backing_req->bio);
+		return;
+	}
+
+	spin_lock(&backing_dev->submit_lock);
+	list_add_tail(&backing_req->node, &backing_dev->submit_list);
+	queue_work(BACKING_DEV_TO_PCACHE(backing_dev)->task_wq, &backing_dev->req_submit_work);
+	spin_unlock(&backing_dev->submit_lock);
+}
+
+static void bio_map(struct bio *bio, void *base, size_t size)
+{
+	struct page *page;
+	unsigned int offset;
+	unsigned int len;
+
+	if (!is_vmalloc_addr(base)) {
+		page = virt_to_page(base);
+		offset = offset_in_page(base);
+
+		BUG_ON(!bio_add_page(bio, page, size, offset));
+		return;
+	}
+
+	flush_kernel_vmap_range(base, size);
+	while (size) {
+		page = vmalloc_to_page(base);
+		offset = offset_in_page(base);
+		len = min_t(size_t, PAGE_SIZE - offset, size);
+
+		BUG_ON(!bio_add_page(bio, page, len, offset));
+		size -= len;
+		base += len;
+	}
+}
+
+static struct pcache_backing_dev_req *req_type_req_alloc(struct pcache_backing_dev *backing_dev,
+							struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_request *pcache_req = opts->req.upper_req;
+	struct pcache_backing_dev_req *backing_req;
+	struct bio *orig = pcache_req->bio;
+
+	backing_req = mempool_alloc(&backing_dev->req_pool, opts->gfp_mask);
+	if (!backing_req)
+		return NULL;
+
+	memset(backing_req, 0, sizeof(struct pcache_backing_dev_req));
+
+	bio_init_clone(backing_dev->dm_dev->bdev, &backing_req->bio, orig, opts->gfp_mask);
+
+	backing_req->type = BACKING_DEV_REQ_TYPE_REQ;
+	backing_req->backing_dev = backing_dev;
+	atomic_inc(&backing_dev->inflight_reqs);
+
+	return backing_req;
+}
+
+static struct pcache_backing_dev_req *kmem_type_req_alloc(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_backing_dev_req *backing_req;
+	u32 n_vecs = bio_add_max_vecs(opts->kmem.data, opts->kmem.len);
+
+	backing_req = mempool_alloc(&backing_dev->req_pool, opts->gfp_mask);
+	if (!backing_req)
+		return NULL;
+
+	memset(backing_req, 0, sizeof(struct pcache_backing_dev_req));
+
+	if (n_vecs > BACKING_DEV_REQ_INLINE_BVECS) {
+		backing_req->kmem.bvecs = mempool_alloc(&backing_dev->bvec_pool, opts->gfp_mask);
+		if (!backing_req->kmem.bvecs)
+			goto free_backing_req;
+	} else {
+		backing_req->kmem.bvecs = backing_req->kmem.inline_bvecs;
+	}
+
+	backing_req->kmem.n_vecs = n_vecs;
+	backing_req->type = BACKING_DEV_REQ_TYPE_KMEM;
+	backing_req->backing_dev = backing_dev;
+	atomic_inc(&backing_dev->inflight_reqs);
+
+	return backing_req;
+
+free_backing_req:
+	mempool_free(backing_req, &backing_dev->req_pool);
+	return NULL;
+}
+
+struct pcache_backing_dev_req *backing_dev_req_alloc(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts)
+{
+	if (opts->type == BACKING_DEV_REQ_TYPE_REQ)
+		return req_type_req_alloc(backing_dev, opts);
+
+	if (opts->type == BACKING_DEV_REQ_TYPE_KMEM)
+		return kmem_type_req_alloc(backing_dev, opts);
+
+	BUG();
+}
+
+static void req_type_req_init(struct pcache_backing_dev_req *backing_req,
+			struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_request *pcache_req = opts->req.upper_req;
+	struct bio *clone;
+	u32 off = opts->req.req_off;
+	u32 len = opts->req.len;
+
+	clone = &backing_req->bio;
+	BUG_ON(off & SECTOR_MASK);
+	BUG_ON(len & SECTOR_MASK);
+	bio_trim(clone, off >> SECTOR_SHIFT, len >> SECTOR_SHIFT);
+
+	clone->bi_iter.bi_sector = (pcache_req->off + off) >> SECTOR_SHIFT;
+	clone->bi_private = backing_req;
+	clone->bi_end_io = backing_dev_bio_end;
+
+	INIT_LIST_HEAD(&backing_req->node);
+	backing_req->end_req     = opts->end_fn;
+
+	pcache_req_get(pcache_req);
+	backing_req->req.upper_req	= pcache_req;
+	backing_req->req.bio_off	= off;
+}
+
+static void kmem_type_req_init(struct pcache_backing_dev_req *backing_req,
+			struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+	struct bio *backing_bio;
+
+	bio_init(&backing_req->bio, backing_dev->dm_dev->bdev, backing_req->kmem.bvecs,
+			backing_req->kmem.n_vecs, opts->kmem.opf);
+
+	backing_bio = &backing_req->bio;
+	bio_map(backing_bio, opts->kmem.data, opts->kmem.len);
+
+	backing_bio->bi_iter.bi_sector = (opts->kmem.backing_off) >> SECTOR_SHIFT;
+	backing_bio->bi_private = backing_req;
+	backing_bio->bi_end_io = backing_dev_bio_end;
+
+	INIT_LIST_HEAD(&backing_req->node);
+	backing_req->end_req	= opts->end_fn;
+	backing_req->priv_data	= opts->priv_data;
+}
+
+void backing_dev_req_init(struct pcache_backing_dev_req *backing_req,
+			struct pcache_backing_dev_req_opts *opts)
+{
+	if (opts->type == BACKING_DEV_REQ_TYPE_REQ)
+		return req_type_req_init(backing_req, opts);
+
+	if (opts->type == BACKING_DEV_REQ_TYPE_KMEM)
+		return kmem_type_req_init(backing_req, opts);
+
+	BUG();
+}
+
+struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts)
+{
+	struct pcache_backing_dev_req *backing_req;
+
+	backing_req = backing_dev_req_alloc(backing_dev, opts);
+	if (!backing_req)
+		return NULL;
+
+	backing_dev_req_init(backing_req, opts);
+
+	return backing_req;
+}
+
+void backing_dev_flush(struct pcache_backing_dev *backing_dev)
+{
+	blkdev_issue_flush(backing_dev->dm_dev->bdev);
+}
+
+int pcache_backing_init(void)
+{
+	u32 max_bvecs = (PCACHE_CACHE_SUBTREE_SIZE >> PAGE_SHIFT) + 1;
+	int ret;
+
+	backing_req_cache = KMEM_CACHE(pcache_backing_dev_req, 0);
+	if (!backing_req_cache) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	backing_bvec_cache = kmem_cache_create("pcache-bvec-slab",
+					max_bvecs * sizeof(struct bio_vec),
+					0, 0, NULL);
+	if (!backing_bvec_cache) {
+		ret = -ENOMEM;
+		goto destroy_req_cache;
+	}
+
+	return 0;
+destroy_req_cache:
+	kmem_cache_destroy(backing_req_cache);
+err:
+	return ret;
+}
+
+void pcache_backing_exit(void)
+{
+	kmem_cache_destroy(backing_bvec_cache);
+	kmem_cache_destroy(backing_req_cache);
+}
diff --git a/drivers/md/dm-pcache/backing_dev.h b/drivers/md/dm-pcache/backing_dev.h
new file mode 100644
index 000000000000..fbcce983f0eb
--- /dev/null
+++ b/drivers/md/dm-pcache/backing_dev.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _BACKING_DEV_H
+#define _BACKING_DEV_H
+
+#include <linux/device-mapper.h>
+
+#include "pcache_internal.h"
+
+struct pcache_backing_dev_req;
+typedef void (*backing_req_end_fn_t)(struct pcache_backing_dev_req *backing_req, int ret);
+
+#define BACKING_DEV_REQ_TYPE_REQ		1
+#define BACKING_DEV_REQ_TYPE_KMEM		2
+
+#define BACKING_DEV_REQ_INLINE_BVECS		4
+
+struct pcache_request;
+struct pcache_backing_dev_req {
+	u8				type;
+	struct bio			bio;
+	struct pcache_backing_dev	*backing_dev;
+
+	void				*priv_data;
+	backing_req_end_fn_t		end_req;
+
+	struct list_head		node;
+	int				ret;
+
+	union {
+		struct {
+			struct pcache_request		*upper_req;
+			u32				bio_off;
+		} req;
+		struct {
+			struct bio_vec	inline_bvecs[BACKING_DEV_REQ_INLINE_BVECS];
+			struct bio_vec	*bvecs;
+			u32		n_vecs;
+		} kmem;
+	};
+};
+
+struct pcache_backing_dev {
+	struct pcache_cache		*cache;
+
+	struct dm_dev			*dm_dev;
+	mempool_t			req_pool;
+	mempool_t			bvec_pool;
+
+	struct list_head		submit_list;
+	spinlock_t			submit_lock;
+	struct work_struct		req_submit_work;
+
+	struct list_head		complete_list;
+	spinlock_t			complete_lock;
+	struct work_struct		req_complete_work;
+
+	atomic_t			inflight_reqs;
+	wait_queue_head_t		inflight_wq;
+
+	u64				dev_size;
+};
+
+struct dm_pcache;
+int backing_dev_start(struct dm_pcache *pcache);
+void backing_dev_stop(struct dm_pcache *pcache);
+
+struct pcache_backing_dev_req_opts {
+	u32 type;
+	union {
+		struct {
+			struct pcache_request *upper_req;
+			u32 req_off;
+			u32 len;
+		} req;
+		struct {
+			void *data;
+			blk_opf_t opf;
+			u32 len;
+			u64 backing_off;
+		} kmem;
+	};
+
+	gfp_t gfp_mask;
+	backing_req_end_fn_t	end_fn;
+	void			*priv_data;
+};
+
+void backing_dev_req_submit(struct pcache_backing_dev_req *backing_req, bool direct);
+void backing_dev_req_end(struct pcache_backing_dev_req *backing_req);
+struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts);
+struct pcache_backing_dev_req *backing_dev_req_alloc(struct pcache_backing_dev *backing_dev,
+						struct pcache_backing_dev_req_opts *opts);
+void backing_dev_req_init(struct pcache_backing_dev_req *backing_req,
+			struct pcache_backing_dev_req_opts *opts);
+void backing_dev_flush(struct pcache_backing_dev *backing_dev);
+
+int pcache_backing_init(void);
+void pcache_backing_exit(void);
+#endif /* _BACKING_DEV_H */
diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
new file mode 100644
index 000000000000..d8e92367d947
--- /dev/null
+++ b/drivers/md/dm-pcache/cache.c
@@ -0,0 +1,445 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blk_types.h>
+
+#include "cache.h"
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "dm_pcache.h"
+
+struct kmem_cache *key_cache;
+
+static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
+{
+	return cache->cache_info_addr + cache->info_index;
+}
+
+static void cache_info_write(struct pcache_cache *cache)
+{
+	struct pcache_cache_info *cache_info = &cache->cache_info;
+
+	cache_info->header.seq++;
+	cache_info->header.crc = pcache_meta_crc(&cache_info->header,
+						sizeof(struct pcache_cache_info));
+
+	memcpy_flushcache(get_cache_info_addr(cache), cache_info,
+			sizeof(struct pcache_cache_info));
+
+	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
+}
+
+static void cache_info_init_default(struct pcache_cache *cache);
+static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_options *opts)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_info *cache_info_addr;
+
+	cache_info_addr = pcache_meta_find_latest(&cache->cache_info_addr->header,
+						sizeof(struct pcache_cache_info),
+						PCACHE_CACHE_INFO_SIZE,
+						&cache->cache_info);
+	if (IS_ERR(cache_info_addr))
+		return PTR_ERR(cache_info_addr);
+
+	if (cache_info_addr) {
+		if (opts->data_crc !=
+				(cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC)) {
+			pcache_dev_err(pcache, "invalid option for data_crc: %s, expected: %s",
+					opts->data_crc ? "true" : "false",
+					cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC ? "true" : "false");
+			return -EINVAL;
+		}
+
+		return 0;
+	}
+
+	/* init cache_info for new cache */
+	cache_info_init_default(cache);
+	cache_mode_set(cache, opts->cache_mode);
+	if (opts->data_crc)
+		cache->cache_info.flags |= PCACHE_CACHE_FLAGS_DATA_CRC;
+
+	return 0;
+}
+
+static void cache_info_set_gc_percent(struct pcache_cache_info *cache_info, u8 percent)
+{
+	cache_info->flags &= ~PCACHE_CACHE_FLAGS_GC_PERCENT_MASK;
+	cache_info->flags |= FIELD_PREP(PCACHE_CACHE_FLAGS_GC_PERCENT_MASK, percent);
+}
+
+int pcache_cache_set_gc_percent(struct pcache_cache *cache, u8 percent)
+{
+	if (percent > PCACHE_CACHE_GC_PERCENT_MAX || percent < PCACHE_CACHE_GC_PERCENT_MIN)
+		return -EINVAL;
+
+	mutex_lock(&cache->cache_info_lock);
+	cache_info_set_gc_percent(&cache->cache_info, percent);
+
+	cache_info_write(cache);
+	mutex_unlock(&cache->cache_info_lock);
+
+	return 0;
+}
+
+void cache_pos_encode(struct pcache_cache *cache,
+			     struct pcache_cache_pos_onmedia *pos_onmedia_base,
+			     struct pcache_cache_pos *pos, u64 seq, u32 *index)
+{
+	struct pcache_cache_pos_onmedia pos_onmedia;
+	struct pcache_cache_pos_onmedia *pos_onmedia_addr = pos_onmedia_base + *index;
+
+	pos_onmedia.cache_seg_id = pos->cache_seg->cache_seg_id;
+	pos_onmedia.seg_off = pos->seg_off;
+	pos_onmedia.header.seq = seq;
+	pos_onmedia.header.crc = cache_pos_onmedia_crc(&pos_onmedia);
+
+	memcpy_flushcache(pos_onmedia_addr, &pos_onmedia, sizeof(struct pcache_cache_pos_onmedia));
+	pmem_wmb();
+
+	*index = (*index + 1) % PCACHE_META_INDEX_MAX;
+}
+
+int cache_pos_decode(struct pcache_cache *cache,
+			    struct pcache_cache_pos_onmedia *pos_onmedia,
+			    struct pcache_cache_pos *pos, u64 *seq, u32 *index)
+{
+	struct pcache_cache_pos_onmedia latest, *latest_addr;
+
+	latest_addr = pcache_meta_find_latest(&pos_onmedia->header,
+					sizeof(struct pcache_cache_pos_onmedia),
+					sizeof(struct pcache_cache_pos_onmedia),
+					&latest);
+	if (IS_ERR(latest_addr))
+		return PTR_ERR(latest_addr);
+
+	if (!latest_addr)
+		return -EIO;
+
+	pos->cache_seg = &cache->segments[latest.cache_seg_id];
+	pos->seg_off = latest.seg_off;
+	*seq = latest.header.seq;
+	*index = (latest_addr - pos_onmedia);
+
+	return 0;
+}
+
+static inline void cache_info_set_seg_id(struct pcache_cache *cache, u32 seg_id)
+{
+	cache->cache_info.seg_id = seg_id;
+}
+
+static int cache_init(struct dm_pcache *pcache)
+{
+	struct pcache_cache *cache = &pcache->cache;
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+	int ret;
+
+	cache->segments = kvcalloc(cache_dev->seg_num, sizeof(struct pcache_cache_segment), GFP_KERNEL);
+	if (!cache->segments) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	cache->seg_map = kvcalloc(BITS_TO_LONGS(cache_dev->seg_num), sizeof(unsigned long), GFP_KERNEL);
+	if (!cache->seg_map) {
+		ret = -ENOMEM;
+		goto free_segments;
+	}
+
+	cache->backing_dev = backing_dev;
+	cache->cache_dev = &pcache->cache_dev;
+	cache->n_segs = cache_dev->seg_num;
+	atomic_set(&cache->gc_errors, 0);
+	spin_lock_init(&cache->seg_map_lock);
+	spin_lock_init(&cache->key_head_lock);
+
+	mutex_init(&cache->cache_info_lock);
+	mutex_init(&cache->key_tail_lock);
+	mutex_init(&cache->dirty_tail_lock);
+	mutex_init(&cache->writeback_lock);
+
+	INIT_DELAYED_WORK(&cache->writeback_work, cache_writeback_fn);
+	INIT_DELAYED_WORK(&cache->gc_work, pcache_cache_gc_fn);
+	INIT_WORK(&cache->clean_work, clean_fn);
+
+	return 0;
+
+free_segments:
+	kvfree(cache->segments);
+err:
+	return ret;
+}
+
+static void cache_exit(struct pcache_cache *cache)
+{
+	kvfree(cache->seg_map);
+	kvfree(cache->segments);
+}
+
+static void cache_info_init_default(struct pcache_cache *cache)
+{
+	struct pcache_cache_info *cache_info = &cache->cache_info;
+
+	cache_info->header.seq = 0;
+	cache_info->n_segs = cache->cache_dev->seg_num;
+	cache_info_set_gc_percent(cache_info, PCACHE_CACHE_GC_PERCENT_DEFAULT);
+}
+
+static int cache_tail_init(struct pcache_cache *cache)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	bool new_cache = !(cache->cache_info.flags & PCACHE_CACHE_FLAGS_INIT_DONE);
+
+	if (new_cache) {
+		__set_bit(0, cache->seg_map);
+
+		cache->key_head.cache_seg = &cache->segments[0];
+		cache->key_head.seg_off = 0;
+		cache_pos_copy(&cache->key_tail, &cache->key_head);
+		cache_pos_copy(&cache->dirty_tail, &cache->key_head);
+
+		cache_encode_dirty_tail(cache);
+		cache_encode_key_tail(cache);
+	} else {
+		if (cache_decode_key_tail(cache) || cache_decode_dirty_tail(cache)) {
+			pcache_dev_err(pcache, "Corrupted key tail or dirty tail.\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static int get_seg_id(struct pcache_cache *cache,
+		      struct pcache_cache_segment *prev_cache_seg,
+		      bool new_cache, u32 *seg_id)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_dev *cache_dev = cache->cache_dev;
+	int ret;
+
+	if (new_cache) {
+		ret = cache_dev_get_empty_segment_id(cache_dev, seg_id);
+		if (ret) {
+			pcache_dev_err(pcache, "no available segment\n");
+			goto err;
+		}
+
+		if (prev_cache_seg)
+			cache_seg_set_next_seg(prev_cache_seg, *seg_id);
+		else
+			cache_info_set_seg_id(cache, *seg_id);
+	} else {
+		if (prev_cache_seg) {
+			struct pcache_segment_info *prev_seg_info;
+
+			prev_seg_info = &prev_cache_seg->cache_seg_info;
+			if (!segment_info_has_next(prev_seg_info)) {
+				ret = -EFAULT;
+				goto err;
+			}
+			*seg_id = prev_cache_seg->cache_seg_info.next_seg;
+		} else {
+			*seg_id = cache->cache_info.seg_id;
+		}
+	}
+	return 0;
+err:
+	return ret;
+}
+
+static int cache_segs_init(struct pcache_cache *cache)
+{
+	struct pcache_cache_segment *prev_cache_seg = NULL;
+	struct pcache_cache_info *cache_info = &cache->cache_info;
+	bool new_cache = !(cache->cache_info.flags & PCACHE_CACHE_FLAGS_INIT_DONE);
+	u32 seg_id;
+	int ret;
+	u32 i;
+
+	for (i = 0; i < cache_info->n_segs; i++) {
+		ret = get_seg_id(cache, prev_cache_seg, new_cache, &seg_id);
+		if (ret)
+			goto err;
+
+		ret = cache_seg_init(cache, seg_id, i, new_cache);
+		if (ret)
+			goto err;
+
+		prev_cache_seg = &cache->segments[i];
+	}
+	return 0;
+err:
+	return ret;
+}
+
+static int cache_init_req_keys(struct pcache_cache *cache, u32 n_paral)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	u32 n_subtrees;
+	int ret;
+	u32 i, cpu;
+
+	/* Calculate number of cache trees based on the device size */
+	n_subtrees = DIV_ROUND_UP(cache->dev_size << SECTOR_SHIFT, PCACHE_CACHE_SUBTREE_SIZE);
+	ret = cache_tree_init(cache, &cache->req_key_tree, n_subtrees);
+	if (ret)
+		goto err;
+
+	cache->n_ksets = n_paral;
+	cache->ksets = kvcalloc(cache->n_ksets, PCACHE_KSET_SIZE, GFP_KERNEL);
+	if (!cache->ksets) {
+		ret = -ENOMEM;
+		goto req_tree_exit;
+	}
+
+	/*
+	 * Initialize each kset with a spinlock and delayed work for flushing.
+	 * Each kset is associated with one queue to ensure independent handling
+	 * of cache keys across multiple queues, maximizing multiqueue concurrency.
+	 */
+	for (i = 0; i < cache->n_ksets; i++) {
+		struct pcache_cache_kset *kset = get_kset(cache, i);
+
+		kset->cache = cache;
+		spin_lock_init(&kset->kset_lock);
+		INIT_DELAYED_WORK(&kset->flush_work, kset_flush_fn);
+	}
+
+	cache->data_heads = alloc_percpu(struct pcache_cache_data_head);
+	if (!cache->data_heads) {
+		ret = -ENOMEM;
+		goto free_kset;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct pcache_cache_data_head *h =
+			per_cpu_ptr(cache->data_heads, cpu);
+		h->head_pos.cache_seg = NULL;
+	}
+
+	/*
+	 * Replay persisted cache keys using cache_replay.
+	 * This function loads and replays cache keys from previously stored
+	 * ksets, allowing the cache to restore its state after a restart.
+	 */
+	ret = cache_replay(cache);
+	if (ret) {
+		pcache_dev_err(pcache, "failed to replay keys\n");
+		goto free_heads;
+	}
+
+	return 0;
+
+free_heads:
+	free_percpu(cache->data_heads);
+free_kset:
+	kvfree(cache->ksets);
+req_tree_exit:
+	cache_tree_exit(&cache->req_key_tree);
+err:
+	return ret;
+}
+
+static void cache_destroy_req_keys(struct pcache_cache *cache)
+{
+	u32 i;
+
+	for (i = 0; i < cache->n_ksets; i++) {
+		struct pcache_cache_kset *kset = get_kset(cache, i);
+
+		cancel_delayed_work_sync(&kset->flush_work);
+	}
+
+	free_percpu(cache->data_heads);
+	kvfree(cache->ksets);
+	cache_tree_exit(&cache->req_key_tree);
+}
+
+int pcache_cache_start(struct dm_pcache *pcache)
+{
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	struct pcache_cache *cache = &pcache->cache;
+	struct pcache_cache_options *opts = &pcache->opts;
+	int ret;
+
+	ret = cache_init(pcache);
+	if (ret)
+		return ret;
+
+	cache->cache_info_addr = CACHE_DEV_CACHE_INFO(cache->cache_dev);
+	cache->cache_ctrl = CACHE_DEV_CACHE_CTRL(cache->cache_dev);
+	backing_dev->cache = cache;
+	cache->dev_size = backing_dev->dev_size;
+
+	ret = cache_info_init(cache, opts);
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_segs_init(cache);
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_tail_init(cache);
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_init_req_keys(cache, num_online_cpus());
+	if (ret)
+		goto cache_exit;
+
+	ret = cache_writeback_init(cache);
+	if (ret)
+		goto destroy_keys;
+
+	cache->cache_info.flags |= PCACHE_CACHE_FLAGS_INIT_DONE;
+	cache_info_write(cache);
+	queue_delayed_work(cache_get_wq(cache), &cache->gc_work, 0);
+
+	return 0;
+
+destroy_keys:
+	cache_destroy_req_keys(cache);
+cache_exit:
+	cache_exit(cache);
+
+	return ret;
+}
+
+void pcache_cache_stop(struct dm_pcache *pcache)
+{
+	struct pcache_cache *cache = &pcache->cache;
+
+	cache_flush(cache);
+
+	cancel_delayed_work_sync(&cache->gc_work);
+	flush_work(&cache->clean_work);
+	cache_writeback_exit(cache);
+
+	if (cache->req_key_tree.n_subtrees)
+		cache_destroy_req_keys(cache);
+
+	cache_exit(cache);
+}
+
+struct workqueue_struct *cache_get_wq(struct pcache_cache *cache)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+
+	return pcache->task_wq;
+}
+
+int pcache_cache_init(void)
+{
+	key_cache = KMEM_CACHE(pcache_cache_key, 0);
+	if (!key_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void pcache_cache_exit(void)
+{
+	kmem_cache_destroy(key_cache);
+}
diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
new file mode 100644
index 000000000000..b3b361cc406e
--- /dev/null
+++ b/drivers/md/dm-pcache/cache.h
@@ -0,0 +1,632 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_CACHE_H
+#define _PCACHE_CACHE_H
+
+#include "segment.h"
+
+/* Garbage collection thresholds */
+#define PCACHE_CACHE_GC_PERCENT_MIN       0                   /* Minimum GC percentage */
+#define PCACHE_CACHE_GC_PERCENT_MAX       90                  /* Maximum GC percentage */
+#define PCACHE_CACHE_GC_PERCENT_DEFAULT   70                  /* Default GC percentage */
+
+#define PCACHE_CACHE_SUBTREE_SIZE		(4 * PCACHE_MB)     /* 4MB total tree size */
+#define PCACHE_CACHE_SUBTREE_SIZE_MASK		0x3FFFFF            /* Mask for tree size */
+#define PCACHE_CACHE_SUBTREE_SIZE_SHIFT		22                  /* Bit shift for tree size */
+
+/* Maximum number of keys per key set */
+#define PCACHE_KSET_KEYS_MAX		128
+#define PCACHE_CACHE_SEGS_MAX		(1024 * 1024)	/* maximum cache size for each device is 16T */
+#define PCACHE_KSET_ONMEDIA_SIZE_MAX	struct_size_t(struct pcache_cache_kset_onmedia, data, PCACHE_KSET_KEYS_MAX)
+#define PCACHE_KSET_SIZE		(sizeof(struct pcache_cache_kset) + sizeof(struct pcache_cache_key_onmedia) * PCACHE_KSET_KEYS_MAX)
+
+/* Maximum number of keys to clean in one round of clean_work */
+#define PCACHE_CLEAN_KEYS_MAX             10
+
+/* Writeback and garbage collection intervals in jiffies */
+#define PCACHE_CACHE_WRITEBACK_INTERVAL   (5 * HZ)
+#define PCACHE_CACHE_GC_INTERVAL          (5 * HZ)
+
+/* Macro to get the cache key structure from an rb_node pointer */
+#define CACHE_KEY(node)                (container_of(node, struct pcache_cache_key, rb_node))
+
+struct pcache_cache_pos_onmedia {
+	struct pcache_meta_header header;
+	__u32 cache_seg_id;
+	__u32 seg_off;
+};
+
+/* Offset and size definitions for cache segment control */
+#define PCACHE_CACHE_SEG_CTRL_OFF     (PCACHE_SEG_INFO_SIZE * PCACHE_META_INDEX_MAX)
+#define PCACHE_CACHE_SEG_CTRL_SIZE    (4 * PCACHE_KB)
+
+struct pcache_cache_seg_gen {
+	struct pcache_meta_header header;
+	__u64 gen;
+};
+
+/* Control structure for cache segments */
+struct pcache_cache_seg_ctrl {
+	struct pcache_cache_seg_gen gen[PCACHE_META_INDEX_MAX];
+	__u64	res[64];
+};
+
+#define PCACHE_CACHE_FLAGS_DATA_CRC			BIT(0)
+#define PCACHE_CACHE_FLAGS_INIT_DONE			BIT(1)
+
+#define PCACHE_CACHE_FLAGS_CACHE_MODE_MASK		GENMASK(5, 2)
+#define PCACHE_CACHE_MODE_WRITEBACK			0
+#define PCACHE_CACHE_MODE_WRITETHROUGH			1
+#define PCACHE_CACHE_MODE_WRITEAROUND			2
+#define PCACHE_CACHE_MODE_WRITEONLY			3
+
+#define PCACHE_CACHE_FLAGS_GC_PERCENT_MASK		GENMASK(12, 6)
+
+struct pcache_cache_info {
+	struct pcache_meta_header header;
+	__u32 seg_id;
+	__u32 n_segs;
+	__u32 flags;
+	__u32 reserved;
+};
+
+struct pcache_cache_pos {
+	struct pcache_cache_segment *cache_seg;
+	u32 seg_off;
+};
+
+struct pcache_cache_segment {
+	struct pcache_cache	*cache;
+	u32			cache_seg_id;   /* Index in cache->segments */
+	struct pcache_segment	segment;
+	atomic_t		refs;
+
+	struct pcache_segment_info cache_seg_info;
+	struct mutex		info_lock;
+	u32			info_index;
+
+	spinlock_t		gen_lock;
+	u64			gen;
+	u64			gen_seq;
+	u32			gen_index;
+
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl;
+	struct mutex		ctrl_lock;
+};
+
+/* rbtree for cache entries */
+struct pcache_cache_subtree {
+	struct rb_root root;
+	spinlock_t tree_lock;
+};
+
+struct pcache_cache_tree {
+	struct pcache_cache		*cache;
+	u32				n_subtrees;
+	mempool_t			key_pool;
+	struct pcache_cache_subtree	*subtrees;
+};
+
+extern struct kmem_cache *key_cache;
+
+struct pcache_cache_key {
+	struct pcache_cache_tree	*cache_tree;
+	struct pcache_cache_subtree	*cache_subtree;
+	struct kref			ref;
+	struct rb_node			rb_node;
+	struct list_head		list_node;
+	u64				off;
+	u32				len;
+	u32				flags;
+	struct pcache_cache_pos		cache_pos;
+	u64				seg_gen;
+};
+
+#define PCACHE_CACHE_KEY_FLAGS_EMPTY		BIT(0)
+#define PCACHE_CACHE_KEY_FLAGS_CLEAN		BIT(1)
+
+struct pcache_cache_key_onmedia {
+	__u64 off;
+	__u32 len;
+	__u32 flags;
+	__u32 cache_seg_id;
+	__u32 cache_seg_off;
+	__u64 seg_gen;
+	__u32 data_crc;
+	__u32 reserved;
+};
+
+struct pcache_cache_kset_onmedia {
+	__u32 crc;
+	union {
+		__u32 key_num;
+		__u32 next_cache_seg_id;
+	};
+	__u64 magic;
+	__u64 flags;
+	struct pcache_cache_key_onmedia data[];
+};
+
+struct pcache_cache {
+	struct pcache_backing_dev	*backing_dev;
+	struct pcache_cache_dev		*cache_dev;
+	struct pcache_cache_ctrl	*cache_ctrl;
+	u64				dev_size;
+
+	struct pcache_cache_data_head __percpu *data_heads;
+
+	spinlock_t		key_head_lock;
+	struct pcache_cache_pos	key_head;
+	u32			n_ksets;
+	struct pcache_cache_kset	*ksets;
+
+	struct mutex		key_tail_lock;
+	struct pcache_cache_pos	key_tail;
+	u64			key_tail_seq;
+	u32			key_tail_index;
+
+	struct mutex		dirty_tail_lock;
+	struct pcache_cache_pos	dirty_tail;
+	u64			dirty_tail_seq;
+	u32			dirty_tail_index;
+
+	struct pcache_cache_tree	req_key_tree;
+	struct work_struct	clean_work;
+
+	struct mutex		writeback_lock;
+	char wb_kset_onmedia_buf[PCACHE_KSET_ONMEDIA_SIZE_MAX];
+	struct pcache_cache_tree	writeback_key_tree;
+	struct delayed_work	writeback_work;
+	struct {
+		atomic_t pending;
+		u32 advance;
+		int ret;
+	} writeback_ctx;
+
+	char gc_kset_onmedia_buf[PCACHE_KSET_ONMEDIA_SIZE_MAX];
+	struct delayed_work	gc_work;
+	atomic_t		gc_errors;
+
+	struct mutex			cache_info_lock;
+	struct pcache_cache_info	cache_info;
+	struct pcache_cache_info	*cache_info_addr;
+	u32				info_index;
+
+	u32			n_segs;
+	unsigned long		*seg_map;
+	u32			last_cache_seg;
+	bool			cache_full;
+	spinlock_t		seg_map_lock;
+	struct pcache_cache_segment *segments;
+};
+
+struct workqueue_struct *cache_get_wq(struct pcache_cache *cache);
+
+struct dm_pcache;
+struct pcache_cache_options {
+	u32	cache_mode:4;
+	u32	data_crc:1;
+};
+int pcache_cache_start(struct dm_pcache *pcache);
+void pcache_cache_stop(struct dm_pcache *pcache);
+
+struct pcache_cache_ctrl {
+	/* Updated by gc_thread */
+	struct pcache_cache_pos_onmedia key_tail_pos[PCACHE_META_INDEX_MAX];
+
+	/* Updated by writeback_thread */
+	struct pcache_cache_pos_onmedia dirty_tail_pos[PCACHE_META_INDEX_MAX];
+};
+
+struct pcache_cache_data_head {
+	struct pcache_cache_pos head_pos;
+};
+
+static inline u16 pcache_cache_get_gc_percent(struct pcache_cache *cache)
+{
+	return FIELD_GET(PCACHE_CACHE_FLAGS_GC_PERCENT_MASK, cache->cache_info.flags);
+}
+
+int pcache_cache_set_gc_percent(struct pcache_cache *cache, u8 percent);
+
+/* cache key */
+struct pcache_cache_key *cache_key_alloc(struct pcache_cache_tree *cache_tree, gfp_t gfp_mask);
+void cache_key_init(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key);
+void cache_key_get(struct pcache_cache_key *key);
+void cache_key_put(struct pcache_cache_key *key);
+int cache_key_append(struct pcache_cache *cache, struct pcache_cache_key *key, bool force_close);
+void cache_key_insert(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key, bool fixup);
+int cache_key_decode(struct pcache_cache *cache,
+			struct pcache_cache_key_onmedia *key_onmedia,
+			struct pcache_cache_key *key);
+void cache_pos_advance(struct pcache_cache_pos *pos, u32 len);
+
+#define PCACHE_KSET_FLAGS_LAST		BIT(0)
+#define PCACHE_KSET_MAGIC		0x676894a64e164f1aULL
+
+struct pcache_cache_kset {
+	struct pcache_cache *cache;
+	spinlock_t        kset_lock;
+	struct delayed_work flush_work;
+	struct pcache_cache_kset_onmedia kset_onmedia;
+};
+
+extern struct pcache_cache_kset_onmedia pcache_empty_kset;
+
+#define SUBTREE_WALK_RET_OK		0
+#define SUBTREE_WALK_RET_ERR		1
+#define SUBTREE_WALK_RET_NEED_KEY	2
+#define SUBTREE_WALK_RET_NEED_REQ	3
+#define SUBTREE_WALK_RET_RESEARCH	4
+
+struct pcache_cache_subtree_walk_ctx {
+	struct pcache_cache_tree *cache_tree;
+	struct rb_node *start_node;
+	struct pcache_request *pcache_req;
+	struct pcache_cache_key *key;
+	u32	req_done;
+	int	ret;
+
+	/* pre-allocated key and backing_dev_req */
+	struct pcache_cache_key		*pre_alloc_key;
+	struct pcache_backing_dev_req	*pre_alloc_req;
+
+	struct list_head *delete_key_list;
+	struct list_head *submit_req_list;
+
+	/*
+	 *	  |--------|		key_tmp
+	 * |====|			key
+	 */
+	int (*before)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |----------|			key_tmp
+	 *		|=====|		key
+	 */
+	int (*after)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *     |----------------|	key_tmp
+	 * |===========|		key
+	 */
+	int (*overlap_tail)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |--------|			key_tmp
+	 *   |==========|		key
+	 */
+	int (*overlap_head)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *    |----|			key_tmp
+	 * |==========|			key
+	 */
+	int (*overlap_contain)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |-----------|		key_tmp
+	 *   |====|			key
+	 */
+	int (*overlap_contained)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	int (*walk_finally)(struct pcache_cache_subtree_walk_ctx *ctx, int ret);
+	bool (*walk_done)(struct pcache_cache_subtree_walk_ctx *ctx);
+};
+
+int cache_subtree_walk(struct pcache_cache_subtree_walk_ctx *ctx);
+struct rb_node *cache_subtree_search(struct pcache_cache_subtree *cache_subtree, struct pcache_cache_key *key,
+				  struct rb_node **parentp, struct rb_node ***newp,
+				  struct list_head *delete_key_list);
+int cache_kset_close(struct pcache_cache *cache, struct pcache_cache_kset *kset);
+void clean_fn(struct work_struct *work);
+void kset_flush_fn(struct work_struct *work);
+int cache_replay(struct pcache_cache *cache);
+int cache_tree_init(struct pcache_cache *cache, struct pcache_cache_tree *cache_tree, u32 n_subtrees);
+void cache_tree_clear(struct pcache_cache_tree *cache_tree);
+void cache_tree_exit(struct pcache_cache_tree *cache_tree);
+
+/* cache segments */
+struct pcache_cache_segment *get_cache_segment(struct pcache_cache *cache);
+int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache);
+void cache_seg_get(struct pcache_cache_segment *cache_seg);
+void cache_seg_put(struct pcache_cache_segment *cache_seg);
+void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id);
+
+/* cache request*/
+int cache_flush(struct pcache_cache *cache);
+void miss_read_end_work_fn(struct work_struct *work);
+int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req);
+
+/* gc */
+void pcache_cache_gc_fn(struct work_struct *work);
+
+/* writeback */
+void cache_writeback_exit(struct pcache_cache *cache);
+int cache_writeback_init(struct pcache_cache *cache);
+void cache_writeback_fn(struct work_struct *work);
+
+/* inline functions */
+static inline struct pcache_cache_subtree *get_subtree(struct pcache_cache_tree *cache_tree, u64 off)
+{
+	if (cache_tree->n_subtrees == 1)
+		return &cache_tree->subtrees[0];
+
+	return &cache_tree->subtrees[off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT];
+}
+
+static inline void *cache_pos_addr(struct pcache_cache_pos *pos)
+{
+	return (pos->cache_seg->segment.data + pos->seg_off);
+}
+
+static inline void *get_key_head_addr(struct pcache_cache *cache)
+{
+	return cache_pos_addr(&cache->key_head);
+}
+
+static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
+{
+	return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
+}
+
+static inline struct pcache_cache_kset *get_kset(struct pcache_cache *cache, u32 kset_id)
+{
+	return (void *)cache->ksets + PCACHE_KSET_SIZE * kset_id;
+}
+
+static inline struct pcache_cache_data_head *get_data_head(struct pcache_cache *cache)
+{
+	return this_cpu_ptr(cache->data_heads);
+}
+
+static inline bool cache_key_empty(struct pcache_cache_key *key)
+{
+	return key->flags & PCACHE_CACHE_KEY_FLAGS_EMPTY;
+}
+
+static inline bool cache_key_clean(struct pcache_cache_key *key)
+{
+	return key->flags & PCACHE_CACHE_KEY_FLAGS_CLEAN;
+}
+
+static inline void cache_pos_copy(struct pcache_cache_pos *dst, struct pcache_cache_pos *src)
+{
+	memcpy(dst, src, sizeof(struct pcache_cache_pos));
+}
+
+/**
+ * cache_seg_is_ctrl_seg - Checks if a cache segment is a cache ctrl segment.
+ * @cache_seg_id: ID of the cache segment.
+ *
+ * Returns true if the cache segment ID corresponds to a cache ctrl segment.
+ *
+ * Note: We extend the segment control of the first cache segment
+ * (cache segment ID 0) to serve as the cache control (pcache_cache_ctrl)
+ * for the entire PCACHE cache. This function determines whether the given
+ * cache segment is the one storing the pcache_cache_ctrl information.
+ */
+static inline bool cache_seg_is_ctrl_seg(u32 cache_seg_id)
+{
+	return (cache_seg_id == 0);
+}
+
+/**
+ * cache_key_cutfront - Cuts a specified length from the front of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ * @cut_len: Length to cut from the front.
+ *
+ * Advances the cache key position by cut_len and adjusts offset and length accordingly.
+ */
+static inline void cache_key_cutfront(struct pcache_cache_key *key, u32 cut_len)
+{
+	if (key->cache_pos.cache_seg)
+		cache_pos_advance(&key->cache_pos, cut_len);
+
+	key->off += cut_len;
+	key->len -= cut_len;
+}
+
+/**
+ * cache_key_cutback - Cuts a specified length from the back of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ * @cut_len: Length to cut from the back.
+ *
+ * Reduces the length of the cache key by cut_len.
+ */
+static inline void cache_key_cutback(struct pcache_cache_key *key, u32 cut_len)
+{
+	key->len -= cut_len;
+}
+
+static inline void cache_key_delete(struct pcache_cache_key *key)
+{
+	struct pcache_cache_subtree *cache_subtree;
+
+	cache_subtree = key->cache_subtree;
+	BUG_ON(!cache_subtree);
+
+	rb_erase(&key->rb_node, &cache_subtree->root);
+	key->flags = 0;
+	cache_key_put(key);
+}
+
+static inline bool cache_data_crc_on(struct pcache_cache *cache)
+{
+	return (cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC);
+}
+
+static inline u32 cache_mode_get(struct pcache_cache *cache)
+{
+	return FIELD_GET(PCACHE_CACHE_FLAGS_CACHE_MODE_MASK, cache->cache_info.flags);
+}
+
+static inline void cache_mode_set(struct pcache_cache *cache, u32 cache_mode)
+{
+	cache->cache_info.flags &= ~PCACHE_CACHE_FLAGS_CACHE_MODE_MASK;
+	cache->cache_info.flags |= FIELD_PREP(PCACHE_CACHE_FLAGS_CACHE_MODE_MASK, cache_mode);
+}
+
+/**
+ * cache_key_data_crc - Calculates CRC for data in a cache key.
+ * @key: Pointer to the pcache_cache_key structure.
+ *
+ * Returns the CRC-32 checksum of the data within the cache key's position.
+ */
+static inline u32 cache_key_data_crc(struct pcache_cache_key *key)
+{
+	void *data;
+
+	data = cache_pos_addr(&key->cache_pos);
+
+	return crc32c(PCACHE_CRC_SEED, data, key->len);
+}
+
+static inline u32 cache_kset_crc(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	u32 crc_size;
+
+	if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST)
+		crc_size = sizeof(struct pcache_cache_kset_onmedia) - 4;
+	else
+		crc_size = struct_size(kset_onmedia, data, kset_onmedia->key_num) - 4;
+
+	return crc32c(PCACHE_CRC_SEED, (void *)kset_onmedia + 4, crc_size);
+}
+
+static inline u32 get_kset_onmedia_size(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	return struct_size_t(struct pcache_cache_kset_onmedia, data, kset_onmedia->key_num);
+}
+
+/**
+ * cache_seg_remain - Computes remaining space in a cache segment.
+ * @pos: Pointer to pcache_cache_pos structure.
+ *
+ * Returns the amount of remaining space in the segment data starting from
+ * the current position offset.
+ */
+static inline u32 cache_seg_remain(struct pcache_cache_pos *pos)
+{
+	struct pcache_cache_segment *cache_seg;
+	struct pcache_segment *segment;
+	u32 seg_remain;
+
+	cache_seg = pos->cache_seg;
+	segment = &cache_seg->segment;
+	seg_remain = segment->data_size - pos->seg_off;
+
+	return seg_remain;
+}
+
+/**
+ * cache_key_invalid - Checks if a cache key is invalid.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns true if the cache key is invalid due to its generation being
+ * less than the generation of its segment; otherwise returns false.
+ *
+ * When the GC (garbage collection) thread identifies a segment
+ * as reclaimable, it increments the segment's generation (gen). However,
+ * it does not immediately remove all related cache keys. When accessing
+ * such a cache key, this function can be used to determine if the cache
+ * key has already become invalid.
+ */
+static inline bool cache_key_invalid(struct pcache_cache_key *key)
+{
+	if (cache_key_empty(key))
+		return false;
+
+	return (key->seg_gen < key->cache_pos.cache_seg->gen);
+}
+
+/**
+ * cache_key_lstart - Retrieves the logical start offset of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns the logical start offset for the cache key.
+ */
+static inline u64 cache_key_lstart(struct pcache_cache_key *key)
+{
+	return key->off;
+}
+
+/**
+ * cache_key_lend - Retrieves the logical end offset of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns the logical end offset for the cache key.
+ */
+static inline u64 cache_key_lend(struct pcache_cache_key *key)
+{
+	return key->off + key->len;
+}
+
+static inline void cache_key_copy(struct pcache_cache_key *key_dst, struct pcache_cache_key *key_src)
+{
+	key_dst->off = key_src->off;
+	key_dst->len = key_src->len;
+	key_dst->seg_gen = key_src->seg_gen;
+	key_dst->cache_tree = key_src->cache_tree;
+	key_dst->cache_subtree = key_src->cache_subtree;
+	key_dst->flags = key_src->flags;
+
+	cache_pos_copy(&key_dst->cache_pos, &key_src->cache_pos);
+}
+
+/**
+ * cache_pos_onmedia_crc - Calculates the CRC for an on-media cache position.
+ * @pos_om: Pointer to pcache_cache_pos_onmedia structure.
+ *
+ * Calculates the CRC-32 checksum of the position, excluding the first 4 bytes.
+ * Returns the computed CRC value.
+ */
+static inline u32 cache_pos_onmedia_crc(struct pcache_cache_pos_onmedia *pos_om)
+{
+	return pcache_meta_crc(&pos_om->header, sizeof(struct pcache_cache_pos_onmedia));
+}
+
+void cache_pos_encode(struct pcache_cache *cache,
+			     struct pcache_cache_pos_onmedia *pos_onmedia,
+			     struct pcache_cache_pos *pos, u64 seq, u32 *index);
+int cache_pos_decode(struct pcache_cache *cache,
+			    struct pcache_cache_pos_onmedia *pos_onmedia,
+			    struct pcache_cache_pos *pos, u64 *seq, u32 *index);
+
+static inline void cache_encode_key_tail(struct pcache_cache *cache)
+{
+	cache_pos_encode(cache, cache->cache_ctrl->key_tail_pos,
+			&cache->key_tail, ++cache->key_tail_seq,
+			&cache->key_tail_index);
+}
+
+static inline int cache_decode_key_tail(struct pcache_cache *cache)
+{
+	return cache_pos_decode(cache, cache->cache_ctrl->key_tail_pos,
+				&cache->key_tail, &cache->key_tail_seq,
+				&cache->key_tail_index);
+}
+
+static inline void cache_encode_dirty_tail(struct pcache_cache *cache)
+{
+	cache_pos_encode(cache, cache->cache_ctrl->dirty_tail_pos,
+			&cache->dirty_tail, ++cache->dirty_tail_seq,
+			&cache->dirty_tail_index);
+}
+
+static inline int cache_decode_dirty_tail(struct pcache_cache *cache)
+{
+	return cache_pos_decode(cache, cache->cache_ctrl->dirty_tail_pos,
+				&cache->dirty_tail, &cache->dirty_tail_seq,
+				&cache->dirty_tail_index);
+}
+
+int pcache_cache_init(void);
+void pcache_cache_exit(void);
+#endif /* _PCACHE_CACHE_H */
diff --git a/drivers/md/dm-pcache/cache_dev.c b/drivers/md/dm-pcache/cache_dev.c
new file mode 100644
index 000000000000..cc138b99137d
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_dev.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/blkdev.h>
+#include <linux/dax.h>
+#include <linux/vmalloc.h>
+#include <linux/pfn_t.h>
+#include <linux/parser.h>
+
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "cache.h"
+#include "dm_pcache.h"
+
+static void cache_dev_dax_exit(struct pcache_cache_dev *cache_dev)
+{
+	if (cache_dev->use_vmap)
+		vunmap(cache_dev->mapping);
+}
+
+static int build_vmap(struct dax_device *dax_dev, long total_pages, void **vaddr)
+{
+	struct page **pages;
+	long i = 0, chunk;
+	pfn_t pfn;
+	int ret;
+
+	pages = vmalloc_array(total_pages, sizeof(struct page *));
+	if (!pages)
+		return -ENOMEM;
+
+	do {
+		chunk = dax_direct_access(dax_dev, i, total_pages - i,
+					  DAX_ACCESS, NULL, &pfn);
+		if (chunk <= 0) {
+			ret = chunk ? chunk : -EINVAL;
+			goto out_free;
+		}
+
+		if (!pfn_t_has_page(pfn)) {
+			ret = -EOPNOTSUPP;
+			goto out_free;
+		}
+
+		while (chunk-- && i < total_pages) {
+			pages[i++] = pfn_t_to_page(pfn);
+			pfn.val++;
+			if (!(i & 15))
+				cond_resched();
+		}
+	} while (i < total_pages);
+
+	*vaddr = vmap(pages, total_pages, VM_MAP, PAGE_KERNEL);
+	if (!*vaddr)
+		ret = -ENOMEM;
+out_free:
+	vfree(pages);
+	return ret;
+}
+
+static int cache_dev_dax_init(struct pcache_cache_dev *cache_dev)
+{
+	struct dm_pcache	*pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	struct dax_device	*dax_dev;
+	long			total_pages, mapped_pages;
+	u64			bdev_size;
+	void			*vaddr;
+	int			ret;
+	int			id;
+	pfn_t			pfn;
+
+	dax_dev	= cache_dev->dm_dev->dax_dev;
+	/* total size check */
+	bdev_size = bdev_nr_bytes(cache_dev->dm_dev->bdev);
+	if (bdev_size < PCACHE_CACHE_DEV_SIZE_MIN) {
+		pcache_dev_err(pcache, "dax device is too small, required at least %llu",
+				PCACHE_CACHE_DEV_SIZE_MIN);
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	total_pages = bdev_size >> PAGE_SHIFT;
+	/* attempt: direct-map the whole range */
+	id = dax_read_lock();
+	mapped_pages = dax_direct_access(dax_dev, 0, total_pages,
+					 DAX_ACCESS, &vaddr, &pfn);
+	if (mapped_pages < 0) {
+		pcache_dev_err(pcache, "dax_direct_access failed: %ld\n", mapped_pages);
+		ret = mapped_pages;
+		goto unlock;
+	}
+
+	if (!pfn_t_has_page(pfn)) {
+		ret = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if (mapped_pages == total_pages) {
+		/* success: contiguous direct mapping */
+		cache_dev->mapping = vaddr;
+	} else {
+		/* need vmap fallback */
+		ret = build_vmap(dax_dev, total_pages, &vaddr);
+		if (ret) {
+			pcache_dev_err(pcache, "vmap fallback failed: %d\n", ret);
+			goto unlock;
+		}
+
+		cache_dev->mapping	= vaddr;
+		cache_dev->use_vmap	= true;
+	}
+	dax_read_unlock(id);
+
+	return 0;
+unlock:
+	dax_read_unlock(id);
+out:
+	return ret;
+}
+
+void cache_dev_zero_range(struct pcache_cache_dev *cache_dev, void *pos, u32 size)
+{
+	memset(pos, 0, size);
+	dax_flush(cache_dev->dm_dev->dax_dev, pos, size);
+}
+
+static int sb_read(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct pcache_sb *sb_addr = CACHE_DEV_SB(cache_dev);
+
+	if (copy_mc_to_kernel(sb, sb_addr, sizeof(struct pcache_sb)))
+		return -EIO;
+
+	return 0;
+}
+
+static void sb_write(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct pcache_sb *sb_addr = CACHE_DEV_SB(cache_dev);
+
+	memcpy_flushcache(sb_addr, sb, sizeof(struct pcache_sb));
+	pmem_wmb();
+}
+
+static int sb_init(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct dm_pcache *pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	u64 nr_segs;
+	u64 cache_dev_size;
+	u64 magic;
+	u32 flags = 0;
+
+	magic = le64_to_cpu(sb->magic);
+	if (magic)
+		return -EEXIST;
+
+	cache_dev_size = bdev_nr_bytes(file_bdev(cache_dev->dm_dev->bdev_file));
+	if (cache_dev_size < PCACHE_CACHE_DEV_SIZE_MIN) {
+		pcache_dev_err(pcache, "dax device is too small, required at least %llu",
+				PCACHE_CACHE_DEV_SIZE_MIN);
+		return -ENOSPC;
+	}
+
+	nr_segs = (cache_dev_size - PCACHE_SEGMENTS_OFF) / ((PCACHE_SEG_SIZE));
+
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	flags |= PCACHE_SB_F_BIGENDIAN;
+#endif
+	sb->flags = cpu_to_le32(flags);
+	sb->magic = cpu_to_le64(PCACHE_MAGIC);
+	sb->seg_num = cpu_to_le32(nr_segs);
+	sb->crc = cpu_to_le32(crc32c(PCACHE_CRC_SEED, (void *)(sb) + 4, sizeof(struct pcache_sb) - 4));
+
+	cache_dev_zero_range(cache_dev, CACHE_DEV_CACHE_INFO(cache_dev),
+			     PCACHE_CACHE_INFO_SIZE * PCACHE_META_INDEX_MAX +
+			     PCACHE_CACHE_CTRL_SIZE);
+
+	return 0;
+}
+
+static int sb_validate(struct pcache_cache_dev *cache_dev, struct pcache_sb *sb)
+{
+	struct dm_pcache *pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	u32 flags;
+	u32 crc;
+
+	if (le64_to_cpu(sb->magic) != PCACHE_MAGIC) {
+		pcache_dev_err(pcache, "unexpected magic: %llx\n",
+				le64_to_cpu(sb->magic));
+		return -EINVAL;
+	}
+
+	crc = crc32c(PCACHE_CRC_SEED, (void *)(sb) + 4, sizeof(struct pcache_sb) - 4);
+	if (crc != le32_to_cpu(sb->crc)) {
+		pcache_dev_err(pcache, "corrupted sb: %u, expected: %u\n", crc, le32_to_cpu(sb->crc));
+		return -EINVAL;
+	}
+
+	flags = le32_to_cpu(sb->flags);
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	if (!(flags & PCACHE_SB_F_BIGENDIAN)) {
+		pcache_dev_err(pcache, "cache_dev is not big endian\n");
+		return -EINVAL;
+	}
+#else
+	if (flags & PCACHE_SB_F_BIGENDIAN) {
+		pcache_dev_err(pcache, "cache_dev is big endian\n");
+		return -EINVAL;
+	}
+#endif
+	return 0;
+}
+
+static int cache_dev_init(struct pcache_cache_dev *cache_dev, u32 seg_num)
+{
+	cache_dev->seg_num = seg_num;
+	cache_dev->seg_bitmap = kvcalloc(BITS_TO_LONGS(cache_dev->seg_num), sizeof(unsigned long), GFP_KERNEL);
+	if (!cache_dev->seg_bitmap)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void cache_dev_exit(struct pcache_cache_dev *cache_dev)
+{
+	kvfree(cache_dev->seg_bitmap);
+}
+
+void cache_dev_stop(struct dm_pcache *pcache)
+{
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+
+	cache_dev_exit(cache_dev);
+	cache_dev_dax_exit(cache_dev);
+}
+
+int cache_dev_start(struct dm_pcache *pcache)
+{
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+	struct pcache_sb sb;
+	bool format = false;
+	int ret;
+
+	mutex_init(&cache_dev->seg_lock);
+
+	ret = cache_dev_dax_init(cache_dev);
+	if (ret) {
+		pcache_dev_err(pcache, "failed to init cache_dev %s via dax way: %d.",
+			       cache_dev->dm_dev->name, ret);
+		goto err;
+	}
+
+	ret = sb_read(cache_dev, &sb);
+	if (ret)
+		goto dax_release;
+
+	if (le64_to_cpu(sb.magic) == 0) {
+		format = true;
+		ret = sb_init(cache_dev, &sb);
+		if (ret < 0)
+			goto dax_release;
+	}
+
+	ret = sb_validate(cache_dev, &sb);
+	if (ret)
+		goto dax_release;
+
+	cache_dev->sb_flags = le32_to_cpu(sb.flags);
+	ret = cache_dev_init(cache_dev, le32_to_cpu(sb.seg_num));
+	if (ret)
+		goto dax_release;
+
+	if (format)
+		sb_write(cache_dev, &sb);
+
+	return 0;
+
+dax_release:
+	cache_dev_dax_exit(cache_dev);
+err:
+	return ret;
+}
+
+int cache_dev_get_empty_segment_id(struct pcache_cache_dev *cache_dev, u32 *seg_id)
+{
+	int ret;
+
+	mutex_lock(&cache_dev->seg_lock);
+	*seg_id = find_next_zero_bit(cache_dev->seg_bitmap, cache_dev->seg_num, 0);
+	if (*seg_id == cache_dev->seg_num) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
+
+	__set_bit(*seg_id, cache_dev->seg_bitmap);
+	ret = 0;
+unlock:
+	mutex_unlock(&cache_dev->seg_lock);
+	return ret;
+}
diff --git a/drivers/md/dm-pcache/cache_dev.h b/drivers/md/dm-pcache/cache_dev.h
new file mode 100644
index 000000000000..6251eb4ebe96
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_dev.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_CACHE_DEV_H
+#define _PCACHE_CACHE_DEV_H
+
+#include <linux/device.h>
+#include <linux/device-mapper.h>
+
+#include "pcache_internal.h"
+
+#define PCACHE_MAGIC				0x65B05EFA96C596EFULL
+
+#define PCACHE_SB_OFF				(4 * PCACHE_KB)
+#define PCACHE_SB_SIZE				(4 * PCACHE_KB)
+
+#define PCACHE_CACHE_INFO_OFF			(PCACHE_SB_OFF + PCACHE_SB_SIZE)
+#define PCACHE_CACHE_INFO_SIZE			(4 * PCACHE_KB)
+
+#define PCACHE_CACHE_CTRL_OFF			(PCACHE_CACHE_INFO_OFF + (PCACHE_CACHE_INFO_SIZE * PCACHE_META_INDEX_MAX))
+#define PCACHE_CACHE_CTRL_SIZE			(4 * PCACHE_KB)
+
+#define PCACHE_SEGMENTS_OFF			(PCACHE_CACHE_CTRL_OFF + PCACHE_CACHE_CTRL_SIZE)
+#define PCACHE_SEG_INFO_SIZE			(4 * PCACHE_KB)
+
+#define PCACHE_CACHE_DEV_SIZE_MIN		(512 * PCACHE_MB)	/* 512 MB */
+#define PCACHE_SEG_SIZE				(16 * PCACHE_MB)	/* Size of each PCACHE segment (16 MB) */
+
+#define CACHE_DEV_SB(cache_dev)			((struct pcache_sb *)(cache_dev->mapping + PCACHE_SB_OFF))
+#define CACHE_DEV_CACHE_INFO(cache_dev)		((void *)cache_dev->mapping + PCACHE_CACHE_INFO_OFF)
+#define CACHE_DEV_CACHE_CTRL(cache_dev)		((void *)cache_dev->mapping + PCACHE_CACHE_CTRL_OFF)
+#define CACHE_DEV_SEGMENTS(cache_dev)		((void *)cache_dev->mapping + PCACHE_SEGMENTS_OFF)
+#define CACHE_DEV_SEGMENT(cache_dev, id)	((void *)CACHE_DEV_SEGMENTS(cache_dev) + (u64)id * PCACHE_SEG_SIZE)
+
+/*
+ * PCACHE SB flags configured during formatting
+ *
+ * The PCACHE_SB_F_xxx flags define registration requirements based on cache_dev
+ * formatting. For a machine to register a cache_dev:
+ * - PCACHE_SB_F_BIGENDIAN: Requires a big-endian machine.
+ */
+#define PCACHE_SB_F_BIGENDIAN			BIT(0)
+
+struct pcache_sb {
+	__le32 crc;
+	__le32 flags;
+	__le64 magic;
+
+	__le32 seg_num;
+};
+
+struct pcache_cache_dev {
+	u32				sb_flags;
+	u32				seg_num;
+	void				*mapping;
+	bool				use_vmap;
+
+	struct dm_dev			*dm_dev;
+
+	struct mutex			seg_lock;
+	unsigned long			*seg_bitmap;
+};
+
+struct dm_pcache;
+int cache_dev_start(struct dm_pcache *pcache);
+void cache_dev_stop(struct dm_pcache *pcache);
+
+void cache_dev_zero_range(struct pcache_cache_dev *cache_dev, void *pos, u32 size);
+
+int cache_dev_get_empty_segment_id(struct pcache_cache_dev *cache_dev, u32 *seg_id);
+
+#endif /* _PCACHE_CACHE_DEV_H */
diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
new file mode 100644
index 000000000000..94f8b276a021
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "cache.h"
+#include "backing_dev.h"
+#include "cache_dev.h"
+#include "dm_pcache.h"
+
+/**
+ * cache_key_gc - Releases the reference of a cache key segment.
+ * @cache: Pointer to the pcache_cache structure.
+ * @key: Pointer to the cache key to be garbage collected.
+ *
+ * This function decrements the reference count of the cache segment
+ * associated with the given key. If the reference count drops to zero,
+ * the segment may be invalidated and reused.
+ */
+static void cache_key_gc(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	cache_seg_put(key->cache_pos.cache_seg);
+}
+
+static bool need_gc(struct pcache_cache *cache, struct pcache_cache_pos *dirty_tail, struct pcache_cache_pos *key_tail)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	void *dirty_addr, *key_addr;
+	u32 segs_used, segs_gc_threshold, to_copy;
+	int ret;
+
+	dirty_addr = cache_pos_addr(dirty_tail);
+	key_addr = cache_pos_addr(key_tail);
+	if (dirty_addr == key_addr) {
+		pcache_dev_debug(pcache, "key tail is equal to dirty tail: %u:%u\n",
+				dirty_tail->cache_seg->cache_seg_id,
+				dirty_tail->seg_off);
+		return false;
+	}
+
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->gc_kset_onmedia_buf;
+
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - key_tail->seg_off);
+	ret = copy_mc_to_kernel(kset_onmedia, key_addr, to_copy);
+	if (ret) {
+		pcache_dev_err(pcache, "error to read kset: %d", ret);
+		return false;
+	}
+
+	/* Check if kset_onmedia is corrupted */
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
+		pcache_dev_debug(pcache, "gc error: magic is not as expected. key_tail: %u:%u magic: %llx, expected: %llx\n",
+					key_tail->cache_seg->cache_seg_id, key_tail->seg_off,
+					kset_onmedia->magic, PCACHE_KSET_MAGIC);
+		return false;
+	}
+
+	/* Verify the CRC of the kset_onmedia */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		pcache_dev_debug(pcache, "gc error: crc is not as expected. crc: %x, expected: %x\n",
+					cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return false;
+	}
+
+	segs_used = bitmap_weight(cache->seg_map, cache->n_segs);
+	segs_gc_threshold = cache->n_segs * pcache_cache_get_gc_percent(cache) / 100;
+	if (segs_used < segs_gc_threshold) {
+		pcache_dev_debug(pcache, "segs_used: %u, segs_gc_threshold: %u\n", segs_used, segs_gc_threshold);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * last_kset_gc - Advances the garbage collection for the last kset.
+ * @cache: Pointer to the pcache_cache structure.
+ * @kset_onmedia: Pointer to the kset_onmedia structure for the last kset.
+ */
+static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_segment *cur_seg, *next_seg;
+
+	cur_seg = cache->key_tail.cache_seg;
+
+	next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
+
+	mutex_lock(&cache->key_tail_lock);
+	cache->key_tail.cache_seg = next_seg;
+	cache->key_tail.seg_off = 0;
+	cache_encode_key_tail(cache);
+	mutex_unlock(&cache->key_tail_lock);
+
+	pcache_dev_debug(pcache, "gc advance kset seg: %u\n", cur_seg->cache_seg_id);
+
+	spin_lock(&cache->seg_map_lock);
+	__clear_bit(cur_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+}
+
+void pcache_cache_gc_fn(struct work_struct *work)
+{
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, gc_work.work);
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_pos dirty_tail, key_tail;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_key *key;
+	int ret;
+	int i;
+
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->gc_kset_onmedia_buf;
+
+	while (true) {
+		if (pcache_is_stopping(pcache) || atomic_read(&cache->gc_errors))
+			return;
+
+		/* Get new tail positions */
+		mutex_lock(&cache->dirty_tail_lock);
+		cache_pos_copy(&dirty_tail, &cache->dirty_tail);
+		mutex_unlock(&cache->dirty_tail_lock);
+
+		mutex_lock(&cache->key_tail_lock);
+		cache_pos_copy(&key_tail, &cache->key_tail);
+		mutex_unlock(&cache->key_tail_lock);
+
+		if (!need_gc(cache, &dirty_tail, &key_tail))
+			break;
+
+		if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+			/* Don't move to the next segment if dirty_tail has not moved */
+			if (dirty_tail.cache_seg == key_tail.cache_seg)
+				break;
+
+			last_kset_gc(cache, kset_onmedia);
+			continue;
+		}
+
+		for (i = 0; i < kset_onmedia->key_num; i++) {
+			struct pcache_cache_key key_tmp = { 0 };
+
+			key_onmedia = &kset_onmedia->data[i];
+
+			key = &key_tmp;
+			cache_key_init(&cache->req_key_tree, key);
+
+			ret = cache_key_decode(cache, key_onmedia, key);
+			if (ret) {
+				/* return without re-arm gc work, and prevent future
+				 * gc, because we can't retry the partial-gc-ed kset
+				 */
+				atomic_inc(&cache->gc_errors);
+				pcache_dev_err(pcache, "failed to decode cache key in gc\n");
+				return;
+			}
+
+			cache_key_gc(cache, key);
+		}
+
+		pcache_dev_debug(pcache, "gc advance: %u:%u %u\n",
+			key_tail.cache_seg->cache_seg_id,
+			key_tail.seg_off,
+			get_kset_onmedia_size(kset_onmedia));
+
+		mutex_lock(&cache->key_tail_lock);
+		cache_pos_advance(&cache->key_tail, get_kset_onmedia_size(kset_onmedia));
+		cache_encode_key_tail(cache);
+		mutex_unlock(&cache->key_tail_lock);
+	}
+
+	queue_delayed_work(cache_get_wq(cache), &cache->gc_work, PCACHE_CACHE_GC_INTERVAL);
+}
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
new file mode 100644
index 000000000000..2b77e121f89b
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -0,0 +1,888 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "cache.h"
+#include "backing_dev.h"
+#include "cache_dev.h"
+#include "dm_pcache.h"
+
+struct pcache_cache_kset_onmedia pcache_empty_kset = { 0 };
+
+void cache_key_init(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key)
+{
+	kref_init(&key->ref);
+	key->cache_tree = cache_tree;
+	INIT_LIST_HEAD(&key->list_node);
+	RB_CLEAR_NODE(&key->rb_node);
+}
+
+struct pcache_cache_key *cache_key_alloc(struct pcache_cache_tree *cache_tree, gfp_t gfp_mask)
+{
+	struct pcache_cache_key *key;
+
+	key = mempool_alloc(&cache_tree->key_pool, gfp_mask);
+	if (!key)
+		return NULL;
+
+	memset(key, 0, sizeof(struct pcache_cache_key));
+	cache_key_init(cache_tree, key);
+
+	return key;
+}
+
+/**
+ * cache_key_get - Increment the reference count of a cache key.
+ * @key: Pointer to the pcache_cache_key structure.
+ *
+ * This function increments the reference count of the specified cache key,
+ * ensuring that it is not freed while still in use.
+ */
+void cache_key_get(struct pcache_cache_key *key)
+{
+	kref_get(&key->ref);
+}
+
+/**
+ * cache_key_destroy - Free a cache key structure when its reference count drops to zero.
+ * @ref: Pointer to the kref structure.
+ *
+ * This function is called when the reference count of the cache key reaches zero.
+ * It frees the allocated cache key back to the slab cache.
+ */
+static void cache_key_destroy(struct kref *ref)
+{
+	struct pcache_cache_key *key = container_of(ref, struct pcache_cache_key, ref);
+	struct pcache_cache_tree *cache_tree = key->cache_tree;
+
+	mempool_free(key, &cache_tree->key_pool);
+}
+
+void cache_key_put(struct pcache_cache_key *key)
+{
+	kref_put(&key->ref, cache_key_destroy);
+}
+
+void cache_pos_advance(struct pcache_cache_pos *pos, u32 len)
+{
+	/* Ensure enough space remains in the current segment */
+	BUG_ON(cache_seg_remain(pos) < len);
+
+	pos->seg_off += len;
+}
+
+static void cache_key_encode(struct pcache_cache *cache,
+			     struct pcache_cache_key_onmedia *key_onmedia,
+			     struct pcache_cache_key *key)
+{
+	key_onmedia->off = key->off;
+	key_onmedia->len = key->len;
+
+	key_onmedia->cache_seg_id = key->cache_pos.cache_seg->cache_seg_id;
+	key_onmedia->cache_seg_off = key->cache_pos.seg_off;
+
+	key_onmedia->seg_gen = key->seg_gen;
+	key_onmedia->flags = key->flags;
+
+	if (cache_data_crc_on(cache))
+		key_onmedia->data_crc = cache_key_data_crc(key);
+}
+
+int cache_key_decode(struct pcache_cache *cache,
+			struct pcache_cache_key_onmedia *key_onmedia,
+			struct pcache_cache_key *key)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+
+	key->off = key_onmedia->off;
+	key->len = key_onmedia->len;
+
+	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
+	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
+
+	key->seg_gen = key_onmedia->seg_gen;
+	key->flags = key_onmedia->flags;
+
+	if (cache_data_crc_on(cache) &&
+			key_onmedia->data_crc != cache_key_data_crc(key)) {
+		pcache_dev_err(pcache, "key: %llu:%u seg %u:%u data_crc error: %x, expected: %x\n",
+				key->off, key->len, key->cache_pos.cache_seg->cache_seg_id,
+				key->cache_pos.seg_off, cache_key_data_crc(key), key_onmedia->data_crc);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void append_last_kset(struct pcache_cache *cache, u32 next_seg)
+{
+	struct pcache_cache_kset_onmedia kset_onmedia = { 0 };
+
+	kset_onmedia.flags |= PCACHE_KSET_FLAGS_LAST;
+	kset_onmedia.next_cache_seg_id = next_seg;
+	kset_onmedia.magic = PCACHE_KSET_MAGIC;
+	kset_onmedia.crc = cache_kset_crc(&kset_onmedia);
+
+	memcpy_flushcache(get_key_head_addr(cache), &kset_onmedia, sizeof(struct pcache_cache_kset_onmedia));
+	pmem_wmb();
+	cache_pos_advance(&cache->key_head, sizeof(struct pcache_cache_kset_onmedia));
+}
+
+int cache_kset_close(struct pcache_cache *cache, struct pcache_cache_kset *kset)
+{
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 kset_onmedia_size;
+	int ret;
+
+	kset_onmedia = &kset->kset_onmedia;
+
+	if (!kset_onmedia->key_num)
+		return 0;
+
+	kset_onmedia_size = struct_size(kset_onmedia, data, kset_onmedia->key_num);
+
+	spin_lock(&cache->key_head_lock);
+again:
+	/* Reserve space for the last kset */
+	if (cache_seg_remain(&cache->key_head) < kset_onmedia_size + sizeof(struct pcache_cache_kset_onmedia)) {
+		struct pcache_cache_segment *next_seg;
+
+		next_seg = get_cache_segment(cache);
+		if (!next_seg) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		/* clear outdated kset in next seg */
+		memcpy_flushcache(next_seg->segment.data, &pcache_empty_kset,
+					sizeof(struct pcache_cache_kset_onmedia));
+		append_last_kset(cache, next_seg->cache_seg_id);
+		cache->key_head.cache_seg = next_seg;
+		cache->key_head.seg_off = 0;
+		goto again;
+	}
+
+	kset_onmedia->magic = PCACHE_KSET_MAGIC;
+	kset_onmedia->crc = cache_kset_crc(kset_onmedia);
+
+	/* clear outdated kset after current kset */
+	memcpy_flushcache(get_key_head_addr(cache) + kset_onmedia_size, &pcache_empty_kset,
+				sizeof(struct pcache_cache_kset_onmedia));
+	/* write current kset into segment */
+	memcpy_flushcache(get_key_head_addr(cache), kset_onmedia, kset_onmedia_size);
+	pmem_wmb();
+
+	/* reset kset_onmedia */
+	memset(kset_onmedia, 0, sizeof(struct pcache_cache_kset_onmedia));
+	cache_pos_advance(&cache->key_head, kset_onmedia_size);
+
+	ret = 0;
+out:
+	spin_unlock(&cache->key_head_lock);
+
+	return ret;
+}
+
+/**
+ * cache_key_append - Append a cache key to the related kset.
+ * @cache: Pointer to the pcache_cache structure.
+ * @key: Pointer to the cache key structure to append.
+ * @force_close: Need to close current kset if true.
+ *
+ * This function appends a cache key to the appropriate kset. If the kset
+ * is full, it closes the kset. If not, it queues a flush work to write
+ * the kset to media.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int cache_key_append(struct pcache_cache *cache, struct pcache_cache_key *key, bool force_close)
+{
+	struct pcache_cache_kset *kset;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	struct pcache_cache_key_onmedia *key_onmedia;
+	u32 kset_id = get_kset_id(cache, key->off);
+	int ret = 0;
+
+	kset = get_kset(cache, kset_id);
+	kset_onmedia = &kset->kset_onmedia;
+
+	spin_lock(&kset->kset_lock);
+	key_onmedia = &kset_onmedia->data[kset_onmedia->key_num];
+	cache_key_encode(cache, key_onmedia, key);
+
+	/* Check if the current kset has reached the maximum number of keys */
+	if (++kset_onmedia->key_num == PCACHE_KSET_KEYS_MAX || force_close) {
+		/* If full, close the kset */
+		ret = cache_kset_close(cache, kset);
+		if (ret) {
+			kset_onmedia->key_num--;
+			goto out;
+		}
+	} else {
+		/* If not full, queue a delayed work to flush the kset */
+		queue_delayed_work(cache_get_wq(cache), &kset->flush_work, 1 * HZ);
+	}
+out:
+	spin_unlock(&kset->kset_lock);
+
+	return ret;
+}
+
+/**
+ * cache_subtree_walk - Traverse the cache tree.
+ * @ctx: Pointer to the context structure for traversal.
+ *
+ * This function traverses the cache tree starting from the specified node.
+ * It calls the appropriate callback functions based on the relationships
+ * between the keys in the cache tree.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int cache_subtree_walk(struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache_key *key_tmp, *key;
+	struct rb_node *node_tmp;
+	int ret = SUBTREE_WALK_RET_OK;
+
+	key = ctx->key;
+	node_tmp = ctx->start_node;
+
+	while (node_tmp) {
+		if (ctx->walk_done && ctx->walk_done(ctx))
+			break;
+
+		key_tmp = CACHE_KEY(node_tmp);
+		/*
+		 * If key_tmp ends before the start of key, continue to the next node.
+		 * |----------|
+		 *              |=====|
+		 */
+		if (cache_key_lend(key_tmp) <= cache_key_lstart(key)) {
+			if (ctx->after) {
+				ret = ctx->after(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			goto next;
+		}
+
+		/*
+		 * If key_tmp starts after the end of key, stop traversing.
+		 *	  |--------|
+		 * |====|
+		 */
+		if (cache_key_lstart(key_tmp) >= cache_key_lend(key)) {
+			if (ctx->before) {
+				ret = ctx->before(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			break;
+		}
+
+		/* Handle overlapping keys */
+		if (cache_key_lstart(key_tmp) >= cache_key_lstart(key)) {
+			/*
+			 * If key_tmp encompasses key.
+			 *     |----------------|	key_tmp
+			 * |===========|		key
+			 */
+			if (cache_key_lend(key_tmp) >= cache_key_lend(key)) {
+				if (ctx->overlap_tail) {
+					ret = ctx->overlap_tail(key, key_tmp, ctx);
+					if (ret)
+						goto out;
+				}
+				break;
+			}
+
+			/*
+			 * If key_tmp is contained within key.
+			 *    |----|		key_tmp
+			 * |==========|		key
+			 */
+			if (ctx->overlap_contain) {
+				ret = ctx->overlap_contain(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+
+			goto next;
+		}
+
+		/*
+		 * If key_tmp starts before key ends but ends after key.
+		 * |-----------|	key_tmp
+		 *   |====|		key
+		 */
+		if (cache_key_lend(key_tmp) > cache_key_lend(key)) {
+			if (ctx->overlap_contained) {
+				ret = ctx->overlap_contained(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			break;
+		}
+
+		/*
+		 * If key_tmp starts before key and ends within key.
+		 * |--------|		key_tmp
+		 *   |==========|	key
+		 */
+		if (ctx->overlap_head) {
+			ret = ctx->overlap_head(key, key_tmp, ctx);
+			if (ret)
+				goto out;
+		}
+next:
+		node_tmp = rb_next(node_tmp);
+	}
+
+out:
+	if (ctx->walk_finally)
+		ret = ctx->walk_finally(ctx, ret);
+
+	return ret;
+}
+
+/**
+ * cache_subtree_search - Search for a key in the cache tree.
+ * @cache_subtree: Pointer to the cache tree structure.
+ * @key: Pointer to the cache key to search for.
+ * @parentp: Pointer to store the parent node of the found node.
+ * @newp: Pointer to store the location where the new node should be inserted.
+ * @delete_key_list: List to collect invalid keys for deletion.
+ *
+ * This function searches the cache tree for a specific key and returns
+ * the node that is the predecessor of the key, or first node if the key is
+ * less than all keys in the tree. If any invalid keys are found during
+ * the search, they are added to the delete_key_list for later cleanup.
+ *
+ * Returns a pointer to the previous node.
+ */
+struct rb_node *cache_subtree_search(struct pcache_cache_subtree *cache_subtree, struct pcache_cache_key *key,
+				  struct rb_node **parentp, struct rb_node ***newp,
+				  struct list_head *delete_key_list)
+{
+	struct rb_node **new, *parent = NULL;
+	struct pcache_cache_key *key_tmp;
+	struct rb_node *prev_node = NULL;
+
+	new = &(cache_subtree->root.rb_node);
+	while (*new) {
+		key_tmp = container_of(*new, struct pcache_cache_key, rb_node);
+		if (cache_key_invalid(key_tmp))
+			list_add(&key_tmp->list_node, delete_key_list);
+
+		parent = *new;
+		if (key_tmp->off >= key->off) {
+			new = &((*new)->rb_left);
+		} else {
+			prev_node = *new;
+			new = &((*new)->rb_right);
+		}
+	}
+
+	if (!prev_node)
+		prev_node = rb_first(&cache_subtree->root);
+
+	if (parentp)
+		*parentp = parent;
+
+	if (newp)
+		*newp = new;
+
+	return prev_node;
+}
+
+static struct pcache_cache_key *get_pre_alloc_key(struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache_key *key;
+
+	if (ctx->pre_alloc_key) {
+		key = ctx->pre_alloc_key;
+		ctx->pre_alloc_key = NULL;
+
+		return key;
+	}
+
+	return cache_key_alloc(ctx->cache_tree, GFP_NOWAIT);
+}
+
+/**
+ * fixup_overlap_tail - Adjust the key when it overlaps at the tail.
+ * @key: Pointer to the new cache key being inserted.
+ * @key_tmp: Pointer to the existing key that overlaps.
+ * @ctx: Pointer to the context for walking the cache tree.
+ *
+ * This function modifies the existing key (key_tmp) when there is an
+ * overlap at the tail with the new key. If the modified key becomes
+ * empty, it is deleted.
+ */
+static int fixup_overlap_tail(struct pcache_cache_key *key,
+			       struct pcache_cache_key *key_tmp,
+			       struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	/*
+	 *     |----------------|	key_tmp
+	 * |===========|		key
+	 */
+	BUG_ON(cache_key_empty(key));
+	if (cache_key_empty(key_tmp)) {
+		cache_key_delete(key_tmp);
+		return SUBTREE_WALK_RET_RESEARCH;
+	}
+
+	cache_key_cutfront(key_tmp, cache_key_lend(key) - cache_key_lstart(key_tmp));
+	if (key_tmp->len == 0) {
+		cache_key_delete(key_tmp);
+		return SUBTREE_WALK_RET_RESEARCH;
+	}
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/**
+ * fixup_overlap_contain - Handle case where new key completely contains an existing key.
+ * @key: Pointer to the new cache key being inserted.
+ * @key_tmp: Pointer to the existing key that is being contained.
+ * @ctx: Pointer to the context for walking the cache tree.
+ *
+ * This function deletes the existing key (key_tmp) when the new key
+ * completely contains it. It returns SUBTREE_WALK_RET_RESEARCH to indicate that the
+ * tree structure may have changed, necessitating a re-insertion of
+ * the new key.
+ */
+static int fixup_overlap_contain(struct pcache_cache_key *key,
+				  struct pcache_cache_key *key_tmp,
+				  struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	/*
+	 *    |----|			key_tmp
+	 * |==========|			key
+	 */
+	BUG_ON(cache_key_empty(key));
+	cache_key_delete(key_tmp);
+
+	return SUBTREE_WALK_RET_RESEARCH;
+}
+
+/**
+ * fixup_overlap_contained - Handle overlap when a new key is contained in an existing key.
+ * @key: The new cache key being inserted.
+ * @key_tmp: The existing cache key that overlaps with the new key.
+ * @ctx: Context for the cache tree walk.
+ *
+ * This function adjusts the existing key if the new key is contained
+ * within it. If the existing key is empty, it indicates a placeholder key
+ * that was inserted during a miss read. This placeholder will later be
+ * updated with real data from the backing_dev, making it no longer an empty key.
+ *
+ * If we delete key or insert a key, the structure of the entire cache tree may change,
+ * requiring a full research of the tree to find a new insertion point.
+ */
+static int fixup_overlap_contained(struct pcache_cache_key *key,
+	struct pcache_cache_key *key_tmp, struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache_tree *cache_tree = ctx->cache_tree;
+
+	/*
+	 * |-----------|		key_tmp
+	 *   |====|			key
+	 */
+	BUG_ON(cache_key_empty(key));
+	if (cache_key_empty(key_tmp)) {
+		/* If key_tmp is empty, don't split it;
+		 * it's a placeholder key for miss reads that will be updated later.
+		 */
+		cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+		if (key_tmp->len == 0) {
+			cache_key_delete(key_tmp);
+			return SUBTREE_WALK_RET_RESEARCH;
+		}
+	} else {
+		struct pcache_cache_key *key_fixup;
+		bool need_research = false;
+
+		key_fixup = get_pre_alloc_key(ctx);
+		if (!key_fixup)
+			return SUBTREE_WALK_RET_NEED_KEY;
+
+		cache_key_copy(key_fixup, key_tmp);
+
+		/* Split key_tmp based on the new key's range */
+		cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+		if (key_tmp->len == 0) {
+			cache_key_delete(key_tmp);
+			need_research = true;
+		}
+
+		/* Create a new portion for key_fixup */
+		cache_key_cutfront(key_fixup, cache_key_lend(key) - cache_key_lstart(key_tmp));
+		if (key_fixup->len == 0) {
+			cache_key_put(key_fixup);
+		} else {
+			/* Insert the new key into the cache */
+			cache_key_insert(cache_tree, key_fixup, false);
+			need_research = true;
+		}
+
+		if (need_research)
+			return SUBTREE_WALK_RET_RESEARCH;
+	}
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/**
+ * fixup_overlap_head - Handle overlap when a new key overlaps with the head of an existing key.
+ * @key: The new cache key being inserted.
+ * @key_tmp: The existing cache key that overlaps with the new key.
+ * @ctx: Context for the cache tree walk.
+ *
+ * This function adjusts the existing key if the new key overlaps
+ * with the beginning of it. If the resulting key length is zero
+ * after the adjustment, the key is deleted. This indicates that
+ * the key no longer holds valid data and requires the tree to be
+ * re-researched for a new insertion point.
+ */
+static int fixup_overlap_head(struct pcache_cache_key *key,
+	struct pcache_cache_key *key_tmp, struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	/*
+	 * |--------|		key_tmp
+	 *   |==========|	key
+	 */
+	BUG_ON(cache_key_empty(key));
+	/* Adjust key_tmp by cutting back based on the new key's start */
+	cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+	if (key_tmp->len == 0) {
+		/* If the adjusted key_tmp length is zero, delete it */
+		cache_key_delete(key_tmp);
+		return SUBTREE_WALK_RET_RESEARCH;
+	}
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/**
+ * cache_key_insert - Insert a new cache key into the cache tree.
+ * @cache_tree: Pointer to the cache_tree structure.
+ * @key: The cache key to insert.
+ * @fixup: Indicates if this is a new key being inserted.
+ *
+ * This function searches for the appropriate location to insert
+ * a new cache key into the cache tree. It handles key overlaps
+ * and ensures any invalid keys are removed before insertion.
+ */
+void cache_key_insert(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key, bool fixup)
+{
+	struct pcache_cache *cache = cache_tree->cache;
+	struct pcache_cache_subtree_walk_ctx walk_ctx = { 0 };
+	struct rb_node **new, *parent = NULL;
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key_tmp = NULL, *key_next;
+	struct rb_node *prev_node = NULL;
+	LIST_HEAD(delete_key_list);
+	int ret;
+
+	cache_subtree = get_subtree(cache_tree, key->off);
+	key->cache_subtree = cache_subtree;
+search:
+	prev_node = cache_subtree_search(cache_subtree, key, &parent, &new, &delete_key_list);
+	if (!list_empty(&delete_key_list)) {
+		/* Remove invalid keys from the delete list */
+		list_for_each_entry_safe(key_tmp, key_next, &delete_key_list, list_node) {
+			list_del_init(&key_tmp->list_node);
+			cache_key_delete(key_tmp);
+		}
+		goto search;
+	}
+
+	if (fixup) {
+		/* Set up the context with the cache, start node, and new key */
+		walk_ctx.cache_tree = cache_tree;
+		walk_ctx.start_node = prev_node;
+		walk_ctx.key = key;
+
+		/* Assign overlap handling functions for different scenarios */
+		walk_ctx.overlap_tail = fixup_overlap_tail;
+		walk_ctx.overlap_head = fixup_overlap_head;
+		walk_ctx.overlap_contain = fixup_overlap_contain;
+		walk_ctx.overlap_contained = fixup_overlap_contained;
+
+		ret = cache_subtree_walk(&walk_ctx);
+		switch (ret) {
+		case SUBTREE_WALK_RET_OK:
+			break;
+		case SUBTREE_WALK_RET_RESEARCH:
+			goto search;
+		case SUBTREE_WALK_RET_NEED_KEY:
+			spin_unlock(&cache_subtree->tree_lock);
+			pcache_dev_debug(CACHE_TO_PCACHE(cache), "allocate pre_alloc_key with GFP_NOIO");
+			walk_ctx.pre_alloc_key = cache_key_alloc(cache_tree, GFP_NOIO);
+			spin_lock(&cache_subtree->tree_lock);
+			goto search;
+		default:
+			BUG();
+		}
+	}
+
+	if (walk_ctx.pre_alloc_key)
+		cache_key_put(walk_ctx.pre_alloc_key);
+
+	/* Link and insert the new key into the red-black tree */
+	rb_link_node(&key->rb_node, parent, new);
+	rb_insert_color(&key->rb_node, &cache_subtree->root);
+}
+
+/**
+ * clean_fn - Cleanup function to remove invalid keys from the cache tree.
+ * @work: Pointer to the work_struct associated with the cleanup.
+ *
+ * This function cleans up invalid keys from the cache tree in the background
+ * after a cache segment has been invalidated during cache garbage collection.
+ * It processes a maximum of PCACHE_CLEAN_KEYS_MAX keys per iteration and holds
+ * the tree lock to ensure thread safety.
+ */
+void clean_fn(struct work_struct *work)
+{
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, clean_work);
+	struct pcache_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct pcache_cache_key *key;
+	int i, count;
+
+	for (i = 0; i < cache->req_key_tree.n_subtrees; i++) {
+		cache_subtree = &cache->req_key_tree.subtrees[i];
+
+again:
+		if (pcache_is_stopping(CACHE_TO_PCACHE(cache)))
+			return;
+
+		/* Delete up to PCACHE_CLEAN_KEYS_MAX keys in one iteration */
+		count = 0;
+		spin_lock(&cache_subtree->tree_lock);
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+			if (cache_key_invalid(key)) {
+				count++;
+				cache_key_delete(key);
+			}
+
+			if (count >= PCACHE_CLEAN_KEYS_MAX) {
+				/* Unlock and pause before continuing cleanup */
+				spin_unlock(&cache_subtree->tree_lock);
+				usleep_range(1000, 2000);
+				goto again;
+			}
+		}
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+}
+
+/*
+ * kset_flush_fn - Flush work for a cache kset.
+ *
+ * This function is called when a kset flush work is queued from
+ * cache_key_append(). If the kset is full, it will be closed
+ * immediately. If not, the flush work will be queued for later closure.
+ *
+ * If cache_kset_close detects that a new segment is required to store
+ * the kset and there are no available segments, it will return an error.
+ * In this scenario, a retry will be attempted.
+ */
+void kset_flush_fn(struct work_struct *work)
+{
+	struct pcache_cache_kset *kset = container_of(work, struct pcache_cache_kset, flush_work.work);
+	struct pcache_cache *cache = kset->cache;
+	int ret;
+
+	if (pcache_is_stopping(CACHE_TO_PCACHE(cache)))
+		return;
+
+	spin_lock(&kset->kset_lock);
+	ret = cache_kset_close(cache, kset);
+	spin_unlock(&kset->kset_lock);
+
+	if (ret) {
+		/* Failed to flush kset, schedule a retry. */
+		queue_delayed_work(cache_get_wq(cache), &kset->flush_work, msecs_to_jiffies(100));
+	}
+}
+
+static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key;
+	int ret;
+	int i;
+
+	for (i = 0; i < kset_onmedia->key_num; i++) {
+		key_onmedia = &kset_onmedia->data[i];
+
+		key = cache_key_alloc(&cache->req_key_tree, GFP_NOIO);
+		ret = cache_key_decode(cache, key_onmedia, key);
+		if (ret) {
+			cache_key_put(key);
+			goto err;
+		}
+
+		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
+
+		/* Check if the segment generation is valid for insertion. */
+		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
+			cache_key_put(key);
+		} else {
+			cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+			spin_lock(&cache_subtree->tree_lock);
+			cache_key_insert(&cache->req_key_tree, key, true);
+			spin_unlock(&cache_subtree->tree_lock);
+		}
+
+		cache_seg_get(key->cache_pos.cache_seg);
+	}
+
+	return 0;
+err:
+	return ret;
+}
+
+int cache_replay(struct pcache_cache *cache)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_pos pos_tail;
+	struct pcache_cache_pos *pos;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 to_copy, count = 0;
+	int ret = 0;
+
+	kset_onmedia = kzalloc(PCACHE_KSET_ONMEDIA_SIZE_MAX, GFP_KERNEL);
+	if (!kset_onmedia)
+		return -ENOMEM;
+
+	cache_pos_copy(&pos_tail, &cache->key_tail);
+	pos = &pos_tail;
+
+	/*
+	 * In cache replaying stage, there is no other one will access
+	 * cache->seg_map, so we can set bit here without cache->seg_map_lock.
+	 */
+	__set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
+
+	while (true) {
+		to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - pos->seg_off);
+		ret = copy_mc_to_kernel(kset_onmedia, cache_pos_addr(pos), to_copy);
+		if (ret) {
+			ret = -EIO;
+			goto out;
+		}
+
+		if (kset_onmedia->magic != PCACHE_KSET_MAGIC ||
+				kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+			break;
+		}
+
+		/* Process the last kset and prepare for the next segment. */
+		if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+			struct pcache_cache_segment *next_seg;
+
+			pcache_dev_debug(pcache, "last kset replay, next: %u\n", kset_onmedia->next_cache_seg_id);
+
+			next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
+
+			pos->cache_seg = next_seg;
+			pos->seg_off = 0;
+
+			__set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
+			continue;
+		}
+
+		/* Replay the kset and check for errors. */
+		ret = kset_replay(cache, kset_onmedia);
+		if (ret)
+			goto out;
+
+		/* Advance the position after processing the kset. */
+		cache_pos_advance(pos, get_kset_onmedia_size(kset_onmedia));
+		if (++count > 512) {
+			cond_resched();
+			count = 0;
+		}
+	}
+
+	/* Update the key_head position after replaying. */
+	spin_lock(&cache->key_head_lock);
+	cache_pos_copy(&cache->key_head, pos);
+	spin_unlock(&cache->key_head_lock);
+out:
+	kfree(kset_onmedia);
+	return ret;
+}
+
+int cache_tree_init(struct pcache_cache *cache, struct pcache_cache_tree *cache_tree, u32 n_subtrees)
+{
+	int ret;
+	u32 i;
+
+	cache_tree->cache = cache;
+	cache_tree->n_subtrees = n_subtrees;
+
+	ret = mempool_init_slab_pool(&cache_tree->key_pool, 1024, key_cache);
+	if (ret)
+		goto err;
+
+	/*
+	 * Allocate and initialize the subtrees array.
+	 * Each element is a cache tree structure that contains
+	 * an RB tree root and a spinlock for protecting its contents.
+	 */
+	cache_tree->subtrees = kvcalloc(cache_tree->n_subtrees, sizeof(struct pcache_cache_subtree), GFP_KERNEL);
+	if (!cache_tree->subtrees) {
+		ret = -ENOMEM;
+		goto key_pool_exit;
+	}
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		struct pcache_cache_subtree *cache_subtree = &cache_tree->subtrees[i];
+
+		cache_subtree->root = RB_ROOT;
+		spin_lock_init(&cache_subtree->tree_lock);
+	}
+
+	return 0;
+
+key_pool_exit:
+	mempool_exit(&cache_tree->key_pool);
+err:
+	return ret;
+}
+
+void cache_tree_clear(struct pcache_cache_tree *cache_tree)
+{
+	struct pcache_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct pcache_cache_key *key;
+	u32 i;
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		cache_subtree = &cache_tree->subtrees[i];
+
+		spin_lock(&cache_subtree->tree_lock);
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+
+			cache_key_delete(key);
+		}
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+}
+
+void cache_tree_exit(struct pcache_cache_tree *cache_tree)
+{
+	cache_tree_clear(cache_tree);
+	kvfree(cache_tree->subtrees);
+	mempool_exit(&cache_tree->key_pool);
+}
diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
new file mode 100644
index 000000000000..992a1ad98909
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -0,0 +1,835 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cache.h"
+#include "backing_dev.h"
+#include "cache_dev.h"
+#include "dm_pcache.h"
+
+static int cache_data_head_init(struct pcache_cache *cache)
+{
+	struct pcache_cache_segment *next_seg;
+	struct pcache_cache_data_head *data_head;
+
+	data_head = get_data_head(cache);
+	next_seg = get_cache_segment(cache);
+	if (!next_seg)
+		return -EBUSY;
+
+	cache_seg_get(next_seg);
+	data_head->head_pos.cache_seg = next_seg;
+	data_head->head_pos.seg_off = 0;
+
+	return 0;
+}
+
+/**
+ * cache_data_alloc - Allocate data for a cache key.
+ * @cache: Pointer to the cache structure.
+ * @key: Pointer to the cache key to allocate data for.
+ *
+ * This function tries to allocate space from the cache segment specified by the
+ * data head. If the remaining space in the segment is insufficient to allocate
+ * the requested length for the cache key, it will allocate whatever is available
+ * and adjust the key's length accordingly. This function does not allocate
+ * space that crosses segment boundaries.
+ */
+static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	struct pcache_cache_data_head *data_head;
+	struct pcache_cache_pos *head_pos;
+	struct pcache_cache_segment *cache_seg;
+	u32 seg_remain;
+	u32 allocated = 0, to_alloc;
+	int ret = 0;
+
+	preempt_disable();
+	data_head = get_data_head(cache);
+again:
+	if (!data_head->head_pos.cache_seg) {
+		seg_remain = 0;
+	} else {
+		cache_pos_copy(&key->cache_pos, &data_head->head_pos);
+		key->seg_gen = key->cache_pos.cache_seg->gen;
+
+		head_pos = &data_head->head_pos;
+		cache_seg = head_pos->cache_seg;
+		seg_remain = cache_seg_remain(head_pos);
+		to_alloc = key->len - allocated;
+	}
+
+	if (seg_remain > to_alloc) {
+		/* If remaining space in segment is sufficient for the cache key, allocate it. */
+		cache_pos_advance(head_pos, to_alloc);
+		allocated += to_alloc;
+		cache_seg_get(cache_seg);
+	} else if (seg_remain) {
+		/* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
+		cache_pos_advance(head_pos, seg_remain);
+		key->len = seg_remain;
+
+		/* Get for key: obtain a reference to the cache segment for the key. */
+		cache_seg_get(cache_seg);
+		/* Put for head_pos->cache_seg: release the reference for the current head's segment. */
+		cache_seg_put(head_pos->cache_seg);
+		head_pos->cache_seg = NULL;
+	} else {
+		/* Initialize a new data head if no segment is available. */
+		ret = cache_data_head_init(cache);
+		if (ret)
+			goto out;
+
+		goto again;
+	}
+
+out:
+	preempt_enable();
+
+	return ret;
+}
+
+static int cache_copy_from_req_bio(struct pcache_cache *cache, struct pcache_cache_key *key,
+				struct pcache_request *pcache_req, u32 bio_off)
+{
+	struct pcache_cache_pos *pos = &key->cache_pos;
+	struct pcache_segment *segment;
+
+	segment = &pos->cache_seg->segment;
+
+	return segment_copy_from_bio(segment, pos->seg_off, key->len, pcache_req->bio, bio_off);
+}
+
+static int cache_copy_to_req_bio(struct pcache_cache *cache, struct pcache_request *pcache_req,
+			    u32 bio_off, u32 len, struct pcache_cache_pos *pos, u64 key_gen)
+{
+	struct pcache_cache_segment *cache_seg = pos->cache_seg;
+	struct pcache_segment *segment = &cache_seg->segment;
+	int ret;
+
+	spin_lock(&cache_seg->gen_lock);
+	if (key_gen < cache_seg->gen) {
+		spin_unlock(&cache_seg->gen_lock);
+		return -EINVAL;
+	}
+
+	ret = segment_copy_to_bio(segment, pos->seg_off, len, pcache_req->bio, bio_off);
+	spin_unlock(&cache_seg->gen_lock);
+
+	return ret;
+}
+
+/**
+ * miss_read_end_req - Handle the end of a miss read request.
+ * @backing_req: Pointer to the request structure.
+ * @read_ret: Return value of read.
+ *
+ * This function is called when a backing request to read data from
+ * the backing_dev is completed. If the key associated with the request
+ * is empty (a placeholder), it allocates cache space for the key,
+ * copies the data read from the bio into the cache, and updates
+ * the key's status. If the key has been overwritten by a write
+ * request during this process, it will be deleted from the cache
+ * tree and no further action will be taken.
+ */
+static void miss_read_end_req(struct pcache_backing_dev_req *backing_req, int read_ret)
+{
+	void *priv_data = backing_req->priv_data;
+	struct pcache_request *pcache_req = backing_req->req.upper_req;
+	struct pcache_cache *cache = backing_req->backing_dev->cache;
+	int ret;
+
+	if (priv_data) {
+		struct pcache_cache_key *key;
+		struct pcache_cache_subtree *cache_subtree;
+
+		key = (struct pcache_cache_key *)priv_data;
+		cache_subtree = key->cache_subtree;
+
+		/* if this key was deleted from cache_subtree by a write, key->flags should be cleared,
+		 * so if cache_key_empty() return true, this key is still in cache_subtree
+		 */
+		spin_lock(&cache_subtree->tree_lock);
+		if (cache_key_empty(key)) {
+			/* Check if the backing request was successful. */
+			if (read_ret) {
+				cache_key_delete(key);
+				goto unlock;
+			}
+
+			/* Allocate cache space for the key and copy data from the backing_dev. */
+			ret = cache_data_alloc(cache, key);
+			if (ret) {
+				cache_key_delete(key);
+				goto unlock;
+			}
+
+			ret = cache_copy_from_req_bio(cache, key, pcache_req, backing_req->req.bio_off);
+			if (ret) {
+				cache_seg_put(key->cache_pos.cache_seg);
+				cache_key_delete(key);
+				goto unlock;
+			}
+			key->flags &= ~PCACHE_CACHE_KEY_FLAGS_EMPTY;
+			key->flags |= PCACHE_CACHE_KEY_FLAGS_CLEAN;
+
+			/* Append the key to the cache. */
+			ret = cache_key_append(cache, key, false);
+			if (ret) {
+				cache_seg_put(key->cache_pos.cache_seg);
+				cache_key_delete(key);
+				goto unlock;
+			}
+		}
+unlock:
+		spin_unlock(&cache_subtree->tree_lock);
+		cache_key_put(key);
+	}
+}
+
+/**
+ * submit_cache_miss_req - Submit a backing request when cache data is missing
+ * @cache: The cache context that manages cache operations
+ * @backing_req: The cache request containing information about the read request
+ *
+ * This function is used to handle cases where a cache read request cannot locate
+ * the required data in the cache. When such a miss occurs during `cache_subtree_walk`,
+ * it triggers a backing read request to fetch data from the backing storage.
+ *
+ * If `pcache_req->priv_data` is set, it points to a `pcache_cache_key`, representing
+ * a new cache key to be inserted into the cache. The function calls `cache_key_insert`
+ * to attempt adding the key. On insertion failure, it releases the key reference and
+ * clears `priv_data` to avoid further processing.
+ */
+static void submit_cache_miss_req(struct pcache_cache *cache, struct pcache_backing_dev_req *backing_req)
+{
+	if (backing_req->priv_data) {
+		struct pcache_cache_key *key;
+
+		/* Attempt to insert the key into the cache if priv_data is set */
+		key = (struct pcache_cache_key *)backing_req->priv_data;
+		cache_key_insert(&cache->req_key_tree, key, true);
+	}
+	backing_dev_req_submit(backing_req, false);
+}
+
+static void cache_miss_req_free(struct pcache_backing_dev_req *backing_req)
+{
+	struct pcache_cache_key *key;
+
+	if (backing_req->priv_data) {
+		key = backing_req->priv_data;
+		backing_req->priv_data = NULL;
+		cache_key_put(key); /* for ->priv_data */
+		cache_key_put(key); /* for init ref in alloc */
+	}
+
+	backing_dev_req_end(backing_req);
+}
+
+static struct pcache_backing_dev_req *cache_miss_req_alloc(struct pcache_cache *cache,
+							   struct pcache_request *parent,
+							   gfp_t gfp_mask)
+{
+	struct pcache_backing_dev *backing_dev = cache->backing_dev;
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache_key *key = NULL;
+	struct pcache_backing_dev_req_opts req_opts = { 0 };
+
+	req_opts.type = BACKING_DEV_REQ_TYPE_REQ;
+	req_opts.gfp_mask = gfp_mask;
+	req_opts.req.upper_req = parent;
+
+	backing_req = backing_dev_req_alloc(backing_dev, &req_opts);
+	if (!backing_req)
+		return NULL;
+
+	key = cache_key_alloc(&cache->req_key_tree, gfp_mask);
+	if (!key)
+		goto free_backing_req;
+
+	cache_key_get(key);
+	backing_req->priv_data = key;
+
+	return backing_req;
+
+free_backing_req:
+	cache_miss_req_free(backing_req);
+	return NULL;
+}
+
+static void cache_miss_req_init(struct pcache_cache *cache,
+				struct pcache_backing_dev_req *backing_req,
+				struct pcache_request *parent,
+				u32 off, u32 len, bool insert_key)
+{
+	struct pcache_cache_key *key;
+	struct pcache_backing_dev_req_opts req_opts = { 0 };
+
+	req_opts.type = BACKING_DEV_REQ_TYPE_REQ;
+	req_opts.req.upper_req = parent;
+	req_opts.req.req_off = off;
+	req_opts.req.len = len;
+	req_opts.end_fn = miss_read_end_req;
+
+	backing_dev_req_init(backing_req, &req_opts);
+
+	if (insert_key) {
+		key = backing_req->priv_data;
+		key->off = parent->off + off;
+		key->len = len;
+		key->flags |= PCACHE_CACHE_KEY_FLAGS_EMPTY;
+	} else {
+		key = backing_req->priv_data;
+		backing_req->priv_data = NULL;
+		cache_key_put(key);
+		cache_key_put(key);
+	}
+}
+
+static struct pcache_backing_dev_req *get_pre_alloc_req(struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_request *pcache_req = ctx->pcache_req;
+	struct pcache_backing_dev_req *backing_req;
+
+	if (ctx->pre_alloc_req) {
+		backing_req = ctx->pre_alloc_req;
+		ctx->pre_alloc_req = NULL;
+
+		return backing_req;
+	}
+
+       return cache_miss_req_alloc(cache, pcache_req, GFP_NOWAIT);
+}
+
+/*
+ * In the process of walking the cache tree to locate cached data, this
+ * function handles the situation where the requested data range lies
+ * entirely before an existing cache node (`key_tmp`). This outcome
+ * signifies that the target data is absent from the cache (cache miss).
+ *
+ * To fulfill this portion of the read request, the function creates a
+ * backing request (`backing_req`) for the missing data range represented
+ * by `key`. It then appends this request to the submission list in the
+ * `ctx`, which will later be processed to retrieve the data from backing
+ * storage. After setting up the backing request, `req_done` in `ctx` is
+ * updated to reflect the length of the handled range, and the range
+ * in `key` is adjusted by trimming off the portion that is now handled.
+ *
+ * The scenario handled here:
+ *
+ *	  |--------|			  key_tmp (existing cached range)
+ * |====|					   key (requested range, preceding key_tmp)
+ *
+ * Since `key` is before `key_tmp`, it signifies that the requested data
+ * range is missing in the cache (cache miss) and needs retrieval from
+ * backing storage.
+ */
+static int read_before(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+
+	/*
+	 * In this scenario, `key` represents a range that precedes `key_tmp`,
+	 * meaning the requested data range is missing from the cache tree
+	 * and must be retrieved from the backing_dev.
+	 */
+	backing_req = get_pre_alloc_req(ctx);
+	if (!backing_req)
+		return SUBTREE_WALK_RET_NEED_REQ;
+
+	cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, key->len, true);
+
+	list_add(&backing_req->node, ctx->submit_req_list);
+	ctx->req_done += key->len;
+	cache_key_cutfront(key, key->len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ * During cache_subtree_walk, this function manages a scenario where part of the
+ * requested data range overlaps with an existing cache node (`key_tmp`).
+ *
+ *	 |----------------|  key_tmp (existing cached range)
+ * |===========|		   key (requested range, overlapping the tail of key_tmp)
+ */
+static int read_overlap_tail(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	u32 io_len;
+	int ret;
+
+	/*
+	 * Calculate the length of the non-overlapping portion of `key`
+	 * before `key_tmp`, representing the data missing in the cache.
+	 */
+	io_len = cache_key_lstart(key_tmp) - cache_key_lstart(key);
+	if (io_len) {
+		backing_req = get_pre_alloc_req(ctx);
+		if (!backing_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, true);
+
+		list_add(&backing_req->node, ctx->submit_req_list);
+		ctx->req_done += io_len;
+		cache_key_cutfront(key, io_len);
+	}
+
+	/*
+	 * Handle the overlapping portion by calculating the length of
+	 * the remaining data in `key` that coincides with `key_tmp`.
+	 */
+	io_len = cache_key_lend(key) - cache_key_lstart(key_tmp);
+	if (cache_key_empty(key_tmp)) {
+		backing_req = get_pre_alloc_req(ctx);
+		if (!backing_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					io_len, &key_tmp->cache_pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ *    |----|          key_tmp (existing cached range)
+ * |==========|       key (requested range)
+ */
+static int read_overlap_contain(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	u32 io_len;
+	int ret;
+
+	/*
+	 * Calculate the non-overlapping part of `key` before `key_tmp`
+	 * to identify the missing data length.
+	 */
+	io_len = cache_key_lstart(key_tmp) - cache_key_lstart(key);
+	if (io_len) {
+		backing_req = get_pre_alloc_req(ctx);
+		if (!backing_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, true);
+
+		list_add(&backing_req->node, ctx->submit_req_list);
+
+		ctx->req_done += io_len;
+		cache_key_cutfront(key, io_len);
+	}
+
+	/*
+	 * Handle the overlapping portion between `key` and `key_tmp`.
+	 */
+	io_len = key_tmp->len;
+	if (cache_key_empty(key_tmp)) {
+		backing_req = get_pre_alloc_req(ctx);
+		if (!backing_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					io_len, &key_tmp->cache_pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ *	 |-----------|		key_tmp (existing cached range)
+ *	   |====|			key (requested range, fully within key_tmp)
+ *
+ * If `key_tmp` contains valid cached data, this function copies the relevant
+ * portion to the request's bio. Otherwise, it sends a backing request to
+ * fetch the required data range.
+ */
+static int read_overlap_contained(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache_pos pos;
+	int ret;
+
+	/*
+	 * Check if `key_tmp` is empty, indicating a miss. If so, initiate
+	 * a backing request to fetch the required data for `key`.
+	 */
+	if (cache_key_empty(key_tmp)) {
+		backing_req = get_pre_alloc_req(ctx);
+		if (!backing_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, key->len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		cache_pos_copy(&pos, &key_tmp->cache_pos);
+		cache_pos_advance(&pos, cache_key_lstart(key) - cache_key_lstart(key_tmp));
+
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					key->len, &pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += key->len;
+	cache_key_cutfront(key, key->len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ *	 |--------|		  key_tmp (existing cached range)
+ *	   |==========|	  key (requested range, overlapping the head of key_tmp)
+ */
+static int read_overlap_head(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+		struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req;
+	struct pcache_cache_pos pos;
+	u32 io_len;
+	int ret;
+
+	io_len = cache_key_lend(key_tmp) - cache_key_lstart(key);
+
+	if (cache_key_empty(key_tmp)) {
+		backing_req = get_pre_alloc_req(ctx);
+		if (!backing_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, io_len, false);
+		submit_cache_miss_req(cache, backing_req);
+	} else {
+		cache_pos_copy(&pos, &key_tmp->cache_pos);
+		cache_pos_advance(&pos, cache_key_lstart(key) - cache_key_lstart(key_tmp));
+
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->pcache_req, ctx->req_done,
+					io_len, &pos, key_tmp->seg_gen);
+		if (ret) {
+			if (ret == -EINVAL) {
+				cache_key_delete(key_tmp);
+				return SUBTREE_WALK_RET_RESEARCH;
+			}
+
+			ctx->ret = ret;
+			return SUBTREE_WALK_RET_ERR;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/**
+ * read_walk_finally - Finalizes the cache read tree walk by submitting any
+ *					 remaining backing requests
+ * @ctx:	Context structure holding information about the cache,
+ *		read request, and submission list
+ * @ret:	the return value after this walk.
+ *
+ * This function is called at the end of the `cache_subtree_walk` during a
+ * cache read operation. It completes the walk by checking if any data
+ * requested by `key` was not found in the cache tree, and if so, it sends
+ * a backing request to retrieve that data. Then, it iterates through the
+ * submission list of backing requests created during the walk, removing
+ * each request from the list and submitting it.
+ *
+ * The scenario managed here includes:
+ * - Sending a backing request for the remaining length of `key` if it was
+ *   not fulfilled by existing cache entries.
+ * - Iterating through `ctx->submit_req_list` to submit each backing request
+ *   enqueued during the walk.
+ *
+ * This ensures all necessary backing requests for cache misses are submitted
+ * to the backing storage to retrieve any data that could not be found in
+ * the cache.
+ */
+static int read_walk_finally(struct pcache_cache_subtree_walk_ctx *ctx, int ret)
+{
+	struct pcache_cache *cache = ctx->cache_tree->cache;
+	struct pcache_backing_dev_req *backing_req, *next_req;
+	struct pcache_cache_key *key = ctx->key;
+
+	list_for_each_entry_safe(backing_req, next_req, ctx->submit_req_list, node) {
+		list_del_init(&backing_req->node);
+		submit_cache_miss_req(ctx->cache_tree->cache, backing_req);
+	}
+
+	if (ret != SUBTREE_WALK_RET_OK)
+		return ret;
+
+	if (key->len) {
+		backing_req = get_pre_alloc_req(ctx);
+		if (!backing_req)
+			return SUBTREE_WALK_RET_NEED_REQ;
+
+		cache_miss_req_init(cache, backing_req, ctx->pcache_req, ctx->req_done, key->len, true);
+		submit_cache_miss_req(cache, backing_req);
+		ctx->req_done += key->len;
+	}
+
+	return SUBTREE_WALK_RET_OK;
+}
+
+/*
+ * This function is used within `cache_subtree_walk` to determine whether the
+ * read operation has covered the requested data length. It compares the
+ * amount of data processed (`ctx->req_done`) with the total data length
+ * specified in the original request (`ctx->pcache_req->data_len`).
+ *
+ * If `req_done` meets or exceeds the required data length, the function
+ * returns `true`, indicating the walk is complete. Otherwise, it returns `false`,
+ * signaling that additional data processing is needed to fulfill the request.
+ */
+static bool read_walk_done(struct pcache_cache_subtree_walk_ctx *ctx)
+{
+	return (ctx->req_done >= ctx->pcache_req->data_len);
+}
+
+/**
+ * cache_read - Process a read request by traversing the cache tree
+ * @cache:	 Cache structure holding cache trees and related configurations
+ * @pcache_req:   Request structure with information about the data to read
+ *
+ * This function attempts to fulfill a read request by traversing the cache tree(s)
+ * to locate cached data for the requested range. If parts of the data are missing
+ * in the cache, backing requests are generated to retrieve the required segments.
+ *
+ * The function operates by initializing a key for the requested data range and
+ * preparing a context (`walk_ctx`) to manage the cache tree traversal. The context
+ * includes pointers to functions (e.g., `read_before`, `read_overlap_tail`) that handle
+ * specific conditions encountered during the traversal. The `walk_finally` and `walk_done`
+ * functions manage the end stages of the traversal, while the `delete_key_list` and
+ * `submit_req_list` lists track any keys to be deleted or requests to be submitted.
+ *
+ * The function first calculates the requested range and checks if it fits within the
+ * current cache tree (based on the tree's size limits). It then locks the cache tree
+ * and performs a search to locate any matching keys. If there are outdated keys,
+ * these are deleted, and the search is restarted to ensure accurate data retrieval.
+ *
+ * If the requested range spans multiple cache trees, the function moves on to the
+ * next tree once the current range has been processed. This continues until the
+ * entire requested data length has been handled.
+ */
+static int cache_read(struct pcache_cache *cache, struct pcache_request *pcache_req)
+{
+	struct pcache_cache_key key_data = { .off = pcache_req->off, .len = pcache_req->data_len };
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key_tmp = NULL, *key_next;
+	struct rb_node *prev_node = NULL;
+	struct pcache_cache_key *key = &key_data;
+	struct pcache_cache_subtree_walk_ctx walk_ctx = { 0 };
+	struct pcache_backing_dev_req *backing_req, *next_req;
+	LIST_HEAD(delete_key_list);
+	LIST_HEAD(submit_req_list);
+	int ret;
+
+	walk_ctx.cache_tree = &cache->req_key_tree;
+	walk_ctx.req_done = 0;
+	walk_ctx.pcache_req = pcache_req;
+	walk_ctx.before = read_before;
+	walk_ctx.overlap_tail = read_overlap_tail;
+	walk_ctx.overlap_head = read_overlap_head;
+	walk_ctx.overlap_contain = read_overlap_contain;
+	walk_ctx.overlap_contained = read_overlap_contained;
+	walk_ctx.walk_finally = read_walk_finally;
+	walk_ctx.walk_done = read_walk_done;
+	walk_ctx.delete_key_list = &delete_key_list;
+	walk_ctx.submit_req_list = &submit_req_list;
+
+next:
+	key->off = pcache_req->off + walk_ctx.req_done;
+	key->len = pcache_req->data_len - walk_ctx.req_done;
+	if (key->len > PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK))
+		key->len = PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK);
+
+	cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+	spin_lock(&cache_subtree->tree_lock);
+search:
+	prev_node = cache_subtree_search(cache_subtree, key, NULL, NULL, &delete_key_list);
+	if (!list_empty(&delete_key_list)) {
+		list_for_each_entry_safe(key_tmp, key_next, &delete_key_list, list_node) {
+			list_del_init(&key_tmp->list_node);
+			cache_key_delete(key_tmp);
+		}
+		goto search;
+	}
+
+	walk_ctx.start_node = prev_node;
+	walk_ctx.key = key;
+
+	ret = cache_subtree_walk(&walk_ctx);
+	if (ret == SUBTREE_WALK_RET_RESEARCH)
+		goto search;
+	spin_unlock(&cache_subtree->tree_lock);
+
+	if (ret == SUBTREE_WALK_RET_ERR) {
+		ret = walk_ctx.ret;
+		goto out;
+	}
+
+	if (ret == SUBTREE_WALK_RET_NEED_REQ) {
+		walk_ctx.pre_alloc_req = cache_miss_req_alloc(cache, pcache_req, GFP_NOIO);
+		pcache_dev_debug(CACHE_TO_PCACHE(cache), "allocate pre_alloc_req with GFP_NOIO");
+	}
+
+	if (walk_ctx.req_done < pcache_req->data_len)
+		goto next;
+	ret = 0;
+out:
+	if (walk_ctx.pre_alloc_req)
+		cache_miss_req_free(walk_ctx.pre_alloc_req);
+
+	list_for_each_entry_safe(backing_req, next_req, &submit_req_list, node) {
+		list_del_init(&backing_req->node);
+		backing_dev_req_end(backing_req);
+	}
+
+	return ret;
+}
+
+static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache_req)
+{
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key;
+	u64 offset = pcache_req->off;
+	u32 length = pcache_req->data_len;
+	u32 io_done = 0;
+	int ret;
+
+	while (true) {
+		if (io_done >= length)
+			break;
+
+		key = cache_key_alloc(&cache->req_key_tree, GFP_NOIO);
+		key->off = offset + io_done;
+		key->len = length - io_done;
+		if (key->len > PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK))
+			key->len = PCACHE_CACHE_SUBTREE_SIZE - (key->off & PCACHE_CACHE_SUBTREE_SIZE_MASK);
+
+		ret = cache_data_alloc(cache, key);
+		if (ret) {
+			cache_key_put(key);
+			goto err;
+		}
+
+		ret = cache_copy_from_req_bio(cache, key, pcache_req, io_done);
+		if (ret) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_put(key);
+			goto err;
+		}
+
+		cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+		spin_lock(&cache_subtree->tree_lock);
+		cache_key_insert(&cache->req_key_tree, key, true);
+		ret = cache_key_append(cache, key, pcache_req->bio->bi_opf & REQ_FUA);
+		if (ret) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_delete(key);
+			goto unlock;
+		}
+
+		io_done += key->len;
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+
+	return 0;
+unlock:
+	spin_unlock(&cache_subtree->tree_lock);
+err:
+	return ret;
+}
+
+/**
+ * cache_flush - Flush all ksets to persist any pending cache data
+ * @cache: Pointer to the cache structure
+ *
+ * This function iterates through all ksets associated with the provided `cache`
+ * and ensures that any data marked for persistence is written to media. For each
+ * kset, it acquires the kset lock, then invokes `cache_kset_close`, which handles
+ * the persistence logic for that kset.
+ *
+ * If `cache_kset_close` encounters an error, the function exits immediately with
+ * the respective error code, preventing the flush operation from proceeding to
+ * subsequent ksets.
+ */
+int cache_flush(struct pcache_cache *cache)
+{
+	struct pcache_cache_kset *kset;
+	u32 i, ret;
+
+	for (i = 0; i < cache->n_ksets; i++) {
+		kset = get_kset(cache, i);
+
+		spin_lock(&kset->kset_lock);
+		ret = cache_kset_close(cache, kset);
+		spin_unlock(&kset->kset_lock);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req)
+{
+	struct bio *bio = pcache_req->bio;
+
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH))
+		return cache_flush(cache);
+
+	if (bio_data_dir(bio) == READ)
+		return cache_read(cache, pcache_req);
+
+	return cache_write(cache, pcache_req);
+}
diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
new file mode 100644
index 000000000000..8f9534ae04c3
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cache_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+#include "dm_pcache.h"
+
+static inline struct pcache_segment_info *get_seg_info_addr(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_segment_info *seg_info_addr;
+	u32 seg_id = cache_seg->segment.seg_id;
+	void *seg_addr;
+
+	seg_addr = CACHE_DEV_SEGMENT(cache_seg->cache->cache_dev, seg_id);
+	seg_info_addr = seg_addr + PCACHE_SEG_INFO_SIZE * cache_seg->info_index;
+
+	return seg_info_addr;
+}
+
+static void cache_seg_info_write(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_segment_info *seg_info_addr;
+	struct pcache_segment_info *seg_info = &cache_seg->cache_seg_info;
+
+	mutex_lock(&cache_seg->info_lock);
+	seg_info->header.seq++;
+	seg_info->header.crc = pcache_meta_crc(&seg_info->header, sizeof(struct pcache_segment_info));
+
+	seg_info_addr = get_seg_info_addr(cache_seg);
+	memcpy_flushcache(seg_info_addr, seg_info, sizeof(struct pcache_segment_info));
+	pmem_wmb();
+
+	cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;
+	mutex_unlock(&cache_seg->info_lock);
+}
+
+static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_segment_info *cache_seg_info_addr_base, *cache_seg_info_addr;
+	struct pcache_cache_dev *cache_dev = cache_seg->cache->cache_dev;
+	struct dm_pcache *pcache = CACHE_DEV_TO_PCACHE(cache_dev);
+	u32 seg_id = cache_seg->segment.seg_id;
+	int ret = 0;
+
+	cache_seg_info_addr_base = CACHE_DEV_SEGMENT(cache_dev, seg_id);
+
+	mutex_lock(&cache_seg->info_lock);
+	cache_seg_info_addr = pcache_meta_find_latest(&cache_seg_info_addr_base->header,
+						sizeof(struct pcache_segment_info),
+						PCACHE_SEG_INFO_SIZE,
+						&cache_seg->cache_seg_info);
+	if (IS_ERR(cache_seg_info_addr)) {
+		ret = PTR_ERR(cache_seg_info_addr);
+		goto out;
+	} else if (!cache_seg_info_addr) {
+		ret = -EIO;
+		goto out;
+	}
+	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
+out:
+	mutex_unlock(&cache_seg->info_lock);
+
+	if (ret)
+		pcache_dev_err(pcache, "can't read segment info of segment: %u, ret: %d\n",
+			      cache_seg->segment.seg_id, ret);
+	return ret;
+}
+
+static int cache_seg_ctrl_load(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+	struct pcache_cache_seg_gen cache_seg_gen, *cache_seg_gen_addr;
+	int ret = 0;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen_addr = pcache_meta_find_latest(&cache_seg_ctrl->gen->header,
+					     sizeof(struct pcache_cache_seg_gen),
+					     sizeof(struct pcache_cache_seg_gen),
+					     &cache_seg_gen);
+	if (IS_ERR(cache_seg_gen_addr)) {
+		ret = PTR_ERR(cache_seg_gen_addr);
+		goto out;
+	}
+
+	if (!cache_seg_gen_addr) {
+		cache_seg->gen = 0;
+		cache_seg->gen_seq = 0;
+		cache_seg->gen_index = 0;
+		goto out;
+	}
+
+	cache_seg->gen = cache_seg_gen.gen;
+	cache_seg->gen_seq = cache_seg_gen.header.seq;
+	cache_seg->gen_index = (cache_seg_gen_addr - cache_seg_ctrl->gen);
+out:
+	mutex_unlock(&cache_seg->ctrl_lock);
+
+	return ret;
+}
+
+static inline struct pcache_cache_seg_gen *get_cache_seg_gen_addr(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+
+	return (cache_seg_ctrl->gen + cache_seg->gen_index);
+}
+
+static void cache_seg_ctrl_write(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_gen cache_seg_gen;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen.gen = cache_seg->gen;
+	cache_seg_gen.header.seq = ++cache_seg->gen_seq;
+	cache_seg_gen.header.crc = pcache_meta_crc(&cache_seg_gen.header,
+						 sizeof(struct pcache_cache_seg_gen));
+
+	memcpy_flushcache(get_cache_seg_gen_addr(cache_seg), &cache_seg_gen, sizeof(struct pcache_cache_seg_gen));
+	pmem_wmb();
+
+	cache_seg->gen_index = (cache_seg->gen_index + 1) % PCACHE_META_INDEX_MAX;
+	mutex_unlock(&cache_seg->ctrl_lock);
+}
+
+static void cache_seg_ctrl_init(struct pcache_cache_segment *cache_seg)
+{
+	cache_seg->gen = 0;
+	cache_seg->gen_seq = 0;
+	cache_seg->gen_index = 0;
+	cache_seg_ctrl_write(cache_seg);
+}
+
+static int cache_seg_meta_load(struct pcache_cache_segment *cache_seg)
+{
+	int ret;
+
+	ret = cache_seg_info_load(cache_seg);
+	if (ret)
+		goto err;
+
+	ret = cache_seg_ctrl_load(cache_seg);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	return ret;
+}
+
+/**
+ * cache_seg_set_next_seg - Sets the ID of the next segment
+ * @cache_seg: Pointer to the cache segment structure.
+ * @seg_id: The segment ID to set as the next segment.
+ *
+ * A pcache_cache allocates multiple cache segments, which are linked together
+ * through next_seg. When loading a pcache_cache, the first cache segment can
+ * be found using cache->seg_id, which allows access to all the cache segments.
+ */
+void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id)
+{
+	cache_seg->cache_seg_info.flags |= PCACHE_SEG_INFO_FLAGS_HAS_NEXT;
+	cache_seg->cache_seg_info.next_seg = seg_id;
+	cache_seg_info_write(cache_seg);
+}
+
+int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache)
+{
+	struct pcache_cache_dev *cache_dev = cache->cache_dev;
+	struct pcache_cache_segment *cache_seg = &cache->segments[cache_seg_id];
+	struct pcache_segment_init_options seg_options = { 0 };
+	struct pcache_segment *segment = &cache_seg->segment;
+	int ret;
+
+	cache_seg->cache = cache;
+	cache_seg->cache_seg_id = cache_seg_id;
+	spin_lock_init(&cache_seg->gen_lock);
+	atomic_set(&cache_seg->refs, 0);
+	mutex_init(&cache_seg->info_lock);
+	mutex_init(&cache_seg->ctrl_lock);
+
+	/* init pcache_segment */
+	seg_options.type = PCACHE_SEGMENT_TYPE_CACHE_DATA;
+	seg_options.data_off = PCACHE_CACHE_SEG_CTRL_OFF + PCACHE_CACHE_SEG_CTRL_SIZE;
+	seg_options.seg_id = seg_id;
+	seg_options.seg_info = &cache_seg->cache_seg_info;
+	pcache_segment_init(cache_dev, segment, &seg_options);
+
+	cache_seg->cache_seg_ctrl = CACHE_DEV_SEGMENT(cache_dev, seg_id) + PCACHE_CACHE_SEG_CTRL_OFF;
+
+	if (new_cache) {
+		cache_dev_zero_range(cache_dev, CACHE_DEV_SEGMENT(cache_dev, seg_id),
+				     PCACHE_SEG_INFO_SIZE * PCACHE_META_INDEX_MAX +
+				     PCACHE_CACHE_SEG_CTRL_SIZE);
+
+		cache_seg_ctrl_init(cache_seg);
+
+		cache_seg->info_index = 0;
+		cache_seg_info_write(cache_seg);
+
+		/* clear outdated kset in segment */
+		memcpy_flushcache(segment->data, &pcache_empty_kset, sizeof(struct pcache_cache_kset_onmedia));
+		pmem_wmb();
+	} else {
+		ret = cache_seg_meta_load(cache_seg);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	return ret;
+}
+
+/**
+ * get_cache_segment - Retrieves a free cache segment from the cache.
+ * @cache: Pointer to the cache structure.
+ *
+ * This function attempts to find a free cache segment that can be used.
+ * It locks the segment map and checks for the next available segment ID.
+ * If a free segment is found, it initializes it and returns a pointer to the
+ * cache segment structure. Returns NULL if no segments are available.
+ */
+struct pcache_cache_segment *get_cache_segment(struct pcache_cache *cache)
+{
+	struct pcache_cache_segment *cache_seg;
+	u32 seg_id;
+
+	spin_lock(&cache->seg_map_lock);
+again:
+	seg_id = find_next_zero_bit(cache->seg_map, cache->n_segs, cache->last_cache_seg);
+	if (seg_id == cache->n_segs) {
+		/* reset the hint of ->last_cache_seg and retry */
+		if (cache->last_cache_seg) {
+			cache->last_cache_seg = 0;
+			goto again;
+		}
+		cache->cache_full = true;
+		spin_unlock(&cache->seg_map_lock);
+		return NULL;
+	}
+
+	/*
+	 * found an available cache_seg, mark it used in seg_map
+	 * and update the search hint ->last_cache_seg
+	 */
+	__set_bit(seg_id, cache->seg_map);
+	cache->last_cache_seg = seg_id;
+	spin_unlock(&cache->seg_map_lock);
+
+	cache_seg = &cache->segments[seg_id];
+	cache_seg->cache_seg_id = seg_id;
+
+	return cache_seg;
+}
+
+static void cache_seg_gen_increase(struct pcache_cache_segment *cache_seg)
+{
+	spin_lock(&cache_seg->gen_lock);
+	cache_seg->gen++;
+	spin_unlock(&cache_seg->gen_lock);
+
+	cache_seg_ctrl_write(cache_seg);
+}
+
+void cache_seg_get(struct pcache_cache_segment *cache_seg)
+{
+	atomic_inc(&cache_seg->refs);
+}
+
+static void cache_seg_invalidate(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache *cache;
+
+	cache = cache_seg->cache;
+	cache_seg_gen_increase(cache_seg);
+
+	spin_lock(&cache->seg_map_lock);
+	if (cache->cache_full)
+		cache->cache_full = false;
+	__clear_bit(cache_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+
+	pcache_defer_reqs_kick(CACHE_TO_PCACHE(cache));
+	/* clean_work will clean the bad key in key_tree*/
+	queue_work(cache_get_wq(cache), &cache->clean_work);
+}
+
+void cache_seg_put(struct pcache_cache_segment *cache_seg)
+{
+	if (atomic_dec_and_test(&cache_seg->refs))
+		cache_seg_invalidate(cache_seg);
+}
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
new file mode 100644
index 000000000000..e92fc4568074
--- /dev/null
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/bio.h>
+
+#include "cache.h"
+#include "backing_dev.h"
+#include "cache_dev.h"
+#include "dm_pcache.h"
+
+static void writeback_ctx_end(struct pcache_cache *cache, int ret)
+{
+	if (ret && !cache->writeback_ctx.ret) {
+		pcache_dev_err(CACHE_TO_PCACHE(cache), "writeback error: %d", ret);
+		cache->writeback_ctx.ret = ret;
+	}
+
+	if (!atomic_dec_and_test(&cache->writeback_ctx.pending))
+		return;
+
+	if (!cache->writeback_ctx.ret) {
+		backing_dev_flush(cache->backing_dev);
+
+		mutex_lock(&cache->dirty_tail_lock);
+		cache_pos_advance(&cache->dirty_tail, cache->writeback_ctx.advance);
+		cache_encode_dirty_tail(cache);
+		mutex_unlock(&cache->dirty_tail_lock);
+	}
+	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
+}
+
+static void writeback_end_req(struct pcache_backing_dev_req *backing_req, int ret)
+{
+	struct pcache_cache *cache = backing_req->priv_data;
+
+	mutex_lock(&cache->writeback_lock);
+	writeback_ctx_end(cache, ret);
+	mutex_unlock(&cache->writeback_lock);
+}
+
+static inline bool is_cache_clean(struct pcache_cache *cache, struct pcache_cache_pos *dirty_tail)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 to_copy;
+	void *addr;
+	int ret;
+
+	addr = cache_pos_addr(dirty_tail);
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->wb_kset_onmedia_buf;
+
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - dirty_tail->seg_off);
+	ret = copy_mc_to_kernel(kset_onmedia, addr, to_copy);
+	if (ret) {
+		pcache_dev_err(pcache, "error to read kset: %d", ret);
+		return true;
+	}
+
+	/* Check if the magic number matches the expected value */
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
+		pcache_dev_debug(pcache, "dirty_tail: %u:%u magic: %llx, not expected: %llx\n",
+				dirty_tail->cache_seg->cache_seg_id, dirty_tail->seg_off,
+				kset_onmedia->magic, PCACHE_KSET_MAGIC);
+		return true;
+	}
+
+	/* Verify the CRC checksum for data integrity */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		pcache_dev_debug(pcache, "dirty_tail: %u:%u crc: %x, not expected: %x\n",
+				dirty_tail->cache_seg->cache_seg_id, dirty_tail->seg_off,
+				cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return true;
+	}
+
+	return false;
+}
+
+void cache_writeback_exit(struct pcache_cache *cache)
+{
+	cancel_delayed_work_sync(&cache->writeback_work);
+	backing_dev_flush(cache->backing_dev);
+	cache_tree_exit(&cache->writeback_key_tree);
+}
+
+int cache_writeback_init(struct pcache_cache *cache)
+{
+	int ret;
+
+	ret = cache_tree_init(cache, &cache->writeback_key_tree, 1);
+	if (ret)
+		goto err;
+
+	atomic_set(&cache->writeback_ctx.pending, 0);
+
+	/* Queue delayed work to start writeback handling */
+	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
+
+	return 0;
+err:
+	return ret;
+}
+
+static void cache_key_writeback(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	struct pcache_backing_dev_req *writeback_req;
+	struct pcache_backing_dev_req_opts writeback_req_opts = { 0 };
+	struct pcache_cache_pos *pos;
+	void *addr;
+	u32 seg_remain;
+	u64 off;
+
+	if (cache_key_clean(key))
+		return;
+
+	pos = &key->cache_pos;
+
+	seg_remain = cache_seg_remain(pos);
+	BUG_ON(seg_remain < key->len);
+
+	addr = cache_pos_addr(pos);
+	off = key->off;
+
+	writeback_req_opts.type = BACKING_DEV_REQ_TYPE_KMEM;
+	writeback_req_opts.gfp_mask = GFP_NOIO;
+	writeback_req_opts.end_fn = writeback_end_req;
+	writeback_req_opts.priv_data = cache;
+
+	writeback_req_opts.kmem.data = addr;
+	writeback_req_opts.kmem.opf = REQ_OP_WRITE;
+	writeback_req_opts.kmem.len = key->len;
+	writeback_req_opts.kmem.backing_off = off;
+
+	writeback_req = backing_dev_req_create(cache->backing_dev, &writeback_req_opts);
+
+	atomic_inc(&cache->writeback_ctx.pending);
+	backing_dev_req_submit(writeback_req, true);
+}
+
+static void cache_wb_tree_writeback(struct pcache_cache *cache, u32 advance)
+{
+	struct pcache_cache_tree *cache_tree = &cache->writeback_key_tree;
+	struct pcache_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct pcache_cache_key *key;
+	u32 i;
+
+	cache->writeback_ctx.ret = 0;
+	cache->writeback_ctx.advance = advance;
+	atomic_set(&cache->writeback_ctx.pending, 1);
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		cache_subtree = &cache_tree->subtrees[i];
+
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+
+			cache_key_writeback(cache, key);
+			cache_key_delete(key);
+		}
+	}
+	writeback_ctx_end(cache, 0);
+}
+
+static int cache_kset_insert_tree(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_subtree *cache_subtree;
+	struct pcache_cache_key *key;
+	int ret;
+	u32 i;
+
+	/* Iterate through all keys in the kset and write each back to storage */
+	for (i = 0; i < kset_onmedia->key_num; i++) {
+		key_onmedia = &kset_onmedia->data[i];
+
+		key = cache_key_alloc(&cache->writeback_key_tree, GFP_NOIO);
+		ret = cache_key_decode(cache, key_onmedia, key);
+		if (ret) {
+			cache_key_put(key);
+			goto clear_tree;
+		}
+
+		cache_subtree = get_subtree(&cache->writeback_key_tree, key->off);
+		spin_lock(&cache_subtree->tree_lock);
+		cache_key_insert(&cache->writeback_key_tree, key, true);
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+
+	return 0;
+clear_tree:
+	cache_tree_clear(&cache->writeback_key_tree);
+	return ret;
+}
+
+static void last_kset_writeback(struct pcache_cache *cache,
+		struct pcache_cache_kset_onmedia *last_kset_onmedia)
+{
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_segment *next_seg;
+
+	pcache_dev_debug(pcache, "last kset, next: %u\n", last_kset_onmedia->next_cache_seg_id);
+
+	next_seg = &cache->segments[last_kset_onmedia->next_cache_seg_id];
+
+	mutex_lock(&cache->dirty_tail_lock);
+	cache->dirty_tail.cache_seg = next_seg;
+	cache->dirty_tail.seg_off = 0;
+	cache_encode_dirty_tail(cache);
+	mutex_unlock(&cache->dirty_tail_lock);
+}
+
+void cache_writeback_fn(struct work_struct *work)
+{
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, writeback_work.work);
+	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	struct pcache_cache_pos dirty_tail;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 delay;
+	int ret;
+
+	mutex_lock(&cache->writeback_lock);
+	if (atomic_read(&cache->writeback_ctx.pending))
+		goto unlock;
+
+	if (pcache_is_stopping(pcache))
+		goto unlock;
+
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->wb_kset_onmedia_buf;
+
+	mutex_lock(&cache->dirty_tail_lock);
+	cache_pos_copy(&dirty_tail, &cache->dirty_tail);
+	mutex_unlock(&cache->dirty_tail_lock);
+
+	if (is_cache_clean(cache, &dirty_tail)) {
+		delay = PCACHE_CACHE_WRITEBACK_INTERVAL;
+		goto queue_work;
+	}
+
+	if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+		last_kset_writeback(cache, kset_onmedia);
+		delay = 0;
+		goto queue_work;
+	}
+
+	ret = cache_kset_insert_tree(cache, kset_onmedia);
+	if (ret) {
+		delay = PCACHE_CACHE_WRITEBACK_INTERVAL;
+		goto queue_work;
+	}
+
+	cache_wb_tree_writeback(cache, get_kset_onmedia_size(kset_onmedia));
+	delay = 0;
+queue_work:
+	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, delay);
+unlock:
+	mutex_unlock(&cache->writeback_lock);
+}
diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
new file mode 100644
index 000000000000..e5f5936fa6f0
--- /dev/null
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -0,0 +1,497 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/module.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+
+#include "../dm-core.h"
+#include "cache_dev.h"
+#include "backing_dev.h"
+#include "cache.h"
+#include "dm_pcache.h"
+
+void pcache_defer_reqs_kick(struct dm_pcache *pcache)
+{
+	struct pcache_cache *cache = &pcache->cache;
+
+	spin_lock(&cache->seg_map_lock);
+	if (!cache->cache_full)
+		queue_work(pcache->task_wq, &pcache->defered_req_work);
+	spin_unlock(&cache->seg_map_lock);
+}
+
+static void defer_req(struct pcache_request *pcache_req)
+{
+	struct dm_pcache *pcache = pcache_req->pcache;
+
+	BUG_ON(!list_empty(&pcache_req->list_node));
+
+	spin_lock(&pcache->defered_req_list_lock);
+	list_add(&pcache_req->list_node, &pcache->defered_req_list);
+	pcache_defer_reqs_kick(pcache);
+	spin_unlock(&pcache->defered_req_list_lock);
+}
+
+static void defered_req_fn(struct work_struct *work)
+{
+	struct dm_pcache *pcache = container_of(work, struct dm_pcache, defered_req_work);
+	struct pcache_request *pcache_req;
+	LIST_HEAD(tmp_list);
+	int ret;
+
+	if (pcache_is_stopping(pcache))
+		return;
+
+	spin_lock(&pcache->defered_req_list_lock);
+	list_splice_init(&pcache->defered_req_list, &tmp_list);
+	spin_unlock(&pcache->defered_req_list_lock);
+
+	while (!list_empty(&tmp_list)) {
+		pcache_req = list_first_entry(&tmp_list,
+					    struct pcache_request, list_node);
+		list_del_init(&pcache_req->list_node);
+		pcache_req->ret = 0;
+		ret = pcache_cache_handle_req(&pcache->cache, pcache_req);
+		if (ret == -EBUSY)
+			defer_req(pcache_req);
+		else
+			pcache_req_put(pcache_req, ret);
+	}
+}
+
+void pcache_req_get(struct pcache_request *pcache_req)
+{
+	kref_get(&pcache_req->ref);
+}
+
+static void end_req(struct kref *ref)
+{
+	struct pcache_request *pcache_req = container_of(ref, struct pcache_request, ref);
+	struct dm_pcache *pcache = pcache_req->pcache;
+	struct bio *bio = pcache_req->bio;
+	int ret = pcache_req->ret;
+
+	if (ret == -EBUSY) {
+		pcache_req_get(pcache_req);
+		defer_req(pcache_req);
+	} else {
+		bio->bi_status = errno_to_blk_status(ret);
+		bio_endio(bio);
+
+		if (atomic_dec_and_test(&pcache->inflight_reqs))
+			wake_up(&pcache->inflight_wq);
+	}
+}
+
+void pcache_req_put(struct pcache_request *pcache_req, int ret)
+{
+	/* Set the return status if it is not already set */
+	if (ret && !pcache_req->ret)
+		pcache_req->ret = ret;
+
+	kref_put(&pcache_req->ref, end_req);
+}
+
+static bool at_least_one_arg(struct dm_arg_set *as, char **error)
+{
+	if (!as->argc) {
+		*error = "Insufficient args";
+		return false;
+	}
+
+	return true;
+}
+
+static int parse_cache_dev(struct dm_pcache *pcache, struct dm_arg_set *as,
+				char **error)
+{
+	int ret;
+
+	if (!at_least_one_arg(as, error))
+		return -EINVAL;
+	ret = dm_get_device(pcache->ti, dm_shift_arg(as),
+			  BLK_OPEN_READ | BLK_OPEN_WRITE,
+			  &pcache->cache_dev.dm_dev);
+	if (ret) {
+		*error = "Error opening cache device";
+		return ret;
+	}
+
+	return 0;
+}
+
+static int parse_backing_dev(struct dm_pcache *pcache, struct dm_arg_set *as,
+				char **error)
+{
+	int ret;
+
+	if (!at_least_one_arg(as, error))
+		return -EINVAL;
+
+	ret = dm_get_device(pcache->ti, dm_shift_arg(as),
+			  BLK_OPEN_READ | BLK_OPEN_WRITE,
+			  &pcache->backing_dev.dm_dev);
+	if (ret) {
+		*error = "Error opening backing device";
+		return ret;
+	}
+
+	return 0;
+}
+
+static void pcache_init_opts(struct pcache_cache_options *opts)
+{
+	opts->cache_mode = PCACHE_CACHE_MODE_WRITEBACK;
+	opts->data_crc = false;
+}
+
+static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
+			    char **error)
+{
+	struct pcache_cache_options *opts = &pcache->opts;
+	static const struct dm_arg _args[] = {
+		{0, 4, "Invalid number of cache option arguments"},
+	};
+	unsigned int argc;
+	const char *arg;
+	int ret;
+
+	pcache_init_opts(opts);
+	if (!as->argc)
+		return 0;
+
+	ret = dm_read_arg_group(_args, as, &argc, error);
+	if (ret)
+		return -EINVAL;
+
+	while (argc) {
+		arg = dm_shift_arg(as);
+		argc--;
+
+		if (!strcmp(arg, "cache_mode")) {
+			arg = dm_shift_arg(as);
+			if (!strcmp(arg, "writeback")) {
+				opts->cache_mode = PCACHE_CACHE_MODE_WRITEBACK;
+			} else {
+				*error = "Invalid cache mode parameter";
+				return -EINVAL;
+			}
+			argc--;
+		} else if (!strcmp(arg, "data_crc")) {
+			arg = dm_shift_arg(as);
+			if (!strcmp(arg, "true")) {
+				opts->data_crc = true;
+			} else if (!strcmp(arg, "false")) {
+				opts->data_crc = false;
+			} else {
+				*error = "Invalid data crc parameter";
+				return -EINVAL;
+			}
+			argc--;
+		} else {
+			*error = "Unrecognised cache option requested";
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int pcache_start(struct dm_pcache *pcache, char **error)
+{
+	int ret;
+
+	ret = cache_dev_start(pcache);
+	if (ret) {
+		*error = "Failed to start cache dev";
+		return ret;
+	}
+
+	ret = backing_dev_start(pcache);
+	if (ret) {
+		*error = "Failed to start backing dev";
+		goto stop_cache;
+	}
+
+	ret = pcache_cache_start(pcache);
+	if (ret) {
+		*error = "Failed to start pcache";
+		goto stop_backing;
+	}
+
+	return 0;
+stop_backing:
+	backing_dev_stop(pcache);
+stop_cache:
+	cache_dev_stop(pcache);
+
+	return ret;
+}
+
+static void pcache_destroy_args(struct dm_pcache *pcache)
+{
+	if (pcache->cache_dev.dm_dev)
+		dm_put_device(pcache->ti, pcache->cache_dev.dm_dev);
+	if (pcache->backing_dev.dm_dev)
+		dm_put_device(pcache->ti, pcache->backing_dev.dm_dev);
+}
+
+static int pcache_parse_args(struct dm_pcache *pcache, unsigned int argc, char **argv,
+				char **error)
+{
+	struct dm_arg_set as;
+	int ret;
+
+	as.argc = argc;
+	as.argv = argv;
+
+	/*
+	 * Parse cache device
+	 */
+	ret = parse_cache_dev(pcache, &as, error);
+	if (ret)
+		return ret;
+	/*
+	 * Parse backing device
+	 */
+	ret = parse_backing_dev(pcache, &as, error);
+	if (ret)
+		goto out;
+	/*
+	 * Parse optional arguments
+	 */
+	ret = parse_cache_opts(pcache, &as, error);
+	if (ret)
+		goto out;
+
+	return 0;
+out:
+	pcache_destroy_args(pcache);
+	return ret;
+}
+
+static int dm_pcache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct mapped_device *md = ti->table->md;
+	struct dm_pcache *pcache;
+	int ret;
+
+	if (md->map) {
+		ti->error = "Don't support table loading for live md";
+		return -EOPNOTSUPP;
+	}
+
+	/* Allocate memory for the cache structure */
+	pcache = kzalloc(sizeof(struct dm_pcache), GFP_KERNEL);
+	if (!pcache)
+		return -ENOMEM;
+
+	pcache->task_wq = alloc_workqueue("pcache-%s-wq",  WQ_UNBOUND | WQ_MEM_RECLAIM,
+					  0, md->name);
+	if (!pcache->task_wq) {
+		ret = -ENOMEM;
+		goto free_pcache;
+	}
+
+	spin_lock_init(&pcache->defered_req_list_lock);
+	INIT_LIST_HEAD(&pcache->defered_req_list);
+	INIT_WORK(&pcache->defered_req_work, defered_req_fn);
+	pcache->ti = ti;
+
+	ret = pcache_parse_args(pcache, argc, argv, &ti->error);
+	if (ret)
+		goto destroy_wq;
+
+	ret = pcache_start(pcache, &ti->error);
+	if (ret)
+		goto destroy_args;
+
+	ti->num_flush_bios = 1;
+	ti->flush_supported = true;
+	ti->per_io_data_size = sizeof(struct pcache_request);
+	ti->private = pcache;
+	atomic_set(&pcache->inflight_reqs, 0);
+	atomic_set(&pcache->state, PCACHE_STATE_RUNNING);
+	init_waitqueue_head(&pcache->inflight_wq);
+
+	return 0;
+destroy_args:
+	pcache_destroy_args(pcache);
+destroy_wq:
+	destroy_workqueue(pcache->task_wq);
+free_pcache:
+	kfree(pcache);
+
+	return ret;
+}
+
+static void defer_req_stop(struct dm_pcache *pcache)
+{
+	struct pcache_request *pcache_req;
+	LIST_HEAD(tmp_list);
+
+	flush_work(&pcache->defered_req_work);
+
+	spin_lock(&pcache->defered_req_list_lock);
+	list_splice_init(&pcache->defered_req_list, &tmp_list);
+	spin_unlock(&pcache->defered_req_list_lock);
+
+	while (!list_empty(&tmp_list)) {
+		pcache_req = list_first_entry(&tmp_list,
+					    struct pcache_request, list_node);
+		list_del_init(&pcache_req->list_node);
+		pcache_req_put(pcache_req, -EIO);
+	}
+}
+
+static void dm_pcache_dtr(struct dm_target *ti)
+{
+	struct dm_pcache *pcache;
+
+	pcache = ti->private;
+	atomic_set(&pcache->state, PCACHE_STATE_STOPPING);
+	defer_req_stop(pcache);
+
+	wait_event(pcache->inflight_wq,
+			atomic_read(&pcache->inflight_reqs) == 0);
+
+	pcache_cache_stop(pcache);
+	backing_dev_stop(pcache);
+	cache_dev_stop(pcache);
+
+	pcache_destroy_args(pcache);
+	drain_workqueue(pcache->task_wq);
+	destroy_workqueue(pcache->task_wq);
+
+	kfree(pcache);
+}
+
+static int dm_pcache_map_bio(struct dm_target *ti, struct bio *bio)
+{
+	struct pcache_request *pcache_req = dm_per_bio_data(bio, sizeof(struct pcache_request));
+	struct dm_pcache *pcache = ti->private;
+	int ret;
+
+	pcache_req->pcache = pcache;
+	kref_init(&pcache_req->ref);
+	pcache_req->ret = 0;
+	pcache_req->bio = bio;
+	pcache_req->off = (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	pcache_req->data_len = bio->bi_iter.bi_size;
+	INIT_LIST_HEAD(&pcache_req->list_node);
+	atomic_inc(&pcache->inflight_reqs);
+
+	ret = pcache_cache_handle_req(&pcache->cache, pcache_req);
+	if (ret == -EBUSY)
+		defer_req(pcache_req);
+	else
+		pcache_req_put(pcache_req, ret);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static void dm_pcache_status(struct dm_target *ti, status_type_t type,
+			     unsigned int status_flags, char *result,
+			     unsigned int maxlen)
+{
+	struct dm_pcache *pcache = ti->private;
+	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
+	struct pcache_backing_dev *backing_dev = &pcache->backing_dev;
+	struct pcache_cache *cache = &pcache->cache;
+	unsigned int sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%x %u %u %u %u %x %u:%u %u:%u %u:%u",
+		       cache_dev->sb_flags,
+		       cache_dev->seg_num,
+		       cache->n_segs,
+		       bitmap_weight(cache->seg_map, cache->n_segs),
+		       pcache_cache_get_gc_percent(cache),
+		       cache->cache_info.flags,
+		       cache->key_head.cache_seg->cache_seg_id,
+		       cache->key_head.seg_off,
+		       cache->dirty_tail.cache_seg->cache_seg_id,
+		       cache->dirty_tail.seg_off,
+		       cache->key_tail.cache_seg->cache_seg_id,
+		       cache->key_tail.seg_off);
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %s 4 cache_mode writeback crc %s",
+		       cache_dev->dm_dev->name,
+		       backing_dev->dm_dev->name,
+		       cache_data_crc_on(cache) ? "true" : "false");
+		break;
+	case STATUSTYPE_IMA:
+		*result = '\0';
+		break;
+	}
+}
+
+static int dm_pcache_message(struct dm_target *ti, unsigned int argc,
+			     char **argv, char *result, unsigned int maxlen)
+{
+	struct dm_pcache *pcache = ti->private;
+	unsigned long val;
+
+	if (argc != 2)
+		goto err;
+
+	if (!strcasecmp(argv[0], "gc_percent")) {
+		if (kstrtoul(argv[1], 10, &val))
+			goto err;
+
+		return pcache_cache_set_gc_percent(&pcache->cache, val);
+	}
+err:
+	return -EINVAL;
+}
+
+static struct target_type dm_pcache_target = {
+	.name		= "pcache",
+	.version	= {0, 1, 0},
+	.module		= THIS_MODULE,
+	.features	= DM_TARGET_SINGLETON,
+	.ctr		= dm_pcache_ctr,
+	.dtr		= dm_pcache_dtr,
+	.map		= dm_pcache_map_bio,
+	.status		= dm_pcache_status,
+	.message	= dm_pcache_message,
+};
+
+static int __init dm_pcache_init(void)
+{
+	int ret;
+
+	ret = pcache_backing_init();
+	if (ret)
+		goto err;
+
+	ret = pcache_cache_init();
+	if (ret)
+		goto backing_exit;
+
+	ret = dm_register_target(&dm_pcache_target);
+	if (ret)
+		goto cache_exit;
+	return 0;
+
+cache_exit:
+	pcache_cache_exit();
+backing_exit:
+	pcache_backing_exit();
+err:
+	return ret;
+}
+module_init(dm_pcache_init);
+
+static void __exit dm_pcache_exit(void)
+{
+	dm_unregister_target(&dm_pcache_target);
+	pcache_cache_exit();
+	pcache_backing_exit();
+}
+module_exit(dm_pcache_exit);
+
+MODULE_DESCRIPTION("dm-pcache Persistent Cache for block device");
+MODULE_AUTHOR("Dongsheng Yang <dongsheng.yang@linux.dev>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm-pcache/dm_pcache.h b/drivers/md/dm-pcache/dm_pcache.h
new file mode 100644
index 000000000000..b4e06be0c0b9
--- /dev/null
+++ b/drivers/md/dm-pcache/dm_pcache.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _DM_PCACHE_H
+#define _DM_PCACHE_H
+#include <linux/device-mapper.h>
+
+#include "../dm-core.h"
+
+#define CACHE_DEV_TO_PCACHE(cache_dev)		(container_of(cache_dev, struct dm_pcache, cache_dev))
+#define BACKING_DEV_TO_PCACHE(backing_dev)	(container_of(backing_dev, struct dm_pcache, backing_dev))
+#define CACHE_TO_PCACHE(cache)			(container_of(cache, struct dm_pcache, cache))
+
+#define PCACHE_STATE_RUNNING			1
+#define PCACHE_STATE_STOPPING			2
+
+struct pcache_cache_dev;
+struct pcache_backing_dev;
+struct pcache_cache;
+struct pcache_cache_options;
+struct dm_pcache {
+	struct dm_target *ti;
+	struct pcache_cache_dev cache_dev;
+	struct pcache_backing_dev backing_dev;
+	struct pcache_cache cache;
+	struct pcache_cache_options opts;
+
+	spinlock_t			defered_req_list_lock;
+	struct list_head		defered_req_list;
+	struct workqueue_struct		*task_wq;
+
+	struct work_struct		defered_req_work;
+
+	atomic_t			state;
+	atomic_t			inflight_reqs;
+	wait_queue_head_t		inflight_wq;
+};
+
+static inline bool pcache_is_stopping(struct dm_pcache *pcache)
+{
+	return (atomic_read(&pcache->state) == PCACHE_STATE_STOPPING);
+}
+
+#define pcache_dev_err(pcache, fmt, ...)							\
+	pcache_err("%s " fmt, pcache->ti->table->md->name, ##__VA_ARGS__)
+#define pcache_dev_info(pcache, fmt, ...)							\
+	pcache_info("%s " fmt, pcache->ti->table->md->name, ##__VA_ARGS__)
+#define pcache_dev_debug(pcache, fmt, ...)							\
+	pcache_debug("%s " fmt, pcache->ti->table->md->name, ##__VA_ARGS__)
+
+struct pcache_request {
+	struct dm_pcache	*pcache;
+	struct bio		*bio;
+
+	u64			off;
+	u32			data_len;
+
+	struct kref		ref;
+	int			ret;
+
+	struct list_head	list_node;
+};
+
+void pcache_req_get(struct pcache_request *pcache_req);
+void pcache_req_put(struct pcache_request *pcache_req, int ret);
+
+void pcache_defer_reqs_kick(struct dm_pcache *pcache);
+
+#endif /* _DM_PCACHE_H */
diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
new file mode 100644
index 000000000000..d427e534727c
--- /dev/null
+++ b/drivers/md/dm-pcache/pcache_internal.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_INTERNAL_H
+#define _PCACHE_INTERNAL_H
+
+#include <linux/delay.h>
+#include <linux/crc32c.h>
+
+#define pcache_err(fmt, ...)							\
+	pr_err("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define pcache_info(fmt, ...)							\
+	pr_info("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define pcache_debug(fmt, ...)							\
+	pr_debug("dm-pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+
+#define PCACHE_KB			(1024ULL)
+#define PCACHE_MB			(1024 * PCACHE_KB)
+
+/* Maximum number of metadata indices */
+#define PCACHE_META_INDEX_MAX		2
+
+#define PCACHE_CRC_SEED			0x3B15A
+/*
+ * struct pcache_meta_header - PCACHE metadata header structure
+ * @crc: CRC checksum for validating metadata integrity.
+ * @seq: Sequence number to track metadata updates.
+ * @version: Metadata version.
+ * @res: Reserved space for future use.
+ */
+struct pcache_meta_header {
+	__u32 crc;
+	__u8  seq;
+	__u8  version;
+	__u16 res;
+};
+
+/*
+ * pcache_meta_crc - Calculate CRC for the given metadata header.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of the metadata structure.
+ *
+ * Returns the CRC checksum calculated by excluding the CRC field itself.
+ */
+static inline u32 pcache_meta_crc(struct pcache_meta_header *header, u32 meta_size)
+{
+	return crc32c(PCACHE_CRC_SEED, (void *)header + 4, meta_size - 4);
+}
+
+/*
+ * pcache_meta_seq_after - Check if a sequence number is more recent, accounting for overflow.
+ * @seq1: First sequence number.
+ * @seq2: Second sequence number.
+ *
+ * Determines if @seq1 is more recent than @seq2 by calculating the signed
+ * difference between them. This approach allows handling sequence number
+ * overflow correctly because the difference wraps naturally, and any value
+ * greater than zero indicates that @seq1 is "after" @seq2. This method
+ * assumes 8-bit unsigned sequence numbers, where the difference wraps
+ * around if seq1 overflows past seq2.
+ *
+ * Returns:
+ *   - true if @seq1 is more recent than @seq2, indicating it comes "after"
+ *   - false otherwise.
+ */
+static inline bool pcache_meta_seq_after(u8 seq1, u8 seq2)
+{
+	return (s8)(seq1 - seq2) > 0;
+}
+
+/*
+ * pcache_meta_find_latest - Find the latest valid metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Finds the latest valid metadata by checking sequence numbers. If a
+ * valid entry with the highest sequence number is found, its pointer
+ * is returned. Returns NULL if no valid metadata is found.
+ */
+static inline void __must_check *pcache_meta_find_latest(struct pcache_meta_header *header,
+					u32 meta_size, u32 meta_max_size,
+					void *meta_ret)
+{
+	struct pcache_meta_header *meta, *latest = NULL;
+	u32 i, seq_latest = 0;
+	void *meta_addr;
+
+	meta = meta_ret;
+
+	for (i = 0; i < PCACHE_META_INDEX_MAX; i++) {
+		meta_addr = (void *)header + (i * meta_max_size);
+		if (copy_mc_to_kernel(meta, meta_addr, meta_size)) {
+			pcache_err("hardware memory error when copy meta");
+			return ERR_PTR(-EIO);
+		}
+
+		/* Skip if CRC check fails, which means corrupted */
+		if (meta->crc != pcache_meta_crc(meta, meta_size))
+			continue;
+
+		/* Update latest if a more recent sequence is found */
+		if (!latest || pcache_meta_seq_after(meta->seq, seq_latest)) {
+			seq_latest = meta->seq;
+			latest = (void *)header + (i * meta_max_size);
+		}
+	}
+
+	if (!latest)
+		return NULL;
+
+	if (copy_mc_to_kernel(meta_ret, latest, meta_size)) {
+		pcache_err("hardware memory error");
+		return ERR_PTR(-EIO);
+	}
+
+	return latest;
+}
+
+#endif /* _PCACHE_INTERNAL_H */
diff --git a/drivers/md/dm-pcache/segment.c b/drivers/md/dm-pcache/segment.c
new file mode 100644
index 000000000000..7e9818701445
--- /dev/null
+++ b/drivers/md/dm-pcache/segment.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/dax.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "segment.h"
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct iov_iter iter;
+	size_t copied;
+	void *src;
+
+	iov_iter_bvec(&iter, ITER_DEST, &bio->bi_io_vec[bio->bi_iter.bi_idx],
+			bio_segments(bio), bio->bi_iter.bi_size);
+	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	if (bio_off)
+		iov_iter_advance(&iter, bio_off);
+
+	src = segment->data + data_off;
+	copied = _copy_mc_to_iter(src, data_len, &iter);
+	if (copied != data_len)
+		return -EIO;
+
+	return 0;
+}
+
+int segment_copy_from_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct iov_iter iter;
+	size_t copied;
+	void *dst;
+
+	iov_iter_bvec(&iter, ITER_SOURCE, &bio->bi_io_vec[bio->bi_iter.bi_idx],
+			bio_segments(bio), bio->bi_iter.bi_size);
+	iter.iov_offset = bio->bi_iter.bi_bvec_done;
+	if (bio_off)
+		iov_iter_advance(&iter, bio_off);
+
+	dst = segment->data + data_off;
+	copied = _copy_from_iter_flushcache(dst, data_len, &iter);
+	if (copied != data_len)
+		return -EIO;
+	pmem_wmb();
+
+	return 0;
+}
+
+void pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options)
+{
+	segment->seg_info = options->seg_info;
+	segment_info_set_type(segment->seg_info, options->type);
+
+	segment->cache_dev = cache_dev;
+	segment->seg_id = options->seg_id;
+	segment->data_size = PCACHE_SEG_SIZE - options->data_off;
+	segment->data = CACHE_DEV_SEGMENT(cache_dev, options->seg_id) + options->data_off;
+}
diff --git a/drivers/md/dm-pcache/segment.h b/drivers/md/dm-pcache/segment.h
new file mode 100644
index 000000000000..deca1ddcb02b
--- /dev/null
+++ b/drivers/md/dm-pcache/segment.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_SEGMENT_H
+#define _PCACHE_SEGMENT_H
+
+#include <linux/bio.h>
+#include <linux/bitfield.h>
+
+#include "pcache_internal.h"
+
+struct pcache_segment_info {
+	struct pcache_meta_header	header;
+	__u32			flags;
+	__u32			next_seg;
+};
+
+#define PCACHE_SEG_INFO_FLAGS_HAS_NEXT		BIT(0)
+
+#define PCACHE_SEG_INFO_FLAGS_TYPE_MASK         GENMASK(4, 1)
+#define PCACHE_SEGMENT_TYPE_CACHE_DATA		1
+
+static inline bool segment_info_has_next(struct pcache_segment_info *seg_info)
+{
+	return (seg_info->flags & PCACHE_SEG_INFO_FLAGS_HAS_NEXT);
+}
+
+static inline void segment_info_set_type(struct pcache_segment_info *seg_info, u8 type)
+{
+	seg_info->flags &= ~PCACHE_SEG_INFO_FLAGS_TYPE_MASK;
+	seg_info->flags |= FIELD_PREP(PCACHE_SEG_INFO_FLAGS_TYPE_MASK, type);
+}
+
+static inline u8 segment_info_get_type(struct pcache_segment_info *seg_info)
+{
+	return FIELD_GET(PCACHE_SEG_INFO_FLAGS_TYPE_MASK, seg_info->flags);
+}
+
+struct pcache_segment_pos {
+	struct pcache_segment	*segment;	/* Segment associated with the position */
+	u32			off;		/* Offset within the segment */
+};
+
+struct pcache_segment_init_options {
+	u8			type;
+	u32			seg_id;
+	u32			data_off;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+struct pcache_segment {
+	struct pcache_cache_dev	*cache_dev;
+
+	void			*data;
+	u32			data_size;
+	u32			seg_id;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		      u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+int segment_copy_from_bio(struct pcache_segment *segment,
+			u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+
+static inline void segment_pos_advance(struct pcache_segment_pos *seg_pos, u32 len)
+{
+	BUG_ON(seg_pos->off + len > seg_pos->segment->data_size);
+
+	seg_pos->off += len;
+}
+
+void pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options);
+#endif /* _PCACHE_SEGMENT_H */
-- 
2.43.0

