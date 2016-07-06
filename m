From: heinzm@redhat.com
Subject: [PATCH 01/26] dm raid: avoid superfluous memory barriers
	on static metadata
Date: Wed,  6 Jul 2016 19:24:32 +0200
Message-ID: <1467825897-26058-2-git-send-email-heinzm@redhat.com>
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
 drivers/md/dm-raid.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 248053d..4bf7747 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -366,14 +366,12 @@ static bool rs_is_reshapable(struct raid_set *rs)
 /* Return true, if raid set in @rs is recovering */
 static bool rs_is_recovering(struct raid_set *rs)
 {
-	smp_rmb();
 	return rs->md.recovery_cp != MaxSector;
 }
 
 /* Return true, if raid set in @rs is reshaping */
 static bool rs_is_reshaping(struct raid_set *rs)
 {
-	smp_rmb();
 	return rs->md.reshape_position != MaxSector;
 }
 
@@ -1484,7 +1482,6 @@ static int rs_check_takeover(struct raid_set *rs)
 	struct mddev *mddev = &rs->md;
 	unsigned int near_copies;
 
-	smp_rmb();
 	if (rs->md.degraded) {
 		rs->ti->error = "Can't takeover degraded raid set";
 		return -EPERM;
@@ -1758,8 +1755,6 @@ static int rs_check_reshape(struct raid_set *rs)
 {
 	struct mddev *mddev = &rs->md;
 
-	smp_rmb(); /* Make sure we access recent reshape position */
-
 	if (!mddev->pers || !mddev->pers->check_reshape)
 		rs->ti->error = "Reshape not supported";
 	else if (mddev->degraded)
-- 
2.5.5
