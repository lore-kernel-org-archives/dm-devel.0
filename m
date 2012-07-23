From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4] DM RAID: Add support for MD RAID10
Date: Tue, 24 Jul 2012 08:26:11 +1000
Message-ID: <20120724082611.41a275d2@notabene.brown>
References: <1343072962.20599.2.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/49B1_T8/ah3to=FtgVqGLln"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1343072962.20599.2.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/49B1_T8/ah3to=FtgVqGLln
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jul 2012 14:49:22 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> Updated 'sectors_per_dev' calculation and integrated your other
> suggestions.

Mostly ...

>=20
>  brassow
>=20
> dm raid: add md raid10 support
>=20
> Support the MD RAID10 personality through dm-raid.c
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -11,6 +11,7 @@
>  #include "md.h"
>  #include "raid1.h"
>  #include "raid5.h"
> +#include "raid10.h"
>  #include "bitmap.h"
> =20
>  #include <linux/device-mapper.h>
> @@ -52,7 +53,10 @@ struct raid_dev {
>  #define DMPF_MAX_RECOVERY_RATE 0x20
>  #define DMPF_MAX_WRITE_BEHIND  0x40
>  #define DMPF_STRIPE_CACHE      0x80
> -#define DMPF_REGION_SIZE       0X100
> +#define DMPF_REGION_SIZE       0x100
> +#define DMPF_RAID10_COPIES     0x200
> +#define DMPF_RAID10_FORMAT     0x400
> +
>  struct raid_set {
>  	struct dm_target *ti;
> =20
> @@ -76,6 +80,7 @@ static struct raid_type {
>  	const unsigned algorithm;	/* RAID algorithm. */
>  } raid_types[] =3D {
>  	{"raid1",    "RAID1 (mirroring)",               0, 2, 1, 0 /* NONE */},
> +	{"raid10",   "RAID10 (striped mirrors)",        0, 2, 10, UINT_MAX /* V=
aries */},
>  	{"raid4",    "RAID4 (dedicated parity disk)",	1, 2, 5, ALGORITHM_PARITY=
_0},
>  	{"raid5_la", "RAID5 (left asymmetric)",		1, 2, 5, ALGORITHM_LEFT_ASYMME=
TRIC},
>  	{"raid5_ra", "RAID5 (right asymmetric)",	1, 2, 5, ALGORITHM_RIGHT_ASYMM=
ETRIC},
> @@ -86,6 +91,17 @@ static struct raid_type {
>  	{"raid6_nc", "RAID6 (N continue)",		2, 4, 6, ALGORITHM_ROTATING_N_CONTI=
NUE}
>  };
> =20
> +static unsigned raid10_md_layout_to_copies(int layout)
> +{
> +	return layout & 0xFF;
> +}
> +
> +static int raid10_format_to_md_layout(char *format, unsigned copies)
> +{
> +	/* 1 "far" copy, and 'copies' "near" copies */
> +	return (1 << 8) | (copies & 0xFF);
> +}
> +
>  static struct raid_type *get_raid_type(char *name)
>  {
>  	int i;
> @@ -339,10 +355,16 @@ static int validate_region_size(struct r
>   *    [max_write_behind <sectors>]	See '-write-behind=3D' (man mdadm)
>   *    [stripe_cache <sectors>]		Stripe cache size for higher RAIDs
>   *    [region_size <sectors>]           Defines granularity of bitmap
> + *
> + * RAID10-only options:
> + *    [raid10_copies <# copies>]        Number of copies.  (Default: 2)
> + *    [raid10_format <near>]            Layout algorithm.  (Default: nea=
r)
>   */
>  static int parse_raid_params(struct raid_set *rs, char **argv,
>  			     unsigned num_raid_params)
>  {
> +	char *raid10_format =3D "near";
> +	unsigned raid10_copies =3D 2;
>  	unsigned i, rebuild_cnt =3D 0;
>  	unsigned long value, region_size =3D 0;
>  	sector_t sectors_per_dev =3D rs->ti->len;
> @@ -416,11 +438,28 @@ static int parse_raid_params(struct raid
>  		}
> =20
>  		key =3D argv[i++];
> +
> +		/* Parameters that take a string value are checked here. */
> +		if (!strcasecmp(key, "raid10_format")) {
> +			if (rs->raid_type->level !=3D 10) {
> +				rs->ti->error =3D "'raid10_format' is an invalid parameter for this =
RAID type";
> +				return -EINVAL;
> +			}
> +			if (strcmp("near", argv[i])) {
> +				rs->ti->error =3D "Invalid 'raid10_format' value given";
> +				return -EINVAL;
> +			}
> +			raid10_format =3D argv[i];
> +			rs->print_flags |=3D DMPF_RAID10_FORMAT;
> +			continue;
> +		}
> +
>  		if (strict_strtoul(argv[i], 10, &value) < 0) {
>  			rs->ti->error =3D "Bad numerical argument given in raid params";
>  			return -EINVAL;
>  		}
> =20
> +		/* Parameters that take a numeric value are checked here */
>  		if (!strcasecmp(key, "rebuild")) {
>  			rebuild_cnt++;
>  			rs->ti->error =3D NULL;
> @@ -436,6 +475,7 @@ static int parse_raid_params(struct raid
>  				if (rebuild_cnt > rs->raid_type->parity_devs)
>  					rs->ti->error =3D "Too many rebuild devices specified for given RAI=
D type";
>  				break;
> +			case 10:
>  			default:
>  				DMERR("The rebuild parameter is not supported for %s", rs->raid_type=
->name);
>  				rs->ti->error =3D "Rebuild not supported for this RAID type";

This hunk doesn't apply for me, or against 3.5.  Is there some patch I'm
missing.
I do vaguely recall you changing this to a switch statement I think, but I
still have an if statement here.
If I'm missing a patch - could you resend it please?



>> @@ -536,8 +585,30 @@ static int parse_raid_params(struct raid
>  	if (dm_set_target_max_io_len(rs->ti, max_io_len))
>  		return -EINVAL;
> =20
> -	if ((rs->raid_type->level > 1) &&
> -	    sector_div(sectors_per_dev, (rs->md.raid_disks - rs->raid_type->par=
ity_devs))) {
> +	if (rs->raid_type->level =3D=3D 10) {
> +		if (raid10_copies > rs->md.raid_disks) {
> +			rs->ti->error =3D "Not enough devices to satisfy specification";
> +			return -EINVAL;
> +		}
> +
> +		/* (Len * #mirrors) / #devices */
> +		sectors_per_dev =3D rs->ti->len * raid10_copies;
> +		if (sector_div(sectors_per_dev, rs->md.raid_disks)) {
> +			rs->ti->error =3D "Target length not evenly divisible by number of st=
ripes";
> +			return -EINVAL;
> +		}

This test is still completely pointless, and putting an extra test for chunk
alignment after it doesn't make it any less pointless.=20
And putting an important division inside the condition of an if(), hides it=
 a
bit more than I like.
But it probably isn't worth arguing about it any more so once I can get a
patch to apply I'll take it.

Thanks,
NeilBrown


--Sig_/49B1_T8/ah3to=FtgVqGLln
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUA3Pgznsnt1WYoG5AQKRNQ//e5shuHsHVH2BjM4JTYNPuabU/8PhG5Ho
g7tRSjb0zBMtWCAmQO4RQba3uNsfShUE8ORb/vTOVKqtYq6XoRfK11QXLNQTagg8
vgkrlEWzuhPCMZue6rGaDjJKN2j8rtQChmoqhGaoyfl3DTH0X4cs3EHeu1hK9Q+m
gV/ABLLHqxdbr78+jHz4Aq9lKTXWbcYImMI5Kr8Pz/arRVKNj5I6B/dhcaHeQdNb
LWkgaLAQ4xijp76oOTY0B2jB4W7T5ewg9bibNR6UkeQ2Bzta7g5hmuUhfY+8LEmj
WCmGDsTqm6RgtdTXjhMNQE2kQhMPMSkSuQHrA863TsOjqoyjuo8sQ+YUT3jkECxE
UB/OI0CiNutWwOkqOKHwjaB7AK9Hc0DqktX+mbGyJxBGvleJq4wXjmf432RmsocO
DO3/AUZ35M+XGSz/muhnuRxceX10aRJ/vgpR+XhfGuRwkBTtAFEv/48f/nD2HMOs
HHLn1xLjdSXZ+Qi5RDAbtSqf9Jvax7QIFYPE8EK5An5c+SptGy8y0Y9rJQJ0qeqG
CIpfvCsd2vQgM+t+EScHYj23TUI9OLVfZzqeyVHwZkWrwhwTjgSeDlJ4HSuRA61j
fhgl36wyDbx/V6/oE9wWxuizeoVjpX7sUh5tuMJAjsoUAyWXXATXnb98G+gi5JB8
K2FAaSszQyQ=
=TWeE
-----END PGP SIGNATURE-----

--Sig_/49B1_T8/ah3to=FtgVqGLln--
