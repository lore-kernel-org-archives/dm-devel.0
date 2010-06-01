From: NeilBrown <neilb@suse.de>
Subject: [PATCH 06/24] md: export various start/stop interfaces
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.77294.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

export entry points for starting and stopping md arrays.
This will be used by a module to make md/raid5 work under
dm.
Also stop calling md_stop_writes from md_stop, as that won't
work well with dm - it will want to call the two separately.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |   15 +++++++++------
 drivers/md/md.h |    4 ++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d8e8a8c..4eccf4e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -416,7 +416,7 @@ static void mddev_put(mddev_t *mddev)
 	spin_unlock(&all_mddevs_lock);
 }
 
-static void mddev_init(mddev_t *mddev)
+void mddev_init(mddev_t *mddev)
 {
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
@@ -436,6 +436,7 @@ static void mddev_init(mddev_t *mddev)
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
 }
+EXPORT_SYMBOL_GPL(mddev_init);
 
 static mddev_t * mddev_find(dev_t unit)
 {
@@ -4307,7 +4308,7 @@ static void md_safemode_timeout(unsigned long data)
 
 static int start_dirty_degraded;
 
-static int md_run(mddev_t *mddev)
+int md_run(mddev_t *mddev)
 {
 	int err;
 	mdk_rdev_t *rdev;
@@ -4511,6 +4512,7 @@ static int md_run(mddev_t *mddev)
 	sysfs_notify(&mddev->kobj, NULL, "degraded");
 	return 0;
 }
+EXPORT_SYMBOL_GPL(md_run);
 
 static int do_md_run(mddev_t *mddev)
 {
@@ -4620,7 +4622,7 @@ static void md_clean(mddev_t *mddev)
 	mddev->bitmap_info.max_write_behind = 0;
 }
 
-static void md_stop_writes(mddev_t *mddev)
+void md_stop_writes(mddev_t *mddev)
 {
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -4640,11 +4642,10 @@ static void md_stop_writes(mddev_t *mddev)
 		md_update_sb(mddev, 1);
 	}
 }
+EXPORT_SYMBOL_GPL(md_stop_writes);
 
-static void md_stop(mddev_t *mddev)
+void md_stop(mddev_t *mddev)
 {
-	md_stop_writes(mddev);
-
 	mddev->pers->stop(mddev);
 	if (mddev->pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
@@ -4652,6 +4653,7 @@ static void md_stop(mddev_t *mddev)
 	mddev->pers = NULL;
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 }
+EXPORT_SYMBOL_GPL(md_stop);
 
 static int md_set_readonly(mddev_t *mddev, int is_open)
 {
@@ -4698,6 +4700,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		if (mddev->ro)
 			set_disk_ro(disk, 0);
 
+		md_stop_writes(mddev);
 		md_stop(mddev);
 		mddev->queue->merge_bvec_fn = NULL;
 		mddev->queue->unplug_fn = NULL;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a9cde80..8e19e86 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -484,5 +484,9 @@ extern void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 extern void restore_bitmap_write_access(struct file *file);
 
+extern void mddev_init(mddev_t *mddev);
+extern int md_run(mddev_t *mddev);
+extern void md_stop(mddev_t *mddev);
+extern void md_stop_writes(mddev_t *mddev);
 extern void md_rdev_init(mdk_rdev_t *rdev);
 #endif /* _MD_MD_H */


