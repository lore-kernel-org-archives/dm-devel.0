Received: from sender3-pp-f112.zoho.com (sender3-pp-f112.zoho.com [136.143.184.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088AB357A32
	for <dm-devel@lists.linux.dev>; Tue, 11 Nov 2025 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.184.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762863253; cv=pass; b=KNgyAgpn740THJP22mCk6UvaIGSlUfdsRdlu6KCqoPglYveqzEmm8fFVNIYmOIFDoFGdJvwIFJpzIs0XqONvRNnw3ZnGAawCXIDRWGPjM9rxKxkFKtkZ/l6t9uuPRYY7Fy28H+MSncadl2o+srC0t2OHt4pRLqJWHi15Kzm1SYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762863253; c=relaxed/simple;
	bh=dN55HW4FfkzTBtEO25VWJ9JrD1kDv1xDO/lxQFE+MTg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFyvqdN1AR0Hg54BmAWFtLqTQ3HqEwerElkaSGeaKFIvXqkJ3SB9Hjj4aZAY9v0OL43sdZ1ciJ5LuhBNqLN61rdEZd1KA4sAD/76DAwecTOZyWWIYY9i5Thlzh0WeDvdYSn13EXxZaA7emmwx6X4bpZgEpoijLiQCZkCWK/xqmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=XWvMoxww; arc=pass smtp.client-ip=136.143.184.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="XWvMoxww"
ARC-Seal: i=1; a=rsa-sha256; t=1762863230; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TiY0i1ybo101BBxI7dKvCHEh6iQtuUXZo7nz1ztUZfGai4a2AhGT6e4HXXbpLsIfZ3HnibbFc45DGfat8tQBMVRoJpZi8vdtNXetE/ZildlXuxdrBjPshcM+9X6UUrrhwSsauM/qD7B1XjthQvkEnMV1eDd1+PMWIOJ/0wUkDEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762863230; h=Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=4oaOTUtuN2YDsbIeaOrLhfRRJFbe0Y3tgRUZy7WUjE8=; 
	b=Wwc9Cvfq+bCVUpkPdCYZjzqCn2Zs1zKZlOOaa3aQEsieilxHJfZvBk6+AKZXBm+5D2jAc2zK8ghKpZU52com8EYTECseYmVhTdIvk4OBEuwKpR42n2MCcoYJbn6LhXPLWdZDbNq0SsHngljBYtnMYOTLq+Fxf49FR8peFBw4Gtk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762863230;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=4oaOTUtuN2YDsbIeaOrLhfRRJFbe0Y3tgRUZy7WUjE8=;
	b=XWvMoxwwSgojaqGpQrycDpraZaShPE8R3JvLdRCvaeh+v0NsiLkLbBHqCrYJeCvb
	bE0iNyzNlyjMOMBmVUfoLuZTfknepXFJ6NvWP6aKXUj0H5upkqwrqEERWUszLrt5WoC
	YDdWN5M4/0NpwNvGZXkgojs1GVcOYvSj5GrWlFXE=
Received: by mx.zohomail.com with SMTPS id 1762863226002819.1329271635038;
	Tue, 11 Nov 2025 04:13:46 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH v2 1/3] dm-pcache: allow built-in build and rename flush helper
Date: Tue, 11 Nov 2025 20:13:34 +0800
Message-ID: <20251111121337.1063443-2-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111121337.1063443-1-me@linux.beauty>
References: <20251111121337.1063443-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From: Li Chen <chenl311@chinatelecom.cn>

CONFIG_BCACHE is tristate, so dm-pcache can also be built-in.
Switch the Makefile to use obj-$(CONFIG_DM_PCACHE) so the target can be
linked into vmlinux instead of always being a loadable module.

Also rename cache_flush() to pcache_cache_flush() to avoid a global
symbol clash with sunrpc/cache.c's cache_flush().

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
---
 drivers/md/dm-pcache/Makefile    | 2 +-
 drivers/md/dm-pcache/cache.c     | 2 +-
 drivers/md/dm-pcache/cache.h     | 2 +-
 drivers/md/dm-pcache/cache_req.c | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-pcache/Makefile b/drivers/md/dm-pcache/Makefile
index 86776e4acad2..cedfd38854f6 100644
--- a/drivers/md/dm-pcache/Makefile
+++ b/drivers/md/dm-pcache/Makefile
@@ -1,3 +1,3 @@
 dm-pcache-y := dm_pcache.o cache_dev.o segment.o backing_dev.o cache.o cache_gc.o cache_writeback.o cache_segment.o cache_key.o cache_req.o
 
-obj-m += dm-pcache.o
+obj-$(CONFIG_DM_PCACHE) += dm-pcache.o
diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index d8e92367d947..d516d4904227 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -411,7 +411,7 @@ void pcache_cache_stop(struct dm_pcache *pcache)
 {
 	struct pcache_cache *cache = &pcache->cache;
 
-	cache_flush(cache);
+	pcache_cache_flush(cache);
 
 	cancel_delayed_work_sync(&cache->gc_work);
 	flush_work(&cache->clean_work);
diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index 1136d86958c8..27613b56be54 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -339,7 +339,7 @@ void cache_seg_put(struct pcache_cache_segment *cache_seg);
 void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id);
 
 /* cache request*/
-int cache_flush(struct pcache_cache *cache);
+int pcache_cache_flush(struct pcache_cache *cache);
 void miss_read_end_work_fn(struct work_struct *work);
 int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req);
 
diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
index 27f94c1fa968..7854a30e07b7 100644
--- a/drivers/md/dm-pcache/cache_req.c
+++ b/drivers/md/dm-pcache/cache_req.c
@@ -790,7 +790,7 @@ static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache
 }
 
 /**
- * cache_flush - Flush all ksets to persist any pending cache data
+ * pcache_cache_flush - Flush all ksets to persist any pending cache data
  * @cache: Pointer to the cache structure
  *
  * This function iterates through all ksets associated with the provided `cache`
@@ -802,7 +802,7 @@ static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache
  * the respective error code, preventing the flush operation from proceeding to
  * subsequent ksets.
  */
-int cache_flush(struct pcache_cache *cache)
+int pcache_cache_flush(struct pcache_cache *cache)
 {
 	struct pcache_cache_kset *kset;
 	int ret;
@@ -827,7 +827,7 @@ int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *p
 	struct bio *bio = pcache_req->bio;
 
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH))
-		return cache_flush(cache);
+		return pcache_cache_flush(cache);
 
 	if (bio_data_dir(bio) == READ)
 		return cache_read(cache, pcache_req);
-- 
2.51.0

