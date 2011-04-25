From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: changes to NetApp's prioritizer
Date: Sun, 24 Apr 2011 23:02:59 -0500
Message-ID: <20110425040259.GC23657@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a patch sent to me by Martin George from NetApp. It changes the
prioriziter name from netapp to ontap, and adds some minor enchancements to
the prioritizer. I can send another patch to change the file names to match,
but that makes it harder to see the full file history in git.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c             |    4 +--
 libmultipath/prio.h                |    2 -
 libmultipath/prioritizers/Makefile |    5 +++-
 libmultipath/prioritizers/netapp.c |   44 +++++++++++++++++++------------------
 multipath.conf.defaults            |    4 +--
 multipath/multipath.conf.5         |    2 -
 6 files changed, 33 insertions(+), 28 deletions(-)

Index: multipath-tools-110412/libmultipath/hwtable.c
===================================================================
--- multipath-tools-110412.orig/libmultipath/hwtable.c
+++ multipath-tools-110412/libmultipath/hwtable.c
@@ -903,7 +903,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.checker_name  = DIRECTIO,
-		.prio_name     = PRIO_NETAPP,
+		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 	},
 	/*
@@ -947,7 +947,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 128,
 		.checker_name  = DIRECTIO,
-		.prio_name     = PRIO_NETAPP,
+		.prio_name     = PRIO_ONTAP,
 		.prio_args     = NULL,
 	},
 	/*
Index: multipath-tools-110412/libmultipath/prio.h
===================================================================
--- multipath-tools-110412.orig/libmultipath/prio.h
+++ multipath-tools-110412/libmultipath/prio.h
@@ -21,7 +21,7 @@
 #define PRIO_EMC "emc"
 #define PRIO_HDS "hds"
 #define PRIO_HP_SW "hp_sw"
-#define PRIO_NETAPP "netapp"
+#define PRIO_ONTAP "ontap"
 #define PRIO_RANDOM "random"
 #define PRIO_RDAC "rdac"
 #define PRIO_DATACORE "datacore"
Index: multipath-tools-110412/libmultipath/prioritizers/Makefile
===================================================================
--- multipath-tools-110412.orig/libmultipath/prioritizers/Makefile
+++ multipath-tools-110412/libmultipath/prioritizers/Makefile
@@ -11,7 +11,7 @@ LIBS = \
 	libprioemc.so \
 	libpriordac.so \
 	libprioalua.so \
-	libprionetapp.so \
+	libprioontap.so \
 	libpriodatacore.so \
 	libpriohds.so
 
@@ -22,6 +22,9 @@ all: $(LIBS)
 libprioalua.so: alua.o alua_rtpg.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
+libprioontap.so: netapp.o
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
+
 libprio%.so: %.o
 	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
 
Index: multipath-tools-110412/libmultipath/prioritizers/netapp.c
===================================================================
--- multipath-tools-110412.orig/libmultipath/prioritizers/netapp.c
+++ multipath-tools-110412/libmultipath/prioritizers/netapp.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Copyright 2005 Network Appliance, Inc., All Rights Reserved
  * Author:  David Wysochanski available at davidw@netapp.com
  *
@@ -7,7 +7,7 @@
  * published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of 
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  * General Public License v2 for more details.
  */
@@ -27,17 +27,17 @@
 #define INQUIRY_CMDLEN	6
 #define DEFAULT_PRIOVAL	10
 #define RESULTS_MAX	256
-#define SG_TIMEOUT	30000
+#define SG_TIMEOUT	60000
 
