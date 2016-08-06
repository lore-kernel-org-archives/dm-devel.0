From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/7] multipath-tools: replace ".I" with \fIxxx\R
	at multipath.conf.5
Date: Sun,  7 Aug 2016 00:40:03 +0200
Message-ID: <1470523208-14067-2-git-send-email-xose.vazquez@gmail.com>
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

Leave ".I" only for values of keywords, now the layout is clearer. Also correct
some minor inconsistencies.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 199 ++++++++++++++-------------------------------
 1 file changed, 62 insertions(+), 137 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c4a5bd4..ed5dd10 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -52,8 +52,7 @@ multipath topology discovery.
 .B blacklist_exceptions
 This section defines which devices should be included in the
 multipath topology discovery, despite being listed in the
-.I blacklist
-section.
+\fIblacklist\fR section.
 .TP
 .B multipaths
 This section defines the multipath topologies. They are indexed by a
@@ -69,9 +68,7 @@ device-specific settings for all devices.
 .RE
 .LP
 .SH "defaults section"
-The
-.I defaults
-section recognizes the following keywords:
+The \fIdefaults\fR section recognizes the following keywords:
 .TP 17
 .B verbosity
 Default verbosity. Higher values increase the verbosity level. Valid
@@ -83,10 +80,8 @@ Default value is: \fB2\fR
 .TP
 .B polling_interval
 Interval between two path checks in seconds. For properly functioning paths,
-the interval between checks will gradually increase to
-.I max_polling_interval.
-This value will be overridden by the
-.I WatchdogSec
+the interval between checks will gradually increase to \fImax_polling_interval\fR.
+This value will be overridden by the \fIWatchdogSec\fR
 setting in the multipathd.service definition if systemd is used.
 .RS
 .TP
@@ -179,8 +174,7 @@ identifier. Should be specified with an absolute path.
 The name of the path priority routine. The specified routine
 should return a numeric value specifying the relative priority
 of this path. Higher number have a higher priority.
-.I "none"
-is a valid value. Currently the following path priority routines
+\fI"none"\fR is a valid value. Currently the following path priority routines
 are implemented:
 .RS
 .TP 12
@@ -190,7 +184,7 @@ Return a constant priority of \fI1\fR.
 .I sysfs
 Use the sysfs attributes \fIaccess_state\fR and \fIpreferred_path\fR to
 generate the path priority. This prioritizer accepts the optional prio_arg
-.I exclusive_pref_bit
+\fIexclusive_pref_bit\fR
 .TP
 .I emc
 (Hardware-dependent)
@@ -222,7 +216,7 @@ Generate the path priority for Hitachi HDS Modular storage arrays.
 .TP
 .I random
 Generate a random priority between 1 and 10.
-.TP 12
+.TP
 .I weightedpath
 Generate the path priority based on the regular expression and the
 priority provided as argument. Requires prio_args keyword.
@@ -243,7 +237,7 @@ prioritizers:
 .TP 12
 .I weighted
 Needs a value of the form
-.I "<hbtl|devname|serial|wwn> <regex1> <prio1> <regex2> <prio2> ..."
+\fI"<hbtl|devname|serial|wwn> <regex1> <prio1> <regex2> <prio2> ..."\fR
 .RS
 .TP 8
 .I hbtl
@@ -256,42 +250,32 @@ regex can be of device name format  Ex: sda , sd.e
 regex can be of serial number format  Ex: .*J1FR.*324  The serial can be looked up through sysfs or by running multipathd show paths format "%z" Ex: 0395J1FR904324
 .TP
 .I wwn
-regex can be of the form
-.I "host_wwnn:host_wwpn:target_wwnn:target_wwpn"
-these values can be looked up through sysfs or by running
-.I multipathd show paths format "%N:%R:%n:%r" Ex: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
+regex can be of the form \fI"host_wwnn:host_wwpn:target_wwnn:target_wwpn"\fR
+these values can be looked up through sysfs or by running \fImultipathd show paths format
+"%N:%R:%n:%r" Ex: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*\fR
 .RE
 .TP 12
 .I alua
