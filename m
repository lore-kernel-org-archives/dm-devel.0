From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: convert Promise/VTrak to
	ALUA
Date: Sat, 26 Nov 2016 10:01:08 +0100
Message-ID: <CABr-GneGifcnJmcSRs+XnUNy0omN5ZMpPeChKegmKh-+fBYdXg@mail.gmail.com>
References: <20161121221726.6877-1-xose.vazquez@gmail.com>
	<20161121221726.6877-2-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4099027617497217105=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161121221726.6877-2-xose.vazquez@gmail.com>
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

--===============4099027617497217105==
Content-Type: multipart/alternative; boundary=94eb2c1a1b7ec477070542307a23

--94eb2c1a1b7ec477070542307a23
Content-Type: text/plain; charset=UTF-8

Applied, thanks.

On Mon, Nov 21, 2016 at 11:17 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> It's also supported.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index efccca9..eb7a5a0 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1034,7 +1034,10 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "Promise",
>                 .product       = "VTrak",
>                 .bl_product    = "VTrak V-LUN",
> -               .pgpolicy      = MULTIBUS,
> +               .hwhandler     = "1 alua",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .prio_name     = PRIO_ALUA,
>                 .no_path_retry = 30,
>         },
>         {
> --
> 2.10.2
>
>

--94eb2c1a1b7ec477070542307a23
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied, thanks.</div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Mon, Nov 21, 2016 at 11:17 PM, Xose Vazquez Perez =
<span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_=
blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">It&#39;s also supported.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 5 ++++-<br>
=C2=A01 file changed, 4 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index efccca9..eb7a5a0 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -1034,7 +1034,10 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;Promise&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;VTrak&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bl_product=C2=A0 =
=C2=A0 =3D &quot;VTrak V-LUN&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.hwhandler=C2=A0 =
=C2=A0 =C2=A0=3D &quot;1 alua&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_ALUA,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
30,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.2<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c1a1b7ec477070542307a23--


--===============4099027617497217105==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4099027617497217105==--
