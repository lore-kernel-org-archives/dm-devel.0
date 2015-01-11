From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 3/6] libmultipath: add overrides section to
	multipath.conf
Date: Mon, 12 Jan 2015 00:37:22 +0100
Message-ID: <CABr-Gnc_3KwO9THMcHW2Yam=QdzK=cJaFxrbevAS-ATOxuJoXw@mail.gmail.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-4-git-send-email-bmarzins@redhat.com>
	<CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
	<20150112001525.0000473f@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0081013012936067782=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150112001525.0000473f@localhost>
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

--===============0081013012936067782==
Content-Type: multipart/alternative; boundary=001a11c364741ad3f0050c68dfeb

--001a11c364741ad3f0050c68dfeb
Content-Type: text/plain; charset=UTF-8

Hi,

the precedence chain is :

multipaths > user-specified per-device > default per-device > default

The issue adressed by Ben's patch would not be solved by your suggestion,
as far as I can see. The proposed override section is just a way not repeat
a per-device in each multipath (insane) or device (tedious) section.

I personnaly implement the tedious device configuration using a
configuration manager (shameless plug: opensvc). But I can see the value of
an override section for those not using a such config management tools.

Best regards,
Christophe Varoqui
OpenSVC

On Mon, Jan 12, 2015 at 12:15 AM, Sebastian Herbszt <herbszt@gmx.de> wrote:

> Christophe Varoqui wrote:
> > I have no strong opinion on this one : I feel like the complexity of the
> > parameter inheritance system is already quite complicated ... but this
> > addition of a new layer would likely and safely be ignored by users who
> > don't need it. Those who need it are surely ready to pay the price.
> >
> > Does someone have objection to my applying this patch ?
> >
> > Best regards,
> > Christophe
> >
> >
> >
> > On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <bmarzins@redhat.com
> >
> > wrote:
> >
> > > Sometimes users want to be able to set a configuration value for all
> their
> > > devices (for instance, they may want all devices to set no_path_retry
> to
> > > fail). The builtin device configurations make this tricky, since users
> need
> > > to change each device configuration individually. To avoid that, this
> patch
> > > adds a new section to multipath.conf, "overrides".  This section has
> all of
> > > the attributes that are in both the devices and defaults section.
> > > Attributes set in the overrides section have a higher priority that
> those
> > > in the devices section. With this section added, the multipath
> > > configuration order now goes:
> > >
> > > multipaths > overrides > devices > defaults
> > >
> > > I also made want_user_friendly_names print out where the configuration
> came
> > > from, and I made made select_hwhandler and select_selector always
> strdup
> > > the string, instead of only on the defaults.  Since multipathd will
> update
> > > the device strings from the kernel anyway, the old way just added
> > > complexity without saving any memory.
> > >
> > > To store the overrides configuration, I used a hwentry structure. We
> may
> > > want to make a new overrides structure, so that we set any of the
> defaults
> > > values in overrides.  That way, users could skip using defaults and
> just
> > > use overrides if they wanted. However, this would take some additional
> > > changes to make sure that all the defaults options can undefined, which
> > > they can't currently be.
> > >
>
> What's the current precedence of the configuration sections? I don't think
> the manual pages document this (sufficiently). I guess the precedence is:
>
> multipaths > devices > defaults
>
> But where do the built-in device configurations fit in? It seems those are
> somehow merged with the user supplied entries from the configuration file.
>
> Would changing the precedence to
>
> multipaths > devices > defaults > built-in devices
>
> fix the issue at hand?
>
> Sebastian
>

--001a11c364741ad3f0050c68dfeb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>the precedence chain is :</div><div=
><br></div><div>multipaths &gt; user-specified per-device &gt; default per-=
device &gt; default</div><div><br></div><div>The issue adressed by Ben&#39;=
s patch would not be solved by your suggestion, as far as I can see. The pr=
oposed override section is just a way not repeat a per-device in each multi=
path (insane) or device (tedious) section.</div><div><br></div><div>I perso=
nnaly implement the tedious device configuration using a configuration mana=
ger (shameless plug: opensvc). But I can see the value of an override secti=
on for those not using a such config management tools.</div><div><br></div>=
<div>Best regards,</div><div>Christophe Varoqui</div><div>OpenSVC</div></di=
v><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Jan 12,=
 2015 at 12:15 AM, Sebastian Herbszt <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:herbszt@gmx.de" target=3D"_blank">herbszt@gmx.de</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">Chr=
istophe Varoqui wrote:<br>
&gt; I have no strong opinion on this one : I feel like the complexity of t=
he<br>
&gt; parameter inheritance system is already quite complicated ... but this=
<br>
&gt; addition of a new layer would likely and safely be ignored by users wh=
o<br>
&gt; don&#39;t need it. Those who need it are surely ready to pay the price=
.<br>
&gt;<br>
&gt; Does someone have objection to my applying this patch ?<br>
&gt;<br>
&gt; Best regards,<br>
&gt; Christophe<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski &lt;<a href=3D"mai=
lto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;<br>
&gt; wrote:<br>
&gt;<br>
&gt; &gt; Sometimes users want to be able to set a configuration value for =
all their<br>
&gt; &gt; devices (for instance, they may want all devices to set no_path_r=
etry to<br>
&gt; &gt; fail). The builtin device configurations make this tricky, since =
users need<br>
&gt; &gt; to change each device configuration individually. To avoid that, =
this patch<br>
&gt; &gt; adds a new section to multipath.conf, &quot;overrides&quot;.=C2=
=A0 This section has all of<br>
&gt; &gt; the attributes that are in both the devices and defaults section.=
<br>
&gt; &gt; Attributes set in the overrides section have a higher priority th=
at those<br>
&gt; &gt; in the devices section. With this section added, the multipath<br=
>
&gt; &gt; configuration order now goes:<br>
&gt; &gt;<br>
&gt; &gt; multipaths &gt; overrides &gt; devices &gt; defaults<br>
&gt; &gt;<br>
&gt; &gt; I also made want_user_friendly_names print out where the configur=
ation came<br>
&gt; &gt; from, and I made made select_hwhandler and select_selector always=
 strdup<br>
&gt; &gt; the string, instead of only on the defaults.=C2=A0 Since multipat=
hd will update<br>
&gt; &gt; the device strings from the kernel anyway, the old way just added=
<br>
&gt; &gt; complexity without saving any memory.<br>
&gt; &gt;<br>
&gt; &gt; To store the overrides configuration, I used a hwentry structure.=
 We may<br>
&gt; &gt; want to make a new overrides structure, so that we set any of the=
 defaults<br>
&gt; &gt; values in overrides.=C2=A0 That way, users could skip using defau=
lts and just<br>
&gt; &gt; use overrides if they wanted. However, this would take some addit=
ional<br>
&gt; &gt; changes to make sure that all the defaults options can undefined,=
 which<br>
&gt; &gt; they can&#39;t currently be.<br>
&gt; &gt;<br>
<br>
</div></div>What&#39;s the current precedence of the configuration sections=
? I don&#39;t think<br>
the manual pages document this (sufficiently). I guess the precedence is:<b=
r>
<br>
multipaths &gt; devices &gt; defaults<br>
<br>
But where do the built-in device configurations fit in? It seems those are<=
br>
somehow merged with the user supplied entries from the configuration file.<=
br>
<br>
Would changing the precedence to<br>
<br>
multipaths &gt; devices &gt; defaults &gt; built-in devices<br>
<br>
fix the issue at hand?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Sebastian<br>
</font></span></blockquote></div><br></div>

--001a11c364741ad3f0050c68dfeb--


--===============0081013012936067782==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0081013012936067782==--
