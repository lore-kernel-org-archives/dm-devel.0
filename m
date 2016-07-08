From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 1/9] multipath-tools: add iSCSI product id
	for TEGILE ZEBI
Date: Fri, 8 Jul 2016 08:36:13 +0200
Message-ID: <CABr-Gneys8z8v2DANxGWJTN=DPqg8mfjMD+POEfMoCWZUZLneg@mail.gmail.com>
References: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1432235205208916250=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466469364-14446-1-git-send-email-xose.vazquez@gmail.com>
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

--===============1432235205208916250==
Content-Type: multipart/alternative; boundary=001a11401ac2e0c11705371a0460

--001a11401ac2e0c11705371a0460
Content-Type: text/plain; charset=UTF-8

All nine patches of this set are merged.
Thanks.

On Tue, Jun 21, 2016 at 2:35 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Devices running 2.x firmware has a different product id for iSCSI.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 6116124..fb38320 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1195,7 +1195,7 @@ static struct hwentry default_hw[] = {
>          */
>         {
>                 .vendor        = "TEGILE",
> -               .product       = "ZEBI-FC|INTELLIFLASH",
> +               .product       = "ZEBI-(FC|ISCSI)|INTELLIFLASH",
>                 .hwhandler     = "1 alua",
>                 .selector      = "round-robin 0",
>                 .pgpolicy      = GROUP_BY_PRIO,
> --
> 2.5.5
>
>

--001a11401ac2e0c11705371a0460
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">All nine patches of this set are merged.<div>Thanks.</div>=
</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Jun=
 21, 2016 at 2:35 AM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&=
gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Devices running 2.x fir=
mware has a different product id for iSCSI.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 6116124..fb38320 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -1195,7 +1195,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;TEGILE&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;ZEBI-FC|INTELLIFLASH&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;ZEBI-(FC|ISCSI)|INTELLIFLASH&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .hwhandler=C2=A0 =
=C2=A0 =C2=A0=3D &quot;1 alua&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .selector=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;round-robin 0&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br></div>

--001a11401ac2e0c11705371a0460--


--===============1432235205208916250==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1432235205208916250==--
