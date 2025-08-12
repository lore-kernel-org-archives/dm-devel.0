Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286F3225A59
	for <dm-devel@lists.linux.dev>; Tue, 12 Aug 2025 08:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754987110; cv=none; b=BmmfmDn++2641ydWp1Eirn1UVUcLj/h6m5rp3r8UKUw/9KYsVwIk7H7U1P5LFh5/baTwokSbCWRcyxGAoc383GLTbN5P1ccvsP9cxzCBzoTyOp22bNMitITUKNr58NT1sQMKxQ9MPnYObblZi8Z1ktPil98UrJGwAstkB7QqbDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754987110; c=relaxed/simple;
	bh=veWOL+23ukAaJT7DekKnBSzKNQjf9kfiWtrXdFG0pmU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nnAxO8J/pPbE5OBiSs6ILBJYjsZR0sn7IPRxhR9y77kwdFetpZtDbmPXkaZYNZofpBUaAk2WN+32vXyuyr6YW8ICftUYPxiYh2WroaUYkCIuCYVoi6Dl4hRdJxAyUu8EMurRp0t7YOPAJfZx5hnNIvPBD2hv49GyASLfhrrBAtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QbPW/SAG; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QbPW/SAG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754987103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/pUy1089LIoq09fWSMh72l+7ou4njoi/W3xc6RHTrp0=;
	b=QbPW/SAGRrS9GPm/UVpOS+kzrsa8O0FYJoPgRjmxEvYF62L0BQaatA1mONqPArqUkLLszl
	flOGG/vOD2led8mEz9d5NJ0VZlyMmXMOtMjzY9avjuOIfePJbyoXn8KHqrpqP0sN5RR8Wg
	3cLS0xuECXnTaj3e5N+HEvFc7sxKbUE=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	cengku@gmail.com,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v5 00/11] dm-pcache – persistent-memory cache for block devices
Date: Tue, 12 Aug 2025 08:24:51 +0000
Message-ID: <20250812082452.2041767-1-dongsheng.yang@linux.dev>
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
	This is V5 for dm-pcache, please consider merging.

	As you requested, I've squashed these patches into a single patch, based
  on v6.16. If you find anything that needs tweaking while merging, feel
  free to modify it directly. I can also send a rebased version on top of the linux-dm branch if you
  prefer.
  
  This patch has gone through quite a bit of testing on my side. I can
  share the highlights. Once you merge this patch into the linux-dm branch,
  I’ll keep running ongoing tests against dm-6.18.
  
  1. dtg-tests for pcache[1]: 
  	- Includes `dmsetup` management operations, including failure/exception scenarios.
	- Failslab tests (covering the NOWAIT → NOIO fallback path you mentioned).
	- `fail_make_request` fault-injection tests.
	- Backing device delay tests.
	- xfstests (group `generic/rw`) under different parameters.
  
  2. Striped pmem as the cache_dev[2]: ran the same dtg-tests suite with a
  striped pmem configuration.
  
  3. KASAN and memleak modes[3]: all of the above tests were also executed
  with KASAN and memory leak detection enabled.
  
  4. Coverage with gcov: I used gcov to gather code coverage during the
  test runs[4].
	- The results show 100% function coverage and 90%+ line coverage. The
	remaining uncovered code is mostly `BUG()` lines and a few hard-to-simulate error paths.
	- In the coverage report you can see the code path for `mempool_alloc`
	with `GFP_NOIO` is exercised and covered.

[1]: https://datatravelguide.github.io/dtg-blog/pcache/pcache_v5_result_virtio/results.html
[2]: https://datatravelguide.github.io/dtg-blog/pcache/pcache_v5_result_ram/results.html
[3]: https://datatravelguide.github.io/dtg-blog/pcache/pcache_v5_result_kasan/results.html
[4]: https://datatravelguide.github.io/dtg-blog/pcache/pcache_cov_v5/dm-pcache/index.html

Changelogs

V5 from V4:
	- Fix `get_n_vecs()` bug when the buffer isn’t page-aligned; use
	- `bio_add_max_vecs()` instead.
	- Use `kvcalloc()` for allocations larger than 32,768 bytes.
	- For mempool allocations, try `GFP_NOWAIT` first; if that fails, fall back to `GFP_NOIO`.

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

Dongsheng Yang (1):
  dm-pcache: add persistent cache target in device-mapper

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

-- 
2.43.0

