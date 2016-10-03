From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: merge emc and dell
Date: Mon, 3 Oct 2016 16:27:21 +0200
Message-ID: <CABr-GndBs1LHT+pnwspKXe95qz46DMLzdKstSnakrWbV7BeidA@mail.gmail.com>
References: <1474047440-3221-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7990890230590113680=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1474047440-3221-1-git-send-email-xose.vazquez@gmail.com>
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

--===============7990890230590113680==
Content-Type: multipart/alternative; boundary=001a113c9ea2fff176053df6bdf7

--001a113c9ea2fff176053df6bdf7
Content-Type: text/plain; charset=UTF-8

Rebased and merged.
Thanks.

On Fri, Sep 16, 2016 at 7:37 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> There can be only one.
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index aaf7480..b8b5bb7 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -150,7 +150,7 @@ static struct hwentry default_hw[] = {
>                 .product       = "SAN DataDirector",
>         },
>         /*
> -        * EMC
> +        * Dell EMC
>          */
>         {
>                 /* Symmetrix / DMX / VMAX */
> @@ -181,9 +181,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "XtremIO",
>                 .product       = "XtremApp",
>         },
> -       /*
> -        * DELL
> -        */
>         {
>                 /*
>                  * Dell SC Series, formerly Compellent
> --
> 2.7.4
>
>

--001a113c9ea2fff176053df6bdf7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Rebased and merged.<div>Thanks.</div></div><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Fri, Sep 16, 2016 at 7:37 PM,=
 Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gm=
ail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br>=
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">There can be only one.<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 5 +----<br>
=C2=A01 file changed, 1 insertion(+), 4 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index aaf7480..b8b5bb7 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -150,7 +150,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;SAN DataDirector&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * EMC<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Dell EMC<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Symmetrix / DMX =
/ VMAX */<br>
@@ -181,9 +181,6 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;XtremIO&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;XtremApp&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * DELL<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Dell SC Ser=
ies, formerly Compellent<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a113c9ea2fff176053df6bdf7--


--===============7990890230590113680==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7990890230590113680==--
