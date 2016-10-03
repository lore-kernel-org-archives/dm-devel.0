From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 2/4] multipath-tools: replace GROUP_BY_SERIAL
 with MULTIBUS for IBM 3542 and 2105
Date: Mon, 3 Oct 2016 14:06:51 +0200
Message-ID: <CABr-GndK4pBmKUgsmjpuYvNH6xgj2R4O4p=jhRQAtT2B+LWg3g@mail.gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
	<1471543096-11441-2-git-send-email-xose.vazquez@gmail.com>
	<CABr-GndoWMoFD898RPci4yJxFDvtwmhQTERH7QZqLk0Qm5mCuQ@mail.gmail.com>
	<bd26cdfd-2b48-69de-cf4a-55f5e75c8c01@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0200437977114717704=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bd26cdfd-2b48-69de-cf4a-55f5e75c8c01@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============0200437977114717704==
Content-Type: multipart/alternative; boundary=001a114102948a8628053df4c7b6

--001a114102948a8628053df4c7b6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks.
Patch pushed.

On Mon, Oct 3, 2016 at 1:54 PM, Hannes Reinecke <hare@suse.de> wrote:

> On 10/03/2016 01:02 PM, Christophe Varoqui wrote:
> > Hi Xose,
> >
> > Group by serial sure can make sense for hardware not capable of multibu=
s.
> >
> > Can you or Hannes (listed as maintainer for IBM) confirm the concerned
> > IBM arrays are multibus capable ?
> >
> > Best regards,
> > Christophe Varoqui
> > OpenSVC
> >
> > On Thu, Aug 18, 2016 at 7:58 PM, Xose Vazquez Perez
> > <xose.vazquez@gmail.com <mailto:xose.vazquez@gmail.com>> wrote:
> >
> >     It doesn't make any sense to have, by default, GROUP_BY_SERIAL in
> >     real hardware.
> >
> >     Cc: Hannes Reinecke <hare@suse.de <mailto:hare@suse.de>>
> >     Cc: Christophe Varoqui <christophe.varoqui@opensvc.com
> >     <mailto:christophe.varoqui@opensvc.com>>
> >     Cc: device-mapper development <dm-devel@redhat.com
> >     <mailto:dm-devel@redhat.com>>
> >     Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com
> >     <mailto:xose.vazquez@gmail.com>>
> >     ---
> >      libmultipath/hwtable.c | 4 ++--
> >      1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >     diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> >     index aa3ea9b..72b5e1d 100644
> >     --- a/libmultipath/hwtable.c
> >     +++ b/libmultipath/hwtable.c
> >     @@ -443,7 +443,7 @@ static struct hwentry default_hw[] =3D {
> >                     /* DS4200 / FAStT200 */
> >                     .vendor        =3D "IBM",
> >                     .product       =3D "^3542",
> >     -               .pgpolicy      =3D GROUP_BY_SERIAL,
> >     +               .pgpolicy      =3D MULTIBUS,
> >                     .pgfailback    =3D FAILBACK_UNDEF,
> >             },
> This is the IBM FAStT 200, which is IIRC an RDAC machine. So multibus
> will be wrong here, and it should be using the RDAC entry instead.
>
> >             {
> >     @@ -451,7 +451,7 @@ static struct hwentry default_hw[] =3D {
> >                     .vendor        =3D "IBM",
> >                     .product       =3D "^2105",
> >                     .no_path_retry =3D NO_PATH_RETRY_QUEUE,
> >     -               .pgpolicy      =3D GROUP_BY_SERIAL,
> >     +               .pgpolicy      =3D MULTIBUS,
> >                     .pgfailback    =3D FAILBACK_UNDEF,
> >             },
> >             {
> That's the old IBM ESS 800; this is a fully symmetric active-active
> array. So yes, multibus is correct here.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)
>

--001a114102948a8628053df4c7b6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thanks.</div>Patch pushed.</div><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Mon, Oct 3, 2016 at 1:54 PM, Hannes=
 Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_=
blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
><span class=3D"">On 10/03/2016 01:02 PM, Christophe Varoqui wrote:<br>
&gt; Hi Xose,<br>
&gt;<br>
&gt; Group by serial sure can make sense for hardware not capable of multib=
us.<br>
&gt;<br>
&gt; Can you or Hannes (listed as maintainer for IBM) confirm the concerned=
<br>
&gt; IBM arrays are multibus capable ?<br>
&gt;<br>
&gt; Best regards,<br>
&gt; Christophe Varoqui<br>
&gt; OpenSVC<br>
&gt;<br>
&gt; On Thu, Aug 18, 2016 at 7:58 PM, Xose Vazquez Perez<br>
</span><span class=3D"">&gt; &lt;<a href=3D"mailto:xose.vazquez@gmail.com">=
xose.vazquez@gmail.com</a> &lt;mailto:<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a><wbr>&gt;&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0It doesn&#39;t make any sense to have, by default, =
GROUP_BY_SERIAL in<br>
&gt;=C2=A0 =C2=A0 =C2=A0real hardware.<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0Cc: Hannes Reinecke &lt;<a href=3D"mailto:ha=
re@suse.de">hare@suse.de</a> &lt;mailto:<a href=3D"mailto:hare@suse.de">har=
e@suse.de</a>&gt;&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Cc: Christophe Varoqui &lt;<a href=3D"mailto:christ=
ophe.varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0&lt;mailto:<a href=3D"mailto:christophe.varoqui@ope=
nsvc.com">christophe.varoqui@<wbr>opensvc.com</a>&gt;&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Cc: device-mapper development &lt;<a href=3D"mailto=
:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt;=C2=A0 =C2=A0 =C2=A0&lt;mailto:<a href=3D"mailto:dm-devel@redhat.com">d=
m-devel@redhat.com</a>&gt;&gt;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0Signed-off-by: Xose Vazquez Perez =
&lt;<a href=3D"mailto:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a><br=
>
</span>&gt;=C2=A0 =C2=A0 =C2=A0&lt;mailto:<a href=3D"mailto:xose.vazquez@gm=
ail.com">xose.vazquez@gmail.com</a><wbr>&gt;&gt;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0---<br>
&gt;=C2=A0 =C2=A0 =C2=A0 libmultipath/hwtable.c | 4 ++--<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1 file changed, 2 insertions(+), 2 deletions(-)<br=
>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0diff --git a/libmultipath/hwtable.c b/libmultipath/=
hwtable.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0index aa3ea9b..72b5e1d 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0--- a/libmultipath/hwtable.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0+++ b/libmultipath/hwtable.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -443,7 +443,7 @@ static struct hwentry default_h=
w[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0/* DS4200 / FAStT200 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.vendor=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.product=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D &quot;^3542&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.pgpolicy=C2=A0 =C2=A0 =C2=A0 =3D GROUP_BY_SERIAL,<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.pgpolicy=C2=A0 =C2=A0 =C2=A0 =3D MULTIBUS,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.pgfailback=C2=A0 =C2=A0 =3D FAILBACK_UNDEF,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
</span>This is the IBM FAStT 200, which is IIRC an RDAC machine. So multibu=
s<br>
will be wrong here, and it should be using the RDAC entry instead.<br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -451,7 +451,7 @@ static struct hwentry default_h=
w[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.vendor=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D &quot;IBM&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.product=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D &quot;^2105&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.no_path_retry =3D NO_PATH_RETRY_QUEUE,<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.pgpolicy=C2=A0 =C2=A0 =C2=A0 =3D GROUP_BY_SERIAL,<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.pgpolicy=C2=A0 =C2=A0 =C2=A0 =3D MULTIBUS,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0.pgfailback=C2=A0 =C2=A0 =3D FAILBACK_UNDEF,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0{<br>
</span>That&#39;s the old IBM ESS 800; this is a fully symmetric active-act=
ive<br>
array. So yes, multibus is correct here.<br>
<br>
Cheers,<br>
<br>
Hannes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0zSeries &amp; Storage<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"=
tel:%2B49%20911%2074053%20688" value=3D"+4991174053688">+49 911 74053 688</=
a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)<br=
>
</font></span></blockquote></div><br></div>

--001a114102948a8628053df4c7b6--


--===============0200437977114717704==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0200437977114717704==--
