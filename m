From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: [PATCH] Change all occurences of netapp to ontap
Date: Thu, 20 Nov 2008 15:29:17 +0530
Message-ID: <1227175157-15820-2-git-send-email-rsarraf@netapp.com>
References: <1227175157-15820-1-git-send-email-rsarraf@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1227175157-15820-1-git-send-email-rsarraf@netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Ritesh Raj Sarraf <rrs@researchut.com>
List-Id: dm-devel.ids

From: Ritesh Raj Sarraf <rrs@researchut.com>

---
 libmultipath/hwtable.c             |    4 ++--
 libmultipath/prio.h                |    2 +-
 libmultipath/prioritizers/Makefile |    2 +-
 libmultipath/prioritizers/ontap.c  |   27 ++++++++++++++-------------
 libmultipath/prioritizers/ontap.h  |    8 ++++----
 5 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 75b5987..066d8da 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -648,7 +648,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.checker_name  = DIRECTIO,
-		.prio_name     = PRIO_NETAPP,
+		.prio_name     = PRIO_ONTAP,
 	},
 	/*
 	 * IBM NSeries (NETAPP) controller family
@@ -669,7 +669,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.checker_name  = DIRECTIO,
-		.prio_name     = PRIO_NETAPP,
+		.prio_name     = PRIO_ONTAP,
 	},
 	/*
 	 * Pillar Data controller family
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 491e6fc..4ee669b 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -20,7 +20,7 @@
 #define PRIO_EMC "emc"
 #define PRIO_HDS "hds"
 #define PRIO_HP_SW "hp_sw"
-#define PRIO_NETAPP "netapp"
+#define PRIO_ONTAP "ontap"
 #define PRIO_RANDOM "random"
 #define PRIO_RDAC "rdac"
 
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 1f70ef1..df42145 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -11,7 +11,7 @@ LIBS = \
 	libprioemc.so \
 	libpriordac.so \
 	libprioalua.so \
-	libprionetapp.so \
+	libprioontap.so \
 	libpriohds.so
 
 CFLAGS += -I..
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 812ecf6..cbff69f 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -1,6 +1,7 @@
 /* 
  * Copyright 2005 Network Appliance, Inc., All Rights Reserved
  * Author:  David Wysochanski available at davidw@netapp.com
+ * Maintainer: Ritesh Raj Sarraf <rsarraf@netapp.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -29,8 +30,8 @@
 #define RESULTS_MAX	256
 #define SG_TIMEOUT	30000
 
-#define pp_netapp_log(prio, fmt, args...) \
-        condlog(prio, "%s: netapp prio: " fmt, dev, ##args)
+#define pp_ontap_log(prio, fmt, args...) \
+        condlog(prio, "%s: ontap prio: " fmt, dev, ##args)
 
 static void dump_cdb(unsigned char *cdb, int size)
 {
@@ -90,12 +91,12 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 	io_hdr.timeout = SG_TIMEOUT;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
-		pp_netapp_log(0, "SG_IO ioctl failed, errno=%d", errno);
+		pp_ontap_log(0, "SG_IO ioctl failed, errno=%d", errno);
 		dump_cdb(cdb, sizeof(cdb));
 		goto out;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
-		pp_netapp_log(0, "SCSI error");
+		pp_ontap_log(0, "SCSI error");
 		dump_cdb(cdb, sizeof(cdb));
 		process_sg_error(&io_hdr);
 		goto out;
@@ -104,8 +105,8 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 	if (results[4] != 0x0a || results[5] != 0x98 ||
 	    results[6] != 0x0a ||results[7] != 0x01) {
 		dump_cdb(cdb, sizeof(cdb));
-		pp_netapp_log(0, "GVA return wrong format ");
-		pp_netapp_log(0, "results[4-7] = 0x%02x 0x%02x 0x%02x 0x%02x",
+		pp_ontap_log(0, "GVA return wrong format ");
+		pp_ontap_log(0, "results[4-7] = 0x%02x 0x%02x 0x%02x 0x%02x",
 			results[4], results[5], results[6], results[7]);
 		goto out;
 	}
@@ -142,13 +143,13 @@ static int get_proxy(const char *dev, int fd)
 	io_hdr.timeout = SG_TIMEOUT;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
-		pp_netapp_log(0, "ioctl sending inquiry command failed, "
+		pp_ontap_log(0, "ioctl sending inquiry command failed, "
 			"errno=%d", errno);
 		dump_cdb(cdb, sizeof(cdb));
 		goto out;
 	}
 	if (io_hdr.info & SG_INFO_OK_MASK) {
-		pp_netapp_log(0, "SCSI error");
+		pp_ontap_log(0, "SCSI error");
 		dump_cdb(cdb, sizeof(cdb));
 		process_sg_error(&io_hdr);
 		goto out;
@@ -158,8 +159,8 @@ static int get_proxy(const char *dev, int fd)
 	    results[9] != 0x98 || results[10] != 0x0a ||
 	    results[11] != 0x0 || results[12] != 0xc1 ||
 	    results[13] != 0x0) {
-		pp_netapp_log(0,"proxy info page in unknown format - ");
-		pp_netapp_log(0,"results[8-13]=0x%02x 0x%02x 0x%02x 0x%02x "
+		pp_ontap_log(0,"proxy info page in unknown format - ");
+		pp_ontap_log(0,"results[8-13]=0x%02x 0x%02x 0x%02x 0x%02x "
 			"0x%02x 0x%02x",
 			results[8], results[9], results[10],
 			results[11], results[12], results[13]);
@@ -180,7 +181,7 @@ static int get_proxy(const char *dev, int fd)
  * 2: iSCSI software
  * 1: FCP proxy
  */
-static int netapp_prio(const char *dev, int fd)
+static int ontap_prio(const char *dev, int fd)
 {
 	unsigned char results[RESULTS_MAX];
 	int results_size=RESULTS_MAX;
@@ -201,7 +202,7 @@ static int netapp_prio(const char *dev, int fd)
 			goto try_fcp_proxy;
 		}
 		if (results[8] != 0x41) {
-			pp_netapp_log(0, "GVA page 0x41 error - "
+			pp_ontap_log(0, "GVA page 0x41 error - "
 				"results[8] = 0x%x", results[8]);
 			goto try_fcp_proxy;
 		}
@@ -239,5 +240,5 @@ static int netapp_prio(const char *dev, int fd)
 
 int getprio (struct path * pp)
 {
-	return netapp_prio(pp->dev, pp->fd);
+	return ontap_prio(pp->dev, pp->fd);
 }
diff --git a/libmultipath/prioritizers/ontap.h b/libmultipath/prioritizers/ontap.h
index ec38821..3142e7f 100644
--- a/libmultipath/prioritizers/ontap.h
+++ b/libmultipath/prioritizers/ontap.h
@@ -1,7 +1,7 @@
-#ifndef _NETAPP_H
-#define _NETAPP_H
+#ifndef _ONTAP_H
+#define _ONTAP_H
 
-#define PRIO_NETAPP "netapp"
-int prio_netapp(struct path * pp);
+#define PRIO_ONTAP "ontap"
+int prio_ontap(struct path * pp);
 
 #endif
-- 
1.5.6.5
