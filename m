From: heinzm@redhat.com
Subject: [PATCH] dm raid: wrong status char during
	resynchronization
Date: Wed,  3 Aug 2016 22:57:42 +0200
Message-ID: <1470257862-24490-1-git-send-email-heinzm@redhat.com>
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

During a resynchronization, device status char 'a' is
put on the raid status line for every device of a RAID set
changing to 'A' (unless device failure) when completed.

Interrupting and restarting an resynchronization by
reloading the table erroneously lead to status char 'A'.

Solve by avoiding superfluous MD_RECOVERY_REQUESTED flag
in raid_preresume().

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5ef6b5a..d20050c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3577,7 +3577,6 @@ static int raid_preresume(struct dm_target *ti)
 	/* Be prepared for mddev_resume() in raid_resume() */
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	if (mddev->recovery_cp && mddev->recovery_cp < MaxSector) {
-		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		mddev->resync_min = mddev->recovery_cp;
 	}
-- 
2.5.5
