From: heinzm@redhat.com
Subject: [PATCH] md: raid5: add prerequisite to run underneath
	dm-raid
Date: Mon,  9 May 2016 17:50:44 +0200
Message-ID: <1462809044-3031-1-git-send-email-heinzm@redhat.com>
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
a request queue or gendisk, thus avoid accesses.

This patch adds a missing conditional to the raid5 personality.


Signed-of-by: Heinz Mauelshagen <heinzm@redhat.com>


---
 drivers/md/raid5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8ab8b65..ce79ce6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7574,8 +7574,10 @@ static void raid5_finish_reshape(struct mddev *mddev)
 
 		if (mddev->delta_disks > 0) {
 			md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
-			set_capacity(mddev->gendisk, mddev->array_sectors);
-			revalidate_disk(mddev->gendisk);
+			if (mddev->queue) {
+				set_capacity(mddev->gendisk, mddev->array_sectors);
+				revalidate_disk(mddev->gendisk);
+			}
 		} else {
 			int d;
 			spin_lock_irq(&conf->device_lock);
-- 
2.5.5
