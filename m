From: heinzm@redhat.com
Subject: [PATCH 16/26] dm raid: also reject size change during
	recovery
Date: Wed,  6 Jul 2016 19:24:47 +0200
Message-ID: <1467825897-26058-17-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5e41bf3..7a33af9 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2772,10 +2772,10 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			return -EINVAL;
 		}
 		rs_setup_recovery(rs, 0);
-	} else if (rs_is_reshaping(rs)) {
-		/* Have to reject size change request during reshape */
+	} else if (rs_is_recovering(rs) || rs_is_reshaping(rs)) {
+		/* Have to reject size change request during recovery/reshape */
 		if (calculated_dev_sectors != rs->dev[0].rdev.sectors) {
-			ti->error = "Can't resize a reshaping raid set";
+			ti->error = "Can't resize a recovering/reshaping raid set";
 			return -EPERM;
 		}
 		/* skip setup rs */
-- 
2.5.5
