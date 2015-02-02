From: NeilBrown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH] md: fix raid5 livelock
Date: Mon, 2 Feb 2015 11:06:29 +1100
Message-ID: <20150202110629.6ead82eb@notabene.brown>
References: <54C54CBC.50101@redhat.com>
	<20150128133754.25835582@notabene.brown>
	<54C8CFF8.6000807@redhat.com>
	<54CA1850.1000909@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/e3y646A7HkUsygQ1hgOnD4f"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54CA1850.1000909@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, Brassow Jonathan <jbrassow@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Marian Csontos <mcsontos@redhat.com>
List-Id: dm-devel.ids

--Sig_/e3y646A7HkUsygQ1hgOnD4f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Jan 2015 12:24:00 +0100 Heinz Mauelshagen <heinzm@redhat.com>
wrote:

>=20
> Neil,
>=20
> the patch worked fine in overnight test runs without the previous liveloc=
k.
> No regressions have been triggered.
>=20
> Yes, tidying up that optimization logic (e.g. in fetch_block()) is very=20
> much appreciated :-)
>=20

Thanks!
The following is what should appear in -next soonish.  If there are any *-b=
y:
tags to be added or changed, please let me know.

NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Mon, 2 Feb 2015 10:44:29 +1100
Subject: [PATCH] md/raid5: fix another livelock caused by non-aligned write=
s.

If a non-page-aligned write is destined for a device which
is missing/faulty, we can deadlock.

As the target device is missing, a read-modify-write cycle
is not possible.
As the write is not for a full-page, a recontruct-write cycle
is not possible.

This should be handled by logic in fetch_block() which notices
there is a non-R5_OVERWRITE write to a missing device, and so
loads all blocks.

However since commit 67f455486d2ea2, that code requires
STRIPE_PREREAD_ACTIVE before it will active, and those circumstances
never set STRIPE_PREREAD_ACTIVE.

So: in handle_stripe_dirtying, if neither rmw or rcw was possible,
set STRIPE_DELAYED, which will cause STRIPE_PREREAD_ACTIVE be set
after a suitable delay.

Fixes: 67f455486d2ea20b2d94d6adf5b9b783d079e321
Cc: stable@vger.kernel.org (v3.16+)
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 41494d904859..274db1834d43 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3192,6 +3192,11 @@ static void handle_stripe_dirtying(struct r5conf *co=
nf,
 					  (unsigned long long)sh->sector,
 					  rcw, qread, test_bit(STRIPE_DELAYED, &sh->state));
 	}
+
+	if (rcw > disks && rmw > disks &&
+	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+		set_bit(STRIPE_DELAYED, &sh->state);
+
 	/* now if nothing is locked, and if we have enough data,
 	 * we can start a write request
 	 */

--Sig_/e3y646A7HkUsygQ1hgOnD4f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM6/hTnsnt1WYoG5AQIsQA/+IMRCxtS4UrNfKjLRd2dvtueKlkfVWgvH
n2w268cUukJdtyw5iadQfJfJ3uWcjRgOEOAZ21jASoRWGB+nRGpW3t+seNj8owfN
2OHlUHUssAGJpe23ERxDuNbYtUSb9xlnuO5sHYBzVU2MCmYiFKh/fO1NIEl+DQmt
zvbOQdoR9VyFwwBY/jQNltwmrS1J/1beFNuKAcSqfp9P/yGc82drCXELBwXWhwaS
qQywBsjU/9nuBdsSIvw77iWue0r9hge6pJVgX3+zUchb6ANQJVUdxwtIrzR5zIKx
VykmReQmOTvWr/4TN4gXk61103tfVDy0Wjr9JbmrZC4nndyTEZSh4NjBpOfNTHqg
Cdq4MyTeZvH8fhkKi9jngDWbb83LgKDu9WNd3fDOw0mPQuZ087QwENsdCPKStdcO
RnWFwMpMoA2DDv5QBGNVbfAKldGLpcCSFRFkMsGSct0NtYIYd/VABmz+j/SHa4s3
Zfl9REhsNk9iSXQ2vOR+qnxNIqEud26i2mR33vX9rk8TManQ92bZo+C7f9/IirmV
nyYPFmBbh146S4H8mvTNVsf7P5cumY/vKBcnfSGx9F/iK9NrTwel7dVwqennMSJk
0kgoEtB6UGeo1Zkjewgd24xWV3iUuYVOzw8W5DPLjJ+LNivSHcNXcCNLIYr2Clw0
J4usENdfhFA=
=LoN0
-----END PGP SIGNATURE-----

--Sig_/e3y646A7HkUsygQ1hgOnD4f--
