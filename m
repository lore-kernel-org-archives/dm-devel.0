From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH] dm raid: fix degraded sync_ratio
Date: Tue, 27 Feb 2018 21:58:59 +0100
Message-ID: <ce8aa347b9ce44c5b854472e286a130cb8b849f2.1519764140.git.heinzm@redhat.com>
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

Upstream commits 4102d9de6d375fc27ec70382c4068f4f9f62ce4f 
in combination with 7c29744eccecc2c74c9b4d1ea0a60b4d95229399
introduced a regression reporting wrong zero sync_ratio for
degraded raid sets through the targets status interface thus
causing lvm2 to fail to repair raid legs automatically.

Fix by identifying the degraded state checking the MD_RECOVERY_INTR
flag and returning mddev->recovery_cp in case it is set.

Fix passes automatic repair tests.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 7ef469e902c6..c1d1034ff7b7 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3408,9 +3408,10 @@ static sector_t rs_get_progress(struct raid_set *rs, unsigned long recovery,
 		set_bit(RT_FLAG_RS_IN_SYNC, &rs->runtime_flags);
 
 	} else {
-		if (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
-		    test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
-		    test_bit(MD_RECOVERY_RUNNING, &recovery))
+		if (!test_bit(MD_RECOVERY_INTR, &recovery) &&
+		    (test_bit(MD_RECOVERY_NEEDED, &recovery) ||
+		     test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
+		     test_bit(MD_RECOVERY_RUNNING, &recovery)))
 			r = mddev->curr_resync_completed;
 		else
 			r = mddev->recovery_cp;
-- 
2.14.3
