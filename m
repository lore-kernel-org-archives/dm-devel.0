From: Christian Hesse <list@eworm.de>
Subject: Re: [PATCH 1/2] libmpathpersist: depend on libmultipath
Date: Fri, 8 May 2020 00:14:47 +0200
Message-ID: <20200508001447.45e0fb95@leda>
References: <20200506073548.41756-1-list@eworm.de>
	<8c24a3e1f995605b3ed3df2c768b0053766cd5a0.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3982710190319060390=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8c24a3e1f995605b3ed3df2c768b0053766cd5a0.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Christian Hesse <mail@eworm.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3982710190319060390==
Content-Type: multipart/signed; boundary="Sig_/f_xUczR/6/JqS_HjyHy0DJl";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/f_xUczR/6/JqS_HjyHy0DJl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Martin Wilck <mwilck@suse.com> on Thu, 2020/05/07 23:18:
> On Wed, 2020-05-06 at 09:35 +0200, Christian Hesse wrote:
> > From: Christian Hesse <mail@eworm.de>
> >=20
> > Without this the build fails with:
> >=20
> > /usr/bin/ld: cannot find -lmultipath =20
>=20
> Thank you. Strange, I've built multipath thousands of times and never
> hit this error.=20

Did you build with lots of parallel jobs? I think my build server does
something like `make -j48`. :-p
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH=
"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);=
}

--Sig_/f_xUczR/6/JqS_HjyHy0DJl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl60iFcACgkQiUUh18yA
9Hampwf/QzWKT7kRMKJZjt31A27rLn6K1BrYbtGGJqKL8GP7m+NgCeOWJjZDX4Qo
pr1m5E27yhZaXo7R9e+hJO8dkfGnP38BkENS5bueop/eLMOLIbgiZNcz9/uDfkVl
Ba3vXF5dMYjnmSkbulBZS/HLOMJjeyFQ5cLP8X7ka5TfjKMnujq8rkgzXLqU0iLW
jxUH88vhD8nGc0y/wooxpYZbxPMS6SaukH/WbJBV7eWF93IXfihR9Hd+iQ0Ye/LX
tTYzm5pxZxyPZQAEyU6hc4HEkbOyF6+zYV7+ttfbSgsn4hbgfGi6922vjPprG1tT
tAMZqzfsZ/cwK2tIYo8fKE24UBHWnQ==
=+eX7
-----END PGP SIGNATURE-----

--Sig_/f_xUczR/6/JqS_HjyHy0DJl--


--===============3982710190319060390==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3982710190319060390==--
