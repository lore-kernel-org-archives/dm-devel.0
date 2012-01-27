From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: Update multipath.conf man page
Date: Fri, 27 Jan 2012 14:42:45 -0600
Message-ID: <20120127204245.GW1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Update the multipath.conf man page.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 |   79 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 15 deletions(-)

Index: multipath-tools-120123/multipath/multipath.conf.5
===================================================================
--- multipath-tools-120123.orig/multipath/multipath.conf.5
+++ multipath-tools-120123/multipath/multipath.conf.5
@@ -82,6 +82,11 @@ maximal interval between two path checks
 directory where udev creates its device nodes; default is
 .I /dev
 .TP
+.B multipath_dir
+directory where the dynamic shared objects are stored; default is system
+dependent, commonly
+.I /lib/multipath
+.TP
 .B verbosity
 default verbosity. Higher values increase the verbosity level. Valid
 levels are between 0 and 6; default is
@@ -141,7 +146,7 @@ Default value is \fImultibus\fR.
 The default program and args to callout to obtain a unique path
 identifier. Should be specified with an absolute path. Default value
 is
-.I /lib/udev/scsi_id --whitelisted --device=/dev/%n
+.I /lib/udev/scsi_id --whitelisted --replace-whitespace --device=/dev/%n
 .TP
 .B prio
 The name of the path priority routine. The specified routine
@@ -177,17 +182,22 @@ Generate the path priority for Hitachi H
 .B random
 Generate a random priority between 1 and 10.
 .TP 12
-.B weightedpath <hbtl|devname> <regex1> <prio1> <regex2> <prio2> ...
-.I hbtl 
-regex can be of SCSI H:B:T:L format  Ex: 1:0:.:. , *:0:0:.
-.I devname 
-regex can be of device name format  Ex: sda , sd.e
+.B weightedpath
 Generate the path priority based on the regular expression and the 
-priority provided as argument.
+priority provided as argument. requires prio_args keyword.
 .TP
 Default value is \fBnone\fR.
 .RE
 .TP
+.B prio_args
+Arguments to pass to to the prio function.  Currently only used with
+.I weighted, which needs a value of the form
+.I "<hbtl|devname> <regex1> <prio1> <regex2> <prio2> ..."
+.I hbtl
+regex can be of SCSI H:B:T:L format  Ex: 1:0:.:. , *:0:0:.
+.I devname
+regex can be of device name format  Ex: sda , sd.e
+.TP
 .B features
 Specify any device-mapper features to be used. Syntax is
 .I num list
@@ -238,19 +248,33 @@ Default value is \fIdirectio\fR.
 .RE
 .TP
 .B failback
-Tell the daemon to manage path group failback, or not to. 0 or
-.I immediate
-means immediate failback, values >0 means deferred failback (in
-seconds).
-.I manual
-means no failback. Default value is
-.I manual
+Tell multipathd how to manage path group failback.
+.RS
+.TP 12
+.B immediate
+Immediately failback to the highest priority pathgroup that contains
+active paths.
+.TP
+.B manual
+Do not perform automatic failback.
+.TP
+.B values > 0
+deferred failback (time to defer in seconds)
+.TP
+Default value is \fImanual\fR.
+.RE
 .TP
 .B  rr_min_io
 The number of IO to route to a path before switching to the next in
-the same path group. Default is
+the same path group. This is only for BIO based multipath. Default is
 .I 1000
 .TP
+.B rr_min_io_q
+The number of IO requests to route to a path before switching to the
+next in the same path group. This is only for request based multipath.
+Default is
+.I 1
+.TP
 .B rr_weight
 If set to \fIpriorities\fR the multipath configurator will assign
 path weights as "path prio * rr_min_io". Possible values are
@@ -280,6 +304,13 @@ be overriden by any specific aliases in
 Default is
 .I no
 .TP
+.B flush_on_last_del
+If set to
+.I yes
+, multipathd will disable queueing when the last path to a device has been
+deleted. Default is
+.I no
+.TP
 .B max_fds
 Specify the maximum number of file descriptors that can be opened by multipath
 and multipathd.  This is equivalent to ulimit -n. A value of \fImax\fR will set
@@ -413,12 +444,20 @@ section:
 .TP
 .B prio
 .TP
+.B prio_args
+.TP
 .B failback
 .TP
+.B rr_weight
+.TP
+.B flush_on_last_del
+.TP
 .B no_path_retry
 .TP
 .B rr_min_io
 .TP
+.B rr_min_io_q
+.TP
 .B features
 .RE
 .PD
@@ -446,6 +485,10 @@ subsection recognizes the following attr
 .B product_blacklist
 (Optional) Product strings to blacklist for this vendor
 .TP
+.B alias_prefix
+(Optional) The user_friendly_names prefix to use for this
+device type, instead of the default "mpath"
+.TP
 .B hardware_handler
 (Optional) The hardware handler to use for this device type.
 The following hardware handler are implemented:
@@ -483,6 +526,8 @@ section:
 .TP
 .B prio
 .TP
+.B prio_args
+.TP
 .B features
 .TP
 .B failback
@@ -493,9 +538,13 @@ section:
 .TP
 .B rr_min_io
 .TP
+.B rr_min_io_rq
+.TP
 .B fast_io_fail_tmo
 .TP
 .B dev_loss_tmo
+.TP
+.B flush_on_last_del
 .RE
 .PD
 .LP
