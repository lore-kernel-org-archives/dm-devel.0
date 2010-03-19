From: David Zeuthen <zeuthen@gmail.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 10:59:12 -0400
Message-ID: <7b13a0f81003190759w4de7be34pfa1a0454ac311ad8@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
	<20100319143412.GE919@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4291345442544799397=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100319143412.GE919@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

--===============4291345442544799397==
Content-Type: multipart/alternative; boundary=001636c5a2851ad0670482289781

--001636c5a2851ad0670482289781
Content-Type: text/plain; charset=ISO-8859-1

Hey,

On Fri, Mar 19, 2010 at 10:34 AM, Alasdair G Kergon <agk@redhat.com> wrote:

> On Fri, Mar 19, 2010 at 09:58:00AM -0400, David Zeuthen wrote:
> > I think the problem is the that fact that 3rd party user space
> > opens the device before it is ready (e.g. just after ADD but before
> > the first CHANGE) makes things fall over.
> > This short-coming is what needs to get fixed, I think - it's very
> > fragile this way and since any random user / package can add
> > rules to open the device on add events, said user / package can
> > make device-mapper fail. Which doesn't exactly strike me
> > as robust behavior.
>
> And we suggested two potential solutions:
>
>  1 - change the kernel so the ADD event doesn't arrive until the device is
> ready for use.     [plus equivalent change for REMOVE]
>
>      Advantage: the dm device handling looks more like a real disk so we
> have
> less 'special case' code.  /dev then only indexes "dm devices ready to be
> used"
> rather than "dm devices registered in the kernel"
>
>      Disadvantage: breaks the currently-simple kobject/sysfs/dev linkage
> (as
> per Kay's earlier mail)


>
>  2 - several changes to the way udev rules are handled so we can choose to
> ignore events and make no changes to /dev, so we can override rules other
> packages insert without requiring dm-specific checks adding to them all,
> and
> probably some of the other things we've discussed on these various threads.
>

I don't think it's realistic to assume that user space will read and honor
something like a DM_UDEV_DISABLE_DM_RULES_FLAG property - while
we can make the udev package and other "core" OS packages do this, rules
from users, sites and random 3rd party packages will open() the device
on "add" (and, if properly written, also on "change").

It's much better to make that operation somehow gracefully fail in the
window where the device isn't configured. My understanding is that
we are not doing this today - for example, suppose I have this udev
rule

  SUBSYSTEM=="block", ACTION=="add|change", \
  IMPORT{program}="foo-check-for-some-signature $tempnode"

where foo-check-for-some-signature is some program to check for
a fs signature (say, for a properietary fs on a portable music
player device) and, if, so, set the FOO_* properties with specifics
about the device (these will be used in the UI to control/manage
the portable music player).

Things like this should work for any block device, no matter what
state it's in. Sure, for device-mapper block devices open() or
read() on the device may fail in the window between "add" and
"change" but that's fine.

What can never happen though, is that this configuration of the
device-mapper device somehow randomly fails because the
program foo-check-for-some-signature tries to open every block
device.

(Sure, user space can be _clever_ and save the fork+exec+open
by checking DM_UDEV_DISABLE_DM_RULES_FLAG from an
udev rule - but that's optimization, not something required for
correctness.)

I haven't checked if this problem still exists with device-mapper
but I know, in the past, that it has - and IIRC it was the reason
that you introduced DM_UDEV_DISABLE_DM_RULES_FLAG
after the udev ignore_device directive was removed.

I'd like to reiterate that it's actually not a problem that the sequence is

 - "add" uevent
 - device is not usable, access to the device fails gracefully
 - "change" uevent
 - device usable, blkid on the device etc. works

the point really is that you have to accept that there will exist
user space programs that does things on the device between
"add" and the initial "change" uevent.

The other problem, the assumption that "change" uevents only
originates from libdevmapper, is separate from this problem.

     David

--001636c5a2851ad0670482289781
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hey,</div><div><br></div>On Fri, Mar 19, 2010 at 10:34 AM, Alasdair G =
Kergon <span dir=3D"ltr">&lt;<a href=3D"mailto:agk@redhat.com">agk@redhat.c=
om</a>&gt;</span> wrote:<br><div class=3D"gmail_quote"><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex;">
<div class=3D"im">On Fri, Mar 19, 2010 at 09:58:00AM -0400, David Zeuthen w=
rote:<br>
&gt; I think the problem is the that fact that 3rd party user space<br>
&gt; opens the device before it is ready (e.g. just after ADD but before<br=
>
&gt; the first CHANGE) makes things fall over.<br>
&gt; This short-coming is what needs to get fixed, I think - it&#39;s very<=
br>
&gt; fragile this way and since any random user / package can add<br>
&gt; rules to open the device on add events, said user / package can<br>
&gt; make device-mapper fail. Which doesn&#39;t exactly strike me<br>
&gt; as robust behavior.<br>
<br>
</div>And we suggested two potential solutions:<br>
<br>
 =A01 - change the kernel so the ADD event doesn&#39;t arrive until the dev=
ice is<br>
ready for use. =A0 =A0 [plus equivalent change for REMOVE]<br>
<br>
 =A0 =A0 =A0Advantage: the dm device handling looks more like a real disk s=
o we have<br>
less &#39;special case&#39; code. =A0/dev then only indexes &quot;dm device=
s ready to be used&quot;<br>
rather than &quot;dm devices registered in the kernel&quot;<br>
<br>
 =A0 =A0 =A0Disadvantage: breaks the currently-simple kobject/sysfs/dev lin=
kage (as<br>
per Kay&#39;s earlier mail)=A0</blockquote><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<br>
<br>
 =A02 - several changes to the way udev rules are handled so we can choose =
to<br>
ignore events and make no changes to /dev, so we can override rules other<b=
r>
packages insert without requiring dm-specific checks adding to them all, an=
d<br>
probably some of the other things we&#39;ve discussed on these various thre=
ads.<br></blockquote><div><br></div><div>I don&#39;t think it&#39;s realist=
ic to assume that user space will read and honor</div><div>something like a=
=A0DM_UDEV_DISABLE_DM_RULES_FLAG property - while</div>
<div>we can make the udev package and other &quot;core&quot; OS packages do=
 this, rules</div><div>from users, sites and random 3rd party packages will=
 open() the device</div><div>on &quot;add&quot; (and, if properly written, =
also on &quot;change&quot;).</div>
<div><br></div><div>It&#39;s much better to make that operation somehow gra=
cefully fail in the</div><div>window where the device isn&#39;t configured.=
 My understanding is that</div><div>we are not doing this today - for examp=
le, suppose I have this udev</div>
<div>rule</div><div><br></div><div>=A0=A0SUBSYSTEM=3D=3D&quot;block&quot;, =
ACTION=3D=3D&quot;add|change&quot;, \</div><div>=A0=A0IMPORT{program}=3D&qu=
ot;foo-check-for-some-signature $tempnode&quot;</div><div><br></div><div>wh=
ere=A0foo-check-for-some-signature is some program to check for</div>
<div>a fs signature (say, for a properietary fs on a portable music</div><d=
iv>player device) and, if, so, set the FOO_* properties with specifics</div=
><div>about the device (these will be used in the UI to control/manage</div=
>
<div>the portable music player).</div><div><br></div><div>Things like this =
should work for any block device, no matter what</div><div>state it&#39;s i=
n. Sure, for device-mapper block devices open() or</div><div>read() on the =
device=A0may fail in the window between &quot;add&quot; and</div>
<div>&quot;change&quot; but that&#39;s fine.</div><div><br></div><div>What =
can never happen though, is that this configuration of the</div><div>device=
-mapper device somehow randomly fails because the</div><div>program foo-che=
ck-for-some-signature tries to open every block</div>
<div>device.</div><div><br></div><div><div>(Sure, user space can be _clever=
_ and save the fork+exec+open</div><div>by checking=A0DM_UDEV_DISABLE_DM_RU=
LES_FLAG from an</div><div>udev rule - but that&#39;s optimization, not som=
ething required for</div>
<div>correctness.)</div><div><br></div><div>I haven&#39;t checked if this p=
roblem still exists with device-mapper</div><div>but I know, in the past, t=
hat it has - and IIRC it was the reason</div><div>that you introduced=A0DM_=
UDEV_DISABLE_DM_RULES_FLAG</div>
<div>after the udev ignore_device directive was removed.</div><div><br></di=
v></div><div>I&#39;d like to reiterate that it&#39;s actually not a problem=
 that the sequence is</div><div><br></div><div>=A0- &quot;add&quot; uevent<=
/div>
<div>=A0- device is not usable, access to the device fails gracefully</div>=
<div>=A0- &quot;change&quot; uevent</div><div>=A0- device usable, blkid on =
the device etc. works</div><div><br></div><div>the point really is that you=
 have to accept that there will exist</div>
<div>user space programs that does things on the device between</div><div>&=
quot;add&quot; and the initial &quot;change&quot; uevent.</div><div><br></d=
iv><div>The other problem, the assumption that &quot;change&quot; uevents o=
nly</div>
<div>originates from libdevmapper, is separate from this problem.</div><div=
><br></div><div>=A0=A0 =A0 David</div><div><br></div></div>

--001636c5a2851ad0670482289781--


--===============4291345442544799397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4291345442544799397==--
