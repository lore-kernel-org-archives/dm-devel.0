From: bmarzins@sourceware.org
Subject: multipath-tools ./Makefile libcheckers/Makefil ...
Date: 18 Jun 2007 17:37:20 -0000
Message-ID: <20070618173720.30636.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-06-18 17:37:18

Modified files:
	.              : Makefile 
	libcheckers    : Makefile checkers.c checkers.h 
	libmultipath   : blacklist.c discovery.c discovery.h structs.h 
	                 util.c util.h 
	multipath      : main.c 
Added files:
	cciss_id       : Makefile cciss_id.c cciss_ioctl.h 
	libcheckers    : cciss_tur.c cciss_tur.h 

Log message:
	Feature for bz #223146. Added cciss device components.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7&r2=1.7.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/cciss_id/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/cciss_id/cciss_id.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/cciss_id/cciss_ioctl.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/cciss_tur.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/cciss_tur.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=NONE&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/Makefile.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.1&r2=1.5.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/blacklist.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.1&r2=1.11.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.4&r2=1.32.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.14&r2=1.14.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18&r2=1.18.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/util.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/util.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.2&r2=1.44.2.3

--- multipath-tools/Makefile	2006/06/06 18:32:43	1.7
+++ multipath-tools/Makefile	2007/06/18 17:37:17	1.7.2.1
@@ -19,11 +19,11 @@
 endif
 export KRNLSRC
 export KRNLOBJ
-BUILDDIRS = multipath multipathd kpartx path_priority/pp_alua \
+BUILDDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	    path_priority/pp_emc path_priority/pp_hds_modular \
 	    path_priority/pp_netapp path_priority/pp_tpc
 
-ALLDIRS = multipath multipathd kpartx path_priority/pp_alua \
+ALLDIRS = multipath multipathd kpartx cciss_id path_priority/pp_alua \
 	  path_priority/pp_emc path_priority/pp_hds_modular \
 	  path_priority/pp_netapp path_priority/pp_tpc \
 	  libmultipath libcheckers
--- multipath-tools/libcheckers/Makefile	2007/04/24 18:49:16	1.5.2.1
+++ multipath-tools/libcheckers/Makefile	2007/06/18 17:37:18	1.5.2.2
@@ -6,7 +6,7 @@
 
 include ../Makefile.inc
 
-OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o rdac.o
+OBJS = checkers.o readsector0.o tur.o directio.o emc_clariion.o hp_sw.o rdac.o cciss_tur.o
 
 all: $(BUILD)
 
--- multipath-tools/libcheckers/checkers.c	2007/04/24 18:49:16	1.1.2.1
+++ multipath-tools/libcheckers/checkers.c	2007/06/18 17:37:18	1.1.2.2
@@ -9,6 +9,7 @@
 #include "emc_clariion.h"
 #include "rdac.h"
 #include "readsector0.h"
+#include "cciss_tur.h"
 
 static struct checker checkers[] = {
 	{
@@ -65,6 +66,15 @@
 		.init       = readsector0_init,
 		.free       = readsector0_free
 	},
+	{
+		.fd         = 0,
+		.name       = CCISS_TUR,
+		.message    = "",
+		.context    = NULL,
+		.check      = cciss_tur,
+		.init       = cciss_tur_init,
+		.free       = cciss_tur_free
+	},
 	{0, "", "", NULL, NULL, NULL, NULL},
 };
 
--- multipath-tools/libcheckers/checkers.h	2007/04/24 18:49:16	1.5.2.1
+++ multipath-tools/libcheckers/checkers.h	2007/06/18 17:37:18	1.5.2.2
@@ -17,6 +17,7 @@
 #define RDAC         "rdac"
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
+#define CCISS_TUR    "cciss_tur"
 
 #define DEFAULT_CHECKER READSECTOR0
 
