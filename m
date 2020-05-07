From: Christian Hesse <list@eworm.de>
Subject: Re: [PATCH 2/2] libmultipath: create libdir on install
Date: Fri, 8 May 2020 00:18:02 +0200
Message-ID: <20200508001802.3d559e01@leda>
References: <20200506073548.41756-1-list@eworm.de>
	<20200506073548.41756-2-list@eworm.de>
	<20200506094828.727f1d3a@leda>
	<858eb4ffcd9405ba7c10ed11f1d4c720a8ed496f.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3143056755045547408=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <858eb4ffcd9405ba7c10ed11f1d4c720a8ed496f.camel@suse.com>
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

--===============3143056755045547408==
Content-Type: multipart/signed; boundary="Sig_/.OfQdh/XDtFdCNiQgNTL3c1";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/.OfQdh/XDtFdCNiQgNTL3c1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Martin Wilck <mwilck@suse.com> on Thu, 2020/05/07 23:13:
> On Wed, 2020-05-06 at 09:48 +0200, Christian Hesse wrote:
> > Christian Hesse <list@eworm.de> on Wed, 2020/05/06 09:35: =20
> > > From: Christian Hesse <mail@eworm.de>
> > >=20
> > > Without this installation fails with:
> > >=20
> > > install: target '$DESTDIR/usr/lib/multipath' is not a directory
> > > Signed-off-by: Christian Hesse <mail@eworm.de>
> > > ---
> > >  libmultipath/prioritizers/Makefile | 1 +
> > >  1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/libmultipath/prioritizers/Makefile
> > > b/libmultipath/prioritizers/Makefile index 9d0fe03c..11da5be2
> > > 100644
> > > --- a/libmultipath/prioritizers/Makefile
> > > +++ b/libmultipath/prioritizers/Makefile
> > > @@ -35,6 +35,7 @@ libprio%.so: %.o
> > >  =09$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> > > =20
> > >  install: $(LIBS)
> > > +=09$(INSTALL_PROGRAM) -d $(DESTDIR)$(libdir)
> > >  =09$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
> > > =20
> > >  uninstall: =20
> >=20
> > Ignore this one... It does not fix the issue. The build system has to
> > be
> > fixed for simultaneous jobs when installing.
> >=20
> > For now installing with just one job (`make -j1`). =20
>=20
> Right. Feel free to send patches for this. I've never felt the urge to
> run "make install" parallelized; it takes less then 1s on my laptop.

Well, doing things in parallel is the default on our build servers... Via
environment variable MAKEFLAGS=3D"-j#". Running just one job is extra work.=
 :-p

If I have some spare time I will have a look again.
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH=
"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);=
}

--Sig_/.OfQdh/XDtFdCNiQgNTL3c1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl60iRoACgkQiUUh18yA
9HanNQf9Haq1anngwCZs+Ej3pw0qooLGTu7RuYzKHIHkSZglQ11x1m/g8DLGpYz6
R6wc5eXspCxFUrrZAkA4f/4yXPiKRqBpvNqd+qUtiK4AbSj2xNntIQBPv/NzUyMS
zXUVQ8/TmfRaNxmU4dsVTefgQc+ivhc7YMfIRbEysT1Xk3YiX6AQ7ypexolwBt6J
oT+547jSMHS0DCj17Ptv/X/kS1A4ttqAu9+IpNNeO74qPJxmQy7WwrfkRtUqpxp/
By3j7HZRmFxPWfGHRCC+WleQJKerxF7p4MernZh/wWnhYxHvf5snTAjoyJDT2yVK
hQTAlFNGVgOfw1N7Y6r7kB9UgNS+Cw==
=ojJp
-----END PGP SIGNATURE-----

--Sig_/.OfQdh/XDtFdCNiQgNTL3c1--


--===============3143056755045547408==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3143056755045547408==--
