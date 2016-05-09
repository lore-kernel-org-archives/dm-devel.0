From: heinzm@redhat.com
Subject: [PATCH] md: raid10: add prerequisite to run underneath
	dm-raid
Date: Mon,  9 May 2016 17:50:45 +0200
Message-ID: <1462809045-3097-1-git-send-email-heinzm@redhat.com>
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

In case md runs underneath the dm-raid target, the mddev does not have
a request queue or gendisk, thus avoid accesses to it.

This patch adds two missing conditionals to the raid10 personality.


Signed-of-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/raid10.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e3fd725..84e24e6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3782,8 +3782,10 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 			return ret;
 	}
 	md_set_array_sectors(mddev, size);
-	set_capacity(mddev->gendisk, mddev->array_sectors);
-	revalidate_disk(mddev->gendisk);
+	if (mddev->queue) {
+		set_capacity(mddev->gendisk, mddev->array_sectors);
+		revalidate_disk(mddev->gendisk);
+	}
 	if (sectors > mddev->dev_sectors &&
 	    mddev->recovery_cp > oldsize) {
 		mddev->recovery_cp = oldsize;
@@ -4593,8 +4595,10 @@ static void raid10_finish_reshape(struct mddev *mddev)
 			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		}
 		mddev->resync_max_sectors = size;
-		set_capacity(mddev->gendisk, mddev->array_sectors);
-		revalidate_disk(mddev->gendisk);
+		if (mddev->queue) {
+			set_capacity(mddev->gendisk, mddev->array_sectors);
+			revalidate_disk(mddev->gendisk);
+		}
 	} else {
 		int d;
 		for (d = conf->geo.raid_disks ;
-- 
2.5.5
