From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/12] Use struct udev_device instead of sysdev
Date: Thu, 19 Apr 2012 11:09:02 +0200
Message-ID: <1334826546-32039-9-git-send-email-hare@suse.de>
References: <1334826546-32039-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1334826546-32039-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device-mapper Development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Remove hand-crafted sysdev and use struct udev_device instead.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c   |  279 +++++++++++++++++++++++--------------------
 libmultipath/discovery.h   |    6 +-
 libmultipath/propsel.c     |    2 +-
 libmultipath/structs.c     |    6 +
 libmultipath/structs.h     |    8 +-
 libmultipath/structs_vec.c |   10 +-
 libmultipath/sysfs.c       |  200 -------------------------------
 libmultipath/sysfs.h       |    3 +-
 libmultipath/uevent.c      |    4 +-
 libmultipath/uevent.h      |    1 +
 libmultipath/util.c        |   10 ++
 libmultipath/util.h        |    1 +
 multipath/main.c           |    1 -
 multipathd/Makefile        |    2 +-
 multipathd/cli_handlers.c  |   11 ++-
 multipathd/main.c          |    9 +-
 16 files changed, 196 insertions(+), 357 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index fd0f827..f45602a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -30,9 +30,15 @@
 #include "defaults.h"
 
 struct path *
-store_pathinfo (vector pathvec, vector hwtable, char * devname, int flag)
+store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
+		int flag)
 {
 	struct path * pp;
+	const char * devname;
+
+	devname = udev_device_get_sysname(udevice);
+	if (!devname)
+		return NULL;
 
 	pp = alloc_path();
 
@@ -43,6 +49,7 @@ store_pathinfo (vector pathvec, vector hwtable, char * devname, int flag)
 		condlog(0, "pp->dev too small");
 		goto out;
 	}
+	pp->udev = udev_device_ref(udevice);
 	if (pathinfo(pp, hwtable, flag))
 		goto out;
 
@@ -73,7 +80,7 @@ path_discover (vector pathvec, struct config * conf,
 	pp = find_path_by_dev(pathvec, (char *)devname);
 	if (!pp) {
 		pp = store_pathinfo(pathvec, conf->hwtable,
-				    (char *)devname, flag);
+				    udevice, flag);
 		return (pp ? 0 : 1);
 	}
 	return pathinfo(pp, conf->hwtable, flag);
@@ -114,24 +121,27 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 	return r;
 }
 
