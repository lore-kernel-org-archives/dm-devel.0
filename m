From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0 of 4] dm-raid: various bug fixes
Date: Wed, 18 Apr 2012 13:48:43 +1000
Message-ID: <20120418134843.1376cc7e@notabene.brown>
References: <1334716219.23908.14.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/amtOfTWH3R0LWkopUUNHGCM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334716219.23908.14.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/amtOfTWH3R0LWkopUUNHGCM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Apr 2012 21:30:19 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've cleaned up the first two patches I sent earlier:
> 	[1 of 5] dm-raid-set-recovery-flags-on-resume.patch
> 	[2 of 5] dm-raid-record-and-handle-missing-devices.patch
> and added a couple more:
> 	[3 of 5] dm-raid-need-safe-version-of-rdev_for_each.patch
> 	[4 of 5] dm-raid-use-md_error-in-place-of-faulty-bit.patch
> 	[5 of 5] md-raid1-further-conditionalize-fullsync.patch
>=20
> Patch [5 of 5] I think needs some work.  It fixes the problem I'm seeing
> and seems to go along with similar logic used for RAID5 in commit
> d6b212f4b19da5301e6b6eca562e5c7a2a6e8c8d.  It also seems like a workable
> solution based on the code surrounding commit
> d30519fc59c5cc2f7772fa67b16b1a2426d36c95.  Can you let me know if I'm
> stretching the usage of 'saved_raid_disk' too far?
>=20
> Thanks,
>  brassow

Thanks.

3-of-5 should go in 3.4 presumably.  The rest wait for 3.5?  Or do you think
they should be in 3.4?

5-of-5:  Maybe it would make sense just to check if saved_raid_disk >=3D 0 =
??

This is only relevant for dm-raid isn't it?  I'd need to think through how
all that fits together again.

The rest are all fine and are in my for-next

Thanks,
NeilBrown

--Sig_/amtOfTWH3R0LWkopUUNHGCM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT445mznsnt1WYoG5AQLmag/9ErW0+difqCGQdh5o+sGSMOcBhfaTDhN1
YLHF/DJBJbe/68ADCWdt8F3I8d/zKyUCfbs8wO7bUvhDZ4GOdh/yt0kwvqCa/3Xw
c++5vwWBS8DmmuK+4X2EtD4FKN0X9IOjLT14CcVeRXvp/IS+AvwlLOUS1Bui5K4Y
O4exNrZFCN+3m5BSf7n348NOP05dkRfqzDBVuqjRj46rOgEge6bDBtVLb0x2sLw8
R+iEi73ZghEweXiYwIGCiGhbR52gNUE1mv5swQbKcO/hXK8SY3TquCu0UvtLCcTR
Lz0r7qk7vr2ni9ts0aoZ+BSUBYFu5KiC39Y6NfORBAsjBKQY7K+d0qIwdkeOn7iY
Ref47IczrOg8ACZqKAPonZmokMvpsI4lq3bBS6SNQ9MmrOLNyA8dE/b/fY1qbJPF
dKbk1OP7YMdhaAy4B/leNY5xQojytvzlOd934F6jr4yOkPyKitAMSIionynC97Ls
my9q9Yb4Ip4Q3wrSWQXW2cqlZNI4Kkif5KkTN2HiQ8MgKwQQyfYC5y10zag7ggED
VdfF9jcjberDeVh8OTlr7IrYEyIAyZf/wuD5OvP9Hb6NlUT86GDAk4z78OYRNh77
eouFkPB6Joihd+XyJEbWlvvboilEq8vB2WTPViiFMIE9/FJsuIOmaST8cNxJwXN2
fN/5JJgT7wk=
=fIaS
-----END PGP SIGNATURE-----

--Sig_/amtOfTWH3R0LWkopUUNHGCM--
