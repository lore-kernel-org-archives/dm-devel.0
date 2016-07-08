From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 14/14] multipath-tools: minor edit of
	multipath/multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:59 +0200
Message-ID: <1468000199-15566-15-git-send-email-xose.vazquez@gmail.com>
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

Add final colons and dots, acronyms in uppercase, s/1/One, ...

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 121 ++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 61 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 3e1a6db..794275e 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,8 +1,8 @@
-.TH MULTIPATH.CONF 5 2016-07-06 "Linux"
+.TH MULTIPATH.CONF 5 2016-07-08 "Linux"
 .SH NAME
-multipath.conf \- multipath daemon configuration file
+multipath.conf \- multipath daemon configuration file.
 .SH DESCRIPTION
-.B "multipath.conf"
+.B "/etc/multipath.conf"
 is the configuration file for the multipath daemon. It is used to
 overwrite the built-in configuration table of \fBmultipathd\fP.
 Any line whose first non-white-space character is a '#' is considered
@@ -57,7 +57,7 @@ section.
 .TP
 .B multipaths
 This section defines the multipath topologies. They are indexed by a
-\fIWorld Wide Identifier\fR(wwid). For details on the wwid generation
+\fIWorld Wide Identifier\fR(WWID). For details on the WWID generation
 see section \fIWWID generation\fR below.
 .TP
 .B devices
@@ -74,7 +74,7 @@ The
 section recognizes the following keywords:
 .TP 17
 .B polling_interval
-interval between two path checks in seconds. For properly functioning paths,
+Interval between two path checks in seconds. For properly functioning paths,
 the interval between checks will gradually increase to
 .I max_polling_interval.
 This value will be overridden by the
@@ -86,17 +86,17 @@ Default value is: \fB5\fR
 .RE
 .TP
 .B max_polling_interval
-maximal interval between two path checks in seconds.
+Maximal interval between two path checks in seconds.
 .RS
 .TP
 Default value is: \fB4 * polling_interval\fR
 .RE
 .TP
 .B multipath_dir
-directory where the dynamic shared objects are stored.
+Directory where the dynamic shared objects are stored.
 .RS
 .TP
-Default value is: \fB<system dependent>\fR, commonly /lib64/multipath/
+Default value is: \fB<system dependent>\fR, commonly \fI/lib64/multipath/\fR
 .RE
 .TP
 .B find_multipaths
@@ -106,7 +106,7 @@ If set to
 path, multipath will only create a device if one of three condidions are
 met.
 .I 1
-There are at least two non-blacklisted paths with the same wwid,
+There are at least two non-blacklisted paths with the same WWID,
 .I 2
 the user manually forces the creation, by specifying a device with the multipath
 command, or
@@ -125,7 +125,7 @@ Default value is: \fBno\fR
 .RE
 .TP
 .B verbosity
-default verbosity. Higher values increase the verbosity level. Valid
+Default verbosity. Higher values increase the verbosity level. Valid
 levels are between 0 and 6.
 .RS
 .TP
@@ -133,7 +133,7 @@ Default value is: \fB2\fR
 .RE
 .TP
 .B reassign_maps
-enable reassigning of device-mapper maps. With this option multipathd
+Enable reassigning of device-mapper maps. With this option multipathd
 will remap existing device-mapper maps to always point to multipath
 device, not the underlying block devices. Possible values are
 \fIyes\fR and \fIno\fR.
@@ -144,7 +144,7 @@ Default value is: \fBno\fR
 .TP
 .B path_selector
 The default path selector algorithm to use; they are offered by the
-kernel multipath target. There are three selector algorithms.
+kernel multipath target. There are three selector algorithms:
 .RS
 .TP 12
 .I "round-robin 0"
@@ -163,26 +163,26 @@ Default value is: \fBservice-time 0\fR
 .TP
 .B path_grouping_policy
 The default path grouping policy to apply to unspecified
-multipaths. Possible values are
+multipaths. Possible values are:
 .RS
 .TP 12
 .I failover
-1 path per priority group
+One path per priority group.
 .TP
 .I multibus
-all paths in 1 priority group
+All paths in one priority group.
 .TP
 .I group_by_serial
-1 priority group per serial number
+One priority group per serial number.
 .TP
 .I group_by_prio
-1 priority group per priority value. Priorities are determined by
+One priority group per priority value. Priorities are determined by
 callout programs specified as a global, per-controller or
 per-multipath option in the configuration file.
 .TP
 .I group_by_node_name
-1 priority group per target node name. Target node names are fetched
-in /sys/class/fc_transport/target*/node_name.
+One priority group per target node name. Target node names are fetched
+in \fI/sys/class/fc_transport/target*/node_name\fR.
 .TP
 Default value is: \fBfailover\fR
 .RE
@@ -195,9 +195,8 @@ Default value is: \fBID_SERIAL\fR
 .RE
 .TP
 .B getuid_callout
