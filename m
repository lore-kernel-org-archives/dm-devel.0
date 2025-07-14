Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374A244660
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 10:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752489661; cv=none; b=fxAXoHCeLV5+gSPLImwjdauRQ5BVn4k+TxCjL0IncoL8AFv+MRKN82msLVZN0O8VBe3c2lP1SMWfEM1+cULSa/Yhv/hw2qKNsixUH6MFZXxRw058rjiMlTDvGzkJkazrSLFOnQLPzzDvw2mONJL2QpPjwvXNS2ur0DO9ziWbvIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752489661; c=relaxed/simple;
	bh=kW04AEZjFb2FBVn5qeKfBJJ0lupAHyRgWX4BPA75ASk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mbTTN4AK7VmUPd2ju0ApKk2pTP2j7MPDsgGATMWtRkB989Z+IDltckwW/ZqOJi8bSPQTF51+rf9Kso6RB/GW587qAgTNOzBuUfqZ51944w4eBIVSuY4O+8M7NLP318rR5b6RKEHJnjWEs20t+57DYSqAX2WqLPdUsPus5ytNuTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ey+HOdHS; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ey+HOdHS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752489655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9LGm9CjSNqtzssXqeEmIFB2cD4S/Mdc4kbQFUEHljEY=;
	b=Ey+HOdHSH90Xg+yqKn2FAzlXkVa7gS665bJDtE+i660ReR1X4Wa4zgXIxLHiM9mchIkilC
	Zyt4LpYS6EfTyYbpW1Xy4+k8ix20qoiVYqdgVwSnHXt+N/au9zLhc7oFmkEu3eB3vJecij
	MbB9RdU32SdEyDEpJqR/3YvV6PJFmCw=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v3 00/11] dm-pcache – persistent-memory cache for block devices
Date: Mon, 14 Jul 2025 10:40:31 +0000
Message-ID: <20250714104043.1800910-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Mikulas,
	This is V3 for dm-pcache, please take a look.

Code:
    https://github.com/DataTravelGuide/linux tags/pcache_v3

Changelogs

V3 from V2:
	- rebased against linux-dm dm-6.17
	- add missing include file bitfiled.h (Mikulas)
	- move kmem_cache from per-device to per-module (Mikulas)
	- fix a memleak in error path found by failslab testing
	- retry pcache_request in defer_req() when memory allocation
	  fail, then `defer_req()` handles two situations:

	  1. Cache-full – the most common case.
	  Here the request waits until the GC thread invalidates cache blocks and triggers a retry.

	  2. Memory-allocation failure – this means the system is already under severe memory pressure.
	  In this case the top priority is to keep I/O recoverable and to allow users to manually stop
	  the pcache device if they wish. Therefore, the request is rescheduled for a retry 5 seconds later.

V2 from V1:
	- introduce req_alloc() and req_init() in backing_dev.c, then we
	  can do req_alloc() before holding spinlock and do req_init()
	  in subtree_walk().
	- introduce pre_alloc_key and pre_alloc_req in walk_ctx, that
	  means we can pre-allocate cache_key or backing_dev_request
	  before subtree walking.
	- use mempool_alloc() with NOIO for the allocation of cache_key
	  and backing_dev_req.
	- some coding style changes from comments of Jonathan.

V1 from RFC-V2:
	- use crc32c to replace crc32
	- only retry pcache_req when cache full, add pcache_req into defer_list,
	  and wait cache invalidation happen.
	- new format for pcache table, it is more easily extended with
	  new parameters later.
	- remove __packed.
	- use spin_lock_irq in req_complete_fn to replace
	  spin_lock_irqsave.
	- fix bug in backing_dev_bio_end with spin_lock_irqsave.
	- queue_work() inside spinlock.
	- introduce inline_bvecs in backing_dev_req.
	- use kmalloc_array for bvecs allocation.
	- calculate ->off with dm_target_offset() before use it.

Dongsheng Yang (11):
  dm-pcache: add pcache_internal.h
  dm-pcache: add backing device management
  dm-pcache: add cache device
  dm-pcache: add segment layer
  dm-pcache: add cache_segment
  dm-pcache: add cache_writeback
  dm-pcache: add cache_gc
  dm-pcache: add cache_key
  dm-pcache: add cache_req
  dm-pcache: add cache core
  dm-pcache: initial dm-pcache target

 .../admin-guide/device-mapper/dm-pcache.rst   | 201 ++++
 MAINTAINERS                                   |   8 +
 drivers/md/Kconfig                            |   2 +
 drivers/md/Makefile                           |   1 +
 drivers/md/dm-pcache/Kconfig                  |  17 +
 drivers/md/dm-pcache/Makefile                 |   3 +
 drivers/md/dm-pcache/backing_dev.c            | 307 ++++++
 drivers/md/dm-pcache/backing_dev.h            |  91 ++
 drivers/md/dm-pcache/cache.c                  | 432 +++++++++
 drivers/md/dm-pcache/cache.h                  | 615 ++++++++++++
 drivers/md/dm-pcache/cache_dev.c              | 299 ++++++
 drivers/md/dm-pcache/cache_dev.h              |  70 ++
 drivers/md/dm-pcache/cache_gc.c               | 170 ++++
 drivers/md/dm-pcache/cache_key.c              | 881 ++++++++++++++++++
 drivers/md/dm-pcache/cache_req.c              | 855 +++++++++++++++++
 drivers/md/dm-pcache/cache_segment.c          | 293 ++++++
 drivers/md/dm-pcache/cache_writeback.c        | 281 ++++++
 drivers/md/dm-pcache/dm_pcache.c              | 506 ++++++++++
 drivers/md/dm-pcache/dm_pcache.h              |  68 ++
 drivers/md/dm-pcache/pcache_internal.h        | 117 +++
 drivers/md/dm-pcache/segment.c                |  61 ++
 drivers/md/dm-pcache/segment.h                |  74 ++
 22 files changed, 5352 insertions(+)
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

-- 
2.43.0

