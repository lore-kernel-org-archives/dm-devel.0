From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v3 05/26] md: Convert md_trim_bio() to use bio_advance()
Date: Wed, 26 Sep 2012 10:38:27 +1000
Message-ID: <20120926103827.4d880cf4@notabene.brown>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
	<1348526106-17074-6-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nWbI9pl8cS=FqJdh=SBSu9o"; protocol="application/pgp-signature"
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348526106-17074-6-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

--Sig_/nWbI9pl8cS=FqJdh=SBSu9o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Sep 2012 15:34:45 -0700 Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
wrote:

> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/md/md.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7a2b079..51ce48c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -190,25 +190,16 @@ void md_trim_bio(struct bio *bio, int offset, int s=
ize)
>  	struct bio_vec *bvec;
>  	int sofar =3D 0;
> =20
> -	size <<=3D 9;
>  	if (offset =3D=3D 0 && size =3D=3D bio->bi_size)
>  		return;

Safer to leave the "size <<=3D 9" where it is, otherwise that condition will
always fail.

Otherwise,
 Acked-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>

NeilBrown


> =20
> -	bio->bi_sector +=3D offset;
> -	bio->bi_size =3D size;
> -	offset <<=3D 9;
>  	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
> =20
> -	while (bio->bi_idx < bio->bi_vcnt &&
> -	       bio->bi_io_vec[bio->bi_idx].bv_len <=3D offset) {
> -		/* remove this whole bio_vec */
> -		offset -=3D bio->bi_io_vec[bio->bi_idx].bv_len;
> -		bio->bi_idx++;
> -	}
> -	if (bio->bi_idx < bio->bi_vcnt) {
> -		bio->bi_io_vec[bio->bi_idx].bv_offset +=3D offset;
> -		bio->bi_io_vec[bio->bi_idx].bv_len -=3D offset;
> -	}
> +	bio_advance(bio, offset << 9);
> +
> +	size <<=3D 9;
> +	bio->bi_size =3D size;
> +
>  	/* avoid any complications with bi_idx being non-zero*/
>  	if (bio->bi_idx) {
>  		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,


--Sig_/nWbI9pl8cS=FqJdh=SBSu9o
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGJOgznsnt1WYoG5AQKkLxAAhuX7kdwyxYlHVz1sprLy1613EV1TB6Hv
ZY1MO+2TFJccsTSBxwPkXcRTHS7Vm7vNrJumM0jLwkAY+5fj4hedVasL4MwFKER0
BOzo6OoeyPNekH6MK71ryLCEgyDNbwip9svvtYwBjSK/r0xb1QE6FrHXDkuq2fje
63QyFLTm/osBrw2gji8DRgY8ji5y8WklJIRJ7lTfxl28PPZ8SZFGWJU3DV/BbsN0
OXSb37vB7EXH2FjOWKNOTMyah7RaROOBkjRVAf/7dhr0cgA7yeohF/bD529uJKJA
zzInxFVHnSOzrhfYQ2cfaV++EAs2Ged0KqU+KY6VHBR0uv8/vBLnmpLNt2YntGNn
I/fUd71hUHLu6+XuyedPnXmbvo4VgpNT2lh6JFewEzOCL1XzjEfK7hWdz4tER8gJ
CjHKp2Tvix7mmsSTvhK4G5+ESerhRZavqxCV6hXEdkhQtXvIxz1mmF5xCHSgqGW2
Kd8BOfC9qqCbJ5kRHunD0D/Piu9u1gXfW9VdNImhGw73g3s4b1Y5jKA2ummy/oMZ
KstbWIZoQO/7ZSFyYkNvdWNOgKBfBhAR61iwiFy2XB1j3dEe1Akfb0tpRw9XEcJ1
8xipd+ygnYmgyZh29YsLkpe7H1moXM0LdNiLzs1tk0yfR9OmUAaT7HnZfc2lYRiN
XUXMfBLloTw=
=kgaU
-----END PGP SIGNATURE-----

--Sig_/nWbI9pl8cS=FqJdh=SBSu9o--
