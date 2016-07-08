From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 04/14] multipath-tools: correct and add default
	values in multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:49 +0200
Message-ID: <1468000199-15566-5-git-send-email-xose.vazquez@gmail.com>
References: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468000199-15566-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 0f89a75..37a219c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -139,7 +139,7 @@ device, not the underlying block devices. Possible values are
 \fIyes\fR and \fIno\fR.
 .RS
 .TP
-Default value is: \fByes\fR
+Default value is: \fBno\fR
 .RE
 .TP
 .B path_selector
@@ -157,6 +157,8 @@ Send the next bunch of IO down the path with the least amount of outstanding IO.
 .I "service-time 0"
 Choose the path for the next bunch of IO based on the amount of outstanding IO
 to the path and its relative throughput.
+.TP
+Default value is: \fBservice-time 0\fR
 .RE
 .TP
 .B path_grouping_policy
@@ -237,7 +239,7 @@ Generate a random priority between 1 and 10.
 Generate the path priority based on the regular expression and the
 priority provided as argument. requires prio_args keyword.
 .TP
-Default value is: \fBnone\fR
+Default value is: \fBconst\fR
 .RE
 .TP
 .B prio_args
@@ -263,6 +265,8 @@ If
 .I exclusive_pref_bit
 is set, paths with the TPGS pref bit set will always be in their own path
 group.
+.TP
+Default value is: \fB<unset>\fR
 .RE
 .TP
 .B features
@@ -282,6 +286,8 @@ keyword.
 .TP
 .I no_partitions
 Disable automatic partitions generation via kpartx.
+.TP
+Default value is: \fB0\fR
 .RE
 .TP
 .B path_checker
@@ -415,6 +421,10 @@ this to the system limit from /proc/sys/fs/nr_open. If this is not set, the
 maximum number of open fds is taken from the calling process. It is usually
 1024. To be safe, this should be set to the maximum number of paths plus 32,
 if that number is greated than 1024.
+.RS
+.TP
+Default value is: \fBmax\fR
+.RE
 .TP
 .B checker_timeout
 Specify the timeout to use for path checkers and prioritizers that issue scsi
@@ -430,6 +440,10 @@ detected on a FC remote port before failing IO to devices on that remote port.
 This should be smaller than dev_loss_tmo. Setting this to
 .I off
 will disable the timeout.
+.RS
+.TP
+Default value is: in \fB5\fR
+.RE
 .TP
 .B dev_loss_tmo
 Specify the number of seconds the scsi layer will wait after a problem has
-- 
2.7.4
