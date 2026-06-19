Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AFC3803DA;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781869496; cv=none; b=SoxtyxckQt2s8bbUQJJE/4LCOohrYk16Jn8JBR4nm7GRPMZJVuOG5iV4Kf49h9W9vlWEN3wiyW9DvQmM3t9qpRsfWTZyyrr2rWiS18XJPngGBXCIPOIhjjcZ2P1HEDfUUrjQ1M4W6xYUaoQIg0SpuuKXoSemIC6qmRhLZnVXMdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781869496; c=relaxed/simple;
	bh=/U0OnU73FcJjgCNshlLiC2uabKk60HcUlTnQcoYq9nc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QJ77KDfh9goWjl+RiVfDVubdxWud6kdN1BwDXQb9CF1BrF6OOsPfbFaohSegiIzX5R1oKgPbw0AfrLF3u7Bf6AiV1ZYSs+dcIKuzZfReygyf8pACpY21iczNiohzI7iS+huBsZKF6nHpfaBCiawc+AcTO+XqwDg6wPnDj0TzNvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHeyloiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHeyloiK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 180A0C2BCC7;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781869496;
	bh=/U0OnU73FcJjgCNshlLiC2uabKk60HcUlTnQcoYq9nc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EHeyloiKlZwh/kawrqFTk4NGw2cL5m0gO/GEnRubTrXfhvwkiXbclktyWa/2vlKRb
	 kW7FWmOFr1lJbwk8tTRvgLjcjugzWEICAHWGBbIC3q8XMHwUrjtIJthP9713MNq1vv
	 QmBDKYJXti+iBApBX5BoH/5NG8Zl6cGGc+oxwFlepMQ5rNFLRWROk5H6my1wja6h/L
	 l1bDNFpz8x/E8zTxoj0LaI//StjMkPC0OUsdnDfKlcPW/DZLBKeNaUmEczRhphiqPM
	 /vyuRWmi6n7jssBfBMeQ4Q7B1AYGtXuooIetoxnwCPtsEdMyQ7n2u1urhfNRetdTrw
	 5bPElEY8Be+UA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012A9CD4F26;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 19 Jun 2026 06:44:55 -0500
Subject: [PATCH 1/3] dm-pcache: validate seg_id fields from persistent
 memory
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260619-b4-disp-997773a1-v1-1-14df8aedb323@proton.me>
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
In-Reply-To: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
To: Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, 
 dm-devel@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781869494; l=7265;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=onDCIMwVT/xaDsiAJmikuphb3qEbDfxuFMQoIzj4Xv0=;
 b=ZXaTQgLnrEQIJEIVuTkeVQ65jwWrjhMy9HxWhRZlrd6MH3vuBM6zhGPGj0ZJossWVXpr97lGq
 4PomS1TuTJzBJiRIQE8J5ETZVGsAWwoxD7Az+TcW7iQMrqq4VK6TIfB
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

cache_pos_decode(), cache_key_decode() and the last-kset branches of
cache_replay(), the writeback worker and the GC worker take a cache
segment id from the cache device metadata and index cache->segments[]
with it without checking it against cache->n_segs. That metadata is only
CRC-protected with a fixed public seed, so whoever supplies the cache
device on a table load (CAP_SYS_ADMIN) controls the id; an out-of-range
value forms a wild pcache_cache_segment pointer that is dereferenced and
written through -- an out-of-bounds read and write driven by on-disk data.

Add cache_seg_id_valid() and reject an out-of-range id at each decode
site, failing the operation with -EIO instead of indexing past the array.
Valid metadata is unaffected.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache.c           |  3 +++
 drivers/md/dm-pcache/cache.h           | 14 ++++++++++++++
 drivers/md/dm-pcache/cache_gc.c        | 16 ++++++++++++++--
 drivers/md/dm-pcache/cache_key.c       | 11 +++++++++++
 drivers/md/dm-pcache/cache_writeback.c | 14 +++++++++++---
 5 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index bb1ada31e483..e6a2f4460f6e 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -118,6 +118,9 @@ int cache_pos_decode(struct pcache_cache *cache,
 	if (!latest_addr)
 		return -EIO;
 
+	if (!cache_seg_id_valid(cache, latest.cache_seg_id))
+		return -EIO;
+
 	pos->cache_seg = &cache->segments[latest.cache_seg_id];
 	pos->seg_off = latest.seg_off;
 	*seq = latest.header.seq;
diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index 27613b56be54..653ceea43131 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -420,6 +420,20 @@ static inline bool cache_seg_is_ctrl_seg(u32 cache_seg_id)
 	return (cache_seg_id == 0);
 }
 
