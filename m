From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH resend] ALUA support for PURE FlashArray
Date: Mon, 2 Mar 2020 15:19:09 +0100
Message-ID: <CABr-GnefEO7EXDsyi9uko0gn_qO_puMkmVHRT03DE=_o23Q4+Q@mail.gmail.com>
References: <20191228002451.9536-1-xose.vazquez@gmail.com>
	<f4b9152e-bce3-5ad8-7f2d-8b0220c2b472@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6670449704200536647=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f4b9152e-bce3-5ad8-7f2d-8b0220c2b472@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Brian Bunker <brian@purestorage.com>
List-Id: dm-devel.ids

--===============6670449704200536647==
Content-Type: multipart/alternative; boundary="000000000000886ce9059fdfdfe7"

--000000000000886ce9059fdfdfe7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Xose, Brian,

I don't have the original patch in my mailbox, ... only Xose's
notifications.
Brian, please resend to: me, cc: list

Best,
Christophe.

On Mon, Mar 2, 2020 at 3:10 PM Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 12/28/19 1:24 AM, Xose Vazquez Perez wrote:
>
> Hi Christophe,
>
> This one is missing.
>
> Thank you.
>
> > From: Brian Bunker <brian@purestorage.com>
> >
> > Hello all,
> >
> > It has been some time since we updated our PURE FlashArray
> > configuration. The Linux vendors that we had been seeing in the field
> > were using very old versions of multipath-tools, so we haven=E2=80=99t =
needed to
> > change anything for some time. With the release of RHEL8, some of our
> > earlier values have been lost by upstream changes.
> >
> > In addition we have our Active Cluster feature which leverages ALUA
> > since our last patch. The ALUA confguration will work for all
> > FlashArrays with or without Active Cluster.
> >
> > We are changing 3 things.
> >
> > 1. ALUA support
> > 2. Fast fail timeout from the default of 5 seconds to 10 seconds (We
> >     need this for our FC NPIV port migration).
> > 3. Maximum sector size of 4MB. Some Linux vendors don=E2=80=99t honor t=
he block
> >     limits VPD page of INQUIRY).
> >
> > Thanks,
> > Brian
> >
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > ---
> >   libmultipath/hwtable.c | 7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 16627ec..9bc59f1 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -1039,7 +1039,12 @@ static struct hwentry default_hw[] =3D {
> >               /* FlashArray */
> >               .vendor        =3D "PURE",
> >               .product       =3D "FlashArray",
> > -             .pgpolicy      =3D MULTIBUS,
> > +             .pgpolicy      =3D GROUP_BY_PRIO,
> > +             .pgfailback    =3D -FAILBACK_IMMEDIATE,
> > +             .hwhandler     =3D "1 alua",
> > +             .prio_name     =3D PRIO_ALUA,
> > +             .fast_io_fail  =3D 10,
> > +             .max_sectors_kb =3D 4096,
> >       },
> >       /*
> >        * Huawei
> >
>
>

--000000000000886ce9059fdfdfe7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi=C2=A0Xose, Brian,<div><br></div><div>I don&#39;t have t=
he original patch in my mailbox, ... only Xose&#39;s notifications.</div><d=
iv>Brian, please resend to: me, cc: list</div><div><br></div><div>Best,</di=
v><div>Christophe.</div></div><br><div class=3D"gmail_quote"><div dir=3D"lt=
r" class=3D"gmail_attr">On Mon, Mar 2, 2020 at 3:10 PM Xose Vazquez Perez &=
lt;<a href=3D"mailto:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a>&gt;=
 wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On 12/28=
/19 1:24 AM, Xose Vazquez Perez wrote:<br>
<br>
Hi Christophe,<br>
<br>
This one is missing.<br>
<br>
Thank you.<br>
<br>
&gt; From: Brian Bunker &lt;<a href=3D"mailto:brian@purestorage.com" target=
=3D"_blank">brian@purestorage.com</a>&gt;<br>
&gt; <br>
&gt; Hello all,<br>
&gt; <br>
&gt; It has been some time since we updated our PURE FlashArray<br>
&gt; configuration. The Linux vendors that we had been seeing in the field<=
br>
&gt; were using very old versions of multipath-tools, so we haven=E2=80=99t=
 needed to<br>
&gt; change anything for some time. With the release of RHEL8, some of our<=
br>
&gt; earlier values have been lost by upstream changes.<br>
&gt; <br>
&gt; In addition we have our Active Cluster feature which leverages ALUA<br=
>
&gt; since our last patch. The ALUA confguration will work for all<br>
&gt; FlashArrays with or without Active Cluster.<br>
&gt; <br>
&gt; We are changing 3 things.<br>
&gt; <br>
&gt; 1. ALUA support<br>
&gt; 2. Fast fail timeout from the default of 5 seconds to 10 seconds (We<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0need this for our FC NPIV port migration).<br>
&gt; 3. Maximum sector size of 4MB. Some Linux vendors don=E2=80=99t honor =
the block<br>
&gt;=C2=A0 =C2=A0 =C2=A0limits VPD page of INQUIRY).<br>
&gt; <br>
&gt; Thanks,<br>
&gt; Brian<br>
&gt; <br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com" target=3D"_blank">christophe.varoqui@opensvc.com</a>&gt;<br>
&gt; Cc: DM-DEVEL ML &lt;<a href=3D"mailto:dm-devel@redhat.com" target=3D"_=
blank">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;<br>
&gt; Signed-off-by: Brian Bunker &lt;<a href=3D"mailto:brian@purestorage.co=
m" target=3D"_blank">brian@purestorage.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 =C2=A0libmultipath/hwtable.c | 7 ++++++-<br>
&gt;=C2=A0 =C2=A01 file changed, 6 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
&gt; index 16627ec..9bc59f1 100644<br>
&gt; --- a/libmultipath/hwtable.c<br>
&gt; +++ b/libmultipath/hwtable.c<br>
&gt; @@ -1039,7 +1039,12 @@ static struct hwentry default_hw[] =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* FlashArray */=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.vendor=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =3D &quot;PURE&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.product=C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D &quot;FlashArray&quot;,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D MULTIBUS,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgpolicy=C2=A0 =C2=
=A0 =C2=A0 =3D GROUP_BY_PRIO,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pgfailback=C2=A0 =C2=
=A0 =3D -FAILBACK_IMMEDIATE,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.hwhandler=C2=A0 =C2=
=A0 =C2=A0=3D &quot;1 alua&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.prio_name=C2=A0 =C2=
=A0 =C2=A0=3D PRIO_ALUA,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.fast_io_fail=C2=A0 =
=3D 10,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.max_sectors_kb =3D 4=
096,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0},<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Huawei<br>
&gt; <br>
<br>
</blockquote></div>

--000000000000886ce9059fdfdfe7--

--===============6670449704200536647==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6670449704200536647==--