-#define pp_netapp_log(prio, fmt, args...) \
-        condlog(prio, "%s: netapp prio: " fmt, dev, ##args)
+#define pp_ontap_log(prio, fmt, args...) \
+        condlog(prio, "%s: ontap prio: " fmt, dev, ##args)
 
 static void dump_cdb(unsigned char *cdb, int size)
 {
 	int i;
 	char buf[10*5+1];
 	char * p = &buf[0];
-	
+
 	condlog(0, "- SCSI CDB: ");
 	for (i=0; i<size; i++) {
 		p += snprintf(p, 10*(size-i), "0x%02x ", cdb[i]);
@@ -50,7 +50,7 @@ static void process_sg_error(struct sg_i
 	int i;
 	char buf[128*5+1];
 	char * p = &buf[0];
-	
+
 	condlog(0, "- masked_status=0x%02x, host_status=0x%02x, "
 		"driver_status=0x%02x", io_hdr->masked_status,
 		io_hdr->host_status, io_hdr->driver_status);
@@ -90,12 +90,12 @@ static int send_gva(const char *dev, int
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
@@ -104,8 +104,8 @@ static int send_gva(const char *dev, int
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
@@ -142,13 +142,13 @@ static int get_proxy(const char *dev, in
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
@@ -158,8 +158,8 @@ static int get_proxy(const char *dev, in
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
@@ -180,7 +180,7 @@ static int get_proxy(const char *dev, in
  * 2: iSCSI software
  * 1: FCP proxy
  */
-static int netapp_prio(const char *dev, int fd)
+static int ontap_prio(const char *dev, int fd)
 {
 	unsigned char results[RESULTS_MAX];
 	int results_size=RESULTS_MAX;
@@ -194,14 +194,14 @@ static int netapp_prio(const char *dev, 
 
 	memset(&results, 0, sizeof (results));
 	rc = send_gva(dev, fd, 0x41, results, &results_size);
-	if (rc == 0) {
+	if (rc >= 0) {
 		tot_len = results[0] << 24 | results[1] << 16 |
 			  results[2] << 8 | results[3];
 		if (tot_len <= 8) {
 			goto try_fcp_proxy;
 		}
 		if (results[8] != 0x41) {
-			pp_netapp_log(0, "GVA page 0x41 error - "
+			pp_ontap_log(0, "GVA page 0x41 error - "
 				"results[8] = 0x%x", results[8]);
 			goto try_fcp_proxy;
 		}
@@ -214,9 +214,11 @@ static int netapp_prio(const char *dev, 
 			is_iscsi_hardware = 1;
 			goto prio_select;
 		}
+	} else {
+		return 0;
 	}
-	
- try_fcp_proxy:	
+
+ try_fcp_proxy:
 	rc = get_proxy(dev, fd);
 	if (rc >= 0) {
 		is_proxy = rc;
@@ -239,5 +241,5 @@ static int netapp_prio(const char *dev, 
 
 int getprio (struct path * pp, char * args)
 {
-	return netapp_prio(pp->dev, pp->fd);
+	return ontap_prio(pp->dev, pp->fd);
 }
Index: multipath-tools-110412/multipath.conf.defaults
===================================================================
--- multipath-tools-110412.orig/multipath.conf.defaults
+++ multipath-tools-110412/multipath.conf.defaults
@@ -503,7 +503,7 @@
 #		rr_weight		uniform
 #		rr_min_io		128
 #		path_checker		directio
-#		prio			netapp
+#		prio			ontap
 #		prio_args		""
 #	}
 #	device {
@@ -534,7 +534,7 @@
 #		rr_weight		uniform
 #		rr_min_io		128
 #		path_checker		directio
-#		prio			netapp
+#		prio			ontap
 #		prio_args		""
 #	}
 #	device {
Index: multipath-tools-110412/multipath/multipath.conf.5
===================================================================
--- multipath-tools-110412.orig/multipath/multipath.conf.5
+++ multipath-tools-110412/multipath/multipath.conf.5
@@ -150,7 +150,7 @@ Generate the path priority for EMC array
 .B mpath_prio_alua /dev/%n
 Generate the path priority based on the SCSI-3 ALUA settings.
 .TP
-.B mpath_prio_netapp /dev/%n
+.B mpath_prio_ontap /dev/%n
 Generate the path priority for NetApp arrays.
 .TP
 .B mpath_prio_rdac /dev/%n
