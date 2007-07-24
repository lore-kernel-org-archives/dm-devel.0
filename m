From: bmarzins@sourceware.org
Subject: multipath-tools ./Makefile libcheckers/Makefil ...
Date: 24 Jul 2007 20:35:26 -0000
Message-ID: <20070724203526.1600.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2007-07-24 20:35:24

Modified files:
	.              : Makefile 
	libcheckers    : Makefile checkers.h selector.c 
	libmultipath   : discovery.c structs.h util.c util.h 
	multipath      : main.c 
Added files:
	cciss_id       : Makefile cciss_id.c cciss_ioctl.h 
	libcheckers    : cciss_tur.c 

Log message:
	Fix for bz #242097. Added cciss support.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.6.2.1&r2=1.6.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/cciss_id/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/cciss_id/cciss_id.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/cciss_id/cciss_ioctl.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/cciss_tur.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=NONE&r2=1.1.4.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/Makefile.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/checkers.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.3&r2=1.3.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libcheckers/selector.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.3&r2=1.28.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.4&r2=1.17.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/util.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/util.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.3&r2=1.3.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.41.2.4&r2=1.41.2.5

--- multipath-tools/Makefile	2007/07/23 21:37:10	1.6.2.1
+++ multipath-tools/Makefile	2007/07/24 20:35:24	1.6.2.2
@@ -23,13 +23,13 @@
 BUILDDIRS = libmultipath libcheckers path_priority/pp_emc \
 	    path_priority/pp_alua path_priority/pp_netapp \
 	    path_priority/pp_hds_modular path_priority/pp_tpc \
-	    multipath multipathd kpartx
+	    multipath multipathd kpartx cciss_id
 ALLDIRS	= $(shell find . -type d -maxdepth 1 -mindepth 1)
 
 VERSION = $(shell basename ${PWD} | cut -d'-' -f3)
 INSTALLDIRS = multipath multipathd kpartx path_priority/pp_emc \
 	     path_priority/pp_alua path_priority/pp_netapp \
-	     path_priority/pp_hds_modular path_priority/pp_tpc
+	     path_priority/pp_hds_modular path_priority/pp_tpc cciss_id
 
 
 all: recurse
--- multipath-tools/libcheckers/Makefile	2005/10/12 21:57:26	1.4
+++ multipath-tools/libcheckers/Makefile	2007/07/24 20:35:24	1.4.2.1
@@ -6,7 +6,7 @@
 
 include ../Makefile.inc
 
-OBJS = readsector0.o tur.o selector.o directio.o emc_clariion.o hp_sw.o
+OBJS = readsector0.o tur.o selector.o directio.o emc_clariion.o hp_sw.o cciss_tur.o
 
 all: $(BUILD)
 
--- multipath-tools/libcheckers/checkers.h	2005/10/12 21:57:26	1.3
+++ multipath-tools/libcheckers/checkers.h	2007/07/24 20:35:24	1.3.2.1
@@ -11,7 +11,8 @@
 	READSECTOR0,
 	DIRECTIO,
 	EMC_CLARIION,
-	HP_SW
+	HP_SW,
+	CCISS_TUR
 };
 
 #define MSG(a) if (msg != NULL) \
@@ -26,5 +27,6 @@
 int readsector0 (int fd, char * msg, void ** ctxt);
 int tur (int fd, char * msg, void ** ctxt);
 int hp_sw (int fd, char * msg, void ** ctxt);
+int cciss_tur (int fd, char * msg, void ** ctxt);
 
 #endif /* _CHECKERS_H */
--- multipath-tools/libcheckers/Attic/selector.c	2005/11/16 20:24:57	1.4
+++ multipath-tools/libcheckers/Attic/selector.c	2007/07/24 20:35:24	1.4.2.1
@@ -19,6 +19,8 @@
 		return EMC_CLARIION;
  	if (0 == strncmp(str, "hp_sw", 5))
 		return HP_SW;
+ 	if (0 == strncmp(str, "cciss_tur", 9))
+		return CCISS_TUR;
 	return -1;
 }
 
@@ -43,6 +45,9 @@
 	case HP_SW:
 		checker = &hp_sw;
 		break;
+	case CCISS_TUR:
+		checker = &cciss_tur;
+		break;
 	default:
 		checker = NULL;
 		break;
@@ -71,6 +76,9 @@
 	case HP_SW:
 		s = "hp_sw";
 		break;
+	case CCISS_TUR:
+		s = "cciss_tur";
+		break;
 	default:
 		s = "undefined";
 		break;
