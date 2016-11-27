From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: replace "Default value" with
	"The default" in multipath/multipath.conf.5
Date: Sun, 27 Nov 2016 15:07:51 +0100
Message-ID: <20161127140751.5090-1-xose.vazquez@gmail.com>
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
 multipath/multipath.conf.5 | 100 ++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 35ce41a..cdfea6b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -108,7 +108,7 @@ Default verbosity. Higher values increase the verbosity level. Valid
 levels are between 0 and 6.
 .RS
 .TP
-Default value is: \fB2\fR
+The default is: \fB2\fR
 .RE
 .
 .
@@ -120,7 +120,7 @@ This value will be overridden by the \fIWatchdogSec\fR
 setting in the multipathd.service definition if systemd is used.
 .RS
 .TP
-Default value is: \fB5\fR
+The default is: \fB5\fR
 .RE
 .
 .
@@ -129,7 +129,7 @@ Default value is: \fB5\fR
 Maximal interval between two path checks in seconds.
 .RS
 .TP
-Default value is: \fB4 * polling_interval\fR
+The default is: \fB4 * polling_interval\fR
 .RE
 .
 .
@@ -141,7 +141,7 @@ device, not the underlying block devices. Possible values are
 \fIyes\fR and \fIno\fR.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -150,7 +150,7 @@ Default value is: \fBno\fR
 Directory where the dynamic shared objects are stored.
 .RS
 .TP
-Default value is: \fB<system dependent>\fR. Defined at compile time, commonly
+The default is: \fB<system dependent>\fR. Defined at compile time, commonly
 \fI/lib64/multipath/\fR.
 .RE
 .
@@ -176,7 +176,7 @@ of outstanding I/O to the path.
 (Since ??? kernel) Choose the path for the next bunch of I/O based on the amount
 of outstanding I/O to the path and its relative throughput.
 .TP
-Default value is: \fBservice-time 0\fR
+The default is: \fBservice-time 0\fR
 .RE
 .
 .
@@ -204,7 +204,7 @@ per-multipath option in the configuration file.
 One priority group per target node name. Target node names are fetched
 in \fI/sys/class/fc_transport/target*/node_name\fR.
 .TP
-Default value is: \fBfailover\fR
+The default is: \fBfailover\fR
 .RE
 .
 .
@@ -213,9 +213,9 @@ Default value is: \fBfailover\fR
 The udev attribute providing a unique path identifier.
 .RS
 .TP
-Default value is: for SCSI devices \fBID_SERIAL\fR
+The default is: for SCSI devices \fBID_SERIAL\fR
 .TP
-Default value is: for DASD devices \fBID_UID\fR
+The default is: for DASD devices \fBID_UID\fR
 .RE
 .
 .
@@ -285,7 +285,7 @@ priority provided as argument. Requires prio_args keyword.
 .\" XXX
 ???. Requires prio_args keyword.
 .TP
-Default value is: \fBconst\fR
+The default is: \fBconst\fR
 .RE
 .
 .
@@ -329,7 +329,7 @@ set will always be in their own path group.
 .\" XXX
 \fIpreferredip\fR ???.
 .TP
-Default value is: \fB<unset>\fR
+The default is: \fB<unset>\fR
 .RE
 .
 .
@@ -362,7 +362,7 @@ Disable automatic partitions generation via kpartx.
 Where <mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR. Which corresponds to
 bio-based, request_fn rq-based, and blk-mq rq-based respectively.
 .TP
-Default value is: \fB0\fR
+The default is: \fB0\fR
 .RE
 .
 .
@@ -406,7 +406,7 @@ Check the path state for HP/COMPAQ Smart Array(CCISS) controllers.
 .I rbd
 Check if the path is in the Ceph blacklist and remap the path if it is.
 .TP
-Default value is: \fBtur\fR
+The default is: \fBtur\fR
 .RE
 .
 .
@@ -415,7 +415,7 @@ Default value is: \fBtur\fR
 The \fIuser_friendly_names\fR prefix.
 .RS
 .TP
-Default value is: \fBmpath\fR
+The default is: \fBmpath\fR
 .RE
 .
 .
@@ -442,7 +442,7 @@ another node requested the failover.
 .I values > 0
 Deferred failback (time to defer in seconds).
 .TP