+/**
+ * cache_seg_id_valid - Validate a cache segment id read from the cache device.
+ * @cache: Pointer to the pcache_cache structure.
+ * @cache_seg_id: Segment id decoded from on-media metadata.
+ *
+ * On-media segment ids are only protected by a CRC, which an attacker who can
+ * format the cache device computes over their chosen value. Reject any id that
+ * would index cache->segments[] out of bounds before it is dereferenced.
+ */
+static inline bool cache_seg_id_valid(struct pcache_cache *cache, u32 cache_seg_id)
+{
+	return cache_seg_id < cache->n_segs;
+}
+
 /**
  * cache_key_cutfront - Cuts a specified length from the front of a cache key.
  * @key: Pointer to pcache_cache_key structure.
diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
index 94f8b276a021..02fa0ce03134 100644
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -74,11 +74,17 @@ static bool need_gc(struct pcache_cache *cache, struct pcache_cache_pos *dirty_t
  * @cache: Pointer to the pcache_cache structure.
  * @kset_onmedia: Pointer to the kset_onmedia structure for the last kset.
  */
-static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+static int last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
 {
 	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
 	struct pcache_cache_segment *cur_seg, *next_seg;
 
+	if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_id)) {
+		pcache_dev_err(pcache, "invalid next_cache_seg_id %u in gc (n_segs %u)\n",
+				kset_onmedia->next_cache_seg_id, cache->n_segs);
+		return -EIO;
+	}
+
 	cur_seg = cache->key_tail.cache_seg;
 
 	next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
@@ -94,6 +100,8 @@ static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_on
 	spin_lock(&cache->seg_map_lock);
 	__clear_bit(cur_seg->cache_seg_id, cache->seg_map);
 	spin_unlock(&cache->seg_map_lock);
+
+	return 0;
 }
 
 void pcache_cache_gc_fn(struct work_struct *work)
@@ -130,7 +138,11 @@ void pcache_cache_gc_fn(struct work_struct *work)
 			if (dirty_tail.cache_seg == key_tail.cache_seg)
 				break;
 
-			last_kset_gc(cache, kset_onmedia);
+			ret = last_kset_gc(cache, kset_onmedia);
+			if (ret) {
+				atomic_inc(&cache->gc_errors);
+				return;
+			}
 			continue;
 		}
 
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index e068e878231b..8eec5238c5da 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -94,6 +94,12 @@ int cache_key_decode(struct pcache_cache *cache,
 	key->off = key_onmedia->off;
 	key->len = key_onmedia->len;
 
+	if (!cache_seg_id_valid(cache, key_onmedia->cache_seg_id)) {
+		pcache_dev_err(pcache, "invalid cache_seg_id %u in cache key (n_segs %u)\n",
+				key_onmedia->cache_seg_id, cache->n_segs);
+		return -EIO;
+	}
+
 	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
 	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
 
@@ -789,6 +795,11 @@ int cache_replay(struct pcache_cache *cache)
 
 			pcache_dev_debug(pcache, "last kset replay, next: %u\n", kset_onmedia->next_cache_seg_id);
 
+			if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_id)) {
+				ret = -EIO;
+				goto out;
+			}
+
 			next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
 
 			pos->cache_seg = next_seg;
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index 87a82b3fe836..a104e6ee8aa8 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -196,12 +196,18 @@ static int cache_kset_insert_tree(struct pcache_cache *cache, struct pcache_cach
 	return ret;
 }
 
-static void last_kset_writeback(struct pcache_cache *cache,
+static int last_kset_writeback(struct pcache_cache *cache,
 		struct pcache_cache_kset_onmedia *last_kset_onmedia)
 {
 	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
 	struct pcache_cache_segment *next_seg;
 
+	if (!cache_seg_id_valid(cache, last_kset_onmedia->next_cache_seg_id)) {
+		pcache_dev_err(pcache, "invalid next_cache_seg_id %u in writeback (n_segs %u)\n",
+				last_kset_onmedia->next_cache_seg_id, cache->n_segs);
+		return -EIO;
+	}
+
 	pcache_dev_debug(pcache, "last kset, next: %u\n", last_kset_onmedia->next_cache_seg_id);
 
 	next_seg = &cache->segments[last_kset_onmedia->next_cache_seg_id];
@@ -211,6 +217,8 @@ static void last_kset_writeback(struct pcache_cache *cache,
 	cache->dirty_tail.seg_off = 0;
 	cache_encode_dirty_tail(cache);
 	mutex_unlock(&cache->dirty_tail_lock);
+
+	return 0;
 }
 
 void cache_writeback_fn(struct work_struct *work)
@@ -241,8 +249,8 @@ void cache_writeback_fn(struct work_struct *work)
 	}
 
 	if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
-		last_kset_writeback(cache, kset_onmedia);
-		delay = 0;
+		ret = last_kset_writeback(cache, kset_onmedia);
+		delay = ret ? PCACHE_CACHE_WRITEBACK_INTERVAL : 0;
 		goto queue_work;
 	}
 

-- 
2.43.0


