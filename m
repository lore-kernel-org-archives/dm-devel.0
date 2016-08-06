From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/7] multipath-tools: add dots(spaces) between
	sections and keywords
Date: Sun,  7 Aug 2016 00:40:05 +0200
Message-ID: <1470523208-14067-4-git-send-email-xose.vazquez@gmail.com>
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

Cleaner layout.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 143 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 141 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 1a96acf..14a8ccb 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,19 +1,28 @@
 .TH MULTIPATH.CONF 5 2016-08-06 "Linux"
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH NAME
 .\" ----------------------------------------------------------------------------
+.
 multipath.conf \- multipath daemon configuration file.
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
 .\" ----------------------------------------------------------------------------
+.
 .B "/etc/multipath.conf"
 is the configuration file for the multipath daemon. It is used to
 overwrite the built-in configuration table of \fBmultipathd\fP.
 Any line whose first non-white-space character is a '#' is considered
 a comment line. Empty lines are ignored.
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH SYNTAX
 .\" ----------------------------------------------------------------------------
+.
 The configuration file contains entries of the form:
 .RS
 .nf
@@ -44,6 +53,8 @@ Each \fIsection\fP contains one or more attributes or subsections. The
 recognized keywords for attributes or subsections depend on the
 section in which they occur.
 .LP
+.
+.
 The following \fIsection\fP keywords are recognized:
 .TP 17
 .B defaults
@@ -73,10 +84,15 @@ This section defines values for attributes that should override the
 device-specific settings for all devices.
 .RE
 .LP
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "defaults section"
 .\" ----------------------------------------------------------------------------
+.
 The \fIdefaults\fR section recognizes the following keywords:
+.
+.
 .TP 17
 .B verbosity
 Default verbosity. Higher values increase the verbosity level. Valid
@@ -85,6 +101,8 @@ levels are between 0 and 6.
 .TP
 Default value is: \fB2\fR
 .RE
+.
+.
 .TP
 .B polling_interval
 Interval between two path checks in seconds. For properly functioning paths,
@@ -95,6 +113,8 @@ setting in the multipathd.service definition if systemd is used.
 .TP
 Default value is: \fB5\fR
 .RE
+.
+.
 .TP
 .B max_polling_interval
 Maximal interval between two path checks in seconds.
@@ -102,6 +122,8 @@ Maximal interval between two path checks in seconds.
 .TP
 Default value is: \fB4 * polling_interval\fR
 .RE
+.
+.
 .TP
 .B reassign_maps
 Enable reassigning of device-mapper maps. With this option multipathd
@@ -112,6 +134,8 @@ device, not the underlying block devices. Possible values are
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B multipath_dir
 Directory where the dynamic shared objects are stored.
@@ -119,6 +143,8 @@ Directory where the dynamic shared objects are stored.
 .TP
 Default value is: \fB<system dependent>\fR, commonly \fI/lib64/multipath/\fR
 .RE
+.
+.
 .TP
 .B path_selector
 The default path selector algorithm to use; they are offered by the
@@ -138,6 +164,8 @@ to the path and its relative throughput.
 .TP
 Default value is: \fBservice-time 0\fR
 .RE
+.
+.
 .TP
 .B path_grouping_policy
 The default path grouping policy to apply to unspecified
@@ -164,6 +192,8 @@ in \fI/sys/class/fc_transport/target*/node_name\fR.
 .TP
 Default value is: \fBfailover\fR
 .RE
+.
+.
 .TP
 .B uid_attribute
 The udev attribute providing a unique path identifier.
@@ -173,11 +203,15 @@ Default value is: \fBID_SERIAL\fR for SCSI devices
 .TP
 Default value is: \fBID_UID\fR for DASD devices
 .RE
+.
+.
 .TP
 .B getuid_callout
 (Deprecated) The default program and args to callout to obtain a unique path
 identifier. Should be specified with an absolute path.
 .TP
+.
+.
 .B prio
 The name of the path priority routine. The specified routine
 should return a numeric value specifying the relative priority
