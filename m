From: heinzm@redhat.com
Subject: [PATCH 1/3] md core: add 2 API functions for takeover
	and resize to support dm-raid
Date: Fri, 13 Feb 2015 19:48:06 +0100
Message-ID: <1423853288-6278-2-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

These 2 added external functions allow the device mapper raid target (dm-raid)
to access the md raid takeover and resize funtionality;
reshape API extensions are not needed in lieu of the existing md personality ones.

The patch makes a reference to mddev->queue conditional as well, because
md instances underneath dm-raid don't manage a request queue of their own.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/md.c | 39 ++++++++++++++++++++++++++++++---------
 drivers/md/md.h |  3 +++
 2 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c8d2bac..fb9907c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3440,7 +3440,8 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
-	blk_set_stacking_limits(&mddev->queue->limits);
+	if (mddev->queue)
+		blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);
@@ -3454,6 +3455,15 @@ out_unlock:
 	return rv;
 }
 
+/* API to expose level_store() to dm-raid target */
+int md_takeover(struct mddev *mddev, const char *buf)
+{
+	ssize_t r = level_store(mddev, buf, strlen(buf));
+
+	return r < 0 ? (int) r : 0;
+}
+EXPORT_SYMBOL_GPL(md_takeover);
+
 static struct md_sysfs_entry md_level =
 __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
 
@@ -3987,18 +3997,15 @@ size_show(struct mddev *mddev, char *page)
 
 static int update_size(struct mddev *mddev, sector_t num_sectors);
 
-static ssize_t
-size_store(struct mddev *mddev, const char *buf, size_t len)
+/* API to expose size_store() to dm-raid target */
+int md_resize(struct mddev *mddev, sector_t sectors)
 {
+	int err;
+
 	/* If array is inactive, we can reduce the component size, but
 	 * not increase it (except from 0).
 	 * If array is active, we can try an on-line resize
 	 */
-	sector_t sectors;
-	int err = strict_blocks_to_sectors(buf, &sectors);
-
-	if (err < 0)
-		return err;
 	err = mddev_lock(mddev);
 	if (err)
 		return err;
@@ -4013,7 +4020,21 @@ size_store(struct mddev *mddev, const char *buf, size_t len)
 			err = -ENOSPC;
 	}
 	mddev_unlock(mddev);
-	return err ? err : len;
+	return err;
+}
+EXPORT_SYMBOL_GPL(md_resize);
+
+/* Compatibility wrapper around md_resize() to keep md internal inbterface */
+static ssize_t
+size_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	sector_t dev_sectors;
+	int err = strict_blocks_to_sectors(buf, &dev_sectors);
+
+	if (!err)
+		err = md_resize(mddev, dev_sectors);
+
+	return err ? (ssize_t) err : len;
 }
 
 static struct md_sysfs_entry md_size =
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 318ca8f..892a28a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -646,6 +646,9 @@ extern void md_stop_writes(struct mddev *mddev);
 extern int md_rdev_init(struct md_rdev *rdev);
 extern void md_rdev_clear(struct md_rdev *rdev);
 
+extern int md_resize(struct mddev *mddev, sector_t dev_sectors);
+extern int md_takeover(struct mddev *mddev, const char *buf);
+
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
 extern struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
-- 
2.1.0
