From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: make defaults values more
	visible in multipath.conf.5
Date: Fri, 8 Jul 2016 09:19:00 +0200
Message-ID: <CABr-Gndxdsjqa6eL+KHq1qE_Sj+Yaek2DGxn4hQOV+FhiEbvuA@mail.gmail.com>
References: <1467500779-28754-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5947012112530086483=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467500779-28754-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5947012112530086483==
Content-Type: multipart/alternative; boundary=001a114128eeeae3ab05371a9dc8

--001a114128eeeae3ab05371a9dc8
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Sun, Jul 3, 2016 at 1:06 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Put them in a new paragraph, and in bold.
>
> Easier to read and cleaner layout.
>
> man page in PDF at:
> https://drive.google.com/file/d/0B_B6YmEmO7cDVTl2djM1YkZMNFE
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5 | 221
> +++++++++++++++++++++++++++++++--------------
>  1 file changed, 153 insertions(+), 68 deletions(-)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 9f0d194..b85ea14 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -1,4 +1,4 @@
> -.TH MULTIPATH.CONF 5 "30 November 2006"
> +.TH MULTIPATH.CONF 5 2016-07-03 "Linux"
>  .SH NAME
>  multipath.conf \- multipath daemon configuration file
>  .SH DESCRIPTION
> @@ -78,17 +78,24 @@ the interval between checks will gradually increase to
>  This value will be overridden by the
>  .B WatchdogSec
>  setting in the multipathd.service definition if systemd is used.
> -Default is
> -.I 5
> +.RS
> +.TP
> +Default value is: \fB5\fR
> +.RE
>  .TP
>  .B max_polling_interval
> -maximal interval between two path checks in seconds; default is
> -.I 4 * polling_interval
> +maximal interval between two path checks in seconds.
> +.RS
> +.TP
> +Default value is: \fB4 * polling_interval\fR
> +.RE
>  .TP
>  .B multipath_dir
> -directory where the dynamic shared objects are stored; default is system
> -dependent, commonly
> -.I /lib/multipath
> +directory where the dynamic shared objects are stored.
> +.RS
> +.TP
> +Default value is: \fB<system dependent>\fR, commonly /lib64/multipath/
> +.RE
>  .TP
>  .B find_multipaths
>  If set to
> @@ -109,20 +116,29 @@ Whenever a multipath device is created with
> find_multipaths set, multipath will
>  remeber the WWID of the device, so that it will automatically create the
>  device again, as soon as it sees a path with that WWID. This should allow
> most
>  users to have multipath automatically choose the correct paths to make
> into
> -multipath devices, without having to edit the blacklist; Default is
> -.I no
> +multipath devices, without having to edit the blacklist.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B verbosity
>  default verbosity. Higher values increase the verbosity level. Valid
> -levels are between 0 and 6; default is
> -.I 2
> +levels are between 0 and 6.
> +.RS
> +.TP
> +Default value is: \fB2\fR
> +.RE
>  .TP
>  .B reassign_maps
>  enable reassigning of device-mapper maps. With this option multipathd
>  will remap existing device-mapper maps to always point to multipath
>  device, not the underlying block devices. Possible values are
> -\fIyes\fR and \fIno\fR. Default is
> -.I yes
> +\fIyes\fR and \fIno\fR.
> +.RS
> +.TP
> +Default value is: \fByes\fR
> +.RE
>  .TP
>  .B path_selector
>  The default path selector algorithm to use; they are offered by the
> @@ -164,13 +180,15 @@ per-multipath option in the configuration file.
>  1 priority group per target node name. Target node names are fetched
>  in /sys/class/fc_transport/target*/node_name.
>  .TP
> -Default value is \fIfailover\fR.
> +Default value is: \fBfailover\fR
>  .RE
>  .TP
>  .B uid_attribute
> -The udev attribute providing a unique path
> -identifier. Default value is
> -.I ID_SERIAL
> +The udev attribute providing a unique path identifier.
> +.RS
> +.TP
> +Default value is: \fBID_SERIAL\fR
> +.RE
>  .TP
>  .B getuid_callout
>  The default program and args to callout to obtain a unique path
> @@ -217,7 +235,7 @@ Generate a random priority between 1 and 10.
>  Generate the path priority based on the regular expression and the
>  priority provided as argument. requires prio_args keyword.
>  .TP
> -Default value is \fBnone\fR.
> +Default value is: \fBnone\fR
>  .RE
>  .TP
>  .B prio_args
> @@ -293,7 +311,7 @@ Check the path state for LSI/Engenio/NetApp E-Series
> RDAC storage controller.
>  deprecated, it will cause spurious path failures under high load.
>  Please use \fItur\fR instead.
>  .TP
> -Default value is \fItur\fR.
> +Default value is: \fBtur\fR
>  .RE
>  .TP
>  .B failback
> @@ -315,19 +333,24 @@ another node requested the failover.
>  .B values > 0
>  deferred failback (time to defer in seconds)
>  .TP
> -Default value is \fImanual\fR.
> +Default value is: \fBmanual\fR
>  .RE
>  .TP
>  .B  rr_min_io
>  The number of IO to route to a path before switching to the next in
> -the same path group. This is only for BIO based multipath. Default is
> -.I 1000
> +the same path group. This is only for BIO based multipath.
> +.RS
> +.TP
> +Default value is: \fB1000\fR
> +.RE
>  .TP
>  .B rr_min_io_rq
>  The number of IO requests to route to a path before switching to the
>  next in the same path group. This is only for request based multipath.
> -Default is
> -.I 1
> +.RS
> +.TP
> +Default value is: \fB1\fR
> +.RE
>  .TP
>  .B rr_weight
>  If set to \fIpriorities\fR the multipath configurator will assign
> @@ -335,8 +358,10 @@ path weights as "path prio * rr_min_io". Possible
> values are
>  .I priorities
>  or
>  .IR uniform .
> -Default is
> -.IR uniform .
> +.RS
> +.TP
> +Default value is: \fBuniform\fR
> +.RE
>  .TP
>  .B no_path_retry
>  Specify the number of retries until disable queueing, or
> @@ -344,7 +369,10 @@ Specify the number of retries until disable queueing,
> or
>  for immediate failure (no queueing),
>  .I queue
>  for never stop queueing. If unset no queueing is attempted.
> -Default is unset.
> +.RS
> +.TP
> +Default value is: \fB<unset>\fR
> +.RE
>  .TP
>  .B user_friendly_names
>  If set to
> @@ -356,15 +384,20 @@ If set to
>  .I no
>  use the WWID as the alias. In either case this be will
>  be overridden by any specific aliases in the \fImultipaths\fR section.
> -Default is
> -.I no
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B flush_on_last_del
>  If set to
>  .I yes
>  , multipathd will disable queueing when the last path to a device has been
> -deleted. Default is
> -.I no
> +deleted.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B max_fds
>  Specify the maximum number of file descriptors that can be opened by
> multipath
> @@ -376,8 +409,11 @@ if that number is greated than 1024.
>  .TP
>  .B checker_timeout
>  Specify the timeout to use for path checkers and prioritizers that issue
> scsi
> -commands with an explicit timeout, in seconds; default taken from
> -.I /sys/block/sd<x>/device/timeout
> +commands with an explicit timeout, in seconds.
> +.RS
> +.TP
> +Default value is: in \fB/sys/block/sd<x>/device/timeout\fR
> +.RE
>  .TP
>  .B fast_io_fail_tmo
>  Specify the number of seconds the scsi layer will wait after a problem
> has been
> @@ -396,7 +432,11 @@ retry interval
>  if a number of retries is given with \fIno_path_retry\fR and the
>  overall retry interval is longer than the specified \fIdev_loss_tmo\fR
> value.
>  The linux kernel will cap this value to \fI300\fR if
> \fBfast_io_fail_tmo\fR
> -is not set. Default is 600.
> +is not set.
> +.RS
> +.TP
> +Default value is: \fB600\fR
> +.RE
>  .TP
>  .B queue_without_daemon
>  If set to
> @@ -408,18 +448,26 @@ for IO to return from the device after multipathd
> has been stopped. Without
>  multipathd running, access to the paths cannot be restored, and the kernel
>  cannot be told to stop queueing IO. Setting queue_without_daemon to
>  .I no
> -, avoids this problem. Default is
> -.I no
> +, avoids this problem.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B bindings_file
> -The full pathname of the binding file to be used when the
> user_friendly_names option is set. Defaults to
> -.I /etc/multipath/bindings
> +The full pathname of the binding file to be used when the
> user_friendly_names option is set.
> +.RS
> +.TP
> +Default value is: \fB/etc/multipath/bindings\fR
> +.RE
>  .TP
>  .B wwids_file
>  The full pathname of the wwids file, which is used by multipath to keep
> track
>  of the wwids for LUNs it has created multipath devices on in the past.
> -Defaults to
> -.I /etc/multipath/wwids
> +.RS
> +.TP
> +Default value is: \fB/etc/multipath/wwids\fR
> +.RE
>  .TP
>  .B log_checker_err
>  If set to
> @@ -427,15 +475,22 @@ If set to
>  , multipathd logs the first path checker error at logging level 2. Any
> later
>  errors are logged at level 3 until the device is restored. If set to
>  .I always
> -, multipathd always logs the path checker error at logging level 2.
> Default is
> -.I always
> +, multipathd always logs the path checker error at logging level 2.
> +.RS
> +.TP
> +Default value is: \fBalways\fR
> +.RE
>  .TP
>  .B reservation_key
>  This is the service action reservation key used by mpathpersist.  It must
> be
>  set for all multipath devices using persistent reservations, and it must
> be
>  the same as the RESERVATION KEY field of the PERSISTENT RESERVE OUT
> parameter
>  list which contains an 8-byte value provided by the application client to
> the
> -device server to identify the I_T nexus. It is unset by default.
> +device server to identify the I_T nexus.
> +.RS
> +.TP
> +Default value is: \fB<unset>\fR
> +.RE
>  .TP
>  .B retain_attached_hw_handler
>  If set to
> @@ -443,8 +498,11 @@ If set to
>  and the scsi layer has already attached a hardware_handler to the device,
>  multipath will not force the device to use the hardware_handler specified
> by
>  mutipath.conf. If the scsi layer has not attached a hardware handler,
> -multipath will continue to use its configured hardware handler. Default is
> -.I no
> +multipath will continue to use its configured hardware handler.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B detect_prio
>  If set to
> @@ -452,17 +510,22 @@ If set to
>  , multipath will try to detect if the device supports ALUA. If so, the
> device
>  will automatically use the
>  .I alua
> -prioritizer. If not, the prioritizer will be selected as usual. Default is
> -.I no
> +prioritizer. If not, the prioritizer will be selected as usual.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B force_sync
>  If set to
>  .I yes
>  , multipathd will call the path checkers in sync mode only.  This means
> that
>  only one checker will run at a time.  This is useful in the case where
> many
> -multipathd checkers running in parallel causes significant CPU pressure.
> The
> -Default is
> -.I no
> +multipathd checkers running in parallel causes significant CPU pressure.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B deferred_remove
>  If set to
> @@ -471,15 +534,21 @@ If set to
>  last path device has been deleted.  This means that if the multipath
> device is
>  still in use, it will be freed when the last user closes it.  If path is
> added
>  to the multipath device before the last user closes it, the deferred
> remove
> -will be canceled. Default is
> -.I no
> +will be canceled.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B config_dir
>  If set to anything other than "", multipath will search this directory
>  alphabetically for file ending in ".conf" and it will read configuration
>  information from them, just as if it was in /etc/multipath.conf.
> config_dir
> -must either be "" or a fully qualified directory name. Default is
> -.I "/etc/multipath/conf.d"
> +must either be "" or a fully qualified directory name.
> +.RS
> +.TP
> +Default value is: \fB/etc/multipath/conf.d/\fR
> +.RE
>  .TP
>  .B delay_watch_checks
>  If set to a value greater than 0, multipathd will watch paths that have
> @@ -487,8 +556,11 @@ recently become valid for this many checks.  If they
> fail again while they are
>  being watched, when they next become valid, they will not be used until
> they
>  have stayed up for
>  .I delay_wait_checks
> -checks. Default is
> -.I no
> +checks.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B delay_wait_checks
>  If set to a value greater than 0, when a device that has recently come
> back
> @@ -497,8 +569,11 @@ online fails again within
>  checks, the next time it comes back online, it will marked and delayed,
> and not
>  used until it has passed
>  .I delay_wait_checks
> -checks. Default is
> -.I no
> +checks.
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B strict_timinig
>  If set to
> @@ -511,8 +586,10 @@ here the missing ticks will be accounted for on the
> next round.
>  A warning will be printed if path checks take longer than
>  .I polling_interval
>  seconds.
> -Default is
> -.I no
> +.RS
> +.TP
> +Default value is: \fBno\fR
> +.RE
>  .TP
>  .B uxsock_timeout
>  CLI receive timeout in milliseconds. For larger systems CLI commands
> @@ -520,16 +597,21 @@ might timeout before the multipathd lock is released
> and the CLI command
>  can be processed. This will result in errors like
>  "timeout receiving packet" to be returned from CLI commands.
>  In these cases it is recommended to increase the CLI timeout to avoid
> -those issues. The default is
> -.I 1000
> +those issues.
> +.RS
> +.TP
> +Default value is: \fB1000\fR
> +.RE
>  .TP
>  .B missing_uev_wait_timeout
>  Controls how many seconds multipathd will wait, after a new multipath
> device
>  is created, to receive a change event from udev for the device, before
>  automatically enabling device reloads. Usually multipathd will delay
> reloads
> -on a device until it receives a change uevent from the initial table
> load. The
> -default is
> -.I 30
> +on a device until it receives a change uevent from the initial table load.
> +.RS
> +.TP
> +Default value is: \fB30\fR
> +.RE
>  .
>  .SH "blacklist section"
>  The
> @@ -574,8 +656,11 @@ The following keywords are recognized:
>  The \fIWorld Wide Identification\fR of a device.
>  .TP
>  .B property
> -Regular expression of the udev property to be whitelisted. Defaults to
> -.I (ID_WWN|SCSI_IDENT_.*)
> +Regular expression of the udev property to be whitelisted.
> +.RS
> +.TP
> +Default value is: \fB(ID_WWN|SCSI_IDENT_.*)\fR
> +.RE
>  .TP
>  .B devnode
>  Regular expression of the device nodes to be whitelisted.
> --
> 2.7.4
>
>

