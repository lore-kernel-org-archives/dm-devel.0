From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: order keywords in
	multipath.conf.5
Date: Mon, 11 Jul 2016 23:05:17 +0200
Message-ID: <1468271117-2847-2-git-send-email-xose.vazquez@gmail.com>
References: <1468271117-2847-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468271117-2847-1-git-send-email-xose.vazquez@gmail.com>
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

Follow the same order as multipath output (libmultipath/dict.c)

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 196 +++++++++++++++++++++++----------------------
 1 file changed, 99 insertions(+), 97 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 76d80e3..3620f48 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -73,6 +73,14 @@ The
 .I defaults
 section recognizes the following keywords:
 .TP 17
+.B verbosity
+Default verbosity. Higher values increase the verbosity level. Valid
+levels are between 0 and 6.
+.RS
+.TP
+Default value is: \fB2\fR
+.RE
+.TP
 .B polling_interval
 Interval between two path checks in seconds. For properly functioning paths,
 the interval between checks will gradually increase to
@@ -92,46 +100,6 @@ Maximal interval between two path checks in seconds.
 Default value is: \fB4 * polling_interval\fR
 .RE
 .TP
-.B multipath_dir
-Directory where the dynamic shared objects are stored.
-.RS
-.TP
-Default value is: \fB<system dependent>\fR, commonly \fI/lib64/multipath/\fR
-.RE
-.TP
-.B find_multipaths
-If set to
-.I yes
-, instead of trying to create a multipath device for every non-blacklisted
-path, multipath will only create a device if one of three condidions are
-met.
-.I 1
-There are at least two non-blacklisted paths with the same WWID,
-.I 2
-the user manually forces the creation, by specifying a device with the multipath
-command, or
-.I 3
-a path has the same WWID as a multipath device that was previously created
-while find_multipaths was set (even if that multipath device doesn't currently
-exist).
-Whenever a multipath device is created with find_multipaths set, multipath will
-remeber the WWID of the device, so that it will automatically create the
-device again, as soon as it sees a path with that WWID. This should allow most
-users to have multipath automatically choose the correct paths to make into
-multipath devices, without having to edit the blacklist.
-.RS
-.TP
-Default value is: \fBno\fR
-.RE
-.TP
-.B verbosity
-Default verbosity. Higher values increase the verbosity level. Valid
-levels are between 0 and 6.
-.RS
-.TP
-Default value is: \fB2\fR
-.RE
-.TP
 .B reassign_maps
 Enable reassigning of device-mapper maps. With this option multipathd
 will remap existing device-mapper maps to always point to multipath
@@ -142,6 +110,13 @@ device, not the underlying block devices. Possible values are
 Default value is: \fBno\fR
 .RE
 .TP
+.B multipath_dir
+Directory where the dynamic shared objects are stored.
+.RS
+.TP
+Default value is: \fB<system dependent>\fR, commonly \fI/lib64/multipath/\fR
+.RE
+.TP
 .B path_selector
 The default path selector algorithm to use; they are offered by the
 kernel multipath target. There are three selector algorithms:
@@ -404,6 +379,18 @@ next in the same path group. This is only for request based multipath.
 Default value is: \fB1\fR
 .RE
 .TP
+.B max_fds
+Specify the maximum number of file descriptors that can be opened by multipath
+and multipathd.  This is equivalent to ulimit \-n. A value of \fImax\fR will set
+this to the system limit from \fI/proc/sys/fs/nr_open\fR. If this is not set, the
+maximum number of open fds is taken from the calling process. It is usually
+1024. To be safe, this should be set to the maximum number of paths plus 32,
+if that number is greated than 1024.
+.RS
+.TP
+Default value is: \fBmax\fR
+.RE
+.TP
 .B rr_weight
 If set to \fIpriorities\fR the multipath configurator will assign
 path weights as "path prio * rr_min_io". Possible values are
@@ -426,21 +413,30 @@ for never stop queueing. If unset no queueing is attempted.
 Default value is: \fB<unset>\fR
 .RE
 .TP
-.B user_friendly_names
-If set to
-.I yes
-, using the bindings file
-.I /etc/multipath/bindings
-to assign a persistent and unique alias to the multipath, in the form of mpath<n>.
+.B queue_without_daemon
 If set to
 .I no
-use the WWID as the alias. In either case this be will
-be overridden by any specific aliases in the \fImultipaths\fR section.
+, when multipathd stops, queueing will be turned off for all devices.
+This is useful for devices that set no_path_retry.  If a machine is
+shut down while all paths to a device are down, it is possible to hang waiting
+for IO to return from the device after multipathd has been stopped. Without
+multipathd running, access to the paths cannot be restored, and the kernel
+cannot be told to stop queueing IO. Setting queue_without_daemon to
+.I no
+, avoids this problem.
 .RS
 .TP
 Default value is: \fBno\fR
 .RE
 .TP
+.B checker_timeout
+Specify the timeout to use for path checkers and prioritizers that issue SCSI
+commands with an explicit timeout, in seconds.
+.RS
+.TP
+Default value is: in \fB/sys/block/sd<x>/device/timeout\fR
+.RE
+.TP
 .B flush_on_last_del
 If set to
 .I yes
@@ -451,24 +447,19 @@ deleted.
 Default value is: \fBno\fR
 .RE
 .TP
