From: heinzm@redhat.com
Subject: [PATCH 20/26] dm raid: fix rs_is_recovering() to allow
	for lvextend
Date: Wed,  6 Jul 2016 19:24:51 +0200
Message-ID: <1467825897-26058-21-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 14b3d93..1ff469f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -372,7 +372,7 @@ static bool rs_is_reshapable(struct raid_set *rs)
 /* Return true, if raid set in @rs is recovering */
 static bool rs_is_recovering(struct raid_set *rs)
 {
-	return rs->md.recovery_cp != MaxSector;
+	return rs->md.recovery_cp < rs->dev[0].rdev.sectors;
 }
 
 /* Return true, if raid set in @rs is reshaping */
@@ -3532,7 +3532,7 @@ static int raid_preresume(struct dm_target *ti)
 
 	rs_set_capacity(rs);
 
-	/* Check for any reshape request and region size change unless new raid set */
+	/* Check for any reshape request unless new raid set */
 	if (test_and_clear_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
 		/* Initiate a reshape. */
 		mddev_lock_nointr(mddev);
-- 
2.5.5
