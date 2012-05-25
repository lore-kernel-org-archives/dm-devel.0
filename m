From: Ondrej Kozina <okozina@redhat.com>
Subject: [RFC PATCH v2 1/3] Adds support for user-submitted ioctl
	commands
Date: Fri, 25 May 2012 15:22:26 +0200
Message-ID: <1337952148-20888-2-git-send-email-okozina@redhat.com>
References: <1335986033-15236-1-git-send-email-okozina@redhat.com>
	<1337952148-20888-1-git-send-email-okozina@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1337952148-20888-1-git-send-email-okozina@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mgrac@redhat.com, kas@fi.muni.cz, mbroz@redhat.com
List-Id: dm-devel.ids

The core of changes in DM ioctl operations

Changes in version No. 2:
^^^^^^^^^^^^^^^^^^^^^^^^

(*) With security enabled, open file descriptor for backing device has to be 
    passed in target parameters (e.g. "fd:9" instead of "8:2")

(*) Load time parameter for dm-mod "enable_security"

(*) Removed owner_gid from sysfs attributes

---
 drivers/md/Makefile           |    2 +-
 drivers/md/dm-ioctl.c         |  141 +++++++++++++++++++++++++++++++++++------
 drivers/md/dm-security.c      |   95 +++++++++++++++++++++++++++
 drivers/md/dm-sysfs.c         |   15 +++++
 drivers/md/dm-table.c         |   23 +++++++-
 drivers/md/dm.c               |   87 +++++++++++++++++++++++++
 drivers/md/dm.h               |   12 ++++
 include/linux/device-mapper.h |    5 ++
 8 files changed, 358 insertions(+), 22 deletions(-)
 create mode 100644 drivers/md/dm-security.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 8b2e0df..28d0808 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -3,7 +3,7 @@
 #
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o
+		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-security.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a1a3e6d..e94a883 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -351,6 +351,7 @@ static char *__change_cell_name(struct hash_cell *hc, char *new_name)
 static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 					    const char *new)
 {
+	int r;
 	char *new_data, *old_name = NULL;
 	struct hash_cell *hc;
 	struct dm_table *table;
@@ -397,6 +398,14 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 		return ERR_PTR(-ENXIO);
 	}
 
+	r = dm_check_dm_dev_permission(hc->md, 1, NULL);
+	if (r) {
+		dm_put(hc->md);
+		up_write(&_hash_lock);
+		kfree(new_data);
+		return ERR_PTR(-EACCES);
+	}
+
 	/*
 	 * Does this device already have a uuid?
 	 */
@@ -434,6 +443,44 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 	return md;
 }
 
+/*
+ * non-root submited ioctl helper function
+ */
+static int initial_permission_check(unsigned int cmd)
+{
+	if (capable(CAP_SYS_ADMIN))
+		return 0;
+
+	if (!sec_enabled)
+		return 1;
+
+	/* FIXME: This is only an example */
+	switch(_IOC_NR(cmd)) {
+	case DM_REMOVE_ALL_CMD:
+	case DM_DEV_SET_GEOMETRY_CMD:
+		DMDEBUG("non-root user cant't call this ioctl: 0x%x", cmd);
+		return 1;
+	}
+	return 0;
+}
+
+static int deny_create(void)
+{
+	if (capable(CAP_SYS_ADMIN))
+		return 0;
+
+	/*
+	 * FIXME: Add some function to limit user to create
+	 * only reasonable number of DM_DEVS
+	 *
+	 * sugestions:
+	 * a) only limited number of devices per second
+	 * b) limited number in total per specific user
+	 * c) limited number in total per non-root user
+	 */
+	return 0;
+}
+
 /*-----------------------------------------------------------------
  * Implementation of the ioctl commands
  *---------------------------------------------------------------*/
@@ -492,9 +539,12 @@ static int list_devices(struct dm_ioctl *param, size_t param_size)
 	 */
 	for (i = 0; i < NUM_BUCKETS; i++) {
 		list_for_each_entry (hc, _name_buckets + i, name_list) {
-			needed += sizeof(struct dm_name_list);
-			needed += strlen(hc->name) + 1;
-			needed += ALIGN_MASK;
+			BUG_ON(!hc->md);
+			if (!dm_check_dm_dev_permission(hc->md, 0, NULL)) {
+				needed += sizeof(struct dm_name_list);
+				needed += strlen(hc->name) + 1;
+				needed += ALIGN_MASK;
+			}
 		}
 	}
 
@@ -515,16 +565,19 @@ static int list_devices(struct dm_ioctl *param, size_t param_size)
 	 */
 	for (i = 0; i < NUM_BUCKETS; i++) {
 		list_for_each_entry (hc, _name_buckets + i, name_list) {
-			if (old_nl)
-				old_nl->next = (uint32_t) ((void *) nl -
-							   (void *) old_nl);
-			disk = dm_disk(hc->md);
-			nl->dev = huge_encode_dev(disk_devt(disk));
-			nl->next = 0;
-			strcpy(nl->name, hc->name);
-
-			old_nl = nl;
-			nl = align_ptr(((void *) ++nl) + strlen(hc->name) + 1);
+			BUG_ON(!hc->md);
+			if (!dm_check_dm_dev_permission(hc->md, 0, NULL)) {
+				if (old_nl)
+					old_nl->next = (uint32_t) ((void *) nl -
+							(void *) old_nl);
+				disk = dm_disk(hc->md);
+				nl->dev = huge_encode_dev(disk_devt(disk));
+				nl->next = 0;
+				strcpy(nl->name, hc->name);
+
+				old_nl = nl;
+				nl = align_ptr(((void *) ++nl) + strlen(hc->name) + 1);
+			}
 		}
 	}
 
@@ -704,6 +757,9 @@ static int dev_create(struct dm_ioctl *param, size_t param_size)
 	int r, m = DM_ANY_MINOR;
 	struct mapped_device *md;
 
+	if (deny_create())
+		return -EACCES;
+
 	r = check_name(param->name);
 	if (r)
 		return r;
@@ -808,6 +864,12 @@ static int dev_remove(struct dm_ioctl *param, size_t param_size)
 
 	md = hc->md;
 
+	if (dm_check_dm_dev_permission(md, 1, NULL)) {
+		up_write(&_hash_lock);
+		dm_put(md);
+		return -EACCES;
+	}
+
 	/*
 	 * Ensure the device is not open and nothing further can open it.
 	 */
@@ -930,6 +992,11 @@ static int do_suspend(struct dm_ioctl *param)
 	if (!md)
 		return -ENXIO;
 
