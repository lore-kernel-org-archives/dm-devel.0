From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: make defaults values more
	visible in multipath.conf.5
Date: Sun,  3 Jul 2016 01:06:19 +0200
Message-ID: <1467500779-28754-1-git-send-email-xose.vazquez@gmail.com>
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

Put them in a new paragraph, and in bold.

Easier to read and cleaner layout.

man page in PDF at: https://drive.google.com/file/d/0B_B6YmEmO7cDVTl2djM1YkZMNFE

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 221 +++++++++++++++++++++++++++++++--------------
 1 file changed, 153 insertions(+), 68 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 9f0d194..b85ea14 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,4 +1,4 @@
-.TH MULTIPATH.CONF 5 "30 November 2006"
+.TH MULTIPATH.CONF 5 2016-07-03 "Linux"
 .SH NAME
 multipath.conf \- multipath daemon configuration file
 .SH DESCRIPTION
@@ -78,17 +78,24 @@ the interval between checks will gradually increase to
 This value will be overridden by the
 .B WatchdogSec
 setting in the multipathd.service definition if systemd is used.
-Default is
-.I 5
+.RS
+.TP
+Default value is: \fB5\fR
+.RE
 .TP
 .B max_polling_interval
-maximal interval between two path checks in seconds; default is
-.I 4 * polling_interval
+maximal interval between two path checks in seconds.
+.RS
+.TP
+Default value is: \fB4 * polling_interval\fR
+.RE
 .TP
 .B multipath_dir
-directory where the dynamic shared objects are stored; default is system
-dependent, commonly
-.I /lib/multipath
+directory where the dynamic shared objects are stored.
+.RS
+.TP
+Default value is: \fB<system dependent>\fR, commonly /lib64/multipath/
+.RE
 .TP
 .B find_multipaths
 If set to
@@ -109,20 +116,29 @@ Whenever a multipath device is created with find_multipaths set, multipath will
 remeber the WWID of the device, so that it will automatically create the
 device again, as soon as it sees a path with that WWID. This should allow most
 users to have multipath automatically choose the correct paths to make into
-multipath devices, without having to edit the blacklist; Default is
-.I no
+multipath devices, without having to edit the blacklist.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B verbosity
 default verbosity. Higher values increase the verbosity level. Valid
-levels are between 0 and 6; default is
-.I 2
+levels are between 0 and 6.
+.RS
+.TP
+Default value is: \fB2\fR
+.RE
 .TP
 .B reassign_maps
 enable reassigning of device-mapper maps. With this option multipathd
 will remap existing device-mapper maps to always point to multipath
 device, not the underlying block devices. Possible values are
-\fIyes\fR and \fIno\fR. Default is
-.I yes
+\fIyes\fR and \fIno\fR.
+.RS
+.TP
+Default value is: \fByes\fR
+.RE
 .TP
 .B path_selector
 The default path selector algorithm to use; they are offered by the
@@ -164,13 +180,15 @@ per-multipath option in the configuration file.
 1 priority group per target node name. Target node names are fetched
 in /sys/class/fc_transport/target*/node_name.
 .TP
-Default value is \fIfailover\fR.
+Default value is: \fBfailover\fR
 .RE
 .TP
 .B uid_attribute
-The udev attribute providing a unique path
-identifier. Default value is
-.I ID_SERIAL
+The udev attribute providing a unique path identifier.
+.RS
+.TP
+Default value is: \fBID_SERIAL\fR
+.RE
 .TP
 .B getuid_callout
 The default program and args to callout to obtain a unique path
@@ -217,7 +235,7 @@ Generate a random priority between 1 and 10.
 Generate the path priority based on the regular expression and the
 priority provided as argument. requires prio_args keyword.
 .TP
-Default value is \fBnone\fR.
+Default value is: \fBnone\fR
 .RE
 .TP
 .B prio_args
@@ -293,7 +311,7 @@ Check the path state for LSI/Engenio/NetApp E-Series RDAC storage controller.
 deprecated, it will cause spurious path failures under high load.
 Please use \fItur\fR instead.
 .TP
-Default value is \fItur\fR.
+Default value is: \fBtur\fR
 .RE
 .TP
 .B failback
@@ -315,19 +333,24 @@ another node requested the failover.
 .B values > 0
 deferred failback (time to defer in seconds)
 .TP