-If
-.I exclusive_pref_bit
-is set, paths with the \fIpreferred path\fR bit set will always
-be in their own path group.
+If \fIexclusive_pref_bit\fR is set, paths with the \fIpreferred path\fR bit
+set will always be in their own path group.
 .TP
 .I datacore
-.I preferredsds
-???.
+\fIpreferredsds\fR ???.
 .TP
 .I iet
-.I preferredip
-???.
+\fIpreferredip\fR ???.
 .TP
 Default value is: \fB<unset>\fR
 .RE
 .TP
 .B features
-Specify any device-mapper features to be used. Syntax is
-.I num list
-where
-.I num
-is the number, between 0 and 6, of features in
-.I list.
+Specify any device-mapper features to be used. Syntax is \fInum list\fR
+where \fInum\fR is the number, between 0 and 6, of features in \fIlist\fR.
 Possible values for the feature list are:
 .RS
 .TP 12
 .I queue_if_no_path
-Queue IO if no path is active; identical to the
-.I no_path_retry
+Queue IO if no path is active; identical to the \fIno_path_retry\fR
 keyword.
 .TP
 .I no_partitions
@@ -316,9 +300,7 @@ are:
 deprecated, please use \fItur\fR instead.
 .TP
 .I tur
-Issue a
-.I TEST UNIT READY
-command to the device.
+Issue a \fITEST UNIT READY\fR command to the device.
 .TP
 .I emc_clariion
 (Hardware-dependent)
@@ -394,7 +376,7 @@ Default value is: \fB1\fR
 .TP
 .B max_fds
 Specify the maximum number of file descriptors that can be opened by multipath
-and multipathd.  This is equivalent to ulimit \-n. A value of \fImax\fR will set
+and multipathd. This is equivalent to ulimit \-n. A value of \fImax\fR will set
 this to the system limit from \fI/proc/sys/fs/nr_open\fR. If this is not set, the
 maximum number of open fds is taken from the calling process. It is usually
 1024. To be safe, this should be set to the maximum number of paths plus 32,
@@ -409,7 +391,7 @@ If set to \fIpriorities\fR the multipath configurator will assign
 path weights as "path prio * rr_min_io". Possible values are
 .I priorities
 or
-.IR uniform .
+.I uniform .
 .RS
 .TP
 Default value is: \fBuniform\fR
@@ -430,7 +412,7 @@ Default value is: \fB<unset>\fR
 If set to
 .I no
 , when multipathd stops, queueing will be turned off for all devices.
-This is useful for devices that set no_path_retry.  If a machine is
+This is useful for devices that set no_path_retry. If a machine is
 shut down while all paths to a device are down, it is possible to hang waiting
 for IO to return from the device after multipathd has been stopped. Without
 multipathd running, access to the paths cannot be restored, and the kernel
@@ -463,10 +445,8 @@ Default value is: \fBno\fR
 .B user_friendly_names
 If set to
 .I yes
-, using the bindings file
-.I /etc/multipath/bindings
-to assign a persistent and unique alias to the multipath, in the form of mpath<n>.
-If set to
+, using the bindings file \fI/etc/multipath/bindings\fR to assign a persistent
+and unique alias to the multipath, in the form of mpath<n>. If set to
 .I no
 use the WWID as the alias. In either case this be will
 be overridden by any specific aliases in the \fImultipaths\fR section.
@@ -530,7 +510,7 @@ Default value is: \fBalways\fR
 .RE
 .TP
 .B reservation_key
-This is the service action reservation key used by mpathpersist.  It must be
+This is the service action reservation key used by mpathpersist. It must be
 set for all multipath devices using persistent reservations, and it must be
 the same as the RESERVATION KEY field of the PERSISTENT RESERVE OUT parameter
 list which contains an 8-byte value provided by the application client to the