--001a114128eeeae3ab05371a9dc8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Sun, Jul 3, 2016 at 1:06 AM, Xose Vazquez=
 Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targ=
et=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">Put them in a new paragraph, and in bold.<br>
<br>
Easier to read and cleaner layout.<br>
<br>
man page in PDF at: <a href=3D"https://drive.google.com/file/d/0B_B6YmEmO7c=
DVTl2djM1YkZMNFE" rel=3D"noreferrer" target=3D"_blank">https://drive.google=
.com/file/d/0B_B6YmEmO7cDVTl2djM1YkZMNFE</a><br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipath/multipath.conf.5 | 221 +++++++++++++++++++++++++++++++-----=
---------<br>
=C2=A01 file changed, 153 insertions(+), 68 deletions(-)<br>
<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 9f0d194..b85ea14 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -1,4 +1,4 @@<br>
-.TH MULTIPATH.CONF 5 &quot;30 November 2006&quot;<br>
+.TH MULTIPATH.CONF 5 2016-07-03 &quot;Linux&quot;<br>
=C2=A0.SH NAME<br>
=C2=A0multipath.conf \- multipath daemon configuration file<br>
=C2=A0.SH DESCRIPTION<br>
@@ -78,17 +78,24 @@ the interval between checks will gradually increase to<=
br>
=C2=A0This value will be overridden by the<br>
=C2=A0.B WatchdogSec<br>
=C2=A0setting in the multipathd.service definition if systemd is used.<br>
-Default is<br>
-.I 5<br>
+.RS<br>
+.TP<br>
+Default value is: \fB5\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B max_polling_interval<br>
-maximal interval between two path checks in seconds; default is<br>
-.I 4 * polling_interval<br>
+maximal interval between two path checks in seconds.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB4 * polling_interval\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B multipath_dir<br>
-directory where the dynamic shared objects are stored; default is system<b=
r>
-dependent, commonly<br>
-.I /lib/multipath<br>
+directory where the dynamic shared objects are stored.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB&lt;system dependent&gt;\fR, commonly /lib64/multipat=
h/<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B find_multipaths<br>
=C2=A0If set to<br>
@@ -109,20 +116,29 @@ Whenever a multipath device is created with find_mult=
ipaths set, multipath will<br>
=C2=A0remeber the WWID of the device, so that it will automatically create =
the<br>
=C2=A0device again, as soon as it sees a path with that WWID. This should a=
llow most<br>
=C2=A0users to have multipath automatically choose the correct paths to mak=
e into<br>
-multipath devices, without having to edit the blacklist; Default is<br>
-.I no<br>
+multipath devices, without having to edit the blacklist.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B verbosity<br>
=C2=A0default verbosity. Higher values increase the verbosity level. Valid<=
br>
-levels are between 0 and 6; default is<br>
-.I 2<br>
+levels are between 0 and 6.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB2\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B reassign_maps<br>
=C2=A0enable reassigning of device-mapper maps. With this option multipathd=
<br>
=C2=A0will remap existing device-mapper maps to always point to multipath<b=
r>
=C2=A0device, not the underlying block devices. Possible values are<br>
-\fIyes\fR and \fIno\fR. Default is<br>
-.I yes<br>
+\fIyes\fR and \fIno\fR.<br>
+.RS<br>
+.TP<br>
+Default value is: \fByes\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B path_selector<br>
=C2=A0The default path selector algorithm to use; they are offered by the<b=
r>
@@ -164,13 +180,15 @@ per-multipath option in the configuration file.<br>
=C2=A01 priority group per target node name. Target node names are fetched<=
br>
=C2=A0in /sys/class/fc_transport/target*/node_name.<br>
=C2=A0.TP<br>
-Default value is \fIfailover\fR.<br>
+Default value is: \fBfailover\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B uid_attribute<br>
-The udev attribute providing a unique path<br>
-identifier. Default value is<br>
-.I ID_SERIAL<br>
+The udev attribute providing a unique path identifier.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBID_SERIAL\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B getuid_callout<br>
=C2=A0The default program and args to callout to obtain a unique path<br>
@@ -217,7 +235,7 @@ Generate a random priority between 1 and 10.<br>
=C2=A0Generate the path priority based on the regular expression and the<br=
>
=C2=A0priority provided as argument. requires prio_args keyword.<br>
=C2=A0.TP<br>
-Default value is \fBnone\fR.<br>
+Default value is: \fBnone\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B prio_args<br>
@@ -293,7 +311,7 @@ Check the path state for LSI/Engenio/NetApp E-Series RD=
AC storage controller.<br>
=C2=A0deprecated, it will cause spurious path failures under high load.<br>
=C2=A0Please use \fItur\fR instead.<br>
=C2=A0.TP<br>
-Default value is \fItur\fR.<br>
+Default value is: \fBtur\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B failback<br>
@@ -315,19 +333,24 @@ another node requested the failover.<br>
=C2=A0.B values &gt; 0<br>
=C2=A0deferred failback (time to defer in seconds)<br>
=C2=A0.TP<br>
-Default value is \fImanual\fR.<br>
+Default value is: \fBmanual\fR<br>
=C2=A0.RE<br>
=C2=A0.TP<br>
=C2=A0.B=C2=A0 rr_min_io<br>
=C2=A0The number of IO to route to a path before switching to the next in<b=
r>
-the same path group. This is only for BIO based multipath. Default is<br>
-.I 1000<br>
+the same path group. This is only for BIO based multipath.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB1000\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B rr_min_io_rq<br>
=C2=A0The number of IO requests to route to a path before switching to the<=
br>
=C2=A0next in the same path group. This is only for request based multipath=
.<br>
-Default is<br>
-.I 1<br>
+.RS<br>
+.TP<br>
+Default value is: \fB1\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B rr_weight<br>
=C2=A0If set to \fIpriorities\fR the multipath configurator will assign<br>
@@ -335,8 +358,10 @@ path weights as &quot;path prio * rr_min_io&quot;. Pos=
sible values are<br>
=C2=A0.I priorities<br>
=C2=A0or<br>
=C2=A0.IR uniform .<br>
-Default is<br>
-.IR uniform .<br>
+.RS<br>
+.TP<br>
+Default value is: \fBuniform\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B no_path_retry<br>
=C2=A0Specify the number of retries until disable queueing, or<br>
@@ -344,7 +369,10 @@ Specify the number of retries until disable queueing, =
or<br>
=C2=A0for immediate failure (no queueing),<br>
=C2=A0.I queue<br>
=C2=A0for never stop queueing. If unset no queueing is attempted.<br>
-Default is unset.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB&lt;unset&gt;\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B user_friendly_names<br>
=C2=A0If set to<br>
@@ -356,15 +384,20 @@ If set to<br>
=C2=A0.I no<br>
=C2=A0use the WWID as the alias. In either case this be will<br>
=C2=A0be overridden by any specific aliases in the \fImultipaths\fR section=
.<br>
-Default is<br>
-.I no<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B flush_on_last_del<br>
=C2=A0If set to<br>
=C2=A0.I yes<br>
=C2=A0, multipathd will disable queueing when the last path to a device has=
 been<br>