-Default value is \fImanual\fR.
+Default value is: \fBmanual\fR
 .RE
 .TP
 .B  rr_min_io
 The number of IO to route to a path before switching to the next in
-the same path group. This is only for BIO based multipath. Default is
-.I 1000
+the same path group. This is only for BIO based multipath.
+.RS
+.TP
+Default value is: \fB1000\fR
+.RE
 .TP
 .B rr_min_io_rq
 The number of IO requests to route to a path before switching to the
 next in the same path group. This is only for request based multipath.
-Default is
-.I 1
+.RS
+.TP
+Default value is: \fB1\fR
+.RE
 .TP
 .B rr_weight
 If set to \fIpriorities\fR the multipath configurator will assign
@@ -335,8 +358,10 @@ path weights as "path prio * rr_min_io". Possible values are
 .I priorities
 or
 .IR uniform .
-Default is
-.IR uniform .
+.RS
+.TP
+Default value is: \fBuniform\fR
+.RE
 .TP
 .B no_path_retry
 Specify the number of retries until disable queueing, or
@@ -344,7 +369,10 @@ Specify the number of retries until disable queueing, or
 for immediate failure (no queueing),
 .I queue
 for never stop queueing. If unset no queueing is attempted.
-Default is unset.
+.RS
+.TP
+Default value is: \fB<unset>\fR
+.RE
 .TP
 .B user_friendly_names
 If set to
@@ -356,15 +384,20 @@ If set to
 .I no
 use the WWID as the alias. In either case this be will
 be overridden by any specific aliases in the \fImultipaths\fR section.
-Default is
-.I no
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B flush_on_last_del
 If set to
 .I yes
 , multipathd will disable queueing when the last path to a device has been
-deleted. Default is
-.I no
+deleted.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B max_fds
 Specify the maximum number of file descriptors that can be opened by multipath
@@ -376,8 +409,11 @@ if that number is greated than 1024.
 .TP
 .B checker_timeout
 Specify the timeout to use for path checkers and prioritizers that issue scsi
-commands with an explicit timeout, in seconds; default taken from
-.I /sys/block/sd<x>/device/timeout
+commands with an explicit timeout, in seconds.
+.RS
+.TP
+Default value is: in \fB/sys/block/sd<x>/device/timeout\fR
+.RE
 .TP
 .B fast_io_fail_tmo
 Specify the number of seconds the scsi layer will wait after a problem has been
@@ -396,7 +432,11 @@ retry interval
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
 The linux kernel will cap this value to \fI300\fR if \fBfast_io_fail_tmo\fR
-is not set. Default is 600.
+is not set.
+.RS
+.TP
+Default value is: \fB600\fR
+.RE
 .TP
 .B queue_without_daemon
 If set to
@@ -408,18 +448,26 @@ for IO to return from the device after multipathd has been stopped. Without
 multipathd running, access to the paths cannot be restored, and the kernel
 cannot be told to stop queueing IO. Setting queue_without_daemon to
 .I no
-, avoids this problem. Default is
-.I no
+, avoids this problem.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B bindings_file
-The full pathname of the binding file to be used when the user_friendly_names option is set. Defaults to
-.I /etc/multipath/bindings
+The full pathname of the binding file to be used when the user_friendly_names option is set.
+.RS
+.TP
+Default value is: \fB/etc/multipath/bindings\fR
+.RE
 .TP
 .B wwids_file
 The full pathname of the wwids file, which is used by multipath to keep track
 of the wwids for LUNs it has created multipath devices on in the past.
-Defaults to
-.I /etc/multipath/wwids
+.RS
+.TP
+Default value is: \fB/etc/multipath/wwids\fR
+.RE
 .TP
 .B log_checker_err
 If set to
@@ -427,15 +475,22 @@ If set to
 , multipathd logs the first path checker error at logging level 2. Any later
 errors are logged at level 3 until the device is restored. If set to
 .I always
-, multipathd always logs the path checker error at logging level 2. Default is
-.I always
+, multipathd always logs the path checker error at logging level 2.
+.RS
+.TP
+Default value is: \fBalways\fR
+.RE
 .TP
 .B reservation_key
 This is the service action reservation key used by mpathpersist.  It must be
 set for all multipath devices using persistent reservations, and it must be
 the same as the RESERVATION KEY field of the PERSISTENT RESERVE OUT parameter
 list which contains an 8-byte value provided by the application client to the
