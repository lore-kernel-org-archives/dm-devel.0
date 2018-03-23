From: Gris Ge <fge@redhat.com>
Subject: [multipath] Should we include python API in the codebase?
Date: Fri, 23 Mar 2018 23:26:55 +0800
Message-ID: <20180323152655.GB2842@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6352538849644168757=="
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids


--===============6352538849644168757==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Guys,

I created a python API of multipath using the JSON output of multipathd
like what we did C API -- libdmmp:

    https://github.com/cathay4t/python-dmmp

Does upstream want it maintained in the codebase of multipath-tools?

Thanks.

--=20
Gris Ge

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8f1XsqXpyNthgIbGbM3lj+QeKP8FAlq1HL8ACgkQbM3lj+Qe
KP9y9xAAgLiCSjUEYa3kfCQbNIurOZdaz4EICDpmZFt1dpoiBSu5pJIXAib+Dxcx
BxX1oVTWKPiCtDEZliXsk7OcFgs3xD02LOz9vBkOSpMzG7o73aAerd/UQ+bh5LJk
NifynXPwGIlAt6MHQjBridz8GWI54RJKB18Yej80QGYMIJK2QPKMBAAmga9l5b0f
ZFP/ctdsLN1pA6yWuHLZs9D5fIdAFUYNod6Kg5gPPNA9bhrfdEyxBNPAPxM59CsN
ZuUlf3xK7KnuBEjfSUjCQ9Tgxvs+Mae+iNfEtAiKQizaiLVXT4Voh8oM0Af1Swz+
NvmsJonXAq48Zp/pg6pAhcOorNud3Dq+TyUn+eWsgwBehWAkcD3dKSaBGoqt9icI
/4QExrMBbbH1XhsCs5edtsGrGghnJVgeVFzGZKjj+8ckD7GnTDpWzcD/wNnZkwvm
cz20HW3R9yibfR/Hisx94009Tl5wcyOX4uuqLWikTcncCHAx1fOwJvEOstW1lv/0
RIkhGNzo4hsqxBJInUlvJR0dd+hqNP0CfUISuaDWeXDa6jSEoRxwwWCCuL6ujA1P
O5B9a67kgiTvy8WZ4gEadZ5ycu3qJT+6VeOXl2qSZi1fbaJIEV4akYrADuyPQFT9
o7E9M3uBnXu/91i6hUcu04/Y2CLi0FbFZY3qO525H8um5N256bs=
=5fQX
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--


--===============6352538849644168757==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6352538849644168757==--
