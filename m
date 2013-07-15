From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/29] multipath: Increase dev_loss_tmo prior to
	fast_io_fail
Date: Mon, 15 Jul 2013 15:00:05 +0200
Message-ID: <1373893230-26077-5-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

There are several constraints when setting fast_io_fail and
dev_loss_tmo.
dev_loss_tmo will be capped automatically when fast_io_fail is
not set. And fast_io_fail can not be raised beyond dev_loss_tmo.

So to increase dev_loss_tmo and fast_io_fail we first need
to increase dev_loss_tmo to the given fast_io_fail
setting, then set fast_io_fail, and then set dev_loss_tmo
to the final setting.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   66 +++++++++++++++++++++++++++++++++++-----------
 libmultipath/sysfs.c     |   64 ++++++++++++++++++++++++++++++++++++++++++--
 libmultipath/sysfs.h     |    2 ++
 3 files changed, 115 insertions(+), 17 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 26983ca..18f72ec 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -317,6 +317,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	struct udev_device *rport_dev = NULL;
 	char value[11];
 	char rport_id[32];
+	unsigned long long tmo;
 
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
@@ -330,23 +331,51 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	condlog(4, "target%d:%d:%d -> %s", pp->sg_id.host_no,
 		pp->sg_id.channel, pp->sg_id.scsi_id, rport_id);
 
-	snprintf(value, 11, "%u", mpp->dev_loss);
-	if (mpp->dev_loss &&
-	    sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11) <= 0) {
-		if ((mpp->fast_io_fail == MP_FAST_IO_FAIL_UNSET ||
-		     mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
-		    && mpp->dev_loss > 600) {
-			condlog(3, "%s: limiting dev_loss_tmo to 600, since "
-				"fast_io_fail is not set", mpp->alias);
-			snprintf(value, 11, "%u", 600);
-			if (sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
-						 value, 11) <= 0)
-				condlog(0, "%s failed to set dev_loss_tmo",
-					mpp->alias);
+	/*
+	 * This is tricky.
+	 * dev_loss_tmo will be limited to 600 if fast_io_fail
+	 * is _not_ set.
+	 * fast_io_fail will be limited by the current dev_loss_tmo
+	 * setting.
+	 * So to get everything right we first need to increase
+	 * dev_loss_tmo to the fast_io_fail setting (if present),
+	 * then set fast_io_fail, and _then_ set dev_loss_tmo
+	 * to the correct value.
+	 */
+	value[0] = '\0';
+	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET &&
+	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
+		/* Check if we need to temporarily increase dev_loss_tmo */
+		if (sysfs_attr_get_value(rport_dev, "dev_loss_tmo",
+					 value, 16) <= 0) {
+			condlog(0, "%s: failed to read dev_loss_tmo value, "
+				"error %d", pp->dev, errno);
+			goto out;
+		}
+		if (sscanf(value, "%llu\n", &tmo) != 1) {
+			condlog(0, "%s: Cannot parse dev_loss_tmo "
+				"attribute '%s'",pp->dev, value);
 			goto out;
 		}
+		if (mpp->fast_io_fail >= tmo) {
+			snprintf(value, 11, "%u", mpp->fast_io_fail);
+		} else {
+			tmo = 0;
+		}
+	} else if (mpp->dev_loss > 600) {
+		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
+			"fast_io_fail is not set", pp->dev);
+		snprintf(value, 11, "%u", 600);
+	} else {
+		snprintf(value, 11, "%u", mpp->dev_loss);
 	}
-	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET){
+	if (strlen(value) &&
+	    sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11) <= 0) {
+		condlog(0, "%s failed to set dev_loss_tmo",
+			mpp->alias);
+		goto out;
+	}
+	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			sprintf(value, "off");
 		else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
@@ -359,6 +388,13 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 				mpp->alias);
 		}
 	}
+	if (tmo > 0) {
+		snprintf(value, 11, "%u", mpp->dev_loss);
+		if (sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
+					 value, 11) <= 0)
+			condlog(0, "%s failed to set dev_loss_tmo",
+				mpp->alias);
+	}
 out:
 	udev_device_unref(rport_dev);
 }
@@ -394,7 +430,7 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 		} else {
 			snprintf(value, 11, "%u", mpp->fast_io_fail);
 			if (sysfs_attr_set_value(session_dev, "recovery_tmo",
-						 value, 11)) {
+						 value, 11) <= 0) {
 				condlog(3, "%s: Failed to set recovery_tmo, "
 					" error %d", pp->dev, errno);
 			}
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index d33747f..22b73b1 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -38,6 +38,62 @@
 #include "debug.h"
 #include "devmapper.h"
 
+/*
+ * When we modify an attribute value we cannot rely on libudev for now,
+ * as libudev lacks the capability to update an attribute value.
+ * So for modified attributes we need to implement our own function.
+ */
+ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
+			     char * value, size_t value_len)
+{
+	char devpath[PATH_SIZE];
+	struct stat statbuf;
+	int fd;
+	ssize_t size = -1;
+
+	if (!dev || !attr_name || !value)
+		return 0;
+
+	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
+		 attr_name);
+	condlog(4, "open '%s'", devpath);
+	if (stat(devpath, &statbuf) != 0) {
+		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
+		return 0;
+	}
+
+	/* skip directories */
+	if (S_ISDIR(statbuf.st_mode)) {
+		condlog(4, "%s is a directory", devpath);
+		return 0;
+	}
+
+	/* skip non-writeable files */
+	if ((statbuf.st_mode & S_IRUSR) == 0) {
+		condlog(4, "%s is not readable", devpath);
+		return 0;
+	}
+
+	/* read attribute value */
+	fd = open(devpath, O_RDONLY);
+	if (fd < 0) {
+		condlog(4, "attribute '%s' can not be opened: %s",
+			devpath, strerror(errno));
+		return 0;
+	}
+	size = read(fd, value, value_len);
+	if (size < 0) {
+		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
+		size = 0;
+	} else if (size == value_len) {
+		condlog(4, "overflow while reading from %s", devpath);
+		size = 0;
+	}
+
+	close(fd);
+	return size;
+}
+
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len)
 {
@@ -58,12 +114,16 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	}
 
 	/* skip directories */
-	if (S_ISDIR(statbuf.st_mode))
+	if (S_ISDIR(statbuf.st_mode)) {
+		condlog(4, "%s is a directory", devpath);
 		return 0;
+	}
 
 	/* skip non-writeable files */
-	if ((statbuf.st_mode & S_IWUSR) == 0)
+	if ((statbuf.st_mode & S_IWUSR) == 0) {
+		condlog(4, "%s is not writeable", devpath);
 		return 0;
+	}
 
 	/* write attribute value */
 	fd = open(devpath, O_WRONLY);
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 13d7545..34f3e00 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -7,6 +7,8 @@
 
 ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 			     char * value, size_t value_len);
+ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
+			     char * value, size_t value_len);
 int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 #endif
-- 
1.7.10.4
