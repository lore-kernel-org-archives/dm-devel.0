From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH] dm: Get devices using name_to_dev_t
Date: Wed, 14 Jan 2015 16:16:00 -0800
Message-ID: <1421280960-23984-1-git-send-email-dehrenberg@chromium.org>
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
Cc: grundler@chromium.org, drewry@chromium.org, gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-Id: dm-devel.ids

If a device is used as the root filesystem, it can't be built
off of devices which are within the root filesystem (just like
command line arguments to root=). For this reason, Linux has a
pseudo-filesystem for root= and md initialization based on the
function name_to_dev_t, which handles different ways of specifying
devices including PARTUUID and major:minor.

This patch applies name_to_dev_t to dm initialization. Rather
than assuming that all things which are not major:minor are paths
in an already-mounted filesystem, this patch first attempts
name_to_dev_t and tries the filesystem as a fallback.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 drivers/md/dm-table.c | 11 +++--------
 include/linux/mount.h |  2 +-
 init/do_mounts.c      |  2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3afae9e..03f65ed 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
+#include <linux/mount.h>
 
 #define DM_MSG_PREFIX "table"
 
@@ -372,18 +373,12 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 	int r;
 	dev_t uninitialized_var(dev);
 	struct dm_dev_internal *dd;
-	unsigned int major, minor;
 	struct dm_table *t = ti->table;
-	char dummy;
 
 	BUG_ON(!t);
 
-	if (sscanf(path, "%u:%u%c", &major, &minor, &dummy) == 2) {
-		/* Extract the major/minor numbers */
-		dev = MKDEV(major, minor);
-		if (MAJOR(dev) != major || MINOR(dev) != minor)
-			return -EOVERFLOW;
-	} else {
+	dev = name_to_dev_t(path);
+	if (!dev) {
 		/* convert the path to a device */
 		struct block_device *bdev = lookup_bdev(path);
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..bca086d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -92,6 +92,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index eb41008..0584e37 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -207,7 +207,7 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
-- 
2.2.0.rc0.207.ga3a616c