-deleted. Default is<br>
-.I no<br>
+deleted.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B max_fds<br>
=C2=A0Specify the maximum number of file descriptors that can be opened by =
multipath<br>
@@ -376,8 +409,11 @@ if that number is greated than 1024.<br>
=C2=A0.TP<br>
=C2=A0.B checker_timeout<br>
=C2=A0Specify the timeout to use for path checkers and prioritizers that is=
sue scsi<br>
-commands with an explicit timeout, in seconds; default taken from<br>
-.I /sys/block/sd&lt;x&gt;/device/timeout<br>
+commands with an explicit timeout, in seconds.<br>
+.RS<br>
+.TP<br>
+Default value is: in \fB/sys/block/sd&lt;x&gt;/device/timeout\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B fast_io_fail_tmo<br>
=C2=A0Specify the number of seconds the scsi layer will wait after a proble=
m has been<br>
@@ -396,7 +432,11 @@ retry interval<br>
=C2=A0if a number of retries is given with \fIno_path_retry\fR and the<br>
=C2=A0overall retry interval is longer than the specified \fIdev_loss_tmo\f=
R value.<br>
=C2=A0The linux kernel will cap this value to \fI300\fR if \fBfast_io_fail_=
tmo\fR<br>
-is not set. Default is 600.<br>
+is not set.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB600\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B queue_without_daemon<br>
=C2=A0If set to<br>
@@ -408,18 +448,26 @@ for IO to return from the device after multipathd has=
 been stopped. Without<br>
