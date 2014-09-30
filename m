From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH]  dm-raid: fix bug when round up region_size
Date: Tue, 30 Sep 2014 22:30:51 +1000
Message-ID: <20140930223051.653dd063@notabene.brown>
References: <1412074836-5820-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3898203715845105095=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412074836-5820-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3898203715845105095==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/mzsqSIgdCVb0exHA.GBEL=y";
	protocol="application/pgp-signature"

--Sig_/mzsqSIgdCVb0exHA.GBEL=y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Sep 2014 13:00:36 +0200 heinzm@redhat.com wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
>=20
> Liong,
> thanks for the catch.
> Introduced minor modification utilizing the is_power_of_2() inline.
>=20
> ---
>=20
> If region_size is not supplied by userspace and the device is very
> large, there is a bug in current code preventing region_size from being
> correctly set.
>=20
>=20
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> Acked-by:      Heinz Mauelshagen <heinzm@redhat.com>
> Tested-by:     Heinz Mauelshagen <heinzm@redhat.com>
>=20
> ---
>  drivers/md/dm-raid.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 4880b69..264aef4 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -325,8 +325,10 @@ static int validate_region_size(struct raid_set *rs,=
 unsigned long region_size)
>  		 */
>  		if (min_region_size > (1 << 13)) {
>  			/* If not a power of 2, make it the next power of 2 */
> -			if (min_region_size & (min_region_size - 1))
> -				region_size =3D 1 << fls(region_size);
> +			if (is_power_of_2(min_region_size))
> +				region_size =3D min_region_size;
> +			else
> +				region_size =3D 1 << fls(min_region_size);
>  			DMINFO("Choosing default region size of %lu sectors",
>  			       region_size);
>  		} else {

If you really wanted to optimize, you could just do
   region_size =3D roundup_pow_of_two(min_region_size);

there is all sorts of cool stuff in log2.h !!

NeilBrown

--Sig_/mzsqSIgdCVb0exHA.GBEL=y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCqieznsnt1WYoG5AQJHtw//fSKLRuCpTvgstcPpwdTRuuUt/Avt/OBm
EUmLoBU/tuTYqu/CiffEdDFblm8DEWHOD0ZOetZ4ALUmzruDNLekBzKDtNiI3Hfu
GRUNC6yw0ws2sWr2QI8W8yt5a6QnZDMKK+5Mt1GS+FoMTaq+tdWsNDp7Gx0bX7PI
bS7kopj+gKsoZLsks56TvrNI1E4RzkObbCcOYFhuJZeZtt3C7rmmDROqP+Lxjo3q
rJWGjG4iZ7PF7lcYoFAeXvUeHsWWP/ubcw2n2iNRSC1ljEw/RzddNx3l4XzjMo8b
r/ZA9F23zC/S8KhXkT3j78OQGn9UvRz/aVuRrcpmNGEGdW9LsT9ca5yKQ10di+QM
JdR5AKUf0lkoXKqRylMXOBOg2C2yZYZz2gQRaDddlvTGHemsSLzG+kk0LSZIVJAU
PSVAjRIIb9CKUWJPF3rPGmvUKa10SbL+Kfpn45U+KsLv297+SEuX8O4ztJRp4OgE
/abaR7iophtjfgSfuSSwm7yCEf51X9IiL7HVIIMjIm9+smQ5bCoUDSwaSCSQuLZD
bFe+GLCTDF8OIx5SGhiWJycwmYth6qdnj1dybgqUBSuLI/an5tAmaNriQ0c10Vkj
Z2SMkcPP62ZN929H0VZtbjbmbOtDqzFYAau5rVDQ79tBimS36wEEY4NIKb4xe/uO
iptmMPfNTr8=
=ZkuB
-----END PGP SIGNATURE-----

--Sig_/mzsqSIgdCVb0exHA.GBEL=y--


--===============3898203715845105095==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3898203715845105095==--
