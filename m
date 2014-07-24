From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipath and READ_CAPACITY
Date: Thu, 24 Jul 2014 11:00:26 +0200
Message-ID: <CABr-Gnf7eCSKxcQzM2SHtNZe_V90WzxOOebtLfdfn7Xxcvq_jQ@mail.gmail.com>
References: <53D0C7E7.6090806@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2415528609602031707=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53D0C7E7.6090806@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

--===============2415528609602031707==
Content-Type: multipart/alternative; boundary=e89a8fb1ea680ffac304feecb07d

--e89a8fb1ea680ffac304feecb07d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This sanity check is useful because users can set arbitrary getuid scripts,
and thus corrupt data if their getuid callout is bogus.
Now, this getuid callout facility is a lot less publicized ...
I'd apply the patch, no problem on my side.


On Thu, Jul 24, 2014 at 10:46 AM, Hannes Reinecke <hare@suse.de> wrote:

> Hi Christophe,
>
> I've had a customer issue where someone complained that multipath would
> reject paths if they are in ALUA 'standby'.
> As it turns out, SPC-3 does _not_ require the READ_CAPACITY command to be
> implemented if a target port is in standby.
> Consecutively, linux would register this path with a capacity of '0', and
> multipath would reject the path in ev_add_path().
>
> Which makes we wonder, do we actually _need_ the check for a matched
> capacity?
> With VPD page 0x83 pretty much standard as of now (and I'm reasonbly sure
> we'll reject any device _not_ providing VPD page 0x83 anyway) we basicall=
y
> have to rely on that information.
> IE if the WWID is identical we have assume the devices are identical. So
> it would make sense to just remove the check altogether.
>
> Thoughts?
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

--e89a8fb1ea680ffac304feecb07d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This sanity check is useful because users can set arbitrar=
y getuid scripts, and thus corrupt data if their getuid callout is bogus.<d=
iv>Now, this getuid callout facility is a lot less publicized ...</div><div=
>
I&#39;d apply the patch, no problem on my side.</div><div class=3D"gmail_ex=
tra"><br><br><div class=3D"gmail_quote">On Thu, Jul 24, 2014 at 10:46 AM, H=
annes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=
=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi Christophe,<br>
<br>
I&#39;ve had a customer issue where someone complained that multipath would=
 reject paths if they are in ALUA &#39;standby&#39;.<br>
As it turns out, SPC-3 does _not_ require the READ_CAPACITY command to be i=
mplemented if a target port is in standby.<br>
Consecutively, linux would register this path with a capacity of &#39;0&#39=
;, and multipath would reject the path in ev_add_path().<br>
<br>
Which makes we wonder, do we actually _need_ the check for a matched capaci=
ty?<br>
With VPD page 0x83 pretty much standard as of now (and I&#39;m reasonbly su=
re we&#39;ll reject any device _not_ providing VPD page 0x83 anyway) we bas=
ically have to rely on that information.<br>
IE if the WWID is identical we have assume the devices are identical. So it=
 would make sense to just remove the check altogether.<br>
<br>
Thoughts?<br>
<br>
Cheers,<br>
<br>
Hannes<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
Dr. Hannes Reinecke =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 zSeries &amp; Storage<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a> =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0<a href=3D"tel:%2B49%20911%2074053%20688" value=3D"+4991174053688=
" target=3D"_blank">+49 911 74053 688</a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)<br=
>
</font></span></blockquote></div><br></div></div>

--e89a8fb1ea680ffac304feecb07d--


--===============2415528609602031707==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2415528609602031707==--