=C2=A0multipathd running, access to the paths cannot be restored, and the k=
ernel<br>
=C2=A0cannot be told to stop queueing IO. Setting queue_without_daemon to<b=
r>
=C2=A0.I no<br>
-, avoids this problem. Default is<br>
-.I no<br>
+, avoids this problem.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B bindings_file<br>
-The full pathname of the binding file to be used when the user_friendly_na=
mes option is set. Defaults to<br>
-.I /etc/multipath/bindings<br>
+The full pathname of the binding file to be used when the user_friendly_na=
mes option is set.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB/etc/multipath/bindings\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B wwids_file<br>
=C2=A0The full pathname of the wwids file, which is used by multipath to ke=
ep track<br>
=C2=A0of the wwids for LUNs it has created multipath devices on in the past=
.<br>
-Defaults to<br>
-.I /etc/multipath/wwids<br>
+.RS<br>
+.TP<br>
+Default value is: \fB/etc/multipath/wwids\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B log_checker_err<br>
=C2=A0If set to<br>
@@ -427,15 +475,22 @@ If set to<br>
=C2=A0, multipathd logs the first path checker error at logging level 2. An=
y later<br>
=C2=A0errors are logged at level 3 until the device is restored. If set to<=
br>
=C2=A0.I always<br>
-, multipathd always logs the path checker error at logging level 2. Defaul=
t is<br>
-.I always<br>
+, multipathd always logs the path checker error at logging level 2.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBalways\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B reservation_key<br>
=C2=A0This is the service action reservation key used by mpathpersist.=C2=
=A0 It must be<br>
=C2=A0set for all multipath devices using persistent reservations, and it m=
ust be<br>
=C2=A0the same as the RESERVATION KEY field of the PERSISTENT RESERVE OUT p=
arameter<br>
=C2=A0list which contains an 8-byte value provided by the application clien=
t to the<br>
-device server to identify the I_T nexus. It is unset by default.<br>
+device server to identify the I_T nexus.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB&lt;unset&gt;\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B retain_attached_hw_handler<br>
=C2=A0If set to<br>
@@ -443,8 +498,11 @@ If set to<br>
=C2=A0and the scsi layer has already attached a hardware_handler to the dev=
ice,<br>
=C2=A0multipath will not force the device to use the hardware_handler speci=
fied by<br>
=C2=A0mutipath.conf. If the scsi layer has not attached a hardware handler,=
<br>
-multipath will continue to use its configured hardware handler. Default is=
<br>
-.I no<br>
+multipath will continue to use its configured hardware handler.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B detect_prio<br>
=C2=A0If set to<br>
@@ -452,17 +510,22 @@ If set to<br>
=C2=A0, multipath will try to detect if the device supports ALUA. If so, th=
e device<br>
=C2=A0will automatically use the<br>
=C2=A0.I alua<br>
-prioritizer. If not, the prioritizer will be selected as usual. Default is=
<br>
-.I no<br>
+prioritizer. If not, the prioritizer will be selected as usual.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B force_sync<br>
=C2=A0If set to<br>
=C2=A0.I yes<br>
=C2=A0, multipathd will call the path checkers in sync mode only.=C2=A0 Thi=
s means that<br>
=C2=A0only one checker will run at a time.=C2=A0 This is useful in the case=
 where many<br>
