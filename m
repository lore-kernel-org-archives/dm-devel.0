From: David Wysochanski <davidw@netapp.com>
Subject: [PATCH] Update pp_netapp callout - increase ioctl
	timeout and return 0 when ioctls fail
Date: Thu, 03 Aug 2006 14:00:21 -0400
Message-ID: <1154628021.1474.6.camel@davidw-sles10.rtp.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: device-mapper development <dm-devel@redhat.com>
Cc: clairek@netapp.com, marting@netapp.com, "Nair, Vinod K" <nvinod@netapp.com>, shenoy@netapp.com
List-Id: dm-devel.ids

This patch against the latest git tree fixes a couple minor
bugs in the Netapp priority callout:
- increase the ioctl timeout from 30 to 60 
- return 0 for priority value when ioctls fail


Signed-off-by: Dave Wysochanski <davidw@netapp.com>
Signed-off-by: Claire Kraft <ckraft@netapp.com>

--- multipath-tools-git/path_priority/pp_netapp/pp_netapp.c	2005-12-02 17:40:39.000000000 -0500
+++ multipath-tools-patch/path_priority/pp_netapp/pp_netapp.c	2006-08-03 13:51:39.177207000 -0400
@@ -29,7 +29,7 @@
 #define INQUIRY_CMDLEN	6
 #define DEFAULT_PRIO	10
 #define RESULTS_MAX	256
-#define SG_TIMEOUT	30000
+#define SG_TIMEOUT	60000
 
 
 static void dump_cdb(unsigned char *cdb, int size)
@@ -209,7 +209,7 @@ static int netapp_prio(const char *dev)
 
 	memset(&results, 0, sizeof (results));
 	rc = send_gva(dev, 0x41, results, &results_size);
-	if (rc == 0) {
+	if (rc >= 0) {
 		tot_len = results[0] << 24 | results[1] << 16 |
 			  results[2] << 8 | results[3];
 		if (tot_len <= 8) {
@@ -229,12 +229,16 @@ static int netapp_prio(const char *dev)
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