+	if (dm_check_dm_dev_permission(md, 1, NULL)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	if (param->flags & DM_SKIP_LOCKFS_FLAG)
 		suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
 	if (param->flags & DM_NOFLUSH_FLAG)
@@ -968,6 +1035,11 @@ static int do_resume(struct dm_ioctl *param)
 
 	md = hc->md;
 
+	if (dm_check_dm_dev_permission(md, 1, NULL)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	new_map = hc->new_map;
 	hc->new_map = NULL;
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
@@ -1008,7 +1080,7 @@ static int do_resume(struct dm_ioctl *param)
 
 	if (!r)
 		__dev_status(md, param);
-
+out:
 	dm_put(md);
 	return r;
 }
@@ -1123,6 +1195,11 @@ static int dev_wait(struct dm_ioctl *param, size_t param_size)
 	if (!md)
 		return -ENXIO;
 
+	if (dm_check_dm_dev_permission(md, 1, NULL)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	/*
 	 * Wait for a notification event
 	 */
@@ -1222,6 +1299,11 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 	if (!md)
 		return -ENXIO;
 
+	if (dm_check_dm_dev_permission(md, 1, NULL)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	r = dm_table_create(&t, get_mode(param), param->target_count, md);
 	if (r)
 		goto out;
@@ -1292,6 +1374,7 @@ out:
 
 static int table_clear(struct dm_ioctl *param, size_t param_size)
 {
+	int r = 0;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 
@@ -1304,6 +1387,11 @@ static int table_clear(struct dm_ioctl *param, size_t param_size)
 		return -ENXIO;
 	}
 
+	if (dm_check_dm_dev_permission(hc->md, 1, NULL)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	if (hc->new_map) {
 		dm_table_destroy(hc->new_map);
 		hc->new_map = NULL;
@@ -1313,10 +1401,12 @@ static int table_clear(struct dm_ioctl *param, size_t param_size)
 
 	__dev_status(hc->md, param);
 	md = hc->md;
+
+out:
 	up_write(&_hash_lock);
 	dm_put(md);
 
-	return 0;
+	return r;
 }
 
 /*
@@ -1387,6 +1477,7 @@ static int table_deps(struct dm_ioctl *param, size_t param_size)
  */
 static int table_status(struct dm_ioctl *param, size_t param_size)
 {
+	int r = 0;
 	struct mapped_device *md;
 	struct dm_table *table;
 
@@ -1394,6 +1485,11 @@ static int table_status(struct dm_ioctl *param, size_t param_size)
 	if (!md)
 		return -ENXIO;
 
+	if (dm_check_dm_dev_permission(md, 1, NULL)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	__dev_status(md, param);
 
 	table = dm_get_live_or_inactive_table(md, param);
@@ -1402,9 +1498,10 @@ static int table_status(struct dm_ioctl *param, size_t param_size)
 		dm_table_put(table);
 	}
 
+out:
 	dm_put(md);
 
-	return 0;
+	return r;
 }
 
 /*
@@ -1423,6 +1520,11 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
 	if (!md)
 		return -ENXIO;
 
+	if (dm_check_dm_dev_permission(md, 1, NULL)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	if (tmsg < (struct dm_target_msg *) param->data ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
 		DMWARN("Invalid target message parameters.");
@@ -1616,13 +1718,12 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	ioctl_fn fn = NULL;
 	size_t input_param_size;
 
-	/* only root can play with this */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (_IOC_TYPE(command) != DM_IOCTL)
 		return -ENOTTY;
 
+	if (initial_permission_check(command))
+		return -EACCES;
+
 	cmd = _IOC_NR(command);
 
 	/*
diff --git a/drivers/md/dm-security.c b/drivers/md/dm-security.c
new file mode 100644
index 0000000..5ce80cf
--- /dev/null
+++ b/drivers/md/dm-security.c
@@ -0,0 +1,95 @@
+#include "dm.h"
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mount.h>
+
+static struct file *get_device_file(unsigned int fd)
+{
+	int r;
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return file;
+
+	r = -ENOTBLK;
+	if (!S_ISBLK(file->f_dentry->d_inode->i_mode))
+		goto err;
+
+	r = -EACCES;
+	if (file->f_vfsmnt->mnt_flags & MNT_NODEV)
+		goto err;
+
+	return file;
+err:
+	fput(file);
+	return ERR_PTR(r);
+}
+
+
+static struct inode *get_bdev_inode(const char *fd_string)
+{
+	char dummy;
+	struct file *dev_file;
+	struct inode *inode;
+	unsigned int fd;
+
+	if (sscanf(fd_string, "fd:%u%c", &fd, &dummy) != 1)
+		return ERR_PTR(-EINVAL);
+
+	dev_file = get_device_file(fd);
+	if (!dev_file)
+		return ERR_PTR(-EINVAL);
+	if (IS_ERR(dev_file))
+		return (void *)dev_file;
+
+	/*
+	 * fd is open by process under it's context
+	 * we're in kernel space
+	 */
+	ihold(dev_file->f_dentry->d_inode);
+
+	inode = dev_file->f_dentry->d_inode;
+	fput(dev_file);
+	return inode;
+}
+
+int dm_check_backing_dev_permission(struct dm_target *ti, const char *fd_string)
+{
+	int perm = 0, r;
+	struct inode *inode;
+
+	inode = get_bdev_inode(fd_string);
+	if (!inode)
+		return -EINVAL;
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	if (dm_table_get_mode(ti->table) & FMODE_READ)
+		perm |= MAY_READ;
+	if (dm_table_get_mode(ti->table) & FMODE_WRITE)
+		perm |= MAY_WRITE;
+
+	r = inode_permission(inode, perm);
+
+	iput(inode);
+
+	return r;
+}
+
+/* fget_light would be better */
+int dm_get_device_from_fd(unsigned int fd, dev_t *devid)
+{
+	struct file *file;
+
+	file = get_device_file(fd);
+	if (!file)
+		return -EINVAL;
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	*devid = file->f_dentry->d_inode->i_rdev;
+
+	fput(file);
+	return 0;
+}
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index 84d2b91..0efdb21 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -64,14 +64,29 @@ static ssize_t dm_attr_suspended_show(struct mapped_device *md, char *buf)
 	return strlen(buf);
 }
 
+static ssize_t dm_attr_owner_uid_show(struct mapped_device *md, char *buf)
+{
+	struct block_device *bdev = bdget_disk(dm_disk(md), 0);
+
+	if (bdev) {
+		sprintf(buf, "%d\n", bdev->bd_inode->i_uid);
+		bdput(bdev);
+		return strlen(buf);
+	}
+
+	return -EIO;
+}
+
 static DM_ATTR_RO(name);
 static DM_ATTR_RO(uuid);
 static DM_ATTR_RO(suspended);
+static DM_ATTR_RO(owner_uid);
 
 static struct attribute *dm_attrs[] = {
 	&dm_attr_name.attr,
 	&dm_attr_uuid.attr,
 	&dm_attr_suspended.attr,
+	&dm_attr_owner_uid.attr,
 	NULL,
 };
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2e227fb..f29cb19 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -461,7 +461,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 	int r;
 	dev_t uninitialized_var(dev);
 	struct dm_dev_internal *dd;
-	unsigned int major, minor;
+	unsigned int fd, major, minor;
 	struct dm_table *t = ti->table;
 	char dummy;
 
@@ -472,6 +472,10 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		dev = MKDEV(major, minor);
 		if (MAJOR(dev) != major || MINOR(dev) != minor)
 			return -EOVERFLOW;
+	} else if (sscanf(path, "fd:%u%c", &fd, &dummy) == 1) {
+		r = dm_get_device_from_fd(fd, &dev);
+		if (r)
+			return r;
 	} else {
 		/* convert the path to a device */
 		struct block_device *bdev = lookup_bdev(path);
@@ -816,6 +820,21 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		goto bad;
 	}
 
+	DMDEBUG("taget-type: %s, security-check %s defined", tgt->type->name, tgt->type->security ? "" : "not");
+
+	if (sec_enabled) {
+		if (tgt->type->security) {
+			r = tgt->type->security(tgt, argc, argv);
+			if (r)
+				goto sec_bad;
+		} else {
+			tgt->error = "target does not support security checks!";
+			/* NOTE: think about suitable error number */
+			r = -ENOTTY;
+			goto sec_bad;
+		}
+	}
+
 	r = tgt->type->ctr(tgt, argc, argv);
 	kfree(argv);
 	if (r)
@@ -829,6 +848,8 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 
 	return 0;
 
+ sec_bad:
+	kfree(argv);
  bad:
 	DMERR("%s: %s: %s", dm_device_name(t->md), type, tgt->error);
 	dm_put_target_type(tgt->type);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e24143c..a333ea7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -46,6 +46,8 @@ static const char *_name = DM_NAME;
 static unsigned int major = 0;
 static unsigned int _major = 0;
 
+unsigned short sec_enabled = 0;
+
 static DEFINE_IDR(_minor_idr);
 
 static DEFINE_SPINLOCK(_minor_lock);
@@ -333,6 +335,76 @@ static void __exit dm_exit(void)
 }
 
 /*
+ * okozina: permissions
+ */
+
+/* FIXME: just simple test */
+/*
+ * Supposed to call during device initialization.
+ * Otherwise inode counter should be incremented.
+ */
+static int set_bdev_owner(struct block_device *bdev)
+{
+	int r = 0;
+	struct inode *inode;
+
+	/*
+	 * ATTR_FORCE is compulsory. otherwise perm dennied for
+	 * user w/o CAP_FOWNER.
+	 *
+	 * Note that user that has no right to create dm device
+	 * needs to be stopped before ioct() syscall on control
+	 * nod.
+	 */
+	struct iattr attr = {
+		.ia_valid = ATTR_UID | ATTR_FORCE,
+		.ia_uid = current_fsuid()
+	};
+
+	inode = bdev->bd_inode;
+
+	mutex_lock(&inode->i_mutex);
+
+	/* for info only */
+	BUG_ON(!inode->i_sb);
+	BUG_ON(!inode->i_sb->s_root);
+
+	r = inode_change_ok(inode, &attr);
+	if (r)
+		goto out;
+
+	setattr_copy(inode, &attr);
+	mark_inode_dirty(inode);
+
+out:
+	mutex_unlock(&inode->i_mutex);
+	return r;
+}
+
+/*
+ * This is only suggestion how to define ownership
+ * of block device in kernel
+ */
+int dm_check_dm_dev_permission(struct mapped_device *md, int warn, void *attr __attribute__((unused)))
+{
+	int r;
+
+	if (!md)
+		return -EINVAL;
+
+	BUG_ON(!md->bdev);
+	BUG_ON(!md->bdev->bd_inode);
+
+	r = !inode_owner_or_capable(md->bdev->bd_inode);
+
+	if (r && warn)
+		DMWARN("uid: %d is not owner (or capable) of the "
+			"device %s", current_uid(), dm_device_name(md));
+
+	return r;
+}
+
+/*
  * Block device functions
  */
 int dm_deleting_md(struct mapped_device *md)
