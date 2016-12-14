From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: add .skip_kpartx and
 .max_sectors_kb to template in hwtable
Date: Wed, 14 Dec 2016 19:33:10 +0100
Message-ID: <CABr-Gnf5S6=j0XYLJvw9RwtsCg341gaqj4CYK6sCOf3ga_0kDQ@mail.gmail.com>
References: <20161208214500.14514-1-xose.vazquez@gmail.com>
	<20161209160309.GD25309@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1515708835968462177=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161209160309.GD25309@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============1515708835968462177==
Content-Type: multipart/alternative; boundary=94eb2c0ec214a63b6d0543a291ce

--94eb2c0ec214a63b6d0543a291ce
Content-Type: text/plain; charset=UTF-8

Merged.

On Fri, Dec 9, 2016 at 5:03 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> ACK
>
> Thanks
> -Ben
>
> On Thu, Dec 08, 2016 at 10:45:00PM +0100, Xose Vazquez Perez wrote:
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  libmultipath/hwtable.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index c6fc3d1..f5a5f7b 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -1115,6 +1115,8 @@ static struct hwentry default_hw[] = {
> >               .deferred_remove = DEFERRED_REMOVE_OFF,
> >               .delay_watch_checks = DELAY_CHECKS_OFF,
> >               .delay_wait_checks = DELAY_CHECKS_OFF,
> > +             .skip_kpartx = SKIP_KPARTX_OFF,
> > +             .max_sectors_kb = MAX_SECTORS_KB_UNDEF,
> >       },
> >  #endif
> >       /*
> > --
> > 2.11.0
>

--94eb2c0ec214a63b6d0543a291ce
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Fri, Dec 9, 2016 at 5:03 PM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">ACK<=
br>
<br>
Thanks<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On Thu, Dec 08, 2016 at 10:45:00PM +0100, Xose Vazquez Perez wrote:<br>
&gt; Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmar=
zins@redhat.com</a>&gt;<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/hwtable.c | 2 ++<br>
&gt;=C2=A0 1 file changed, 2 insertions(+)<br>
&gt;<br>
&gt; diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
&gt; index c6fc3d1..f5a5f7b 100644<br>
&gt; --- a/libmultipath/hwtable.c<br>
&gt; +++ b/libmultipath/hwtable.c<br>
&gt; @@ -1115,6 +1115,8 @@ static struct hwentry default_hw[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.deferred_remove=
 =3D DEFERRED_REMOVE_OFF,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.delay_watch_che=
cks =3D DELAY_CHECKS_OFF,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.delay_wait_chec=
ks =3D DELAY_CHECKS_OFF,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.skip_kpartx =3D SKIP=
_KPARTX_OFF,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.max_sectors_kb =3D M=
AX_SECTORS_KB_UNDEF,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; --<br>
&gt; 2.11.0<br>
</div></div></blockquote></div><br></div>

--94eb2c0ec214a63b6d0543a291ce--


--===============1515708835968462177==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1515708835968462177==--
