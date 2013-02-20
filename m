From: Paul Menzel <pm.debian@googlemail.com>
Subject: Re: [PATCH linux-next] DM RAID: validate_raid_redundancy: Silence
 uninitialized variable warning
Date: Wed, 20 Feb 2013 23:16:37 +0100
Message-ID: <1361398597.4895.24.camel@mattotaupa>
References: <1361392278-59767-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0icSWeS8ZFVNtyJCy4wG"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1361392278-59767-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids


--=-0icSWeS8ZFVNtyJCy4wG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Tim,


thanks for the patch.


Am Mittwoch, den 20.02.2013, 13:31 -0700 schrieb Tim Gardner:

Noting the `gcc` version and build environment is never wrong. ;-)

> drivers/md/dm-raid.c: In function 'raid_ctr':
> drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used un=
initialized in this function [-Wuninitialized]
> drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here
>=20
> It appears unlikely that rebuilds_per_group could be used before set,

Why? Otherwise the compiler would not complain, right?

> but set it to 0 anyways just to shutup GCC.

Unfortunately I do not know what linux-next version you tested, so the
line numbers are off in.

        $ git describe
        v3.7.5-4-g9c2ab66

> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/md/dm-raid.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 9d6bf19..8005caf 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -380,7 +380,7 @@ static int validate_region_size(struct raid_set *rs, =
unsigned long region_size)
>  static int validate_raid_redundancy(struct raid_set *rs)
>  {
>  	unsigned i, rebuild_cnt =3D 0;
> -	unsigned rebuilds_per_group, copies, d;
> +	unsigned rebuilds_per_group =3D 0, copies, d;
>  	unsigned group_size, last_group_start;
> =20
>  	for (i =3D 0; i < rs->md.raid_disks; i++)


Thanks,

Paul

--=-0icSWeS8ZFVNtyJCy4wG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlElS0UACgkQPX1aK2wOHVi/rACfSfzrTnavweXApMe2bpgccSGK
PrwAn37PjP+zizUgGOSBrpkbO0pZl9TP
=QAX3
-----END PGP SIGNATURE-----

--=-0icSWeS8ZFVNtyJCy4wG--