-The default program and args to callout to obtain a unique path
+(Deprecated) The default program and args to callout to obtain a unique path
 identifier. Should be specified with an absolute path.
-This parameter is deprecated.
 .TP
 .B prio
 The name of the path priority routine. The specified routine
@@ -219,8 +218,7 @@ EMC VNX families.
 .I alua
 (Hardware-dependent)
 Generate the path priority based on the SCSI-3 ALUA settings. This prioritizer
-accepts the optional prio_arg
-.I exclusive_pref_bit
+accepts the optional prio_arg \fIexclusive_pref_bit\fR.
 .TP
 .I ontap
 (Hardware-dependent)
@@ -245,7 +243,7 @@ Generate a random priority between 1 and 10.
 .TP 12
 .I weightedpath
 Generate the path priority based on the regular expression and the
-priority provided as argument. requires prio_args keyword.
+priority provided as argument. Requires prio_args keyword.
 .TP
 .I datacore
 ???. Requires prio_args keyword.
@@ -258,7 +256,7 @@ Default value is: \fBconst\fR
 .TP
 .B prio_args
 Arguments to pass to to the prio function. This only applies to certain
-prioritizers
+prioritizers:
 .RS
 .TP 12
 .I weighted
@@ -282,11 +280,11 @@ group.
 .TP
 .I datacore
 .I preferredsds
-???
+???.
 .TP
 .I iet
 .I preferredip
-???
+???.
 .TP
 Default value is: \fB<unset>\fR
 .RE
@@ -320,12 +318,12 @@ Default value is: \fB0\fR
 .TP
 .B path_checker
 The default method used to determine the paths state. Possible values
-are
+are:
 .RS
 .TP 12
 .I readsector0
 (Deprecated) Read the first sector of the device. This checker is being
-deprecated, please use \fItur\fR instead
+deprecated, please use \fItur\fR instead.
 .TP
 .I tur
 Issue a
@@ -349,7 +347,7 @@ Series, and OEM arrays from IBM DELL SGI STK and SUN.
 .TP
 .I directio
 (Deprecated) Read the first sector with direct I/O. This checker is being
-deprecated, it will cause spurious path failures under high load.
+deprecated, it could cause spurious path failures under high load.
 Please use \fItur\fR instead.
 .TP
 .I cciss_tur
@@ -383,7 +381,7 @@ becomes active. This keeps a node from automatically failing back when
 another node requested the failover.
 .TP
 .I values > 0
-deferred failback (time to defer in seconds)
+Deferred failback (time to defer in seconds).
 .TP
 Default value is: \fBmanual\fR
 .RE
@@ -454,7 +452,7 @@ Default value is: \fBno\fR
 .B max_fds
 Specify the maximum number of file descriptors that can be opened by multipath
 and multipathd.  This is equivalent to ulimit \-n. A value of \fImax\fR will set
-this to the system limit from /proc/sys/fs/nr_open. If this is not set, the
+this to the system limit from \fI/proc/sys/fs/nr_open\fR. If this is not set, the
 maximum number of open fds is taken from the calling process. It is usually
 1024. To be safe, this should be set to the maximum number of paths plus 32,
 if that number is greated than 1024.
@@ -464,7 +462,7 @@ Default value is: \fBmax\fR
 .RE
 .TP
 .B checker_timeout
-Specify the timeout to use for path checkers and prioritizers that issue scsi
+Specify the timeout to use for path checkers and prioritizers that issue SCSI
 commands with an explicit timeout, in seconds.
 .RS
 .TP
@@ -472,7 +470,7 @@ Default value is: in \fB/sys/block/sd<x>/device/timeout\fR
 .RE
 .TP
 .B fast_io_fail_tmo
-Specify the number of seconds the scsi layer will wait after a problem has been
+Specify the number of seconds the SCSI layer will wait after a problem has been
 detected on a FC remote port before failing IO to devices on that remote port.
 This should be smaller than dev_loss_tmo. Setting this to
 .I off
@@ -483,7 +481,7 @@ Default value is: in \fB5\fR
 .RE
 .TP
 .B dev_loss_tmo
-Specify the number of seconds the scsi layer will wait after a problem has
+Specify the number of seconds the SCSI layer will wait after a problem has
 been detected on a FC remote port before removing it from the system. This
 can be set to "infinity" which sets it to the max value of 2147483647
 seconds, or 68 years. It will be automatically adjusted to the overall
@@ -491,7 +489,7 @@ retry interval
 \fIno_path_retry\fR * \fIpolling_interval\fR
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
-The linux kernel will cap this value to \fI300\fR if \fIfast_io_fail_tmo\fR
+The Linux kernel will cap this value to \fI300\fR if \fIfast_io_fail_tmo\fR
 is not set.
 .RS
 .TP
@@ -522,8 +520,8 @@ Default value is: \fB/etc/multipath/bindings\fR
 .RE
 .TP
 .B wwids_file
