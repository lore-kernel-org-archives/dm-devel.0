From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 17/21] [libmultipath] Remove libsysfs
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.9F400D44CC@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


libsysfs is deprecated and doesn't work with recent kernels.
Copied over stuff from udev and implemented our own sysfs handling.
Much saner now.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Makefile.inc               |    1 -
 libmultipath/Makefile      |    2 +-
 libmultipath/config.h      |    1 +
 libmultipath/configure.c   |    4 +-
 libmultipath/discovery.c   |  422 +++++++++++++++++---------------------------
 libmultipath/discovery.h   |    7 +-
 libmultipath/list.h        |  289 ++++++++++++++++++++++++++++++
 libmultipath/print.c       |   47 +++--
 libmultipath/structs.h     |   15 ++-
 libmultipath/structs_vec.c |    7 +-
 libmultipath/sysfs.c       |  409 ++++++++++++++++++++++++++++++++++++++++++
 libmultipath/sysfs.h       |   20 ++
 libmultipath/util.c        |   52 ++++++
 libmultipath/util.h        |    4 +-
 multipath/Makefile         |    2 +-
 multipath/main.c           |   11 +-
 multipathd/Makefile        |    2 +-
 multipathd/cli_handlers.c  |   17 ++-
 multipathd/main.c          |   92 +++++------
 multipathd/main.h          |    2 +-
 20 files changed, 1059 insertions(+), 347 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 71970ef..7eb3dfb 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -17,7 +17,6 @@ ifeq ($(strip $(BUILD)),klibc)
 	CC = klcc
 	klibcdir = /usr/lib/klibc
 	libdm    = $(klibcdir)/lib/libdevmapper.a
-	libsysfs = $(klibcdir)/lib/libsysfs.a
 endif
 
 prefix      = 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index ef561a8..511f5ad 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -13,7 +13,7 @@ OBJS = memory.o parser.o vector.o devmap
        structs.o discovery.o propsel.o dict.o \
        pgpolicies.o debug.o regex.o defaults.o uevent.o \
        switchgroup.o uxsock.o print.o alias.o log_pthread.o \
-       log.o configure.o structs_vec.o
+       log.o configure.o structs_vec.o sysfs.o
 
 PREVBUILD = $(shell nm debug.o 2> /dev/null|grep log_safe)
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 7caa11d..a25b3ad 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -66,6 +66,7 @@ struct config {
 	int pg_timeout;
 
 	char * dev;
+	char * sysfs_dir;
 	char * udev_dir;
 	char * selector;
 	char * getuid;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a5bad4c..3cd6041 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -325,8 +325,10 @@ domap (struct multipath * mpp)
 			return DOMAP_RETRY;
 		}
 
-		if (dm_map_present(mpp->alias))
+		if (dm_map_present(mpp->alias)) {
+			condlog(3, "%s: map already present", mpp->alias);
 			break;
+		}
 
 		r = dm_addmap(DM_DEVICE_CREATE, mpp->alias, DEFAULT_TARGET,
 			      mpp->params, mpp->size, mpp->wwid);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index a196583..52e0621 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -8,9 +8,8 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
+#include <dirent.h>
 #include <errno.h>
-#include <sysfs/dlist.h>
-#include <sysfs/libsysfs.h>
 
 #include <checkers.h>
 
@@ -24,6 +23,7 @@
 #include "debug.h"
 #include "propsel.h"
 #include "sg_include.h"
+#include "sysfs.h"
 #include "discovery.h"
 
 struct path *
