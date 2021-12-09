Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A058C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  9 Dec 2021 07:01:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-Ae9IlAWRNnOjwTBWIvg_zw-1; Thu, 09 Dec 2021 02:01:50 -0500
X-MC-Unique: Ae9IlAWRNnOjwTBWIvg_zw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D05C36393;
	Thu,  9 Dec 2021 07:01:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FAE445D7D;
	Thu,  9 Dec 2021 07:01:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8985D1809CB8;
	Thu,  9 Dec 2021 07:01:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B96xJZX015176 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 9 Dec 2021 01:59:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 917B214171FE; Thu,  9 Dec 2021 06:59:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CAFE14171FD
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 06:59:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E5633C00138
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 06:59:19 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-575-9ccVrSjGMS-Z4SqN5clG8g-1; Thu, 09 Dec 2021 01:59:17 -0500
X-MC-Unique: 9ccVrSjGMS-Z4SqN5clG8g-1
Received: from [2001:4bb8:180:a1c8:2d0e:135:af53:41f8] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mvD4b-0096hm-Jx; Thu, 09 Dec 2021 06:38:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Date: Thu,  9 Dec 2021 07:38:27 +0100
Message-Id: <20211209063828.18944-5-hch@lst.de>
In-Reply-To: <20211209063828.18944-1-hch@lst.de>
References: <20211209063828.18944-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH 4/5] dax: remove the copy_from_iter and
	copy_to_iter methods
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

These methods indirect the actual DAX read/write path.  In the end pmem
uses magic flush and mc safe variants and fuse and dcssblk use plain ones
while device mapper picks redirects to the underlying device.

Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
special variants, then use them everywhere as they fall back to the plain
ones on s390 anyway and remove an indirect call from the read/write path
as well as a lot of boilerplate code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/dax/super.c           | 36 ++++++++++++++--
 drivers/md/dm-linear.c        | 20 ---------
 drivers/md/dm-log-writes.c    | 80 -----------------------------------
 drivers/md/dm-stripe.c        | 20 ---------
 drivers/md/dm.c               | 50 ----------------------
 drivers/nvdimm/pmem.c         | 20 ---------
 drivers/s390/block/dcssblk.c  | 14 ------
 fs/dax.c                      |  5 ---
 fs/fuse/virtio_fs.c           | 19 +--------
 include/linux/dax.h           |  9 ++--
 include/linux/device-mapper.h |  4 --
 11 files changed, 37 insertions(+), 240 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index e81d5ee57390f..ff676a07480c8 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -105,6 +105,10 @@ enum dax_device_flags {
 	DAXDEV_WRITE_CACHE,
 	/* flag to check if device supports synchronous flush */
 	DAXDEV_SYNC,
+	/* do not use uncached operations to write data */
+	DAXDEV_CACHED,
+	/* do not use mcsafe operations to read data */
+	DAXDEV_NOMCSAFE,
 };
 
 /**
@@ -146,9 +150,15 @@ size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 	if (!dax_alive(dax_dev))
 		return 0;
 
-	return dax_dev->ops->copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+	/*
+	 * The userspace address for the memory copy has already been validated
+	 * via access_ok() in vfs_write, so use the 'no check' version to bypass
+	 * the HARDENED_USERCOPY overhead.
+	 */
+	if (test_bit(DAXDEV_CACHED, &dax_dev->flags))
+		return _copy_from_iter(addr, bytes, i);
+	return _copy_from_iter_flushcache(addr, bytes, i);
 }
-EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 
 size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i)
@@ -156,9 +166,15 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
 	if (!dax_alive(dax_dev))
 		return 0;
 
-	return dax_dev->ops->copy_to_iter(dax_dev, pgoff, addr, bytes, i);
+	/*
+	 * The userspace address for the memory copy has already been validated
+	 * via access_ok() in vfs_red, so use the 'no check' version to bypass
+	 * the HARDENED_USERCOPY overhead.
+	 */
+	if (test_bit(DAXDEV_NOMCSAFE, &dax_dev->flags))
+		return _copy_to_iter(addr, bytes, i);
+	return _copy_mc_to_iter(addr, bytes, i);
 }
-EXPORT_SYMBOL_GPL(dax_copy_to_iter);
 
 int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 			size_t nr_pages)