-multipathd checkers running in parallel causes significant CPU pressure. T=
he<br>
-Default is<br>
-.I no<br>
+multipathd checkers running in parallel causes significant CPU pressure.<b=
r>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B deferred_remove<br>
=C2=A0If set to<br>
@@ -471,15 +534,21 @@ If set to<br>
=C2=A0last path device has been deleted.=C2=A0 This means that if the multi=
path device is<br>
=C2=A0still in use, it will be freed when the last user closes it.=C2=A0 If=
 path is added<br>
=C2=A0to the multipath device before the last user closes it, the deferred =
remove<br>
-will be canceled. Default is<br>
-.I no<br>
+will be canceled.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B config_dir<br>
=C2=A0If set to anything other than &quot;&quot;, multipath will search thi=
s directory<br>
=C2=A0alphabetically for file ending in &quot;.conf&quot; and it will read =
configuration<br>
=C2=A0information from them, just as if it was in /etc/multipath.conf.=C2=
=A0 config_dir<br>
-must either be &quot;&quot; or a fully qualified directory name. Default i=
s<br>
-.I &quot;/etc/multipath/conf.d&quot;<br>
+must either be &quot;&quot; or a fully qualified directory name.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB/etc/multipath/conf.d/\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B delay_watch_checks<br>
=C2=A0If set to a value greater than 0, multipathd will watch paths that ha=
ve<br>
@@ -487,8 +556,11 @@ recently become valid for this many checks.=C2=A0 If t=
hey fail again while they are<br>
=C2=A0being watched, when they next become valid, they will not be used unt=
il they<br>
=C2=A0have stayed up for<br>
=C2=A0.I delay_wait_checks<br>
-checks. Default is<br>
-.I no<br>
+checks.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B delay_wait_checks<br>
=C2=A0If set to a value greater than 0, when a device that has recently com=
e back<br>
@@ -497,8 +569,11 @@ online fails again within<br>
=C2=A0checks, the next time it comes back online, it will marked and delaye=
d, and not<br>
=C2=A0used until it has passed<br>
=C2=A0.I delay_wait_checks<br>
-checks. Default is<br>
-.I no<br>
+checks.<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B strict_timinig<br>
=C2=A0If set to<br>
@@ -511,8 +586,10 @@ here the missing ticks will be accounted for on the ne=
xt round.<br>
=C2=A0A warning will be printed if path checks take longer than<br>
=C2=A0.I polling_interval<br>
=C2=A0seconds.<br>
-Default is<br>
-.I no<br>
+.RS<br>
+.TP<br>
+Default value is: \fBno\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B uxsock_timeout<br>
=C2=A0CLI receive timeout in milliseconds. For larger systems CLI commands<=
br>
@@ -520,16 +597,21 @@ might timeout before the multipathd lock is released =
and the CLI command<br>
=C2=A0can be processed. This will result in errors like<br>
=C2=A0&quot;timeout receiving packet&quot; to be returned from CLI commands=
.<br>
=C2=A0In these cases it is recommended to increase the CLI timeout to avoid=
<br>
-those issues. The default is<br>
-.I 1000<br>
+those issues.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB1000\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B missing_uev_wait_timeout<br>
=C2=A0Controls how many seconds multipathd will wait, after a new multipath=
 device<br>
