From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 11/15] multipath: enable configuration
	directory
Date: Mon, 9 Mar 2015 00:29:17 +0100
Message-ID: <CABr-GncekSo0WLREj6B2XZehaEvbd32vcAt747bcJufgqd+nnA@mail.gmail.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
	<1425785506-20419-12-git-send-email-bmarzins@redhat.com>
	<20150308232706.000039e7@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1859907352482536606=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150308232706.000039e7@localhost>
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

--===============1859907352482536606==
Content-Type: multipart/alternative; boundary=047d7bdc0dd24508bd0510cf493c

--047d7bdc0dd24508bd0510cf493c
Content-Type: text/plain; charset=UTF-8

I had the same thought reading the patch, but I couldn't see any
consistency in existing "*.d" directory locations in modern distros I
couldn't decently object to Ben's proposal :

Following Ben's proposal :
/etc/udev/*.d
/etc/mysql/conf.d
/etc/apm/*.d

Following your proposal :
/etc/rsyslog.d
/etc/sysctl.d
/etc/profile.d

Does somebody know if the LSB FHS gives guidelines for this ?

Best regards,
Christophe Varoqui


On Sun, Mar 8, 2015 at 11:27 PM, Sebastian Herbszt <herbszt@gmx.de> wrote:

> Benjamin Marzinski wrote:
> > Users who setup multipath on many machines sometimes want a core
> > configuration file that stays the same on all machines, and also
> secondary
> > configuration files that are unique to each machine to set blacklists and
> > aliases.  This patch enables this by adding a new configuration option,
> > "config_dir", which defaults to "/etc/multipath/conf.d". If this is set,
> > multipath will check this directory for files ending in .conf, and apply
> > them on top of the initial configuration file in alphabetical order.
>
> How about using "/etc/multipath.conf.d" instead of "/etc/multipath/conf.d"
> ?
>
> Sebastian
>

--047d7bdc0dd24508bd0510cf493c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I had the same thought reading the patch, but I couldn&#39=
;t see any consistency in existing &quot;*.d&quot; directory locations in m=
odern distros I couldn&#39;t decently object to Ben&#39;s proposal :<div><b=
r></div><div>Following Ben&#39;s proposal :</div><div>/etc/udev/*.d</div><d=
iv>/etc/mysql/conf.d</div><div>/etc/apm/*.d</div><div><br></div><div>Follow=
ing your proposal :</div><div>/etc/rsyslog.d</div><div>/etc/sysctl.d</div><=
div>/etc/profile.d</div><div><br></div><div>Does somebody know if the LSB F=
HS gives guidelines for this ?</div><div><br></div><div>Best regards,</div>=
<div>Christophe Varoqui</div><div>=C2=A0=C2=A0</div></div><div class=3D"gma=
il_extra"><br><div class=3D"gmail_quote">On Sun, Mar 8, 2015 at 11:27 PM, S=
ebastian Herbszt <span dir=3D"ltr">&lt;<a href=3D"mailto:herbszt@gmx.de" ta=
rget=3D"_blank">herbszt@gmx.de</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">Benjamin Marzinski wrote:<br>
&gt; Users who setup multipath on many machines sometimes want a core<br>
&gt; configuration file that stays the same on all machines, and also secon=
dary<br>
&gt; configuration files that are unique to each machine to set blacklists =
and<br>
&gt; aliases.=C2=A0 This patch enables this by adding a new configuration o=
ption,<br>
&gt; &quot;config_dir&quot;, which defaults to &quot;/etc/multipath/conf.d&=
quot;. If this is set,<br>
&gt; multipath will check this directory for files ending in .conf, and app=
ly<br>
&gt; them on top of the initial configuration file in alphabetical order.<b=
r>
<br>
</span>How about using &quot;/etc/multipath.conf.d&quot; instead of &quot;/=
etc/multipath/conf.d&quot; ?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Sebastian<br>
</font></span></blockquote></div><br></div>

--047d7bdc0dd24508bd0510cf493c--


--===============1859907352482536606==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1859907352482536606==--