@@ -87,127 +87,117 @@ path_discover (vector pathvec, struct co
 int
 path_discovery (vector pathvec, struct config * conf, int flag)
 {
-	struct dlist * ls;
-	struct sysfs_class * class;
-	struct sysfs_class_device * dev;
-	int r = 1;
-
-	if (!(class = sysfs_open_class("block")))
+	DIR *blkdir;
+	struct dirent *blkdev;
+	struct stat statbuf;
+	char devpath[PATH_MAX];
+	char *devptr;
+	int r = 0;
+
+	if (!(blkdir = opendir("/sys/block")))
 		return 1;
 
-	if (!(ls = sysfs_get_class_devices(class)))
-		goto out;
+	strcpy(devpath,"/sys/block");
+	while ((blkdev = readdir(blkdir)) != NULL) {
+		if ((strcmp(blkdev->d_name,".") == 0) ||
+		    (strcmp(blkdev->d_name,"..") == 0))
+			continue;
 
-	r = 0;
+		devptr = devpath + 10;
+		*devptr = '\0';
+		strcat(devptr,"/");
+		strcat(devptr,blkdev->d_name);
+		if (stat(devpath, &statbuf) < 0)
+			continue;
 
-	dlist_for_each_data(ls, dev, struct sysfs_class_device)
-		r += path_discover(pathvec, conf, dev->name, flag);
+		if (S_ISDIR(statbuf.st_mode) == 0)
+			continue;
 
-out:
-	sysfs_close_class(class);
-	return r;
-}
+		condlog(4, "Discover device %s", devpath);
 
-/*
- * the daemon can race udev upon path add,
- * not multipath(8), ran by udev
- */
-#if DAEMON
-#define WAIT_MAX_SECONDS 60
-#define WAIT_LOOP_PER_SECOND 5
-
-static int
-wait_for_file (char * filename)
-{
-	int loop;
-	struct stat stats;
-	
-	loop = WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
-	
-	while (--loop) {
-		if (stat(filename, &stats) == 0)
-			return 0;
-
-		if (errno != ENOENT)
-			return 1;
-
-		usleep(1000 * 1000 / WAIT_LOOP_PER_SECOND);
+		r += path_discover(pathvec, conf, blkdev->d_name, flag);
 	}
-	return 1;
-}
-#else
-static int
-wait_for_file (char * filename)
-{
-	return 0;
+	closedir(blkdir);
+	condlog(4, "Discovery status %d", r);
+	return r;
 }
-#endif
 
-#define declare_sysfs_get_str(fname, fmt) \
+#define declare_sysfs_get_str(fname) \
 extern int \
-sysfs_get_##fname (char * sysfs_path, char * dev, char * buff, int len) \
+sysfs_get_##fname (struct sysfs_device * dev, char * buff, size_t len) \
 { \
-	struct sysfs_attribute * attr; \
-	char attr_path[SYSFS_PATH_SIZE]; \
+	char *attr; \
 \
-	if (safe_sprintf(attr_path, fmt, sysfs_path, dev)) \
+	attr = sysfs_attr_get_value(dev->devpath, #fname); \
+	if (!attr) \
 		return 1; \
 \
-	if (wait_for_file(attr_path)) \
-		return 1; \
-\
-	if (!(attr = sysfs_open_attribute(attr_path))) \
-		return 1; \
-\
-	if (0 > sysfs_read_attribute(attr)) \
-		goto out; \
-\
-	if (attr->len < 2 || attr->len - 1 > len) \
-		goto out; \
-\
-	strncpy(buff, attr->value, attr->len - 1); \
-	strchop(buff); \
-	sysfs_close_attribute(attr); \
+	if (strlcpy(buff, attr, len) != strlen(attr)) \
+		return 2; \
 	return 0; \
-out: \
-	sysfs_close_attribute(attr); \
-	return 1; \
 }
 
-declare_sysfs_get_str(devtype, "%s/block/%s/device/devtype");
-declare_sysfs_get_str(cutype, "%s/block/%s/device/cutype");
-declare_sysfs_get_str(vendor, "%s/block/%s/device/vendor");
-declare_sysfs_get_str(model, "%s/block/%s/device/model");
-declare_sysfs_get_str(rev, "%s/block/%s/device/rev");
-declare_sysfs_get_str(dev, "%s/block/%s/dev");
+declare_sysfs_get_str(devtype);
+declare_sysfs_get_str(cutype);
+declare_sysfs_get_str(vendor);
+declare_sysfs_get_str(model);
+declare_sysfs_get_str(rev);
 
 int
-sysfs_get_size (char * sysfs_path, char * dev, unsigned long long * size)
+sysfs_get_dev (struct sysfs_device * dev, char * buff, size_t len)
 {
-	struct sysfs_attribute * attr;
-	char attr_path[SYSFS_PATH_SIZE];
-	int r;
+	char *attr;
 
-	if (safe_sprintf(attr_path, "%s/block/%s/size", sysfs_path, dev))
+	attr = sysfs_attr_get_value(dev->devpath, "dev");
+	if (!attr) {
+		condlog(3, "%s: no 'dev' attribute in sysfs", dev->kernel);
 		return 1;
+	}
+	if (strlcpy(buff, attr, len) != strlen(attr)) {
+		condlog(3, "%s: overflow in 'dev' attribute", dev->kernel);
+		return 2;
+	}
+	return 0;
+}
 
-	attr = sysfs_open_attribute(attr_path);
+int
+sysfs_get_size (struct sysfs_device * dev, unsigned long long * size)
+{
+	char *attr;
+	int r;
 
+	attr = sysfs_attr_get_value(dev->devpath, "size");
 	if (!attr)
 		return 1;
 
-	if (0 > sysfs_read_attribute(attr))
-		goto out;
-
-	r = sscanf(attr->value, "%llu\n", size);
-	sysfs_close_attribute(attr);
+	r = sscanf(attr, "%llu\n", size);
 
 	if (r != 1)
 		return 1;
 
 	return 0;
-out:
-	sysfs_close_attribute(attr);
+}
+	
+int
+sysfs_get_fc_nodename (struct sysfs_device * dev, char * node,
+		       unsigned int host, unsigned int channel,
+		       unsigned int target)
+{
+	char attr_path[SYSFS_PATH_SIZE], *attr;
+
+	if (safe_sprintf(attr_path, 
+			 "/class/fc_transport/target%i:%i:%i",
+			 host, channel, target)) {
+		condlog(0, "attr_path too small");
+		return 1;
+	}
+
+	attr = sysfs_attr_get_value(attr_path, "node_name");
+	if (attr) {
+		strlcpy(node, attr, strlen(attr));
+		return 0;
+	}
+
 	return 1;
 }
 	
@@ -224,68 +214,52 @@ opennode (char * dev, int mode)
 		return -1;
 	}
 
-	if (wait_for_file(devpath)) {
-		condlog(3, "failed to open %s", devpath);
-		return -1;
-	}
-
 	return open(devpath, mode);
 }
 
 extern int
 devt2devname (char *devname, char *devt)
 {
-	struct dlist * ls;
-	char attr_path[FILE_NAME_SIZE];
+	FILE *fd;
+	unsigned int tmpmaj, tmpmin, major, minor;
+	char dev[FILE_NAME_SIZE];
 	char block_path[FILE_NAME_SIZE];
-	struct sysfs_attribute * attr = NULL;
-	struct sysfs_class * class;
-	struct sysfs_class_device * dev;
+	struct stat statbuf;
 
-	if(safe_sprintf(block_path, "%s/block", sysfs_path)) {
-		condlog(0, "block_path too small");
+	if (sscanf(devt, "%u:%u", &major, &minor) != 2) {
+		condlog(0, "Invalid device number %s", devt);
 		return 1;
 	}
-	if (!(class = sysfs_open_class("block")))
-		return 1;
 
-	if (!(ls = sysfs_get_class_devices(class)))
-		goto err;
+	if ((fd = fopen("/proc/partitions", "r")) < 0) {
+		condlog(0, "Cannot open /proc/partitions");
+		return 1;
+	}
+	
+	while (!feof(fd)) {
+		if (fscanf(fd," %u %u %*d %s",&tmpmaj, &tmpmin, dev) != 3)
+			continue;
 
-	dlist_for_each_data(ls, dev, struct sysfs_class_device) {
-		if(safe_sprintf(attr_path, "%s/%s/dev",
-				block_path, dev->name)) {
-			condlog(0, "attr_path too small");
-			goto err;
-		}
-		if (!(attr = sysfs_open_attribute(attr_path)))
-			goto err;
-
-		if (sysfs_read_attribute(attr))
-			goto err1;
-
-		/* discard newline */
-		if (attr->len > 1) attr->len--;
-
-		if (strlen(devt) == attr->len &&
-		    strncmp(attr->value, devt, attr->len) == 0) {
-			if(safe_sprintf(attr_path, "%s/%s",
-					block_path, dev->name)) {
-				condlog(0, "attr_path too small");
-				goto err1;
-			}
-			sysfs_get_name_from_path(attr_path, devname,
-						 FILE_NAME_SIZE);
-			sysfs_close_attribute(attr);
-			sysfs_close_class(class);
-			return 0;
+		if ((major == tmpmaj) && (minor == tmpmin)) {
+			sprintf(block_path, "/sys/block/%s", dev);
+			break;
 		}
 	}
-err1:
-	sysfs_close_attribute(attr);
-err:
-	sysfs_close_class(class);
-	return 1;
+	fclose(fd);
+
+	if (strncpy(block_path,"/sys/block", 10))
+		return 1;
+
+	if (stat(block_path, &statbuf) < 0) {
+		condlog(0, "No sysfs entry for %s\n", block_path);
+		return 1;
+	}
+
+	if (S_ISDIR(statbuf.st_mode) == 0) {
+		condlog(0, "sysfs entry %s is not a directory\n", block_path);
+		return 1;
+	}
+	return 0;
 }
 
 static int
@@ -363,79 +337,21 @@ get_serial (char * str, int maxlen, int
 }
 
 static int
-sysfs_get_bus (char * sysfs_path, struct path * pp)
-{
-	struct sysfs_device *sdev;
-	char attr_path[FILE_NAME_SIZE];
-	char attr_buff[FILE_NAME_SIZE];
-
-	pp->bus = SYSFS_BUS_UNDEF;
-
-	/*
-	 * This is ugly : we should be able to do a simple
-	 * get_link("%s/block/%s/device/bus", ...) but it just
-	 * won't work
-	 */
-	if(safe_sprintf(attr_path, "%s/block/%s/device",
-			sysfs_path, pp->dev)) {
-		condlog(0, "attr_path too small");
-		return 1;
-	}
-
-	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
-		return 1;
-
-#if DAEMON
-	int loop = WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
-
-	while (loop--) {
-		sdev = sysfs_open_device_path(attr_buff);
-
-		if (strlen(sdev->bus))
-			break;
-
-		sysfs_close_device(sdev);
-		usleep(1000 * 1000 / WAIT_LOOP_PER_SECOND);
-	}
-#else
-	sdev = sysfs_open_device_path(attr_buff);
-#endif
-
-	if (!strncmp(sdev->bus, "scsi", 4))
-		pp->bus = SYSFS_BUS_SCSI;
-	else if (!strncmp(sdev->bus, "ide", 3))
-		pp->bus = SYSFS_BUS_IDE;
-	else if (!strncmp(sdev->bus, "ccw", 3))
-		pp->bus = SYSFS_BUS_CCW;
-	else
-		return 1;
-
-	sysfs_close_device(sdev);
-
-	return 0;
-}
-
-static int
-scsi_sysfs_pathinfo (struct path * pp)
+scsi_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
 {
 	char attr_path[FILE_NAME_SIZE];
-	char attr_buff[FILE_NAME_SIZE];
-	struct sysfs_attribute * attr;
 
-	if (sysfs_get_vendor(sysfs_path, pp->dev,
-			     pp->vendor_id, SCSI_VENDOR_SIZE))
+	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE))
 		return 1;
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
-	if (sysfs_get_model(sysfs_path, pp->dev,
-			    pp->product_id, SCSI_PRODUCT_SIZE))
+	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE))
 		return 1;
 
 	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 
-	if (sysfs_get_rev(sysfs_path, pp->dev,
-			  pp->rev, SCSI_REV_SIZE))
+	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE))
 		return 1;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
@@ -448,15 +364,7 @@ scsi_sysfs_pathinfo (struct path * pp)
 	/*
 	 * host / bus / target / lun
 	 */
