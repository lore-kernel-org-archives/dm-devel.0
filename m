From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: return ENOSPC instead of EIO when
	error_if_no_space enabled
Date: Thu, 22 May 2014 14:12:44 -0400
Message-ID: <1400782364-6537-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: sandeen@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Update the DM thin provisioning target's allocation failure error to be
consistent with commit a9d6ceb8 ("[SCSI] return ENOSPC on thin
provisioning failure").

The DM thin target now returns -ENOSPC rather than -EIO when
block allocation fails due to the pool being out of data space (and
the 'error_if_no_space' thin-pool feature is enabled).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c31f5f1..b77e919 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1021,7 +1021,7 @@ static void retry_on_resume(struct bio *bio)
 	spin_unlock_irqrestore(&tc->lock, flags);
 }
 
-static bool should_error_unserviceable_bio(struct pool *pool)
+static int should_error_unserviceable_bio(struct pool *pool)
 {
 	enum pool_mode m = get_pool_mode(pool);
 
@@ -1029,25 +1029,27 @@ static bool should_error_unserviceable_bio(struct pool *pool)
 	case PM_WRITE:
 		/* Shouldn't get here */
 		DMERR_LIMIT("bio unserviceable, yet pool is in PM_WRITE mode");
-		return true;
+		return -EIO;
 
 	case PM_OUT_OF_DATA_SPACE:
-		return pool->pf.error_if_no_space;
+		return pool->pf.error_if_no_space ? -ENOSPC : 0;
 
 	case PM_READ_ONLY:
 	case PM_FAIL:
-		return true;
+		return -EIO;
 	default:
 		/* Shouldn't get here */
 		DMERR_LIMIT("bio unserviceable, yet pool has an unknown mode");
-		return true;
+		return -EIO;
 	}
 }
 
 static void handle_unserviceable_bio(struct pool *pool, struct bio *bio)
 {
-	if (should_error_unserviceable_bio(pool))
-		bio_io_error(bio);
+	int error = should_error_unserviceable_bio(pool);
+
+	if (error)
+		bio_endio(bio, error);
 	else
 		retry_on_resume(bio);
 }
-- 
1.7.4.4
