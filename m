From: heinzm@redhat.com
Subject: [PATCH 06/11] dm-raid: use rt_is_raid*() in all
	appropriate checks
Date: Thu, 19 May 2016 18:49:29 +0200
Message-ID: <1463676574-12596-7-git-send-email-heinzm@redhat.com>
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

Make use if raid type rt_is_*() bool functions for
simplification and consistency resons.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7f85243..50bdd7e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -260,6 +260,12 @@ static bool rt_is_raid6(struct raid_type *rt)
 {
 	return rt->level == 6;
 }
+
+/* Return true, if raid type in @rt is raid4/5/6 */
+static bool rt_is_raid456(struct raid_type *rt)
+{
+	return _in_range(rt->level, 4, 6);
+}
 /* END: raid level bools */
 
 /*
@@ -725,7 +731,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	 * First, parse the in-order required arguments
 	 * "chunk_size" is the only argument of this type.
 	 */
-	if (rs->raid_type->level == 1) {
+	if (rt_is_raid1(rs->raid_type)) {
 		if (value)
 			DMERR("Ignoring chunk size parameter for RAID 1");
 		value = 0;
@@ -790,7 +796,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_RAID10_FORMAT))) {
 			if (_test_and_set_flag(CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
 				return ti_error_einval(rs->ti, "Only one raid10_format argument pair allowed");
-			if (rs->raid_type->level != 10)
+			if (!rt_is_raid10(rs->raid_type))
 				return ti_error_einval(rs->ti, "'raid10_format' is an invalid parameter for this RAID type");
 			if (strcmp("near", arg) &&
 			    strcmp("far", arg) &&
@@ -819,7 +825,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			rd->rdev.recovery_offset = 0;
 			_set_flag(CTR_FLAG_REBUILD, &rs->ctr_flags);
 		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_WRITE_MOSTLY))) {
-			if (rs->raid_type->level != 1)
+			if (!rt_is_raid1(rs->raid_type))
 				return ti_error_einval(rs->ti, "write_mostly option is only valid for RAID1");
  
 			if (!_in_range(value, 0, rs->md.raid_disks - 1))
@@ -828,7 +834,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			set_bit(WriteMostly, &rs->dev[value].rdev.flags);
 			_set_flag(CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags);
 		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_MAX_WRITE_BEHIND))) {
-			if (rs->raid_type->level != 1)
+			if (!rt_is_raid1(rs->raid_type))
 				return ti_error_einval(rs->ti, "max_write_behind option is only valid for RAID1");
 
 			if (_test_and_set_flag(CTR_FLAG_MAX_WRITE_BEHIND, &rs->ctr_flags))
@@ -858,7 +864,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			 */
 			value /= 2;
 
-			if (!_in_range(rs->raid_type->level, 4, 6))
+			if (!rt_is_raid456(rs->raid_type))
 				return ti_error_einval(rs->ti, "Inappropriate argument: stripe_cache");
 			if (raid5_set_cache_size(&rs->md, (int)value))
 				return ti_error_einval(rs->ti, "Bad stripe_cache size");
@@ -905,7 +911,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
 		return -EINVAL;
 
-	if (rs->raid_type->level == 10) {
+	if (rt_is_raid10(rs->raid_type)) {
 		if (raid10_copies > rs->md.raid_disks)
 			return ti_error_einval(rs->ti, "Not enough devices to satisfy specification");
 
@@ -923,7 +929,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		rs->md.layout = raid10_format_to_md_layout(raid10_format,
 							   raid10_copies);
 		rs->md.new_layout = rs->md.layout;
-	} else if ((!rs->raid_type->level || rs->raid_type->level > 1) &&
+	} else if (!rt_is_raid1(rs->raid_type) &&
 		   sector_div(sectors_per_dev,
 			      (rs->md.raid_disks - rs->raid_type->parity_devs)))
 		return ti_error_einval(rs->ti, "Target length not divisible by number of data devices");
@@ -1144,7 +1150,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 	}
 
 	/* We can only change the number of devices in RAID1 right now */
-	if ((rs->raid_type->level != 1) &&
+	if (!rt_is_raid1(rs->raid_type) &&
 	    (le32_to_cpu(sb->num_devices) != mddev->raid_disks)) {
 		DMERR("Reshaping arrays not yet supported. (device count change)");
 		return -EINVAL;
@@ -1208,7 +1214,7 @@ static int super_init_validation(struct mddev *mddev, struct md_rdev *rdev)
 		if (!test_bit(FirstUse, &r->flags) && (r->raid_disk >= 0)) {
 			role = le32_to_cpu(sb2->array_position);
 			if (role != r->raid_disk) {
-				if (rs->raid_type->level != 1)
+				if (!rt_is_raid1(rs->raid_type))
 					return ti_error_einval(rs->ti, "Cannot change device "
 								       "positions in RAID array");
 				DMINFO("RAID1 device #%d now at position #%d",
@@ -1240,7 +1246,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
 		return -EINVAL;
 
 	/* Enable bitmap creation for RAID levels != 0 */
-	mddev->bitmap_info.offset = (rs->raid_type->level) ? to_sector(4096) : 0;
+	mddev->bitmap_info.offset = rt_is_raid0(rs->raid_type) ? 0 : to_sector(4096);
 	rdev->mddev->bitmap_info.default_offset = mddev->bitmap_info.offset;
 
 	if (!test_bit(FirstUse, &rdev->flags)) {
@@ -1561,7 +1567,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_INFO:
 		DMEMIT("%s %d ", rs->raid_type->name, rs->md.raid_disks);
 
-		if (rs->raid_type->level) {
+		if (!rt_is_raid0(rs->raid_type)) {
 			if (test_bit(MD_RECOVERY_RUNNING, &rs->md.recovery))
 				sync = rs->md.curr_resync_completed;
 			else
@@ -1883,7 +1889,7 @@ static void raid_resume(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
-	if (rs->raid_type->level) {
+	if (!rt_is_raid0(rs->raid_type)) {
 		set_bit(MD_CHANGE_DEVS, &rs->md.flags);
 
 		if (!rs->bitmap_loaded) {
-- 
2.5.5
