From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/12] Use devpath as argument for sysfs functions
Date: Thu, 19 Apr 2012 11:08:55 +0200
Message-ID: <1334826546-32039-2-git-send-email-hare@suse.de>
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

Whenever we pass in a sysfs structure to functions we're only
ever interested in the devpath. So we can as well pass in the
device path directly, without reference to the sysfs structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c   |   67 +++++++++++++++++++++++---------------------
 libmultipath/discovery.h   |    4 +-
 libmultipath/propsel.c     |    2 +-
 libmultipath/structs_vec.c |    2 +-
 libmultipath/sysfs.h       |    2 +-
 libmultipath/util.c        |    6 ++--
 libmultipath/util.h        |    2 +-
 multipathd/cli_handlers.c  |    2 +-
 8 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1b67e76..426c511 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -128,19 +128,19 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 
 #define declare_sysfs_get_str(fname) \
 extern int \
-sysfs_get_##fname (struct sysfs_device * dev, char * buff, size_t len) \
+sysfs_get_##fname (const char  * devpath, char * buff, size_t len) \
 {								       \
 	int size;						       \
 								       \
-	size = sysfs_attr_get_value(dev->devpath, #fname, buff, len);	\
+	size = sysfs_attr_get_value(devpath, #fname, buff, len);	\
 	if (!size) {							\
 		condlog(3, "%s: attribute %s not found in sysfs",	\
-			dev->kernel, #fname);				\
+			devpath, #fname);				\
 		return 1;						\
 	}								\
 	if (size == len) {						\
 		condlog(3, "%s: overflow in attribute %s",		\
-			dev->kernel, #fname);				\
+			devpath, #fname);				\
 		return 2;						\
 	}								\
 	strchop(buff);							\
@@ -156,19 +156,22 @@ declare_sysfs_get_str(state);
 declare_sysfs_get_str(dev);
 
 int
-sysfs_get_timeout(struct sysfs_device *dev, unsigned int *timeout)
+sysfs_get_timeout(const char *devpath, unsigned int *timeout)
 {
 	char attr_path[SYSFS_PATH_SIZE], attr[NAME_SIZE];
 	size_t len;
 	int r;
 	unsigned int t;
 
-	if (safe_sprintf(attr_path, "%s/device", dev->devpath))
+	if (!devpath)
+		return 1;
+
+	if (safe_sprintf(attr_path, "%s/device", devpath))
 		return 1;
 
 	len = sysfs_attr_get_value(attr_path, "timeout", attr, NAME_SIZE);
 	if (!len) {
-		condlog(3, "%s: No timeout value in sysfs", dev->devpath);
+		condlog(3, "%s: No timeout value in sysfs", devpath);
 		return 1;
 	}
 
@@ -176,7 +179,7 @@ sysfs_get_timeout(struct sysfs_device *dev, unsigned int *timeout)
 
 	if (r != 1) {
 		condlog(3, "%s: Cannot parse timeout attribute '%s'",
-			dev->devpath, attr);
+			devpath, attr);
 		return 1;
 	}
 
@@ -186,15 +189,15 @@ sysfs_get_timeout(struct sysfs_device *dev, unsigned int *timeout)
 }
 
 int
-sysfs_get_size (struct sysfs_device * dev, unsigned long long * size)
+sysfs_get_size (const char * devpath, unsigned long long * size)
 {
 	char attr[NAME_SIZE];
 	size_t len;
 	int r;
 
-	len = sysfs_attr_get_value(dev->devpath, "size", attr, NAME_SIZE);
+	len = sysfs_attr_get_value(devpath, "size", attr, NAME_SIZE);
 	if (!len) {
-		condlog(3, "%s: No size attribute in sysfs", dev->devpath);
+		condlog(3, "%s: No size attribute in sysfs", devpath);
 		return 1;
 	}
 
@@ -202,7 +205,7 @@ sysfs_get_size (struct sysfs_device * dev, unsigned long long * size)
 
 	if (r != 1) {
 		condlog(3, "%s: Cannot parse size attribute '%s'",
-			dev->devpath, attr);
+			devpath, attr);
 		return 1;
 	}
 
@@ -210,7 +213,7 @@ sysfs_get_size (struct sysfs_device * dev, unsigned long long * size)
 }
 
 int
-sysfs_get_tgt_nodename (struct sysfs_device * dev, char * node,
+sysfs_get_tgt_nodename (const char * devpath, char * node,
 		       unsigned int host, unsigned int channel,
 		       unsigned int target)
 {
@@ -229,8 +232,8 @@ sysfs_get_tgt_nodename (struct sysfs_device * dev, char * node,
 	if (len)
 		return 0;
 
-	if (sscanf(dev->devpath, "/devices/platform/host%u/session%u/",
-	           &checkhost, &session) != 2)
+	if (sscanf(devpath, "/devices/platform/host%u/session%u/",
+		   &checkhost, &session) != 2)
 		return 1;
 	if (checkhost != host)
 		return 1;
@@ -544,7 +547,7 @@ get_geometry(struct path *pp)
 }
 
 static int
-scsi_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
+scsi_sysfs_pathinfo (struct path * pp, const char * parent)
 {
 	char attr_path[FILE_NAME_SIZE];
 
@@ -571,7 +574,7 @@ scsi_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
 	/*
 	 * host / bus / target / lun
 	 */
-	basenamecpy(parent->devpath, attr_path, FILE_NAME_SIZE);
+	basenamecpy(parent, attr_path, FILE_NAME_SIZE);
 
 	sscanf(attr_path, "%i:%i:%i:%i",
 			&pp->sg_id.host_no,
@@ -600,7 +603,7 @@ scsi_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
 }
 
 static int
-ccw_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
+ccw_sysfs_pathinfo (struct path * pp, const char * parent)
 {
 	char attr_path[FILE_NAME_SIZE];
 	char attr_buff[FILE_NAME_SIZE];
@@ -630,7 +633,7 @@ ccw_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
 	/*
 	 * host / bus / target / lun
 	 */
-	basenamecpy(parent->devpath, attr_path, FILE_NAME_SIZE);
+	basenamecpy(parent, attr_path, FILE_NAME_SIZE);
 	pp->sg_id.lun = 0;
 	sscanf(attr_path, "%i.%i.%x",
 			&pp->sg_id.host_no,
@@ -647,14 +650,14 @@ ccw_sysfs_pathinfo (struct path * pp, struct sysfs_device * parent)
 }
 
 static int
-cciss_sysfs_pathinfo (struct path * pp, struct sysfs_device * dev)
+cciss_sysfs_pathinfo (struct path * pp, const char * devpath)
 {
 	char attr_path[FILE_NAME_SIZE];
 
 	/*
 	 * host / bus / target / lun
 	 */
-	basenamecpy(dev->devpath, attr_path, FILE_NAME_SIZE);
+	basenamecpy(devpath, attr_path, FILE_NAME_SIZE);
 	pp->sg_id.lun = 0;
 	pp->sg_id.channel = 0;
 	sscanf(attr_path, "cciss!c%id%i",
@@ -670,12 +673,12 @@ cciss_sysfs_pathinfo (struct path * pp, struct sysfs_device * dev)
 }
 
 static int
-common_sysfs_pathinfo (struct path * pp, struct sysfs_device *dev)
+common_sysfs_pathinfo (struct path * pp, const char * devpath)
 {
 	size_t len;
 
-	len = sysfs_attr_get_value(dev->devpath, "dev",
-				    pp->dev_t, BLK_DEV_SIZE);
+	len = sysfs_attr_get_value(devpath, "dev",
+				   pp->dev_t, BLK_DEV_SIZE);
 	if (!len) {
 		condlog(3, "%s: no 'dev' attribute in sysfs", pp->dev);
 		return 1;
@@ -683,7 +686,7 @@ common_sysfs_pathinfo (struct path * pp, struct sysfs_device *dev)
 
 	condlog(3, "%s: dev_t = %s", pp->dev, pp->dev_t);
 
-	if (sysfs_get_size(dev, &pp->size))
+	if (sysfs_get_size(devpath, &pp->size))
 		return 1;
 
 	condlog(3, "%s: size = %llu", pp->dev, pp->size);
@@ -729,7 +732,7 @@ path_offline (struct path * pp)
 		return PATH_WILD;
 	}
 
-	if (sysfs_get_state(parent, buff, SCSI_STATE_SIZE))
+	if (sysfs_get_state(parent->devpath, buff, SCSI_STATE_SIZE))
 		return PATH_WILD;
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
@@ -758,7 +761,7 @@ sysfs_pathinfo(struct path * pp)
 		return 1;
 	}
 
-	if (common_sysfs_pathinfo(pp, pp->sysdev))
+	if (common_sysfs_pathinfo(pp, pp->sysdev->devpath))
 		return 1;
 
 	parent = sysfs_device_get_parent(pp->sysdev);
@@ -782,13 +785,13 @@ sysfs_pathinfo(struct path * pp)
 	if (pp->bus == SYSFS_BUS_UNDEF)
 		return 0;
 	else if (pp->bus == SYSFS_BUS_SCSI) {
-		if (scsi_sysfs_pathinfo(pp, parent))
+		if (scsi_sysfs_pathinfo(pp, parent->devpath))
 			return 1;
 	} else if (pp->bus == SYSFS_BUS_CCW) {
-		if (ccw_sysfs_pathinfo(pp, parent))
+		if (ccw_sysfs_pathinfo(pp, parent->devpath))
 			return 1;
 	} else if (pp->bus == SYSFS_BUS_CCISS) {
-		if (cciss_sysfs_pathinfo(pp, pp->sysdev))
+		if (cciss_sysfs_pathinfo(pp, pp->sysdev->devpath))
 			return 1;
 	}
 	return 0;
@@ -859,8 +862,8 @@ get_state (struct path * pp, int daemon)
 	checker_clear_message(c);
 	if (daemon)
 		checker_set_async(c);
-	if (!conf->checker_timeout)
-		sysfs_get_timeout(pp->sysdev, &(c->timeout));
+	if (!conf->checker_timeout && pp->sysdev)
+		sysfs_get_timeout(pp->sysdev->devpath, &(c->timeout));
 	state = checker_check(c);
 	condlog(3, "%s: state = %s", pp->dev, checker_state_name(state));
 	if (state == PATH_DOWN && strlen(checker_message(c)))
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 0ba33d8..1b4d437 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -24,7 +24,7 @@
 #define SCSI_COMMAND_TERMINATED 0x22
 #define SG_ERR_DRIVER_SENSE     0x08
 
-int sysfs_get_dev (struct sysfs_device * dev, char * buff, size_t len);
+int sysfs_get_dev (const char * dev, char * buff, size_t len);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
 int do_tur (char *);
@@ -34,7 +34,7 @@ int pathinfo (struct path *, vector hwtable, int mask);
 struct path * store_pathinfo (vector pathvec, vector hwtable,
 			      char * devname, int flag);
 int sysfs_set_scsi_tmo (struct multipath *mpp);
-int sysfs_get_timeout(struct sysfs_device *dev, unsigned int *timeout);
+int sysfs_get_timeout(const char * devpath, unsigned int *timeout);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 10aec29..50b0e8a 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -335,7 +335,7 @@ out:
 		condlog(3, "%s: checker timeout = %u ms (config file default)",
 				pp->dev, c->timeout);
 	}
-	else if (sysfs_get_timeout(pp->sysdev, &c->timeout) == 0)
+	else if (pp->sysdev && sysfs_get_timeout(pp->sysdev->devpath, &c->timeout) == 0)
 		condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
 				pp->dev, c->timeout);
 	else {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f4bae10..bbbe888 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -445,7 +445,7 @@ verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec)
 		/*
 		 * see if path is in sysfs
 		 */
-		if (!pp->sysdev || sysfs_get_dev(pp->sysdev,
+		if (!pp->sysdev || sysfs_get_dev(pp->sysdev->devpath,
 						 pp->dev_t, BLK_DEV_SIZE)) {
 			if (pp->state != PATH_DOWN) {
 				condlog(1, "%s: removing valid path %s in state %d",
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index a84857d..22a4c5b 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -23,6 +23,6 @@ size_t sysfs_attr_get_value(const char *devpath, const char *attr_name,
 ssize_t sysfs_attr_set_value(const char *devpath, const char *attr_name,
 			     const char *value, int value_len);
 int sysfs_resolve_link(char *path, size_t size);
-int sysfs_get_size (struct sysfs_device * dev, unsigned long long * size);
+int sysfs_get_size(const char * devpath, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
 #endif
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 62b1aa1..f6ee09c 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -20,7 +20,7 @@ strchop(char *str)
 }
 
 int
-basenamecpy (char * str1, char * str2, int str2len)
+basenamecpy (const char * str1, char * str2, int str2len)
 {
 	char *p;
 
@@ -33,7 +33,7 @@ basenamecpy (char * str1, char * str2, int str2len)
 	if (!str2)
 		return 0;
 
-	p = str1 + (strlen(str1) - 1);
+	p = (char *)str1 + (strlen(str1) - 1);
 
 	while (*--p != '/' && p != str1)
 		continue;
@@ -231,6 +231,6 @@ skip_proc:
 		condlog(0, "sysfs entry %s is not a directory\n", block_path);
 		return 1;
 	}
-	basenamecpy(block_path, devname, devname_len);
+	basenamecpy((const char *)block_path, devname, devname_len);
 	return 0;
 }
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 72de319..cb4ce1b 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -2,7 +2,7 @@
 #define _UTIL_H
 
 void strchop(char *);
-int basenamecpy (char * src, char * dst, int);
+int basenamecpy (const char * src, char * dst, int);
 int filepresent (char * run);
 int get_word (char * sentence, char ** word);
 size_t strlcpy(char *dst, const char *src, size_t size);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 9e0e2ee..4c4295d 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -571,7 +571,7 @@ cli_resize(void *v, char **reply, int *len, void *data)
 
 	pgp = VECTOR_SLOT(mpp->pg, 0);
 	pp = VECTOR_SLOT(pgp->paths, 0);
-	if (sysfs_get_size(pp->sysdev, &size)) {
+	if (!pp->sysdev || sysfs_get_size(pp->sysdev->devpath, &size)) {
 		condlog(0, "%s: couldn't get size for sysfs. cannot resize",
 			mapname);
 		return 1;
-- 
1.7.3.4