@@ -220,6 +236,18 @@ void set_dax_synchronous(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(set_dax_synchronous);
 
+void set_dax_cached(struct dax_device *dax_dev)
+{
+	set_bit(DAXDEV_CACHED, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(set_dax_cached);
+
+void set_dax_nomcsafe(struct dax_device *dax_dev)
+{
+	set_bit(DAXDEV_NOMCSAFE, &dax_dev->flags);
+}
+EXPORT_SYMBOL_GPL(set_dax_nomcsafe);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 90de42f6743ac..1b97a11d71517 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -180,22 +180,6 @@ static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
-static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
-
-	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
-static size_t linear_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
-
-	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
 static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 				      size_t nr_pages)
 {
@@ -206,8 +190,6 @@ static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 
 #else
 #define linear_dax_direct_access NULL
-#define linear_dax_copy_from_iter NULL
-#define linear_dax_copy_to_iter NULL
 #define linear_dax_zero_page_range NULL
 #endif
 
@@ -225,8 +207,6 @@ static struct target_type linear_target = {
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_dax_direct_access,
-	.dax_copy_from_iter = linear_dax_copy_from_iter,
-	.dax_copy_to_iter = linear_dax_copy_to_iter,
 	.dax_zero_page_range = linear_dax_zero_page_range,
 };
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index cdb22e7a1d0da..139b09b06eda9 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -902,51 +902,6 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 }
 
 #if IS_ENABLED(CONFIG_FS_DAX)
-static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
-		   struct iov_iter *i)
-{
-	struct pending_block *block;
-
-	if (!bytes)
-		return 0;
-
-	block = kzalloc(sizeof(struct pending_block), GFP_KERNEL);
-	if (!block) {
-		DMERR("Error allocating dax pending block");
-		return -ENOMEM;
-	}
-
-	block->data = kzalloc(bytes, GFP_KERNEL);
-	if (!block->data) {
-		DMERR("Error allocating dax data space");
-		kfree(block);
-		return -ENOMEM;
-	}
-
-	/* write data provided via the iterator */
-	if (!copy_from_iter(block->data, bytes, i)) {
-		DMERR("Error copying dax data");
-		kfree(block->data);
-		kfree(block);
-		return -EIO;
-	}
-
-	/* rewind the iterator so that the block driver can use it */
-	iov_iter_revert(i, bytes);
-
-	block->datalen = bytes;
-	block->sector = bio_to_dev_sectors(lc, sector);
-	block->nr_sectors = ALIGN(bytes, lc->sectorsize) >> lc->sectorshift;
-
-	atomic_inc(&lc->pending_blocks);
-	spin_lock_irq(&lc->blocks_lock);
-	list_add_tail(&block->list, &lc->unflushed_blocks);
-	spin_unlock_irq(&lc->blocks_lock);
-	wake_up_process(lc->log_kthread);
-
-	return 0;
-}
-
 static struct dax_device *log_writes_dax_pgoff(struct dm_target *ti,
 		pgoff_t *pgoff)
 {
@@ -964,37 +919,6 @@ static long log_writes_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
-static size_t log_writes_dax_copy_from_iter(struct dm_target *ti,
-					    pgoff_t pgoff, void *addr, size_t bytes,
-					    struct iov_iter *i)
-{
-	struct log_writes_c *lc = ti->private;
-	sector_t sector = pgoff * PAGE_SECTORS;
-	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
-	int err;
-
-	/* Don't bother doing anything if logging has been disabled */
-	if (!lc->logging_enabled)
-		goto dax_copy;
-
-	err = log_dax(lc, sector, bytes, i);
-	if (err) {
-		DMWARN("Error %d logging DAX write", err);
-		return 0;
-	}
-dax_copy:
-	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
-static size_t log_writes_dax_copy_to_iter(struct dm_target *ti,
-					  pgoff_t pgoff, void *addr, size_t bytes,
-					  struct iov_iter *i)
-{
-	struct dax_device *dax_dev = log_writes_dax_pgoff(ti, &pgoff);
-
-	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
 static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 					  size_t nr_pages)
 {
@@ -1005,8 +929,6 @@ static int log_writes_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 
 #else
 #define log_writes_dax_direct_access NULL
-#define log_writes_dax_copy_from_iter NULL
-#define log_writes_dax_copy_to_iter NULL
 #define log_writes_dax_zero_page_range NULL
 #endif
 
@@ -1024,8 +946,6 @@ static struct target_type log_writes_target = {
 	.iterate_devices = log_writes_iterate_devices,
 	.io_hints = log_writes_io_hints,
 	.direct_access = log_writes_dax_direct_access,
-	.dax_copy_from_iter = log_writes_dax_copy_from_iter,
-	.dax_copy_to_iter = log_writes_dax_copy_to_iter,
 	.dax_zero_page_range = log_writes_dax_zero_page_range,
 };
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 50dba3f39274c..e566115ec0bb8 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -324,22 +324,6 @@ static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
-static size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
-
-	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
-static size_t stripe_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
-
-	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
-}
-
 static int stripe_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 				      size_t nr_pages)
 {
@@ -350,8 +334,6 @@ static int stripe_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
 
 #else
 #define stripe_dax_direct_access NULL
-#define stripe_dax_copy_from_iter NULL
-#define stripe_dax_copy_to_iter NULL
 #define stripe_dax_zero_page_range NULL
 #endif
 
@@ -488,8 +470,6 @@ static struct target_type stripe_target = {
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
 	.direct_access = stripe_dax_direct_access,
-	.dax_copy_from_iter = stripe_dax_copy_from_iter,
-	.dax_copy_to_iter = stripe_dax_copy_to_iter,
 	.dax_zero_page_range = stripe_dax_zero_page_range,
 };
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f4b972af10928..1b7e4ec9e2f57 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1027,54 +1027,6 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
-static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
-				    void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct mapped_device *md = dax_get_private(dax_dev);
-	sector_t sector = pgoff * PAGE_SECTORS;
-	struct dm_target *ti;
-	long ret = 0;
-	int srcu_idx;
-
-	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
-
-	if (!ti)
-		goto out;
-	if (!ti->type->dax_copy_from_iter) {
-		ret = copy_from_iter(addr, bytes, i);
-		goto out;
-	}
-	ret = ti->type->dax_copy_from_iter(ti, pgoff, addr, bytes, i);
- out:
-	dm_put_live_table(md, srcu_idx);
-
-	return ret;
-}
-
-static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	struct mapped_device *md = dax_get_private(dax_dev);
-	sector_t sector = pgoff * PAGE_SECTORS;
-	struct dm_target *ti;
-	long ret = 0;
-	int srcu_idx;
-
-	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
-
-	if (!ti)
-		goto out;
-	if (!ti->type->dax_copy_to_iter) {
-		ret = copy_to_iter(addr, bytes, i);
-		goto out;
-	}
-	ret = ti->type->dax_copy_to_iter(ti, pgoff, addr, bytes, i);
- out:
-	dm_put_live_table(md, srcu_idx);
-
-	return ret;
-}
-
 static int dm_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
 				  size_t nr_pages)
 {
@@ -3024,8 +2976,6 @@ static const struct block_device_operations dm_rq_blk_dops = {
 
 static const struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
-	.copy_from_iter = dm_dax_copy_from_iter,
-	.copy_to_iter = dm_dax_copy_to_iter,
 	.zero_page_range = dm_dax_zero_page_range,
 };
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 85b3339286bd8..b08f0642aa257 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -301,28 +301,8 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
 }
 
