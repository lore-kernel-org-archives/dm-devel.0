From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 01/14] multipath-tools: replace bold<->italic in
	multipath.conf.5
Date: Fri,  8 Jul 2016 19:49:46 +0200
Message-ID: <1468000199-15566-2-git-send-email-xose.vazquez@gmail.com>
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

Do it more readable.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 116 +++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 57 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b85ea14..c7a2f1b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,4 +1,4 @@
-.TH MULTIPATH.CONF 5 2016-07-03 "Linux"
+.TH MULTIPATH.CONF 5 2016-07-06 "Linux"
 .SH NAME
 multipath.conf \- multipath daemon configuration file
 .SH DESCRIPTION
@@ -25,8 +25,10 @@ The configuration file contains entries of the form:
 <attribute> <value>
 .I "..."
 .RE
+.ft B
 }
 .RE
+.ft B
 }
 .ft R
 .fi
@@ -56,7 +58,7 @@ section.
 .B multipaths
 This section defines the multipath topologies. They are indexed by a
 \fIWorld Wide Identifier\fR(wwid). For details on the wwid generation
-see section \fBWWID generation\fR below.
+see section \fIWWID generation\fR below.
 .TP
 .B devices
 This section defines the device-specific settings.
@@ -68,15 +70,15 @@ device-specific settings for all devices.
 .LP
 .SH "defaults section"
 The
-.B defaults
+.I defaults
 section recognizes the following keywords:
 .TP 17
 .B polling_interval
 interval between two path checks in seconds. For properly functioning paths,
 the interval between checks will gradually increase to
-.B max_polling_interval.
+.I max_polling_interval.
 This value will be overridden by the
-.B WatchdogSec
+.I WatchdogSec
 setting in the multipathd.service definition if systemd is used.
 .RS
 .TP
@@ -145,14 +147,14 @@ The default path selector algorithm to use; they are offered by the
 kernel multipath target. There are three selector algorithms.
 .RS
 .TP 12
-.B "round-robin 0"
+.I "round-robin 0"
 Loop through every path in the path group, sending the same amount of IO to
 each.
 .TP
-.B "queue-length 0"
+.I "queue-length 0"
 Send the next bunch of IO down the path with the least amount of outstanding IO.
 .TP
-.B "service-time 0"
+.I "service-time 0"
 Choose the path for the next bunch of IO based on the amount of outstanding IO
 to the path and its relative throughput.
 .RE
@@ -162,21 +164,21 @@ The default path grouping policy to apply to unspecified
 multipaths. Possible values are
 .RS
 .TP 12
-.B failover
+.I failover
 1 path per priority group
 .TP
-.B multibus
+.I multibus
 all paths in 1 priority group
 .TP
-.B group_by_serial
+.I group_by_serial
 1 priority group per serial number
 .TP
-.B group_by_prio
+.I group_by_prio
 1 priority group per priority value. Priorities are determined by
 callout programs specified as a global, per-controller or
 per-multipath option in the configuration file.
 .TP
-.B group_by_node_name
+.I group_by_node_name
 1 priority group per target node name. Target node names are fetched
 in /sys/class/fc_transport/target*/node_name.
 .TP
@@ -204,34 +206,34 @@ is a valid value. Currently the following path priority routines
 are implemented:
 .RS
 .TP 12
-.B const
+.I const
 Return a constant priority of \fI1\fR.
 .TP
-.B emc
+.I emc
 Generate the path priority for EMC arrays.
 .TP
-.B alua
+.I alua
 Generate the path priority based on the SCSI-3 ALUA settings. This prioritizer
 accepts the optional prio_arg
 .I exclusive_pref_bit
 .TP
-.B ontap
+.I ontap
 Generate the path priority for NetApp arrays.
 .TP
-.B rdac
+.I rdac
 Generate the path priority for LSI/Engenio/NetApp E-Series RDAC controller.
 .TP
-.B hp_sw
+.I hp_sw
 Generate the path priority for Compaq/HP controller in
 active/standby mode.
 .TP
-.B hds
+.I hds
 Generate the path priority for Hitachi HDS Modular storage arrays.
 .TP
-.B random
+.I random
 Generate a random priority between 1 and 10.
 .TP 12
-.B weightedpath
+.I weightedpath
 Generate the path priority based on the regular expression and the
 priority provided as argument. requires prio_args keyword.
 .TP
@@ -243,7 +245,7 @@ Arguments to pass to to the prio function. This only applies to certain
 prioritizers
 .RS
 .TP 12
-.B weighted
+.I weighted
 Needs a value of the form
 .I "<hbtl|devname|wwn> <regex1> <prio1> <regex2> <prio2> ..."
 .I hbtl
@@ -256,7 +258,7 @@ regex can be of the form
 these values can be looked up through sysfs or by running
 .I mulitpathd show paths format "%N:%R:%n:%r" Ex: 0x200100e08ba0aea0:0x210100e08ba0aea0:.*:.* , .*:.*:iqn.2009-10.com.redhat.msp.lab.ask-06:.*
 .TP
-.B alua
+.I alua
 If
 .I exclusive_pref_bit
 is set, paths with the TPGS pref bit set will always be in their own path
@@ -273,12 +275,12 @@ is the number of features in
 Possible values for the feature list are
 .RS
 .TP 12
-.B queue_if_no_path
+.I queue_if_no_path
 Queue IO if no path is active; identical to the
 .I no_path_retry
 keyword.
 .TP