@@ -421,6 +493,11 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
+	if (!capable(CAP_SYS_ADMIN)) {
+		r = -EACCES;
+		goto out;
+	}
+
 	/* We only support devices that have a single target */
 	if (dm_table_get_num_targets(map) != 1)
 		goto out;
@@ -1884,6 +1961,15 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->bdev)
 		goto bad_bdev;
 
+	/* It's just a test. This should be
+	 * in block layer */
+	if (set_bdev_owner(md->bdev)) {
+		DMDEBUG("set device ownership failed");
+		goto bad_bdev;
+	}
+	DMDEBUG("Device %s has got owner uid: %d",
+		md->name, md->bdev->bd_inode->i_uid);
+
 	bio_init(&md->flush_bio);
 	md->flush_bio.bi_bdev = md->bdev;
 	md->flush_bio.bi_rw = WRITE_FLUSH;
@@ -2774,6 +2860,7 @@ module_init(dm_init);
 module_exit(dm_exit);
 
 module_param(major, uint, 0);
+module_param_named(enable_security, sec_enabled, ushort, 0444);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index b7dacd5..82e98bd 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -156,4 +156,16 @@ void dm_kcopyd_exit(void);
 struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
+/*
+ * Check device permission
+ */
+int dm_check_dm_dev_permission(struct mapped_device *md, int warn, void *attr);
+
+/*
+ *  Security related functions
+ */
+
+int dm_get_device_from_fd(unsigned int fd, dev_t *devid);
+int dm_check_backing_dev_permission(struct dm_target *ti, const char *fd_string);
+
 #endif
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 98f34b8..7ddca63 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -12,6 +12,8 @@
 #include <linux/blkdev.h>
 #include <linux/ratelimit.h>
 
+extern unsigned short sec_enabled;
+
 struct dm_dev;
 struct dm_target;
 struct dm_table;
@@ -95,6 +97,8 @@ typedef int (*dm_iterate_devices_fn) (struct dm_target *ti,
 typedef void (*dm_io_hints_fn) (struct dm_target *ti,
 				struct queue_limits *limits);
 
+typedef int (*dm_security_fn) (struct dm_target *ti, unsigned int argc, char **argv);
+
 /*
  * Returns:
  *    0: The target can handle the next I/O immediately.
@@ -151,6 +155,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_security_fn security;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
1.7.8.6
