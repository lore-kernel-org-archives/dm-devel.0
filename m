From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: minor edition and corrections
	in multipath.conf.5
Date: Fri, 18 Aug 2017 00:42:14 +0200
Message-ID: <20170817224214.8085-1-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 62 +++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index d9ac279..a78ec5b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -2,12 +2,13 @@
 .\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t multipath/multipath.conf.5
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 >/dev/null
 .\"
 .\" TODO: Look for XXX and ???
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2017-05-11 "Linux"
+.TH MULTIPATH.CONF 5 2017-08-18 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -26,6 +27,8 @@ is the configuration file for the multipath daemon. It is used to
 overwrite the built-in configuration table of \fBmultipathd\fP.
 Any line whose first non-white-space character is a '#' is considered
 a comment line. Empty lines are ignored.
+.PP
+Internal multipathd configuration can be displayed with the \fBmultipath -t\fR command.
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -215,11 +218,9 @@ unique identifier in config file, and it would activate merging uevents
 according to the identifier to promote effiecncy in processing uevents.
 It has no default value, if you want to identify path by udev attribute
 and to activate merging uevents for SCSI and DASD devices, you can set
-its value as:
+its value as: \fIuid_attrs "sd:ID_SERIAL dasd:ID_UID"\fR.
 .RS
 .TP
-\fBuid_attrs "sd:ID_SERIAL dasd:ID_UID"\fR
-.TP
 The default is: \fB<unset>\fR
 .RE
 .
@@ -241,9 +242,13 @@ The default is: for NVME devices \fBID_WWN\fR
 .B getuid_callout
 (Superseded by \fIuid_attribute\fR) The default program and args to callout
 to obtain a unique path identifier. Should be specified with an absolute path.
+.RS
 .TP
+The default is: \fB<unset>\fR
+.RE
 .
 .
+.TP
 .B prio
 The name of the path priority routine. The specified routine
 should return a numeric value specifying the relative priority
@@ -301,7 +306,7 @@ Requires prio_args keyword.
 .TP
 .I datacore
 (Hardware-dependent)
-Generate the path priority for some Datacore storage arrays. Requires prio_args
+Generate the path priority for some DataCore storage arrays. Requires prio_args
 keyword.
 .TP
 .I iet
@@ -328,25 +333,24 @@ Needs a value of the form
 .RS
 .TP 8
 .I hbtl
-regex can be of SCSI H:B:T:L format. For example: 1:0:.:. , *:0:0:.
+Regex can be of SCSI H:B:T:L format. For example: 1:0:.:. , *:0:0:.
 .TP
 .I devname
-regex can be of device name format. For example: sda , sd.e
+Regex can be of device name format. For example: sda , sd.e
 .TP
 .I serial
-regex can be of serial number format. For example: .*J1FR.*324 . The serial can
+Regex can be of serial number format. For example: .*J1FR.*324 . The serial can
 be looked up through sysfs or by running multipathd show paths format "%z". For
 example: 0395J1FR904324
 .TP
 .I wwn
-regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
+Regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
 these values can be looked up through sysfs or by running \fImultipathd show paths format
 "%N:%R:%n:%r"\fR. For example: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
 .RE
 .TP 12
 .I path_latency
-Needs a value of the form
-\fI"<io_num>|<base_num>"\fR
+Needs a value of the form \fI"<io_num>|<base_num>"\fR
 .RS
 .TP 8
 .I io_num
@@ -369,12 +373,21 @@ If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
 set will always be in their own path group.
 .TP
 .I datacore
-\fIpreferredsds\fR (required) denotes the preferred "SDS name" for datacore
-arrays. \fItimeout\fR (optional) is the timeout for the INQUIRY, in ms.
+.RS
+.TP 8
+.I preferredsds
+(Mandatory) The preferred "SDS name".
 .TP
+.I timeout
+(Optional) The timeout for the INQUIRY, in ms.
+.RE
+.TP 12
 .I iet
-\fIpreferredip=...\fR (required) denotes the preferred IP address (in dotted decimal
-notation) for iSCSI targets.
+.RS
+.TP 8
+.I preferredip=...
+(Mandatory) Th preferred IP address, in dotted decimal notation, for iSCSI targets.
+.RE
 .TP
 The default is: \fB<unset>\fR
 .RE
@@ -387,30 +400,27 @@ where \fInum\fR is the number, between 0 and 8, of features in \fIlist\fR.
 Possible values for the feature list are:
 .RS
 .TP 12
-.\" XXX
 .I queue_if_no_path
 (Deprecated, superseded by \fIno_path_retry\fR) Queue I/O if no path is active.
 Identical to the \fIno_path_retry\fR with \fIqueue\fR value. If both this
 feature and \fIno_path_retry\fR are set, the latter value takes
 precedence. See KNOWN ISSUES.
 .TP
-.\" XXX
 .I pg_init_retries <times>
 (Since kernel 2.6.24) Number of times to retry pg_init, it must be between 1 and 50.
 .TP
-.\" XXX
 .I pg_init_delay_msecs <msecs>
 (Since kernel 2.6.38) Number of msecs before pg_init retry, it must be between 0 and 60000.
 .TP
-.\" XXX
 .I queue_mode <mode>
 (Since kernel 4.8) Select the the queueing mode per multipath device.
 <mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR, which corresponds to
 bio-based, request-based, and block-multiqueue (blk-mq) request-based,
 respectively.
-
 The default depends on the kernel parameter \fBdm_mod.use_blk_mq\fR. It is
 \fImq\fR if the latter is set, and \fIrq\fR otherwise.
+.TP
+The default is: \fB<unset>\fR
 .RE
 .
 .
@@ -550,15 +560,13 @@ Specify what to do when all paths are down. Possible values are:
 .RS
 .TP 12
 .I value > 0
-number of retries until disable I/O queueing.
+Number of retries until disable I/O queueing.
 .TP
 .I fail
-for immediate failure (no I/O queueing).
+For immediate failure (no I/O queueing).
 .TP
 .I queue
-for never stop I/O queueing. Similar to \fIqueue_if_no_path\fR.
-.TP
-See KNOWN ISSUES.
+For never stop I/O queueing, similar to \fIqueue_if_no_path\fR. See KNOWN ISSUES.
 .TP
 The default is: \fBfail\fR
 .RE
@@ -706,7 +714,9 @@ mutipath.conf. If the SCSI layer has not attached a hardware handler,
 multipath will continue to use its configured hardware handler.
 .RS
 .PP
-The default is: \fByes\fR. Linux kernel 4.3 or newer always behaves as if
+The default is: \fByes\fR
+.PP
+\fBImportant Note:\fR Linux kernel 4.3 or newer always behaves as if
 \fB"retain_attached_hw_handler yes"\fR was set.
 .RE
 .
-- 
2.13.5
