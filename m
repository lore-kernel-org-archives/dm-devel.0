From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 1/4] [perstent-data] Simplify
	dm_bm_flush_and_unlock() -> dm_bm_flush()
Date: Thu, 27 Mar 2014 14:13:20 +0000
Message-ID: <1395929603-14604-2-git-send-email-ejt@redhat.com>
References: <1395929603-14604-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1395929603-14604-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

Now you have to do the unlock yourself.
---
 drivers/md/persistent-data/dm-block-manager.c |   15 ++-------------
 drivers/md/persistent-data/dm-block-manager.h |    3 +--
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 5c80855..9618a65 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -609,25 +609,14 @@ int dm_bm_unlock(struct dm_block *b)
 }
 EXPORT_SYMBOL_GPL(dm_bm_unlock);
 
-int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
-			   struct dm_block *superblock)
+int dm_bm_flush(struct dm_block_manager *bm)
 {
-	int r;
-
 	if (bm->read_only)
 		return -EPERM;
 
-	r = dm_bufio_write_dirty_buffers(bm->bufio);
-	if (unlikely(r)) {
-		dm_bm_unlock(superblock);
-		return r;
-	}
-
-	dm_bm_unlock(superblock);
-
 	return dm_bufio_write_dirty_buffers(bm->bufio);
 }
-EXPORT_SYMBOL_GPL(dm_bm_flush_and_unlock);
+EXPORT_SYMBOL_GPL(dm_bm_flush);
 
 void dm_bm_prefetch(struct dm_block_manager *bm, dm_block_t b)
 {
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index 13cd58e..1b95dfc 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -105,8 +105,7 @@ int dm_bm_unlock(struct dm_block *b);
  *
  * This method always blocks.
  */
-int dm_bm_flush_and_unlock(struct dm_block_manager *bm,
-			   struct dm_block *superblock);
+int dm_bm_flush(struct dm_block_manager *bm);
 
 /*
  * Request data is prefetched into the cache.
-- 
1.7.10.4
