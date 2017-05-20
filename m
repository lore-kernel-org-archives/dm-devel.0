From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: delete vendor name HUASY
 for Huawei devices
Date: Sat, 20 May 2017 12:31:14 +0200
Message-ID: <CABr-Gnfh93jZVi=sET6hpOgHpYUQBDJj4P1Nk7tqcnp9cz6tCQ@mail.gmail.com>
References: <1495268822-18564-1-git-send-email-zouming.zouming@huawei.com>
	<CABr-GneAwr2yFYvjigedLV32csn2jtAR3mK7G_2eOAB+T+9_HQ@mail.gmail.com>
	<a1e23307-2a9d-45c5-579e-e2d912e76bcc@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7453912673679345107=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a1e23307-2a9d-45c5-579e-e2d912e76bcc@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Zouming (IT)" <zouming.zouming@huawei.com>
Cc: guanjunxiong@huawei.com, philip.yang@huawei.com, shenhong09@huawei.com, device-mapper development <dm-devel@redhat.com>, hege09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

--===============7453912673679345107==
Content-Type: multipart/alternative; boundary="001a113e2b6e365486054ff223c9"

--001a113e2b6e365486054ff223c9
Content-Type: text/plain; charset="UTF-8"

Thanks for the clarification.

On Sat, May 20, 2017 at 11:17 AM, Zouming (IT) <zouming.zouming@huawei.com>
wrote:

> Hi christophe:
>
> We absolutely sure for product XSG1,no arrays use vendor name HUASY.
> Because these arrays are our up-to-date product.
>
> Best regards,
> Zou Ming.
>
> On 2017/5/20 17:02, Christophe Varoqui wrote:
> > Hi,
> >
> > question is, is there arrays in the wild exposing this vendor name ?
> > If so, we'll rather keep its defaults for the decade to come.
> >
> > Best regards,
> > Christophe.
> >
> > On Sat, May 20, 2017 at 10:27 AM, Zou Ming <zouming.zouming@huawei.com
> <mailto:zouming.zouming@huawei.com>> wrote:
> >
> >     For product XSG1,HUASY is obsolete for Huawei devices,Only HUAWEI is
> the official vendor name.
> >     ---
> >      libmultipath/hwtable.c | 2 +-
> >      1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >     diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> >     index 54309ef..bd8719c 100644
> >     --- a/libmultipath/hwtable.c
> >     +++ b/libmultipath/hwtable.c
> >     @@ -881,7 +881,7 @@ static struct hwentry default_hw[] = {
> >              */
> >             {
> >                     /* OceanStor V3 */
> >     -               .vendor        = "(HUAWEI|HUASY)",
> >     +               .vendor        = "HUAWEI",
> >                     .product       = "XSG1",
> >                     .pgpolicy      = MULTIBUS,
> >             },
> >     --
> >     2.6.4.windows.1
> >
> >
> >     --
> >     dm-devel mailing list
> >     dm-devel@redhat.com <mailto:dm-devel@redhat.com>
> >     https://www.redhat.com/mailman/listinfo/dm-devel <
> https://www.redhat.com/mailman/listinfo/dm-devel>
> >
> >
>
>

--001a113e2b6e365486054ff223c9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for the clarification.</div><div class=3D"gmail_ext=
ra"><br><div class=3D"gmail_quote">On Sat, May 20, 2017 at 11:17 AM, Zoumin=
g (IT) <span dir=3D"ltr">&lt;<a href=3D"mailto:zouming.zouming@huawei.com" =
target=3D"_blank">zouming.zouming@huawei.com</a>&gt;</span> wrote:<br><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex">Hi christophe:<br>
<br>
We absolutely sure for product XSG1,no arrays use vendor name HUASY.<br>
Because these arrays are our up-to-date product.<br>
<br>
Best regards,<br>
Zou Ming.<br>
<span class=3D""><br>
On 2017/5/20 17:02, Christophe Varoqui wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; question is, is there arrays in the wild exposing this vendor name ?<b=
r>
&gt; If so, we&#39;ll rather keep its defaults for the decade to come.<br>
&gt;<br>
&gt; Best regards,<br>
&gt; Christophe.<br>
&gt;<br>
</span><span class=3D"">&gt; On Sat, May 20, 2017 at 10:27 AM, Zou Ming &lt=
;<a href=3D"mailto:zouming.zouming@huawei.com">zouming.zouming@huawei.com</=
a> &lt;mailto:<a href=3D"mailto:zouming.zouming@huawei.com">zouming.zouming=
@<wbr>huawei.com</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0For product XSG1,HUASY is obsolete for Huawei devic=
es,Only HUAWEI is the official vendor name.<br>
&gt;=C2=A0 =C2=A0 =C2=A0---<br>
&gt;=C2=A0 =C2=A0 =C2=A0 libmultipath/hwtable.c | 2 +-<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0diff --git a/libmultipath/hwtable.c b/libmultipath/=
hwtable.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0index 54309ef..bd8719c 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0--- a/libmultipath/hwtable.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0+++ b/libmultipath/hwtable.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -881,7 +881,7 @@ static struct hwentry default_h=
w[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0/* OceanStor V3 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.vendor=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D &quot;(HUAWEI|HUASY)&quot;,<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.vendor=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D &quot;HUAWEI&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.product=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D &quot;XSG1&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.pgpolicy=C2=A0 =C2=A0 =C2=A0 =3D MULTIBUS,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
&gt;=C2=A0 =C2=A0 =C2=A0--<br>
&gt;=C2=A0 =C2=A0 =C2=A02.6.4.windows.1<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0--<br>
&gt;=C2=A0 =C2=A0 =C2=A0dm-devel mailing list<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0<a href=3D"mailto:dm-devel@redhat.com">dm-de=
vel@redhat.com</a> &lt;mailto:<a href=3D"mailto:dm-devel@redhat.com">dm-dev=
el@redhat.com</a>&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0<a href=3D"https://www.redhat.com/mailman/listinfo/=
dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/<wbr>=
mailman/listinfo/dm-devel</a> &lt;<a href=3D"https://www.redhat.com/mailman=
/listinfo/dm-devel" rel=3D"noreferrer" target=3D"_blank">https://www.redhat=
.com/<wbr>mailman/listinfo/dm-devel</a>&gt;<br>
&gt;<br>
&gt;<br>
<br>
</blockquote></div><br></div>

--001a113e2b6e365486054ff223c9--


--===============7453912673679345107==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7453912673679345107==--
