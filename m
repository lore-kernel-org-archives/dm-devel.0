From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: replace strict_strto*() with kstrto*()
Date: Tue, 4 Jun 2013 12:00:42 +1000
Message-ID: <20130604120042.4e0a697f@notabene.brown>
References: <000601ce5e97$c4870a20$4d951e60$@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/krKFON5C8=4qGCOJQSQNTjC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000601ce5e97$c4870a20$4d951e60$@samsung.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, 'Alasdair Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

--Sig_/krKFON5C8=4qGCOJQSQNTjC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 01 Jun 2013 16:15:16 +0900 Jingoo Han <jg1.han@samsung.com> wrote:

> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/md/bitmap.c  |    8 ++++----
>  drivers/md/dm-raid.c |    8 ++++----
>  drivers/md/md.c      |   16 ++++++++--------
>  drivers/md/raid5.c   |    4 ++--
>  4 files changed, 18 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 5a2c754..a7fd821 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -2002,9 +2002,9 @@ location_store(struct mddev *mddev, const char *buf=
, size_t len)
>  		} else {
>  			int rv;
>  			if (buf[0] =3D=3D '+')
> -				rv =3D strict_strtoll(buf+1, 10, &offset);
> +				rv =3D kstrtoll(buf+1, 10, &offset);
>  			else
> -				rv =3D strict_strtoll(buf, 10, &offset);
> +				rv =3D kstrtoll(buf, 10, &offset);
>  			if (rv)
>  				return rv;
>  			if (offset =3D=3D 0)
> @@ -2139,7 +2139,7 @@ static ssize_t
>  backlog_store(struct mddev *mddev, const char *buf, size_t len)
>  {
>  	unsigned long backlog;
> -	int rv =3D strict_strtoul(buf, 10, &backlog);
> +	int rv =3D kstrtoul(buf, 10, &backlog);
>  	if (rv)
>  		return rv;
>  	if (backlog > COUNTER_MAX)
> @@ -2165,7 +2165,7 @@ chunksize_store(struct mddev *mddev, const char *bu=
f, size_t len)
>  	unsigned long csize;
>  	if (mddev->bitmap)
>  		return -EBUSY;
> -	rv =3D strict_strtoul(buf, 10, &csize);
> +	rv =3D kstrtoul(buf, 10, &csize);
>  	if (rv)
>  		return rv;
>  	if (csize < 512 ||
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 0f5a6fb..21e8e46 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -504,7 +504,7 @@ static int parse_raid_params(struct raid_set *rs, cha=
r **argv,
>  	 * First, parse the in-order required arguments
>  	 * "chunk_size" is the only argument of this type.
>  	 */
> -	if ((strict_strtoul(argv[0], 10, &value) < 0)) {
> +	if ((kstrtoul(argv[0], 10, &value) < 0)) {
>  		rs->ti->error =3D "Bad chunk size";
>  		return -EINVAL;
>  	} else if (rs->raid_type->level =3D=3D 1) {
> @@ -585,7 +585,7 @@ static int parse_raid_params(struct raid_set *rs, cha=
r **argv,
>  			continue;
>  		}
> =20
> -		if (strict_strtoul(argv[i], 10, &value) < 0) {
> +		if (kstrtoul(argv[i], 10, &value) < 0) {
>  			rs->ti->error =3D "Bad numerical argument given in raid params";
>  			return -EINVAL;
>  		}
> @@ -1181,7 +1181,7 @@ static int raid_ctr(struct dm_target *ti, unsigned =
argc, char **argv)
>  	argv++;
> =20
>  	/* number of RAID parameters */
> -	if (strict_strtoul(argv[0], 10, &num_raid_params) < 0) {
> +	if (kstrtoul(argv[0], 10, &num_raid_params) < 0) {
>  		ti->error =3D "Cannot understand number of RAID parameters";
>  		return -EINVAL;
>  	}
> @@ -1194,7 +1194,7 @@ static int raid_ctr(struct dm_target *ti, unsigned =
argc, char **argv)
>  		return -EINVAL;
>  	}
> =20
> -	if ((strict_strtoul(argv[num_raid_params], 10, &num_raid_devs) < 0) ||
> +	if ((kstrtoul(argv[num_raid_params], 10, &num_raid_devs) < 0) ||
>  	    (num_raid_devs >=3D INT_MAX)) {
>  		ti->error =3D "Cannot understand number of raid devices";
>  		return -EINVAL;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0bbe710..76f5a8b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2870,7 +2870,7 @@ static ssize_t
>  offset_store(struct md_rdev *rdev, const char *buf, size_t len)
>  {
>  	unsigned long long offset;
> -	if (strict_strtoull(buf, 10, &offset) < 0)
> +	if (kstrtoull(buf, 10, &offset) < 0)
>  		return -EINVAL;
>  	if (rdev->mddev->pers && rdev->raid_disk >=3D 0)
>  		return -EBUSY;
> @@ -2898,7 +2898,7 @@ static ssize_t new_offset_store(struct md_rdev *rde=
v,
>  	unsigned long long new_offset;
>  	struct mddev *mddev =3D rdev->mddev;
> =20
> -	if (strict_strtoull(buf, 10, &new_offset) < 0)
> +	if (kstrtoull(buf, 10, &new_offset) < 0)
>  		return -EINVAL;
> =20
>  	if (mddev->sync_thread)
> @@ -2964,7 +2964,7 @@ static int strict_blocks_to_sectors(const char *buf=
, sector_t *sectors)
>  	unsigned long long blocks;
>  	sector_t new;
> =20
> -	if (strict_strtoull(buf, 10, &blocks) < 0)
> +	if (kstrtoull(buf, 10, &blocks) < 0)
>  		return -EINVAL;
> =20
>  	if (blocks & 1ULL << (8 * sizeof(blocks) - 1))
> @@ -3072,7 +3072,7 @@ static ssize_t recovery_start_store(struct md_rdev =
*rdev, const char *buf, size_
> =20
>  	if (cmd_match(buf, "none"))
>  		recovery_start =3D MaxSector;
> -	else if (strict_strtoull(buf, 10, &recovery_start))
> +	else if (kstrtoull(buf, 10, &recovery_start))
>  		return -EINVAL;
> =20
>  	if (rdev->mddev->pers &&
> @@ -3500,7 +3500,7 @@ level_store(struct mddev *mddev, const char *buf, s=
ize_t len)
>  	if (clevel[len-1] =3D=3D '\n')
>  		len--;
>  	clevel[len] =3D 0;
> -	if (strict_strtol(clevel, 10, &level))
> +	if (kstrtol(clevel, 10, &level))
>  		level =3D LEVEL_NONE;
> =20
>  	if (request_module("md-%s", clevel) !=3D 0)
> @@ -4359,7 +4359,7 @@ sync_force_parallel_store(struct mddev *mddev, cons=
t char *buf, size_t len)
>  {
>  	long n;
> =20
> -	if (strict_strtol(buf, 10, &n))
> +	if (kstrtol(buf, 10, &n))
>  		return -EINVAL;
> =20
>  	if (n !=3D 0 && n !=3D 1)
> @@ -4427,7 +4427,7 @@ static ssize_t
>  min_sync_store(struct mddev *mddev, const char *buf, size_t len)
>  {
>  	unsigned long long min;
> -	if (strict_strtoull(buf, 10, &min))
> +	if (kstrtoull(buf, 10, &min))
>  		return -EINVAL;
>  	if (min > mddev->resync_max)
>  		return -EINVAL;
> @@ -4464,7 +4464,7 @@ max_sync_store(struct mddev *mddev, const char *buf=
, size_t len)
>  		mddev->resync_max =3D MaxSector;
>  	else {
>  		unsigned long long max;
> -		if (strict_strtoull(buf, 10, &max))
> +		if (kstrtoull(buf, 10, &max))
>  			return -EINVAL;
>  		if (max < mddev->resync_min)
>  			return -EINVAL;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e1bcd75..d06eaa0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4929,7 +4929,7 @@ raid5_store_stripe_cache_size(struct mddev *mddev, =
const char *page, size_t len)
>  	if (!conf)
>  		return -ENODEV;
> =20
> -	if (strict_strtoul(page, 10, &new))
> +	if (kstrtoul(page, 10, &new))
>  		return -EINVAL;
>  	err =3D raid5_set_cache_size(mddev, new);
>  	if (err)
> @@ -4962,7 +4962,7 @@ raid5_store_preread_threshold(struct mddev *mddev, =
const char *page, size_t len)
>  	if (!conf)
>  		return -ENODEV;
> =20
> -	if (strict_strtoul(page, 10, &new))
> +	if (kstrtoul(page, 10, &new))
>  		return -EINVAL;
>  	if (new > conf->max_nr_stripes)
>  		return -EINVAL;


Applied, thanks.

NeilBrown

--Sig_/krKFON5C8=4qGCOJQSQNTjC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUa1KSjnsnt1WYoG5AQI6MxAAs7yfh7F0KEPYRsMwEFSEM8q4o4+Yl4gr
YyVaCfYlawt5WzOA8ZiapHpUS3L9fFQnZQ+P25lJ20ppZFLMk2Otdv0UUQKBez6v
FthJ+W+bmb8YRdvgl3JGtA3iOl+ZIigpygT2j2tEvPdHfwGVkxA+Y5zpZF1J53Rk
zDmL6seVNlEzm0grAhvStxxc3GfXFCeJ3+Ct2uye47wBBXtSL+DAXze6/2nbO2Jz
pZCN32PEIFcs6n4tpnR9pmnXARZi381deV30W3+lp1bLPcKPC32V4+5YMtzF8Una
flsPrKE8MjZCXHmMLGtBmb2Nm234qAPw6isstQ+vJYHsyjkQwqAShZMB6o9rL/8i
makdJj8q1hGoC7XVg2ncnb6K3hN3Fdb2Q5WwfZspnU4BqvziMSs9QQ5gRBYW9+si
5XLYWa6u1swMoQETPq9gevqThCRCSIE8/jWGSLbG2kM/7XJICvnx6T8605mHsDKT
bMP42zQoJ3YIncrfrbpxWJS+XGrznb2goQzCCe/l/yyn4HBVp9OmYllKlaXh2iRe
JrDy5LnQvpcr9+nMYZEDitkHXjMCUSIRikvOZqPJdbke7QFZfWrsG8351yEWY3cU
GAGyK06tcenLOxLE1r3b0X9y1vLYQICY22nsFErNGot1DLeFz44bnOidXGd6+Vgz
gDEG9AFfOV0=
=FkaZ
-----END PGP SIGNATURE-----

--Sig_/krKFON5C8=4qGCOJQSQNTjC--
