From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 22/57] multipath: use option '-i' when called
	from udev
Date: Tue, 3 May 2016 08:37:08 +0200
Message-ID: <CABr-GncAsFSouftGFZgnMR5FLsF+U3GYYLtbe8MTY3LG3g7=rw@mail.gmail.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-23-git-send-email-hare@suse.de>
	<20160502153124.GP26117@octiron.msp.redhat.com>
	<57283ABF.4080304@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0349852498472736321=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57283ABF.4080304@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============0349852498472736321==
Content-Type: multipart/alternative; boundary=001a114a42be9d4adb0531ea5659

--001a114a42be9d4adb0531ea5659
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ben,

does this patch actually break the Red Hat integration ?
I'm inclined to merge it if not.

Thanks,
Christophe

On Tue, May 3, 2016 at 7:44 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 05/02/2016 05:31 PM, Benjamin Marzinski wrote:
> > On Wed, Apr 27, 2016 at 01:10:23PM +0200, Hannes Reinecke wrote:
> >> multipath should be using the option '-i' to ignore the wwids
> >> file when called from udev. Otherwise we might run into a race
> >> condition with systemd and the system might not boot up correctly.
> >
> > The race condition being? Are you talking about the udev rules not
> > claiming a path for multipath, but then having multipathd create a
> > multipath device using that path? I agree that this can be an issue.
> > Another way to solve it is to run mutipathd with the -n option in the
> > initramfs (see commit a8efa5838cf215febd853f282c26af62c0daa862). That
> > commit solves the race by making mutipathd ignore devices that aren't
> > already in the wwids file.  This also keeps the initramfs from picking =
a
> > different user_friendly_name than will be picked in late boot (but
> > hopefully that issue has been sorted out by other patches already).
> >
> This is in fact SUSE-specific, as we do _not_ require any a-priory
> configuration. So we will start out with a system without any wwid file,
> _but_ expect multipath to start up properly.
> As the wwid file will only be created by multipathd the udev check will
> always being false, and none of the multipath devices will be created.
>
> > I'm not NAKing this. The question of what to do about the differnces in
> > the distribution's systemd and udev configurations can be hashed out
> > outside of patch reviewing. I just want to make sure I understand the
> > race this is solving.
> >
> This is in fact a good question.
> We should be coming up with a common approach which would suit both needs=
.
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

--001a114a42be9d4adb0531ea5659
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ben,<div><br></div><div>does this patch actually break the=
 Red Hat integration ?</div><div>I&#39;m inclined to merge it if not.</div>=
<div><br></div><div>Thanks,</div><div>Christophe</div></div><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Tue, May 3, 2016 at 7:44 AM, =
Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" targe=
t=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex"><span class=3D"">On 05/02/2016 05:31 PM, Benjamin Marzinski wrote:<b=
r>
&gt; On Wed, Apr 27, 2016 at 01:10:23PM +0200, Hannes Reinecke wrote:<br>
&gt;&gt; multipath should be using the option &#39;-i&#39; to ignore the ww=
ids<br>
&gt;&gt; file when called from udev. Otherwise we might run into a race<br>
&gt;&gt; condition with systemd and the system might not boot up correctly.=
<br>
&gt;<br>
&gt; The race condition being? Are you talking about the udev rules not<br>
&gt; claiming a path for multipath, but then having multipathd create a<br>
&gt; multipath device using that path? I agree that this can be an issue.<b=
r>
&gt; Another way to solve it is to run mutipathd with the -n option in the<=
br>
&gt; initramfs (see commit a8efa5838cf215febd853f282c26af62c0daa862). That<=
br>
&gt; commit solves the race by making mutipathd ignore devices that aren&#3=
9;t<br>
&gt; already in the wwids file.=C2=A0 This also keeps the initramfs from pi=
cking a<br>
&gt; different user_friendly_name than will be picked in late boot (but<br>
&gt; hopefully that issue has been sorted out by other patches already).<br=
>
&gt;<br>
</span>This is in fact SUSE-specific, as we do _not_ require any a-priory<b=
r>
configuration. So we will start out with a system without any wwid file,<br=
>
_but_ expect multipath to start up properly.<br>
As the wwid file will only be created by multipathd the udev check will<br>
always being false, and none of the multipath devices will be created.<br>
<span class=3D""><br>
&gt; I&#39;m not NAKing this. The question of what to do about the differnc=
es in<br>
&gt; the distribution&#39;s systemd and udev configurations can be hashed o=
ut<br>
&gt; outside of patch reviewing. I just want to make sure I understand the<=
br>
&gt; race this is solving.<br>
&gt;<br>
</span>This is in fact a good question.<br>
We should be coming up with a common approach which would suit both needs.<=
br>
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

--001a114a42be9d4adb0531ea5659--


--===============0349852498472736321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0349852498472736321==--
