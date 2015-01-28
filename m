From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: fix raid5 livelock
Date: Wed, 28 Jan 2015 13:37:54 +1100
Message-ID: <20150128133754.25835582@notabene.brown>
References: <54C54CBC.50101@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Q4lOFZbiEoapi=0S_S7l+Z9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54C54CBC.50101@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: "dm-devel >> device-mapper development" <dm-devel@redhat.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

--Sig_/Q4lOFZbiEoapi=0S_S7l+Z9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Jan 2015 21:06:20 +0100 Heinz Mauelshagen <heinzm@redhat.com>
wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
>=20
> Hi Neil,
>=20
> the reconstruct write optimization in raid5, function fetch_block causes
> livelocks in LVM raid4/5 tests.
>=20
> Test scenarios:
> the tests wait for full initial array resynchronization before making a=20
> filesystem
> on the raid4/5 logical volume, mounting it, writing to the filesystem=20
> and failing
> one physical volume holding a raiddev.
>=20
> In short, we're seeing livelocks on fully synchronized raid4/5 arrays=20
> with a failed device.
>=20
> This patch fixes the issue but likely in a suboptimnal way.
>=20
> Do you think there is a better solution to avoid livelocks on=20
> reconstruct writes?
>=20
> Regards,
> Heinz
>=20
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> Tested-by: Jon Brassow <jbrassow@redhat.com>
> Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
>=20
> ---
>   drivers/md/raid5.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c1b0d52..0fc8737 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2915,7 +2915,7 @@ static int fetch_block(struct stripe_head *sh,=20
> struct stripe_head_state *s,
>               (s->failed >=3D 1 && fdev[0]->toread) ||
>               (s->failed >=3D 2 && fdev[1]->toread) ||
>               (sh->raid_conf->level <=3D 5 && s->failed && fdev[0]->towri=
te &&
> -             (!test_bit(R5_Insync, &dev->flags) ||=20
> test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) &&
> +             (!test_bit(R5_Insync, &dev->flags) ||=20
> test_bit(STRIPE_PREREAD_ACTIVE, &sh->state) || s->non_overwrite) &&
>                !test_bit(R5_OVERWRITE, &fdev[0]->flags)) ||
>               ((sh->raid_conf->level =3D=3D 6 ||
>                 sh->sector >=3D sh->raid_conf->mddev->recovery_cp)


That is a bit heavy handed, but knowing that fixes the problem helps a lot.

I think the problem happens when processes a non-overwrite write to a failed
device.

fetch_block() should, in that case, pre-read all of the working device, but
since

	      (!test_bit(R5_Insync, &dev->flags) || test_bit(STRIPE_PREREAD_ACTIVE=
, &sh->state)) &&

was added, it sometimes doesn't.  The root problem is that
handle_stripe_dirtying is getting confused because neither rmw or rcw seem =
to
work, so it doesn't start the chain of events to set STRIPE_PREREAD_ACTIVE.

The following (which is against mainline) might fix it.  Can you test?

Thanks,
NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c1b0d52bfcb0..793cf2861e97 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3195,6 +3195,10 @@ static void handle_stripe_dirtying(struct r5conf *co=
nf,
 					  (unsigned long long)sh->sector,
 					  rcw, qread, test_bit(STRIPE_DELAYED, &sh->state));
 	}
+	if (rcw > disks && rmw > disks &&
+	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		set_bit(STRIPE_DELAYED, &sh->state);
+
 	/* now if nothing is locked, and if we have enough data,
 	 * we can start a write request
 	 */


This code really really needs to be tidied up and commented better!!!

Thanks,
NeilBrown


--Sig_/Q4lOFZbiEoapi=0S_S7l+Z9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVMhLgjnsnt1WYoG5AQLrcRAAw3RVsZEzzgG96sPB/5WXRPV0rk87WPt7
JMPy0ikMgSgei6OsduFM5i/Ynubh0btdpF6IEf6AC9NKQ88w4QHuosEmJk+JkJnt
lozu7WZwT1K+u3eFXTzKhjp1l8OLZFjU9pf+ZNRnjLZsjgAUiycY8wuehW+xY1nb
cco/KKECODpd8b0aIZ+nqy0ayqp46t0KRP30tU/E7xJMLn9w005J+MT4S8UXsx/l
A5O7h/Srj4xTpym+qq27DmZ5Bdolth2xWXVWmsr7/gebVKJelUZ0whTZQJH4gQ3P
X8Pd82pPxaW0qNBYC8XZJ+ek6T7TckEaHRYgkeQiNDpXWuPTFOpqc1Pigse1+ESS
GHoyLmldZ/u7rulnJZ0VWKyrNLXWpQb2AGZfHX0R7Vu/eVN3mVq3UiqOte/1G7kk
6wpfmCZStuh7UvY8bucMZly+Aybla41Ufjo8slXnnXKPUTyR+O841CF8eeriqJ2C
7WZxNKGcyJG4XFFcZVVtHhWltGx/TAMf3qfpEHzsszkr63wJ+wQOEavgeTJtUieF
A2Hwj9k55x6RyURtl4y7YIJj6tvv93X30ehEV/2l9nTtrnZJSR+HKjKIPp9L+aSY
KpMga8PcM+ji3sw/iJYJt9zY1kxwzsIDLBMN7lYNtlZy6htkdGwVyu01Fiu+AzdA
b5GY3wBZYFc=
=B4pW
-----END PGP SIGNATURE-----

--Sig_/Q4lOFZbiEoapi=0S_S7l+Z9--
