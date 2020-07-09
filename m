From: mwilck@suse.com
Subject: [PATCH 07/35] libmultipath: devt2devname(): simplify
	using libudev
Date: Thu,  9 Jul 2020 12:15:52 +0200
Message-ID: <20200709101620.6786-8-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Replace the hand-written code by a simple libudev call. The two
previously skipped tests can now be enabled again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.c | 87 ++++++---------------------------------------
 libmultipath/util.h |  2 +-
 tests/devt.c        |  2 --
 3 files changed, 12 insertions(+), 79 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 28d0168..3c43f28 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -21,6 +21,7 @@
 #include "checkers.h"
 #include "vector.h"
 #include "structs.h"
+#include "config.h"
 #include "log.h"
 
 size_t
@@ -155,89 +156,23 @@ size_t strlcat(char *dst, const char *src, size_t size)
 	return bytes;
 }
 
-int devt2devname(char *devname, int devname_len, char *devt)
+int devt2devname(char *devname, int devname_len, const char *devt)
 {
-	FILE *fd;
-	unsigned int tmpmaj, tmpmin, major, minor;
-	char dev[FILE_NAME_SIZE];
-	char block_path[PATH_SIZE];
-	struct stat statbuf;
-
-	memset(block_path, 0, sizeof(block_path));
-	memset(dev, 0, sizeof(dev));
-	if (sscanf(devt, "%u:%u", &major, &minor) != 2) {
-		condlog(0, "Invalid device number %s", devt);
-		return 1;
-	}
+	struct udev_device *u_dev;
+	int r;
 
-	if (devname_len > FILE_NAME_SIZE)
-		devname_len = FILE_NAME_SIZE;
-
-	if (stat("/sys/dev/block", &statbuf) == 0) {
-		/* Newer kernels have /sys/dev/block */
-		sprintf(block_path,"/sys/dev/block/%u:%u", major, minor);
-		dev[FILE_NAME_SIZE - 1] = '\0';
-		if (lstat(block_path, &statbuf) == 0) {
-			if (S_ISLNK(statbuf.st_mode) &&
-			    readlink(block_path, dev, FILE_NAME_SIZE-1) > 0) {
-				char *p = strrchr(dev, '/');
-
-				if (!p) {
-					condlog(0, "No sysfs entry for %s",
-						block_path);
-					return 1;
-				}
-				p++;
-				strlcpy(devname, p, devname_len);
-				return 0;
-			}
-		}
-		condlog(4, "%s is invalid", block_path);
+	if (!devname || !devname_len || !devt)
 		return 1;
-	}
-	memset(block_path, 0, sizeof(block_path));
 
-	if (!(fd = fopen("/proc/partitions", "r"))) {
-		condlog(0, "Cannot open /proc/partitions");
+	u_dev = udev_device_new_from_devnum(udev, 'b', parse_devt(devt));
+	if (!u_dev) {
+		condlog(0, "\"%s\": invalid major/minor numbers, not found in sysfs", devt);
 		return 1;
 	}
+	r = strlcpy(devname, udev_device_get_sysname(u_dev), devname_len);
+	udev_device_unref(u_dev);
 
-	while (!feof(fd)) {
-		int r = fscanf(fd,"%u %u %*d %s",&tmpmaj, &tmpmin, dev);
-		if (!r) {
-			r = fscanf(fd,"%*s\n");
-			continue;
-		}
-		if (r != 3)
-			continue;
-
-		if ((major == tmpmaj) && (minor == tmpmin)) {
-			if (safe_sprintf(block_path, "/sys/block/%s", dev)) {
-				condlog(0, "device name %s is too long", dev);
-				fclose(fd);
-				return 1;
-			}
-			break;
-		}
-	}
-	fclose(fd);
-
-	if (strncmp(block_path,"/sys/block", 10)) {
-		condlog(3, "No device found for %u:%u", major, minor);
-		return 1;
-	}
-
-	if (stat(block_path, &statbuf) < 0) {
-		condlog(0, "No sysfs entry for %s", block_path);
-		return 1;
-	}
-
-	if (S_ISDIR(statbuf.st_mode) == 0) {
-		condlog(0, "sysfs entry %s is not a directory", block_path);
-		return 1;
-	}
-	basenamecpy((const char *)block_path, devname, devname_len);
-	return 0;
+	return !(r < devname_len);
 }
 
 /* This function returns a pointer inside of the supplied pathname string.
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 56bd78c..df75c4f 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -14,7 +14,7 @@ char *get_next_string(char **temp, char *split_char);
 int get_word (char * sentence, char ** word);
 size_t strlcpy(char *dst, const char *src, size_t size);
 size_t strlcat(char *dst, const char *src, size_t size);
-int devt2devname (char *, int, char *);
+int devt2devname (char *, int, const char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
 void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
diff --git a/tests/devt.c b/tests/devt.c
index 4be6d75..fd4d74a 100644
--- a/tests/devt.c
+++ b/tests/devt.c
@@ -92,7 +92,6 @@ static void test_devt2devname_length_1(void **state)
 {
 	char dummy[] = "";
 
-	skip();
 	assert_int_equal(devt2devname(dummy, sizeof(dummy), *state), 1);
 }
 
@@ -100,7 +99,6 @@ static void test_devt2devname_devt_null(void **state)
 {
 	char dummy[32];
 
-	skip();
 	assert_int_equal(devt2devname(dummy, sizeof(dummy), NULL), 1);
 }
 
-- 
2.26.2
