From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Thu, 12 Jul 2012 21:43:36 +1000
Message-ID: <20120712214336.54fa2ade@notabene.brown>
References: <1342057001.22214.6.camel@f16>
	<20120712163207.222b4bcc@notabene.brown>
	<20120712095624.GD2095@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8CRqObGwOzJYm46bfSY6E69"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120712095624.GD2095@agk-dp.fab.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

--Sig_/8CRqObGwOzJYm46bfSY6E69
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jul 2012 10:56:24 +0100 Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Jul 12, 2012 at 04:32:07PM +1000, Neil Brown wrote:
> > Alasdair: I guess we should make sure we are in agreement about how pat=
ches
> > to dm-raid.c are funnelled through.  So far both you and I have feed th=
em to
> > Linus, which doesn't seem to have caused any problems yet. =20
>=20
> Just take it case-by-case as has been happening.
> Roughly speaking, when changes are driven from the md side, you take the
> coupled patches to the dm files too; when the changes are driven from the=
 dm
> side, I'll take them.

Sounds good - thanks.

NeilBrown

--Sig_/8CRqObGwOzJYm46bfSY6E69
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/64aDnsnt1WYoG5AQJ/tA/9GnZgoKLrxiuLY7KskZbck3l3+YdexuDC
CbH9Z7b3HMvpy6wcnvMXWwtkhKVioyfcit5fK0rFkGfFlWzRvx2QNjr+GJvtQunm
nS4PznKqbGppkWifPtxn21++Z73SA1AQSdE+0fYzpOyAUfzjYn3KXicAun85ebcy
PhjfMm9iJDvMb29bSsdwkbQrqAyWoszF6Qza7HOR1JFJpoAzkvJgxymxnSRunYRW
MsZIN7Ti5O9j/cxD56Td5fuFYQLZ11NVku2KgkxApbzbcG2qB/5nOT55nweibIUA
bSsVwx3MfNOcyKUrJR5ql8/f/0SSzuEKTvWsF+KuIpmXmvXLsN4/SYO2ZcJx/xsI
AYmLwjWA+LS3PIo47RUvhOnzOUABs97Yo2MAYxigxV2v63O368uTWSXn56W3QnF7
b03VqdYq+uSG425isbi278P2uJiIVKha0c+3Ppx2PRo0zqcDFyGhzYZxGANqND4C
f+FQw80vwbvzurS3pz4KavnI1LnLbHTBXtYzVeh47YkJj+JashvTdGPXX+jbUNTS
mrFtG0cOhUhN13f8b0AG6TWwayGMBn0el67g9aiYNAsdOIOF79o7vHZPCFx2qNFs
COSux2nCnSJ+a0A9MpI3ofV9aqs/YNr+7iQidtSu19g2hISm3azhIIH1GGfJ0w9n
wte7dLmh+pA=
=Lqx/
-----END PGP SIGNATURE-----

--Sig_/8CRqObGwOzJYm46bfSY6E69--
