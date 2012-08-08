From: Wesley Miaw <wmiaw@netflix.com>
Subject: Re: [dm-devel] [PATCH] dm: verity support data device offset (Linux
 3.4.7)
Date: Wed, 8 Aug 2012 20:46:46 +0000
Message-ID: <AD722D70-2E9C-4B2D-BE48-B94E2268C3DD@netflix.com>
References: <8893CF66-2E2C-4D8F-9239-E38BE55716AE@netflix.com>
 <Pine.LNX.4.64.1208081437550.16469@file.rdu.redhat.com>
 <5022CC99.30103@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="Apple-Mail=_BB6D1B9A-301B-46F7-BA19-4C8C058D4648";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5022CC99.30103@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, "msb@google.com" <msb@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?Windows-1252?Q?Will_Drewry=99?= <w@google.com>
List-Id: dm-devel.ids

--Apple-Mail=_BB6D1B9A-301B-46F7-BA19-4C8C058D4648
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Aug 8, 2012, at 1:31 PM, Milan Broz wrote:

> On 08/08/2012 08:46 PM, Mikulas Patocka wrote:
>=20
>> The problem with the patch is that it changes interface to the =
userspace=20
>> tool. The userspace tool veritysetup already exists in recent =
cryptsetup=20
>> package, so we can't change the interface - you should change the =
patch so=20
>> that the starting data block is the last argument and the argument is=20=

>> optional - so that it is compatible with the existing userspace too.
>=20
> yes. Please never change interface without at least increasing target =
version.
>=20
> I have to add userspace support as well to veritysetup and we need a =
way
> how to detect that option is supported by running kernel.


Understood. Thank you for the feedback. I will attempt a new patch =
version which addresses these issues. I also found that I did not =
correct the last-block boundary check so I will re-submit my patch with =
that as well.

I did modify veritysetup on my own so the format and verify commands =
will work with regular files on disk instead of having to mount through =
loop devices.
--
Wesley Miaw=

--Apple-Mail=_BB6D1B9A-301B-46F7-BA19-4C8C058D4648
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)

iQEcBAEBAgAGBQJQItA2AAoJELoPFVk1ivvRshUH/ig/0hogLn/utO1+ubjgW/Fd
oRt8iaYaAAz9i6ufv6gK50RCT21KGd+qB9/83wKEr0a8uXmTm14z18i6GZCV3FlR
1cT8/elEvBgWWCyd3X5zRewYS45fgs47Xw2PpkUG4BOwT5MFyj9R5sdsFKTpsnNr
P74QQ60GY3xIoFijNNJ+GRqQCzIo7Scd5i/1iv3sjJDF9ONCRmZezBU4FmqO1jNQ
qsoN4Az5GOLNmH+GJAX8D0pc7AqaFKO71Ad9JOjT8scWN8igoNH+dqyTJdStr4j7
fUw7r/yCM1d7S63eFsrKXolEeBMDr527tcbqtipdAcaCIHn/jlMaBS4QZoZvtsw=
=RPrr
-----END PGP SIGNATURE-----

--Apple-Mail=_BB6D1B9A-301B-46F7-BA19-4C8C058D4648--
