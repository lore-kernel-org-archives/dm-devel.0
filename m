Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A338DF9
	for <dm-devel@lists.linux.dev>; Mon,  1 Sep 2025 05:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756705337; cv=none; b=akNGkQobugJXGK0e3Bx8TonRS6YyEh3ogCOcfxH7YBjHLBOJdzO1Pe3121K+ElIiPQZZYmsnMfC7Xc2AOvMvfVlkFWO+o6NF4TmkaM5ySLTsrW+V4eJx+pnlwnR09f5vnk61P1v3iEwc8xsjKltZ4k2TuYSqqg02glOzI7R6ibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756705337; c=relaxed/simple;
	bh=4Er055+Ny4fBHUHc+teGxJnrVvxJIsuGLy6aBnalS5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l6dUm+UeJednrBpSetkUnHVo8/S25OkqRX4+r5gknd2WGOxeGrwDgTWxfSvmKcTfprq7ktO5wfHYBIcMh3bYYIZXWnP9LyyiAJfb1iecppiALRKFD9Kov4Nrj4uNB6jkR2vq9kIiS7gKy45LfEpKnkh9nQEOXdf10UjB9eh7X7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r7Kda+pw; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r7Kda+pw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756705330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TkyccWiBL+AniRAIuTkw+fX+S22c6gKBV/NY1XKrm74=;
	b=r7Kda+pwmAsKqC+mUf8q2ek+v4CGSmWAocbdp6Uuvocz6iLJ3NiT+Xdm8dTifKphRAjz1B
	Y7zVZumqA/GTngrX6f4uEd+48Cq2pKy0+qXMwAZdpCOqAZrldgQppvTp8GDkAGjyVXskRg
	I/NmEKsWtiMCHB1hNQH7y/y2YyWs8po=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: mpatocka@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org
Cc: dm-devel@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH] dm-pcache: remove ctrl_lock for pcache_cache_segment
Date: Mon,  1 Sep 2025 05:42:00 +0000
Message-ID: <20250901054200.2635562-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The smatch checker reports a “scheduler in atomic context” problem in
the following call chain:

miss_read_end_req()
   -> cache_seg_put()
      -> cache_seg_invalidate()
         -> cache_seg_gen_increase()
            -> mutex_lock(&cache_seg->ctrl_lock);

In practice, this `mutex_lock` will not actually schedule, because it is
only called when `cache_seg_put()` drops the last reference, which is
single-threaded. That is also why the issue never shows up during real
testing.

However, the code is still buggy. The original purpose of `ctrl_lock`
was to prevent read/write conflicts on the cache segment control
information. Looking at the current usage, all control information
accesses are single-threaded: reads only occur during the init phase,
where no conflicts are possible, and writes happen once in the init
phase (also single-threaded) and once when `cache_seg_put()` drops the
last reference (again single-threaded).

Therefore, this patch removes `ctrl_lock` entirely and adds comments in
the appropriate places to document this logic.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache.h         |  1 -
 drivers/md/dm-pcache/cache_segment.c | 22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index f005c9d9a7aa..1136d86958c8 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -90,7 +90,6 @@ struct pcache_cache_segment {
 	u32			gen_index;
 
 	struct pcache_cache_seg_ctrl *cache_seg_ctrl;
-	struct mutex		ctrl_lock;
 };
 
 /* rbtree for cache entries */
diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
index 8f9534ae04c3..f0b58980806e 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -72,7 +72,6 @@ static int cache_seg_ctrl_load(struct pcache_cache_segment *cache_seg)
 	struct pcache_cache_seg_gen cache_seg_gen, *cache_seg_gen_addr;
 	int ret = 0;
 
-	mutex_lock(&cache_seg->ctrl_lock);
 	cache_seg_gen_addr = pcache_meta_find_latest(&cache_seg_ctrl->gen->header,
 					     sizeof(struct pcache_cache_seg_gen),
 					     sizeof(struct pcache_cache_seg_gen),
@@ -93,7 +92,6 @@ static int cache_seg_ctrl_load(struct pcache_cache_segment *cache_seg)
 	cache_seg->gen_seq = cache_seg_gen.header.seq;
 	cache_seg->gen_index = (cache_seg_gen_addr - cache_seg_ctrl->gen);
 out:
-	mutex_unlock(&cache_seg->ctrl_lock);
 
 	return ret;
 }
@@ -105,11 +103,27 @@ static inline struct pcache_cache_seg_gen *get_cache_seg_gen_addr(struct pcache_
 	return (cache_seg_ctrl->gen + cache_seg->gen_index);
 }
 
+/*
+ * cache_seg_ctrl_write - write cache segment control information
+ * @seg: the cache segment to update
+ *
+ * This function writes the control information of a cache segment to media.
+ *
+ * Although this updates shared control data, we intentionally do not use
+ * any locking here.  All accesses to control information are single-threaded:
+ *
+ *   - All reads occur during the init phase, where no concurrent writes
+ *     can happen.
+ *   - Writes happen once during init and once when the last reference
+ *     to the segment is dropped in cache_seg_put().
+ *
+ * Both cases are guaranteed to be single-threaded, so there is no risk
+ * of concurrent read/write races.
+ */
 static void cache_seg_ctrl_write(struct pcache_cache_segment *cache_seg)
 {
 	struct pcache_cache_seg_gen cache_seg_gen;
 
-	mutex_lock(&cache_seg->ctrl_lock);
 	cache_seg_gen.gen = cache_seg->gen;
 	cache_seg_gen.header.seq = ++cache_seg->gen_seq;
 	cache_seg_gen.header.crc = pcache_meta_crc(&cache_seg_gen.header,
@@ -119,7 +133,6 @@ static void cache_seg_ctrl_write(struct pcache_cache_segment *cache_seg)
 	pmem_wmb();
 
 	cache_seg->gen_index = (cache_seg->gen_index + 1) % PCACHE_META_INDEX_MAX;
-	mutex_unlock(&cache_seg->ctrl_lock);
 }
 
 static void cache_seg_ctrl_init(struct pcache_cache_segment *cache_seg)
@@ -177,7 +190,6 @@ int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg_id,
 	spin_lock_init(&cache_seg->gen_lock);
 	atomic_set(&cache_seg->refs, 0);
 	mutex_init(&cache_seg->info_lock);
-	mutex_init(&cache_seg->ctrl_lock);
 
 	/* init pcache_segment */
 	seg_options.type = PCACHE_SEGMENT_TYPE_CACHE_DATA;
-- 
2.43.0

