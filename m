From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH v2 01/18] block_dev: Support checking inode
	permissions in lookup_bdev()
Date: Mon,  7 Dec 2015 15:21:10 -0600
Message-ID: <1449523289-144238-2-git-send-email-seth.forshee@canonical.com>
References: <1449523289-144238-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1449523289-144238-1-git-send-email-seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Neil Brown <neilb-IBi9RG/b67k@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

When looking up a block device by path no permission check is
done to verify that the user has access to the block device inode
at the specified path. In some cases it may be necessary to
check permissions towards the inode, such as allowing
unprivileged users to mount block devices in user namespaces.

Add an argument to lookup_bdev() to optionally perform this
permission check. A value of 0 skips the permission check and
behaves the same as before. A non-zero value specifies the mask
of access rights required towards the inode at the specified
path. The check is always skipped if the user has CAP_SYS_ADMIN.

All callers of lookup_bdev() currently pass a mask of 0, so this
patch results in no functional change. Subsequent patches will
add permission checks where appropriate.

Signed-off-by: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/md/bcache/super.c |  2 +-
 drivers/md/dm-table.c     |  2 +-
 drivers/mtd/mtdsuper.c    |  2 +-
 fs/block_dev.c            | 13 ++++++++++---
 fs/quota/quota.c          |  2 +-
 include/linux/fs.h        |  2 +-
 6 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 679a093a3bf6..e8287b0d1dac 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1926,7 +1926,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 				  sb);
 	if (IS_ERR(bdev)) {
 		if (bdev == ERR_PTR(-EBUSY)) {
-			bdev = lookup_bdev(strim(path));
+			bdev = lookup_bdev(strim(path), 0);
 			mutex_lock(&bch_register_lock);
 			if (!IS_ERR(bdev) && bch_is_open(bdev))
 				err = "device already registered";
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 061152a43730..81c60b2495ed 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -380,7 +380,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 	BUG_ON(!t);
 
 	/* convert the path to a device */
-	bdev = lookup_bdev(path);
+	bdev = lookup_bdev(path, 0);
 	if (IS_ERR(bdev)) {
 		dev = name_to_dev_t(path);
 		if (!dev)
diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index 20c02a3b7417..b5b60e1af31c 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -176,7 +176,7 @@ struct dentry *mount_mtd(struct file_system_type *fs_type, int flags,
 	/* try the old way - the hack where we allowed users to mount
 	 * /dev/mtdblock$(n) but didn't actually _use_ the blockdev
 	 */
-	bdev = lookup_bdev(dev_name);
+	bdev = lookup_bdev(dev_name, 0);
 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
 		pr_debug("MTDSB: lookup_bdev() returned %d\n", ret);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index f90d91efa1b4..3ebbde85d898 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1426,7 +1426,7 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
 	struct block_device *bdev;
 	int err;
 
-	bdev = lookup_bdev(path);
+	bdev = lookup_bdev(path, 0);
 	if (IS_ERR(bdev))
 		return bdev;
 
@@ -1736,12 +1736,14 @@ EXPORT_SYMBOL(ioctl_by_bdev);
 /**
  * lookup_bdev  - lookup a struct block_device by name
  * @pathname:	special file representing the block device
+ * @mask:	rights to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
  *
  * Get a reference to the blockdevice at @pathname in the current
  * namespace if possible and return it.  Return ERR_PTR(error)
- * otherwise.
+ * otherwise.  If @mask is non-zero, check for access rights to the
+ * inode at @pathname.
  */
-struct block_device *lookup_bdev(const char *pathname)
+struct block_device *lookup_bdev(const char *pathname, int mask)
 {
 	struct block_device *bdev;
 	struct inode *inode;
@@ -1756,6 +1758,11 @@ struct block_device *lookup_bdev(const char *pathname)
 		return ERR_PTR(error);
 
 	inode = d_backing_inode(path.dentry);
+	if (mask != 0 && !capable(CAP_SYS_ADMIN)) {
+		error = __inode_permission(inode, mask);
+		if (error)
+			goto fail;
+	}
 	error = -ENOTBLK;
 	if (!S_ISBLK(inode->i_mode))
 		goto fail;
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 3746367098fd..a40eaecbd5cc 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -733,7 +733,7 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	bdev = lookup_bdev(tmp->name);
+	bdev = lookup_bdev(tmp->name, 0);
 	putname(tmp);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8a17c5649ef2..879ec382fd88 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2373,7 +2373,7 @@ static inline void unregister_chrdev(unsigned int major, const char *name)
 #define BLKDEV_MAJOR_HASH_SIZE	255
 extern const char *__bdevname(dev_t, char *buffer);
 extern const char *bdevname(struct block_device *bdev, char *buffer);
-extern struct block_device *lookup_bdev(const char *);
+extern struct block_device *lookup_bdev(const char *, int mask);
 extern void blkdev_show(struct seq_file *,off_t);
 
 #else
-- 
1.9.1


------------------------------------------------------------------------------
Go from Idea to Many App Stores Faster with Intel(R) XDK
Give your users amazing mobile app experiences with Intel(R) XDK.
Use one codebase in this all-in-one HTML5 development environment.
Design, debug & build mobile apps & 2D/3D high-impact games for multiple OSs.
http://pubads.g.doubleclick.net/gampad/clk?id=254741911&iu=/4140
