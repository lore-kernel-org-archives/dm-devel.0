From: Piet Delaney <piet-QZGUWFDCMdVWk0Htik3J/w@public.gmane.org>
Subject: Re: [dm-devel] [stable][PATCH < 2.6.19] Fix data corruption with
	dm-crypt over RAID5
Date: Wed, 17 Jan 2007 00:44:08 -0800
Message-ID: <1169023448.10964.244.camel@piet2.bluelane.com>
References: <456B732F.6080906@lelik.org>
	 <20061129145208.GQ4409@agk.surrey.redhat.com> <456F46E3.6030702@lelik.org>
	 <1164983209.24524.20.camel@leto.intern.saout.de>
	 <20061201152143.GE4409@agk.surrey.redhat.com> <45704B95.3020308@lelik.org>
	 <1165026116.29307.18.camel@leto.intern.saout.de>
	 <1165026476.29307.23.camel@leto.intern.saout.de>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3lsNEuFtZCBPnfzfdyWP"
Return-path: <dm-crypt-return-2044-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
Reply-To: piet-QZGUWFDCMdVWk0Htik3J/w@public.gmane.org
In-Reply-To: <1165026476.29307.23.camel-EBVayWzc4uH0B753RsUbJiEWGD4kr0XT@public.gmane.org>
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Piet Delaney <piet-QZGUWFDCMdVWk0Htik3J/w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, Chris Wright <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org, Andrey <dm-crypt-revealed-address-4bR+2G7ON2DYtjvyW6yDsg@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

--=-3lsNEuFtZCBPnfzfdyWP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2006-12-02 at 03:27 +0100, Christophe Saout wrote:

Hi Christophe:

I'm wondering about trying out your patch with dm-crypt on 2.6.12.=20
The code in drivers/md/dm-crypt.c`crypt_endio() appears to be the same.

Is there a reason that this isn't necessary or would be a bad idea.
Looks like the existing code isn't checking the BIO_UPTODATE flag
before doing the bio_put(). Looks the the second part of not calling
kcryptd_queue_io() and forwarding the processing to the cryptd is
effectively the same. The 1st change will set error if BIO_UPTODATE
isn't set and that will cause the 2nd change to skip calling=20
kcryptd_queue_io().

I'm not sure about the change in the arg to bio_data_dir()=20
changing from bio to io->bio. Perhaps they are equivalent;
care to comment on that.

Unless I hear otherwise I'll try it out Tomorrow.

-piet

> Fix corruption issue with dm-crypt on top of software raid5. Cancelled
> readahead bio's that report no error, just have BIO_UPTODATE cleared
> were reported as successful reads to the higher layers (and leaving
> random content in the buffer cache). Already fixed in 2.6.19.
>=20
> Signed-off-by: Christophe Saout <christophe-4q3lyFh4P1g@public.gmane.org>
>=20
>=20
> --- linux-2.6.18.orig/drivers/md/dm-crypt.c	2006-09-20 05:42:06.000000000=
 +0200
> +++ linux-2.6.18/drivers/md/dm-crypt.c	2006-12-02 03:03:36.000000000 +010=
0
> @@ -717,13 +717,15 @@
>  	if (bio->bi_size)
>  		return 1;
> =20
> +	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
> +		error =3D -EIO;
> +                       =20
>  	bio_put(bio);
> =20
>  	/*
>  	 * successful reads are decrypted by the worker thread
>  	 */
> -	if ((bio_data_dir(bio) =3D=3D READ)
> -	    && bio_flagged(bio, BIO_UPTODATE)) {
> +	if (bio_data_dir(io->bio) =3D=3D READ && !error) {
>  		kcryptd_queue_io(io);
>  		return 0;
>  	}
>=20
>=20
> --
> dm-devel mailing list
> dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet-QZGUWFDCMdVWk0Htik3J/w@public.gmane.org

--=-3lsNEuFtZCBPnfzfdyWP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBFreHYJICwm/rv3hoRAp9DAJ0a+Utvf1mK2f9aZ+fPb/+J0KZgHgCdFjHk
sd/J5VJF1ESE7MsZ8hE4YGY=
=XvwY
-----END PGP SIGNATURE-----

--=-3lsNEuFtZCBPnfzfdyWP--
