From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: Document retrigger_tries
	and retrigger_delay in multipath.conf.5
Date: Mon, 11 Jul 2016 23:05:16 +0200
Message-ID: <1468271117-2847-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Added in 688aa22bfa6efb1db0bd1fa6c4d5b6789eb1a911

Minimal info, a more detailed description should be nice.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 709ab3c..76d80e3 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -673,6 +673,21 @@ those issues.
 Default value is: \fB1000\fR
 .RE
 .TP
+.B retrigger_tries
+Sets the number of times multipathd will try to retrigger a uevent to get the
+WWID.
+.RS
+.TP
+Default value is: \fB3\fR
+.RE
+.TP
+.B retrigger_delay
+Sets the amount of time, in seconds, to wait between retriggers.
+.RS
+.TP
+Default value is: \fB10\fR
+.RE
+.TP
 .B missing_uev_wait_timeout
 Controls how many seconds multipathd will wait, after a new multipath device
 is created, to receive a change event from udev for the device, before
-- 
2.7.4
