From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 3 Sep 2010 03:46:13 -0000
Message-ID: <20100903034613.9341.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2010-09-03 03:46:12

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : discovery.c discovery.h hwtable.c 

Log message:
	Fix for bz #484419. Now that the RHEL5 kernel exports everything necessary
	to sysfs, get all the cciss specific sysfs pathinfo correctly.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.23&r2=1.5.4.24
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.15&r2=1.32.2.16
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14.2.4&r2=1.14.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.30&r2=1.20.2.31

--- multipath-tools/multipath.conf.defaults	2010/08/24 21:51:10	1.5.4.23
+++ multipath-tools/multipath.conf.defaults	2010/09/03 03:46:11	1.5.4.24
@@ -150,6 +150,19 @@
 #		path_checker		tur
 #	}
 #       device {
+#		vendor			"HP"
+#		product			"LOGICAL VOLUME.*"
+#		getuid_callout		"/sbin/cciss_id /dev/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		1000
+#		path_checker		cciss_tur
+#	}
+#       device {
 #               vendor                  "DDN"
 #               product                 "SAN DataDirector"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
--- multipath-tools/libmultipath/discovery.c	2010/08/11 23:05:50	1.32.2.15
+++ multipath-tools/libmultipath/discovery.c	2010/09/03 03:46:12	1.32.2.16
@@ -250,8 +250,10 @@
 declare_sysfs_get_str(model, "%s/block/%s/device/model", 1);
 declare_sysfs_get_str(rev, "%s/block/%s/device/rev", 1);
 declare_sysfs_get_str(dev, "%s/block/%s/dev", 1);
-declare_sysfs_get_str(bustype, "%s/block/%s/device/bus", 1);
 declare_sysfs_get_str(state, "%s/block/%s/device/state", 0);
+declare_sysfs_get_str(cciss_vendor, "%s/block/%s/vendor", 1);
+declare_sysfs_get_str(cciss_model, "%s/block/%s/model", 1);
+declare_sysfs_get_str(cciss_rev, "%s/block/%s/rev", 1);
 
 int
 sysfs_get_timeout (char * sysfs_path, char * dev, unsigned int *timeout)
@@ -475,6 +477,24 @@
 }
 
 static int
+sysfs_get_driver (char *sysfs_path, char * dev, char *driver)
+{
+	char path[FILE_NAME_SIZE];
+	char buff[SYSFS_NAME_LEN];
+
+	if (safe_sprintf(path, "%s/block/%s/device/driver", sysfs_path, dev)) {
+		condlog(0, "driver path too small");
+		return 1;
+	}
+	if (sysfs_get_link(path, buff, SYSFS_NAME_LEN) < 0) {
+		condlog(0, "can't get driver link: %s", strerror(errno));
+		return 1;
+	}
+	basename(buff, driver);
+	return 0;
+}
+
+static int
 sysfs_get_bus (char * sysfs_path, struct path * pp)
 {
 	struct sysfs_device *sdev;
@@ -517,8 +537,8 @@
 	while (loop--) {
 		sdev = sysfs_open_device_path(attr_buff);
 		if(!strncmp(pp->dev,"cciss",5)) 
-                         sysfs_get_bustype(sysfs_path,pp->dev,
-                             sdev->bus,5);
+                         sysfs_get_driver(sysfs_path, pp->dev,
+                             sdev->bus);
 
 		if (strlen(sdev->bus))
 			break;
@@ -529,8 +549,8 @@
 #else
 	sdev = sysfs_open_device_path(attr_buff);
 	if(!strncmp(pp->dev,"cciss",5))
-                  sysfs_get_bustype(sysfs_path, pp->dev,
-                     sdev->bus,5);
+                  sysfs_get_driver(sysfs_path, pp->dev,
+                     sdev->bus);
 #endif
 
 	if (!strncmp(sdev->bus, "scsi", 4))
@@ -692,20 +712,33 @@
 static int
 cciss_sysfs_pathinfo (struct path * curpath)
 {
+	unsigned int controller, lun;
+	char dev_path[FILE_NAME_SIZE];
+
+	if (sscanf(curpath->dev, "cciss!c%ud%u", &controller, &lun) != 2) {
+		condlog(0, "invalid cciss device name : '%s'", curpath->dev);
+		return 1;
+	}
+
+	if(safe_sprintf(dev_path, "%s/device/cciss%u/c%ud%u", curpath->dev,
+			controller, controller, lun)) {
+		condlog(0, "dev_path too small");
+		return 1;
+	}
 
-        if (sysfs_get_vendor(sysfs_path, curpath->dev,
+        if (sysfs_get_cciss_vendor(sysfs_path, dev_path,
                              curpath->vendor_id, SCSI_VENDOR_SIZE))
                 return 1;
 
         condlog(3, "vendor = %s", curpath->vendor_id);
 
-        if (sysfs_get_model(sysfs_path, curpath->dev,
+        if (sysfs_get_cciss_model(sysfs_path, dev_path,
                             curpath->product_id,  SCSI_PRODUCT_SIZE))
                 return 1;
 
         condlog(3, "product = %s", curpath->product_id);
 
-        if (sysfs_get_rev(sysfs_path, curpath->dev,
+        if (sysfs_get_cciss_rev(sysfs_path, dev_path,
                           curpath->rev, SCSI_REV_SIZE))
                 return 1;
 
--- multipath-tools/libmultipath/discovery.h	2010/06/23 16:28:07	1.14.2.4
+++ multipath-tools/libmultipath/discovery.h	2010/09/03 03:46:12	1.14.2.5
@@ -30,7 +30,6 @@
 int sysfs_get_model (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_rev (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_dev (char * sysfs_path, char * dev, char * buff, int len);
-int sysfs_get_bustype (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_state (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_size (char * sysfs_path, char * dev, unsigned long long *);
 int sysfs_get_timeout (char * sysfs_path, char * dev, unsigned int *timeout);
--- multipath-tools/libmultipath/hwtable.c	2010/08/24 21:51:10	1.20.2.30
+++ multipath-tools/libmultipath/hwtable.c	2010/09/03 03:46:12	1.20.2.31
@@ -185,6 +185,22 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = READSECTOR0,
 	},
+	{
+		/* HP Smart Array */
+		.vendor        = "HP",
+		.product       = "LOGICAL VOLUME.*",
+		.getuid        = "/sbin/cciss_id /dev/%n",
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 12,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = CCISS_TUR,
+	},
 	/*
 	 * DDN controller family
 	 *
