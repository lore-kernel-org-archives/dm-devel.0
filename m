From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/13] libmultipath: return error numbers from
	sysfs_get_XXX
Date: Fri, 15 Nov 2013 11:29:35 +0100
Message-ID: <1384511384-27642-5-git-send-email-hare@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384511384-27642-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of returning hand-crafted error values from sysfs_get_XXX
functions we should be using the standard error numbers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c   | 40 +++++++++++++++++++++-------------------
 libmultipath/discovery.h   |  2 +-
 libmultipath/propsel.c     |  2 +-
 libmultipath/structs_vec.c |  3 +--
 4 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3292358..d5557d9 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -140,31 +140,34 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 }
 
 #define declare_sysfs_get_str(fname)					\
-extern int								\
+extern ssize_t								\
 sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len)	\
 {									\
+	ssize_t ret;							\
 	const char * attr;						\
 	const char * devname;						\
 									\
+	if (!udev)							\
+		return -ENOSYS;						\
+									\
 	devname = udev_device_get_sysname(udev);			\
 									\
 	attr = udev_device_get_sysattr_value(udev, #fname);		\
 	if (!attr) {							\
 		condlog(3, "%s: attribute %s not found in sysfs",	\
 			devname, #fname);				\
-		return 1;						\
+		return -ENXIO;						\
 	}								\
 	if (strlen(attr) > len) {					\
 		condlog(3, "%s: overflow in attribute %s",		\
 			devname, #fname);				\
-		return 2;						\
+		return -EINVAL;						\
 	}								\
-	strlcpy(buff, attr, len);					\
-	return 0;							\
+	ret = strlcpy(buff, attr, len);					\
+	return ret;							\
 }
 
 declare_sysfs_get_str(devtype);
-declare_sysfs_get_str(cutype);
 declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
@@ -180,7 +183,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 	unsigned int t;
 
 	if (!pp->udev || pp->bus != SYSFS_BUS_SCSI)
-		return 1;
+		return -ENOSYS;
 
 	parent = pp->udev;
 	while (parent) {
@@ -192,7 +195,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 	}
 	if (!attr) {
 		condlog(3, "%s: No timeout value in sysfs", pp->dev);
-		return 1;
+		return -ENXIO;
 	}
 
 	r = sscanf(attr, "%u\n", &t);
@@ -200,7 +203,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 	if (r != 1) {
 		condlog(3, "%s: Cannot parse timeout attribute '%s'",
 			pp->dev, attr);
-		return 1;
+		return -EINVAL;
 	}
 
 	*timeout = t;
@@ -650,17 +653,17 @@ scsi_sysfs_pathinfo (struct path * pp)
 	if (!attr_path || pp->sg_id.host_no == -1)
 		return 1;
 
-	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE))
+	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0)
 		return 1;
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
-	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE))
+	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) <= 0)
 		return 1;
 
 	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 
-	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE))
+	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) <= 0)
 		return 1;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
@@ -712,7 +715,7 @@ ccw_sysfs_pathinfo (struct path * pp)
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
-	if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE))
+	if (sysfs_get_devtype(parent, attr_buff, FILE_NAME_SIZE) <= 0)
 		return 1;
 
 	if (!strncmp(attr_buff, "3370", 4)) {
@@ -772,17 +775,17 @@ cciss_sysfs_pathinfo (struct path * pp)
 	if (!attr_path || pp->sg_id.host_no == -1)
 		return 1;
 
-	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE))
+	if (sysfs_get_vendor(parent, pp->vendor_id, SCSI_VENDOR_SIZE) <= 0)
 		return 1;
 
 	condlog(3, "%s: vendor = %s", pp->dev, pp->vendor_id);
 
-	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE))
+	if (sysfs_get_model(parent, pp->product_id, SCSI_PRODUCT_SIZE) <= 0)
 		return 1;
 
 	condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 
-	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE))
+	if (sysfs_get_rev(parent, pp->rev, SCSI_REV_SIZE) <= 0)
 		return 1;
 
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
@@ -816,7 +819,7 @@ common_sysfs_pathinfo (struct path * pp)
 		condlog(4, "%s: udev not initialised", pp->dev);
 		return 1;
 	}
-	if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE)) {
+	if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE) <= 0) {
 		condlog(3, "%s: no 'dev' attribute in sysfs", pp->dev);
 		return 1;
 	}
@@ -956,8 +959,7 @@ get_state (struct path * pp, int daemon)
 	if (daemon)
 		checker_set_async(c);
 	if (!conf->checker_timeout &&
-	    (pp->bus != SYSFS_BUS_SCSI ||
-	     sysfs_get_timeout(pp, &(c->timeout))))
+	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
 		c->timeout = DEF_TIMEOUT;
 	state = checker_check(c);
 	condlog(3, "%s: state = %s", pp->dev, checker_state_name(state));
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index d049ead..3d2d0ce 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -26,7 +26,7 @@
 
 struct config;
 
-int sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);
+ssize_t sysfs_get_dev (struct udev_device *udev, char * buff, size_t len);
 int path_discovery (vector pathvec, struct config * conf, int flag);
 
 int do_tur (char *);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index e47d0ca..f092227 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -351,7 +351,7 @@ out:
 		condlog(3, "%s: checker timeout = %u s (config file default)",
 				pp->dev, c->timeout);
 	}
-	else if (pp->udev && sysfs_get_timeout(pp, &c->timeout) == 0)
+	else if (sysfs_get_timeout(pp, &c->timeout) > 0)
 		condlog(3, "%s: checker timeout = %u ms (sysfs setting)",
 				pp->dev, c->timeout);
 	else {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 14ea1c7..abb2c56 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -451,8 +451,7 @@ verify_paths(struct multipath * mpp, struct vectors * vecs, vector rpvec)
 		/*
 		 * see if path is in sysfs
 		 */
-		if (!pp->udev || sysfs_get_dev(pp->udev, pp->dev_t,
-					       BLK_DEV_SIZE)) {
+		if (sysfs_get_dev(pp->udev, pp->dev_t, BLK_DEV_SIZE) <= 0) {
 			if (pp->state != PATH_DOWN) {
 				condlog(1, "%s: removing valid path %s in state %d",
 					mpp->alias, pp->dev, pp->state);
-- 
1.8.1.4
