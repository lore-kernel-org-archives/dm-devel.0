From: heinzm@redhat.com
Subject: [PATCH 08/11] dm-raid: add new reshaping/raid10 format
	table line options to parameter parser
Date: Thu, 19 May 2016 18:49:31 +0200
Message-ID: <1463676574-12596-9-git-send-email-heinzm@redhat.com>
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

Support the follwoing arguments in the ctr parameter parser:

 - add 'delta_disks', 'data_offset' taking int and sector respectively

 - 'raid10_use_near_sets' bool argument to optionally select
   near sets with supporting raid10 mappings

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 48 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 3b2bdac..dac8dfa 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -140,6 +140,7 @@ struct raid_set {
 
 	int raid_disks;
 	int delta_disks;
+	int data_offset;
 	int raid10_copies;
 
 	struct mddev md;
@@ -241,6 +242,9 @@ struct arg_name_flag {
 	{ CTR_FLAG_REGION_SIZE, "region_size"},
 	{ CTR_FLAG_RAID10_COPIES, "raid10_copies"},
 	{ CTR_FLAG_RAID10_FORMAT, "raid10_format"},
+	{ CTR_FLAG_DATA_OFFSET, "data_offset"},
+	{ CTR_FLAG_DELTA_DISKS, "delta_disks"},
+	{ CTR_FLAG_RAID10_USE_NEAR_SETS, "raid10_use_near_sets"},
 };
 
 /* Return argument name string for given @flag */
@@ -948,22 +952,28 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 	 * Second, parse the unordered optional arguments
 	 */
 	for (i = 0; i < num_raid_params; i++) {
-		arg = dm_shift_arg(as);
-		if (!arg)
+		key = dm_shift_arg(as);
+		if (!key)
 			return ti_error_einval(rs->ti, "Not enough raid parameters given");
 
-		if (!strcasecmp(arg, "nosync")) {
+		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_NOSYNC))) {
+			if (_test_and_set_flag(CTR_FLAG_NOSYNC, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one 'nosync' argument allowed");
 			rs->md.recovery_cp = MaxSector;
-			_set_flag(CTR_FLAG_NOSYNC, &rs->ctr_flags);
 			continue;
 		}
-		if (!strcasecmp(arg, "sync")) {
+		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_SYNC))) {
+			if (_test_and_set_flag(CTR_FLAG_SYNC, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one 'sync' argument allowed");
 			rs->md.recovery_cp = 0;
-			_set_flag(CTR_FLAG_SYNC, &rs->ctr_flags);
+			continue;
+		}
+		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_RAID10_USE_NEAR_SETS))) {
+			if (_test_and_set_flag(CTR_FLAG_RAID10_USE_NEAR_SETS, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one 'raid10_use_new_sets' argument allowed");
 			continue;
 		}
 
-		key = arg;
 		arg = dm_shift_arg(as);
 		i++; /* Account for the argument pairs */
 		if (!arg)
@@ -975,7 +985,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		/* Parameter "raid10_format" which takes a string value is checked here. */
 		if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_RAID10_FORMAT))) {
 			if (_test_and_set_flag(CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
-				return ti_error_einval(rs->ti, "Only one raid10_format argument pair allowed");
+				return ti_error_einval(rs->ti, "Only one 'raid10_format' argument pair allowed");
 			if (!rt_is_raid10(rt))
 				return ti_error_einval(rs->ti, "'raid10_format' is an invalid parameter for this RAID type");
 			raid10_format = raid10_name_to_format(arg);
@@ -1032,6 +1042,26 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			if (!value || (value > MAX_SCHEDULE_TIMEOUT))
 				return ti_error_einval(rs->ti, "daemon sleep period out of range");
 			rs->md.bitmap_info.daemon_sleep = value;
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_DATA_OFFSET))) {
+			/* Userspace passes new data_offset after having extended the the data image LV */
+			if (_test_and_set_flag(CTR_FLAG_DATA_OFFSET, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one data_offset argument pair allowed");
+
+			/* Ensure sensible data offset */
+			if (value < 0)
+				return ti_error_einval(rs->ti, "Bogus data_offset value");
+
+			rs->data_offset = value;
+		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_DELTA_DISKS))) {
+			/* Define the +/-# of disks to add to/remove from the given raid set */
+			if (_test_and_set_flag(CTR_FLAG_DELTA_DISKS, &rs->ctr_flags))
+				return ti_error_einval(rs->ti, "Only one delta_disks argument pair allowed");
+
+			/* Ensure MAX_RAID_DEVICES and raid type minimal_devs! */
+			if (!_in_range(abs(value), 1, MAX_RAID_DEVICES - rt->minimal_devs))
+				return ti_error_einval(rs->ti, "Too many delta_disk requested");
+
+			rs->delta_disks = value;
 		} else if (!strcasecmp(key, _argname_by_flag(CTR_FLAG_STRIPE_CACHE))) {
 			if (_test_and_set_flag(CTR_FLAG_STRIPE_CACHE, &rs->ctr_flags))
 				return ti_error_einval(rs->ti, "Only one stripe_cache argument pair allowed");
@@ -1103,7 +1133,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		if ((rt->algorithm == ALGORITHM_RAID10_DEFAULT ||
 		     rt->algorithm == ALGORITHM_RAID10_NEAR) &&
 		    _test_flag(CTR_FLAG_RAID10_USE_NEAR_SETS, rs->ctr_flags))
-			return ti_error_einval(rs->ti, "RAID10 format \"near\" and \"raid10_use_near_sets\" are incompatible");
+			return ti_error_einval(rs->ti, "RAID10 format 'near' and 'raid10_use_near_sets' are incompatible");
 
 		/* (Len * #mirrors) / #devices */
 		sectors_per_dev = rs->ti->len * raid10_copies;
-- 
2.5.5