-/*
- * Use the 'no check' versions of _copy_from_iter_flushcache() and
- * _copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
- * checking, both file offset and device offset, is handled by
- * dax_iomap_actor()
- */
-static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	return _copy_from_iter_flushcache(addr, bytes, i);
-}
-
-static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i)
-{
-	return _copy_mc_to_iter(addr, bytes, i);
-}
-
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_dax_direct_access,
-	.copy_from_iter = pmem_copy_from_iter,
-	.copy_to_iter = pmem_copy_to_iter,
 	.zero_page_range = pmem_dax_zero_page_range,
 };
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 10823debc09bd..d614843caf6cc 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -44,18 +44,6 @@ static const struct block_device_operations dcssblk_devops = {
 	.release 	= dcssblk_release,
 };
 
-static size_t dcssblk_dax_copy_from_iter(struct dax_device *dax_dev,
-		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
-{
-	return copy_from_iter(addr, bytes, i);
-}
-
-static size_t dcssblk_dax_copy_to_iter(struct dax_device *dax_dev,
-		pgoff_t pgoff, void *addr, size_t bytes, struct iov_iter *i)
-{
-	return copy_to_iter(addr, bytes, i);
-}
-
 static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev,
 				       pgoff_t pgoff, size_t nr_pages)
 {
@@ -72,8 +60,6 @@ static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev,
 
 static const struct dax_operations dcssblk_dax_ops = {
 	.direct_access = dcssblk_dax_direct_access,
-	.copy_from_iter = dcssblk_dax_copy_from_iter,
-	.copy_to_iter = dcssblk_dax_copy_to_iter,
 	.zero_page_range = dcssblk_dax_zero_page_range,
 };
 
diff --git a/fs/dax.c b/fs/dax.c
index e0eecd8e3a8f8..cd03485867a74 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1260,11 +1260,6 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 		if (map_len > end - pos)
 			map_len = end - pos;
 
-		/*
-		 * The userspace address for the memory copy has already been
-		 * validated via access_ok() in either vfs_read() or
-		 * vfs_write(), depending on which operation we are doing.
-		 */
 		if (iov_iter_rw(iter) == WRITE)
 			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
 					map_len, iter);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 5c03a0364a9bb..754319ce2a29b 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -753,20 +753,6 @@ static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	return nr_pages > max_nr_pages ? max_nr_pages : nr_pages;
 }
 
