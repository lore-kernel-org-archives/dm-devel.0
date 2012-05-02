From: okozina@redhat.com
Subject: [RFC PATCH 2/4] Adds support for the dentry lookup from
	path or major:minor couple during target security check
Date: Wed,  2 May 2012 21:13:51 +0200
Message-ID: <1335986033-15236-3-git-send-email-okozina@redhat.com>
References: <1335986033-15236-1-git-send-email-okozina@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335986033-15236-1-git-send-email-okozina@redhat.com>
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
Cc: Ondrej Kozina <okozina@redhat.com>, mgrac@redhat.com, kas@fi.muni.cz
List-Id: dm-devel.ids

From: Ondrej Kozina <okozina@redhat.com>

Translation of the major:minor couple into dentry with inode. AFAIK there's no
proper way to do it because of the fact that you can have posibly many dentries
asociated with one major:minor couple. I lean to propose a patch for the block
layer that would allow to define ownership of block device. Right now I use
inode in block_device structure for that purpose, but it's simple inode w/o
support for extended attributes. Moreover the inode in bdev pseudo-fs is not
accessible from userspace. If we got support for block device ownership, it
would easier to know whether the user is owner or not. I'm aware that this
solution is not very credible. I would most welcome any comments on that
particular problem.

---
 drivers/md/dm-target.c |  126 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 8da366c..fb97233 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -150,5 +150,131 @@ void dm_target_exit(void)
 	dm_unregister_target(&error_target);
 }
 
+static struct block_device* dmt_get_bdev(char *device_param, char **path_string)
+{
+	dev_t dev;
+	struct block_device *bdev;
+	unsigned int major, minor;
+
+	if (sscanf(device_param, "%u:%u", &major, &minor) == 2) {
+		/* Extract the major/minor numbers */
+		dev = MKDEV(major, minor);
+		if (MAJOR(dev) != major || MINOR(dev) != minor)
+			return ERR_PTR(-EOVERFLOW);
+
+		bdev = bdget(dev);
+	} else {
+		bdev = lookup_bdev(device_param);
+		*path_string = device_param;
+	}
+
+	return bdev;
+}
+
+/*
+ * Tries to lookup dentry associated with device id passed in device_param.
+ * In case path is stored in device_param, the lookup is trivial.
+ *
+ * In case major:minor couple is stored in device_param the situation is
+ * much worse. major:minor is unique id for device, but not for a dentry
+ * node linked with block device. Perhaps, we should move security checks against
+ * device into block layer. And there's another problem - bdev inodes for block
+ * devices are not accessible from userspace in any way:(
+ *
+ * @device_param: major:minor couple or path (i.e. /dev/sda)
+ */
+struct dentry* dm_lookup_bdev_dentry(char *device_param)
+{
+	char *path_str = NULL;
+	int r = 0, partno;
+	struct block_device *bdev;
+	struct gendisk *disk = NULL;
+	struct dentry *dentry = NULL;
+	struct inode *inode;
+	struct path path;
+
+	/*
+	 * if _device_param_ contains the path, its reference is stored
+	 * in _path_
+	 */
+	bdev = dmt_get_bdev(device_param, &path_str);
+	if (!bdev)
+		return ERR_PTR(-EINVAL);
+	if (IS_ERR(bdev))
+		return ERR_PTR(PTR_ERR(bdev));
+
+	/*
+	 * This is the ugly part. I presume that the device node for major/minor
+	 * is in /dev/<device_nam>.
+	 */
+	if (!path_str) {
+		BUG_ON(!bdev->bd_dev);
+
+		disk = get_gendisk(bdev->bd_dev, &partno);
+		if (!disk) {
+			r = -EINVAL;
+			goto fail_bdev;
+		}
+
+		BUG_ON(!disk->disk_name);
+
+		path_str = kzalloc(strlen(disk->disk_name) * sizeof(char)
+				   + strlen(DEV_PATH) * sizeof(char),
+				   GFP_KERNEL);
+		if (!path_str) {
+			put_disk(disk);
+			r = -ENOMEM;
+			goto fail_bdev;
+		}
+
+		sprintf(path_str, "%s", DEV_PATH);
+		memcpy(path_str + strlen(DEV_PATH), disk->disk_name,
+					strlen(disk->disk_name));
+		put_disk(disk);
+	}
+	DMDEBUG("lookup_bdev_dentry(): path_str for dentry lookup: %s", path_str);
+
+	r = kern_path(path_str, LOOKUP_FOLLOW, &path);
+	if (r)
+		goto fail_bdev;
+
+	dentry = dget(path.dentry);
+	if (!dentry) {
+		r = -EINVAL;
+		goto fail_path;
+	}
+
+	inode = dentry->d_inode;
+
+	if (!S_ISBLK(inode->i_mode)) {
+		r = -ENOTBLK;
+		goto fail_dentry;
+	}
+
+	/*
+	 * That check is supposed to be elsewhere maybe, but
+	 * it's the esential test!
+	 */
+	if (path.mnt->mnt_flags & MNT_NODEV)
+		r = -EACCES;
+
+fail_dentry:
+	if (r)
+		dput(dentry);
+fail_path:
+	path_put(&path);
+fail_bdev:
+	if (path_str && (device_param != path_str))
+		kfree(path_str);
+
+	bdput(bdev);
+
+	if (r)
+		return ERR_PTR(r);
+	else
+		return dentry;
+}
+
+EXPORT_SYMBOL(dm_lookup_bdev_dentry);
 EXPORT_SYMBOL(dm_register_target);
 EXPORT_SYMBOL(dm_unregister_target);
-- 
1.7.8.5
