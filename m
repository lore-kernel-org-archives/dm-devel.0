From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 1/5] fs: Verify access of user towards block device file when mounting
Date: Wed, 30 Sep 2015 15:15:10 -0500
Message-ID: <1443644116-41366-2-git-send-email-seth.forshee@canonical.com>
References: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443644116-41366-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-Id: dm-devel.ids

When mounting a filesystem on a block device there is currently
no verification that the user has appropriate access to the
device file passed to mount. This has not been an issue so far
since the user in question has always been root, but this must
be changed before allowing unprivileged users to mount in user
namespaces.

To fix this, add an argument to lookup_bdev() to specify the
required permissions. If the mask of permissions is zero, or
if the user has CAP_SYS_ADMIN, the permission check is skipped,
otherwise the lookup fails if the user does not have the
specified access rights for the inode at the supplied path.

Callers associated with mounting are updated to pass permission
masks to lookup_bdev() so that these mounts will fail for an
unprivileged user who lacks permissions for the block device
inode. All other callers pass 0 to maintain their current
behaviors.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/md/bcache/super.c |  2 +-
 drivers/md/dm-table.c     |  2 +-
 drivers/mtd/mtdsuper.c    |  6 +++++-
 fs/block_dev.c            | 18 +++++++++++++++---
 fs/quota/quota.c          |  2 +-
 include/linux/fs.h        |  2 +-
 6 files changed, 24 insertions(+), 8 deletions(-)

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
index e76ed003769e..35bb3ea4cbe2 100644
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
index 20c02a3b7417..5d7e7705fed8 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -125,6 +125,7 @@ struct dentry *mount_mtd(struct file_system_type *fs_type, int flags,
 #ifdef CONFIG_BLOCK
 	struct block_device *bdev;
 	int ret, major;
+	int perm;
 #endif
 	int mtdnr;
 
@@ -176,7 +177,10 @@ struct dentry *mount_mtd(struct file_system_type *fs_type, int flags,
 	/* try the old way - the hack where we allowed users to mount
 	 * /dev/mtdblock$(n) but didn't actually _use_ the blockdev
 	 */
-	bdev = lookup_bdev(dev_name);
+	perm = MAY_READ;
+	if (!(flags & MS_RDONLY))
+		perm |= MAY_WRITE;
+	bdev = lookup_bdev(dev_name, perm);
 	if (IS_ERR(bdev)) {
 		ret = PTR_ERR(bdev);
 		pr_debug("MTDSB: lookup_bdev() returned %d\n", ret);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 26cee058dc02..54d94cd64577 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1394,9 +1394,14 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
 					void *holder)
 {
 	struct block_device *bdev;
+	int perm = 0;
 	int err;
 
-	bdev = lookup_bdev(path);
+	if (mode & FMODE_READ)
+		perm |= MAY_READ;
+	if (mode & FMODE_WRITE)
+		perm |= MAY_WRITE;
+	bdev = lookup_bdev(path, perm);
 	if (IS_ERR(bdev))
 		return bdev;
 
@@ -1706,12 +1711,14 @@ EXPORT_SYMBOL(ioctl_by_bdev);
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
@@ -1726,6 +1733,11 @@ struct block_device *lookup_bdev(const char *pathname)
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
index 458ee7b213be..cc18dfb0b98e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2388,7 +2388,7 @@ static inline void unregister_chrdev(unsigned int major, const char *name)
 #define BLKDEV_MAJOR_HASH_SIZE	255
 extern const char *__bdevname(dev_t, char *buffer);
 extern const char *bdevname(struct block_device *bdev, char *buffer);
-extern struct block_device *lookup_bdev(const char *);
+extern struct block_device *lookup_bdev(const char *, int mask);
 extern void blkdev_show(struct seq_file *,off_t);
 
 #else
-- 
1.9.1