-Default value is: \fBmanual\fR
+The default is: \fBmanual\fR
 .RE
 .
 .
@@ -453,7 +453,7 @@ same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and
 only apply to \fIround-robin\fR path_selector.
 .RS
 .TP
-Default value is: \fB1000\fR
+The default is: \fB1000\fR
 .RE
 .
 .
@@ -464,7 +464,7 @@ same path group. This is only for \fIRequest\fR based multipath and
 only apply to \fIround-robin\fR path_selector.
 .RS
 .TP
-Default value is: \fB1\fR
+The default is: \fB1\fR
 .RE
 .
 .
@@ -478,7 +478,7 @@ maximum number of open fds is taken from the calling process. It is usually
 if that number is greated than 1024.
 .RS
 .TP
-Default value is: \fBmax\fR
+The default is: \fBmax\fR
 .RE
 .
 .
@@ -492,7 +492,7 @@ or
 Only apply to \fIround-robin\fR path_selector.
 .RS
 .TP
-Default value is: \fBuniform\fR
+The default is: \fBuniform\fR
 .RE
 .
 .
@@ -512,7 +512,7 @@ for never stop I/O queueing. Similar to \fIqueue_if_no_path\fR.
 .TP
 See KNOWN ISSUES.
 .TP
-Default value is: \fBfail\fR
+The default is: \fBfail\fR
 .RE
 .
 .
@@ -530,7 +530,7 @@ cannot be told to stop queueing I/O. Setting queue_without_daemon to
 , avoids this problem.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -540,7 +540,7 @@ Specify the timeout to use for path checkers and prioritizers that issue SCSI
 commands with an explicit timeout, in seconds.
 .RS
 .TP
-Default value is: in \fB/sys/block/sd<x>/device/timeout\fR
+The default is: in \fB/sys/block/sd<x>/device/timeout\fR
 .RE
 .
 .
@@ -552,7 +552,7 @@ If set to
 deleted.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -567,7 +567,7 @@ use the WWID as the alias. In either case this be will
 be overridden by any specific aliases in the \fImultipaths\fR section.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -580,7 +580,7 @@ This should be smaller than dev_loss_tmo. Setting this to
 will disable the timeout.
 .RS
 .TP
-Default value is: in \fB5\fR
+The default is: in \fB5\fR
 .RE
 .
 .
@@ -597,7 +597,7 @@ The Linux kernel will cap this value to \fI300\fR if \fIfast_io_fail_tmo\fR
 is not set. See KNOWN ISSUES.
 .RS
 .TP
-Default value is: \fB600\fR
+The default is: \fB600\fR
 .RE
 .
 .
@@ -607,7 +607,7 @@ The full pathname of the binding file to be used when the user_friendly_names
 option is set.
 .RS
 .TP
-Default value is: \fB/etc/multipath/bindings\fR
+The default is: \fB/etc/multipath/bindings\fR
 .RE
 .
 .
@@ -617,7 +617,7 @@ The full pathname of the WWIDs file, which is used by multipath to keep track
 of the WWIDs for LUNs it has created multipath devices on in the past.
 .RS
 .TP
-Default value is: \fB/etc/multipath/wwids\fR
+The default is: \fB/etc/multipath/wwids\fR
 .RE
 .
 .
@@ -631,7 +631,7 @@ errors are logged at level 3 until the device is restored. If set to
 , multipathd always logs the path checker error at logging level 2.
 .RS
 .TP
-Default value is: \fBalways\fR
+The default is: \fBalways\fR
 .RE
 .
 .
@@ -644,7 +644,7 @@ list which contains an 8-byte value provided by the application client to the
 device server to identify the I_T nexus.
 .RS
 .TP
-Default value is: \fB<unset>\fR
+The default is: \fB<unset>\fR
 .RE
 .
 .
@@ -658,7 +658,7 @@ mutipath.conf. If the SCSI layer has not attached a hardware handler,
 multipath will continue to use its configured hardware handler.
 .RS
 .TP
-Default value is: \fByes\fR
+The default is: \fByes\fR
 .RE
 .
 .
@@ -674,7 +674,7 @@ attributes \fIaccess_state\fR and \fIpreferred_path\fR are supported, or the
 , the prioritizer will be selected as usual.
 .RS
 .TP
