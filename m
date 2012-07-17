From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Tue, 17 Jul 2012 12:34:04 +1000
Message-ID: <20120717123404.3516b943@notabene.brown>
References: <1342057001.22214.6.camel@f16>
	<20120712163207.222b4bcc@notabene.brown>
	<544F2898-B9C7-42CD-A0FD-F1DE35C5E628@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p5XfmhI=lDLwaAj161Tf9wn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <544F2898-B9C7-42CD-A0FD-F1DE35C5E628@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/p5XfmhI=lDLwaAj161Tf9wn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 17:06:32 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jul 12, 2012, at 1:32 AM, NeilBrown wrote:
>=20
> >>=20
> >> @@ -76,6 +80,7 @@ static struct raid_type {
> >> 	const unsigned algorithm;	/* RAID algorithm. */
> >> } raid_types[] =3D {
> >> 	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */=
},
> >> +	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, -1 /* Vari=
es */},
> >> 	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARI=
TY_0},
> >> 	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYM=
METRIC},
> >> 	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASY=
MMETRIC},
> >=20
> > Initialising the "unsigned" algorithm to "-1" looks like it is asking f=
or
> > trouble.
>=20
> I'm initializing to -1 because I know it is a value that will fail if not=
 set later in the setup process.  I could just as easily choose the default=
 values (near =3D 2).

I don't much care what value you use as long as it is of the same type as t=
he
variable you assign it to.  So maybe UINT_MAX, or maybe '2'.


>=20
> >=20
> >> @@ -493,7 +554,7 @@ static int parse_raid_params(struct raid
> >> 			 */
> >> 			value /=3D 2;
> >>=20
> >> -			if (rs->raid_type->level < 5) {
> >> +			if (rs->raid_type->level !=3D 5) {
> >> 				rs->ti->error =3D "Inappropriate argument: stripe_cache";
> >> 				return -EINVAL;
> >> 			}
> >=20
> > This leaves RAID6 out in the cold.  Maybe
> >  level < 5 || level > 6
> > or      !=3D5          !=3D6
> > or a switch statement?
>=20
> Thanks.  For some reason I had thought that raid6 had level=3D5, like rai=
d4...  Fixed.

I love consistency ... or at least I think I would if only I could find it
somewhere!

>=20
>=20
>=20
> >> @@ -536,9 +605,25 @@ static int parse_raid_params(struct raid
> >> 	if (dm_set_target_max_io_len(rs->ti, max_io_len))
> >> 		return -EINVAL;
> >>=20
> >> -	if ((rs->raid_type->level > 1) &&
> >> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->=
parity_devs))) {
> >> +	if (rs->raid_type->level =3D=3D 10) {
> >> +		/* (Len * Stripes) / Mirrors */
> >> +		sectors_per_dev *=3D rs->md.raid_disks;
> >> +		if (sector_div(sectors_per_dev, raid10_copies)) {
> >> +			rs->ti->error =3D "Target length not divisible by number of data d=
evices";
> >> +			return -EINVAL;
> >> +		}
> >=20
> > I'm not entirely sure what you are trying to do here, but I don't think=
 it
> > works.
> >=20
> > At the very least you would need to convert the "sectors_per_dev" numbe=
r to a
> > 'chunks_per_dev' before multiplying by raid_disks and dividing by copie=
s.
> >=20
> > But even that isn't necessary.  If you have a 3-device near=3D2 array w=
ith an
> > odd number of chunks per device, that will still work.  The last chunk =
won't
> > be mirrored, so won't be used.
> > Until a couple of weeks ago a recovery of the last device would trigger=
 an
> > error when we try to recover that last chunk, but that is fixed now.
> >=20
> > So if you want to impose this limitation (and there is some merit in ma=
king
> > sure people don't confuse themselves), I suggest it get imposed in the
> > user-space tools which create the RAID10.
>=20
> I have seen what you do in calc_sectors(), I suppose I could bring that i=
n.  However, I'm simply trying to find the value that will be preliminarily=
 assigned to mddev->dev_sectors.  It is an enforced (perhaps unnecessary) c=
onstraint that the array length be divisible by the number of data devices.=
  I'm not accounting for chunk boundaries - I leave that to userspace to co=
nfigure and MD to catch.

In that case I suggest you keep it out of dmraid.

It might make sense to check that the resulting array size matches what
user-space said to expect - or is at-least-as-big-as.  However I don't see
much point in other size changes there.

Thanks,
NeilBrown


--Sig_/p5XfmhI=lDLwaAj161Tf9wn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUATPHTnsnt1WYoG5AQKNnw//Zk/7UQaHriM6vGUzkCpCeMGoMciqTy6c
thDCu43Lsh+4EurB+iT3oRr9ntxd5UetwjWLB3LBo6QxtJ6YzZN1l0Xz7ppqRoec
FeGAlZ7AHQ0I6qwti5B4t1DOqrV/lZj9Mq1boPBEtnuq4RhxIDy3L9L88VYZEuur
SlLpQzJfIs2bEHRcE9lQ24daRDrM8Z2899iIEE78MvdKA1MNJOXyW9tNdMedRTG9
3LGvkuKCLpTixl8YmxGQq+pBmW8oJwRWfSpntRYF0+5d0evuaT0t9+nfJLxWqWsN
yKd4ewmE1MZHCGnidTNXTwxm5rqNPrfUMGKCNzMVmBeKXdEplG6Zt/RkIhogOpw8
PplA6GWVTiwCXYl9GZ8CHmZ0Woi0h1dbJBFSFuswHPJcB8Rstm80hIPZaeDrf7Y8
bxKoe6h5Er13F6HuAWSHggAi+uKVDcMKfye7sBWXqHpt5FxVk6Ydf1WLe/FkJmB8
3unhZFTjaj8uGNymN25k3SpW5YhP7Jv1Y638LuLnrXL2xL1IJnRumPgzhFaCW1hT
+xVzcXfp3mEFxDQEW5oi3HXcJ8eaBPykvfTN8+Rdwt95AkxO9ixZ4GNGMqM99Krj
MU2ptQeTjvcQadICWBfz1bf8JXQST1zBONAensPJOraDk+cwmiTxB5vbZyk6cJ5E
d/OSbp6t4vY=
=3jLL
-----END PGP SIGNATURE-----

--Sig_/p5XfmhI=lDLwaAj161Tf9wn--
