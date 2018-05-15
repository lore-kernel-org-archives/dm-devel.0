From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: configure hitachi ams2000
 and hus100 as full active arrays
Date: Tue, 15 May 2018 14:58:42 +0200
Message-ID: <CABr-GncNCnnckXaBO_=6EzHXUTLYvrix_UqNBaS31p3tPXmRjQ@mail.gmail.com>
References: <20180514153017.7193-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1651790019868940887=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180514153017.7193-1-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, DM-DEV ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1651790019868940887==
Content-Type: multipart/alternative; boundary="0000000000007461c5056c3e29a2"

--0000000000007461c5056c3e29a2
Content-Type: text/plain; charset="UTF-8"

Merged,
thanks.

On Mon, May 14, 2018 at 5:30 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> AMS2000 and HUS100 families are active/active arrays.
>
> Based on https://support.hitachivantara.com/download/epcra/df818913.pdf
> and internal hitachi docs.
>
>
> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEV ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 827e899..9705025 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -398,13 +398,13 @@ static struct hwentry default_hw[] = {
>          * Mail : matthias.rudolph@hds.com
>          */
>         {
> -               /* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families */
> +               /* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families /
> HP XP */
>                 .vendor        = "(HITACHI|HP)",
>                 .product       = "^OPEN-",
>                 .pgpolicy      = MULTIBUS,
>         },
>         {
> -               /* AMS 2000 and HUS 100 families */
> +               /* AMS other than AMS 2000 */
>                 .vendor        = "HITACHI",
>                 .product       = "^DF",
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
> @@ -412,6 +412,12 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .prio_name     = PRIO_HDS,
>         },
> +       {
> +               /* AMS 2000 and HUS 100 families */
> +               .vendor        = "HITACHI",
> +               .product       = "^DF600F",
> +               .pgpolicy      = MULTIBUS,
> +       },
>         /*
>          * IBM
>          *
> --
> 2.17.0
>
>

--0000000000007461c5056c3e29a2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged,<div>thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, May 14, 2018 at 5:30 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">AMS2000 and HUS100 families are active/active arrays.<br=
>
<br>
Based on <a href=3D"https://support.hitachivantara.com/download/epcra/df818=
913.pdf" rel=3D"noreferrer" target=3D"_blank">https://support.<wbr>hitachiv=
antara.com/download/<wbr>epcra/df818913.pdf</a><br>
and internal hitachi docs.<br>
<br>
<br>
Cc: Matthias Rudolph &lt;<a href=3D"mailto:Matthias.Rudolph@hitachivantara.=
com">Matthias.Rudolph@<wbr>hitachivantara.com</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: DM-DEV ML &lt;<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.co=
m</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 10 ++++++++--<br>
=C2=A01 file changed, 8 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 827e899..9705025 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -398,13 +398,13 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Mail : <a href=3D"mailto:matthias.rudol=
ph@hds.com">matthias.rudolph@hds.com</a><br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* USP-V, HUS VM, V=
SP, VSP G1X00 and VSP GX00 families */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* USP-V, HUS VM, V=
SP, VSP G1X00 and VSP GX00 families / HP XP */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;(HITACHI|HP)&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^OPEN-&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* AMS 2000 and HUS=
 100 families */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* AMS other than A=
MS 2000 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;HITACHI&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^DF&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
NO_PATH_RETRY_QUEUE,<br>
@@ -412,6 +412,12 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D -FAILBACK_IMMEDIATE,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .prio_name=C2=A0 =
=C2=A0 =C2=A0=3D PRIO_HDS,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* AMS 2000 and HUS=
 100 families */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;HITACHI&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^DF600F&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* IBM<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*<br>
<span class=3D"HOEnZb"><font color=3D"#888888">-- <br>
2.17.0<br>
<br>
</font></span></blockquote></div><br></div>

--0000000000007461c5056c3e29a2--


--===============1651790019868940887==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1651790019868940887==--