@@ -556,15 +536,9 @@ Default value is: \fByes\fR
 If set to
 .I yes
 , multipath will try to detect if the device supports SCSI-3 ALUA. If so, the
-device will automatically use the
-.I sysfs
-prioritizer if the required sysfs attributes
-.I access_state
-and
-.I preferred_path
-are supported, or the
-.I alua
-prioritizer if not. If set to
+device will automatically use the \fIsysfs\fR prioritizer if the required sysf
+attributes \fIaccess_state\fR and \fIpreferred_path\fR are supported, or the
+\fIalua\fR prioritizer if not. If set to
 .I no
 , the prioritizer will be selected as usual.
 .RS
@@ -587,12 +561,10 @@ Default value is: \fBno\fR
 If set to
 .I yes
 , multipathd will start a new path checker loop after exactly one second,
-so that each path check will occur at exactly
-.I polling_interval
+so that each path check will occur at exactly \fIpolling_interval\fR
 seconds. On busy systems path checks might take longer than one second;
 here the missing ticks will be accounted for on the next round.
-A warning will be printed if path checks take longer than
-.I polling_interval
+A warning will be printed if path checks take longer than \fIpolling_interval\fR
 seconds.
 .RS
 .TP
@@ -634,11 +606,9 @@ Default value is: \fB/etc/multipath/conf.d/\fR
 .TP
 .B delay_watch_checks
 If set to a value greater than 0, multipathd will watch paths that have
-recently become valid for this many checks.  If they fail again while they are
+recently become valid for this many checks. If they fail again while they are
 being watched, when they next become valid, they will not be used until they
-have stayed up for
-.I delay_wait_checks
-checks.
+have stayed up for \fIdelay_wait_checks\fR checks.
 .RS
 .TP
 Default value is: \fBno\fR
@@ -646,12 +616,9 @@ Default value is: \fBno\fR
 .TP
 .B delay_wait_checks
 If set to a value greater than 0, when a device that has recently come back
-online fails again within
-.I delay_watch_checks
-checks, the next time it comes back online, it will marked and delayed, and not
-used until it has passed
-.I delay_wait_checks
-checks.
+online fails again within \fIdelay_watch_checks\fR checks, the next time it
+comes back online, it will marked and delayed, and not used until it has passed
+\fIdelay_wait_checks\fR checks.
 .RS
 .TP
 Default value is: \fBno\fR
@@ -720,8 +687,7 @@ Default value is: \fB30\fR
 .RE
 .
 .SH "blacklist section"
-The
-.I blacklist
+The \fIblacklist\fR
 section is used to exclude specific device from inclusion in the
 multipath topology. It is most commonly used to exclude local disks or
 LUNs for the array controller.
@@ -743,17 +709,12 @@ Subsection for the device description. This subsection recognizes the
 and
 .B product
 keywords. For a full description of these keywords please see the
-.I devices
-section description.
+\fIdevices\fR section description.
 .SH "blacklist_exceptions section"
-The
-.I blacklist_exceptions
-section is used to revert the actions of the
-.I blacklist
-section, for example to include specific device in the
+The \fIblacklist_exceptions\fR section is used to revert the actions of the
+\fIblacklist\fR section, for example to include specific device in the
 multipath topology. This allows one to selectively include devices which
-would normally be excluded via the
-.I blacklist
+would normally be excluded via the \fIblacklist\fR
 section.
 .LP
 The following keywords are recognized:
@@ -776,29 +737,18 @@ Subsection for the device description. This subsection recognizes the
 .B vendor
 and
 .B product
-keywords. For a full description of these keywords please see the
-.I devices
+keywords. For a full description of these keywords please see the \fIdevices\fR
 section description.
 .LP