-The full pathname of the wwids file, which is used by multipath to keep track
-of the wwids for LUNs it has created multipath devices on in the past.
+The full pathname of the WWIDs file, which is used by multipath to keep track
+of the WWIDs for LUNs it has created multipath devices on in the past.
 .RS
 .TP
 Default value is: \fB/etc/multipath/wwids\fR
@@ -555,9 +553,9 @@ Default value is: \fB<unset>\fR
 .B retain_attached_hw_handler
 If set to
 .I yes
-and the scsi layer has already attached a hardware_handler to the device,
+and the SCSI layer has already attached a hardware_handler to the device,
 multipath will not force the device to use the hardware_handler specified by
-mutipath.conf. If the scsi layer has not attached a hardware handler,
+mutipath.conf. If the SCSI layer has not attached a hardware handler,
 multipath will continue to use its configured hardware handler.
 .RS
 .TP
@@ -567,8 +565,8 @@ Default value is: \fBno\fR
 .B detect_prio
 If set to
 .I yes
-, multipath will try to detect if the device supports ALUA. If so, the device
-will automatically use the
+, multipath will try to detect if the device supports SCSI-3 ALUA. If so, the
+device will automatically use the
 .I alua
 prioritizer. If not, the prioritizer will be selected as usual.
 .RS
@@ -613,8 +611,8 @@ Default value is: \fB<unset>\fR
 .B config_dir
 If set to anything other than "", multipath will search this directory
 alphabetically for file ending in ".conf" and it will read configuration
-information from them, just as if it was in /etc/multipath.conf.  config_dir
-must either be "" or a fully qualified directory name.
+information from them, just as if it was in \fI/etc/multipath.conf\fR.
+config_dir must either be "" or a fully qualified directory name.
 .RS
 .TP
 Default value is: \fB/etc/multipath/conf.d/\fR
@@ -714,7 +712,7 @@ The
 .I blacklist_exceptions
 section is used to revert the actions of the
 .I blacklist
-section, ie to include specific device in the
+section, for example to include specific device in the
 multipath topology. This allows one to selectively include devices which
 would normally be excluded via the
 .I blacklist
@@ -765,10 +763,10 @@ The
 subsection recognizes the following attributes:
 .TP 17
 .B wwid
-Index of the container. Mandatory for this subsection.
+(Mandatory) Index of the container.
 .TP
 .B alias
-(Optional) symbolic name for the multipath map.
+(Optional) Symbolic name for the multipath map.
 .LP
 The following attributes are optional; if not set the default values
 are taken from the
@@ -824,20 +822,20 @@ The
 subsection recognizes the following attributes:
 .TP 17
 .B vendor
-(Mandatory) Vendor identifier
+(Mandatory) Vendor identifier.
 .TP
 .B product
-(Mandatory) Product identifier
+(Mandatory) Product identifier.
 .TP
 .B revision
-(Optional) Revision identfier
+(Optional) Revision identfier.
 .TP
 .B product_blacklist
-(Optional) Product strings to blacklist for this vendor
+(Optional) Product strings to blacklist for this vendor.
 .TP
 .B alias_prefix
 (Optional) The user_friendly_names prefix to use for this
-device type, instead of the default "mpath"
+device type, instead of the default "mpath".
 .TP
 .B hardware_handler
 (Optional) The hardware handler to use for this device type.
@@ -975,11 +973,11 @@ sections:
 .PD
 .LP
 .SH "WWID generation"
-Multipath uses a \fIWorld Wide Identification\fR (wwid) to determine
+Multipath uses a \fIWorld Wide Identification\fR (WWID) to determine
 which paths belong to the same device. Each path presenting the same
-wwid is assumed to point to the same device.
+WWID is assumed to point to the same device.
 .LP
-The wwid is generated by three methods (in the order of preference):
+The WWID is generated by three methods (in the order of preference):
 .TP 17
 .B getuid_callout
 Use the specified external program; cf \fIgetuid_callout\fR above.
@@ -997,7 +995,7 @@ variable.
 .B vpd_pg83
 If none of the \fIgetuid_callout\fR or \fIuid_attribute\fR parameters
 are present multipath will try to use the sysfs attribute
-\fIvpd_pg83\fR to generate the wwid.
+\fIvpd_pg83\fR to generate the WWID.
 .SH "KNOWN ISSUES"
 The usage of
 .I queue_if_no_path
@@ -1019,13 +1017,14 @@ The multipath daemon will update the
 .I dev_loss_tmo
 setting accordingly to avoid this deadlock. Hence if both values are
 specified the order of precedence is
-.I no_path_retry, queue_if_no_path, dev_loss_tmo
+.I no_path_retry, queue_if_no_path, dev_loss_tmo.
 
 .SH "SEE ALSO"
 .BR udev (8),
-.BR dmsetup (8)
-.BR multipath (8)
-.BR multipathd (8)
+.BR dmsetup (8),
+.BR multipath (8),
+.BR multipathd (8).
+
 .SH AUTHORS
-.I multipath
+.I multipath-tools
 was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
-- 
2.7.4
