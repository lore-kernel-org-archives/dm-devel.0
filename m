From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2] multipath-tools: add availability of
 service-time and queue-length to multipath.conf.5
Date: Mon, 27 Feb 2017 06:46:02 +0100
Message-ID: <CABr-Gnfae1rsKrxsLrJxVoJHLhrHD3MZOPVgqjskSM41Q1=_pA@mail.gmail.com>
References: <20170221213108.4126-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2314102605048886335=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170221213108.4126-1-xose.vazquez@gmail.com>
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

--===============2314102605048886335==
Content-Type: multipart/alternative; boundary=001a11c0004444619005497c983b

--001a11c0004444619005497c983b
Content-Type: text/plain; charset=UTF-8

Applied.

On Tue, Feb 21, 2017 at 10:31 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> https://kernelnewbies.org/Linux_2_6_31#head-7a4afa809f53cf9a2df884c745f4f8
> 150e24645a
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> v2 - remove XXX tags
> ---
>  multipath/multipath.conf.5 | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 7de8bc7..4961c06 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -166,14 +166,12 @@ Loop through every path in the path group, sending
> the same amount of I/O to
>  each. Some aspects of behavior can be controlled with the attributes:
>  \fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.
>  .TP
> -.\" XXX
>  .I "queue-length 0"
> -(Since ??? kernel) Choose the path for the next bunch of I/O based on the
> amount
> +(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on
> the amount
>  of outstanding I/O to the path.
>  .TP
> -.\" XXX
>  .I "service-time 0"
> -(Since ??? kernel) Choose the path for the next bunch of I/O based on the
> amount
> +(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on
> the amount
>  of outstanding I/O to the path and its relative throughput.
>  .TP
>  The default is: \fBservice-time 0\fR
> --
> 2.11.1
>
>

--001a11c0004444619005497c983b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Tue, Feb 21, 2017 at 10:31 PM, Xose Vazquez Perez <span di=
r=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">x=
ose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><span class=3D""><a href=3D"https://kernelnewbies.org/Linux_2_6_31#head-=
7a4afa809f53cf9a2df884c745f4f8150e24645a" rel=3D"noreferrer" target=3D"_bla=
nk">https://kernelnewbies.org/<wbr>Linux_2_6_31#head-<wbr>7a4afa809f53cf9a2=
df884c745f4f8<wbr>150e24645a</a><br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
</span>v2 - remove XXX tags<br>
---<br>
=C2=A0multipath/multipath.conf.5 | 6 ++----<br>
=C2=A01 file changed, 2 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 7de8bc7..4961c06 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -166,14 +166,12 @@ Loop through every path in the path group, sending th=
e same amount of I/O to<br>
<span class=3D"">=C2=A0each. Some aspects of behavior can be controlled wit=
h the attributes:<br>
</span>=C2=A0\fIrr_min_io\fR, \fIrr_min_io_rq\fR and \fIrr_weight\fR.<br>
=C2=A0.TP<br>
-.\&quot; XXX<br>
<span class=3D"">=C2=A0.I &quot;queue-length 0&quot;<br>
-(Since ??? kernel) Choose the path for the next bunch of I/O based on the =
amount<br>
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on t=
he amount<br>
=C2=A0of outstanding I/O to the path.<br>
=C2=A0.TP<br>
</span>-.\&quot; XXX<br>
<div class=3D"HOEnZb"><div class=3D"h5">=C2=A0.I &quot;service-time 0&quot;=
<br>
-(Since ??? kernel) Choose the path for the next bunch of I/O based on the =
amount<br>
+(Since 2.6.31 kernel) Choose the path for the next bunch of I/O based on t=
he amount<br>
=C2=A0of outstanding I/O to the path and its relative throughput.<br>
=C2=A0.TP<br>
=C2=A0The default is: \fBservice-time 0\fR<br>
--<br>
2.11.1<br>
<br>
</div></div></blockquote></div><br></div>

--001a11c0004444619005497c983b--


--===============2314102605048886335==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2314102605048886335==--
