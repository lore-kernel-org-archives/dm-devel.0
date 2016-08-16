From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add queue_mode to the
	features list in multipath/multipath.conf.5
Date: Tue, 16 Aug 2016 09:49:19 +0200
Message-ID: <CABr-GneY4SqsKmRcyDSc4-t_PshUo7yANkFWisQtF7A0TGeP3A@mail.gmail.com>
References: <1471011841-4126-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7629029919810523756=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471011841-4126-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============7629029919810523756==
Content-Type: multipart/alternative; boundary=001a114102a41ec496053a2b967c

--001a114102a41ec496053a2b967c
Content-Type: text/plain; charset=UTF-8

Could you please rebase this one ?
Thanks.

On Fri, Aug 12, 2016 at 4:24 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> New undocumented feature, added in e83068a5f:
>
>     dm mpath: add optional "queue_mode" feature
>
>     Allow a user to specify an optional feature 'queue_mode <mode>' where
>     <mode> may be "bio", "rq" or "mq" -- which corresponds to bio-based,
>     request_fn rq-based, and blk-mq rq-based respectively.
>
>     If the queue_mode feature isn't specified the default for the
>     "multipath" target is still "rq" but if dm_mod.use_blk_mq is set to Y
>     it'll default to mode "mq".
>
>     This new queue_mode feature introduces the ability for each multipath
>     device to have its own queue_mode (whereas before this feature all
>     multipath devices effectively had to have the same queue_mode).
>
>
> Also add more info to other features.
>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath/multipath.conf.5 | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index fd4b1f2..40df315 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -3,11 +3,11 @@
>  .\" Make sure there are no errors with:
>  .\" groff -z -wall -b -e -t multipath/multipath.conf.5
>  .\"
> -.\" TODO: Look for XXX
> +.\" TODO: Look for XXX and ???
>  .\"
>  .\" ------------------------------------------------------------
> ----------------
>  .
> -.TH MULTIPATH.CONF 5 2016-08-09 "Linux"
> +.TH MULTIPATH.CONF 5 2016-08-12 "Linux"
>  .
>  .
>  .\" ------------------------------------------------------------
> ----------------
> @@ -166,12 +166,15 @@ Loop through every path in the path group, sending
> the same amount of IO to
>  each. Some aspects of behavior can be controlled with the attributes:
>  \fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
>  .TP
> +.\" XXX
>  .I "queue-length 0"
> -Send the next bunch of IO down the path with the least amount of
> outstanding IO.
> +(Since ??? kernel) Choose the path for the next bunch of IO based on the
> amount
> +of outstanding IO to the path.
>  .TP
> +.\" XXX
>  .I "service-time 0"
> -Choose the path for the next bunch of IO based on the amount of
> outstanding IO
> -to the path and its relative throughput.
> +(Since ??? kernel) Choose the path for the next bunch of IO based on the
> amount
> +of outstanding IO to the path and its relative throughput.
>  .TP
>  Default value is: \fBservice-time 0\fR
>  .RE
> @@ -333,22 +336,31 @@ Default value is: \fB<unset>\fR
>  .TP
>  .B features
>  Specify any device-mapper features to be used. Syntax is \fInum list\fR
> -where \fInum\fR is the number, between 0 and 6, of features in \fIlist\fR.
> +where \fInum\fR is the number, between 0 and 8, of features in \fIlist\fR.
>  Possible values for the feature list are:
>  .RS
>  .TP 12
> +.\" XXX
>  .I queue_if_no_path
> -(Superseded by \fIno_path_retry\fR) Queue IO if no path is active.
> Identical to
> -the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.
> +(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue IO if no
> path is active.
> +Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN
> ISSUES.
>  .TP
>  .I no_partitions
>  Disable automatic partitions generation via kpartx.
>  .TP
> -.I pg_init_retries
> -Number of times to retry pg_init, it must be between 1 and 50.
> +.\" XXX
> +.I pg_init_retries <times>
> +(Since ??? kernel) Number of times to retry pg_init, it must be between 1
> and 50.
>  .TP
> -.I pg_init_delay_msecs
> -Number of msecs before pg_init retry, it must be between 0 and 60000.
> +.\" XXX
> +.I pg_init_delay_msecs <msecs>
> +(Since ??? kernel) Number of msecs before pg_init retry, it must be
> between 0 and 60000.
> +.TP
> +.\" XXX
> +.I queue_mode <mode>
> +(Since ??? kernel) Select the the queue_mode per multipath device.
> +Where <mode> can be \fIbio\fR, \fIrq\fR or \fImq\fR. Which corresponds to
> +bio-based, request_fn rq-based, and blk-mq rq-based respectively.
>  .TP
>  Default value is: \fB0\fR
>  .RE
> --
> 2.7.4
>
>

--001a114102a41ec496053a2b967c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Could you please rebase this one ?<div>Thanks.</div></div>=
<div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Aug 12, 2=
016 at 4:24 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:=
xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</s=
pan> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex">New undocumented feature, add=
ed in e83068a5f:<br>
<br>
=C2=A0 =C2=A0 dm mpath: add optional &quot;queue_mode&quot; feature<br>
<br>
=C2=A0 =C2=A0 Allow a user to specify an optional feature &#39;queue_mode &=
lt;mode&gt;&#39; where<br>
=C2=A0 =C2=A0 &lt;mode&gt; may be &quot;bio&quot;, &quot;rq&quot; or &quot;=
mq&quot; -- which corresponds to bio-based,<br>
=C2=A0 =C2=A0 request_fn rq-based, and blk-mq rq-based respectively.<br>
<br>
=C2=A0 =C2=A0 If the queue_mode feature isn&#39;t specified the default for=
 the<br>
=C2=A0 =C2=A0 &quot;multipath&quot; target is still &quot;rq&quot; but if d=
m_mod.use_blk_mq is set to Y<br>
=C2=A0 =C2=A0 it&#39;ll default to mode &quot;mq&quot;.<br>
<br>
=C2=A0 =C2=A0 This new queue_mode feature introduces the ability for each m=
ultipath<br>
=C2=A0 =C2=A0 device to have its own queue_mode (whereas before this featur=
e all<br>
=C2=A0 =C2=A0 multipath devices effectively had to have the same queue_mode=
).<br>
<br>
<br>
Also add more info to other features.<br>
<br>
Cc: Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com">snitzer@redhat.c=
om</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0multipath/multipath.conf.5 | 36 ++++++++++++++++++++++++------<wbr>--=
----<br>
=C2=A01 file changed, 24 insertions(+), 12 deletions(-)<br>
<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index fd4b1f2..40df315 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -3,11 +3,11 @@<br>
=C2=A0.\&quot; Make sure there are no errors with:<br>
=C2=A0.\&quot; groff -z -wall -b -e -t multipath/multipath.conf.5<br>
=C2=A0.\&quot;<br>
-.\&quot; TODO: Look for XXX<br>
+.\&quot; TODO: Look for XXX and ???<br>
=C2=A0.\&quot;<br>
=C2=A0.\&quot; ------------------------------<wbr>-------------------------=
-----<wbr>----------------<br>
=C2=A0.<br>
-.TH MULTIPATH.CONF 5 2016-08-09 &quot;Linux&quot;<br>
+.TH MULTIPATH.CONF 5 2016-08-12 &quot;Linux&quot;<br>
=C2=A0.<br>
=C2=A0.<br>
=C2=A0.\&quot; ------------------------------<wbr>-------------------------=
-----<wbr>----------------<br>
@@ -166,12 +166,15 @@ Loop through every path in the path group, sending th=
e same amount of IO to<br>
=C2=A0each. Some aspects of behavior can be controlled with the attributes:=
<br>
=C2=A0\fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.<br>
=C2=A0.TP<br>
+.\&quot; XXX<br>
=C2=A0.I &quot;queue-length 0&quot;<br>
-Send the next bunch of IO down the path with the least amount of outstandi=
ng IO.<br>
+(Since ??? kernel) Choose the path for the next bunch of IO based on the a=
mount<br>
+of outstanding IO to the path.<br>
=C2=A0.TP<br>
+.\&quot; XXX<br>
=C2=A0.I &quot;service-time 0&quot;<br>
-Choose the path for the next bunch of IO based on the amount of outstandin=
g IO<br>
-to the path and its relative throughput.<br>
+(Since ??? kernel) Choose the path for the next bunch of IO based on the a=
mount<br>
+of outstanding IO to the path and its relative throughput.<br>
=C2=A0.TP<br>
=C2=A0Default value is: \fBservice-time 0\fR<br>
=C2=A0.RE<br>
@@ -333,22 +336,31 @@ Default value is: \fB&lt;unset&gt;\fR<br>
=C2=A0.TP<br>
=C2=A0.B features<br>
=C2=A0Specify any device-mapper features to be used. Syntax is \fInum list\=
fR<br>
-where \fInum\fR is the number, between 0 and 6, of features in \fIlist\fR.=
<br>
+where \fInum\fR is the number, between 0 and 8, of features in \fIlist\fR.=
<br>
=C2=A0Possible values for the feature list are:<br>
=C2=A0.RS<br>
=C2=A0.TP 12<br>
+.\&quot; XXX<br>
=C2=A0.I queue_if_no_path<br>
-(Superseded by \fIno_path_retry\fR) Queue IO if no path is active. Identic=
al to<br>
-the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISSUES.<br>
+(Superseded by \fIno_path_retry\fR) (Since ??? kernel) Queue IO if no path=
 is active.<br>
+Identical to the \fIno_path_retry\fR with \fIqueue\fR value. See KNOWN ISS=
UES.<br>
=C2=A0.TP<br>
=C2=A0.I no_partitions<br>
=C2=A0Disable automatic partitions generation via kpartx.<br>
=C2=A0.TP<br>
-.I pg_init_retries<br>
-Number of times to retry pg_init, it must be between 1 and 50.<br>
+.\&quot; XXX<br>
+.I pg_init_retries &lt;times&gt;<br>
+(Since ??? kernel) Number of times to retry pg_init, it must be between 1 =
and 50.<br>
=C2=A0.TP<br>
-.I pg_init_delay_msecs<br>
-Number of msecs before pg_init retry, it must be between 0 and 60000.<br>
+.\&quot; XXX<br>
+.I pg_init_delay_msecs &lt;msecs&gt;<br>
+(Since ??? kernel) Number of msecs before pg_init retry, it must be betwee=
n 0 and 60000.<br>
+.TP<br>
+.\&quot; XXX<br>
+.I queue_mode &lt;mode&gt;<br>
+(Since ??? kernel) Select the the queue_mode per multipath device.<br>
+Where &lt;mode&gt; can be \fIbio\fR, \fIrq\fR or \fImq\fR. Which correspon=
ds to<br>
+bio-based, request_fn rq-based, and blk-mq rq-based respectively.<br>
=C2=A0.TP<br>
=C2=A0Default value is: \fB0\fR<br>
=C2=A0.RE<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114102a41ec496053a2b967c--


--===============7629029919810523756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7629029919810523756==--