-static size_t virtio_fs_copy_from_iter(struct dax_device *dax_dev,
-				       pgoff_t pgoff, void *addr,
-				       size_t bytes, struct iov_iter *i)
-{
-	return copy_from_iter(addr, bytes, i);
-}
-
-static size_t virtio_fs_copy_to_iter(struct dax_device *dax_dev,
-				       pgoff_t pgoff, void *addr,
-				       size_t bytes, struct iov_iter *i)
-{
-	return copy_to_iter(addr, bytes, i);
-}
-
 static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
 				     pgoff_t pgoff, size_t nr_pages)
 {
@@ -783,8 +769,6 @@ static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
 
 static const struct dax_operations virtio_fs_dax_ops = {
 	.direct_access = virtio_fs_direct_access,
-	.copy_from_iter = virtio_fs_copy_from_iter,
-	.copy_to_iter = virtio_fs_copy_to_iter,
 	.zero_page_range = virtio_fs_zero_page_range,
 };
 
@@ -853,7 +837,8 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 	fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
 	if (IS_ERR(fs->dax_dev))
 		return PTR_ERR(fs->dax_dev);
-
+	set_dax_cached(fs->dax_dev);
+	set_dax_nomcsafe(fs->dax_dev);
 	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
 					fs->dax_dev);
 }
diff --git a/include/linux/dax.h b/include/linux/dax.h
index c04f46478e3b5..d22cbf03d37d2 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -28,12 +28,6 @@ struct dax_operations {
 	 */
 	bool (*dax_supported)(struct dax_device *, struct block_device *, int,
 			sector_t, sector_t);
-	/* copy_from_iter: required operation for fs-dax direct-i/o */
-	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
-			struct iov_iter *);
-	/* copy_to_iter: required operation for fs-dax direct-i/o */
-	size_t (*copy_to_iter)(struct dax_device *, pgoff_t, void *, size_t,
-			struct iov_iter *);
 	/* zero_page_range: required operation. Zero page range   */
 	int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
 };
@@ -95,6 +89,9 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
 }
 #endif
 
+void set_dax_cached(struct dax_device *dax_dev);
+void set_dax_nomcsafe(struct dax_device *dax_dev);
+
 struct writeback_control;
 #if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
 int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a7df155ea49b8..b26fecf6c8e87 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -147,8 +147,6 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
  */
 typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
-typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
-		void *addr, size_t bytes, struct iov_iter *i);
 typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
 		size_t nr_pages);
 
@@ -200,8 +198,6 @@ struct target_type {
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
 	dm_dax_direct_access_fn direct_access;
-	dm_dax_copy_iter_fn dax_copy_from_iter;
-	dm_dax_copy_iter_fn dax_copy_to_iter;
 	dm_dax_zero_page_range_fn dax_zero_page_range;
 
 	/* For internal device-mapper use. */
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