-	if(safe_sprintf(attr_path, "%s/block/%s/device",
-			sysfs_path, pp->dev)) {
-		condlog(0, "attr_path too small");
-		return 1;
-	}
-	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
-		return 1;
-	
-	basename(attr_buff, attr_path);
+	basename(parent->devpath, attr_path);
 
 	sscanf(attr_path, "%i:%i:%i:%i",
 			&pp->sg_id.host_no,
@@ -473,35 +381,19 @@ scsi_sysfs_pathinfo (struct path * pp)
 	/*
 	 * target node name
 	 */
-	if(safe_sprintf(attr_path,
-			"%s/class/fc_transport/target%i:%i:%i/node_name",
-			sysfs_path,
-			pp->sg_id.host_no,
-			pp->sg_id.channel,
-			pp->sg_id.scsi_id)) {
-		condlog(0, "attr_path too small");
-		return 1;
+	if(!sysfs_get_fc_nodename(parent, pp->tgt_node_name,
+				 pp->sg_id.host_no,
+				 pp->sg_id.channel,
+				 pp->sg_id.scsi_id)) {
+		condlog(3, "%s: tgt_node_name = %s",
+			pp->dev, pp->tgt_node_name);
 	}
-	if (!(attr = sysfs_open_attribute(attr_path)))
-		return 0;
-
-	if (sysfs_read_attribute(attr))
-		goto err;
-
-	if (attr->len > 0)
-		strncpy(pp->tgt_node_name, attr->value, attr->len - 1);
-
-	condlog(3, "%s: tgt_node_name = %s",
-		pp->dev, pp->tgt_node_name);
 
 	return 0;
-err:
-	sysfs_close_attribute(attr);
-	return 1;
 }
 
 static int
-ccw_sysfs_pathinfo (struct path * pp)
+ccw_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
 {
 	char attr_path[FILE_NAME_SIZE];
 	char attr_buff[FILE_NAME_SIZE];
@@ -510,8 +402,7 @@ ccw_sysfs_pathinfo (struct path * pp)
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
-	if (sysfs_get_devtype(sysfs_path, pp->dev,
-			      attr_buff, FILE_NAME_SIZE))
+	if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE))
 		return 1;
 
 	if (!strncmp(attr_buff, "3370", 4)) {
@@ -531,16 +422,8 @@ ccw_sysfs_pathinfo (struct path * pp)
 
 	/*
 	 * host / bus / target / lun
-	 */
-	if(safe_sprintf(attr_path, "%s/block/%s/device",
-			sysfs_path, pp->dev)) {
-		condlog(0, "attr_path too small");
-		return 1;
-	}
-	if (0 > sysfs_get_link(attr_path, attr_buff, sizeof(attr_buff)))
-		return 1;
-	
-	basename(attr_buff, attr_path);
+	 */	
+	basename(parent->devpath, attr_path);
 	pp->sg_id.lun = 0;
 	sscanf(attr_path, "%i.%i.%x",
 			&pp->sg_id.host_no,
@@ -557,20 +440,20 @@ ccw_sysfs_pathinfo (struct path * pp)
 }
 
 static int
-common_sysfs_pathinfo (struct path * pp)
+common_sysfs_pathinfo (struct path * pp, struct sysfs_device *dev)
 {
-	if (sysfs_get_bus(sysfs_path, pp))
-		return 1;
-
-	condlog(3, "%s: bus = %i", pp->dev, pp->bus);
+	char *attr;
 
-	if (sysfs_get_dev(sysfs_path, pp->dev,
-			  pp->dev_t, BLK_DEV_SIZE))
+	attr = sysfs_attr_get_value(dev->devpath, "dev");
+	if (!attr) {
+		condlog(3, "%s: no 'dev' attribute in sysfs", pp->dev);
 		return 1;
+	}
+	strlcpy(pp->dev_t, attr, BLK_DEV_SIZE);
 
 	condlog(3, "%s: dev_t = %s", pp->dev, pp->dev_t);
 
-	if (sysfs_get_size(sysfs_path, pp->dev, &pp->size))
+	if (sysfs_get_size(dev, &pp->size))
 		return 1;
 
 	condlog(3, "%s: size = %llu", pp->dev, pp->size);
@@ -578,19 +461,46 @@ common_sysfs_pathinfo (struct path * pp)
 	return 0;
 }
 
+struct sysfs_device *sysfs_device_from_path(struct path *pp)
+{
+	char sysdev[FILE_NAME_SIZE];
+
+	strlcpy(sysdev,"/block/", FILE_NAME_SIZE);
+	strlcat(sysdev,pp->dev, FILE_NAME_SIZE);
+
+	return sysfs_device_get(sysdev);
+}
+
 extern int
 sysfs_pathinfo(struct path * pp)
 {
-	if (common_sysfs_pathinfo(pp))
+	struct sysfs_device *parent;
+
+	pp->sysdev = sysfs_device_from_path(pp);
+	if (!pp->sysdev) {
+		condlog(1, "%s: failed to get sysfs information", pp->dev);
 		return 1;
+	}
+	
+	parent = sysfs_device_get_parent(pp->sysdev);
+
+	if (common_sysfs_pathinfo(pp, pp->sysdev))
+		return 1;
+
+	condlog(3, "%s: subsystem = %s", pp->dev, parent->subsystem);
+
+	if (!strncmp(parent->subsystem, "scsi",4))
+		pp->bus = SYSFS_BUS_SCSI;
+	if (!strncmp(parent->subsystem, "ccw",3))
+		pp->bus = SYSFS_BUS_CCW;
 
 	if (pp->bus == SYSFS_BUS_UNDEF)
 		return 0;
 	else if (pp->bus == SYSFS_BUS_SCSI) {
-		if (scsi_sysfs_pathinfo(pp))
+		if (scsi_sysfs_pathinfo(pp, parent))
 			return 1;
 	} else if (pp->bus == SYSFS_BUS_CCW) {
-		if (ccw_sysfs_pathinfo(pp))
+		if (ccw_sysfs_pathinfo(pp, parent))
 			return 1;
 	}
 	return 0;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index ab62a59..c7cf7e8 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -24,12 +24,7 @@
 #define SCSI_COMMAND_TERMINATED 0x22
 #define SG_ERR_DRIVER_SENSE     0x08
 
-int sysfs_get_vendor (char * sysfs_path, char * dev, char * buff, int len);
-int sysfs_get_model (char * sysfs_path, char * dev, char * buff, int len);
-int sysfs_get_rev (char * sysfs_path, char * dev, char * buff, int len);
-int sysfs_get_dev (char * sysfs_path, char * dev, char * buff, int len);
-
-int sysfs_get_size (char * sysfs_path, char * dev, unsigned long long *);
+int sysfs_get_dev (struct sysfs_device * dev, char * buff, size_t len);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
 void basename (char *, char *);
diff --git a/libmultipath/list.h b/libmultipath/list.h
new file mode 100644
index 0000000..8626630
--- /dev/null
+++ b/libmultipath/list.h
@@ -0,0 +1,289 @@
+/*
+ * Copied from the Linux kernel source tree, version 2.6.0-test1.
+ *
+ * Licensed under the GPL v2 as per the whole kernel source tree.
+ *
+ */
+
+#ifndef _LIST_H
+#define _LIST_H
+
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ *
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+/*
+ * These are non-NULL pointers that will result in page faults
+ * under normal circumstances, used to verify that nobody uses
+ * non-initialized list entries.
+ */
+#define LIST_POISON1  ((void *) 0x00100100)
+#define LIST_POISON2  ((void *) 0x00200200)
+
+/*
+ * Simple doubly linked list implementation.
+ *
+ * Some of the internal functions ("__xxx") are useful when
+ * manipulating whole lists rather than single entries, as
+ * sometimes we already know the next/prev entries and we can
+ * generate better code by using them directly rather than
+ * using the generic single-entry routines.
+ */
+
+struct list_head {
+	struct list_head *next, *prev;
+};
+
+#define LIST_HEAD_INIT(name) { &(name), &(name) }
+
+#define LIST_HEAD(name) \
+	struct list_head name = LIST_HEAD_INIT(name)
+
+#define INIT_LIST_HEAD(ptr) do { \
+	(ptr)->next = (ptr); (ptr)->prev = (ptr); \
+} while (0)
+
+/*
+ * Insert a new entry between two known consecutive entries. 
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add(struct list_head *new,
+			      struct list_head *prev,
+			      struct list_head *next)
+{
+	next->prev = new;
+	new->next = next;
+	new->prev = prev;
+	prev->next = new;
+}
+
+/**
+ * list_add - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ */
+static inline void list_add(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head, head->next);
+}
+
+/**
+ * list_add_tail - add a new entry
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ */
+static inline void list_add_tail(struct list_head *new, struct list_head *head)
+{
+	__list_add(new, head->prev, head);
+}
+
+/*
+ * Delete a list entry by making the prev/next entries
+ * point to each other.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_del(struct list_head * prev, struct list_head * next)
+{
+	next->prev = prev;
+	prev->next = next;
+}
+
+/**
+ * list_del - deletes entry from list.
+ * @entry: the element to delete from the list.
+ * Note: list_empty on entry does not return true after this, the entry is
+ * in an undefined state.
+ */
+static inline void list_del(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = LIST_POISON1;
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_del_init - deletes entry from list and reinitialize it.
+ * @entry: the element to delete from the list.
+ */
+static inline void list_del_init(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	INIT_LIST_HEAD(entry); 
+}
+
+/**
+ * list_move - delete from one list and add as another's head
+ * @list: the entry to move
+ * @head: the head that will precede our entry
+ */
+static inline void list_move(struct list_head *list, struct list_head *head)
+{
+	__list_del(list->prev, list->next);
+	list_add(list, head);
+}
+
+/**
+ * list_move_tail - delete from one list and add as another's tail
+ * @list: the entry to move
+ * @head: the head that will follow our entry
+ */
+static inline void list_move_tail(struct list_head *list,
+				  struct list_head *head)
+{
+	__list_del(list->prev, list->next);
+	list_add_tail(list, head);
+}
+
+/**
+ * list_empty - tests whether a list is empty
+ * @head: the list to test.
+ */
+static inline int list_empty(struct list_head *head)
+{
+	return head->next == head;
+}
+
+static inline void __list_splice(struct list_head *list,
+				 struct list_head *head)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->next;
+
+	first->prev = head;
+	head->next = first;
+
+	last->next = at;
+	at->prev = last;
+}
+
+/**
+ * list_splice - join two lists
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice(struct list_head *list, struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice(list, head);
+}
+
+/**
+ * list_splice_init - join two lists and reinitialise the emptied list.
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_init(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
+ * list_entry - get the struct for this entry
+ * @ptr:	the &struct list_head pointer.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_entry(ptr, type, member) \
+	container_of(ptr, type, member)
+
+/**
+ * list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ */
+#define list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); \
+		pos = pos->next)
+
+/**
+ * __list_for_each	-	iterate over a list
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ *
+ * This variant differs from list_for_each() in that it's the
+ * simplest possible list iteration code.
+ * Use this for code that knows the list to be very short (empty
+ * or 1 entry) most of the time.
+ */
+#define __list_for_each(pos, head) \
+	for (pos = (head)->next; pos != (head); pos = pos->next)
+
+/**
+ * list_for_each_prev	-	iterate over a list backwards
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev(pos, head) \
+	for (pos = (head)->prev; pos != (head); pos = pos->prev)
+
+/**
+ * list_for_each_safe	-	iterate over a list safe against removal of list entry
+ * @pos:	the &struct list_head to use as a loop counter.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_safe(pos, n, head) \
+	for (pos = (head)->next, n = pos->next; pos != (head); \
+		pos = n, n = pos->next)
+
+/**
+ * list_for_each_entry	-	iterate over list of given type
+ * @pos:	the type * to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry(pos, head, member)				\
+	for (pos = list_entry((head)->next, typeof(*pos), member);	\
+	     &pos->member != (head); 					\
+	     pos = list_entry(pos->member.next, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop counter.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_reverse(pos, head, member)			\
+	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
+	     &pos->member != (head); 					\
+	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+
+/**
+ * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ */
+#define list_for_each_entry_safe(pos, n, head, member)			\
+	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+		n = list_entry(pos->member.next, typeof(*pos), member);	\
+	     &pos->member != (head); 					\
+	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+
+#endif /* _LIST_H */
diff --git a/libmultipath/print.c b/libmultipath/print.c
index dc8af48..1d80e48 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -5,8 +5,8 @@
 #include <string.h>
 #include <libdevmapper.h>
 #include <stdarg.h>
-#include <sysfs/dlist.h>
-#include <sysfs/libsysfs.h>
+#include <sys/stat.h>
+#include <dirent.h>
 
 #include <checkers.h>
 
@@ -1096,35 +1096,46 @@ snprint_blacklist_except (char * buff, i
 extern int
 snprint_devices (char * buff, int len, struct vectors *vecs)
 {
-        struct dlist * ls;
-        struct sysfs_class * class;
-        struct sysfs_class_device * dev;
+	DIR *blkdir;
+	struct dirent *blkdev;
+	struct stat statbuf;
+	char devpath[PATH_MAX];
+	char *devptr;
 	int threshold = MAX_LINE_LEN;
 	int fwd = 0;
 	int r;
 
 	struct path * pp;
 
-        if (!(class = sysfs_open_class("block")))
-                return 0;
-
-        if (!(ls = sysfs_get_class_devices(class))) {
-                sysfs_close_class(class);
-                return 0;
-        }
+	if (!(blkdir = opendir("/sys/block")))
+		return 1;
 
 	if ((len - fwd - threshold) <= 0)
 		return len;
 	fwd += snprintf(buff + fwd, len - fwd, "available block devices:\n");
 
-        dlist_for_each_data(ls, dev, struct sysfs_class_device) {
+	strcpy(devpath,"/sys/block");
+	devptr = devpath + 10;
+	while ((blkdev = readdir(blkdir)) != NULL) {
+		if ((strcmp(blkdev->d_name,".") == 0) ||
+		    (strcmp(blkdev->d_name,"..") == 0))
+			continue;
+
+		strcat(devptr,blkdev->d_name);
+		if (stat(devptr, &statbuf) < 0)
+			continue;
+
+		if (S_ISDIR(statbuf.st_mode) == 0)
+			continue;
+
 		if ((len - fwd - threshold)  <= 0)
 			return len;
-		fwd += snprintf(buff + fwd, len - fwd, "    %s", dev->name);
-		pp = find_path_by_dev(vecs->pathvec, dev->name);
+
+		fwd += snprintf(buff + fwd, len - fwd, "    %s", devpath);
+		pp = find_path_by_dev(vecs->pathvec, devpath);
 		if (!pp) {
 			r = filter_devnode(conf->blist_devnode,
-					   conf->elist_devnode, dev->name);
+					   conf->elist_devnode, devpath);
 			if (r > 0)
 				fwd += snprintf(buff + fwd, len - fwd,
 						" (blacklisted)");
@@ -1133,8 +1144,8 @@ snprint_devices (char * buff, int len, s
 						" (whitelisted)");
 		}
 		fwd += snprintf(buff + fwd, len - fwd, "\n");
-        }
-        sysfs_close_class(class);
+	}
+	closedir(blkdir);
 
 	if (fwd > len)
 		return len;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 46dcdee..75322aa 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -9,6 +9,9 @@
 #define FILE_NAME_SIZE		256
 #define CALLOUT_MAX_SIZE	128
 #define BLK_DEV_SIZE		33
+#define PATH_SIZE		512
+#define NAME_SIZE		128
+
 
 #define SCSI_VENDOR_SIZE	9
 #define SCSI_PRODUCT_SIZE	17
@@ -86,9 +89,19 @@ struct scsi_dev {
 	int host_no;
 };
 
+struct sysfs_device {
+	struct sysfs_device *parent;		/* parent device */
+	char devpath[PATH_SIZE];
+	char subsystem[NAME_SIZE];		/* $class, $bus, drivers, module */
+	char kernel[NAME_SIZE];			/* device instance name */
+	char kernel_number[NAME_SIZE];
+	char driver[NAME_SIZE];			/* device driver name */
+};
+
 struct path {
 	char dev[FILE_NAME_SIZE];
 	char dev_t[BLK_DEV_SIZE];
+	struct sysfs_device *sysdev;
 	struct scsi_idlun scsi_id;
 	struct sg_id sg_id;
 	char wwid[WWID_SIZE];
@@ -200,6 +213,6 @@ struct path * first_path (struct multipa
 int pathcountgr (struct pathgroup *, int);
 int pathcount (struct multipath *, int);
 
-char sysfs_path[FILE_NAME_SIZE];
+extern char sysfs_path[PATH_SIZE];
 
 #endif /* _STRUCTS_H */
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index a4a996a..1cc6028 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -13,6 +13,7 @@
 #include "dmparser.h"
 #include "config.h"
 #include "propsel.h"
+#include "sysfs.h"
 #include "discovery.h"
 #include "waiter.h"
 
@@ -373,10 +374,10 @@ verify_paths(struct multipath * mpp, str
 		/*
 		 * see if path is in sysfs
 		 */
-		if (!pp->dev || sysfs_get_dev(sysfs_path,
-				  pp->dev, pp->dev_t, BLK_DEV_SIZE)) {
+		if (!pp->sysdev || sysfs_get_dev(pp->sysdev,
+						 pp->dev_t, BLK_DEV_SIZE)) {
 			condlog(0, "%s: failed to access path %s", mpp->alias,
-				pp->dev ? pp->dev : pp->dev_t);
+				pp->sysdev ? pp->sysdev->devpath : pp->dev_t);
 			count++;
 			vector_del_slot(mpp->paths, i);
 			i--;
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
new file mode 100644
index 0000000..9d54bc8
--- /dev/null
+++ b/libmultipath/sysfs.c
@@ -0,0 +1,409 @@
+/*
+ * Copyright (C) 2005-2006 Kay Sievers <kay.sievers@vrfy.org>
+ *
+ *	This program is free software; you can redistribute it and/or modify it
+ *	under the terms of the GNU General Public License as published by the
+ *	Free Software Foundation version 2 of the License.
+ * 
+ *	This program is distributed in the hope that it will be useful, but
+ *	WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *	General Public License for more details.
+ * 
+ *	You should have received a copy of the GNU General Public License along
+ *	with this program; if not, write to the Free Software Foundation, Inc.,
+ *	51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ */
+
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <stddef.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <ctype.h>
+#include <errno.h>
+#include <sys/stat.h>
+#include <string.h>
+
+#include "checkers.h"
+#include "vector.h"
+#include "structs.h"
+#include "sysfs.h"
+#include "list.h"
+#include "util.h"
+
+char sysfs_path[PATH_SIZE];
+
+/* attribute value cache */
+static LIST_HEAD(attr_list);
+struct sysfs_attr {
+	struct list_head node;
+	char path[PATH_SIZE];
+	char *value;			/* points to value_local if value is cached */
+	char value_local[NAME_SIZE];
+};
+
+int sysfs_init(char *path, size_t len)
+{
+	if (path) {
+		strlcpy(sysfs_path, path, len);
+		remove_trailing_chars(sysfs_path, '/');
+	} else
+		strlcpy(sysfs_path, "/sys", len);
+	dbg("sysfs_path='%s'", sysfs_path);
+
+	INIT_LIST_HEAD(&attr_list);
+	return 0;
+}
+
+void sysfs_cleanup(void)
+{
+	struct sysfs_attr *attr_loop;
+	struct sysfs_attr *attr_temp;
+
+	list_for_each_entry_safe(attr_loop, attr_temp, &attr_list, node) {
+		list_del(&attr_loop->node);
+		free(attr_loop);
+	}
+
+}
+
+void sysfs_device_set_values(struct sysfs_device *dev, const char *devpath,
+			     const char *subsystem, const char *driver)
+{
+	char *pos;
+
+	strlcpy(dev->devpath, devpath, sizeof(dev->devpath));
+	if (subsystem != NULL)
+		strlcpy(dev->subsystem, subsystem, sizeof(dev->subsystem));
+	if (driver != NULL)
+		strlcpy(dev->driver, driver, sizeof(dev->driver));
+
+	/* set kernel name */
+	pos = strrchr(dev->devpath, '/');
+	if (pos == NULL)
+		return;
+	strlcpy(dev->kernel, &pos[1], sizeof(dev->kernel));
+	dbg("kernel='%s'", dev->kernel);
+
+	/* some devices have '!' in their name, change that to '/' */
+	pos = dev->kernel;
+	while (pos[0] != '\0') {
+		if (pos[0] == '!')
+			pos[0] = '/';
+		pos++;
+	}
+
+	/* get kernel number */
+	pos = &dev->kernel[strlen(dev->kernel)];
+	while (isdigit(pos[-1]))
+		pos--;
+	strlcpy(dev->kernel_number, pos, sizeof(dev->kernel_number));
+	dbg("kernel_number='%s'", dev->kernel_number);
+}
+
+int sysfs_resolve_link(char *devpath, size_t size)
+{
+	char link_path[PATH_SIZE];
+	char link_target[PATH_SIZE];
+	int len;
+	int i;
+	int back;
+
+	strlcpy(link_path, sysfs_path, sizeof(link_path));
+	strlcat(link_path, devpath, sizeof(link_path));
+	len = readlink(link_path, link_target, sizeof(link_target));
+	if (len <= 0)
+		return -1;
+	link_target[len] = '\0';
+	dbg("path link '%s' points to '%s'", devpath, link_target);
+
+	for (back = 0; strncmp(&link_target[back * 3], "../", 3) == 0; back++)
+		;
+	dbg("base '%s', tail '%s', back %i", devpath, &link_target[back * 3], back);
+	for (i = 0; i <= back; i++) {
+		char *pos = strrchr(devpath, '/');
+
+		if (pos == NULL)
+			return -1;
+		pos[0] = '\0';
+	}
+	dbg("after moving back '%s'", devpath);
+	strlcat(devpath, "/", size);
+	strlcat(devpath, &link_target[back * 3], size);
+	return 0;
+}
+
+struct sysfs_device *sysfs_device_get(const char *devpath)
+{
+	char path[PATH_SIZE];
+	char devpath_real[PATH_SIZE];
+	struct sysfs_device *dev;
+	struct stat statbuf;
+	char link_path[PATH_SIZE];
+	char link_target[PATH_SIZE];
+	int len;
+	char *pos;
+
+	dbg("open '%s'", devpath);
+	strlcpy(devpath_real, devpath, sizeof(devpath_real));
+	remove_trailing_chars(devpath_real, '/');
+
+	/* if we got a link, resolve it to the real device */
+	strlcpy(path, sysfs_path, sizeof(path));
+	strlcat(path, devpath_real, sizeof(path));
+	if (lstat(path, &statbuf) != 0) {
+		dbg("stat '%s' failed: %s", path, strerror(errno));
+		return NULL;
+	}
+	if (S_ISLNK(statbuf.st_mode)) {
+		if (sysfs_resolve_link(devpath_real, sizeof(devpath_real)) != 0)
+			return NULL;
+
+	}
+
+	/* it is a new device */
+	dbg("new device '%s'", devpath_real);
+	dev = malloc(sizeof(struct sysfs_device));
+	if (dev == NULL)
+		return NULL;
+	memset(dev, 0x00, sizeof(struct sysfs_device));
+
+	sysfs_device_set_values(dev, devpath_real, NULL, NULL);
+
+	/* get subsystem name */
+	strlcpy(link_path, sysfs_path, sizeof(link_path));
+	strlcat(link_path, dev->devpath, sizeof(link_path));
+	strlcat(link_path, "/subsystem", sizeof(link_path));
+	len = readlink(link_path, link_target, sizeof(link_target));
+	if (len > 0) {
+		/* get subsystem from "subsystem" link */
+		link_target[len] = '\0';
+		dbg("subsystem link '%s' points to '%s'", link_path, link_target);
+		pos = strrchr(link_target, '/');
+		if (pos != NULL)
+			strlcpy(dev->subsystem, &pos[1], sizeof(dev->subsystem));
+	} else if (strncmp(dev->devpath, "/class/", 7) == 0) {
+		/* get subsystem from class dir */
+		strlcpy(dev->subsystem, &dev->devpath[7], sizeof(dev->subsystem));
+		pos = strchr(dev->subsystem, '/');
+		if (pos != NULL)
+			pos[0] = '\0';
+		else
+			dev->subsystem[0] = '\0';
+	} else if (strncmp(dev->devpath, "/block/", 7) == 0) {
+		strlcpy(dev->subsystem, "block", sizeof(dev->subsystem));
+	} else if (strncmp(dev->devpath, "/devices/", 9) == 0) {
+		/* get subsystem from "bus" link */
+		strlcpy(link_path, sysfs_path, sizeof(link_path));
+		strlcat(link_path, dev->devpath, sizeof(link_path));
+		strlcat(link_path, "/bus", sizeof(link_path));
+		len = readlink(link_path, link_target, sizeof(link_target));
+		if (len > 0) {
+			link_target[len] = '\0';
+			dbg("bus link '%s' points to '%s'", link_path, link_target);
+			pos = strrchr(link_target, '/');
+			if (pos != NULL)
+				strlcpy(dev->subsystem, &pos[1], sizeof(dev->subsystem));
+		}
+	} else if (strstr(dev->devpath, "/drivers/") != NULL) {
+		strlcpy(dev->subsystem, "drivers", sizeof(dev->subsystem));
+	} else if (strncmp(dev->devpath, "/module/", 8) == 0) {
+		strlcpy(dev->subsystem, "module", sizeof(dev->subsystem));
+	}
+
+	/* get driver name */
+	strlcpy(link_path, sysfs_path, sizeof(link_path));
+	strlcat(link_path, dev->devpath, sizeof(link_path));
+	strlcat(link_path, "/driver", sizeof(link_path));
+	len = readlink(link_path, link_target, sizeof(link_target));
+	if (len > 0) {
+		link_target[len] = '\0';
+		dbg("driver link '%s' points to '%s'", link_path, link_target);
+		pos = strrchr(link_target, '/');
+		if (pos != NULL)
+			strlcpy(dev->driver, &pos[1], sizeof(dev->driver));
+	}
+
+	return dev;
+}
+
+struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev)
+{
+	char parent_devpath[PATH_SIZE];
+	char *pos;
+
+	dbg("open '%s'", dev->devpath);
+
+	/* look if we already know the parent */
+	if (dev->parent != NULL)
+		return dev->parent;
+
+	/* requesting a parent is only valid for devices */
+	if ((strncmp(dev->devpath, "/devices/", 9) != 0) &&
+	    (strncmp(dev->devpath, "/subsystem/", 11) != 0) &&
+	    (strncmp(dev->devpath, "/class/", 7) != 0) &&
+	    (strncmp(dev->devpath, "/block/", 7) != 0))
+		return NULL;
+
+	strlcpy(parent_devpath, dev->devpath, sizeof(parent_devpath));
+	dbg("'%s'", parent_devpath);
+
+	/* strip last element */
+	pos = strrchr(parent_devpath, '/');
+	if (pos == NULL || pos == parent_devpath)
+		return NULL;
+	pos[0] = '\0';
+
+	/* are we at the top level of /devices */
+	if (strcmp(parent_devpath, "/devices") == 0) {
+		dbg("/devices top level");
+		return NULL;
+	}
+
+	/* at the subsystems top level we want to follow the old-style "device" link */
+	if (strncmp(parent_devpath, "/subsystem", 10) == 0) {
+		pos = strrchr(parent_devpath, '/');
+		if (pos == &parent_devpath[10] || pos == parent_devpath || strcmp(pos, "/devices") == 0) {
+			dbg("/subsystem top level, look for device link");
+			goto device_link;
+		}
+	}
+	if (strncmp(parent_devpath, "/class", 6) == 0) {
+		pos = strrchr(parent_devpath, '/');
+		if (pos == &parent_devpath[6] || pos == parent_devpath) {
+			dbg("/class top level, look for device link");
+			goto device_link;
+		}
+	}
+	if (strcmp(parent_devpath, "/block") == 0) {
+		dbg("/block top level, look for device link");
+		goto device_link;
+	}
+
+	/* get parent and remember it */
+	dev->parent = sysfs_device_get(parent_devpath);
+	return dev->parent;
+
+device_link:
+	strlcpy(parent_devpath, dev->devpath, sizeof(parent_devpath));
+	strlcat(parent_devpath, "/device", sizeof(parent_devpath));
+	if (sysfs_resolve_link(parent_devpath, sizeof(parent_devpath)) != 0)
+		return NULL;
+
+	/* get parent and remember it */
+	dev->parent = sysfs_device_get(parent_devpath);
+	return dev->parent;
+}
+
+struct sysfs_device *sysfs_device_get_parent_with_subsystem(struct sysfs_device *dev, const char *subsystem)
+{
+	struct sysfs_device *dev_parent;
+
+	dev_parent = sysfs_device_get_parent(dev);
+	while (dev_parent != NULL) {
+		if (strcmp(dev_parent->subsystem, subsystem) == 0)
+			return dev_parent;
+		dev_parent = sysfs_device_get_parent(dev_parent);
+	}
+	return NULL;
+}
+
+char *sysfs_attr_get_value(const char *devpath, const char *attr_name)
+{
+	char path_full[PATH_SIZE];
+	const char *path;
+	char value[NAME_SIZE];
+	struct sysfs_attr *attr_loop;
+	struct sysfs_attr *attr;
+	struct stat statbuf;
+	int fd;
+	ssize_t size;
+	size_t sysfs_len;
+
+	dbg("open '%s'/'%s'", devpath, attr_name);
+	sysfs_len = strlcpy(path_full, sysfs_path, sizeof(path_full));
+	path = &path_full[sysfs_len];
+	strlcat(path_full, devpath, sizeof(path_full));
+	strlcat(path_full, "/", sizeof(path_full));
+	strlcat(path_full, attr_name, sizeof(path_full));
+
+	/* look for attribute in cache */
+	list_for_each_entry(attr_loop, &attr_list, node) {
+		if (strcmp(attr_loop->path, path) == 0) {
+			dbg("found in cache '%s'", attr_loop->path);
+			attr= attr_loop;
+		}
+	}
+	if (!attr) {
+		/* store attribute in cache */
+		dbg("new uncached attribute '%s'", path_full);
+		attr = malloc(sizeof(struct sysfs_attr));
+		if (attr == NULL)
+			return NULL;
+		memset(attr, 0x00, sizeof(struct sysfs_attr));
+		strlcpy(attr->path, path, sizeof(attr->path));
+		dbg("add to cache '%s'", path_full);
+		list_add(&attr->node, &attr_list);
+	} else {
+		/* clear old value */
+		memset(attr->value, 0x00, sizeof(attr->value));
+	}
+
+	if (lstat(path_full, &statbuf) != 0) {
+		dbg("stat '%s' failed: %s", path_full, strerror(errno));
+		goto out;
+	}
+
+	if (S_ISLNK(statbuf.st_mode)) {
+		/* links return the last element of the target path */
+		char link_target[PATH_SIZE];
+		int len;
+		const char *pos;
+
+		len = readlink(path_full, link_target, sizeof(link_target));
+		if (len > 0) {
+			link_target[len] = '\0';
+			pos = strrchr(link_target, '/');
+			if (pos != NULL) {
+				dbg("cache '%s' with link value '%s'", path_full, value);
+				strlcpy(attr->value_local, &pos[1], sizeof(attr->value_local));
+				attr->value = attr->value_local;
+			}
+		}
+		goto out;
+	}
+
+	/* skip directories */
+	if (S_ISDIR(statbuf.st_mode))
+		goto out;
+
+	/* skip non-readable files */
+	if ((statbuf.st_mode & S_IRUSR) == 0)
+		goto out;
+
+	/* read attribute value */
+	fd = open(path_full, O_RDONLY);
+	if (fd < 0) {
+		dbg("attribute '%s' does not exist", path_full);
+		goto out;
+	}
+	size = read(fd, value, sizeof(value));
+	close(fd);
+	if (size < 0)
+		goto out;
+	if (size == sizeof(value))
+		goto out;
+
+	/* got a valid value, store and return it */
+	value[size] = '\0';
+	remove_trailing_chars(value, '\n');
+	dbg("cache '%s' with attribute value '%s'", path_full, value);
+	strlcpy(attr->value_local, value, sizeof(attr->value_local));
+	attr->value = attr->value_local;
+
+out:
+	return attr->value;
+}
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
new file mode 100644
index 0000000..4ac30db
--- /dev/null
+++ b/libmultipath/sysfs.h
@@ -0,0 +1,20 @@
+/*
+ * sysfs.h
+ */
+
+#ifndef _LIBMULTIPATH_SYSFS_H
+#define _LIBMULTIPATH_SYSFS_H
+
+#define dbg(format, arg...) do {} while (0)
+
+int sysfs_init(char *path, size_t len);
+void sysfs_cleanup(void);
+void sysfs_device_set_values(struct sysfs_device *dev, const char *devpath,
+			     const char *subsystem, const char *driver);
+struct sysfs_device *sysfs_device_get(const char *devpath);
+struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev);
+struct sysfs_device *sysfs_device_get_parent_with_subsystem(struct sysfs_device *dev, const char *subsystem);
+char *sysfs_attr_get_value(const char *devpath, const char *attr_name);
+int sysfs_resolve_link(char *path, size_t size);
+
+#endif
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 911ec55..eaf2266 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -103,3 +103,55 @@ get_word (char * sentence, char ** word)
 	return skip + len;
 }
 
+size_t strlcpy(char *dst, const char *src, size_t size)
+{
+	size_t bytes = 0;
+	char *q = dst;
+	const char *p = src;
+	char ch;
+
+	while ((ch = *p++)) {
+		if (bytes+1 < size)
+			*q++ = ch;
+		bytes++;
+	}
+
+	/* If size == 0 there is no space for a final null... */
+	if (size)
+		*q = '\0';
+	return bytes;
+}
+
+size_t strlcat(char *dst, const char *src, size_t size)
+{
+	size_t bytes = 0;
+	char *q = dst;
+	const char *p = src;
+	char ch;
+
+	while (bytes < size && *q) {
+		q++;
+		bytes++;
+	}
+	if (bytes == size)
+		return (bytes + strlen(src));
+
+	while ((ch = *p++)) {
+		if (bytes+1 < size)
+		*q++ = ch;
+		bytes++;
+	}
+
+	*q = '\0';
+	return bytes;
+}
+
+void remove_trailing_chars(char *path, char c)
+{
+	size_t len;
+
+	len = strlen(path);
+	while (len > 0 && path[len-1] == c)
+		path[--len] = '\0';
+}
+
diff --git a/libmultipath/util.h b/libmultipath/util.h
index e86bae2..d0df8aa 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -6,7 +6,9 @@ void strchop(char *);
 void basename (char * src, char * dst);
 int filepresent (char * run);
 int get_word (char * sentence, char ** word);
-
+size_t strlcpy(char *dst, const char *src, size_t size);
+size_t strlcat(char *dst, const char *src, size_t size);
+void remove_trailing_chars(char *path, char c);
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
diff --git a/multipath/Makefile b/multipath/Makefile
index 2afa6ad..8ff1775 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -12,7 +12,7 @@ CFLAGS += -I$(multipathdir) -I$(checkers
 ifeq ($(strip $(BUILD)),klibc)
 	OBJS += $(libdm) $(libsysfs)
 else
-	LDFLAGS += -ldevmapper -lsysfs
+	LDFLAGS += -ldevmapper
 endif
 
 EXEC = multipath
diff --git a/multipath/main.c b/multipath/main.c
index c3d0dac..e2d7f41 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -25,7 +25,6 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <ctype.h>
-#include <sysfs/libsysfs.h>
 
 #include <checkers.h>
 #include <vector.h>
@@ -37,6 +36,7 @@
 #include <structs.h>
 #include <structs_vec.h>
 #include <dmparser.h>
+#include <sysfs.h>
 #include <config.h>
 #include <blacklist.h>
 #include <discovery.h>
@@ -373,13 +373,13 @@ main (int argc, char *argv[])
 	if (dm_prereq(DEFAULT_TARGET))
 		exit(1);
 
-	if (sysfs_get_mnt_path(sysfs_path, FILE_NAME_SIZE)) {
-		condlog(0, "multipath tools need sysfs mounted");
-		exit(1);
-	}
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
+	if (sysfs_init(conf->sysfs_dir, FILE_NAME_SIZE)) {
+		condlog(0, "multipath tools need sysfs mounted");
+		exit(1);
+	}
 	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:t")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
@@ -472,6 +472,7 @@ main (int argc, char *argv[])
 		condlog(3, "restart multipath configuration process");
 	
 out:
+	sysfs_cleanup();
 	free_config(conf);
 	dm_lib_release();
 	dm_lib_exit();
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 8ad25ee..5ae9e7b 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -7,7 +7,7 @@ include ../Makefile.inc
 # basic flags setting
 #
 CFLAGS += -DDAEMON -I$(multipathdir) -I$(checkersdir)
-LDFLAGS = -lpthread -ldevmapper -lsysfs -lreadline -lncurses
+LDFLAGS = -lpthread -ldevmapper -lreadline -lncurses
 
 #
 # debuging stuff
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4938e84..7bae02a 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -13,6 +13,7 @@
 #include <blacklist.h>
 #include <debug.h>
 #include <print.h>
+#include <sysfs.h>
 
 #include "main.h"
 #include "cli.h"
@@ -312,6 +313,9 @@ cli_add_map (void * v, char ** reply, in
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
+	int minor;
+	char dev_path[PATH_SIZE];
+	struct sysfs_device *sysdev;
 
 	condlog(2, "%s: add map (operator)", param);
 
@@ -321,7 +325,18 @@ cli_add_map (void * v, char ** reply, in
 		condlog(2, "%s: map blacklisted", param);
 		return 0;
 	}
-	return ev_add_map(param, vecs);
+	minor = dm_get_minor(param);
+	if (minor < 0) {
+		condlog(2, "%s: not a device mapper table", param);
+		return 0;
+	}
+	sprintf(dev_path,"/block/dm-%d", minor);
+	sysdev = sysfs_device_get(dev_path);
+	if (!sysdev) {
+		condlog(2, "%s: not found in sysfs", param);
+		return 0;
+	}
+	return ev_add_map(sysdev, vecs);
 }
 
 int
diff --git a/multipathd/main.c b/multipathd/main.c
index 94b0b95..a173da3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -14,12 +14,6 @@
 #include <errno.h>
 
 /*
- * libsysfs
- */
-#include <sysfs/libsysfs.h>
-#include <sysfs/dlist.h>
-
-/*
  * libcheckers
  */
 #include <checkers.h>
@@ -40,6 +34,7 @@
 #include <structs_vec.h>
 #include <dmparser.h>
 #include <devmapper.h>
+#include <sysfs.h>
 #include <dict.h>
 #include <discovery.h>
 #include <debug.h>
@@ -208,31 +203,29 @@ flush_map(struct multipath * mpp, struct
 }
 
 static int
-uev_add_map (char * devname, struct vectors * vecs)
+uev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 {
-	condlog(2, "%s: add map (uevent)", devname);
-	return ev_add_map(devname, vecs);
+	condlog(2, "%s: add map (uevent)", dev->kernel);
+	return ev_add_map(dev, vecs);
 }
 
 int
-ev_add_map (char * devname, struct vectors * vecs)
+ev_add_map (struct sysfs_device * dev, struct vectors * vecs)
 {
-	int major, minor;
-	char dev_t[BLK_DEV_SIZE];
 	char * alias;
+	char *dev_t;
+	int major, minor;
 	char * refwwid;
 	struct multipath * mpp;
 	int map_present;
 	int r = 1;
 
-	/* libsysfs seems to forget to terminate the string... */
-	memset(dev_t, 0, BLK_DEV_SIZE);
-	if (sscanf(devname, "dm-%d", &minor) == 1 &&
-	    !sysfs_get_dev(sysfs_path, devname, dev_t, BLK_DEV_SIZE) &&
-	    sscanf(dev_t, "%d:%d", &major, &minor) == 2)
-		alias = dm_mapname(major, minor);
-	else
-		alias = STRDUP(devname);
+	dev_t = sysfs_attr_get_value(dev->devpath, "dev");
+
+	if (!dev_t || sscanf(dev_t, "%d:%d", &major, &minor) != 2)
+		return 1;
+
+	alias = dm_mapname(major, minor);
 		
 	if (!alias)
 		return 1;
@@ -241,7 +234,6 @@ ev_add_map (char * devname, struct vecto
 
 	if (map_present && dm_type(alias, DEFAULT_TARGET) <= 0) {
 		condlog(4, "%s: not a multipath map", alias);
-		FREE(alias);
 		return 0;
 	}
 
@@ -254,8 +246,7 @@ ev_add_map (char * devname, struct vecto
 		 * of uev_add_path
 		 */
 		condlog(0, "%s: devmap already registered",
-			devname);
-		FREE(alias);
+			dev->kernel);
 		return 0;
 	}
 
@@ -265,10 +256,10 @@ ev_add_map (char * devname, struct vecto
 	if (map_present && (mpp = add_map_without_path(vecs, minor, alias,
 					start_waiter_thread))) {
 		sync_map_state(mpp);
-		condlog(3, "%s: devmap %s added", alias, devname);
+		condlog(3, "%s: devmap %s added", alias, dev->kernel);
 		return 0;
 	}
-	refwwid = get_refwwid(devname, DEV_DEVMAP, vecs->pathvec);
+	refwwid = get_refwwid(dev->kernel, DEV_DEVMAP, vecs->pathvec);
 
 	if (refwwid) {
 		r = coalesce_paths(vecs, NULL, refwwid);
@@ -276,20 +267,19 @@ ev_add_map (char * devname, struct vecto
 	}
 	
 	if (!r)
-		condlog(3, "%s: devmap %s added", alias, devname);
+		condlog(3, "%s: devmap %s added", alias, dev->kernel);
 	else
-		condlog(0, "%s: uev_add_map %s failed", alias, devname);
+		condlog(0, "%s: uev_add_map %s failed", alias, dev->kernel);
 
 	FREE(refwwid);
-	FREE(alias);
 	return r;
 }
 
 static int
-uev_remove_map (char * devname, struct vectors * vecs)
+uev_remove_map (struct sysfs_device * dev, struct vectors * vecs)
 {
-	condlog(2, "%s: remove map (uevent)", devname);
-	return ev_remove_map(devname, vecs);
+	condlog(2, "%s: remove map (uevent)", dev->kernel);
+	return ev_remove_map(dev->kernel, vecs);
 }
 
 int
@@ -310,13 +300,13 @@ ev_remove_map (char * devname, struct ve
 }
 
 static int
-uev_umount_map (char * devname, struct vectors * vecs)
+uev_umount_map (struct sysfs_device * dev, struct vectors * vecs)
 {
 	struct multipath * mpp;
 
-	condlog(2, "%s: umount map (uevent)", devname);
+	condlog(2, "%s: umount map (uevent)", dev->kernel);
 
-	mpp = find_mp_by_str(vecs->mpvec, devname);
+	mpp = find_mp_by_str(vecs->mpvec, dev->kernel);
 
 	if (!mpp)
 		return 0;
@@ -331,10 +321,10 @@ uev_umount_map (char * devname, struct v
 }
 	
 static int
-uev_add_path (char * devname, struct vectors * vecs)
+uev_add_path (struct sysfs_device * dev, struct vectors * vecs)
 {
-	condlog(2, "%s: add path (uevent)", devname);
-	return (ev_add_path(devname, vecs) != 1)? 0 : 1;
+	condlog(2, "%s: add path (uevent)", dev->kernel);
+	return (ev_add_path(dev->kernel, vecs) != 1)? 0 : 1;
 }
 
 
@@ -450,10 +440,10 @@ out:
 }
 
 static int
-uev_remove_path (char * devname, struct vectors * vecs)
+uev_remove_path (struct sysfs_device * dev, struct vectors * vecs)
 {
-	condlog(2, "%s: remove path (uevent)", devname);
-	return ev_remove_path(devname, vecs);
+	condlog(2, "%s: remove path (uevent)", dev->kernel);
+	return ev_remove_path(dev->kernel, vecs);
 }
 
 int
@@ -636,7 +626,7 @@ int
 uev_trigger (struct uevent * uev, void * trigger_data)
 {
 	int r = 0;
-	char devname[32];
+	struct sysfs_device *sysdev;
 	struct vectors * vecs;
 
 	vecs = (struct vectors *)trigger_data;
@@ -644,7 +634,7 @@ uev_trigger (struct uevent * uev, void *
 	if (uev_discard(uev->devpath))
 		return 0;
 
-	basename(uev->devpath, devname);
+	sysdev = sysfs_device_get(uev->devpath);
 	lock(vecs->lock);
 
 	/*
@@ -652,17 +642,17 @@ uev_trigger (struct uevent * uev, void *
 	 * Add events are ignored here as the tables
 	 * are not fully initialised then.
 	 */
-	if (!strncmp(devname, "dm-", 3)) {
+	if (!strncmp(sysdev->kernel, "dm-", 3)) {
 		if (!strncmp(uev->action, "change", 6)) {
-			r = uev_add_map(devname, vecs);
+			r = uev_add_map(sysdev, vecs);
 			goto out;
 		}
 		if (!strncmp(uev->action, "remove", 6)) {
-			r = uev_remove_map(devname, vecs);
+			r = uev_remove_map(sysdev, vecs);
 			goto out;
 		}
 		if (!strncmp(uev->action, "umount", 6)) {
-			r = uev_umount_map(devname, vecs);
+			r = uev_umount_map(sysdev, vecs);
 			goto out;
 		}
 		goto out;
@@ -672,15 +662,15 @@ uev_trigger (struct uevent * uev, void *
 	 * path add/remove event
 	 */
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-		 	   devname) > 0)
+		 	   sysdev->kernel) > 0)
 		goto out;
 
 	if (!strncmp(uev->action, "add", 3)) {
-		r = uev_add_path(devname, vecs);
+		r = uev_add_path(sysdev, vecs);
 		goto out;
 	}
 	if (!strncmp(uev->action, "remove", 6)) {
-		r = uev_remove_path(devname, vecs);
+		r = uev_remove_path(sysdev, vecs);
 		goto out;
 	}
 
@@ -1278,7 +1268,7 @@ child (void * param)
 	if (!vecs)
 		exit(1);
 
-	if (sysfs_get_mnt_path(sysfs_path, FILE_NAME_SIZE)) {
+	if (sysfs_init(conf->sysfs_dir, FILE_NAME_SIZE)) {
 		condlog(0, "can not find sysfs mount point");
 		exit(1);
 	}
@@ -1315,6 +1305,8 @@ child (void * param)
 	pthread_cancel(uevent_thr);
 	pthread_cancel(uxlsnr_thr);
 
+	sysfs_cleanup();
+
 	free_keys(keys);
 	keys = NULL;
 	free_handlers(handlers);
diff --git a/multipathd/main.h b/multipathd/main.h
index d0cce3a..1a6dc55 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -7,7 +7,7 @@
 int reconfigure (struct vectors *);
 int ev_add_path (char *, struct vectors *);
 int ev_remove_path (char *, struct vectors *);
-int ev_add_map (char *, struct vectors *);
+int ev_add_map (struct sysfs_device *, struct vectors *);
 int ev_remove_map (char *, struct vectors *);
 
 #endif /* MAIN_H */
-- 
1.4.3.4