@@ -237,6 +271,8 @@ priority provided as argument. Requires prio_args keyword.
 .TP
 Default value is: \fBconst\fR
 .RE
+.
+.
 .TP
 .B prio_args
 Arguments to pass to to the prio function. This only applies to certain
@@ -275,6 +311,8 @@ set will always be in their own path group.
 .TP
 Default value is: \fB<unset>\fR
 .RE
+.
+.
 .TP
 .B features
 Specify any device-mapper features to be used. Syntax is \fInum list\fR
@@ -297,6 +335,8 @@ Number of msecs before pg_init retry, it must be between 0 and 60000.
 .TP
 Default value is: \fB0\fR
 .RE
+.
+.
 .TP
 .B path_checker
 The default method used to determine the paths state. Possible values
@@ -336,6 +376,8 @@ Check the path state for HP/COMPAQ Smart Array(CCISS) controllers.
 .TP
 Default value is: \fBtur\fR
 .RE
+.
+.
 .TP
 .B alias_prefix
 The \fIuser_friendly_names\fR prefix.
@@ -343,6 +385,8 @@ The \fIuser_friendly_names\fR prefix.
 .TP
 Default value is: \fBmpath\fR
 .RE
+.
+.
 .TP
 .B failback
 Tell multipathd how to manage path group failback.
@@ -365,6 +409,8 @@ Deferred failback (time to defer in seconds).
 .TP
 Default value is: \fBmanual\fR
 .RE
+.
+.
 .TP
 .B  rr_min_io
 The number of IO to route to a path before switching to the next in
@@ -373,6 +419,8 @@ the same path group. This is only for BIO based multipath.
 .TP
 Default value is: \fB1000\fR
 .RE
+.
+.
 .TP
 .B rr_min_io_rq
 The number of IO requests to route to a path before switching to the
@@ -381,6 +429,8 @@ next in the same path group. This is only for request based multipath.
 .TP
 Default value is: \fB1\fR
 .RE
+.
+.
 .TP
 .B max_fds
 Specify the maximum number of file descriptors that can be opened by multipath
@@ -393,6 +443,8 @@ if that number is greated than 1024.
 .TP
 Default value is: \fBmax\fR
 .RE
+.
+.
 .TP
 .B rr_weight
 If set to \fIpriorities\fR the multipath configurator will assign
@@ -404,6 +456,8 @@ or
 .TP
 Default value is: \fBuniform\fR
 .RE
+.
+.
 .TP
 .B no_path_retry
 Specify the number of retries until disable queueing, or
@@ -415,6 +469,8 @@ for never stop queueing. If unset no queueing is attempted.
 .TP
 Default value is: \fB<unset>\fR
 .RE
+.
+.
 .TP
 .B queue_without_daemon
 If set to
@@ -431,6 +487,8 @@ cannot be told to stop queueing IO. Setting queue_without_daemon to
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B checker_timeout
 Specify the timeout to use for path checkers and prioritizers that issue SCSI
@@ -439,6 +497,8 @@ commands with an explicit timeout, in seconds.
 .TP
 Default value is: in \fB/sys/block/sd<x>/device/timeout\fR
 .RE
+.
+.
 .TP
 .B flush_on_last_del
 If set to
@@ -449,6 +509,8 @@ deleted.
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B user_friendly_names
 If set to
@@ -462,6 +524,8 @@ be overridden by any specific aliases in the \fImultipaths\fR section.
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B fast_io_fail_tmo
 Specify the number of seconds the SCSI layer will wait after a problem has been
@@ -473,6 +537,8 @@ will disable the timeout.
 .TP
 Default value is: in \fB5\fR
 .RE
+.
+.
 .TP
 .B dev_loss_tmo
 Specify the number of seconds the SCSI layer will wait after a problem has
@@ -489,6 +555,8 @@ is not set.
 .TP
 Default value is: \fB600\fR
 .RE
+.
+.
 .TP
 .B bindings_file
 The full pathname of the binding file to be used when the user_friendly_names option is set.
