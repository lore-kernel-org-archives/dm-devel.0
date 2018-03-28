From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH v3] dm raid: fix parse_raid_params() variable
	range issue
Date: Wed, 28 Mar 2018 17:07:14 +0200
Message-ID: <b780a63ecdc48d98c8262a34c7749c6739e8490c.1522245017.git.heinzm@redhat.com>
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
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

parse_raid_params() compares variable "int value" with INT_MAX.

E.g. related Coverity report excerpt:
   CID 1364818 (#2 of 3): Operands don't affect result (CONSTANT_EXPRESSION_RESULT) [select issue]
1433                        if (value > INT_MAX) {

Fix by changing checks to avoid INT_MAX.

Whilst on it, avoid unnecessary checks against constants
and add check for sane recovery speed min/max.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c1d1034ff7b7..b73e2e791d2b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1370,19 +1370,18 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			 * In device-mapper, we specify things in sectors, but
 			 * MD records this value in kB
 			 */
-			value /= 2;
-			if (value > COUNTER_MAX) {
+			if (value < 0 || value / 2 > COUNTER_MAX) {
 				rs->ti->error = "Max write-behind limit out of range";
 				return -EINVAL;
 			}
 
-			rs->md.bitmap_info.max_write_behind = value;
+			rs->md.bitmap_info.max_write_behind = value / 2;
 		} else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_DAEMON_SLEEP))) {
 			if (test_and_set_bit(__CTR_FLAG_DAEMON_SLEEP, &rs->ctr_flags)) {
 				rs->ti->error = "Only one daemon_sleep argument pair allowed";
 				return -EINVAL;
 			}
-			if (!value || (value > MAX_SCHEDULE_TIMEOUT)) {
+			if (value < 0) {
 				rs->ti->error = "daemon sleep period out of range";
 				return -EINVAL;
 			}
@@ -1424,27 +1423,33 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				return -EINVAL;
 			}
 
+			if (value < 0) {
+				rs->ti->error = "Bogus stripe cache entries value";
+				return -EINVAL;
+			}
 			rs->stripe_cache_entries = value;
 		} else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_MIN_RECOVERY_RATE))) {
 			if (test_and_set_bit(__CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags)) {
 				rs->ti->error = "Only one min_recovery_rate argument pair allowed";
 				return -EINVAL;
 			}
-			if (value > INT_MAX) {
+
+			if (value < 0) {
 				rs->ti->error = "min_recovery_rate out of range";
 				return -EINVAL;
 			}
-			rs->md.sync_speed_min = (int)value;
+			rs->md.sync_speed_min = value;
 		} else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_MAX_RECOVERY_RATE))) {
 			if (test_and_set_bit(__CTR_FLAG_MAX_RECOVERY_RATE, &rs->ctr_flags)) {
 				rs->ti->error = "Only one max_recovery_rate argument pair allowed";
 				return -EINVAL;
 			}
-			if (value > INT_MAX) {
+
+			if (value < 0) {
 				rs->ti->error = "max_recovery_rate out of range";
 				return -EINVAL;
 			}
-			rs->md.sync_speed_max = (int)value;
+			rs->md.sync_speed_max = value;
 		} else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_REGION_SIZE))) {
 			if (test_and_set_bit(__CTR_FLAG_REGION_SIZE, &rs->ctr_flags)) {
 				rs->ti->error = "Only one region_size argument pair allowed";
@@ -1490,6 +1495,12 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 		return -EINVAL;
 	}
 
+	if (rs->md.sync_speed_max &&
+	    rs->md.sync_speed_min > rs->md.sync_speed_max) {
+		rs->ti->error = "Bogus recovery rates";
+		return -EINVAL;
+	}
+
 	if (validate_region_size(rs, region_size))
 		return -EINVAL;
 
-- 
2.14.3
