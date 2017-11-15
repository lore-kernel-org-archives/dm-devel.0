From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace RDAC maintainer
	with a generic alias
Date: Thu, 16 Nov 2017 00:00:31 +0100
Message-ID: <CABr-Gnfi2sw5WAEAiJohypwDExyAKRhmndfF+p4Uoo-LJkpRjg@mail.gmail.com>
References: <20170928214233.9438-1-xose.vazquez@gmail.com>
	<8bbd60df-7ea7-d6b4-0adf-e650dc228909@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9137179887853361062=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8bbd60df-7ea7-d6b4-0adf-e650dc228909@gmail.com>
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
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, device-mapper development <dm-devel@redhat.com>, Sean Stewart <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

--===============9137179887853361062==
Content-Type: multipart/alternative; boundary="001a1144533071d654055e0d783a"

--001a1144533071d654055e0d783a
Content-Type: text/plain; charset="UTF-8"

Ok, merged.
Post 0.7.4, sorry.

On Wed, Nov 15, 2017 at 11:54 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> On 09/28/2017 11:42 PM, Xose Vazquez Perez wrote:
>
> This one is missing.
>
> > Sean moved to a different role.
> >
> > Cc: Sean Stewart <Sean.Stewart@netapp.com>
> > Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  libmultipath/hwtable.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index efa81ba..2a93a48 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -639,8 +639,8 @@ static struct hwentry default_hw[] = {
> >               /*
> >                * SANtricity(RDAC) family
> >                *
> > -              * Maintainer : Sean Stewart
> > -              * Mail : sean.stewart@netapp.com
> > +              * Maintainer : NetApp RDAC team
> > +              * Mail : ng-eseries-upstream-maintainers@netapp.com
> >                */
> >               .vendor        = "(NETAPP|LSI|ENGENIO)",
> >               .product       = "INF-01-00",
> >
>
>

--001a1144533071d654055e0d783a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ok, merged.<div>Post 0.7.4, sorry.</div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, Nov 15, 2017 at 11:=
54 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazq=
uez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">On 09/28/2017 11:42 PM, Xose Vazquez P=
erez wrote:<br>
<br>
This one is missing.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Sean moved to a different role.<br>
&gt;<br>
&gt; Cc: Sean Stewart &lt;<a href=3D"mailto:Sean.Stewart@netapp.com">Sean.S=
tewart@netapp.com</a>&gt;<br>
&gt; Cc: NetApp RDAC team &lt;<a href=3D"mailto:ng-eseries-upstream-maintai=
ners@netapp.com">ng-eseries-upstream-<wbr>maintainers@netapp.com</a>&gt;<br=
>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/hwtable.c | 4 ++--<br>
&gt;=C2=A0 1 file changed, 2 insertions(+), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
&gt; index efa81ba..2a93a48 100644<br>
&gt; --- a/libmultipath/hwtable.c<br>
&gt; +++ b/libmultipath/hwtable.c<br>
&gt; @@ -639,8 +639,8 @@ static struct hwentry default_hw[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * SANtricity(RD=
AC) family<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Maintainer : Sean =
Stewart<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Mail : <a href=3D"=
mailto:sean.stewart@netapp.com">sean.stewart@netapp.com</a><br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Maintainer : NetAp=
p RDAC team<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Mail : <a href=3D"=
mailto:ng-eseries-upstream-maintainers@netapp.com">ng-eseries-upstream-<wbr=
>maintainers@netapp.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D &quot;(NETAPP|LSI|ENGENIO)&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D &quot;INF-01-00&quot;,<br>
&gt;<br>
<br>
</div></div></blockquote></div><br></div>

--001a1144533071d654055e0d783a--


--===============9137179887853361062==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9137179887853361062==--
