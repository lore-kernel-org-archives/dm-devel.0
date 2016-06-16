From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/39] libmultipath: use fstat() when reading
	sysfs attributes
Date: Thu, 16 Jun 2016 11:47:21 +0200
Message-ID: <1466070465-1021-16-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Coverity pointed out that we shouldn't be using stat()/open(),
as the file might have vanished or changed in between those
two calls. So modify it to open()/fstat() instead.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/sysfs.c | 59 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index de7df40..a74de9f 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -57,30 +57,31 @@ ssize_t sysfs_attr_get_value(struct udev_device *dev, const char *attr_name,
 	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
 		 attr_name);
 	condlog(4, "open '%s'", devpath);
-	if (stat(devpath, &statbuf) != 0) {
+	/* read attribute value */
+	fd = open(devpath, O_RDONLY);
+	if (fd < 0) {
+		condlog(4, "attribute '%s' can not be opened: %s",
+			devpath, strerror(errno));
+		return -errno;
+	}
+	if (fstat(fd, &statbuf) < 0) {
 		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
+		close(fd);
 		return -ENXIO;
 	}
-
 	/* skip directories */
 	if (S_ISDIR(statbuf.st_mode)) {
 		condlog(4, "%s is a directory", devpath);
+		close(fd);
 		return -EISDIR;
 	}
-
 	/* skip non-writeable files */
 	if ((statbuf.st_mode & S_IRUSR) == 0) {
 		condlog(4, "%s is not readable", devpath);
+		close(fd);
 		return -EPERM;
 	}
 
-	/* read attribute value */
-	fd = open(devpath, O_RDONLY);
-	if (fd < 0) {
-		condlog(4, "attribute '%s' can not be opened: %s",
-			devpath, strerror(errno));
-		return -errno;
-	}
 	size = read(fd, value, value_len);
 	if (size < 0) {
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
@@ -112,30 +113,33 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
 		 attr_name);
 	condlog(4, "open '%s'", devpath);
-	if (stat(devpath, &statbuf) != 0) {
+	/* read attribute value */
+	fd = open(devpath, O_RDONLY);
+	if (fd < 0) {
+		condlog(4, "attribute '%s' can not be opened: %s",
+			devpath, strerror(errno));
+		return -errno;
+	}
+	if (fstat(fd, &statbuf) != 0) {
 		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
+		close(fd);
 		return -ENXIO;
 	}
 
 	/* skip directories */
 	if (S_ISDIR(statbuf.st_mode)) {
 		condlog(4, "%s is a directory", devpath);
+		close(fd);
 		return -EISDIR;
 	}
 
 	/* skip non-writeable files */
 	if ((statbuf.st_mode & S_IRUSR) == 0) {
 		condlog(4, "%s is not readable", devpath);
+		close(fd);
 		return -EPERM;
 	}
 
-	/* read attribute value */
-	fd = open(devpath, O_RDONLY);
-	if (fd < 0) {
-		condlog(4, "attribute '%s' can not be opened: %s",
-			devpath, strerror(errno));
-		return -errno;
-	}
 	size = read(fd, value, value_len);
 	if (size < 0) {
 		condlog(4, "read from %s failed: %s", devpath, strerror(errno));
@@ -163,30 +167,33 @@ ssize_t sysfs_attr_set_value(struct udev_device *dev, const char *attr_name,
 	snprintf(devpath, PATH_SIZE, "%s/%s", udev_device_get_syspath(dev),
 		 attr_name);
 	condlog(4, "open '%s'", devpath);
-	if (stat(devpath, &statbuf) != 0) {
+	/* write attribute value */
+	fd = open(devpath, O_WRONLY);
+	if (fd < 0) {
+		condlog(4, "attribute '%s' can not be opened: %s",
+			devpath, strerror(errno));
+		return -errno;
+	}
+	if (fstat(fd, &statbuf) != 0) {
 		condlog(4, "stat '%s' failed: %s", devpath, strerror(errno));
+		close(fd);
 		return -errno;
 	}
 
 	/* skip directories */
 	if (S_ISDIR(statbuf.st_mode)) {
 		condlog(4, "%s is a directory", devpath);
+		close(fd);
 		return -EISDIR;
 	}
 
 	/* skip non-writeable files */
 	if ((statbuf.st_mode & S_IWUSR) == 0) {
 		condlog(4, "%s is not writeable", devpath);
+		close(fd);
 		return -EPERM;
 	}
 
-	/* write attribute value */
-	fd = open(devpath, O_WRONLY);
-	if (fd < 0) {
-		condlog(4, "attribute '%s' can not be opened: %s",
-			devpath, strerror(errno));
-		return -errno;
-	}
 	size = write(fd, value, value_len);
 	if (size < 0) {
 		condlog(4, "write to %s failed: %s", devpath, strerror(errno));
-- 
2.6.6
