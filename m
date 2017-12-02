From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH V2 05/12] dm raid: enhance resume() frozen checks
Date: Sat,  2 Dec 2017 01:03:52 +0100
Message-ID: <1b6628ea47d120598fedd2852c12ddb1cb85db22.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
In-Reply-To: <cover.1512171097.git.heinzm@redhat.com>
References: <cover.1512171097.git.heinzm@redhat.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

In case userspace reloads multiple times thus reading
the superblocks, the raid set needs to stay frozen in
case of a reshape request until all config changes
(chunk size, layout data_offset, delta_disks) have
been stored in the superblocks and respective
flags cleared.
---
 drivers/md/dm-raid.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 3b0964c7da17..e37ee5f8ed3d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3885,7 +3885,7 @@ static int raid_preresume(struct dm_target *ti)
 	}
 
 	/* Check for any reshape request unless new raid set */
-	if (test_and_clear_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
+	if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		/* Initiate a reshape. */
 		rs_set_rdev_sectors(rs);
 		mddev_lock_nointr(mddev);
@@ -3927,8 +3927,15 @@ static void raid_resume(struct dm_target *ti)
 	 * This ensures that the constructor for the inactive table
 	 * retrieves an up-to-date reshape_position.
 	 */
-	if (!(rs->ctr_flags & RESUME_STAY_FROZEN_FLAGS))
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	if (!test_and_clear_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags) &&
+	    !(rs->ctr_flags & RESUME_STAY_FROZEN_FLAGS)) {
+		if (rs_is_reshapable(rs)) {
+			if (!rs_is_reshaping(rs) ||
+			    _get_reshape_sectors(rs))
+				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		} else
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
 		mddev_lock_nointr(mddev);
-- 
2.13.6
