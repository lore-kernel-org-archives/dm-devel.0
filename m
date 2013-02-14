From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH for multipath-tools] Handle SCSI device states
 "quiesce" and "transport-offline" properly
Date: Thu, 14 Feb 2013 15:17:28 +0100
Message-ID: <511CF1F8.4040100@acm.org>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 libmultipath/discovery.c |    5 +++--
 libmultipath/structs.h   |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3fbc181..0b5fd1d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -797,12 +797,13 @@ path_offline (struct path * pp)
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
-	if (!strncmp(buff, "offline", 7)) {
+	if (!strncmp(buff, "offline", 7) ||
+	    !strncmp(buff, "transport-offline", 17)) {
 		pp->offline = 1;
 		return PATH_DOWN;
 	}
 	pp->offline = 0;
-	if (!strncmp(buff, "blocked", 7))
+	if (!strncmp(buff, "blocked", 7) || !strncmp(buff, "quiesce", 7))
 		return PATH_PENDING;
 	else if (!strncmp(buff, "running", 7))
 		return PATH_UP;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index ab05a78..b9ace36 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -20,7 +20,7 @@
 #define SCSI_VENDOR_SIZE	9
 #define SCSI_PRODUCT_SIZE	17
 #define SCSI_REV_SIZE		5
-#define SCSI_STATE_SIZE		9
+#define SCSI_STATE_SIZE		19
 
 #define NO_PATH_RETRY_UNDEF	0
 #define NO_PATH_RETRY_FAIL	-1
-- 
1.7.10.4