-#define declare_sysfs_get_str(fname) \
-extern int \
-sysfs_get_##fname (const char  * devpath, char * buff, size_t len) \
-{								       \
-	int size;						       \
-								       \
-	size = sysfs_attr_get_value(devpath, #fname, buff, len);	\
-	if (!size) {							\
+#define declare_sysfs_get_str(fname)					\
+extern int								\
+sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)	\
+{									\
+	const char * attr;						\
+	const char * devname;						\
+									\
+	devname = udev_device_get_sysname(udev);			\
+									\
+	attr = udev_device_get_sysattr_value(udev, #fname);		\
+	if (!attr) {							\
 		condlog(3, "%s: attribute %s not found in sysfs",	\
-			devpath, #fname);				\
+			devname, #fname);				\
 		return 1;						\
 	}								\
-	if (size == len) {						\
+	if (strlen(attr) > len) {					\
 		condlog(3, "%s: overflow in attribute %s",		\
-			devpath, #fname);				\
+			devname, #fname);				\
 		return 2;						\
 	}								\
-	strchop(buff);							\
+	strlcpy(buff, attr, len);					\
 	return 0;							\
 }
 
@@ -144,22 +154,27 @@ declare_sysfs_get_str(state);
 declare_sysfs_get_str(dev);
 
 int
-sysfs_get_timeout(const char *devpath, unsigned int *timeout)
+sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 {
-	char attr_path[SYSFS_PATH_SIZE], attr[NAME_SIZE];
-	size_t len;
+	const char *attr = NULL;
+	const char *subsys;
+	struct udev_device *parent;
 	int r;
 	unsigned int t;
 
-	if (!devpath)
-		return 1;
-
-	if (safe_sprintf(attr_path, "%s/device", devpath))
+	if (!pp->udev)
 		return 1;
 
-	len = sysfs_attr_get_value(attr_path, "timeout", attr, NAME_SIZE);
-	if (!len) {
-		condlog(3, "%s: No timeout value in sysfs", devpath);
+	parent = pp->udev;
+	while (parent) {
+		subsys = udev_device_get_subsystem(parent);
+		attr = udev_device_get_sysattr_value(parent, "timeout");
+		if (subsys && attr)
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+	if (!attr) {
+		condlog(3, "%s: No timeout value in sysfs", pp->dev);
 		return 1;
 	}
 
@@ -167,7 +182,7 @@ sysfs_get_timeout(const char *devpath, unsigned int *timeout)
 
 	if (r != 1) {
 		condlog(3, "%s: Cannot parse timeout attribute '%s'",
-			devpath, attr);
+			pp->dev, attr);
 		return 1;
 	}
 
@@ -177,15 +192,17 @@ sysfs_get_timeout(const char *devpath, unsigned int *timeout)
 }
 
 int
-sysfs_get_size (const char * devpath, unsigned long long * size)
+sysfs_get_size (struct path *pp, unsigned long long * size)
 {
-	char attr[NAME_SIZE];
-	size_t len;
+	const char * attr;
 	int r;
 
-	len = sysfs_attr_get_value(devpath, "size", attr, NAME_SIZE);
-	if (!len) {
-		condlog(3, "%s: No size attribute in sysfs", devpath);
+	if (!pp->udev)
+		return 1;
+
+	attr = udev_device_get_sysattr_value(pp->udev, "size");
+	if (!attr) {
+		condlog(3, "%s: No size attribute in sysfs", pp->dev);
 		return 1;
 	}
 
@@ -193,7 +210,7 @@ sysfs_get_size (const char * devpath, unsigned long long * size)
 
 	if (r != 1) {
 		condlog(3, "%s: Cannot parse size attribute '%s'",
-			devpath, attr);
+			pp->dev, attr);
 		return 1;
 	}
 
@@ -201,41 +218,56 @@ sysfs_get_size (const char * devpath, unsigned long long * size)
 }
 
 int
-sysfs_get_tgt_nodename (const char * devpath, char * node,
-		       unsigned int host, unsigned int channel,
-		       unsigned int target)
+sysfs_get_tgt_nodename (struct path *pp, char * node)
 {
-	unsigned int checkhost, session;
+	const char * targetid;
+	struct udev_device *parent;
 	char attr_path[SYSFS_PATH_SIZE];
 	size_t len;
 
+	parent = pp->udev;
+	while (parent) {
+		targetid = udev_device_get_sysname(parent);
+		if (!strncmp(targetid , "target", 6))
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+	/* 'target' needs to exist */
+	if (!parent || !targetid)
+		return 1;
+	/* Check if it's FibreChannel */
 	if (safe_sprintf(attr_path,
-			 "/class/fc_transport/target%i:%i:%i",
-			 host, channel, target)) {
+			 "/class/fc_transport/%s", targetid)) {
 		condlog(0, "attr_path too small");
 		return 1;
 	}
 
-	len = sysfs_attr_get_value(attr_path, "node_name", node, NODE_NAME_SIZE);
+	len = sysfs_attr_get_value(attr_path, "node_name",
+				   node, NODE_NAME_SIZE);
 	if (len)
 		return 0;
 
-	if (sscanf(devpath, "/devices/platform/host%u/session%u/",
-		   &checkhost, &session) != 2)
-		return 1;
-	if (checkhost != host)
-		return 1;
-	if (safe_sprintf(attr_path, "/devices/platform/host%u/session%u/iscsi_session/session%u", host, session, session)) {
-		condlog(0, "attr_path too small");
-		return 1;
+	/* Check for iSCSI */
+	parent = pp->udev;
+	while (parent) {
+		targetid = udev_device_get_sysname(parent);
+		if (!strncmp(targetid , "session", 6))
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+	if (parent) {
+		if (safe_sprintf(attr_path, "/class/iscsi_session/%s",
+				 targetid)) {
+			condlog(0, "attr_path too small");
+			return 1;
+		}
+		len = sysfs_attr_get_value(attr_path, "targetname", node,
+					   NODE_NAME_SIZE);
+		if (len)
+			return 0;
 	}
 
-	len = sysfs_attr_get_value(attr_path, "targetname", node,
-				   NODE_NAME_SIZE);
-	if (!len)
-		return 1;
-
-	return 0;
+	return 1;
 }
 
 static int
@@ -535,9 +567,28 @@ get_geometry(struct path *pp)
 }
 
 static int
-scsi_sysfs_pathinfo (struct path * pp, const char * parent)
+scsi_sysfs_pathinfo (struct path * pp)
 {
-	char attr_path[FILE_NAME_SIZE];
+	struct udev_device *parent;
+	const char *attr_path = NULL;
+
+	parent = pp->udev;
+	while (parent) {
+		if (!strncmp(udev_device_get_subsystem(parent), "scsi", 4)) {
+			attr_path = udev_device_get_sysname(parent);
+			if (!attr_path)
+				break;
+			if (sscanf(attr_path, "%i:%i:%i:%i",
+				   &pp->sg_id.host_no,
+				   &pp->sg_id.channel,
+				   &pp->sg_id.scsi_id,
+				   &pp->sg_id.lun) == 4)
+				break;
+		}
+		parent = udev_device_get_parent(parent);
+	}
+	if (!attr_path || pp->sg_id.host_no == -1)
+		return 1;
 
 	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE))
 		return 1;
@@ -562,13 +613,6 @@ scsi_sysfs_pathinfo (struct path * pp, const char * parent)
 	/*
 	 * host / bus / target / lun
 	 */
-	basenamecpy(parent, attr_path, FILE_NAME_SIZE);
-
-	sscanf(attr_path, "%i:%i:%i:%i",
-			&pp->sg_id.host_no,
-			&pp->sg_id.channel,
-			&pp->sg_id.scsi_id,
-			&pp->sg_id.lun);
 	condlog(3, "%s: h:b:t:l = %i:%i:%i:%i",
 			pp->dev,
 			pp->sg_id.host_no,
@@ -579,10 +623,7 @@ scsi_sysfs_pathinfo (struct path * pp, const char * parent)
 	/*
 	 * target node name
 	 */
-	if(!sysfs_get_tgt_nodename(parent, pp->tgt_node_name,
-				 pp->sg_id.host_no,
-				 pp->sg_id.channel,
-				 pp->sg_id.scsi_id)) {
+	if(!sysfs_get_tgt_nodename(pp, pp->tgt_node_name)) {
 		condlog(3, "%s: tgt_node_name = %s",
 			pp->dev, pp->tgt_node_name);
 	}
@@ -591,10 +632,20 @@ scsi_sysfs_pathinfo (struct path * pp, const char * parent)
 }
 
 static int
-ccw_sysfs_pathinfo (struct path * pp, const char * parent)
+ccw_sysfs_pathinfo (struct path * pp)
 {
-	char attr_path[FILE_NAME_SIZE];
-	char attr_buff[FILE_NAME_SIZE];
+	struct udev_device *parent;
+	char attr_buff[NAME_SIZE];
+	const char *attr_path;
+
+	parent = pp->udev;
+	while (parent) {
+		if (!strncmp(udev_device_get_subsystem(parent), "ccw", 3))
+			break;
+		parent = udev_device_get_parent(parent);
+	}
+	if (!parent)
+		return 1;
 
 	sprintf(pp->vendor_id, "IBM");
 
@@ -621,7 +672,7 @@ ccw_sysfs_pathinfo (struct path * pp, const char * parent)
 	/*
 	 * host / bus / target / lun
 	 */
-	basenamecpy(parent, attr_path, FILE_NAME_SIZE);
+	attr_path = udev_device_get_sysname(parent);
 	pp->sg_id.lun = 0;
 	sscanf(attr_path, "%i.%i.%x",
 			&pp->sg_id.host_no,
@@ -638,14 +689,17 @@ ccw_sysfs_pathinfo (struct path * pp, const char * parent)
 }
 
 static int
-cciss_sysfs_pathinfo (struct path * pp, const char * devpath)
+cciss_sysfs_pathinfo (struct path * pp)
 {
-	char attr_path[FILE_NAME_SIZE];
+	const char * attr_path;
 
 	/*
 	 * host / bus / target / lun
 	 */
-	basenamecpy(devpath, attr_path, FILE_NAME_SIZE);
+	attr_path = udev_device_get_devpath(pp->udev);
+	if (!attr_path)
+		return 1;
+
 	pp->sg_id.lun = 0;
 	pp->sg_id.channel = 0;
 	sscanf(attr_path, "cciss!c%id%i",
@@ -661,20 +715,20 @@ cciss_sysfs_pathinfo (struct path * pp, const char * devpath)
 }
 
 static int
-common_sysfs_pathinfo (struct path * pp, const char * devpath)
+common_sysfs_pathinfo (struct path * pp)
 {
-	size_t len;
-
-	len = sysfs_attr_get_value(devpath, "dev",
-				   pp->dev_t, BLK_DEV_SIZE);
-	if (!len) {
+	if (!pp->udev) {
+		condlog(4, "%s: udev not initialised", pp->dev);
+		return 1;
+	}
+	if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE)) {
 		condlog(3, "%s: no 'dev' attribute in sysfs", pp->dev);
 		return 1;
 	}
 
 	condlog(3, "%s: dev_t = %s", pp->dev, pp->dev_t);
 
-	if (sysfs_get_size(devpath, &pp->size))
+	if (sysfs_get_size(pp, &pp->size))
 		return 1;
 
 	condlog(3, "%s: size = %llu", pp->dev, pp->size);
@@ -682,45 +736,28 @@ common_sysfs_pathinfo (struct path * pp, const char * devpath)
 	return 0;
 }
 
-struct sysfs_device *sysfs_device_from_path(struct path *pp)
-{
-	char sysdev[FILE_NAME_SIZE];
-
-	if (pp->sysdev && sysfs_device_verify(pp->sysdev))
-		return pp->sysdev;
-
-	strlcpy(sysdev,"/block/", FILE_NAME_SIZE);
-	strlcat(sysdev,pp->dev, FILE_NAME_SIZE);
-
-	return sysfs_device_get(sysdev);
-}
-
 int
 path_offline (struct path * pp)
 {
-	struct sysfs_device * parent;
+	struct udev_device * parent;
 	char buff[SCSI_STATE_SIZE];
 
 	if (pp->bus != SYSFS_BUS_SCSI)
 		return PATH_UP;
 
-	pp->sysdev = sysfs_device_from_path(pp);
-	if (!pp->sysdev) {
-		condlog(1, "%s: failed to get sysfs information", pp->dev);
-		return PATH_WILD;
+	parent = pp->udev;
+	while (parent) {
+		if (!strncmp(udev_device_get_subsystem(parent), "scsi", 4))
+			break;
+		parent = udev_device_get_parent(parent);
 	}
 
-	parent = sysfs_device_get_parent(pp->sysdev);
-	if (!parent)
-		parent = pp->sysdev;
-	if (parent && !strncmp(parent->kernel, "block",5))
-		parent = sysfs_device_get_parent(parent);
 	if (!parent) {
-		condlog(1, "%s: failed to get parent", pp->dev);
+		condlog(1, "%s: failed to get sysfs information", pp->dev);
 		return PATH_WILD;
 	}
 
-	if (sysfs_get_state(parent->devpath, buff, SCSI_STATE_SIZE))
+	if (sysfs_get_state(parent, buff, SCSI_STATE_SIZE))
 		return PATH_WILD;
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
@@ -741,26 +778,8 @@ path_offline (struct path * pp)
 extern int
 sysfs_pathinfo(struct path * pp)
 {
-	struct sysfs_device *parent;
-
-	pp->sysdev = sysfs_device_from_path(pp);
-	if (!pp->sysdev) {
-		condlog(1, "%s: failed to get sysfs information", pp->dev);
+	if (common_sysfs_pathinfo(pp))
 		return 1;
-	}
-
-	if (common_sysfs_pathinfo(pp, pp->sysdev->devpath))
-		return 1;
-
-	parent = sysfs_device_get_parent(pp->sysdev);
-	if (!parent)
-		parent = pp->sysdev;
-	if (parent && !strncmp(parent->kernel, "block",5))
-		parent = sysfs_device_get_parent(parent);
-	if (!parent) {
-		condlog(1, "%s: failed to get parent", pp->dev);
-		return 1;
-	}
 
 	pp->bus = SYSFS_BUS_UNDEF;
 	if (!strncmp(pp->dev,"cciss",5))
@@ -773,13 +792,13 @@ sysfs_pathinfo(struct path * pp)
 	if (pp->bus == SYSFS_BUS_UNDEF)
 		return 0;
 	else if (pp->bus == SYSFS_BUS_SCSI) {
-		if (scsi_sysfs_pathinfo(pp, parent->devpath))
+		if (scsi_sysfs_pathinfo(pp))
 			return 1;
 	} else if (pp->bus == SYSFS_BUS_CCW) {
-		if (ccw_sysfs_pathinfo(pp, parent->devpath))
+		if (ccw_sysfs_pathinfo(pp))
 			return 1;
 	} else if (pp->bus == SYSFS_BUS_CCISS) {
-		if (cciss_sysfs_pathinfo(pp, pp->sysdev->devpath))
+		if (cciss_sysfs_pathinfo(pp))
 			return 1;
 	}
 	return 0;
@@ -829,7 +848,7 @@ get_state (struct path * pp, int daemon)
 	condlog(3, "%s: get_state", pp->dev);
 
 	if (!checker_selected(c)) {
-		if (daemon || pp->sysdev == NULL) {
+		if (daemon) {
 			if (pathinfo(pp, conf->hwtable, DI_SYSFS) != 0) {
 				condlog(3, "%s: couldn't get sysfs pathinfo",
 					pp->dev);
@@ -850,8 +869,8 @@ get_state (struct path * pp, int daemon)
 	checker_clear_message(c);
 	if (daemon)
 		checker_set_async(c);
-	if (!conf->checker_timeout && pp->sysdev)
-		sysfs_get_timeout(pp->sysdev->devpath, &(c->timeout));
+	if (!conf->checker_timeout)
+		sysfs_get_timeout(pp, &(c->timeout));
 	state = checker_check(c);
 	condlog(3, "%s: state = %s", pp->dev, checker_state_name(state));
 	if (state == PATH_DOWN && strlen(checker_message(c)))
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index c071026..17108c7 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -26,7 +26,7 @@
 
 struct config;
 
-int sysfs_get_dev (const char * dev, char * buff, size_t len);
+int sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
 int do_tur (char *);
@@ -34,9 +34,9 @@ int path_offline (struct path *);
 int get_state (struct path * pp, int daemon);
 int pathinfo (struct path *, vector hwtable, int mask);
 struct path * store_pathinfo (vector pathvec, vector hwtable,
-			      char * devname, int flag);
+			      struct udev_device *udevice, int flag);
 int sysfs_set_scsi_tmo (struct multipath *mpp);
-int sysfs_get_timeout(const char * devpath, unsigned int *timeout);
+int sysfs_get_timeout(struct path *pp, unsigned int *timeout);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 50b0e8a..f38af86 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -335,7 +335,7 @@ out:
 		condlog(3, "%s: checker timeout = %u ms (config file default)",
 				pp->dev, c->timeout);
 	}
-	else if (pp->sysdev && sysfs_get_timeout(pp->sysdev->devpath, &c->timeout) == 0)
+	else if (pp->udev && sysfs_get_timeout(pp, &c->timeout) == 0)
 		condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
 				pp->dev, c->timeout);
 	else {
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 280d2eb..3c0fe90 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <libdevmapper.h>
+#include <libudev.h>
 
 #include "checkers.h"
 #include "memory.h"
@@ -47,6 +48,11 @@ free_path (struct path * pp)
 	if (pp->fd >= 0)
 		close(pp->fd);
 
+	if (pp->udev) {
+		udev_device_unref(pp->udev);
+		pp->udev = NULL;
+	}
+
 	FREE(pp);
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 010be5d..16aa0ff 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -115,12 +115,6 @@ struct scsi_dev {
 	int host_no;
 };
 
-struct sysfs_device {
-	struct sysfs_device *parent;		/* parent device */
-	char devpath[PATH_SIZE];
-	char kernel[NAME_SIZE];			/* device instance name */
-};
-
 # ifndef HDIO_GETGEO
 #  define HDIO_GETGEO	0x0301	/* get device geometry */
 
@@ -134,7 +128,7 @@ struct hd_geometry {
 struct path {
 	char dev[FILE_NAME_SIZE];
 	char dev_t[BLK_DEV_SIZE];
-	struct sysfs_device *sysdev;
+	struct udev_device *udev;
 	struct scsi_idlun scsi_id;
 	struct sg_id sg_id;
 	struct hd_geometry geom;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index bbbe888..b7dd7c4 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -445,16 +445,14 @@ verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec)
 		/*
 		 * see if path is in sysfs
 		 */
-		if (!pp->sysdev || sysfs_get_dev(pp->sysdev->devpath,
-						 pp->dev_t, BLK_DEV_SIZE)) {
+		if (!pp->udev || sysfs_get_dev(pp->udev, pp->dev_t,
+					       BLK_DEV_SIZE)) {
 			if (pp->state != PATH_DOWN) {
 				condlog(1, "%s: removing valid path %s in state %d",
-					mpp->alias,
-					pp->sysdev?pp->sysdev->devpath:pp->dev_t, pp->state);
+					mpp->alias, pp->dev, pp->state);
 			} else {
 				condlog(3, "%s: failed to access path %s",
-					mpp->alias,
-					pp->sysdev ? pp->sysdev->devpath : pp->dev_t);
+					mpp->alias, pp->dev);
 			}
 			count++;
 			vector_del_slot(mpp->paths, i);
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 13af8a1..5cd365a 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -39,14 +39,6 @@
 
 char sysfs_path[PATH_SIZE];
 
-/* list of sysfs devices */
-static LIST_HEAD(sysfs_dev_list);
-struct sysfs_dev {
-	struct list_head node;
-	struct sysfs_device dev;
-	int refcount;
-};
-
 int sysfs_init(char *path, size_t len)
 {
 	if (path) {
@@ -56,43 +48,9 @@ int sysfs_init(char *path, size_t len)
 		strlcpy(sysfs_path, "/sys", sizeof(sysfs_path));
 	dbg("sysfs_path='%s'", sysfs_path);
 
-	INIT_LIST_HEAD(&sysfs_dev_list);
 	return 0;
 }
 
-void sysfs_cleanup(void)
-{
-	struct sysfs_dev *sysdev_loop;
-	struct sysfs_dev *sysdev_temp;
-
-	list_for_each_entry_safe(sysdev_loop, sysdev_temp, &sysfs_dev_list, node) {
-		list_del(&sysdev_loop->node);
-		free(sysdev_loop);
-	}
-}
-
-void sysfs_device_set_values(struct sysfs_device *dev, const char *devpath)
-{
-	char *pos;
-
-	strlcpy(dev->devpath, devpath, sizeof(dev->devpath));
-
-	/* set kernel name */
-	pos = strrchr(dev->devpath, '/');
-	if (pos == NULL)
-		return;
-	strlcpy(dev->kernel, &pos[1], sizeof(dev->kernel));
-	dbg("kernel='%s'", dev->kernel);
-
-	/* some devices have '!' in their name, change that to '/' */
-	pos = dev->kernel;
-	while (pos[0] != '\0') {
-		if (pos[0] == '!')
-			pos[0] = '/';
-		pos++;
-	}
-}
-
 int sysfs_resolve_link(char *devpath, size_t size)
 {
 	char link_path[PATH_SIZE];
@@ -125,164 +83,6 @@ int sysfs_resolve_link(char *devpath, size_t size)
 	return 0;
 }
 
-/*
- * Caution: this routine is called extremely often.
- * Should be as efficient as possible.
- */
-struct sysfs_device *sysfs_device_get(const char *devpath)
-{
-	char path[PATH_SIZE];
-	char devpath_real[PATH_SIZE];
-	struct sysfs_device *dev = NULL;
-	struct sysfs_dev *sysdev_loop, *sysdev;
-	struct stat statbuf;
-
-	dbg("open '%s'", devpath);
-	strlcpy(devpath_real, devpath, sizeof(devpath_real));
-	remove_trailing_chars(devpath_real, '/');
-	if (devpath[0] == '\0' )
-		return NULL;
-
-	/* if we got a link, resolve it to the real device */
-	strlcpy(path, sysfs_path, sizeof(path));
-	strlcat(path, devpath_real, sizeof(path));
-	if (lstat(path, &statbuf) != 0) {
-		/* if stat fails look in the cache */
-		dbg("stat '%s' failed: %s", path, strerror(errno));
-		list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
-			if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
-				dbg("found vanished dev in cache '%s'",
-				    sysdev_loop->dev.devpath);
-				sysdev_loop->refcount++;
-				return &sysdev_loop->dev;
-			}
-		}
-		return NULL;
-	}
-
-	if (S_ISLNK(statbuf.st_mode)) {
-		if (sysfs_resolve_link(devpath_real, sizeof(devpath_real)) != 0)
-			return NULL;
-	}
-
-	list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
-		if (strcmp(sysdev_loop->dev.devpath, devpath_real) == 0) {
-			dbg("found dev in cache '%s'", sysdev_loop->dev.devpath);
-			dev = &sysdev_loop->dev;
-			sysdev_loop->refcount++;
-		}
-	}
-
-	if(!dev) {
-		/* it is a new device */
-		dbg("new device '%s'", devpath_real);
-		sysdev = malloc(sizeof(struct sysfs_dev));
-		if (sysdev == NULL)
-			return NULL;
-		memset(sysdev, 0x00, sizeof(struct sysfs_dev));
-		sysdev->refcount = 1;
-		list_add(&sysdev->node, &sysfs_dev_list);
-		dev = &sysdev->dev;
-	}
-
-	sysfs_device_set_values(dev, devpath_real);
-
-	return dev;
-}
-
-struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev)
-{
-	char parent_devpath[PATH_SIZE];
-	char *pos;
-
-	dbg("open '%s'", dev->devpath);
-
-	/* look if we already know the parent */
-	if (dev->parent != NULL)
-		return dev->parent;
-
-	strlcpy(parent_devpath, dev->devpath, sizeof(parent_devpath));
-	dbg("'%s'", parent_devpath);
-
-	/* strip last element */
-	pos = strrchr(parent_devpath, '/');
-	if (pos == NULL || pos == parent_devpath)
-		return NULL;
-	pos[0] = '\0';
-
-	if (strncmp(parent_devpath, "/class", 6) == 0) {
-		pos = strrchr(parent_devpath, '/');
-		if (pos == &parent_devpath[6] || pos == parent_devpath) {
-			dbg("/class top level, look for device link");
-			goto device_link;
-		}
-	}
-	if (strcmp(parent_devpath, "/block") == 0) {
-		dbg("/block top level, look for device link");
-		goto device_link;
-	}
-
-	/* are we at the top level? */
-	pos = strrchr(parent_devpath, '/');
-	if (pos == NULL || pos == parent_devpath)
-		return NULL;
-
-	/* get parent and remember it */
-	dev->parent = sysfs_device_get(parent_devpath);
-	return dev->parent;
-
-device_link:
-	strlcpy(parent_devpath, dev->devpath, sizeof(parent_devpath));
-	strlcat(parent_devpath, "/device", sizeof(parent_devpath));
-	if (sysfs_resolve_link(parent_devpath, sizeof(parent_devpath)) != 0)
-		return NULL;
-
-	/* get parent and remember it */
-	dev->parent = sysfs_device_get(parent_devpath);
-	return dev->parent;
-}
-
-struct sysfs_device *sysfs_device_verify(struct sysfs_device *dev)
-{
-	char path[PATH_SIZE];
-	struct stat statbuf;
-
-	if (!dev->devpath)
-		return NULL;
-	strlcpy(path, sysfs_path, sizeof(path));
-	strlcat(path, dev->devpath, sizeof(path));
-	if (stat(dev->devpath, &statbuf) == 0 &&
-	    S_ISDIR(statbuf.st_mode))
-		return dev;
-
-	return NULL;
-}
-
-void sysfs_device_put(struct sysfs_device *dev)
-{
-	struct sysfs_dev *sysdev_loop;
-
-	list_for_each_entry(sysdev_loop, &sysfs_dev_list, node) {
-		if (&sysdev_loop->dev == dev) {
-			sysdev_loop->refcount--;
-			if (!sysdev_loop->refcount) {
-				dbg("removed dev '%s' from cache",
-				    sysdev_loop->dev.devpath);
-				list_del(&sysdev_loop->node);
-				free(sysdev_loop);
-			} else {
-				dbg("dev '%s' still in cache, refcount %d",
-				    sysdev_loop->dev.devpath,
-				    sysdev_loop->refcount);
-			}
-			return;
-		}
-	}
-	dbg("dev '%s' not found in cache", dev->devpath);
-
-	return;
-}
-
 size_t sysfs_attr_get_value(const char *devpath, const char *attr_name,
 			    char *attr_value, int attr_len)
 {
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 22a4c5b..b5a3f21 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -13,7 +13,6 @@
 
 int sysfs_init(char *path, size_t len);
 void sysfs_cleanup(void);
-void sysfs_device_set_values(struct sysfs_device *dev, const char *devpath);
 struct sysfs_device *sysfs_device_get(const char *devpath);
 struct sysfs_device *sysfs_device_get_parent(struct sysfs_device *dev);
 void sysfs_device_put(struct sysfs_device *dev);
@@ -23,6 +22,6 @@ size_t sysfs_attr_get_value(const char *devpath, const char *attr_name,
 ssize_t sysfs_attr_set_value(const char *devpath, const char *attr_name,
 			     const char *value, int value_len);
 int sysfs_resolve_link(char *path, size_t size);
-int sysfs_get_size(const char * devpath, unsigned long long * size);
+int sysfs_get_size(struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 #endif
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 4e31d4f..a29a43c 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -117,6 +117,8 @@ service_uevq(struct list_head *tmpq)
 		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
 			condlog(0, "uevent trigger error");
 
+		if (uev->udev)
+			udev_device_unref(uev->udev);
 		FREE(uev);
 	}
 }
@@ -472,7 +474,7 @@ int uevent_listen(void)
 			if (i == HOTPLUG_NUM_ENVP - 1)
 				break;
 		}
-		udev_device_unref(dev);
+		uev->udev = dev;
 		uev->envp[i] = NULL;
 
 		condlog(3, "uevent '%s' from '%s'", uev->action, uev->devpath);
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 46596fd..64f00b7 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -15,6 +15,7 @@
 
 struct uevent {
 	struct list_head node;
+	struct udev_device *udev;
 	char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];
 	char *devpath;
 	char *action;
diff --git a/libmultipath/util.c b/libmultipath/util.c
index f6ee09c..70735e6 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -234,3 +234,13 @@ skip_proc:
 	basenamecpy((const char *)block_path, devname, devname_len);
 	return 0;
 }
+
+dev_t parse_devt(const char *dev_t)
+{
+	int maj, min;
+
+	if (sscanf(dev_t,"%d:%d", &maj, &min) != 2)
+		return 0;
+
+	return makedev(maj, min);
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index cb4ce1b..44184a1 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -9,6 +9,7 @@ size_t strlcpy(char *dst, const char *src, size_t size);
 size_t strlcat(char *dst, const char *src, size_t size);
 void remove_trailing_chars(char *path, char c);
 int devt2devname (char *, int, char *);
+dev_t parse_devt(const char *dev_t);
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
diff --git a/multipath/main.c b/multipath/main.c
index 2078fe3..9be52b5 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -539,7 +539,6 @@ main (int argc, char *argv[])
 out:
 	udev_wait(conf->cookie);
 
-	sysfs_cleanup();
 	dm_lib_release();
 	dm_lib_exit();
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 1d4ea14..9553251 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -6,7 +6,7 @@ include ../Makefile.inc
 # basic flags setting
 #
 CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
-LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -ldl \
+LDFLAGS += -lpthread -ldevmapper -lreadline -lncurses -ludev -ldl \
 	   -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist
 
 #
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 5cf5f4b..39b89bf 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -16,6 +16,8 @@
 #include <print.h>
 #include <sysfs.h>
 #include <errno.h>
+#include <libudev.h>
+#include <util.h>
 
 #include "main.h"
 #include "cli.h"
@@ -426,10 +428,15 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		if (pp->mpp)
 			return 0;
 	} else {
+		struct udev_device *udevice;
+
+		udevice = udev_device_new_from_devnum(conf->udev, 'b',
+						      parse_devt(pp->dev_t));
 		pp = store_pathinfo(vecs->pathvec, conf->hwtable,
-				    param, DI_ALL);
+				    udevice, DI_ALL);
 		if (!pp) {
 			condlog(0, "%s: failed to store path info", param);
+			udev_device_unref(udevice);
 			return 1;
 		}
 	}
@@ -596,7 +603,7 @@ cli_resize(void *v, char **reply, int *len, void *data)
 
 	pgp = VECTOR_SLOT(mpp->pg, 0);
 	pp = VECTOR_SLOT(pgp->paths, 0);
-	if (!pp->sysdev || sysfs_get_size(pp->sysdev->devpath, &size)) {
+	if (!pp->udev || sysfs_get_size(pp, &size)) {
 		condlog(0, "%s: couldn't get size for sysfs. cannot resize",
 			mapname);
 		return 1;
diff --git a/multipathd/main.c b/multipathd/main.c
index e87375c..b54f6c6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -16,6 +16,7 @@
 #include <sys/resource.h>
 #include <limits.h>
 #include <linux/oom.h>
+#include <libudev.h>
 #include <mpath_persist.h>
 
 /*
@@ -390,13 +391,17 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		if (pp->mpp)
 			return 0;
 	} else {
+		struct udev_device *udevice;
+
 		/*
 		 * get path vital state
 		 */
+		udevice = udev_device_ref(uev->udev);
 		if (!(pp = store_pathinfo(vecs->pathvec, conf->hwtable,
-					  uev->kernel, DI_ALL))) {
+					  udevice, DI_ALL))) {
 			condlog(0, "%s: failed to store path info",
 				uev->kernel);
+			udev_device_unref(udevice);
 			return 1;
 		}
 		pp->checkint = conf->checkint;
@@ -1671,8 +1676,6 @@ child (void * param)
 	pthread_cancel(uxlsnr_thr);
 	pthread_cancel(uevq_thr);
 
-	sysfs_cleanup();
-
 	lock(vecs->lock);
 	free_pathvec(vecs->pathvec, FREE_PATHS);
 	vecs->pathvec = NULL;
-- 
1.7.3.4
