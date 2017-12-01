From: heinzm@redhat.com
Subject: [PATCH 09/10] dm raid: comments
Date: Fri,  1 Dec 2017 01:02:27 +0100
Message-ID: <20171201000228.32677-10-heinzm@redhat.com>
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
Cc: heinzm@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/dm-raid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8e63888fe670..5c08729ccc22 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2837,13 +2837,13 @@ static int rs_setup_reshape(struct raid_set *rs)
 	/*
 	 * Adjust array size:
 	 *
-	 * - in case of adding disks, array size has
+	 * - in case of adding disk(s), array size has
 	 *   to grow after the disk adding reshape,
 	 *   which'll hapen in the event handler;
 	 *   reshape will happen forward, so space has to
 	 *   be available at the beginning of each disk
 	 *
-	 * - in case of removing disks, array size
+	 * - in case of removing disk(s), array size
 	 *   has to shrink before starting the reshape,
 	 *   which'll happen here;
 	 *   reshape will happen backward, so space has to
@@ -2874,7 +2874,7 @@ static int rs_setup_reshape(struct raid_set *rs)
 			rdev->recovery_offset = rs_is_raid1(rs) ? 0 : MaxSector;
 		}
 
-		mddev->reshape_backwards = 0; /* adding disks -> forward reshape */
+		mddev->reshape_backwards = 0; /* adding disk(s) -> forward reshape */
 
 	/* Remove disk(s) */
 	} else if (rs->delta_disks < 0) {
-- 
2.13.6
