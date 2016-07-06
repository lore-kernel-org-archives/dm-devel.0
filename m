From: heinzm@redhat.com
Subject: [PATCH 18/26] dm raid: fix ctr memory leaks on error
	paths
Date: Wed,  6 Jul 2016 19:24:49 +0200
Message-ID: <1467825897-26058-19-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 109d698..2fb5a9b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2738,7 +2738,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	 */
 	r = rs_set_dev_and_array_sectors(rs, false);
 	if (r)
-		return r;
+		goto bad;
 
 	calculated_dev_sectors = rs->dev[0].rdev.sectors;
 
@@ -2769,20 +2769,23 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		if (rs_is_raid6(rs) &&
 		    test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags)) {
 			ti->error = "'nosync' not allowed for new raid6 set";
-			return -EINVAL;
+			r = -EINVAL;
+			goto bad;
 		}
 		rs_setup_recovery(rs, 0);
 	} else if (rs_is_recovering(rs) || rs_is_reshaping(rs)) {
 		/* Have to reject size change request during recovery/reshape */
 		if (calculated_dev_sectors != rs->dev[0].rdev.sectors) {
 			ti->error = "Can't resize a recovering/reshaping raid set";
-			return -EPERM;
+			r = -EPERM;
+			goto bad;
 		}
 		/* skip setup rs */
 	} else if (rs_takeover_requested(rs)) {
 		if (rs_is_reshaping(rs)) {
 			ti->error = "Can't takeover a reshaping raid set";
-			return -EPERM;
+			r = -EPERM;
+			goto bad;
 		}
 
 		/*
@@ -2792,11 +2795,11 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		 */
 		r = rs_check_takeover(rs);
 		if (r)
-			return r;
+			goto bad;
 
 		r = rs_setup_takeover(rs);
 		if (r)
-			return r;
+			goto bad;
 
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		set_bit(RT_FLAG_KEEP_RS_FROZEN, &rs->runtime_flags);
@@ -2804,7 +2807,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	} else if (rs_reshape_requested(rs)) {
 		if (rs_is_reshaping(rs)) {
 			ti->error = "raid set already reshaping!";
-			return -EPERM;
+			r = -EPERM;
+			goto bad;
 		}
 
 		if (rs_is_raid10(rs)) {
@@ -2820,7 +2824,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				 */
 				if (rs->raid_disks % rs->raid10_copies) {
 					ti->error = "Can't reshape raid10 mirror groups";
-					return -EINVAL;
+					r = -EINVAL;
+					goto bad;
 				}
 
 				/* Userpace reordered disks to add/remove mirrors -> adjust raid_disk indexes */
@@ -2865,7 +2870,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	/* If constructor requested it, change data and new_data offsets */
 	r = rs_adjust_data_offsets(rs);
 	if (r)
-		return r;
+		goto bad;
 
 	/* Start raid set read-only and assumed clean to change in raid_resume() */
 	rs->md.ro = 1;
@@ -2899,7 +2904,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		r = rs_check_reshape(rs);
 		if (r)
-			return r;
+			goto bad_check_reshape;
 
 		/* Restore new, ctr requested layout to perform check */
 		rs_config_restore(rs, &rs_layout);
-- 
2.5.5
