From: bmarzins@sourceware.org
Subject: multipath-tools/path_priority/pp_netapp pp_net ...
Date: 9 Oct 2007 05:13:45 -0000
Message-ID: <20071009051345.17082.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-10-09 05:13:45

Modified files:
	path_priority/pp_netapp: pp_netapp.c 

Log message:
	Pulled in the bugfixes from the netapp patch in bz282131.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_netapp/pp_netapp.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.4.1

--- multipath-tools/path_priority/pp_netapp/pp_netapp.c	2005/11/21 23:28:32	1.1
+++ multipath-tools/path_priority/pp_netapp/pp_netapp.c	2007/10/09 05:13:44	1.1.4.1
@@ -29,7 +29,7 @@
 #define INQUIRY_CMDLEN	6
 #define DEFAULT_PRIO	10
 #define RESULTS_MAX	256
-#define SG_TIMEOUT	30000
+#define SG_TIMEOUT	60000
 
 
 static void dump_cdb(unsigned char *cdb, int size)
@@ -209,7 +209,7 @@
 
 	memset(&results, 0, sizeof (results));
 	rc = send_gva(dev, 0x41, results, &results_size);
-	if (rc == 0) {
+	if (rc >= 0) {
 		tot_len = results[0] << 24 | results[1] << 16 |
 			  results[2] << 8 | results[3];
 		if (tot_len <= 8) {
@@ -229,12 +229,16 @@
 			is_iscsi_hardware = 1;
 			goto prio_select;
 		}
+	} else {
+		return 0;
 	}
 	
  try_fcp_proxy:	
 	rc = get_proxy(dev);
 	if (rc >= 0) {
 		is_proxy = rc;
+	} else {
+		return 0;
 	}
 
  prio_select:
