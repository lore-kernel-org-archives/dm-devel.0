From: heinzm@redhat.com
Subject: [PATCH] dm raid: fix processing of max_recovery_rate
	constructor flag
Date: Wed, 27 Jul 2016 23:33:52 +0200
Message-ID: <1469655232-19231-1-git-send-email-heinzm@redhat.com>
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

__CTR_FLAG_MIN_RECOVERY_RATE was used instead of __CTR_FLAG_MAX_RECOVERY_RATE
thus causing max_recovery_rate to be rejected in case min_recovery_rate
was already set.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8498354..5ef6b5a 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1270,7 +1270,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
 			}
 			rs->md.sync_speed_min = (int)value;
 		} else if (!strcasecmp(key, dm_raid_arg_name_by_flag(CTR_FLAG_MAX_RECOVERY_RATE))) {
-			if (test_and_set_bit(__CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags)) {
+			if (test_and_set_bit(__CTR_FLAG_MAX_RECOVERY_RATE, &rs->ctr_flags)) {
 				rs->ti->error = "Only one max_recovery_rate argument pair allowed";
 				return -EINVAL;
 			}
-- 
2.5.5