-The
-.I property
-blacklist and whitelist handling is different from the usual handling
-in the sense that the whitelist
-.I has
-to be set, otherwise the device will be blacklisted.
-In these cases the message
-.I blacklisted, udev property missing
-will be displayed.
+The \fIproperty\fR blacklist and whitelist handling is different from the usual
+handling in the sense that the whitelist \fIhas\fR to be set, otherwise the
+device will be blacklisted. In these cases the message \fIblacklisted, udev
+property missing\fR will be displayed.
 .SH "multipaths section"
-The only recognized attribute for the
-.I multipaths
-section is the
-.I multipath
-subsection.
+The only recognized attribute for the \fImultipaths\fR section is the
+\fImultipath\fR subsection.
 .LP
-The
-.I multipath
-subsection recognizes the following attributes:
+The \fImultipath\fR subsection recognizes the following attributes:
 .TP 17
 .B wwid
 (Mandatory) Index of the container.
@@ -807,10 +757,7 @@ subsection recognizes the following attributes:
 Symbolic name for the multipath map.
 .LP
 The following attributes are optional; if not set the default values
-are taken from the
-.I defaults
-or
-.I devices
+are taken from the \fIdefaults\fR or \fIdevices\fR
 section:
 .sp 1
 .PD .1v
@@ -851,15 +798,10 @@ section:
 .PD
 .LP
 .SH "devices section"
-The only recognized attribute for the
-.I devices
-section is the
-.I device
+The only recognized attribute for the \fIdevices\fR section is the \fIdevice\fR
 subsection.
 .LP
-The
-.I device
-subsection recognizes the following attributes:
+The \fIdevice\fR subsection recognizes the following attributes:
 .TP 17
 .B vendor
 (Mandatory) Vendor identifier.
@@ -904,8 +846,7 @@ Default value is: \fB<unset>\fR
 .RE
 .LP
 The following attributes are optional; if not set the default values
-are taken from the
-.I defaults
+are taken from the \fIdefaults\fR
 section:
 .sp 1
 .PD .1v
@@ -955,11 +896,7 @@ section:
 .LP
 .SH "overrides section"
 The overrides section recognizes the following optional attributes; if not set
-the values are taken from the
-.I devices
-or
-.I defaults
-sections:
+the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .sp 1
 .PD .1v
 .RS
@@ -1037,27 +974,15 @@ If none of the \fIgetuid_callout\fR or \fIuid_attribute\fR parameters
 are present multipath will try to use the sysfs attribute
 \fIvpd_pg83\fR to generate the WWID.
 .SH "KNOWN ISSUES"
-The usage of
-.I queue_if_no_path
-option can lead to
-.I D state
-processes being hung and not killable in situations where all the paths to the LUN go offline.
-It is advisable to use the
-.I no_path_retry
-option instead.
+The usage of \fIqueue_if_no_path\fR option can lead to \fID state\fR
+processes being hung and not killable in situations where all the paths to the
+LUN go offline. It is advisable to use the \fIno_path_retry\fR option instead.
 .P
-The use of
-.I queue_if_no_path
-or
-.I no_path_retry
-might lead to a deadlock if the
-.I dev_loss_tmo
-setting results in a device being removed while I/O is still queued.
-The multipath daemon will update the
-.I dev_loss_tmo
+The use of \fIqueue_if_no_path\fR or \fIno_path_retry\fR might lead to a
+deadlock if the \fIdev_loss_tmo\fR setting results in a device being removed
+while I/O is still queued. The multipath daemon will update the \fIdev_loss_tmo\fR
 setting accordingly to avoid this deadlock. Hence if both values are
-specified the order of precedence is
-.I no_path_retry, queue_if_no_path, dev_loss_tmo.
+specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_loss_tmo.\fR
 
 .SH "SEE ALSO"
 .BR udev (8),
@@ -1066,5 +991,5 @@ specified the order of precedence is
 .BR multipathd (8).
 
 .SH AUTHORS
-.I multipath-tools
-was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
+\fImultipath-tools\fR was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com>
+and others.
-- 
2.7.4
