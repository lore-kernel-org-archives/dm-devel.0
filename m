From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: delete vendor name HUASY
 for Huawei devices
Date: Sat, 20 May 2017 11:02:55 +0200
Message-ID: <CABr-GneAwr2yFYvjigedLV32csn2jtAR3mK7G_2eOAB+T+9_HQ@mail.gmail.com>
References: <1495268822-18564-1-git-send-email-zouming.zouming@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8923623463565374527=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1495268822-18564-1-git-send-email-zouming.zouming@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zou Ming <zouming.zouming@huawei.com>
Cc: guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, device-mapper development <dm-devel@redhat.com>, hege09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

--===============8923623463565374527==
Content-Type: multipart/alternative; boundary="001a113cf13c630d6c054ff0e775"

--001a113cf13c630d6c054ff0e775
Content-Type: text/plain; charset="UTF-8"

Hi,

question is, is there arrays in the wild exposing this vendor name ?
If so, we'll rather keep its defaults for the decade to come.

Best regards,
Christophe.

On Sat, May 20, 2017 at 10:27 AM, Zou Ming <zouming.zouming@huawei.com>
wrote:

> For product XSG1,HUASY is obsolete for Huawei devices,Only HUAWEI is the
> official vendor name.
> ---
>  libmultipath/hwtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 54309ef..bd8719c 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -881,7 +881,7 @@ static struct hwentry default_hw[] = {
>          */
>         {
>                 /* OceanStor V3 */
> -               .vendor        = "(HUAWEI|HUASY)",
> +               .vendor        = "HUAWEI",
>                 .product       = "XSG1",
>                 .pgpolicy      = MULTIBUS,
>         },
> --
> 2.6.4.windows.1
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113cf13c630d6c054ff0e775
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>question is, is there arrays in the=
 wild exposing this vendor name ?</div><div>If so, we&#39;ll rather keep it=
s defaults for the decade to come.</div><div><br></div><div>Best regards,</=
div><div>Christophe.</div></div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Sat, May 20, 2017 at 10:27 AM, Zou Ming <span dir=3D"lt=
r">&lt;<a href=3D"mailto:zouming.zouming@huawei.com" target=3D"_blank">zoum=
ing.zouming@huawei.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">For product XSG1,HUASY is obsolete for Huawei devices,Only HUAWEI is th=
e official vendor name.<br>
---<br>
=C2=A0libmultipath/hwtable.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 54309ef..bd8719c 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -881,7 +881,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* OceanStor V3 */<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;(HUAWEI|HUASY)&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =3D &quot;HUAWEI&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .product=C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D &quot;XSG1&quot;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.6.4.windows.1<br>
<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--001a113cf13c630d6c054ff0e775--


--===============8923623463565374527==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8923623463565374527==--