@@ -496,6 +564,8 @@ The full pathname of the binding file to be used when the user_friendly_names op
 .TP
 Default value is: \fB/etc/multipath/bindings\fR
 .RE
+.
+.
 .TP
 .B wwids_file
 The full pathname of the WWIDs file, which is used by multipath to keep track
@@ -504,6 +574,8 @@ of the WWIDs for LUNs it has created multipath devices on in the past.
 .TP
 Default value is: \fB/etc/multipath/wwids\fR
 .RE
+.
+.
 .TP
 .B log_checker_err
 If set to
@@ -516,6 +588,8 @@ errors are logged at level 3 until the device is restored. If set to
 .TP
 Default value is: \fBalways\fR
 .RE
+.
+.
 .TP
 .B reservation_key
 This is the service action reservation key used by mpathpersist. It must be
@@ -527,6 +601,8 @@ device server to identify the I_T nexus.
 .TP
 Default value is: \fB<unset>\fR
 .RE
+.
+.
 .TP
 .B retain_attached_hw_handler
 If set to
@@ -539,6 +615,8 @@ multipath will continue to use its configured hardware handler.
 .TP
 Default value is: \fByes\fR
 .RE
+.
+.
 .TP
 .B detect_prio
 If set to
@@ -553,6 +631,8 @@ attributes \fIaccess_state\fR and \fIpreferred_path\fR are supported, or the
 .TP
 Default value is: \fByes\fR
 .RE
+.
+.
 .TP
 .B force_sync
 If set to
@@ -564,6 +644,8 @@ multipathd checkers running in parallel causes significant CPU pressure.
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B strict_timinig
 If set to
@@ -578,6 +660,8 @@ seconds.
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B deferred_remove
 If set to
@@ -591,6 +675,8 @@ will be canceled.
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B partition_delimiter
 If this value is not set, when multipath renames a device, it will act just
@@ -601,6 +687,8 @@ the \fI-p\fR option is used, and always add delimiter.
 .TP
 Default value is: \fB<unset>\fR
 .RE
+.
+.
 .TP
 .B config_dir
 If set to anything other than "", multipath will search this directory
@@ -611,6 +699,8 @@ config_dir must either be "" or a fully qualified directory name.
 .TP
 Default value is: \fB/etc/multipath/conf.d/\fR
 .RE
+.
+.
 .TP
 .B delay_watch_checks
 If set to a value greater than 0, multipathd will watch paths that have
@@ -621,6 +711,8 @@ have stayed up for \fIdelay_wait_checks\fR checks.
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B delay_wait_checks
 If set to a value greater than 0, when a device that has recently come back
@@ -631,6 +723,8 @@ comes back online, it will marked and delayed, and not used until it has passed
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B find_multipaths
 If set to
@@ -656,6 +750,8 @@ multipath devices, without having to edit the blacklist.
 .TP
 Default value is: \fBno\fR
 .RE
+.
+.
 .TP
 .B uxsock_timeout
 CLI receive timeout in milliseconds. For larger systems CLI commands
@@ -668,6 +764,8 @@ those issues.
 .TP
 Default value is: \fB1000\fR
 .RE
+.
+.
 .TP
 .B retrigger_tries
 Sets the number of times multipathd will try to retrigger a uevent to get the
@@ -676,6 +774,8 @@ WWID.
 .TP
 Default value is: \fB3\fR
 .RE
+.
+.
 .TP
 .B retrigger_delay
 Sets the amount of time, in seconds, to wait between retriggers.
@@ -683,6 +783,8 @@ Sets the amount of time, in seconds, to wait between retriggers.
 .TP
 Default value is: \fB10\fR
 .RE
+.
+.
 .TP
 .B missing_uev_wait_timeout
 Controls how many seconds multipathd will wait, after a new multipath device
@@ -694,14 +796,19 @@ on a device until it receives a change uevent from the initial table load.
 Default value is: \fB30\fR
 .RE
 .
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist section"
 .\" ----------------------------------------------------------------------------
+.
 The \fIblacklist\fR
 section is used to exclude specific device from inclusion in the
 multipath topology. It is most commonly used to exclude local disks or
 LUNs for the array controller.
 .LP
