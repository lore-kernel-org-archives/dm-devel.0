Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC02EAB78
	for <dm-devel@lists.linux.dev>; Tue, 15 Jul 2025 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586476; cv=none; b=nn20ARIYsvb+YyWyDQRE/cgFlSgJCysydJGG7IO3mNMKw4Q9nwqz2XZ+FNNlbT+sQbWrjHAcVfpnwD35dcI5qy2NT7K4ONstxXUCC3xVjkt9peR3m6jd8eSySNAoMbq1dh6hegXc90Z7P8mhV8N6RwPMzMRToqHKnwaTtxPR/uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586476; c=relaxed/simple;
	bh=lrGCsiV05uqmL19D/STDaaSIzuB4smMhCxvrATU1FzA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dKXDZK9xCaWW8wk+ItkWlcWWUQl08GuC2BunWovFSL2KUwl4HOZMd1TLQO6r+CgI6ufjUsHzyO0lLTzh/1VygTa8lA8fYdxknYHiPRcJiDcu3vCQ/PP/PI900gruSPgYLVls09B+bA+ePvM86DmgMwDeLn/BKPe1tPgLRl7jz1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fQ/BvN5j; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fQ/BvN5j"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752586472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z6kTubrM9WUzyrvMAdKqwfoLurfWvOs/Q3L1IulHOwE=;
	b=fQ/BvN5jBxORA0hNKdGxN/f55oJZQXFdgUjFUJ8bskvraDayvJo/A6KjNiudIVEpyUzwsU
	3EmjZJC+8eEHduPee+aT3smOU0vQwsU/CgXQOOusCi/PQ5hwf2kdsRFEMZaWmt7pH6NsH2
	RH2rjNPaYH574OWhR1dgfuYfpjAK4Lk=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	cengku@gmail.com,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v4 00/11] dm-pcache – persistent-memory cache for block devices
Date: Tue, 15 Jul 2025 13:33:20 +0000
Message-ID: <20250715133332.1764715-1-dongsheng.yang@linux.dev>
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
	This is V4 for dm-pcache, please help to review.

Code:
    https://github.com/DataTravelGuide/linux tags/pcache_v4

Changelogs

V4 from V3:
	- go back to use mempool for allocation of cache_key and
	  backing_dev_req.

	- introduce backing_bvec_cache and backing_dev->bvec_pool to
	  allocate bvecs for backing_dev_req. Currently, the obj_size of
	  bvec_cache is max size of bvecs. The bvecs are allocated only for
	  write‑back backing_dev_req requests, and only a limited number of writeback requests
	  are allocated at the same time, so the resulting memory overhead should
	  not be too severe.

	  If in the futer we found that this implementation results in unacceptable memory waste,
	  we can optimize it by switching to a multi‑level slab design.

	- remove ret-value checking for bio_init_clone() as there should
	  not be REQ_INTEGRITY in bio bi_opf, so bio_init_clone() never
	  fail.

	- remove ret-value checking for backing_dev_req_alloc() and
	  cache_key_alloc().

V3 from V2:
	- rebased against linux-dm dm-6.17
	- add missing include file bitfiled.h (Mikulas)
	- move kmem_cache from per-device to per-module (Mikulas)
	- fix a memleak in error path found by failslab testing
	- retry pcache_request in defer_req() when memory allocation
	  fail.

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
 drivers/md/dm-pcache/backing_dev.c            | 359 +++++++
 drivers/md/dm-pcache/backing_dev.h            |  98 ++
 drivers/md/dm-pcache/cache.c                  | 448 +++++++++
 drivers/md/dm-pcache/cache.h                  | 621 ++++++++++++
 drivers/md/dm-pcache/cache_dev.c              | 299 ++++++
 drivers/md/dm-pcache/cache_dev.h              |  70 ++
 drivers/md/dm-pcache/cache_gc.c               | 170 ++++
 drivers/md/dm-pcache/cache_key.c              | 883 ++++++++++++++++++
 drivers/md/dm-pcache/cache_req.c              | 834 +++++++++++++++++
 drivers/md/dm-pcache/cache_segment.c          | 293 ++++++
 drivers/md/dm-pcache/cache_writeback.c        | 259 +++++
 drivers/md/dm-pcache/dm_pcache.c              | 488 ++++++++++
 drivers/md/dm-pcache/dm_pcache.h              |  65 ++
 drivers/md/dm-pcache/pcache_internal.h        | 117 +++
 drivers/md/dm-pcache/segment.c                |  61 ++
 drivers/md/dm-pcache/segment.h                |  74 ++
 22 files changed, 5371 insertions(+)
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

