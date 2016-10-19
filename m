From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace IO by I/O in
	multipath.conf.5
Date: Wed, 19 Oct 2016 08:07:18 +0200
Message-ID: <CABr-Gnewfrj3gfOgzzcV4-YWaHfynk4J51GGCEBWMqvTGxPB+A@mail.gmail.com>
References: <20161017212932.2811-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3816385284599086393=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161017212932.2811-1-xose.vazquez@gmail.com>
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

--===============3816385284599086393==
Content-Type: multipart/alternative; boundary=001a113f188620c339053f319fd8

--001a113f188620c339053f319fd8
Content-Type: text/plain; charset=UTF-8

Merged.

On Mon, Oct 17, 2016 at 11:29 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> to be consistent with the rest of the text.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5 | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 4ab2917..eec319f 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -7,7 +7,7 @@
>  .\"
>  .\" ------------------------------------------------------------
> ----------------
>  .
> -.TH MULTIPATH.CONF 5 2016-08-12 "Linux"
> +.TH MULTIPATH.CONF 5 2016-10-18 "Linux"
>  .
>  .
>  .\" ------------------------------------------------------------
> ----------------
> @@ -162,19 +162,19 @@ kernel multipath target. There are three selector
> algorithms:
>  .RS
>  .TP 12
>  .I "round-robin 0"
> -Loop through every path in the path group, sending the same amount of IO
> to
> +Loop through every path in the path group, sending the same amount of I/O
> to
>  each. Some aspects of behavior can be controlled with the attributes:
>  \fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
>  .TP
>  .\" XXX
>  .I "queue-length 0"
> -(Since ??? kernel) Choose the path for the next bunch of IO based on the
> amount
> -of outstanding IO to the path.
> +(Since ??? kernel) Choose the path for the next bunch of I/O based on the
> amount
> +of outstanding I/O to the path.
>  .TP
>  .\" XXX
>  .I "service-time 0"
> -(Since ??? kernel) Choose the path for the next bunch of IO based on the
> amount
> -of outstanding IO to the path and its relative throughput.
> +(Since ??? kernel) Choose the path for the next bunch of I/O based on the
> amount
> +of outstanding I/O to the path and its relative throughput.
>  .TP
>  Default value is: \fBservice-time 0\fR
>  .RE
> @@ -342,7 +342,7 @@ Possible values for the feature list are:
>  .TP 12
>  .\" XXX
>  .I queue_if_no_path
> -(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue IO if no
> path is active.
> +(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue I/O if no
> path is active.
>  Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN
> ISSUES.
>  .TP
>  .I no_partitions
> @@ -448,7 +448,7 @@ Default value is: \fBmanual\fR
>  .
>  .TP
>  .B  rr_min_io
> -Number of IO requests to route to a path before switching to the next in
> the
> +Number of I/O requests to route to a path before switching to the next in
> the
>  same path group. This is only for \fIBlock I/O\fR(BIO) based multipath and
>  only apply to \fIround-robin\fR path_selector.
>  .RS
> @@ -459,7 +459,7 @@ Default value is: \fB1000\fR
>  .
>  .TP
>  .B rr_min_io_rq
> -Number of IO requests to route to a path before switching to the next in
> the
> +Number of I/O requests to route to a path before switching to the next in
> the
>  same path group. This is only for \fIRequest\fR based multipath and
>  only apply to \fIround-robin\fR path_selector.
>  .RS
> @@ -523,9 +523,9 @@ If set to
>  , when multipathd stops, queueing will be turned off for all devices.
>  This is useful for devices that set no_path_retry. If a machine is
>  shut down while all paths to a device are down, it is possible to hang
> waiting
> -for IO to return from the device after multipathd has been stopped.
> Without
> +for I/O to return from the device after multipathd has been stopped.
> Without
>  multipathd running, access to the paths cannot be restored, and the kernel
> -cannot be told to stop queueing IO. Setting queue_without_daemon to
> +cannot be told to stop queueing I/O. Setting queue_without_daemon to
>  .I no
>  , avoids this problem.
>  .RS
> @@ -574,7 +574,7 @@ Default value is: \fBno\fR
>  .TP
>  .B fast_io_fail_tmo
>  Specify the number of seconds the SCSI layer will wait after a problem
> has been
> -detected on a FC remote port before failing IO to devices on that remote
> port.
> +detected on a FC remote port before failing I/O to devices on that remote
> port.
>  This should be smaller than dev_loss_tmo. Setting this to
>  .I off
>  will disable the timeout.
> --
> 2.10.1
>
>

--001a113f188620c339053f319fd8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Mon, Oct 17, 2016 at 11:29 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">to be consistent with the rest of the text.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipath/multipath.conf.5 | 24 ++++++++++++------------<br>
=C2=A01 file changed, 12 insertions(+), 12 deletions(-)<br>
<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 4ab2917..eec319f 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -7,7 +7,7 @@<br>
=C2=A0.\&quot;<br>
=C2=A0.\&quot; ------------------------------<wbr>-------------------------=
-----<wbr>----------------<br>
=C2=A0.<br>
-.TH MULTIPATH.CONF 5 2016-08-12 &quot;Linux&quot;<br>
+.TH MULTIPATH.CONF 5 2016-10-18 &quot;Linux&quot;<br>
=C2=A0.<br>
=C2=A0.<br>
=C2=A0.\&quot; ------------------------------<wbr>-------------------------=
-----<wbr>----------------<br>
@@ -162,19 +162,19 @@ kernel multipath target. There are three selector alg=
orithms:<br>
=C2=A0.RS<br>
=C2=A0.TP 12<br>
=C2=A0.I &quot;round-robin 0&quot;<br>
-Loop through every path in the path group, sending the same amount of IO t=
o<br>
+Loop through every path in the path group, sending the same amount of I/O =
to<br>
=C2=A0each. Some aspects of behavior can be controlled with the attributes:=
<br>
=C2=A0\fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.<br>
=C2=A0.TP<br>
=C2=A0.\&quot; XXX<br>
=C2=A0.I &quot;queue-length 0&quot;<br>
-(Since ??? kernel) Choose the path for the next bunch of IO based on the a=
mount<br>
-of outstanding IO to the path.<br>
+(Since ??? kernel) Choose the path for the next bunch of I/O based on the =
amount<br>
+of outstanding I/O to the path.<br>
=C2=A0.TP<br>
=C2=A0.\&quot; XXX<br>
=C2=A0.I &quot;service-time 0&quot;<br>
-(Since ??? kernel) Choose the path for the next bunch of IO based on the a=
mount<br>
-of outstanding IO to the path and its relative throughput.<br>
+(Since ??? kernel) Choose the path for the next bunch of I/O based on the =
amount<br>
+of outstanding I/O to the path and its relative throughput.<br>
=C2=A0.TP<br>
=C2=A0Default value is: \fBservice-time 0\fR<br>
=C2=A0.RE<br>
@@ -342,7 +342,7 @@ Possible values for the feature list are:<br>
=C2=A0.TP 12<br>
=C2=A0.\&quot; XXX<br>
=C2=A0.I queue_if_no_path<br>
-(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue IO if no path=
 is active.<br>
+(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue I/O if no pat=
h is active.<br>
=C2=A0Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOW=
N ISSUES.<br>
=C2=A0.TP<br>
=C2=A0.I no_partitions<br>
@@ -448,7 +448,7 @@ Default value is: \fBmanual\fR<br>
=C2=A0.<br>
=C2=A0.TP<br>
=C2=A0.B=C2=A0 rr_min_io<br>
-Number of IO requests to route to a path before switching to the next in t=
he<br>
+Number of I/O requests to route to a path before switching to the next in =
the<br>
=C2=A0same path group. This is only for \fIBlock I/O\fR(BIO) based multipat=
h and<br>
=C2=A0only apply to \fIround-robin\fR path_selector.<br>
=C2=A0.RS<br>
@@ -459,7 +459,7 @@ Default value is: \fB1000\fR<br>
=C2=A0.<br>
=C2=A0.TP<br>
=C2=A0.B rr_min_io_rq<br>
-Number of IO requests to route to a path before switching to the next in t=
he<br>
+Number of I/O requests to route to a path before switching to the next in =
the<br>
=C2=A0same path group. This is only for \fIRequest\fR based multipath and<b=
r>
=C2=A0only apply to \fIround-robin\fR path_selector.<br>
=C2=A0.RS<br>
@@ -523,9 +523,9 @@ If set to<br>
=C2=A0, when multipathd stops, queueing will be turned off for all devices.=
<br>
=C2=A0This is useful for devices that set no_path_retry. If a machine is<br=
>
=C2=A0shut down while all paths to a device are down, it is possible to han=
g waiting<br>
-for IO to return from the device after multipathd has been stopped. Withou=
t<br>
+for I/O to return from the device after multipathd has been stopped. Witho=
ut<br>
=C2=A0multipathd running, access to the paths cannot be restored, and the k=
ernel<br>
-cannot be told to stop queueing IO. Setting queue_without_daemon to<br>
+cannot be told to stop queueing I/O. Setting queue_without_daemon to<br>
=C2=A0.I no<br>
=C2=A0, avoids this problem.<br>
=C2=A0.RS<br>
@@ -574,7 +574,7 @@ Default value is: \fBno\fR<br>
=C2=A0.TP<br>
=C2=A0.B fast_io_fail_tmo<br>
=C2=A0Specify the number of seconds the SCSI layer will wait after a proble=
m has been<br>
-detected on a FC remote port before failing IO to devices on that remote p=
ort.<br>
+detected on a FC remote port before failing I/O to devices on that remote =
port.<br>
=C2=A0This should be smaller than dev_loss_tmo. Setting this to<br>
=C2=A0.I off<br>
=C2=A0will disable the timeout.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113f188620c339053f319fd8--


--===============3816385284599086393==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3816385284599086393==--
