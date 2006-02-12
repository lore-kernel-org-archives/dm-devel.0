From: Bastian Blank <bastian@waldi.eu.org>
Subject: devmapper 1.02.03 breaks ABI
Date: Sun, 12 Feb 2006 11:23:57 +0100
Message-ID: <20060212102357.GA4134@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2086252357=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--===============2086252357==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks

devmapper 1.02.03 breaks the ABI by removing the exported symbol dm_strdup.

Bastian

--=20
The sight of death frightens them [Earthers].
		-- Kras the Klingon, "Friday's Child", stardate 3497.2

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEYEARECAAYFAkPvDL0ACgkQnw66O/MvCNFCfACfRXPyXepq0m57W+/FozS5KMi0
y9sAoKRjF8Qi4NXLyXoV/O9j4eGmaqIb
=F8Td
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--


--===============2086252357==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2086252357==--
