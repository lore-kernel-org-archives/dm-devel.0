From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: remove Pure modifications
Date: Sun, 20 Nov 2016 10:15:22 +0100
Message-ID: <CABr-GneAeiYMxOqt6k-heNS5_1t0mEKQQH6A4Au11zvHrfvUGw@mail.gmail.com>
References: <20161107144032.2068-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7885593732266800392=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161107144032.2068-1-xose.vazquez@gmail.com>
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

--===============7885593732266800392==
Content-Type: multipart/alternative; boundary=94eb2c1a1b6c9a5f1c0541b7fa90

--94eb2c1a1b6c9a5f1c0541b7fa90
Content-Type: text/plain; charset=UTF-8

Applied,
thanks.

On Mon, Nov 7, 2016 at 3:40 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> There is no reason to deviate from standard values.
>
> Default:
>  .fast_io_fail  = 5
>  .dev_loss      = 600
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 340035e..6ca9ea2 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -899,8 +899,6 @@ static struct hwentry default_hw[] = {
>                 .vendor        = "PURE",
>                 .product       = "FlashArray",
>                 .pgpolicy      = MULTIBUS,
> -               .fast_io_fail  = 10,
> -               .dev_loss      = 60,
>         },
>         /*
>          * Huawei
> --
> 2.10.2
>
>

--94eb2c1a1b6c9a5f1c0541b7fa90
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Mon, Nov 7, 2016 at 3:40 PM, Xose Vazque=
z Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" tar=
get=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">There is no reason to deviate from standard values.<br>
<br>
Default:<br>
=C2=A0.fast_io_fail=C2=A0 =3D 5<br>
=C2=A0.dev_loss=C2=A0 =C2=A0 =C2=A0 =3D 600<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 2 --<br>
=C2=A01 file changed, 2 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 340035e..6ca9ea2 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -899,8 +899,6 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;PURE&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;FlashArray&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fast_io_fail=C2=A0=
 =3D 10,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.dev_loss=C2=A0 =C2=
=A0 =C2=A0 =3D 60,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Huawei<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.2<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c1a1b6c9a5f1c0541b7fa90--


--===============7885593732266800392==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7885593732266800392==--