--- multipath-tools/libmultipath/blacklist.c	2007/01/10 20:08:08	1.11.2.1
+++ multipath-tools/libmultipath/blacklist.c	2007/06/18 17:37:18	1.11.2.2
@@ -114,13 +114,13 @@
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
-	
-	str = STRDUP("^cciss!c[0-9]d[0-9]*");
+/*	
+	str = STRDUP("^cciss!c[0-9]d[0-9]*");     
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
-
+*/
 	vector_foreach_slot (conf->hwtable, hwe, i) {
 		if (hwe->bl_product) {
 			if (alloc_ble_device(conf->blist_device))
--- multipath-tools/libmultipath/discovery.c	2007/06/01 00:26:41	1.32.2.4
+++ multipath-tools/libmultipath/discovery.c	2007/06/18 17:37:18	1.32.2.5
@@ -234,6 +234,7 @@
 declare_sysfs_get_str(model, "%s/block/%s/device/model");
 declare_sysfs_get_str(rev, "%s/block/%s/device/rev");
 declare_sysfs_get_str(dev, "%s/block/%s/dev");
+declare_sysfs_get_str(bustype, "%s/block/%s/device/bus");
 
 int
 sysfs_get_size (char * sysfs_path, char * dev, unsigned long long * size)
@@ -273,6 +274,14 @@
 {
 	char devpath[FILE_NAME_SIZE];
 
+	if(!strncmp(dev,"cciss",5)) { 
+		char ccissdev[FILE_NAME_SIZE];
+		cciss_basename(dev,ccissdev);	
+	        if (safe_sprintf(devpath, "%s/cciss/%s", conf->udev_dir, ccissdev)) {
+        	        condlog(0, "devpath too small");
+                	return -1;
+		}
+	} else
 	if (safe_sprintf(devpath, "%s/%s", conf->udev_dir, dev)) {
 		condlog(0, "devpath too small");
 		return -1;
@@ -451,6 +460,9 @@
 
 	while (loop--) {
 		sdev = sysfs_open_device_path(attr_buff);
+		if(!strncmp(pp->dev,"cciss",5)) 
+                         sysfs_get_bustype(sysfs_path,pp->dev,
+                             sdev->bus,5);
 
 		if (strlen(sdev->bus))
 			break;
@@ -460,6 +472,9 @@
 	}
 #else
 	sdev = sysfs_open_device_path(attr_buff);
+	if(!strncmp(pp->dev,"cciss",5))
+                  sysfs_get_bustype(sysfs_path, pp->dev,
+                     sdev->bus,5);
 #endif
 
 	if (!strncmp(sdev->bus, "scsi", 4))
@@ -468,6 +483,8 @@
 		pp->bus = SYSFS_BUS_IDE;
 	else if (!strncmp(sdev->bus, "ccw", 3))
 		pp->bus = SYSFS_BUS_CCW;
+	else if (!strncmp(sdev->bus, "cciss", 5)) 
+		pp->bus = SYSFS_BUS_CCISS;
 	else
 		return 1;
 
@@ -616,6 +633,34 @@
 
 	return 0;
 }
+static int
+cciss_sysfs_pathinfo (struct path * curpath)
+{
+
+        if (sysfs_get_vendor(sysfs_path, curpath->dev,
+                             curpath->vendor_id, SCSI_VENDOR_SIZE))
+                return 1;
+
+        condlog(3, "vendor = %s", curpath->vendor_id);
+
+        if (sysfs_get_model(sysfs_path, curpath->dev,
+                            curpath->product_id,  SCSI_PRODUCT_SIZE))
+                return 1;
+
+        condlog(3, "product = %s", curpath->product_id);
+
+        if (sysfs_get_rev(sysfs_path, curpath->dev,
+                          curpath->rev, SCSI_REV_SIZE))
+                return 1;
+
+        condlog(3, "rev = %s", curpath->rev);
+	/*
+         * set the hwe configlet pointer
+         */
+        	curpath->hwe = find_hwe(conf->hwtable, curpath->vendor_id, curpath->product_id);
+
+        return 0;
+}
 
 static int
 common_sysfs_pathinfo (struct path * pp)
@@ -634,6 +679,9 @@
 	if (sysfs_get_size(sysfs_path, pp->dev, &pp->size))
 		return 1;
 
+	if(pp->size == 0)
+		return 1;
+	
 	condlog(3, "%s: size = %llu", pp->dev, pp->size);
 
 	return 0;
@@ -653,6 +701,9 @@
 	} else if (pp->bus == SYSFS_BUS_CCW) {
 		if (ccw_sysfs_pathinfo(pp))
 			return 1;
+	} else if (pp->bus == SYSFS_BUS_CCISS){    
+		if (cciss_sysfs_pathinfo(pp))
+			return 1;
 	}
 	return 0;
 }
--- multipath-tools/libmultipath/discovery.h	2006/10/12 16:16:09	1.14
+++ multipath-tools/libmultipath/discovery.h	2007/06/18 17:37:18	1.14.2.1
@@ -29,6 +29,7 @@
 int sysfs_get_model (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_rev (char * sysfs_path, char * dev, char * buff, int len);
 int sysfs_get_dev (char * sysfs_path, char * dev, char * buff, int len);
+int sysfs_get_bustype (char * sysfs_path, char * dev, char * buff, int len);
 
 int sysfs_get_size (char * sysfs_path, char * dev, unsigned long long *);
 int path_discovery (vector pathvec, struct config * conf, int flag);
--- multipath-tools/libmultipath/structs.h	2006/06/06 18:32:43	1.18
+++ multipath-tools/libmultipath/structs.h	2007/06/18 17:37:18	1.18.2.1
@@ -40,6 +40,7 @@
 	SYSFS_BUS_SCSI,
 	SYSFS_BUS_IDE,
 	SYSFS_BUS_CCW,
+	SYSFS_BUS_CCISS
 };
 
 enum pathstates {
--- multipath-tools/libmultipath/util.c	2006/06/06 18:32:43	1.5
+++ multipath-tools/libmultipath/util.c	2007/06/18 17:37:18	1.5.2.1
@@ -52,6 +52,18 @@
 	strcpy(str2, p);
 }
 
+void 
+cciss_basename (char * str1, char * str2)
+{
+	char *p = str1 + (strlen(str1) );
+
+        while (*--p != '!' && p != str1)
+                continue;
+        if (p != str1)
+                p++;
+        strcpy(str2, p);
+}
+
 int
 filepresent (char * run) {
 	struct stat buf;
--- multipath-tools/libmultipath/util.h	2006/06/06 18:32:43	1.4
+++ multipath-tools/libmultipath/util.h	2007/06/18 17:37:18	1.4.2.1
@@ -6,7 +6,7 @@
 void basename (char * src, char * dst);
 int filepresent (char * run);
 int get_word (char * sentence, char ** word);
-
+void cciss_basename (char * , char * );
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
--- multipath-tools/multipath/main.c	2007/06/15 19:03:02	1.44.2.2
+++ multipath-tools/multipath/main.c	2007/06/18 17:37:18	1.44.2.3
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.2 2007/06/15 19:03:02 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.3 2007/06/18 17:37:18 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -268,8 +268,7 @@
 		/* maximum info */
 		di_flag = DI_ALL;
 
-	if (path_discovery(pathvec, conf, di_flag))
-		goto out;
+	path_discovery(pathvec, conf, di_flag);
 
 	if (conf->verbosity > 2)
 		print_all_paths(pathvec, 1);
