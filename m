From: Christian Hesse <list@eworm.de>
Subject: Re: [PATCH 2/2] libmultipath: create libdir on install
Date: Wed, 6 May 2020 09:48:28 +0200
Message-ID: <20200506094828.727f1d3a@leda>
References: <20200506073548.41756-1-list@eworm.de>
	<20200506073548.41756-2-list@eworm.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0267465331608610918=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200506073548.41756-2-list@eworm.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Christian Hesse <mail@eworm.de>
List-Id: dm-devel.ids

--===============0267465331608610918==
Content-Type: multipart/signed; boundary="Sig_//x5vMvyuv7RPR7A7604/axm";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_//x5vMvyuv7RPR7A7604/axm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Christian Hesse <list@eworm.de> on Wed, 2020/05/06 09:35:
> From: Christian Hesse <mail@eworm.de>
>=20
> Without this installation fails with:
>=20
> install: target '$DESTDIR/usr/lib/multipath' is not a directory
> Signed-off-by: Christian Hesse <mail@eworm.de>
> ---
>  libmultipath/prioritizers/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/libmultipath/prioritizers/Makefile
> b/libmultipath/prioritizers/Makefile index 9d0fe03c..11da5be2 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -35,6 +35,7 @@ libprio%.so: %.o
>  =09$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> =20
>  install: $(LIBS)
> +=09$(INSTALL_PROGRAM) -d $(DESTDIR)$(libdir)
>  =09$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
> =20
>  uninstall:

Ignore this one... It does not fix the issue. The build system has to be
fixed for simultaneous jobs when installing.

For now installing with just one job (`make -j1`).
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH=
"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);=
}

--Sig_//x5vMvyuv7RPR7A7604/axm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl6ya8wACgkQiUUh18yA
9HZeWQgAqwLNSSgPImSXy/RuW8w50X+Wlr1+7dor3DTKIuZB3R0s0oiXZfk+sNeU
Mmuy2pO6GrXVtiP2VK0kg8JnCK37VTkdpWmrfdV5PtmYdnsaCtqELVIk01alGW/N
Pyx0N9e+Tj13NG+sWqo1yiOJF9y9/ruQCcTd0yfo8fe46bOTqBL+fWJa05gjBnDj
V7Gcn+N5pJdlQBXK36G/seetFhuWWJVhZTLz/Q5qxTHUe33SMQNfm9yaqNwhoHeP
Vn38D+Nude87D/vPxtpWeMReAagB6B27FgGj3IsGH33o/YTVeY859Ev2bw5nVeXr
nvJzUJ8S0NjxF2yako11aSOilyE4WA==
=PBUr
-----END PGP SIGNATURE-----

--Sig_//x5vMvyuv7RPR7A7604/axm--


--===============0267465331608610918==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0267465331608610918==--
