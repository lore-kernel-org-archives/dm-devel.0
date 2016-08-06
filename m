From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 7/7] multipath-tools: more fixes for
	multipath.conf.5
Date: Sun,  7 Aug 2016 00:40:08 +0200
Message-ID: <1470523208-14067-7-git-send-email-xose.vazquez@gmail.com>
References: <1470523208-14067-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470523208-14067-1-git-send-email-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5 | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index fc620be..6267c45 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,11 +1,13 @@
 .\" ----------------------------------------------------------------------------
 .\" Update the date below if you make any significant change.
+.\" Make sure there are no errors with:
+.\" groff -z -wall -b -e -t multipath/multipath.conf.5
 .\"
 .\" TODO: Look for XXX
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2016-08-06 "Linux"
+.TH MULTIPATH.CONF 5 2016-08-07 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -145,7 +147,7 @@ Default value is: \fBno\fR
 .
 .TP
 .B multipath_dir
-Directory where the dynamic shared objects are stored.
+Directory where the dynamic shared objects are stored. Defined at compile time.
 .RS
 .TP
 Default value is: \fB<system dependent>\fR, commonly \fI/lib64/multipath/\fR
@@ -214,8 +216,8 @@ Default value is: for DASD devices \fBID_UID\fR
 .
 .TP
 .B getuid_callout
-(Deprecated) The default program and args to callout to obtain a unique path
-identifier. Should be specified with an absolute path.
+(Superseded by \fIuid_attribute\fR) The default program and args to callout
+to obtain a unique path identifier. Should be specified with an absolute path.
 .TP
 .
 .
@@ -306,7 +308,7 @@ up through sysfs or by running multipathd show paths format "%z". For example: 0
 .I wwn
 regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
 these values can be looked up through sysfs or by running \fImultipathd show paths format
-"%N:%R:%n:%r". For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*\fR
+"%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
 .RE
 .TP 12
 .I alua
@@ -333,8 +335,8 @@ Possible values for the feature list are:
 .RS
 .TP 12
 .I queue_if_no_path
-Queue IO if no path is active; identical to the \fIno_path_retry\fR
-keyword.
+Queue IO if no path is active; identical to the \fIno_path_retry\fR keyword.
+See KNOWN ISSUES.
 .TP
 .I no_partitions
 Disable automatic partitions generation via kpartx.
@@ -412,8 +414,9 @@ active paths.
 Do not perform automatic failback.
 .TP
 .I followover
-Only perform automatic failback when the first path of a pathgroup
-becomes active. This keeps a node from automatically failing back when
+Used to deal with multiple computers accessing the same Active/Passive storage
+devices. Only perform automatic failback when the first path of a pathgroup
+becomes active. This keeps a cluster node from automatically failing back when
 another node requested the failover.
 .TP
 .I values > 0
@@ -476,7 +479,7 @@ Specify the number of retries until disable queueing, or
 .I fail
 for immediate failure (no queueing),
 .I queue
-for never stop queueing. If unset no queueing is attempted.
+for never stop queueing. If unset no queueing is attempted. See KNOWN ISSUES.
 .RS
 .TP
 Default value is: \fB<unset>\fR
@@ -561,7 +564,7 @@ retry interval \fIno_path_retry\fR * \fIpolling_interval\fR
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
 The Linux kernel will cap this value to \fI300\fR if \fIfast_io_fail_tmo\fR
-is not set.
+is not set. See KNOWN ISSUES.
 .RS
 .TP
 Default value is: \fB600\fR
-- 
2.7.4
