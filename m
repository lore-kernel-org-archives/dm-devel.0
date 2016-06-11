From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: replace spaces with tabs in
	defaults.h
Date: Sun, 12 Jun 2016 00:14:40 +0200
Message-ID: <1465683281-21755-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

replace spaces by tabs in defaults.h

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 96f5a2c..dc70a74 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -7,22 +7,22 @@
 #define DEFAULT_HWHANDLER	"0"
 #define DEFAULT_MINIO		1000
 #define DEFAULT_MINIO_RQ	1
-#define DEFAULT_PGPOLICY       FAILOVER
-#define DEFAULT_FAILBACK       -FAILBACK_MANUAL
-#define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
-#define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
+#define DEFAULT_PGPOLICY	FAILOVER
+#define DEFAULT_FAILBACK	-FAILBACK_MANUAL
+#define DEFAULT_RR_WEIGHT	RR_WEIGHT_NONE
+#define DEFAULT_NO_PATH_RETRY	NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	0
 #define DEFAULT_FIND_MULTIPATHS	0
 #define DEFAULT_FAST_IO_FAIL	5
-#define DEFAULT_DEV_LOSS_TMO   600
+#define DEFAULT_DEV_LOSS_TMO	600
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
-#define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
-#define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
-#define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF
+#define DEFAULT_DETECT_PRIO	DETECT_PRIO_OFF
+#define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
+#define DEFAULT_DELAY_CHECKS	DELAY_CHECKS_OFF
 #define DEFAULT_UEVENT_STACKSIZE 256
-#define DEFAULT_RETRIGGER_DELAY 10
-#define DEFAULT_RETRIGGER_TRIES 3
+#define DEFAULT_RETRIGGER_DELAY	10
+#define DEFAULT_RETRIGGER_TRIES	3
 #define DEFAULT_UEV_WAIT_TIMEOUT 30
 
 #define DEFAULT_CHECKINT	5
-- 
2.5.5
