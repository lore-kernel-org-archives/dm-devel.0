From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/29] Do not print error when rport is blocked
Date: Mon, 15 Jul 2013 15:00:24 +0200
Message-ID: <1373893230-26077-24-git-send-email-hare@suse.de>
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

When an rport is blocked any write to the dev_loss_tmo
attribute will fail with EBUSY. But that's perfectly
normal and nothing to worry about, so decrease the
logging priority for these cases.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |   52 ++++++++++++++++++++++++++++++----------------
 libmultipath/sysfs.c     |   20 +++++++++---------
 2 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e9c6a50..092930a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -324,6 +324,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	char value[11];
 	char rport_id[32];
 	unsigned long long tmo = 0;
+	int ret;
 
 	sprintf(rport_id, "rport-%d:%d-%d",
 		pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
@@ -353,15 +354,16 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_ZERO &&
 	    mpp->fast_io_fail != MP_FAST_IO_FAIL_OFF) {
 		/* Check if we need to temporarily increase dev_loss_tmo */
-		if (sysfs_attr_get_value(rport_dev, "dev_loss_tmo",
-					 value, 16) <= 0) {
+		ret = sysfs_attr_get_value(rport_dev, "dev_loss_tmo",
+					   value, 16);
+		if (ret <= 0) {
 			condlog(0, "%s: failed to read dev_loss_tmo value, "
-				"error %d", pp->dev, errno);
+				"error %d", rport_id, -ret);
 			goto out;
 		}
 		if (sscanf(value, "%llu\n", &tmo) != 1) {
 			condlog(0, "%s: Cannot parse dev_loss_tmo "
-				"attribute '%s'",pp->dev, value);
+				"attribute '%s'", rport_id, value);
 			goto out;
 		}
 		if (mpp->fast_io_fail >= tmo) {
@@ -369,16 +371,21 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 		}
 	} else if (mpp->dev_loss > 600) {
 		condlog(3, "%s: limiting dev_loss_tmo to 600, since "
-			"fast_io_fail is not set", pp->dev);
+			"fast_io_fail is not set", rport_id);
 		snprintf(value, 11, "%u", 600);
 	} else {
 		snprintf(value, 11, "%u", mpp->dev_loss);
 	}
-	if (strlen(value) &&
-	    sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11) <= 0) {
-		condlog(0, "%s failed to set dev_loss_tmo",
-			mpp->alias);
-		goto out;
+	if (strlen(value)) {
+		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo", value, 11);
+		if (ret <= 0) {
+			if (ret == -EBUSY)
+				condlog(3, "%s: rport blocked", rport_id);
+			else
+				condlog(0, "%s: failed to set dev_loss_tmo to %s, error %d",
+					rport_id, value, -ret);
+			goto out;
+		}
 	}
 	if (mpp->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
 		if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
@@ -387,18 +394,27 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 			sprintf(value, "0");
 		else
 			snprintf(value, 11, "%u", mpp->fast_io_fail);
-		if (sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
-					 value, 11) <= 0) {
-			condlog(0, "%s failed to set fast_io_fail_tmo",
-				mpp->alias);
+		ret = sysfs_attr_set_value(rport_dev, "fast_io_fail_tmo",
+					   value, 11);
+		if (ret <= 0) {
+			if (ret == -EBUSY)
+				condlog(3, "%s: rport blocked", rport_id);
+			else
+				condlog(0, "%s: failed to set fast_io_fail_tmo to %s, error %d",
+					rport_id, value, -ret);
 		}
 	}
 	if (tmo > 0) {
 		snprintf(value, 11, "%u", mpp->dev_loss);
-		if (sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
-					 value, 11) <= 0)
-			condlog(0, "%s failed to set dev_loss_tmo",
-				mpp->alias);
+		ret = sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
+					   value, 11);
+		if (ret <= 0) {
+			if (ret == -EBUSY)
+				condlog(3, "%s: rport blocked", rport_id);
+			else
+				condlog(0, "%s: failed to set dev_loss_tmo to %s, error %d",
+					rport_id, value, -ret);
+		}
 	}
 out:
 	udev_device_unref(rport_dev);
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index bab3837..0670e0a 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -59,19 +59,19 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	condlog(4, "open '%s'", devpath);
 	if (stat(devpath, &statbuf) != 0) {
 		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
-		return 0;
+		return -errno;
 	}
 
 	/* skip directories */
 	if (S_ISDIR(statbuf.st_mode)) {
 		condlog(4, "%s is a directory", devpath);
-		return 0;
+		return -EISDIR;
 	}
 
 	/* skip non-writeable files */
 	if ((statbuf.st_mode & S_IRUSR) == 0) {
 		condlog(4, "%s is not readable", devpath);
-		return 0;
+		return -EPERM;
 	}
 
 	/* read attribute value */
@@ -79,12 +79,12 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	if (fd < 0) {
 		condlog(4, "attribute '%s' can not be opened: %s",
 			devpath, strerror(errno));
-		return 0;
+		return -errno;
 	}
 	size = read(fd, value, value_len);
 	if (size < 0) {
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
-		size = 0;
+		size = -errno;
 	} else if (size == value_len) {
 		condlog(4, "overflow while reading from %s", devpath);
 		size = 0;
@@ -110,19 +110,19 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	condlog(4, "open '%s'", devpath);
 	if (stat(devpath, &statbuf) != 0) {
 		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
-		return 0;
+		return -errno;
 	}
 
 	/* skip directories */
 	if (S_ISDIR(statbuf.st_mode)) {
 		condlog(4, "%s is a directory", devpath);
-		return 0;
+		return -EISDIR;
 	}
 
 	/* skip non-writeable files */
 	if ((statbuf.st_mode & S_IWUSR) == 0) {
 		condlog(4, "%s is not writeable", devpath);
-		return 0;
+		return -EPERM;
 	}
 
 	/* write attribute value */
@@ -130,12 +130,12 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	if (fd < 0) {
 		condlog(4, "attribute '%s' can not be opened: %s",
 			devpath, strerror(errno));
-		return 0;
+		return -errno;
 	}
 	size = write(fd, value, value_len);
 	if (size < 0) {
 		condlog(4, "write to %s failed: %s", devpath, strerror(errno));
-		size = 0;
+		size = -errno;
 	} else if (size < value_len) {
 		condlog(4, "tried to write %ld to %s. Wrote %ld",
 			(long)value_len, devpath, (long)size);
-- 
1.7.10.4
