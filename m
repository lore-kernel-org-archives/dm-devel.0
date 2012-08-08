From: Wesley Miaw <wmiaw@netflix.com>
Subject: Re: [dm-devel] [PATCH] dm: verity support data device offset (Linux
 3.4.7)
Date: Wed, 8 Aug 2012 21:53:40 +0000
Message-ID: <ED328367-4878-406E-9E2A-86397F208A1B@netflix.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com>
 <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
 <5022CC99.30103@redhat.com>
 <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
 <5022D29B.9000402@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="Apple-Mail=_A00A6A6E-7090-45DD-A471-55D807879059";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5022D29B.9000402@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?Windows-1252?Q?Will_Drewry=99?= <w@google.com>
List-Id: dm-devel.ids

--Apple-Mail=_A00A6A6E-7090-45DD-A471-55D807879059
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Aug 8, 2012, at 1:56 PM, Milan Broz wrote:

> On 08/08/2012 10:46 PM, Wesley Miaw wrote:
>=20
>> I did modify veritysetup on my own so the format and verify commands =
will work with regular files on disk instead of having to mount through =
loop devices.
>=20
> Which veritysetup? In upstream (cryptsetup repository) it allocates =
loop automatically.
> (And for userspace verification it doesn't need loop at all.)
>=20
> Anyway, please send a patch for userspace as well then ;-)

I grabbed cryptsetup from http://code.google.com/p/cryptsetup as what I =
read said that is the most recent. And then modified the code in there =
because the final block device images need to combine the file system, =
hash data, and some metadata into a single image and I don't want my =
users to need root privileges.

I can send a separate patch of those changes, but I'm not sure to where? =
Also to the LKML?

Thanks,
--
Wesley Miaw=

--Apple-Mail=_A00A6A6E-7090-45DD-A471-55D807879059
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQEcBAEBAgAGBQJQIt/kAAoJELoPFVk1ivvRhHsH/2Q2cqCuCrhsK076Hl4y/hXY
bpT11dyK42LX7l6s/GhbCVA0Lw5WZ3wIJtK3uO1RPnfJOd9H4MupNjISxOP6EUWF
Bcnu4P+xMt3eobMECHpuhAMXez8h1Qq0TyM9sVKnfvXu7GNSeGmHUJKkGU6G7wH3
Dj2WRuUuUW/FwzdXWcc6JEnj7md3tPlZEVEtIgFwI0V15ib9QiGV2YRD0SZIHE6M
Klvh6MYeieQBpO3xm/yzVYM7C58lriIWCjw1OMqTuZQx1GrwZUpRX1gpUmWzrM/E
Rnz81bWEpCVb4WVU6zAAt/vFbLBJOk95B0x+zWglNvHtuG/9P7oZ76YkpU860Gc=
=th2f
-----END PGP SIGNATURE-----

--Apple-Mail=_A00A6A6E-7090-45DD-A471-55D807879059--
