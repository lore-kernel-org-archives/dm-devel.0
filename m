From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 13/13] multipathd: no_map_shutdown option
Date: Fri, 22 Nov 2013 11:11:22 +0100
Message-ID: <CABr-GndEn2D0OMpOKAP0_WNxHDZCxD+RRw4N87yKKWX_YvENsg@mail.gmail.com>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
	<1384511384-27642-14-git-send-email-hare@suse.de>
	<20131121231710.GL1661@dhcp80-209.msp.redhat.com>
	<528F2004.2050101@suse.de>
	<CABr-GncbrpsL5VLvHh+V0e714KguJrJEuRGfihrcq+1Wbs568w@mail.gmail.com>
	<528F2C21.1000005@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4283990358636945914=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <528F2C21.1000005@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============4283990358636945914==
Content-Type: multipart/alternative; boundary=047d7bf182d27ca92d04ebc13c7a

--047d7bf182d27ca92d04ebc13c7a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Excellent,

I'll push the 01-05 patchset to the master git repo this evening (GMT+1)



On Fri, Nov 22, 2013 at 11:04 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 11/22/2013 10:30 AM, Christophe Varoqui wrote:
> > Hi,
> >
> > To my knowledge, systemd has not been integrated in all distributions.
> > It would be nice not to break the build of multipath-tools on those
> > environments.
> >
> > The current patchset breaks the build on non-systemd systems as soon
> > as patch 06/13.
> > I can apply the patchset from 01/13 to 05/13 included, and let you
> > refactor the systemd integration proper in a new series.
> >
> > Is that ok with you ?
> >
> Yes, of course.
>
> I'll be reworking the remaining patches to make systemd optional.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
>

--047d7bf182d27ca92d04ebc13c7a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Excellent,<div><br></div><div>I&#39;ll push the 01-05 patc=
hset to the master git repo this evening (GMT+1)</div><div><br></div></div>=
<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Nov 2=
2, 2013 at 11:04 AM, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 11/22/2013 10:30 AM, Ch=
ristophe Varoqui wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; To my knowledge, systemd has not been integrated in all distributions.=
<br>
&gt; It would be nice not to break the build of multipath-tools on those<br=
>
&gt; environments.<br>
&gt;<br>
&gt; The current patchset breaks the build on non-systemd systems as soon<b=
r>
&gt; as patch 06/13.<br>
&gt; I can apply the patchset from 01/13 to 05/13 included, and let you<br>
&gt; refactor the systemd integration proper in a new series.<br>
&gt;<br>
&gt; Is that ok with you ?<br>
&gt;<br>
</div>Yes, of course.<br>
<br>
I&#39;ll be reworking the remaining patches to make systemd optional.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Hannes<br>
--<br>
Dr. Hannes Reinecke =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zSeries &amp; Stora=
ge<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a> =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0<a href=3D"tel:%2B49%20911%2074053%20688" value=
=3D"+4991174053688">+49 911 74053 688</a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)<br>
</div></div></blockquote></div><br></div>

--047d7bf182d27ca92d04ebc13c7a--


--===============4283990358636945914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4283990358636945914==--
