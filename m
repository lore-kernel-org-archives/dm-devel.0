From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] DM RAID: Add support for MD RAID10
Date: Thu, 12 Jul 2012 16:32:07 +1000
Message-ID: <20120712163207.222b4bcc@notabene.brown>
References: <1342057001.22214.6.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qa2JBRqoXmBLxj_a+=ve78O"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1342057001.22214.6.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/Qa2JBRqoXmBLxj_a+=ve78O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2012 20:36:41 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've changed the tunables to the way we discussed.  If it becomes
> necessary to have the freedom to have simultaneous near and far copies,
> then I will likely add 'raid10_near|far|offset_copies' to compliment the
> existing 'raid10_copies' arg.  Like you, I doubt they will be necessary
> though.
>=20
> I have yet to add the code that allows new devices to replace old/failed
> devices (i.e. handles the 'rebuild' parameter).  That will be a future
> patch.
>=20
>  brassow

Looks good, though a couple of comments below.

Alasdair: I guess we should make sure we are in agreement about how patches
to dm-raid.c are funnelled through.  So far both you and I have feed them to
Linus, which doesn't seem to have caused any problems yet.  Are you OK with
us continuing like that, would you rather all dm-raid.c patched went through
you?
I'm happy either way.

> @@ -76,6 +80,7 @@ static struct raid_type {
>  	const unsigned algorithm;	/* RAID algorithm. */
>  } raid_types[] =3D {
>  	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
> +	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, -1 /* Varies =
*/},
>  	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY=
_0},
>  	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMME=
TRIC},
>  	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMM=
ETRIC},

Initialising the "unsigned" algorithm to "-1" looks like it is asking for
trouble.

> @@ -493,7 +554,7 @@ static int parse_raid_params(struct raid
>  			 */
>  			value /=3D 2;
> =20
> -			if (rs->raid_type->level < 5) {
> +			if (rs->raid_type->level !=3D 5) {
>  				rs->ti->error =3D "Inappropriate argument: stripe_cache";
>  				return -EINVAL;
>  			}

This leaves RAID6 out in the cold.  Maybe
  level < 5 || level > 6
or      !=3D5          !=3D6
or a switch statement?


> @@ -536,9 +605,25 @@ static int parse_raid_params(struct raid
>  	if (dm_set_target_max_io_len(rs->ti, max_io_len))
>  		return -EINVAL;
> =20
> -	if ((rs->raid_type->level > 1) &&
> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->par=
ity_devs))) {
> +	if (rs->raid_type->level =3D=3D 10) {
> +		/* (Len * Stripes) / Mirrors */
> +		sectors_per_dev *=3D rs->md.raid_disks;
> +		if (sector_div(sectors_per_dev, raid10_copies)) {
> +			rs->ti->error =3D "Target length not divisible by number of data devi=
ces";
> +			return -EINVAL;
> +		}

I'm not entirely sure what you are trying to do here, but I don't think it
works.

At the very least you would need to convert the "sectors_per_dev" number to=
 a
'chunks_per_dev' before multiplying by raid_disks and dividing by copies.

But even that isn't necessary.  If you have a 3-device near=3D2 array with =
an
odd number of chunks per device, that will still work.  The last chunk won't
be mirrored, so won't be used.
Until a couple of weeks ago a recovery of the last device would trigger an
error when we try to recover that last chunk, but that is fixed now.

So if you want to impose this limitation (and there is some merit in making
sure people don't confuse themselves), I suggest it get imposed in the
user-space tools which create the RAID10.


Otherwise it looks good.

Thanks,
NeilBrown

--Sig_/Qa2JBRqoXmBLxj_a+=ve78O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/5vZznsnt1WYoG5AQL6PhAAqHQCaCQL63UGaUfA2h/865N/BMloH/+Y
rPk6cUMCat68PVT89R2oGMCwOxazeEd7/dmw3GEai4H+kY69Sl1vT6B2Q2Ti3O3T
l1krrSo1VggqUXSybA4Gya3oECQdt+h0iI5pgQyr3r9fF/awiH4wHABHKDRtxc5w
U+A/i8MHIupKdjU/yw283A7/Wr/baJb1IhnJOCpAS2rXcBhubkgKby68wsTcsbo+
X4owVyoGKobzFECZSL5YtSznTtBcgwn3rkwu+WeR8jTuEsEW1+iWXqrV3jvPZmld
KNFQYRMXYOX3B1BRlPqxP5ffHSiASPeLbqbsmIVeZHKOMsqJbcV9xcshqc5l1IWj
dFUFFN/Rh7pUc+foEpCaB1RSyFsPrgNnfFOBi+LeZ1Nk04QTbIqx0OlprGtC4rUi
MqdgqqCbhVrvJyvd/BRXkJ2hr1X1dMiKcQaCa7ehBujK03F+N7MMK7Zw2zeq1t2K
sCPgUIdUPtQ0xDa6qg8rY9/MBFAvHveoYcos8t/BAAWiWRDvCN7BDLx37djpezaa
UO0GKoDuJzZqjk5oOBLlIy6A/KdKxrMy2kr3wG+N9R59Sj4esH0lkShCnE9udvlf
AJxq3/JW3DMw36cXvrUp30q4r9LNFQjV8mvXiplzcud7InAaknE9AYrz+Ph7C+O+
/3Z2Z9e1umM=
=xsWq
-----END PGP SIGNATURE-----

--Sig_/Qa2JBRqoXmBLxj_a+=ve78O--
