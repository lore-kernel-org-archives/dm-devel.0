From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add Nexsan NST and UNITY
	families to hwtable
Date: Sat, 26 Nov 2016 10:11:44 +0100
Message-ID: <CABr-GnfZiLG6=QQkNG608Y7_FOWKZcLN5mWkDRe+NjHcHOQ1aw@mail.gmail.com>
References: <20161126023758.13346-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0865431825387891890=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161126023758.13346-1-xose.vazquez@gmail.com>
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

--===============0865431825387891890==
Content-Type: multipart/alternative; boundary=001a11411c76ac8e9a054230a018

--001a11411c76ac8e9a054230a018
Content-Type: text/plain; charset=UTF-8

Applied, thanks

On Sat, Nov 26, 2016 at 3:37 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index c0bfa75..c6fc3d1 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -992,6 +992,16 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>                 .no_path_retry = 15,
>         },
> +       {
> +               /* NST / UNITY */
> +               .vendor        = "Nexsan",
> +               .product       = "(NestOS|NST5000)",
> +               .hwhandler     = "1 alua",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .prio_name     = PRIO_ALUA,
> +               .no_path_retry = 30,
> +       },
>         /*
>          * Xiotech
>          */
> --
> 2.10.2
>
>

--001a11411c76ac8e9a054230a018
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied, thanks</div><div class=3D"gmail_extra"><br><div c=
lass=3D"gmail_quote">On Sat, Nov 26, 2016 at 3:37 AM, Xose Vazquez Perez <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_bl=
ank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@op=
ensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 10 ++++++++++<br>
=C2=A01 file changed, 10 insertions(+)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index c0bfa75..c6fc3d1 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -992,6 +992,16 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
15,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* NST / UNITY */<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;Nexsan&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;(NestOS|NST5000)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.hwhandler=C2=A0 =
=C2=A0 =C2=A0=3D &quot;1 alua&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.no_path_retry =3D =
30,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Xiotech<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a11411c76ac8e9a054230a018--


--===============0865431825387891890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0865431825387891890==--