--- multipath-tools/libmultipath/discovery.c	2006/10/06 18:09:14	1.28.2.3
+++ multipath-tools/libmultipath/discovery.c	2007/07/24 20:35:24	1.28.2.4
@@ -237,6 +237,7 @@
 declare_sysfs_get_str(model, "%s/block/%s/device/model");
 declare_sysfs_get_str(rev, "%s/block/%s/device/rev");
 declare_sysfs_get_str(dev, "%s/block/%s/dev");
+declare_sysfs_get_str(bustype, "%s/block/%s/device/bus");
 
 int
 sysfs_get_size (char * sysfs_path, char * dev, unsigned long long * size)
@@ -266,7 +267,15 @@
 opennode (char * dev, int mode)
 {
 	char devpath[FILE_NAME_SIZE];
-
+	if(!strncmp(dev,"cciss",5)) { 
+		char ccissdev[FILE_NAME_SIZE];
+		cciss_basename(dev,ccissdev);	
+	        if (safe_sprintf(devpath, "%s/cciss/%s", conf->udev_dir, ccissdev)) {
+        	        condlog(0, "devpath too small");
+                	return -1;
+		}
+	}
+	else
 	if (safe_sprintf(devpath, "%s/%s", conf->udev_dir, dev)) {
 		condlog(0, "devpath too small");
 		return -1;
@@ -435,6 +444,9 @@
 
 	while (loop--) {
 		sdev = sysfs_open_device_path(attr_buff);
+		if(!strncmp(curpath->dev, "cciss", 5))
+			sysfs_get_bustype(sysfs_path, curpath->dev, sdev->bus,
+					  5);
 
 		if (strlen(sdev->bus))
 			break;
@@ -444,6 +456,9 @@
 	}
 #else
 	sdev = sysfs_open_device_path(attr_buff);
+
+	if(!strncmp(curpath->dev, "cciss", 5))
+		sysfs_get_bustype(sysfs_path, curpath->dev, sdev->bus, 5);
 #endif
 
 	if (!strncmp(sdev->bus, "scsi", 4))
@@ -452,6 +467,8 @@
 		curpath->bus = SYSFS_BUS_IDE;
 	else if (!strncmp(sdev->bus, "ccw", 3))
 		curpath->bus = SYSFS_BUS_CCW;
+	else if (!strncmp(sdev->bus, "cciss", 5))
+		curpath->bus = SYSFS_BUS_CCISS;
 	else
 		return 1;
 
@@ -459,6 +476,31 @@
 
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
+
+        return 0;
+}
+
 
 static int
 scsi_sysfs_pathinfo (struct path * curpath)
@@ -617,6 +659,9 @@
 	} else if (curpath->bus == SYSFS_BUS_CCW) {
 		if (ccw_sysfs_pathinfo(curpath))
 			return 1;
+	} else if (curpath->bus == SYSFS_BUS_CCISS){
+		if (cciss_sysfs_pathinfo(curpath))
+			return 1;
 	}
 	return 0;
 }
--- multipath-tools/libmultipath/structs.h	2007/03/07 19:01:17	1.17.2.4
+++ multipath-tools/libmultipath/structs.h	2007/07/24 20:35:24	1.17.2.5
@@ -40,6 +40,7 @@
 	SYSFS_BUS_SCSI,
 	SYSFS_BUS_IDE,
 	SYSFS_BUS_CCW,
+	SYSFS_BUS_CCISS
 };
 
 enum pathstates {
--- multipath-tools/libmultipath/util.c	2005/10/12 21:57:26	1.4
+++ multipath-tools/libmultipath/util.c	2007/07/24 20:35:24	1.4.2.1
@@ -43,6 +43,17 @@
 	strcpy(str2, p);
 }
 
+void cciss_basename (char * str1, char * str2)
+{
+char *p = str1 + (strlen(str1) );
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
--- multipath-tools/libmultipath/util.h	2005/07/13 01:16:19	1.3
+++ multipath-tools/libmultipath/util.h	2007/07/24 20:35:24	1.3.2.1
@@ -5,7 +5,7 @@
 void basename (char * src, char * dst);
 int filepresent (char * run);
 int get_word (char * sentence, char ** word);
-
+void cciss_basename (char * , char * );
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
--- multipath-tools/multipath/main.c	2006/12/01 23:45:18	1.41.2.4
+++ multipath-tools/multipath/main.c	2007/07/24 20:35:24	1.41.2.5
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.41.2.4 2006/12/01 23:45:18 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.41.2.5 2007/07/24 20:35:24 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -1064,8 +1064,8 @@
 		/* maximum info */
 		di_flag = DI_ALL;
 
-	if (path_discovery(pathvec, conf, di_flag))
-		goto out;
+	path_discovery(pathvec, conf, di_flag);
+	//	goto out;
 
 	if (conf->verbosity > 2) {
 		fprintf(stdout, "#\n# all paths :\n#\n");
