From: NeilBrown <neilb@suse.de>
Subject: [PATCH 11/12] dm-raid456: add suspend/resume method
Date: Thu, 15 Apr 2010 16:43:02 +1000
Message-ID: <20100415064302.15646.44263.stgit@notabene.brown>
References: <20100415062909.15646.16.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415062909.15646.16.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: dm-devel.ids

These just call in to the md methods.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid456.c |   15 +++++++++++++++
 drivers/md/md.c         |    6 ++++--
 drivers/md/md.h         |    3 +++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid456.c b/drivers/md/dm-raid456.c
index 071a8ae..126042d 100644
--- a/drivers/md/dm-raid456.c
+++ b/drivers/md/dm-raid456.c
@@ -465,6 +465,19 @@ static void raid_io_hints(struct dm_target *ti,
 			  (conf->raid_disks - conf->max_degraded));
 }			  
 
+static void raid_presuspend(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+	mddev_suspend(&rs->md);
+}
+
+static void raid_resume(struct dm_target *ti)
+{
+	struct raid_set *rs = ti->private;
+
+	mddev_resume(&rs->md);
+}
+
 static struct target_type raid_target = {
 	.name = "raid45",
 	.version = {1, 0, 0},
@@ -475,6 +488,8 @@ static struct target_type raid_target = {
 	.status = raid_status,
 	.iterate_devices = raid_iterate_devices,
 	.io_hints = raid_io_hints,
+	.presuspend = raid_presuspend,
+	.resume = raid_resume,
 };
 
 static int __init dm_raid_init(void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b292dc5..098f72c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -260,7 +260,7 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
  * Once ->stop is called and completes, the module will be completely
  * unused.
  */
-static void mddev_suspend(mddev_t *mddev)
+void mddev_suspend(mddev_t *mddev)
 {
 	BUG_ON(mddev->suspended);
 	mddev->suspended = 1;
@@ -268,13 +268,15 @@ static void mddev_suspend(mddev_t *mddev)
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
 	mddev->pers->quiesce(mddev, 1);
 }
+EXPORT_SYMBOL_GPL(mddev_suspend);
 
-static void mddev_resume(mddev_t *mddev)
+void mddev_resume(mddev_t *mddev)
 {
 	mddev->suspended = 0;
 	wake_up(&mddev->sb_wait);
 	mddev->pers->quiesce(mddev, 0);
 }
+EXPORT_SYMBOL_GPL(mddev_resume);
 
 int mddev_congested(mddev_t *mddev, int bits)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e4f60ae..fac75bd 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -506,4 +506,7 @@ extern void mddev_init(mddev_t *mddev);
 extern int md_run(mddev_t *mddev);
 extern void md_stop(mddev_t *mddev);
 extern void md_rdev_init(mdk_rdev_t *rdev);
+
+extern void mddev_suspend(mddev_t *mddev);
+extern void mddev_resume(mddev_t *mddev);
 #endif /* _MD_MD_H */


