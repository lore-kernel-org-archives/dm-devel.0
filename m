From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10] block: move bounce declarations to block/blk.h
Date: Mon, 19 Jun 2017 09:26:21 +0200
Message-ID: <20170619072628.12894-4-hch@lst.de>
References: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170619072628.12894-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h            | 13 +++++++++++++
 block/bounce.c         |  1 +
 include/linux/blkdev.h | 13 -------------
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 83c8e1100525..4576fb5a8006 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -334,4 +334,17 @@ static inline void blk_throtl_bio_endio(struct bio *bio) { }
 static inline void blk_throtl_stat_add(struct request *rq, u64 time) { }
 #endif
 
+#ifdef CONFIG_BOUNCE
+extern int init_emergency_isa_pool(void);
+extern void blk_queue_bounce(struct request_queue *q, struct bio **bio);
+#else
+static inline int init_emergency_isa_pool(void)
+{
+	return 0;
+}
+static inline void blk_queue_bounce(struct request_queue *q, struct bio **bio)
+{
+}
+#endif /* CONFIG_BOUNCE */
+
 #endif /* BLK_INTERNAL_H */
diff --git a/block/bounce.c b/block/bounce.c
index b7e44bd59d7c..fc79dd3e0f20 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -22,6 +22,7 @@
 #include <asm/tlbflush.h>
 
 #include <trace/events/block.h>
+#include "blk.h"
 
 #define POOL_SIZE	64
 #define ISA_POOL_SIZE	16
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 22cfba64ce81..f1a5f82a4d97 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -863,19 +863,6 @@ extern unsigned long blk_max_low_pfn, blk_max_pfn;
 #define BLK_DEFAULT_SG_TIMEOUT	(60 * HZ)
 #define BLK_MIN_SG_TIMEOUT	(7 * HZ)
 
-#ifdef CONFIG_BOUNCE
-extern int init_emergency_isa_pool(void);
-extern void blk_queue_bounce(struct request_queue *q, struct bio **bio);
-#else
-static inline int init_emergency_isa_pool(void)
-{
-	return 0;
-}
-static inline void blk_queue_bounce(struct request_queue *q, struct bio **bio)
-{
-}
-#endif /* CONFIG_MMU */
-
 struct rq_map_data {
 	struct page **pages;
 	int page_order;
-- 
2.11.0