-Default value is: \fByes\fR
+The default is: \fByes\fR
 .RE
 .
 .
@@ -687,7 +687,7 @@ only one checker will run at a time.  This is useful in the case where many
 multipathd checkers running in parallel causes significant CPU pressure.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -703,7 +703,7 @@ A warning will be printed if path checks take longer than \fIpolling_interval\fR
 seconds.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -718,7 +718,7 @@ to the multipath device before the last user closes it, the deferred remove
 will be canceled.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -730,7 +730,7 @@ number. If this parameter is set, multipath will act like kpartx does with
 the \fI-p\fR option is used, and always add delimiter.
 .RS
 .TP
-Default value is: \fB<unset>\fR
+The default is: \fB<unset>\fR
 .RE
 .
 .
@@ -742,7 +742,7 @@ information from them, just as if it was in \fI/etc/multipath.conf\fR.
 config_dir must either be "" or a fully qualified directory name.
 .RS
 .TP
-Default value is: \fB/etc/multipath/conf.d/\fR
+The default is: \fB/etc/multipath/conf.d/\fR
 .RE
 .
 .
@@ -754,7 +754,7 @@ being watched, when they next become valid, they will not be used until they
 have stayed up for \fIdelay_wait_checks\fR checks.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -766,7 +766,7 @@ comes back online, it will marked and delayed, and not used until it has passed
 \fIdelay_wait_checks\fR checks.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -793,7 +793,7 @@ users to have multipath automatically choose the correct paths to make into
 multipath devices, without having to edit the blacklist.
 .RS
 .TP
-Default value is: \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -807,7 +807,7 @@ In these cases it is recommended to increase the CLI timeout to avoid
 those issues.
 .RS
 .TP
-Default value is: \fB1000\fR
+The default is: \fB1000\fR
 .RE
 .
 .
@@ -817,7 +817,7 @@ Sets the number of times multipathd will try to retrigger a uevent to get the
 WWID.
 .RS
 .TP
-Default value is: \fB3\fR
+The default is: \fB3\fR
 .RE
 .
 .
@@ -826,7 +826,7 @@ Default value is: \fB3\fR
 Sets the amount of time, in seconds, to wait between retriggers.
 .RS
 .TP
-Default value is: \fB10\fR
+The default is: \fB10\fR
 .RE
 .
 .
@@ -838,7 +838,7 @@ automatically enabling device reloads. Usually multipathd will delay reloads
 on a device until it receives a change uevent from the initial table load.
 .RS
 .TP
-Default value is: \fB30\fR
+The default is: \fB30\fR
 .RE
 .
 .
@@ -849,7 +849,7 @@ If set to
 , kpartx will not automatically create partitions on the device.
 .RS
 .TP
-The default is \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -860,7 +860,7 @@ if it has changed from the wwid of the multipath device, multipathd will
 disable access to the path until the wwid changes back.
 .RS
 .TP
-Default value is \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
@@ -870,7 +870,7 @@ This sets how may times multipath will retry removing a device that is in-use.
 Between each attempt, multipath will sleep 1 second.
 .RS
 .TP
-Default value is \fB0\fR
+The default is: \fB0\fR
 .RE
 .
 .
@@ -900,7 +900,7 @@ The following keywords are recognized:
 Regular expression of the device nodes to be excluded.
 .RS
 .TP
-Default value is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]\fR and \fB^(td|hd|vd)[a-z]\fR
+The default is: \fB^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk|nvme)[0-9]\fR and \fB^(td|hd|vd)[a-z]\fR
 .RE
 .TP
 .B wwid
@@ -941,7 +941,7 @@ The \fIWorld Wide Identification\fR of a device.
 Regular expression of the udev property to be whitelisted.
 .RS
 .TP
-Default value is: \fB(SCSI_IDENT_|ID_WWN)\fR
+The default is: \fB(SCSI_IDENT_|ID_WWN)\fR
 .RE
 .TP
 .B device
@@ -1076,7 +1076,7 @@ Active/Standby mode exclusively.
 (Hardware-dependent)
 Hardware handler for SCSI-3 ALUA compatible arrays.
 .TP
-Default value is: \fB<unset>\fR
+The default is: \fB<unset>\fR
 .RE
 .
 .
-- 
2.10.2
