From: heinzm@redhat.com
Subject: [PATCH 07/26] dm raid: enhance comments in takeover
	checks
Date: Wed,  6 Jul 2016 19:24:38 +0200
Message-ID: <1467825897-26058-8-git-send-email-heinzm@redhat.com>
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
index d387d24..f6120e1 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1610,7 +1610,7 @@ static int rs_check_takeover(struct raid_set *rs)
 		    mddev->raid_disks == 2)
 			return 0;
 
-		/* raid5 with parity N -> raid6 with parity N */
+		/* raid5_* ->  raid6_*_6 with Q-Syndrome N (e.g. raid5_ra -> raid6_ra_6 */
 		if (mddev->new_level == 6 &&
 		    ((mddev->layout == ALGORITHM_PARITY_N && mddev->new_layout == ALGORITHM_PARITY_N) ||
 		      __within_range(mddev->new_layout, ALGORITHM_LEFT_ASYMMETRIC_6, ALGORITHM_RIGHT_SYMMETRIC_6)))
@@ -1628,7 +1628,7 @@ static int rs_check_takeover(struct raid_set *rs)
 		    mddev->layout == ALGORITHM_PARITY_N)
 			return 0;
 
-		/* raid6_*_n with parity N -> raid5_* */
+		/* raid6_*_n with Q-Syndrome N -> raid5_* */
 		if (mddev->new_level == 5 &&
 		    ((mddev->layout == ALGORITHM_PARITY_N && mddev->new_layout == ALGORITHM_PARITY_N) ||
 		     __within_range(mddev->new_layout, ALGORITHM_LEFT_ASYMMETRIC, ALGORITHM_RIGHT_SYMMETRIC)))
-- 
2.5.5
