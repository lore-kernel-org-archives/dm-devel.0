From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Fri, 13 Jul 2012 11:27:17 +1000
Message-ID: <20120713112717.3b15647c@notabene.brown>
References: <1342057001.22214.6.camel@f16>
	<20120712162205.GA13485@www5.open-std.org>
	<331FD2B6-AD96-4513-AF37-4E1B9EE7A34F@redhat.com>
	<20120713011505.GA3099@www5.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/x1u9VTXBkgrjFq0Wrb2dbd8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120713011505.GA3099@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Brassow Jonathan <jbrassow@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/x1u9VTXBkgrjFq0Wrb2dbd8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2012 03:15:05 +0200 keld@keldix.com wrote:

> I think the layout you described should not be promoted at all,
> and only kept for backward compatibility. As there is no backward=20
> compatibility in your case I think it is an error to implement it.
> I understand that you do not reuse any of the MD code here?

Not correct.  The whole point of this exercise is to reuse md code.


> The flaw is worse than Neil described, as far as I understand.
> With n=3D2 you can in the current implementation only have 1 disk failing,
> for any numbers of drives in the array. With the suggested layout
> then for 4 drives you have the probability of surviving 66 %=20
> of 2 drives failing. This get even better for 6, 8 .. disks in the array.
> And you may even survive 3 or more disk failures, dependent on the number
> of drives employed. The probability is the same as  for raid-1+0

Also not correct.  You can certainly have more than one failed device
providing you don't have 'n' adjacent devices all failed.
So e.g. if you have 2 drives in a far-2 layout then you can survive the
failure of three devices if they are 0,2,4 or 1,3,5.


>=20
> > When it is available to MD, I'll make it available to dm-raid also.
>=20
> Please dont implement it in the flawed  way. It will just create a number=
 of problems
> for when to switch over and convert between the two formats, and then whi=
ch should
> be the default (I fear some would say the old flawed should be the defaul=
t), and we need
> to explain the two formats and implement two sets of repairs and so on.

This "flawed" arrangement is the only one that makes sense for an odd number
of devices (assuming 2 copies).

NeilBrown

--Sig_/x1u9VTXBkgrjFq0Wrb2dbd8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/95dTnsnt1WYoG5AQIgrRAAwMpvHtWG22m3rONhyoAnYwFXP1iXe+Pt
WBsLXoZIPfqz8MrXlrpmQyKgjv5zarU3G9E1jmjD4k+ubKEUMRW+1ftFv4xIGTWZ
rdPgAPyRotV9vVj2JczsU/mr7KA+S0k/e10/4OiZ2WMEn2RP6V2Ismdjv64LPrwj
NEiUl+XkpgyJfRojVzBlPZJAlk+mPWXBa9W9dREEJq3LfZ9nYP6+dSKU9XzxFNmC
bXdb+mVCEEqDIGqGyR+wBAdvs6cgllN/Oy3GNkYjcTW6DM7PHK+e6rT0KYPexubV
vrB2GF2W5iXMyoqaFz/lxC7s4DxVzLLRkE0Srf2Rm9BWEwnPyDYr+tco4hbreG+U
NqynORDkec+tEi9kQj3s6HuMb8JpN/2jWNgmZ5v8cVJ3/D7AwNKHvtCUUX6AFKqv
tiHndL4/f6rkc/ORKUNf7RxLTa+Norhe113W2/GFivhOK1RNX7VMJENBqtgPXSVY
xZKNIG+CwpQgonwqr5a4GLdErAGKkERIoinVV6KU3vbRmfJLubT2OwesA5MAl8NU
wzAmPHhSNr24t8G3MImt4YSWgC32QuMpD0uKoMsAu7R5GvXBdNBW6XMMArPbfQyx
/OODtrl+iiAPwN03k2PgFwBSqpYzsGVRQBRNh4HbTFcLb91MvKLb9vFZ6tSeMYbU
OFiAz+cHbZ0=
=TRGZ
-----END PGP SIGNATURE-----

--Sig_/x1u9VTXBkgrjFq0Wrb2dbd8--
