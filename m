From: Asim Zia <ziajee2k@gmail.com>
Subject: Re: Re: [PATCH 2/3] scsi_dh: Provide set_params interface
	in emc device handler
Date: Tue, 21 Jul 2009 09:02:39 +0500
Message-ID: <1c02af620907202102x555a4239k1b751a6f764f10b4@mail.gmail.com>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	<20090702031320.28354.96958.sendpatchset@chandra-ubuntu>
	<1248094813.6307.10.camel@eddie-laptop>
	<1248138120.10481.37.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1322244915=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1248138120.10481.37.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1322244915==
Content-Type: multipart/alternative; boundary=000e0cd32f625ac297046f2f5352

--000e0cd32f625ac297046f2f5352
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

unsubscribe linux-scsi





On Tue, Jul 21, 2009 at 6:02 AM, Chandra Seetharaman <sekharan@us.ibm.com>wrote:

>
> I will reroll the patch with this fix and ported to the latest RC.
>  On Mon, 2009-07-20 at 09:00 -0400, Eddie Williams wrote:
> > On Wed, 2009-07-01 at 20:13 -0700, Chandra Seetharaman wrote:
> > > Handle the parameters provided by user thru multipath.
> > >
> > > This handler expects only 2 parameters and their value can either be 0
> or 1.
> > >
> > > This code originates from the old dm-emc.c file. Appropriate changes
> have
> > > been made to make it work in the new design.
> > >
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > ---
> > >  drivers/scsi/device_handler/scsi_dh_emc.c |   56
> ++++++++++++++++++++++++++++++
> > >  1 file changed, 56 insertions(+)
> > >
> > > Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
> > > ===================================================================
> > > --- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh_emc.c
> > > +++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c
> > > @@ -561,6 +561,61 @@ done:
> > >
> > >     return result;
> > >  }
> > > +/*
> > > + * params - parameters in the following format
> > > + *      "no_of_params\0param1\0param2\0param3\0...\0"
> > > + *      for example, string for 2 parameters with value 10 and 21
> > > + *      is specified as "2\010\021\0".
> > > + */
> > > +static int clariion_set_params(struct scsi_device *sdev, const char
> *params)
> > > +{
> > > +   struct clariion_dh_data *csdev = get_clariion_data(sdev);
> > > +   unsigned int hr = 0, st = 0, argc;
> > > +   char *p = params;
> >
> > This throws a compiler warning resolved with a type cast:
> >       char *p = (char *)params;
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--000e0cd32f625ac297046f2f5352
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>unsubscribe linux-scsi</div>
<div>=A0</div>
<div>=A0</div>
<div><br><br>=A0</div>
<div class=3D"gmail_quote">On Tue, Jul 21, 2009 at 6:02 AM, Chandra Seethar=
aman <span dir=3D"ltr">&lt;<a href=3D"mailto:sekharan@us.ibm.com">sekharan@=
us.ibm.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid"><br>I will reroll the patch with=
 this fix and ported to the latest RC.<br>
<div>
<div></div>
<div class=3D"h5">On Mon, 2009-07-20 at 09:00 -0400, Eddie Williams wrote:<=
br>&gt; On Wed, 2009-07-01 at 20:13 -0700, Chandra Seetharaman wrote:<br>&g=
t; &gt; Handle the parameters provided by user thru multipath.<br>&gt; &gt;=
<br>
&gt; &gt; This handler expects only 2 parameters and their value can either=
 be 0 or 1.<br>&gt; &gt;<br>&gt; &gt; This code originates from the old dm-=
emc.c file. Appropriate changes have<br>&gt; &gt; been made to make it work=
 in the new design.<br>
&gt; &gt;<br>&gt; &gt; Signed-off-by: Chandra Seetharaman &lt;<a href=3D"ma=
ilto:sekharan@us.ibm.com">sekharan@us.ibm.com</a>&gt;<br>&gt; &gt; ---<br>&=
gt; &gt; =A0drivers/scsi/device_handler/scsi_dh_emc.c | =A0 56 ++++++++++++=
++++++++++++++++++<br>
&gt; &gt; =A01 file changed, 56 insertions(+)<br>&gt; &gt;<br>&gt; &gt; Ind=
ex: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c<br>&gt; &gt;=
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>&gt; &gt; --- lin=
ux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh_emc.c<br>
&gt; &gt; +++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh_emc.c<br=
>&gt; &gt; @@ -561,6 +561,61 @@ done:<br>&gt; &gt;<br>&gt; &gt; =A0 =A0 ret=
urn result;<br>&gt; &gt; =A0}<br>&gt; &gt; +/*<br>&gt; &gt; + * params - pa=
rameters in the following format<br>
&gt; &gt; + * =A0 =A0 =A0&quot;no_of_params\0param1\0param2\0param3\0...\0&=
quot;<br>&gt; &gt; + * =A0 =A0 =A0for example, string for 2 parameters with=
 value 10 and 21<br>&gt; &gt; + * =A0 =A0 =A0is specified as &quot;2\010\02=
1\0&quot;.<br>
&gt; &gt; + */<br>&gt; &gt; +static int clariion_set_params(struct scsi_dev=
ice *sdev, const char *params)<br>&gt; &gt; +{<br>&gt; &gt; + =A0 struct cl=
ariion_dh_data *csdev =3D get_clariion_data(sdev);<br>&gt; &gt; + =A0 unsig=
ned int hr =3D 0, st =3D 0, argc;<br>
&gt; &gt; + =A0 char *p =3D params;<br>&gt;<br>&gt; This throws a compiler =
warning resolved with a type cast:<br>&gt; =A0 =A0 =A0 char *p =3D (char *)=
params;<br>&gt;<br>&gt;<br>&gt;<br>&gt; --<br></div></div>&gt; To unsubscri=
be from this list: send the line &quot;unsubscribe linux-scsi&quot; in<br>
&gt; the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">=
majordomo@vger.kernel.org</a><br>&gt; More majordomo info at =A0<a href=3D"=
http://vger.kernel.org/majordomo-info.html" target=3D"_blank">http://vger.k=
ernel.org/majordomo-info.html</a><br>

<div>
<div></div>
<div class=3D"h5"><br>--<br>dm-devel mailing list<br><a href=3D"mailto:dm-d=
evel@redhat.com">dm-devel@redhat.com</a><br><a href=3D"https://www.redhat.c=
om/mailman/listinfo/dm-devel" target=3D"_blank">https://www.redhat.com/mail=
man/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br>

--000e0cd32f625ac297046f2f5352--


--===============1322244915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1322244915==--
