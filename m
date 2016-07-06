From: heinzm@redhat.com
Subject: [PATCH 19/26] dm raid: fix rebuild and catch bogus
	sync/resync flags
Date: Wed,  6 Jul 2016 19:24:50 +0200
Message-ID: <1467825897-26058-20-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2fb5a9b..14b3d93 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1312,6 +1312,13 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		return -EINVAL;
 	}
 
+	if (test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags) &&
+	    (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) ||
+	     test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags))) {
+		rs->ti->error = "sync/nosync and rebuild are mutually exclusive";
+		return -EINVAL;
+	}
+
 	if (write_mostly >= rs->md.raid_disks) {
 		rs->ti->error = "Can't set all raid1 devices to write_mostly";
 		return -EINVAL;
@@ -2776,7 +2783,9 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	} else if (rs_is_recovering(rs) || rs_is_reshaping(rs)) {
 		/* Have to reject size change request during recovery/reshape */
 		if (calculated_dev_sectors != rs->dev[0].rdev.sectors) {
-			ti->error = "Can't resize a recovering/reshaping raid set";
+			ti->error = rs_is_recovering(rs) ?
+				    "Can't resize a recovering raid set" :
+				    "Can't resize a reshaping raid set";
 			r = -EPERM;
 			goto bad;
 		}
@@ -2863,8 +2872,12 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		rs_setup_recovery(rs, MaxSector);
 	} else {
 		rs_set_cur(rs);
-		rs_setup_recovery(rs, test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) ?
-				      0 : calculated_dev_sectors);
+		if (test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags)) {
+			rs_setup_recovery(rs, MaxSector);
+			set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
+		} else
+			rs_setup_recovery(rs, test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) ?
+					      0 : calculated_dev_sectors);
 	}
 
 	/* If constructor requested it, change data and new_data offsets */
-- 
2.5.5
