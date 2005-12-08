From: lbt <transter@gmail.com>
Subject: Re: [PATCH] IBM hwtable update
Date: Thu, 8 Dec 2005 08:45:29 -0800
Message-ID: <ac71172a0512080845g4ad89a8fu99666ba2e483f429@mail.gmail.com>
References: <4396C35B.7030109@suse.de>
	<OF3BAED142.4E324BA7-ONC12570D0.003FCC56-C12570D0.00406650@de.ibm.com>
Reply-To: transter@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1034884441=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF3BAED142.4E324BA7-ONC12570D0.003FCC56-C12570D0.00406650@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1034884441==
Content-Type: multipart/alternative;
	boundary="----=_Part_16181_19843129.1134060329851"

------=_Part_16181_19843129.1134060329851
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I think FAILBACK_IMMEDIATE for DS6000 makes more sense. Also for SVC (2145)
the same settings should be used as DS6000 since it is also an asymetric
device,
i.e.
    r +=3D store_hwe_ext(hw, "IBM", "2145", GROUP_BY_PRIO, DEFAULT_GETUID,
                 "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path"=
,
"tur", FAILBACK_IMMEDIATE);


On 12/7/05, Stefan Bader <Stefan.Bader@de.ibm.com> wrote:
>
> Hi Christophe, Hannes,
>
> I thought I had already sent parts of these but they don't seem to be in
> the git head when
> I look now. I'd suggest a small change for the DS6000 aka 1750500. Since
> paths with
> higher prio are more appreciated, wouldn'T FAILBACK_IMMEDIATE make more
> sense?
>
> Regards,
> Stefan
>
> SW Linux on zSeries Development & Services
> Stefan.Bader@de.ibm.com
>
> -------------------------------------------------------------------------=
---------
>   When all other means of communication fail, try words.
>
> dm-devel-bounces@redhat.com wrote on 07.12.2005 12:11:23:
>
> > Hi Christophe,
> >
> > attached is a patch to update hwtable.c with some IBM Storage Servers.
> > Especially the DS6000 should be handled properly as it again has
> > asymmetric paths.
> >
> > Cheers,
> >
> > Hannes
> > --
> > Dr. Hannes Reinecke         hare@suse.de
> > SuSE Linux Products GmbH      S390 & zSeries
> > Maxfeldstra=DFe 5            +49 911 74053 688
> > 90409 N=FCrnberg            http://www.suse.de
> > Subject: Hardware entries for IBM Storage Servers
> >
> > Several IBM Storage Servers (most notably the DS range) need
> > specific hardware entries. This patch adds hardware entries
> > for:
> >
> > - IBM ESS F20 (aka Shark)
> > - IBM DS6000
> > - IBM DS8000
> > - IBM SVC
> >
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> >
> > ---
> >
> >  libmultipath/hwtable.c |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> >
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -39,6 +39,20 @@ setup_default_hwtable (vector hw)
> >           "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE);
> >     r +=3D store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL,
> DEFAULT_GETUID,
> >           NULL, "0", "0", "tur", FAILBACK_UNDEF);
> > +   /* IBM ESS F20 aka Shark */
> > +   r +=3D store_hwe_ext(hw, "IBM", "2105F20", GROUP_BY_SERIAL,
> > +         DEFAULT_GETUID, NULL, "0", "1 queue_if_no_path",
> > +         "tur", FAILBACK_UNDEF);
> > +       /* IBM DS6000 */
> > +   r +=3D store_hwe_ext(hw, "IBM", "1750500", GROUP_BY_PRIO,
> DEFAULT_GETUID,
> > +         "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_if_no_path",
> > +         "tur", FAILBACK_UNDEF);
> > +   /* IBM DS8000 */
> > +   r +=3D store_hwe_ext(hw, "IBM", "2107900", GROUP_BY_SERIAL,
> DEFAULT_GETUID,
> > +         NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
> > +   /* IBM SAN Volume Controller */
> > +   r +=3D store_hwe_ext(hw, "IBM", "2145", MULTIBUS, DEFAULT_GETUID,
> > +         NULL, "0", "1 queue_if_no_path", "tur", FAILBACK_UNDEF);
> >     r +=3D store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO,
> DEFAULT_GETUID,
> >          "/sbin/mpath_prio_netapp /dev/%n", NULL,
> >          "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF);
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_16181_19843129.1134060329851
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I think FAILBACK_IMMEDIATE for DS6000 makes more sense. Also for SVC
(2145) the same settings should be used as DS6000 since it is also an
asymetric device, <br>
i.e. <br>
&nbsp;&nbsp;&nbsp; r +=3D store_hwe_ext(hw, &quot;IBM&quot;, &quot;2145&quo=
t;, GROUP_BY_PRIO, DEFAULT_GETUID,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;
&quot;/sbin/mpath_prio_alua /dev/%n&quot;, &quot;0&quot;, &quot;1 queue_if_=
no_path&quot;, &quot;tur&quot;,
FAILBACK_IMMEDIATE);<br>
<br><br><div><span class=3D"gmail_quote">On 12/7/05, <b class=3D"gmail_send=
ername">Stefan Bader</b> &lt;<a href=3D"mailto:Stefan.Bader@de.ibm.com">Ste=
fan.Bader@de.ibm.com</a>&gt; wrote:</span><blockquote class=3D"gmail_quote"=
 style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.=
8ex; padding-left: 1ex;">
Hi Christophe, Hannes,<br><br>I thought I had already sent parts of these b=
ut they don't seem to be in<br>the git head when<br>I look now. I'd suggest=
 a small change for the DS6000 aka 1750500. Since<br>paths with<br>higher p=
rio are more appreciated, wouldn'T FAILBACK_IMMEDIATE make more
<br>sense?<br><br>Regards,<br>Stefan<br><br>SW Linux on zSeries Development=
 &amp; Services<br><a href=3D"mailto:Stefan.Bader@de.ibm.com">Stefan.Bader@=
de.ibm.com</a><br>---------------------------------------------------------=
-------------------------
<br>&nbsp;&nbsp;When all other means of communication fail, try words.<br><=
br><a href=3D"mailto:dm-devel-bounces@redhat.com">dm-devel-bounces@redhat.c=
om</a> wrote on 07.12.2005 12:11:23:<br><br>&gt; Hi Christophe,<br>&gt;<br>=
&gt; attached is a patch to update=20
hwtable.c with some IBM Storage Servers.<br>&gt; Especially the DS6000 shou=
ld be handled properly as it again has<br>&gt; asymmetric paths.<br>&gt;<br=
>&gt; Cheers,<br>&gt;<br>&gt; Hannes<br>&gt; --<br>&gt; Dr. Hannes Reinecke=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
<a href=3D"mailto:hare@suse.de">hare@suse.de</a><br>&gt; SuSE Linux Product=
s GmbH&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S390 &amp; zSeries<br>&gt; Maxfel=
dstra=DFe 5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;+49 911 74053 688<br>&gt; 90409 N=FCrnberg&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=3D"http://www.suse.d=
e">http://www.suse.de
</a><br>&gt; Subject: Hardware entries for IBM Storage Servers<br>&gt;<br>&=
gt; Several IBM Storage Servers (most notably the DS range) need<br>&gt; sp=
ecific hardware entries. This patch adds hardware entries<br>&gt; for:<br>
&gt;<br>&gt; - IBM ESS F20 (aka Shark)<br>&gt; - IBM DS6000<br>&gt; - IBM D=
S8000<br>&gt; - IBM SVC<br>&gt;<br>&gt; Signed-off-by: Hannes Reinecke &lt;=
<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt;<br>&gt;<br>&gt; ---<br=
>
&gt;<br>&gt;&nbsp;&nbsp;libmultipath/hwtable.c |&nbsp;&nbsp; 14 +++++++++++=
+++<br>&gt;&nbsp;&nbsp;1 files changed, 14 insertions(+), 0 deletions(-)<br=
>&gt;<br>&gt; diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<=
br>&gt; --- a/libmultipath/hwtable.c
<br>&gt; +++ b/libmultipath/hwtable.c<br>&gt; @@ -39,6 +39,20 @@ setup_defa=
ult_hwtable (vector hw)<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; &quot;1 queue_if_no_path&quot;, &quot;emc_clariion&quot;, =
-FAILBACK_IMMEDIATE);<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp; r +=3D store_hwe_ext(=
hw, &quot;IBM&quot;, &quot;3542&quot;, GROUP_BY_SERIAL,
<br>DEFAULT_GETUID,<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; NULL, &quot;0&quot;, &quot;0&quot;, &quot;tur&quot;, FAILBACK_=
UNDEF);<br>&gt; +&nbsp;&nbsp; /* IBM ESS F20 aka Shark */<br>&gt; +&nbsp;&n=
bsp; r +=3D store_hwe_ext(hw, &quot;IBM&quot;, &quot;2105F20&quot;, GROUP_B=
Y_SERIAL,
<br>&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEFAULT_GETUID, =
NULL, &quot;0&quot;, &quot;1 queue_if_no_path&quot;,<br>&gt; +&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;tur&quot;, FAILBACK_UNDEF);<br>&g=
t; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* IBM DS6000 */<br>&gt; +&nbsp;&n=
bsp; r +=3D store_hwe_ext(hw, &quot;IBM&quot;, &quot;1750500&quot;, GROUP_B=
Y_PRIO,
<br>DEFAULT_GETUID,<br>&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; &quot;/sbin/mpath_prio_alua /dev/%n&quot;, &quot;0&quot;, &quot;1 queue_=
if_no_path&quot;,<br>&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 &quot;tur&quot;, FAILBACK_UNDEF);<br>&gt; +&nbsp;&nbsp; /* IBM DS8000 */<b=
r>&gt; +&nbsp;&nbsp; r +=3D store_hwe_ext(hw, &quot;IBM&quot;, &quot;210790=
0&quot;, GROUP_BY_SERIAL,
<br>DEFAULT_GETUID,<br>&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; NULL, &quot;0&quot;, &quot;1 queue_if_no_path&quot;, &quot;tur&quot;, FA=
ILBACK_UNDEF);<br>&gt; +&nbsp;&nbsp; /* IBM SAN Volume Controller */<br>&gt=
; +&nbsp;&nbsp; r +=3D store_hwe_ext(hw, &quot;IBM&quot;, &quot;2145&quot;,=
 MULTIBUS, DEFAULT_GETUID,
<br>&gt; +&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NULL, &quot;0&qu=
ot;, &quot;1 queue_if_no_path&quot;, &quot;tur&quot;, FAILBACK_UNDEF);<br>&=
gt;&nbsp;&nbsp;&nbsp;&nbsp; r +=3D store_hwe_ext(hw, &quot;NETAPP&quot;, &q=
uot;LUN&quot;, GROUP_BY_PRIO,<br>DEFAULT_GETUID,<br>&gt;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;/sbin/mpath_prio_netapp /dev=
/%n&quot;, NULL,
<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;1=
 queue_if_no_path&quot;, &quot;readsector0&quot;, FAILBACK_UNDEF);<br>&gt; =
--<br>&gt; dm-devel mailing list<br>&gt; <a href=3D"mailto:dm-devel@redhat.=
com">dm-devel@redhat.com</a><br>&gt; <a href=3D"https://www.redhat.com/mail=
man/listinfo/dm-devel">
https://www.redhat.com/mailman/listinfo/dm-devel</a><br><br>--<br>dm-devel =
mailing list<br><a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com<=
/a><br><a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https:/=
/www.redhat.com/mailman/listinfo/dm-devel
</a><br></blockquote></div><br>

------=_Part_16181_19843129.1134060329851--


--===============1034884441==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1034884441==--