-.B no_partitions
+.I no_partitions
 Disable automatic partitions generation via kpartx.
 .RE
 .TP
@@ -287,26 +289,26 @@ The default method used to determine the paths state. Possible values
 are
 .RS
 .TP 12
-.B readsector0
+.I readsector0
 (Deprecated) Read the first sector of the device. This checker is being
 deprecated, please use \fItur\fR instead
 .TP
-.B tur
+.I tur
 Issue a
 .I TEST UNIT READY
 command to the device.
 .TP
-.B emc_clariion
+.I emc_clariion
 Query the EMC Clariion specific EVPD page 0xC0 to determine the path
 state.
 .TP
-.B hp_sw
+.I hp_sw
 Check the path state for HP storage arrays with Active/Standby firmware.
 .TP
-.B rdac
+.I rdac
 Check the path state for LSI/Engenio/NetApp E-Series RDAC storage controller.
 .TP
-.B directio
+.I directio
 (Deprecated) Read the first sector with direct I/O. This checker is being
 deprecated, it will cause spurious path failures under high load.
 Please use \fItur\fR instead.
@@ -318,19 +320,19 @@ Default value is: \fBtur\fR
 Tell multipathd how to manage path group failback.
 .RS
 .TP 12
-.B immediate
+.I immediate
 Immediately failback to the highest priority pathgroup that contains
 active paths.
 .TP
-.B manual
+.I manual
 Do not perform automatic failback.
 .TP
-.B followover
+.I followover
 Only perform automatic failback when the first path of a pathgroup
 becomes active. This keeps a node from automatically failing back when
 another node requested the failover.
 .TP
-.B values > 0
+.I values > 0
 deferred failback (time to defer in seconds)
 .TP
 Default value is: \fBmanual\fR
@@ -431,7 +433,7 @@ retry interval
 \fIno_path_retry\fR * \fIpolling_interval\fR
 if a number of retries is given with \fIno_path_retry\fR and the
 overall retry interval is longer than the specified \fIdev_loss_tmo\fR value.
-The linux kernel will cap this value to \fI300\fR if \fBfast_io_fail_tmo\fR
+The linux kernel will cap this value to \fI300\fR if \fIfast_io_fail_tmo\fR
 is not set.
 .RS
 .TP
@@ -633,9 +635,9 @@ Regular expression of the udev property to be excluded.
 .TP
 .B device
 Subsection for the device description. This subsection recognizes the
-.I vendor
+.B vendor
 and
-.I product
+.B product
 keywords. For a full description of these keywords please see the
 .I devices
 section description.
@@ -667,9 +669,9 @@ Regular expression of the device nodes to be whitelisted.
 .TP
 .B device
 Subsection for the device description. This subsection recognizes the
-.I vendor
+.B vendor
 and
-.I product
+.B product
 keywords. For a full description of these keywords please see the
 .I devices
 section description.
@@ -678,20 +680,20 @@ The
 .I property
 blacklist and whitelist handling is different from the usual handling
 in the sense that the whitelist
-.B has
+.I has
 to be set, otherwise the device will be blacklisted.
 In these cases the message
 .I blacklisted, udev property missing
 will be displayed.
 .SH "multipaths section"
 The only recognized attribute for the
-.B multipaths
+.I multipaths
 section is the
 .I multipath
 subsection.
 .LP
 The
-.B multipath
+.I multipath
 subsection recognizes the following attributes:
 .TP 17
 .B wwid
@@ -744,7 +746,7 @@ section:
 .LP
 .SH "devices section"
 The only recognized attribute for the
-.B devices
+.I devices
 section is the
 .I device
 subsection.
@@ -774,17 +776,17 @@ device type, instead of the default "mpath"
 The following hardware handler are implemented:
 .RS
 .TP 12
-.B 1 emc
+.I 1 emc
 Hardware handler for EMC storage arrays.
 .TP
-.B 1 rdac
+.I 1 rdac
 Hardware handler for LSI/Engenio/NetApp E-Series RDAC storage controller.
 .TP
-.B 1 hp_sw
+.I 1 hp_sw
 Hardware handler for Compaq/HP storage arrays in active/standby
 mode.
 .TP
-.B 1 alua
+.I 1 alua
 Hardware handler for SCSI-3 ALUA compatible arrays.
 .RE
 .LP
@@ -923,23 +925,23 @@ are present multipath will try to use the sysfs attribute
 \fIvpd_pg83\fR to generate the wwid.
 .SH "KNOWN ISSUES"
 The usage of
-.B queue_if_no_path
+.I queue_if_no_path
 option can lead to
-.B D state
+.I D state
 processes being hung and not killable in situations where all the paths to the LUN go offline.
 It is advisable to use the
-.B no_path_retry
+.I no_path_retry
 option instead.
 .P
 The use of
-.B queue_if_no_path
+.I queue_if_no_path
 or
-.B no_path_retry
+.I no_path_retry
 might lead to a deadlock if the
-.B dev_loss_tmo
+.I dev_loss_tmo
 setting results in a device being removed while I/O is still queued.
 The multipath daemon will update the
-.B dev_loss_tmo
+.I dev_loss_tmo
 setting accordingly to avoid this deadlock. Hence if both values are
 specified the order of precedence is
 .I no_path_retry, queue_if_no_path, dev_loss_tmo
@@ -950,5 +952,5 @@ specified the order of precedence is
 .BR multipath (8)
 .BR multipathd (8)
 .SH AUTHORS
-.B multipath
+.I multipath
 was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
-- 
2.7.4
