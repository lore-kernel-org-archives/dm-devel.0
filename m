Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F9C3451CC
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 03:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791947553; cv=none; b=O5JrpydvRXpjxi9LHzhNlGLBe8CP+KYMZ98lDX41+ccDNhDME3+P460/flj6WiLkfTcDWLFfV8GS9xX1KlF/4lWAiCxnd0jFHtbrHqvuAu0FFy7YiCvCALEJIQ3gi0bmGpQA8ybmWUAfkGRVsF1Sc/EGpUX8FRvIDupOdrqZ0yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791947553; c=relaxed/simple;
	bh=BUSSFbKZ6VZ0+BfQXbAFUwaLxWgSvnNJ9CA8J/jeVOo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CbU6PbzeB7uDjoE08Clf+Lbg2PZjLF700JtzzRmXsFgL/O+jRUn8NY1hCrDnfWCvQWcAxTgZyiYSZK3LRqcQpXcctlojVnXdCX3Ul3F/82ZK1EUpl/jR0m42WbGiuSPo/2cRvERv0I/0AoIVpo5RdmHJ8RUTMuA1NB69QhNZfTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=ABWBU/h0; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="ABWBU/h0"
Received: from localhost (gyproxy-mailtls2-entmail-virt217.gy.ntes [39.144.128.132])
	by smtp.qiye.163.com (Hmail) with ESMTP id 50f4eaf67;
	Wed, 14 Oct 2026 11:12:18 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH] dm-pcache: do not advance dirty_tail after backing flush failure
Date: Wed, 14 Oct 2026 03:11:50 +0000
Message-Id: <20261014031150.3913245-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1386580dc03a2kunm5c4b65fd20844
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSR1PVk5JSxhMSUxCTB1DSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlIQlVKT09VSklDVUpISVlXWRYaDxIVHRRZQVlPS0hVSktJQk
	NDTFVKS0tVS1kG
DKIM-Signature: a=rsa-sha256;
	b=ABWBU/h04LfN9+YaSAzOMJqEV+Ojl+tZ1jSrkfvo+aZ7kGS9BmKzSM45qMLA+8poyXqX0v1PS53Z0YR+IE+ySPpjPTggDJzhsvRy9yyth6qZaFxYs2FzpoyRHH1e6qGg1C8uSFx+kmCyofVGKwiQuKLx4rlwsyLXfX74MOnVMBY=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=oD548kiL8wsHFNxFMntc62Ulyta0dtgOgui/GaSRvz4=;
	h=date:mime-version:subject:message-id:from;

After all writeback bios for a kset complete, writeback_ctx_end()
flushes the backing device and then advances the persistent dirty_tail.
However, backing_dev_flush() discards the error returned by
blkdev_issue_flush(), so dirty_tail is advanced even when the written
data is not known to be durable.

dirty_tail points to the first kset that still requires writeback.
Advancing it causes recovery to treat the preceding kset as clean and
allows its cache copy to eventually be reclaimed by garbage collection.
If the backing device flush failed, a subsequent power failure may
therefore result in data loss.

Make backing_dev_flush() return the flush status and handle a flush
failure like a writeback I/O failure. Leave dirty_tail unchanged so
that the same kset will be retried.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
 drivers/md/dm-pcache/backing_dev.c     |  4 ++--
 drivers/md/dm-pcache/backing_dev.h     |  2 +-
 drivers/md/dm-pcache/cache_writeback.c | 28 +++++++++++++++++++-------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcache/backing_dev.c
index 7165fc0364bb..0c15bb01068e 100644
--- a/drivers/md/dm-pcache/backing_dev.c
+++ b/drivers/md/dm-pcache/backing_dev.c
@@ -336,9 +336,9 @@ struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev
 	return backing_req;
 }
 
-void backing_dev_flush(struct pcache_backing_dev *backing_dev)
+int backing_dev_flush(struct pcache_backing_dev *backing_dev)
 {
-	blkdev_issue_flush(backing_dev->dm_dev->bdev);
+	return blkdev_issue_flush(backing_dev->dm_dev->bdev);
 }
 
 int pcache_backing_init(void)
diff --git a/drivers/md/dm-pcache/backing_dev.h b/drivers/md/dm-pcache/backing_dev.h
index b371cba483b9..8422e5e76e29 100644
--- a/drivers/md/dm-pcache/backing_dev.h
+++ b/drivers/md/dm-pcache/backing_dev.h
@@ -120,7 +120,7 @@ struct pcache_backing_dev_req *backing_dev_req_alloc(struct pcache_backing_dev *
 						struct pcache_backing_dev_req_opts *opts);
 void backing_dev_req_init(struct pcache_backing_dev_req *backing_req,
 			struct pcache_backing_dev_req_opts *opts);
-void backing_dev_flush(struct pcache_backing_dev *backing_dev);
+int backing_dev_flush(struct pcache_backing_dev *backing_dev);
 
 int pcache_backing_init(void);
 void pcache_backing_exit(void);
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index c8a4c8110a58..e09560f172dd 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -18,12 +18,18 @@ static void writeback_ctx_end(struct pcache_cache *cache, int ret)
 		return;
 
 	if (!cache->writeback_ctx.ret) {
-		backing_dev_flush(cache->backing_dev);
-
-		mutex_lock(&cache->dirty_tail_lock);
-		cache_pos_advance(&cache->dirty_tail, cache->writeback_ctx.advance);
-		cache_encode_dirty_tail(cache);
-		mutex_unlock(&cache->dirty_tail_lock);
+		ret = backing_dev_flush(cache->backing_dev);
+		if (ret) {
+			pcache_dev_err(CACHE_TO_PCACHE(cache),
+				       "failed to flush backing device: %d", ret);
+			cache->writeback_ctx.ret = ret;
+		} else {
+			mutex_lock(&cache->dirty_tail_lock);
+			cache_pos_advance(&cache->dirty_tail,
+					  cache->writeback_ctx.advance);
+			cache_encode_dirty_tail(cache);
+			mutex_unlock(&cache->dirty_tail_lock);
+		}
 	}
 	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
 }
@@ -76,8 +82,16 @@ static inline bool is_cache_clean(struct pcache_cache *cache, struct pcache_cach
 
 void cache_writeback_exit(struct pcache_cache *cache)
 {
+	int ret;
+
 	cancel_delayed_work_sync(&cache->writeback_work);
-	backing_dev_flush(cache->backing_dev);
+
+	ret = backing_dev_flush(cache->backing_dev);
+	if (ret)
+		pcache_dev_err(CACHE_TO_PCACHE(cache),
+			       "failed to flush backing device during exit: %d",
+			       ret);
+
 	cache_tree_exit(&cache->writeback_key_tree);
 }
 
-- 
2.34.1

