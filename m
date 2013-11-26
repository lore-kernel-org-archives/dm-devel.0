From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] MD/DM RAID: Fix hang due to recent RAID5 locking
 changes
Date: Tue, 26 Nov 2013 16:27:46 +1100
Message-ID: <20131126162746.4d42ef1d@notabene.brown>
References: <1385335843-14021-1-git-send-email-jbrassow@redhat.com>
	<1385335843-14021-2-git-send-email-jbrassow@redhat.com>
	<20131125110315.262223cf@notabene.brown>
	<D89A7889-9B7B-40F1-AD7D-08937D168C7E@redhat.com>
	<30A220BB-6E93-44C9-A487-F23DBF546ED6@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CmjlCD+HuKB.8Y=GjsWm.Qo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30A220BB-6E93-44C9-A487-F23DBF546ED6@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--Sig_/CmjlCD+HuKB.8Y=GjsWm.Qo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Nov 2013 13:08:56 -0600 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Nov 25, 2013, at 8:20 AM, Brassow Jonathan wrote:
>=20
> >=20
> > On Nov 24, 2013, at 6:03 PM, NeilBrown wrote:
> >=20
> >> On Sun, 24 Nov 2013 17:30:43 -0600 Jonathan Brassow <jbrassow@redhat.c=
om>
> >> wrote:
> >>=20
> >>> When commit 773ca82 was made in v3.12-rc1, it caused RAID4/5/6 devices
> >>> that were created via device-mapper (dm-raid.c) to hang on creation.
> >>> This is not necessarily the fault of that commit, but perhaps the way
> >>> dm-raid.c was setting-up and activating devices.
> >>>=20
> >>> Device-mapper allows I/O and memory allocations in the constructor
> >>> (i.e. raid_ctr()), but nominal and recovery I/O should not be allowed
> >>> until a 'resume' is issued (i.e. raid_resume()).  It has been problem=
atic
> >>> (at least in the past) to call mddev_resume before mddev_suspend was
> >>> called, but this is how DM behaves - CTR then resume.  To solve the
> >>> problem, raid_ctr() was setting up the structures, calling md_run(), =
and
> >>> then also calling mddev_suspend().  The stage was then set for raid_r=
esume()
> >>> to call mddev_resume().
> >>>=20
> >>> Commit 773ca82 caused a change in behavior during raid5.c:run().
> >>> 'setup_conf->grow_stripes->grow_one_stripe' is called which creates t=
he
> >>> stripe cache and increments 'active_stripes'.
> >>> 'grow_one_stripe->release_stripe' doesn't actually decrement 'active_=
stripes'
> >>> anymore.  The side effect of this is that when raid_ctr calls mddev_s=
uspend,
> >>> it waits for 'active_stripes' to reduce to 0 - which never happens.
> >>=20
> >> Hi Jon,
> >> this sounds like the same bug that is fixed by=20
> >>=20
> >> commit ad4068de49862b083ac2a15bc50689bb30ce3e44
> >> Author: majianpeng <majianpeng@gmail.com>
> >> Date:   Thu Nov 14 15:16:15 2013 +1100
> >>=20
> >>   raid5: Use slow_path to release stripe when mddev->thread is null
> >>=20
> >> which is already en-route to 3.12.x.  Could you check if it fixes the =
bug for
> >> you?
> >=20
> > Sure, I'll check.  Just reading the subject of the patch, I have high h=
opes.  The slow path decrements 'active_stripes', which was causing the abo=
ve problem...  I'll make sure though.
>=20
> Yes, this patch fixes the issue in 3.12-rc1+.
>=20
> However, there is still a problem I'm searching for that was introduced i=
n commit 566c09c (at least that's what I get when bisecting).
>=20
> The problem only shows up when I have taken a snapshot of a RAID5 device =
and only if I have cycled the device before adding the snapshot:
> 1> lvcreate --type raid5 -i 3 -L 20M -n lv vg
> 2> lvchange -an vg/lv
> 3> lvchange -ay vg/lv
> 4> lvcreate -s vg/lv -L 50M -n snap
> 5> lvchange -an vg/lv
> 6> lvchange -ay vg/lv -- BUG: line 292 of raid5.c
>=20
> The current bug triggers on the 'BUG_ON(atomic_read(&conf->active_stripes=
)=3D=3D0)' in do_release_stripe().  I'm not sure why yet.
>=20
>  brassow

I've had a look and I must say I'm not sure either.
I keep wondering if something is wrong with the locking in get_active_strip=
e.
The region covered by device_lock is not much smaller with the whole now
covered by hash_locks[hash].  I cannot see a problem with the locking but I
might be missing something.  A missing atomic_inc of active_stripes in there
could cause your problem.

As you can easily reproduce, could you try expanding the range covered by
device_lock to be the whole branch where sh is not NULL.  If that makes a
difference it would be quite instructive.  I don't hold high hopes though.

Thanks,
NeilBrown

--Sig_/CmjlCD+HuKB.8Y=GjsWm.Qo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpQxUjnsnt1WYoG5AQJrSA/9GP9G9WedgJ82SNqu3YwKWqJWVS9xukKc
JrLMRndtvruNPJ0UpxF0qjxEmLp/U+WKYycOYqMeVQESQpRTdnzmG+GjLe5rjWLk
wifGcBftAfTK732Ud9GMHha/dZYAheWmPMxS8qOV8m4QQ40Z0TOhXH3CbEKEAvDd
YBFn7FaG3z/b7AdAcKd2mSx9eGwRDAoyCjuJTfqQsx3YN3o5qtRLincLqySuq/om
rYpp6DRLcwZFHnh7DUxh+WiKYlp3H4j9WtWdma816A9pQekdYP2hW2Tq+42NR5PB
yAJpQ02jdQCLUZ7wb2P1XU/x959WgW0noLpnr52FXpJte9a6Yl85FxBTZokk37tJ
5zno4HuqaWslwnYToAzEpPulKreRX2X9vXow7iIOo5M9+6JneVU+jJWWRy2RBCVy
HO83/q/jC7Nr2UPmwIzX0UlrvTX5+0wG8jAEv3AuZ8olag/iRLhA9X7/qXbRfP6Q
leyj9QsCxv2JwK+3F3QyGJ5vs94CuoVg3jodsDFh9huB3fLopq0SkPu1wiAPmZvr
KnQW+E9PAdoHZXcjSc8IMePeXk5BNoQANgfAufu9guhu5cpqUm19Ktwk5ibFqdtF
+3DJgE8D73ZGiU6J9Lokq00YMusEWbN8b2vpzlAJEI0YY2/LkXJa07KZtdSOUWVR
i+9hvLQ5+9E=
=BY1D
-----END PGP SIGNATURE-----

--Sig_/CmjlCD+HuKB.8Y=GjsWm.Qo--
