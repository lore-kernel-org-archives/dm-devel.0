From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 01/18] multipath-tools: add KOVE/XPD to
	hwtable
Date: Sun, 31 Jul 2016 11:06:26 +0200
Message-ID: <CABr-GneKuiUW8_X_0wgr=Dfw042zot56AivyR-5eqOYXFuh1nA@mail.gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7633594751464157452=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Nick Russo <nick.russo@kove.net>
List-Id: dm-devel.ids

--===============7633594751464157452==
Content-Type: multipart/alternative; boundary=001a1140211e74c3e60538eacc5f

--001a1140211e74c3e60538eacc5f
Content-Type: text/plain; charset=UTF-8

Sorry this patchset will also need rebasing.
Thanks.

On Sat, Jul 30, 2016 at 2:28 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Info provided directly by the manufacturer - http://kove.net/xpd :
>
> .vendor        = "KOVE",
> .product       = "XPD",
> .features      = DEFAULT_FEATURES,
> .hwhandler     = DEFAULT_HWHANDLER,
> .selector      = "round-robin 0",
> .pgpolicy      = MULTIBUS,
> .pgfailback    = -FAILBACK_IMMEDIATE,
> .rr_weight     = RR_WEIGHT_NONE,
> .no_path_retry = DEFAULT_NO_PATH_RETRY,
> .minio         = DEFAULT_MINIO,
> .minio_rq      = DEFAULT_MINIO_RQ,
> .checker_name  = DIRECTIO,
> .prio_name     = DEFAULT_PRIO,
> .prio_args     = NULL,
>
> Cc: Nick Russo <nick.russo@kove.net>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 1efaeee..3e22714 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -771,6 +771,16 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = 30,
>                 .minio         = 128,
>         },
> +       /*
> +        * Kove
> +        */
> +       {
> +               .vendor        = "KOVE",
> +               .product       = "XPD",
> +               .selector      = "round-robin 0",
> +               .pgpolicy      = MULTIBUS,
> +               .no_path_retry = DEFAULT_NO_PATH_RETRY,
> +       },
>  #if 0
>         /*
>          * Copy this TEMPLATE to add new hardware.
> --
> 2.7.4
>
>

--001a1140211e74c3e60538eacc5f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry this patchset will also need rebasing.<div>Thanks.</=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Sat,=
 Jul 30, 2016 at 2:28 AM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=
=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Info provided dire=
ctly by the manufacturer - <a href=3D"http://kove.net/xpd" rel=3D"noreferre=
r" target=3D"_blank">http://kove.net/xpd</a> :<br>
<br>
.vendor=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D &quot;KOVE&quot;,<br>
.product=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D &quot;XPD&quot;,<br>
.features=C2=A0 =C2=A0 =C2=A0 =3D DEFAULT_FEATURES,<br>
.hwhandler=C2=A0 =C2=A0 =C2=A0=3D DEFAULT_HWHANDLER,<br>
.selector=C2=A0 =C2=A0 =C2=A0 =3D &quot;round-robin 0&quot;,<br>
.pgpolicy=C2=A0 =C2=A0 =C2=A0 =3D MULTIBUS,<br>
.pgfailback=C2=A0 =C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
.rr_weight=C2=A0 =C2=A0 =C2=A0=3D RR_WEIGHT_NONE,<br>
.no_path_retry =3D DEFAULT_NO_PATH_RETRY,<br>
.minio=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D DEFAULT_MINIO,<br>
.minio_rq=C2=A0 =C2=A0 =C2=A0 =3D DEFAULT_MINIO_RQ,<br>
.checker_name=C2=A0 =3D DIRECTIO,<br>
.prio_name=C2=A0 =C2=A0 =C2=A0=3D DEFAULT_PRIO,<br>
.prio_args=C2=A0 =C2=A0 =C2=A0=3D NULL,<br>
<br>
Cc: Nick Russo &lt;<a href=3D"mailto:nick.russo@kove.net">nick.russo@kove.n=
et</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 10 ++++++++++<br>
=C2=A01 file changed, 10 insertions(+)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 1efaeee..3e22714 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -771,6 +771,16 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D 30,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .minio=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0=3D 128,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Kove<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;KOVE&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;XPD&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.selector=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;round-robin 0&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path_retry =3D =
DEFAULT_NO_PATH_RETRY,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
=C2=A0#if 0<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Copy this TEMPLATE to add new hardware.=
<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a1140211e74c3e60538eacc5f--


--===============7633594751464157452==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7633594751464157452==--
