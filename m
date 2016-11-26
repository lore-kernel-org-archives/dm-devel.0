From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add Promise/Vess to hwtable
Date: Sat, 26 Nov 2016 09:59:34 +0100
Message-ID: <CABr-GnetsVNzjoW52mao8KkOarJEq+Z0S8ooV54tNpcyUD1AQg@mail.gmail.com>
References: <20161121221726.6877-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3652708617159364254=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161121221726.6877-1-xose.vazquez@gmail.com>
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

--===============3652708617159364254==
Content-Type: multipart/alternative; boundary=f403045ecf0a2e8b1e05423075a3

--f403045ecf0a2e8b1e05423075a3
Content-Type: text/plain; charset=UTF-8

Applied, thanks.

On Mon, Nov 21, 2016 at 11:17 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index c46b072..efccca9 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1037,6 +1037,16 @@ static struct hwentry default_hw[] = {
>                 .pgpolicy      = MULTIBUS,
>                 .no_path_retry = 30,
>         },
> +       {
> +               .vendor        = "Promise",
> +               .product       = "Vess",
> +               .bl_product    = "Vess V-LUN",
> +               .hwhandler     = "1 alua",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .prio_name     = PRIO_ALUA,
> +               .no_path_retry = 30,
> +       },
>         /*
>          * Infortrend Technology
>          */
> --
> 2.10.2
>
>

--f403045ecf0a2e8b1e05423075a3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied, thanks.</div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Mon, Nov 21, 2016 at 11:17 PM, Xose Vazquez Perez =
<span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_=
blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@=
opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 10 ++++++++++<br>
=C2=A01 file changed, 10 insertions(+)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index c46b072..efccca9 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -1037,6 +1037,16 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
30,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;Promise&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;Vess&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.bl_product=C2=A0 =
=C2=A0 =3D &quot;Vess V-LUN&quot;,<br>
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
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Infortrend Technology<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.2<br>
<br>
</font></span></blockquote></div><br></div>

--f403045ecf0a2e8b1e05423075a3--


--===============3652708617159364254==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3652708617159364254==--
