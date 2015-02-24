From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/4] dm: remove unnecessary wrapper around
	blk_lld_busy
Date: Tue, 24 Feb 2015 11:44:07 -0500
Message-ID: <1424796250-38553-2-git-send-email-snitzer@redhat.com>
References: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1424796250-38553-1-git-send-email-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, shivakrishna.merla@netapp.com, jmoyer@redhat.com
List-Id: dm-devel.ids

There is no need for DM to export a wrapper around the already exported
blk_lld_busy().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c         | 2 +-
 drivers/md/dm.c               | 6 ------
 include/linux/device-mapper.h | 5 -----
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d376dc8..add6391 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1627,7 +1627,7 @@ static int __pgpath_busy(struct pgpath *pgpath)
 {
 	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
 
-	return dm_underlying_device_busy(q);
+	return blk_lld_busy(q);
 }
 
 /*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 73f2880..1766ba0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2003,12 +2003,6 @@ out:
 	dm_put_live_table(md, srcu_idx);
 }
 
-int dm_underlying_device_busy(struct request_queue *q)
-{
-	return blk_lld_busy(q);
-}
-EXPORT_SYMBOL_GPL(dm_underlying_device_busy);
-
 static int dm_lld_busy(struct request_queue *q)
 {
 	int r;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 2646aed..3e4db11 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -604,9 +604,4 @@ static inline unsigned long to_bytes(sector_t n)
 	return (n << SECTOR_SHIFT);
 }
 
-/*-----------------------------------------------------------------
- * Helper for block layer and dm core operations
- *---------------------------------------------------------------*/
-int dm_underlying_device_busy(struct request_queue *q);
-
 #endif	/* _LINUX_DEVICE_MAPPER_H */
-- 
1.9.3 (Apple Git-50)
