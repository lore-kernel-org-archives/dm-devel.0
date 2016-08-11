From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 14/15] multipath-tools: replace queue-length
	by default selector
Date: Thu, 11 Aug 2016 08:52:27 +0200
Message-ID: <CABr-GnfWdrj23yeg5BYK2mbf2eOS=TPmE0zSGhF0AXkGQV846g@mail.gmail.com>
References: <1470846038-6590-1-git-send-email-xose.vazquez@gmail.com>
	<1470846038-6590-14-git-send-email-xose.vazquez@gmail.com>
	<411eb480-d21d-051b-1f7b-12631cae1f25@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1025121597310292026=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <411eb480-d21d-051b-1f7b-12631cae1f25@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1025121597310292026==
Content-Type: multipart/alternative; boundary=001a11412e4289bfb70539c635a5

--001a11412e4289bfb70539c635a5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I agree with Hannes on this.

The default values are not meant to provide optimal performance ... they
are meant to provide an accessible LUN whatever the hardware and on the
broader range of Linux kernels. Vendors are responsible to provide their
array tuning as hwtable entries. And the size or factorization of the
hwtable is not an issue.


On Thu, Aug 11, 2016 at 7:58 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 08/10/2016 06:20 PM, Xose Vazquez Perez wrote:
> > service-time is more advanced, and it works better in asymmetric and
> > asymmetric environments.
> >
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  libmultipath/hwtable.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index bc2d407..edfd8fe 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -198,7 +198,6 @@ static struct hwentry default_hw[] =3D {
> >       {
> >               .vendor        =3D "XtremIO",
> >               .product       =3D "XtremApp",
> > -             .selector      =3D "queue-length 0",
> >               .pgpolicy      =3D MULTIBUS,
> >               .pgfailback    =3D FAILBACK_UNDEF,
> >       },
> > @@ -823,7 +822,6 @@ static struct hwentry default_hw[] =3D {
> >       {
> >               .vendor        =3D "PURE",
> >               .product       =3D "FlashArray",
> > -             .selector      =3D "queue-length 0",
> >               .pgpolicy      =3D MULTIBUS,
> >               .pgfailback    =3D FAILBACK_UNDEF,
> >               .fast_io_fail  =3D 10,
> >
> I would _not_ do this, unless tested on the real hardware.
> Just claiming 'the other one is more advanced' is not enough here.
>
> NACK.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
>

--001a11412e4289bfb70539c635a5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I agree with Hannes on this.<div><br></div><div>The defaul=
t values are not meant to provide optimal performance ... they are meant to=
 provide an accessible LUN whatever the hardware and on the broader range o=
f Linux kernels. Vendors are responsible to provide their array tuning as h=
wtable entries. And the size or factorization of the hwtable is not an issu=
e.</div><div><br></div></div><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On Thu, Aug 11, 2016 at 7:58 AM, Hannes Reinecke <span dir=3D"l=
tr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&=
gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><=
div class=3D"h5">On 08/10/2016 06:20 PM, Xose Vazquez Perez wrote:<br>
&gt; service-time is more advanced, and it works better in asymmetric and<b=
r>
&gt; asymmetric environments.<br>
&gt;<br>
&gt; Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</=
a>&gt;<br>
&gt; Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmar=
zins@redhat.com</a>&gt;<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/hwtable.c | 2 --<br>
&gt;=C2=A0 1 file changed, 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
&gt; index bc2d407..edfd8fe 100644<br>
&gt; --- a/libmultipath/hwtable.c<br>
&gt; +++ b/libmultipath/hwtable.c<br>
&gt; @@ -198,7 +198,6 @@ static struct hwentry default_hw[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D &quot;XtremIO&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D &quot;XtremApp&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.selector=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;queue-length 0&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =
=C2=A0 =C2=A0 =3D MULTIBUS,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=
=A0 =C2=A0 =3D FAILBACK_UNDEF,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
&gt; @@ -823,7 +822,6 @@ static struct hwentry default_hw[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D &quot;PURE&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D &quot;FlashArray&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.selector=C2=A0 =C2=
=A0 =C2=A0 =3D &quot;queue-length 0&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =
=C2=A0 =C2=A0 =3D MULTIBUS,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=
=A0 =C2=A0 =3D FAILBACK_UNDEF,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fast_io_fail=C2=
=A0 =3D 10,<br>
&gt;<br>
</div></div>I would _not_ do this, unless tested on the real hardware.<br>
Just claiming &#39;the other one is more advanced&#39; is not enough here.<=
br>
<br>
NACK.<br>
<br>
Cheers,<br>
<br>
Hannes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
Teamlead Storage &amp; Networking<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"tel:%2B49%20911%2074053%20688" value=3D"=
+4991174053688">+49 911 74053 688</a><br>
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton<br>
HRB 21284 (AG N=C3=BCrnberg)<br>
</font></span></blockquote></div><br></div>

--001a11412e4289bfb70539c635a5--


--===============1025121597310292026==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1025121597310292026==--
