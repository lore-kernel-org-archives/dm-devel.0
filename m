From: heinzm@redhat.com
Subject: [PATCH 12/26] dm raid: prohibit 'nosync' on new raid6
	and reject resize during reshape
Date: Wed,  6 Jul 2016 19:24:43 +0200
Message-ID: <1467825897-26058-13-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7e334b6..6dc4940 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2752,9 +2752,21 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (test_bit(MD_ARRAY_FIRST_USE, &rs->md.flags)) {
 		set_bit(RT_FLAG_UPDATE_SBS, &rs->runtime_flags);
 		rs_set_new(rs);
-	} else if (rs_is_reshaping(rs))
-		; /* skip rs setup */
-	else if (rs_takeover_requested(rs)) {
+		/* A new raid6 set has to be recovered to ensure proper parity and Q-Syndrome */
+		if (rs_is_raid6(rs) &&
+		    test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags)) {
+			ti->error = "'nosync' not allowed for new raid6 set";
+			return -EINVAL;
+		}
+		rs_setup_recovery(rs, 0);
+	} else if (rs_is_reshaping(rs)) {
+		/* Have to reject size change request during reshape */
+		if (calculated_dev_sectors != rs->dev[0].rdev.sectors) {
+			ti->error = "Can't resize a reshaping raid set";
+			return -EPERM;
+		}
+		/* skip setup rs */
+	} else if (rs_takeover_requested(rs)) {
 		if (rs_is_reshaping(rs)) {
 			ti->error = "Can't takeover a reshaping raid set";
 			return -EPERM;
-- 
2.5.5
