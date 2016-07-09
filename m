From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: enable retain_hw_handler
	and detect_prio by default
Date: Sat,  9 Jul 2016 02:48:46 +0200
Message-ID: <1468025327-9625-1-git-send-email-xose.vazquez@gmail.com>
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

Based on previous Hannes's work.

He wrote:
"And for several versions (years, even) the linux kernel has the ability
to correctly detect the device handler, so we should be making
'retain_hw_handler' the default.
And if we do this we also want to enable 'detect_prio', to ensure
we pick the correct prioritizer."

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/defaults.h    | 4 ++--
 multipath/multipath.conf.5 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index dc70a74..dd6a24b 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -16,8 +16,8 @@
 #define DEFAULT_FIND_MULTIPATHS	0
 #define DEFAULT_FAST_IO_FAIL	5
 #define DEFAULT_DEV_LOSS_TMO	600
-#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
-#define DEFAULT_DETECT_PRIO	DETECT_PRIO_OFF
+#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
+#define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
 #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS	DELAY_CHECKS_OFF
 #define DEFAULT_UEVENT_STACKSIZE 256
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 709ab3c..1da2de1 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -561,7 +561,7 @@ mutipath.conf. If the SCSI layer has not attached a hardware handler,
 multipath will continue to use its configured hardware handler.
 .RS
 .TP
-Default value is: \fBno\fR
+Default value is: \fByes\fR
 .RE
 .TP
 .B detect_prio
@@ -573,7 +573,7 @@ device will automatically use the
 prioritizer. If not, the prioritizer will be selected as usual.
 .RS
 .TP
-Default value is: \fBno\fR
+Default value is: \fByes\fR
 .RE
 .TP
 .B force_sync
-- 
2.7.4
