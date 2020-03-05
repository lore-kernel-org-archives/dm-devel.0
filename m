From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] [git pull] device mapper fixes for 5.6-rc5
Date: Thu, 5 Mar 2020 10:44:21 +0100
Message-ID: <7493a5fb-e267-6aaa-286b-16472ac8a5ca@redhat.com>
References: <20200304150257.GA19885@redhat.com>
 <CAHk-=wgP=q648JXn8Hd9q7DuNaOEpLmxQp2W3RO3vkaD2CS_9g@mail.gmail.com>
 <20200304192335.GA24296@redhat.com>
 <CAHk-=wjdzxSGRLVHheRd1WA_FhsAMEV5pOwy08x8NaMG7ty8DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjdzxSGRLVHheRd1WA_FhsAMEV5pOwy08x8NaMG7ty8DQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Hou Tao <houtao1@huawei.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Dne 04. 03. 20 v 20:34 Linus Torvalds napsal(a):
>=20
>=20
> On Wed, Mar 4, 2020, 13:23 Mike Snitzer <snitzer@redhat.com=20
> <mailto:snitzer@redhat.com>> wrote:
>=20
>=20
>     These versions are for userspace's benefit (be it lvm2, cryptsetup,
>     multipath-tools, etc).=C2=A0 But yes, these versions are bogus even=
 for
>     that -- primarily because it requires userspace to know when a
>     particular feature/fix it cares about was introduced.=C2=A0 In addi=
tion: if
>     fixes, that also bump version, are marked for stable@ then we're qu=
ickly
>     in versioning hell -- which is why I always try to decouple version
>     bumps from fixes.
>=20
>=20
> Yeah, I think the drm people used to have a version number too, and it'=
s not=20
> just fixes getting backported to stable - it's distro kernels taking ch=
anges=20
> for new hardware without taking other parts etc.
>=20
> So the versioning ends up not ever working reliably anyway - the same w=
ay that=20
> you can't use the kernel version number to determine what system calls =
are=20
> available.
>=20
> So versions can not ever be anything more than informational, and it's =
usually=20
> just very confusing to have multiple different version numbers (ie "I'm=
=20
> running kernel v5.4, and my driver abc version is 1.4.2a" is *not* in t=
he=20
> least helpful).
>=20
>     Others have suggested setting feature flags.=C2=A0 I expect you'd h=
ate those
>     too.=C2=A0 I suspect I quickly would too given flag bits are finite=
 and
>     really tedious to deal with.
>=20
>=20
> It also leads to some people then thinking it's ok to remove features (=
perhaps=20
> to reimplement them differently) if they only clear the feature bit.
>=20
> And no, it's not how kernel interfaces work. We keep the interfaces eve=
n if=20
> the internals change.
>=20
> So I've been suggesting that people just freeze the version, or remove =
the=20
> interface entirely is possible.
>=20
> Because otherwise it's just a source of problems, where user space migh=
t=20
> refuse to do something that the kernel supports because of some silly v=
ersion=20
> check...

Hi

POV of lvm2 developer - there are 2 things to solve - 1st. is the introdu=
ction=20
of a new 'features'. The 2nd. is usability/stability of certain version o=
f dm=20
targets - so when we later discover some combination of device stack are =
not=20
safe to use (can lead to significant lose of user's data) lvm2 adds check=
 for=20
this.

The reason for complexity comes from fact - numerous distribution use ver=
sion
of kernel X.Y.Z while they can have much new DM target version as it's mu=
ch=20
more simple to backport new DM into older version.

Nothing is clearly 'perfect', there is no ideal solution to cover all=20
combination of all kernel backports - but current separate versioning str=
eam
of DM targets added to kernel versioning, which i.e. lvm2 also is trackin=
g,=20
adds more hints for safe decision (as the safety of user's data is the mo=
st=20
important here)  and allows various distributions to 'somehow reasonably'=
=20
handle backporting of bugfixes.

So if there would be 'feature flag' list provided by DM target - there st=
ill=20
should be visible which version of implemented flag is that - as when the=
 new=20
feature is added - it's not always 'perfect' - sometimes we discover q bu=
g=20
quite late in the process of new feature introduction - so the plain fact=
=20
'featureXYZ' is present unfortunately doesn't always mean it's usable.
Sometimes even 'fixing' one bug may introduce a new problem we discover a=
gain=20
later (testing combinations of device stacks is really madness of its own=
...)


Zdenek
