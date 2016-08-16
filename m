From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add two rdac devices
Date: Tue, 16 Aug 2016 09:41:23 +0200
Message-ID: <CABr-Gnc8eSZrGGp0C6dcmxWzRG2GUdZoYA_vjF0vSNNMXpeWCg@mail.gmail.com>
References: <1471104301-5702-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8846903254227018229=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1471104301-5702-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Sean Stewart <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

--===============8846903254227018229==
Content-Type: multipart/alternative; boundary=001a114b0af6baab28053a2b7935

--001a114b0af6baab28053a2b7935
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Sat, Aug 13, 2016 at 6:05 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Sun StorEdge 6130 and SGI TP9700.
>
> They were include in the kernel rdac side, but never in mpt:
> https://bugzilla.redhat.com/524335
> https://marc.info/?l=dm-devel&m=130203604024614
>
> Cc: Sean Stewart <Sean.Stewart@netapp.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index a489d6c..10d89d7 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -613,7 +613,7 @@ static struct hwentry default_hw[] = {
>         },
>         {
>                 .vendor        = "SGI",
> -               .product       = "TP9[345]00",
> +               .product       = "TP9[3457]00",
>                 .bl_product    = "Universal Xport",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .checker_name  = RDAC,
> @@ -715,9 +715,9 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = 30,
>         },
>         {
> -               /* 6140 */
> +               /* 6130 / 6140 */
>                 .vendor        = "SUN",
> -               .product       = "CSM200_R",
> +               .product       = "CSM[12]00_R",
>                 .bl_product    = "Universal Xport",
>                 .pgpolicy      = GROUP_BY_PRIO,
>                 .checker_name  = RDAC,
> --
> 2.7.4
>
>

--001a114b0af6baab28053a2b7935
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Sat, Aug 13, 2016 at 6:05 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Sun StorEdge 6130 and SGI TP9700.<br>
<br>
They were include in the kernel rdac side, but never in mpt:<br>
<a href=3D"https://bugzilla.redhat.com/524335" rel=3D"noreferrer" target=3D=
"_blank">https://bugzilla.redhat.com/<wbr>524335</a><br>
<a href=3D"https://marc.info/?l=3Ddm-devel&amp;m=3D130203604024614" rel=3D"=
noreferrer" target=3D"_blank">https://marc.info/?l=3Ddm-devel&amp;<wbr>m=3D=
130203604024614</a><br>
<br>
Cc: Sean Stewart &lt;<a href=3D"mailto:Sean.Stewart@netapp.com">Sean.Stewar=
t@netapp.com</a>&gt;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 6 +++---<br>
=C2=A01 file changed, 3 insertions(+), 3 deletions(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index a489d6c..10d89d7 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -613,7 +613,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;SGI&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;TP9[345]00&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;TP9[3457]00&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bl_product=C2=A0 =
=C2=A0 =3D &quot;Universal Xport&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .checker_name=C2=A0=
 =3D RDAC,<br>
@@ -715,9 +715,9 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .no_path_retry =3D =
30,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* 6140 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* 6130 / 6140 */<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;SUN&quot;,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;CSM200_R&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;CSM[12]00_R&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .bl_product=C2=A0 =
=C2=A0 =3D &quot;Universal Xport&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .checker_name=C2=A0=
 =3D RDAC,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114b0af6baab28053a2b7935--


--===============8846903254227018229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8846903254227018229==--