-.B max_fds
-Specify the maximum number of file descriptors that can be opened by multipath
-and multipathd.  This is equivalent to ulimit \-n. A value of \fImax\fR will set
-this to the system limit from \fI/proc/sys/fs/nr_open\fR. If this is not set, the
-maximum number of open fds is taken from the calling process. It is usually
-1024. To be safe, this should be set to the maximum number of paths plus 32,
-if that number is greated than 1024.
-.RS
-.TP
-Default value is: \fBmax\fR
-.RE
-.TP
-.B checker_timeout
-Specify the timeout to use for path checkers and prioritizers that issue SCSI
-commands with an explicit timeout, in seconds.
+.B user_friendly_names
+If set to
+.I yes
+, using the bindings file
+.I /etc/multipath/bindings
+to assign a persistent and unique alias to the multipath, in the form of mpath<n>.
+If set to
+.I no
+use the WWID as the alias. In either case this be will
+be overridden by any specific aliases in the \fImultipaths\fR section.
 .RS
 .TP
-Default value is: in \fB/sys/block/sd<x>/device/timeout\fR
+Default value is: \fBno\fR
 .RE
 .TP
 .B fast_io_fail_tmo
@@ -498,22 +489,6 @@ is not set.
 Default value is: \fB600\fR
 .RE
 .TP
-.B queue_without_daemon
-If set to
-.I no
-, when multipathd stops, queueing will be turned off for all devices.
-This is useful for devices that set no_path_retry.  If a machine is
-shut down while all paths to a device are down, it is possible to hang waiting
-for IO to return from the device after multipathd has been stopped. Without
-multipathd running, access to the paths cannot be restored, and the kernel
-cannot be told to stop queueing IO. Setting queue_without_daemon to
-.I no
-, avoids this problem.
-.RS
-.TP
-Default value is: \fBno\fR
-.RE
-.TP
 .B bindings_file
 The full pathname of the binding file to be used when the user_friendly_names option is set.
 .RS
@@ -587,6 +562,22 @@ multipathd checkers running in parallel causes significant CPU pressure.
 Default value is: \fBno\fR
 .RE
 .TP
+.B strict_timinig
+If set to
+.I yes
+, multipathd will start a new path checker loop after exactly one second,
+so that each path check will occur at exactly
+.I polling_interval
+seconds. On busy systems path checks might take longer than one second;
+here the missing ticks will be accounted for on the next round.
+A warning will be printed if path checks take longer than
+.I polling_interval
+seconds.
+.RS
+.TP
+Default value is: \fBno\fR
+.RE
+.TP
 .B deferred_remove
 If set to
 .I yes
@@ -645,17 +636,26 @@ checks.
 Default value is: \fBno\fR
 .RE
 .TP
-.B strict_timinig
+.B find_multipaths
 If set to
 .I yes
-, multipathd will start a new path checker loop after exactly one second,
-so that each path check will occur at exactly
-.I polling_interval
-seconds. On busy systems path checks might take longer than one second;
-here the missing ticks will be accounted for on the next round.
-A warning will be printed if path checks take longer than
-.I polling_interval
-seconds.
+, instead of trying to create a multipath device for every non-blacklisted
+path, multipath will only create a device if one of three condidions are
+met.
+.I 1
+There are at least two non-blacklisted paths with the same WWID,
+.I 2
+the user manually forces the creation, by specifying a device with the multipath
+command, or
+.I 3
+a path has the same WWID as a multipath device that was previously created
+while find_multipaths was set (even if that multipath device doesn't currently
+exist).
+Whenever a multipath device is created with find_multipaths set, multipath will
+remeber the WWID of the device, so that it will automatically create the
+device again, as soon as it sees a path with that WWID. This should allow most
+users to have multipath automatically choose the correct paths to make into
+multipath devices, without having to edit the blacklist.
 .RS
 .TP
 Default value is: \fBno\fR
@@ -707,12 +707,12 @@ LUNs for the array controller.
 .LP
 The following keywords are recognized:
 .TP 17
-.B wwid
-The \fIWorld Wide Identification\fR of a device.
-.TP
 .B devnode
 Regular expression of the device nodes to be excluded.
 .TP
+.B wwid
+The \fIWorld Wide Identification\fR of a device.
+.TP
 .B property
 Regular expression of the udev property to be excluded.
 .TP
@@ -737,6 +737,9 @@ section.
 .LP
 The following keywords are recognized:
 .TP 17
+.B devnode
+Regular expression of the device nodes to be whitelisted.
+.TP
 .B wwid
 The \fIWorld Wide Identification\fR of a device.
 .TP
@@ -747,9 +750,6 @@ Regular expression of the udev property to be whitelisted.
 Default value is: \fB(ID_WWN|SCSI_IDENT_.*)\fR
 .RE
 .TP
-.B devnode
-Regular expression of the device nodes to be whitelisted.
-.TP
 .B device
 Subsection for the device description. This subsection recognizes the
 .B vendor
@@ -807,18 +807,20 @@ section:
 .TP
 .B rr_weight
 .TP
-.B flush_on_last_del
-.TP
 .B no_path_retry
 .TP
 .B rr_min_io
 .TP
 .B rr_min_io_rq
 .TP
+.B flush_on_last_del
+.TP
 .B features
 .TP
 .B reservation_key
 .TP
+.B user_friendly_names
+.TP
 .B deferred_remove
 .TP
 .B delay_watch_checks
-- 
2.7.4
