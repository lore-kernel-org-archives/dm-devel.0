From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: use __within_range() more in
	parse_raid_params()
Date: Mon, 19 Mar 2018 17:28:26 +0100
Message-ID: <1468ea2ed50e3fa3194e61b6ff5057d9db323ab4.1521476841.git.heinzm@redhat.com>
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

parse_raid_params() doesn't use __with_rnage() to check
argument values throughout.  Add where appropriate.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7ffa1839b206..38c53632dfeb 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1371,7 +1371,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			 * MD records this value in kB
 			 */
 			value /= 2;
-			if (value > COUNTER_MAX) {
+			if (!__within_range(value, 1, COUNTER_MAX)) {
 				rs->ti->error = "Max write-behind limit out of range";
 				return -EINVAL;
 			}
@@ -1382,7 +1382,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				rs->ti->error = "Only one daemon_sleep argument pair allowed";
 				return -EINVAL;
 			}
-			if (!value || (value > MAX_SCHEDULE_TIMEOUT)) {
+			if (!__within_range(value, 1, MAX_SCHEDULE_TIMEOUT)) {
 				rs->ti->error = "daemon sleep period out of range";
 				return -EINVAL;
 			}
@@ -1430,7 +1430,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				rs->ti->error = "Only one min_recovery_rate argument pair allowed";
 				return -EINVAL;
 			}
-			if (value > INT_MAX) {
+			if (!__within_range(value, 1, INT_MAX)) {
 				rs->ti->error = "min_recovery_rate out of range";
 				return -EINVAL;
 			}
@@ -1440,7 +1440,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 				rs->ti->error = "Only one max_recovery_rate argument pair allowed";
 				return -EINVAL;
 			}
-			if (value > INT_MAX) {
+			if (!__within_range(value, 1, INT_MAX)) {
 				rs->ti->error = "max_recovery_rate out of range";
 				return -EINVAL;
 			}
-- 
2.14.3
