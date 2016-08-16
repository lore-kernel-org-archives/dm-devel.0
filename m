From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 01/15] multipath-tools: identify more devices
	at hwtable
Date: Tue, 16 Aug 2016 09:51:35 +0200
Message-ID: <CABr-Gne4XX55A2peJpMSukO8L+G3Hszso9vzZRN1GyNoAw1vSw@mail.gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6813289694058540191=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
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

--===============6813289694058540191==
Content-Type: multipart/alternative; boundary=001a114a5e923c925f053a2b9e76

--001a114a5e923c925f053a2b9e76
Content-Type: text/plain; charset=UTF-8

This set is merged, expect 10/15 and 14/15.
Thanks.

On Wed, Aug 10, 2016 at 6:20 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 2192d38..1222f47 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -468,7 +468,7 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = FAILBACK_UNDEF,
>         },
>         {
> -               /* SAN Volume Controller / Storwize */
> +               /* Storwize family / SAN Volume Controller / Flex System
> V7000 */
>                 .vendor        = "IBM",
>                 .product       = "^2145",
>                 .features      = "1 queue_if_no_path",
> @@ -811,6 +811,7 @@ static struct hwentry default_hw[] = {
>          * Huawei
>          */
>         {
> +               /* OceanStor V3 */
>                 .vendor        = "(HUAWEI|HUASY)",
>                 .product       = "XSG1",
>                 .pgpolicy      = MULTIBUS,
> --
> 2.7.4
>
>

--001a114a5e923c925f053a2b9e76
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This set is merged, expect 10/15 and 14/15.<div>Thanks.</d=
iv></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, =
Aug 10, 2016 at 6:20 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=
=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Cc: Christophe Var=
oqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com">christophe.varoq=
ui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/hwtable.c | 3 ++-<br>
=C2=A01 file changed, 2 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 2192d38..1222f47 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -468,7 +468,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgfailback=C2=A0 =
=C2=A0 =3D FAILBACK_UNDEF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* SAN Volume Contr=
oller / Storwize */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Storwize family =
/ SAN Volume Controller / Flex System V7000 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;^2145&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .features=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;1 queue_if_no_path&quot;,<br>
@@ -811,6 +811,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Huawei<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* OceanStor V3 */<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;(HUAWEI|HUASY)&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;XSG1&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a114a5e923c925f053a2b9e76--


--===============6813289694058540191==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6813289694058540191==--
