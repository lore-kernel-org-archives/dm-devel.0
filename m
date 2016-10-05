From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add IBM/3552 (FAStT500)
	array
Date: Wed, 5 Oct 2016 08:03:57 +0200
Message-ID: <CABr-Gndy+pViEbL1JG1tM4jk=Ro+i_Pvv8gRMs0c+hY0qr5S3Q@mail.gmail.com>
References: <20161004213902.2982-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1572764852421229469=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161004213902.2982-1-xose.vazquez@gmail.com>
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

--===============1572764852421229469==
Content-Type: multipart/alternative; boundary=94eb2c0db23a689c31053e17f1a3

--94eb2c0db23a689c31053e17f1a3
Content-Type: text/plain; charset=UTF-8

Applied.

On Tue, Oct 4, 2016 at 11:39 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Vendor doc: https://www.redbooks.ibm.com/redbooks/pdfs/sg246246.pdf
> This also confirms that IBM/3542 (FAStT200) is really a RDAC device.
> Both of them run the same firmware.
>
> DS4200 tag is wrong.
>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index b8d9196..bfd8d66 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -422,9 +422,9 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = 30,
>         },
>         {
> -               /* DS4200 / FAStT200 */
> +               /* FAStT200 and FAStT500 */
>                 .vendor        = "IBM",
> -               .product       = "^3542",
> +               .product       = "^(3542|3552)",
>                 .bl_product    = "Universal Xport",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .checker_name  = RDAC,
> --
> 2.10.1
>
>

--94eb2c0db23a689c31053e17f1a3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.</div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Tue, Oct 4, 2016 at 11:39 PM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Vendor doc: <a href=3D"https://www.redbooks.ibm.com/redbooks/pdfs/sg24624=
6.pdf" rel=3D"noreferrer" target=3D"_blank">https://www.redbooks.ibm.com/<w=
br>redbooks/pdfs/sg246246.pdf</a><br>
This also confirms that IBM/3542 (FAStT200) is really a RDAC device.<br>
Both of them run the same firmware.<br>
<br>
DS4200 tag is wrong.<br>
<br>
Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt=
;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 4 ++--<br>
=C2=A01 file changed, 2 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index b8d9196..bfd8d66 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -422,9 +422,9 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
30,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* DS4200 / FAStT20=
0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* FAStT200 and FAS=
tT500 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^3542&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^(3542|3552)&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bl_product=C2=A0 =
=C2=A0 =3D &quot;Universal Xport&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .checker_name=C2=A0=
 =3D RDAC,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c0db23a689c31053e17f1a3--


--===============1572764852421229469==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1572764852421229469==--
