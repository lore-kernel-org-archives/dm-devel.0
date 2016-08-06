From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 5/7] multipath-tools: random fixes in
	multipath.conf.5
Date: Sun,  7 Aug 2016 00:40:06 +0200
Message-ID: <1470523208-14067-5-git-send-email-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5 | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 14a8ccb..4567103 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,3 +1,10 @@
+.\" ----------------------------------------------------------------------------
+.\" Update the date below if you make any significant change.
+.\"
+.\" TODO: Look for XXX
+.\"
+.\" ----------------------------------------------------------------------------
+.
 .TH MULTIPATH.CONF 5 2016-08-06 "Linux"
 .
 .
@@ -199,9 +206,9 @@ Default value is: \fBfailover\fR
 The udev attribute providing a unique path identifier.
 .RS
 .TP
-Default value is: \fBID_SERIAL\fR for SCSI devices
+Default value is: for SCSI devices \fBID_SERIAL\fR
 .TP
-Default value is: \fBID_UID\fR for DASD devices
+Default value is: for DASD devices \fBID_UID\fR
 .RE
 .
 .
@@ -264,9 +271,11 @@ Generate the path priority based on the regular expression and the
 priority provided as argument. Requires prio_args keyword.
 .TP
 .I datacore
+.\" XXX
 ???. Requires prio_args keyword.
 .TP
 .I iet
+.\" XXX
 ???. Requires prio_args keyword.
 .TP
 Default value is: \fBconst\fR
@@ -285,18 +294,19 @@ Needs a value of the form
 .RS
 .TP 8
 .I hbtl
-regex can be of SCSI H:B:T:L format  Ex: 1:0:.:. , *:0:0:.
+regex can be of SCSI H:B:T:L format. For example: 1:0:.:. , *:0:0:.
 .TP
 .I devname
-regex can be of device name format  Ex: sda , sd.e
+regex can be of device name format. For example: sda , sd.e
 .TP
 .I serial
-regex can be of serial number format  Ex: .*J1FR.*324  The serial can be looked up through sysfs or by running multipathd show paths format "%z" Ex: 0395J1FR904324
+regex can be of serial number format. For example: .*J1FR.*324 . The serial can be looked
+up through sysfs or by running multipathd show paths format "%z". For example: 0395J1FR904324
 .TP
 .I wwn
 regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
 these values can be looked up through sysfs or by running \fImultipathd show paths format
-"%N:%R:%n:%r" Ex: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*\fR
+"%N:%R:%n:%r". For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*\fR
 .RE
 .TP 12
 .I alua
@@ -304,9 +314,11 @@ If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
 set will always be in their own path group.
 .TP
 .I datacore
+.\" XXX
 \fIpreferredsds\fR ???.
 .TP
 .I iet
+.\" XXX
 \fIpreferredip\fR ???.
 .TP
 Default value is: \fB<unset>\fR
@@ -545,8 +557,7 @@ Specify the number of seconds the SCSI layer will wait after a problem has
 been detected on a FC remote port before removing it from the system. This
 can be set to "infinity" which sets it to the max value of 2147483647
 seconds, or 68 years. It will be automatically adjusted to the overall
-retry interval
-\fIno_path_retry\fR * \fIpolling_interval\fR
+retry interval \fIno_path_retry\fR * \fIpolling_interval\fR
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
 The Linux kernel will cap this value to \fI300\fR if \fIfast_io_fail_tmo\fR
@@ -802,10 +813,9 @@ Default value is: \fB30\fR
 .SH "blacklist section"
 .\" ----------------------------------------------------------------------------
 .
-The \fIblacklist\fR
-section is used to exclude specific device from inclusion in the
-multipath topology. It is most commonly used to exclude local disks or
-LUNs for the array controller.
+The \fIblacklist\fR section is used to exclude specific device from inclusion in
+the multipath topology. It is most commonly used to exclude local disks or LUNs
+for the array controller.
 .LP
 .
 .
@@ -834,10 +844,9 @@ keywords. For a full description of these keywords please see the
 .\" ----------------------------------------------------------------------------
 .
 The \fIblacklist_exceptions\fR section is used to revert the actions of the
-\fIblacklist\fR section, for example to include specific device in the
+\fIblacklist\fR section. For example to include specific device in the
 multipath topology. This allows one to selectively include devices which
-would normally be excluded via the \fIblacklist\fR
-section.
+would normally be excluded via the \fIblacklist\fR section.
 .LP
 .
 .
@@ -890,8 +899,7 @@ Symbolic name for the multipath map.
 .
 .
 The following attributes are optional; if not set the default values
-are taken from the \fIdefaults\fR or \fIdevices\fR
-section:
+are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .sp 1
 .PD .1v
 .RS
@@ -1139,7 +1147,7 @@ The use of \fIqueue_if_no_path\fR or \fIno_path_retry\fR might lead to a
 deadlock if the \fIdev_loss_tmo\fR setting results in a device being removed
 while I/O is still queued. The multipath daemon will update the \fIdev_loss_tmo\fR
 setting accordingly to avoid this deadlock. Hence if both values are
-specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_loss_tmo.\fR
+specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_loss_tmo\fR.
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1158,3 +1166,4 @@ specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_los
 .
 \fImultipath-tools\fR was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com>
 and others.
+.\" EOF
-- 
2.7.4