=C2=A0is created, to receive a change event from udev for the device, befor=
e<br>
=C2=A0automatically enabling device reloads. Usually multipathd will delay =
reloads<br>
-on a device until it receives a change uevent from the initial table load.=
 The<br>
-default is<br>
-.I 30<br>
+on a device until it receives a change uevent from the initial table load.=
<br>
+.RS<br>
+.TP<br>
+Default value is: \fB30\fR<br>
+.RE<br>
=C2=A0.<br>
=C2=A0.SH &quot;blacklist section&quot;<br>
=C2=A0The<br>
@@ -574,8 +656,11 @@ The following keywords are recognized:<br>
=C2=A0The \fIWorld Wide Identification\fR of a device.<br>
=C2=A0.TP<br>
=C2=A0.B property<br>
-Regular expression of the udev property to be whitelisted. Defaults to<br>
-.I (ID_WWN|SCSI_IDENT_.*)<br>
+Regular expression of the udev property to be whitelisted.<br>
+.RS<br>
+.TP<br>
+Default value is: \fB(ID_WWN|SCSI_IDENT_.*)\fR<br>
+.RE<br>
=C2=A0.TP<br>
=C2=A0.B devnode<br>
=C2=A0Regular expression of the device nodes to be whitelisted.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114128eeeae3ab05371a9dc8--


--===============5947012112530086483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5947012112530086483==--
