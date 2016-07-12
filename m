From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V5 3/3] Introducing multipath C API
Date: Tue, 12 Jul 2016 13:29:39 +0800
Message-ID: <20160712052939.GA1981@redhat.com>
References: <46d2a8c7-0a33-54fb-9952-c2805816f5c8@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8067078988846803144=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46d2a8c7-0a33-54fb-9952-c2805816f5c8@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============8067078988846803144==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 10, 2016 at 06:23:39PM +0200, Xose Vazquez Perez wrote:
> Gris Ge wrote:
>=20
> > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > new file mode 100644
> > index 0000000..ce7ca3f
> > --- /dev/null
> > +++ b/libdmmp/Makefile
> > @@ -0,0 +1,78 @@
> > +	ln -sf $@ $(DEVLIB)
>=20
> In Makefile(s), replace "ln -arguments" and "rm -arguments" with
> $(LN) $(RM).

Thanks. Will fix them in V6 patch set.

--=20
Gris Ge

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXhIBDAAoJEGzN5Y/kHij/dM4P+gM2P0kSCRzTiT/vlN0Y5sMe
wG24r+0HrvVktJL/jqraNpDwjMKvaHbFvg4pvlp7N2cxDJ3JYScISTGc7+O+jqwf
6999dztlbP+i2CabyjQUPu+3jCaMHcj9IkeiVL3TZsWKu33yT7cYI1J7MVC73tuI
CTYWQR3TVBCjqfVOo73cJtj/Z1oYUvDZ7KVfC6DbdUIve08m2lomZWzhAq92WuW0
M1CRqPf2Mzld3fFta7FF4dlkQpgJsKTByKxY/vkjAo9PUNZfSNxNsRa2yNaauKGz
9xhFYI24uWOnAw/JNyQ5EqRoX8jEavNjwsifNAp9NxufhLBQAPiv4W4q4iVLBGbn
N4Pfvrkzr+xNx1qcTyGMdbIbsR4hpY73sS5IzX5M3p08+5+pjKmFgy3ol6riWFju
Js2MfZ7EO0NJOjw3ej1XrrkYKdwTLep4zmRsu32ml+i8Z8dqM1WhggwYG75tnzZI
V6LVZLayU0gFdBM88O0Igdnsm+VCWFrNqxz+epM36VSuS3kCMvfn+1Fa8sRkykbm
L2I5nk6biq2EU7UtuaNwXhZ+QF+dqz9AL14mxJnVmn6IEqJeHJ4RSZepGVEF1Vh8
PlFn9fQV37OnREKbCOgPH/vfjj0Vjtbm1X8EIt4TEVOc9Dv86KCTDeeXIqgnZVUV
cSs4Nzhh5D3xrD2Oyj/y
=sLfH
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--


--===============8067078988846803144==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8067078988846803144==--
