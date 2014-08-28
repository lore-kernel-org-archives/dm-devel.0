From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Update ETERNUS DX entry
Date: Thu, 28 Aug 2014 05:58:39 +0200
Message-ID: <CABr-GncV-yq+bBOMBerk8pG+pS+o53WDoPX5FzvC8BxUYbTBBw@mail.gmail.com>
References: <20140630233858.00001ed0@localhost>
	<20140827233240.000073e1@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4733344729563361857=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140827233240.000073e1@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4733344729563361857==
Content-Type: multipart/alternative; boundary=001a11346152436e080501a88d16

--001a11346152436e080501a88d16
Content-Type: text/plain; charset=UTF-8

Sorry, the patch was lost in the backlog.
Applied,
Thanks.


On Wed, Aug 27, 2014 at 11:32 PM, Sebastian Herbszt <herbszt@gmx.de> wrote:

> I wrote:
> > Add DX500 S3/DX600 S3.
> >
> > Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> > ---
> >  libmultipath/hwtable.c  | 2 +-
> >  multipath.conf.defaults | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index bb73a40..b774453 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -308,7 +308,7 @@ static struct hwentry default_hw[] = {
> >       },
> >       {
> >               .vendor        = "FUJITSU",
> > -             .product       = "ETERNUS_DX(L|400|8000)",
> > +             .product       = "ETERNUS_DX(L|M|400|8000)",
> >               .features      = "1 queue_if_no_path",
> >               .hwhandler     = DEFAULT_HWHANDLER,
> >               .pgpolicy      = GROUP_BY_PRIO,
> > diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> > index 12fb3f0..654be97 100644
> > --- a/multipath.conf.defaults
> > +++ b/multipath.conf.defaults
> > @@ -285,7 +285,7 @@
> >  #    }
> >  #    device {
> >  #            vendor "FUJITSU"
> > -#            product "ETERNUS_DX(L|400|8000)"
> > +#            product "ETERNUS_DX(L|M|400|8000)"
> >  #            path_grouping_policy "group_by_prio"
> >  #            path_checker "tur"
> >  #            features "1 queue_if_no_path"
>
> Christophe, can you apply this?
>
> Sebastian
>

--001a11346152436e080501a88d16
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Sorry, the patch was lost in the backlog.</div>Applie=
d,<div>Thanks.</div></div><div class=3D"gmail_extra"><br><br><div class=3D"=
gmail_quote">On Wed, Aug 27, 2014 at 11:32 PM, Sebastian Herbszt <span dir=
=3D"ltr">&lt;<a href=3D"mailto:herbszt@gmx.de" target=3D"_blank">herbszt@gm=
x.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">I wr=
ote:<br>
&gt; Add DX500 S3/DX600 S3.<br>
&gt;<br>
&gt; Signed-off-by: Sebastian Herbszt &lt;<a href=3D"mailto:herbszt@gmx.de"=
>herbszt@gmx.de</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/hwtable.c=C2=A0 | 2 +-<br>
&gt;=C2=A0 multipath.conf.defaults | 2 +-<br>
&gt;=C2=A0 2 files changed, 2 insertions(+), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
&gt; index bb73a40..b774453 100644<br>
&gt; --- a/libmultipath/hwtable.c<br>
&gt; +++ b/libmultipath/hwtable.c<br>
&gt; @@ -308,7 +308,7 @@ static struct hwentry default_hw[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D &quot;FUJITSU&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D &quot;ETERNUS_DX(L|400|8000)&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D &quot;ETERNUS_DX(L|M|400|8000)&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.features=C2=A0 =
=C2=A0 =C2=A0 =3D &quot;1 queue_if_no_path&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.hwhandler=C2=A0=
 =C2=A0 =C2=A0=3D DEFAULT_HWHANDLER,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =
=C2=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
&gt; diff --git a/multipath.conf.defaults b/multipath.conf.defaults<br>
&gt; index 12fb3f0..654be97 100644<br>
&gt; --- a/multipath.conf.defaults<br>
&gt; +++ b/multipath.conf.defaults<br>
&gt; @@ -285,7 +285,7 @@<br>
&gt;=C2=A0 #=C2=A0 =C2=A0 }<br>
&gt;=C2=A0 #=C2=A0 =C2=A0 device {<br>
&gt;=C2=A0 #=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &quot;FUJITSU&=
quot;<br>
&gt; -#=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product &quot;ETERNUS_DX(L=
|400|8000)&quot;<br>
&gt; +#=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product &quot;ETERNUS_DX(L=
|M|400|8000)&quot;<br>
&gt;=C2=A0 #=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_grouping_policy =
&quot;group_by_prio&quot;<br>
&gt;=C2=A0 #=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_checker &quot;tu=
r&quot;<br>
&gt;=C2=A0 #=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 features &quot;1 queu=
e_if_no_path&quot;<br>
<br>
</div></div>Christophe, can you apply this?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Sebastian<br>
</font></span></blockquote></div><br></div>

--001a11346152436e080501a88d16--


--===============4733344729563361857==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4733344729563361857==--