-device server to identify the I_T nexus. It is unset by default.
+device server to identify the I_T nexus.
+.RS
+.TP
+Default value is: \fB<unset>\fR
+.RE
 .TP
 .B retain_attached_hw_handler
 If set to
@@ -443,8 +498,11 @@ If set to
 and the scsi layer has already attached a hardware_handler to the device,
 multipath will not force the device to use the hardware_handler specified by
 mutipath.conf. If the scsi layer has not attached a hardware handler,
-multipath will continue to use its configured hardware handler. Default is
-.I no
+multipath will continue to use its configured hardware handler.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B detect_prio
 If set to
@@ -452,17 +510,22 @@ If set to
 , multipath will try to detect if the device supports ALUA. If so, the device
 will automatically use the
 .I alua
-prioritizer. If not, the prioritizer will be selected as usual. Default is
-.I no
+prioritizer. If not, the prioritizer will be selected as usual.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B force_sync
 If set to
 .I yes
 , multipathd will call the path checkers in sync mode only.  This means that
 only one checker will run at a time.  This is useful in the case where many
-multipathd checkers running in parallel causes significant CPU pressure. The
-Default is
-.I no
+multipathd checkers running in parallel causes significant CPU pressure.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B deferred_remove
 If set to
@@ -471,15 +534,21 @@ If set to
 last path device has been deleted.  This means that if the multipath device is
 still in use, it will be freed when the last user closes it.  If path is added
 to the multipath device before the last user closes it, the deferred remove
-will be canceled. Default is
-.I no
+will be canceled.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B config_dir
 If set to anything other than "", multipath will search this directory
 alphabetically for file ending in ".conf" and it will read configuration
 information from them, just as if it was in /etc/multipath.conf.  config_dir
-must either be "" or a fully qualified directory name. Default is
-.I "/etc/multipath/conf.d"
+must either be "" or a fully qualified directory name.
+.RS
+.TP
+Default value is: \fB/etc/multipath/conf.d/\fR
+.RE
 .TP
 .B delay_watch_checks
 If set to a value greater than 0, multipathd will watch paths that have
@@ -487,8 +556,11 @@ recently become valid for this many checks.  If they fail again while they are
 being watched, when they next become valid, they will not be used until they
 have stayed up for
 .I delay_wait_checks
-checks. Default is
-.I no
+checks.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B delay_wait_checks
 If set to a value greater than 0, when a device that has recently come back
@@ -497,8 +569,11 @@ online fails again within
 checks, the next time it comes back online, it will marked and delayed, and not
 used until it has passed
 .I delay_wait_checks
-checks. Default is
-.I no
+checks.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B strict_timinig
 If set to
@@ -511,8 +586,10 @@ here the missing ticks will be accounted for on the next round.
 A warning will be printed if path checks take longer than
 .I polling_interval
 seconds.
-Default is
-.I no
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
 .TP
 .B uxsock_timeout
 CLI receive timeout in milliseconds. For larger systems CLI commands
@@ -520,16 +597,21 @@ might timeout before the multipathd lock is released and the CLI command
 can be processed. This will result in errors like
 "timeout receiving packet" to be returned from CLI commands.
 In these cases it is recommended to increase the CLI timeout to avoid
-those issues. The default is
-.I 1000
+those issues.
+.RS
+.TP
+Default value is: \fB1000\fR
+.RE
 .TP
 .B missing_uev_wait_timeout
 Controls how many seconds multipathd will wait, after a new multipath device
 is created, to receive a change event from udev for the device, before
 automatically enabling device reloads. Usually multipathd will delay reloads
-on a device until it receives a change uevent from the initial table load. The
-default is
-.I 30
+on a device until it receives a change uevent from the initial table load.
+.RS
+.TP
+Default value is: \fB30\fR
+.RE
 .
 .SH "blacklist section"
 The
@@ -574,8 +656,11 @@ The following keywords are recognized:
 The \fIWorld Wide Identification\fR of a device.
 .TP
 .B property
-Regular expression of the udev property to be whitelisted. Defaults to
-.I (ID_WWN|SCSI_IDENT_.*)
+Regular expression of the udev property to be whitelisted.
+.RS
+.TP
+Default value is: \fB(ID_WWN|SCSI_IDENT_.*)\fR
+.RE
 .TP
 .B devnode
 Regular expression of the device nodes to be whitelisted.
-- 
2.7.4
