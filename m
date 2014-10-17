From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 11/17] dm thin: grab a virtual cell
	before looking up the mapping
Date: Fri, 17 Oct 2014 02:07:01 -0400
Message-ID: <1413526027-21630-12-git-send-email-snitzer@redhat.com>
References: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Avoids normal IO racing with discard.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-thin.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index dc3efac..b9b6afb 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1998,6 +1998,14 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
+	/*
+	 * We must hold the virtual cell before doing the lookup, otherwise
+	 * there's a race with discard.
+	 */
+	build_virtual_key(tc->td, block, &key);
+	if (dm_bio_detain(tc->pool->prison, &key, bio, &cell1, &cell_result))
+		return DM_MAPIO_SUBMITTED;
+
 	r = dm_thin_find_block(td, block, 0, &result);
 
 	/*
@@ -2021,13 +2029,10 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			 * shared flag will be set in their case.
 			 */
 			thin_defer_bio(tc, bio);
+			cell_defer_no_holder_no_free(tc, &cell1);
 			return DM_MAPIO_SUBMITTED;
 		}
 
-		build_virtual_key(tc->td, block, &key);
-		if (dm_bio_detain(tc->pool->prison, &key, bio, &cell1, &cell_result))
-			return DM_MAPIO_SUBMITTED;
-
 		build_data_key(tc->td, result.block, &key);
 		if (dm_bio_detain(tc->pool->prison, &key, bio, &cell2, &cell_result)) {
 			cell_defer_no_holder_no_free(tc, &cell1);
@@ -2048,12 +2053,14 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 			 * of doing so.
 			 */
 			handle_unserviceable_bio(tc->pool, bio);
+			cell_defer_no_holder_no_free(tc, &cell1);
 			return DM_MAPIO_SUBMITTED;
 		}
 		/* fall through */
 
 	case -EWOULDBLOCK:
 		thin_defer_bio(tc, bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 
 	default:
@@ -2063,6 +2070,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		 * pool is switched to fail-io mode.
 		 */
 		bio_io_error(bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
 		return DM_MAPIO_SUBMITTED;
 	}
 }
-- 
1.9.3
