From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] libmultipath: Implement
	sysfs_attr_get_value()
Date: Thu, 14 Mar 2013 15:08:46 +0100
Message-ID: <1363270128-20900-5-git-send-email-hare@suse.de>
References: <1363270128-20900-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1363270128-20900-1-git-send-email-hare@suse.de>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When we've modified an sysfs attribute via sysfs_attr_set_value()
we cannot use libudev-provided functions to read the current
value from that attribute, as libudev will return the stale
cached value here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/sysfs.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/sysfs.h |    2 ++
 2 files changed, 58 insertions(+)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index da228e4..22b73b1 100644
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
