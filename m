From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 4/5] dm raid: simplify rs_get_progress()
Date: Wed, 13 Dec 2017 03:02:37 +0100
Message-ID: <e66e04f17e907da14f73d09c7959a27c74b44c17.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
In-Reply-To: <cover.1513125666.git.heinzm@redhat.com>
References: <cover.1513125666.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

No need to calculate the reshaping progress because
mddev->curr_resync_completed holds it.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f5db4ce69d6b..41a411526b27 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3399,26 +3399,9 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
-		/* Reshape is relative to the array size */
-		if (test_bit(MD_RECOVERY_RESHAPE, &recovery)) {
-			r = mddev->reshape_position;
-			if (r != MaxSector) {
-				/* Got to reverse on backward reshape */
-				if (mddev->reshape_backwards)
-					r = mddev->array_sectors - r;
-
-				/* Divide by # of data stripes unless raid1 */
-				if (!rs_is_raid1(rs))
-					sector_div(r, mddev_data_stripes(rs));
-			}
-
-		/*
-		 * Sync/recover is relative to the component device size.
-		 *
-		 * MD_RECOVERY_NEEDED for https://bugzilla.redhat.com/show_bug.cgi?id=1508070
-		 */
-		} else if (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
-			   test_bit(MD_RECOVERY_RUNNING, &recovery))
+		if (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
+		    test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
+		    test_bit(MD_RECOVERY_RUNNING, &recovery))
 			r = mddev->curr_resync_completed;
 		else
 			r = mddev->recovery_cp;
-- 
2.13.6
