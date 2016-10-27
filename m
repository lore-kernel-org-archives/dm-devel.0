From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: clean up and organize
	multipath/multipath.8
Date: Thu, 27 Oct 2016 12:22:41 +0200
Message-ID: <20161027102241.2077-1-xose.vazquez@gmail.com>
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
 multipath/multipath.8 | 159 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 109 insertions(+), 50 deletions(-)

diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 966139e..f0b1ff0 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -1,7 +1,24 @@
-.TH MULTIPATH 8 "July 2006" "" "Linux Administrator's Manual"
+.\" ----------------------------------------------------------------------------
+.\" Update the date below if you make any significant change.
+.\" Make sure there are no errors with:
+.\" groff -z -wall -b -e -t multipath/multipath.8
+.\"
+.\" ----------------------------------------------------------------------------
+.
+.TH MULTIPATH 8 2016-10-26 "Linux"
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH NAME
-multipath \- Device mapper target autoconfig
+.\" ----------------------------------------------------------------------------
+.
+multipath \- Device mapper target autoconfig.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH SYNOPSIS
+.\" ----------------------------------------------------------------------------
+.
 .B multipath
 .RB [\| \-v\ \c
 .IR verbosity \|]
@@ -10,124 +27,166 @@ multipath \- Device mapper target autoconfig
 .RB [\| \-d \|]
 .RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \|-i | \-a | \|-u | \-w | \-W \|]
 .RB [\| \-p\ \c
-.BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
+.IR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
+.\" ----------------------------------------------------------------------------
+.
 .B multipath
 is used to detect and coalesce multiple paths to devices, for fail-over or performance reasons.
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH OPTIONS
+.\" ----------------------------------------------------------------------------
+.
 .TP
-.B \-v " level"
-verbosity, print all paths and multipaths
+.BI \-v " level"
+Verbosity, print all paths and multipaths:
 .RS 1.2i
 .TP 1.2i
-.B 0
-no output
+.I 0
+No output.
 .TP
-.B 1
-print the created or updated multipath names only, for use to feed other tools like kpartx
+.I 1
+Print the created or updated multipath names only, for use to feed other tools like kpartx.
 .TP
-.B 2 +
-print all info : detected paths, coalesced paths (ie multipaths) and device maps
+.I 2 +
+Print all info: detected paths, coalesced paths (ie multipaths) and device maps.
 .RE
+.
 .TP
 .B \-h
-print usage text
+Print usage text.
+.
 .TP
 .B \-d
-dry run, do not create or update devmaps
+Dry run, do not create or update devmaps.
+.
 .TP
 .B \-l
-show the current multipath topology from information fetched in sysfs and the device mapper
+Show the current multipath topology from information fetched in sysfs and the device mapper.
+.
 .TP
 .B \-ll
-show the current multipath topology from all available information (sysfs, the device mapper, path checkers ...)
+Show the current multipath topology from all available information (sysfs, the device mapper, path checkers ...).
+.
 .TP
 .B \-f
-flush a multipath device map specified as parameter, if unused
+Flush a multipath device map specified as parameter, if unused.
+.
 .TP
 .B \-F
-flush all unused multipath device maps
+Flush all unused multipath device maps.
+.
 .TP
 .B \-t
-print internal hardware table to stdout
+Print internal hardware table to stdout.
+.
 .TP
 .B \-r
-force devmap reload
+Force devmap reload.
+.
 .TP
 .B \-i
-ignore wwids file when processing devices
+Ignore WWIDs file when processing devices.
+.
 .TP
 .B \-B
-treat the bindings file as read only
+Treat the bindings file as read only.
+.
 .TP
-.B \-b " bindings_file"
-set user_friendly_names bindings file location.  The default is
-/etc/multipath/bindings
+.BI \-b " bindings_file"
+Set user_friendly_names bindings file location.  The default is
+\fI/etc/multipath/bindings\fR.
+.
 .TP
 .B \-c
-check if a block device should be a path in a multipath device
+Check if a block device should be a path in a multipath device.
+.
 .TP
 .B \-q
-allow device tables with queue_if_no_path when multipathd is not running
+Allow device tables with \fIqueue_if_no_path\fR when multipathd is not running.
+.
 .TP
 .B \-a
-add the wwid for the specified device to the wwids file
+Add the WWID for the specified device to the WWIDs file.
+.
 .TP
 .B \-u
-check if the device specified in the program environment should be
+Check if the device specified in the program environment should be
 a path in a multipath device.
+.
 .TP
 .B \-w
-remove the wwid for the specified device from the wwids file
+Remove the WWID for the specified device from the WWIDs file.
+.
 .TP
 .B \-W
-reset the wwids file to only include the current multipath devices
+Reset the WWIDs file to only include the current multipath devices.
+.
 .TP
 .BI \-p " policy"
-force new maps to use the specified policy:
+Force new maps to use the specified policy:
 .RS 1.2i
 .TP 1.2i
-.B failover
-1 path per priority group
+.I failover
+One path per priority group.
 .TP
-.B multibus
-all paths in 1 priority group
+.I multibus
+All paths in one priority group.
 .TP
-.B group_by_serial
-1 priority group per serial
+.I group_by_serial
+One priority group per serial number.
 .TP
-.B group_by_prio
-1 priority group per priority value. Priorities are determined by callout programs specified as a global, per-controller or per-multipath option in the configuration file
+.I group_by_prio
+One priority group per priority value. Priorities are determined by
+callout programs specified as a global, per-controller or
+per-multipath option in the configuration file.
 .TP
-.B group_by_node_name
-1 priority group per target node name. Target node names are fetched
-in /sys/class/fc_transport/target*/node_name.
+.I group_by_node_name
+One priority group per target node name. Target node names are fetched
+in \fI/sys/class/fc_transport/target*/node_name\fR.
 .TP
 .RE
 Existing maps are not modified.
+.
 .TP
 .BI device
-update only the devmap specified by
+Update only the devmap specified by
 .IR device ,
 which is either:
 .RS 1.2i
 .IP \[bu]
-a devmap name
+A devmap name.
 .IP \[bu]
-a path associated with the desired devmap; the path may be in one of the following formats:
+A path associated with the desired devmap; the path may be in one of the following formats:
 .RS 1.2i
 .IP \[bu]
-.B /dev/sdb
+.B /dev/sdX
 .IP \[bu]
 .B major:minor
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH "SEE ALSO"
+.\" ----------------------------------------------------------------------------
+.
 .BR multipathd (8),
 .BR multipath.conf (5),
 .BR kpartx (8),
 .BR udev (8),
-.BR dmsetup (8)
-.BR hotplug (8)
+.BR dmsetup (8),
+.BR hotplug (8).
+.
+.
+.\" ----------------------------------------------------------------------------
 .SH AUTHORS
-.B multipath
-was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
+.\" ----------------------------------------------------------------------------
+.
+\fImultipath-tools\fR was developed by Christophe Varoqui <christophe.varoqui@opensvc.com>
+and others.
+.\" EOF
-- 
2.10.1
