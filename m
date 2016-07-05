From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V5 3/3] Introducing multipath C API
Date: Tue, 5 Jul 2016 11:17:19 +0800
Message-ID: <20160705031719.GA4128@redhat.com>
References: <90c5e679-2942-12ce-4e77-9cc1f475ee45@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1449486424224432163=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <90c5e679-2942-12ce-4e77-9cc1f475ee45@gmail.com>
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


--===============1449486424224432163==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 06:32:56PM +0200, Xose Vazquez Perez wrote:
> Gris Ge wrote:
>=20
> > +	perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
> > +		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
>=20
> Please, replace perl with sed, awk or any other basic tool.
>=20
Hi Xose Vazquez Perez,

it's quit complex to handle folder path with '/' in sed or
awk unless I missed anything.

As we need perl in 'kernel-doc' tool blow to generate manpage,
can I keep it?
> > +	perl docs/kernel-doc -man $(HEADERS) | perl docs/split-man.pl docs/man
> > +	@for file in docs/man/*.3; do \
> > +		gzip -f $$file; \
> > +	done
> > +	find docs/man -type f -name \*[0-9].gz

--=20
Gris Ge

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXeya7AAoJEGzN5Y/kHij/tFYQAKATeqR/F+UaGeT+am+2yQ6C
DN4XJiL+7Bde275BBvFCqFleXZcIxNfba2g/q/oIcub+UnsFWh201ApdD9eSYea+
cfRs25KvulgSSAcGH8QlNmkYFJlpcyvEhowNE3r8lH05NVW9s8bB6Cyb5prR3f/6
Itw3q7YxJ8mL7RxaYcy6+xLJNot96SJcEgfH9VsIpxr6ZbJJanPrB0EbultW7gpL
YwoI12KQjPHj+PxOi6besEM9mlniTehGWIH11HSbYSlNA/RkfU7Dx338Clnpc9Kr
100au9Vr8kKSj7YlZTZQnuYl6Q8sj9VuExnDGspFJpzbuIqNn3qQr9utAaycc7FT
x5fihGoaN4otw62LpNPXbkBmMqFACwNcXLo94PxIt2XHUs1UY4ecraGuzc7zhdsY
rqbwfad+9zgdqcyuDIZBYaklBMC3EdXF+LT8xdARg3jVuFWGq+BGVEUgTdevdjLe
j+Wkw3AOt5N4ELXDoTxmCLGWtEMi4JJKi+WgSCeKc2RaTUQzArPBM1qZQFxykPEx
w8MFiUXZ5AUyl036U4Bc6FpA7llKdBWQD+5sZWcr5SaEB71LumMIgZJUKcFjJI1s
9kho+eG6SESvCPQqYxVHpa+kolPP6BQMpTdx97KALiWeucGw3PluJDQ84AmiIMfQ
ieY45UQ2Pce4PfmHq0E+
=2dO0
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--


--===============1449486424224432163==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1449486424224432163==--