+.
+.
 The following keywords are recognized:
 .TP 17
 .B devnode
@@ -720,15 +827,20 @@ and
 .B product
 keywords. For a full description of these keywords please see the
 \fIdevices\fR section description.
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist_exceptions section"
 .\" ----------------------------------------------------------------------------
+.
 The \fIblacklist_exceptions\fR section is used to revert the actions of the
 \fIblacklist\fR section, for example to include specific device in the
 multipath topology. This allows one to selectively include devices which
 would normally be excluded via the \fIblacklist\fR
 section.
 .LP
+.
+.
 The following keywords are recognized:
 .TP 17
 .B devnode
@@ -756,12 +868,17 @@ The \fIproperty\fR blacklist and whitelist handling is different from the usual
 handling in the sense that the whitelist \fIhas\fR to be set, otherwise the
 device will be blacklisted. In these cases the message \fIblacklisted, udev
 property missing\fR will be displayed.
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "multipaths section"
 .\" ----------------------------------------------------------------------------
+.
 The only recognized attribute for the \fImultipaths\fR section is the
 \fImultipath\fR subsection.
 .LP
+.
+.
 The \fImultipath\fR subsection recognizes the following attributes:
 .TP 17
 .B wwid
@@ -770,6 +887,8 @@ The \fImultipath\fR subsection recognizes the following attributes:
 .B alias
 Symbolic name for the multipath map.
 .LP
+.
+.
 The following attributes are optional; if not set the default values
 are taken from the \fIdefaults\fR or \fIdevices\fR
 section:
@@ -811,12 +930,17 @@ section:
 .RE
 .PD
 .LP
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "devices section"
 .\" ----------------------------------------------------------------------------
+.
 The only recognized attribute for the \fIdevices\fR section is the \fIdevice\fR
 subsection.
 .LP
+.
+.
 The \fIdevice\fR subsection recognizes the following attributes:
 .TP 17
 .B vendor
@@ -860,6 +984,8 @@ Hardware handler for SCSI-3 ALUA compatible arrays.
 .TP
 Default value is: \fB<unset>\fR
 .RE
+.
+.
 .LP
 The following attributes are optional; if not set the default values
 are taken from the \fIdefaults\fR
@@ -910,9 +1036,12 @@ section:
 .RE
 .PD
 .LP
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "overrides section"
 .\" ----------------------------------------------------------------------------
+.
 The overrides section recognizes the following optional attributes; if not set
 the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .sp 1
@@ -967,9 +1096,12 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .RE
 .PD
 .LP
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "WWID generation"
 .\" ----------------------------------------------------------------------------
+.
 Multipath uses a \fIWorld Wide Identification\fR (WWID) to determine
 which paths belong to the same device. Each path presenting the same
 WWID is assumed to point to the same device.
@@ -993,9 +1125,12 @@ variable.
 If none of the \fIgetuid_callout\fR or \fIuid_attribute\fR parameters
 are present multipath will try to use the sysfs attribute
 \fIvpd_pg83\fR to generate the WWID.
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "KNOWN ISSUES"
 .\" ----------------------------------------------------------------------------
+.
 The usage of \fIqueue_if_no_path\fR option can lead to \fID state\fR
 processes being hung and not killable in situations where all the paths to the
 LUN go offline. It is advisable to use the \fIno_path_retry\fR option instead.
@@ -1005,17 +1140,21 @@ deadlock if the \fIdev_loss_tmo\fR setting results in a device being removed
 while I/O is still queued. The multipath daemon will update the \fIdev_loss_tmo\fR
 setting accordingly to avoid this deadlock. Hence if both values are
 specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_loss_tmo.\fR
-
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
 .\" ----------------------------------------------------------------------------
+.
 .BR udev (8),
 .BR dmsetup (8),
 .BR multipath (8),
 .BR multipathd (8).
-
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH AUTHORS
 .\" ----------------------------------------------------------------------------
+.
 \fImultipath-tools\fR was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com>
 and others.
-- 
2.7.4
