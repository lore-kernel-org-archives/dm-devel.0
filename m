From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH 2/3] devmapper - fix selinux inclusion in
	pkgconfig file
Date: Mon, 10 Mar 2008 21:03:22 +0100
Message-ID: <20080310200322.GB12454@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0122301499=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0122301499==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Use Requires.private instead of Libs.private.

--- trunk.orig/lib/libdevmapper.pc.in
+++ trunk/lib/libdevmapper.pc.in
@@ -8,4 +8,4 @@
 Version: @DM_LIB_VERSION@
 Cflags: -I${includedir}=20
 Libs: -L${libdir} -ldevmapper
-Libs.private: -lselinux -lsepol
+Requires.private: libselinux
--=20
Pain is a thing of the mind.  The mind can be controlled.
		-- Spock, "Operation -- Annihilate!" stardate 3287.2

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkfVlAoACgkQnw66O/MvCNEHIgCbBh8q2HnKODzbYxGgCx9EvuEO
1vQAnA/st0vpsQgOSanIQn2wf3/DDReO
=6pDm
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--


--===============0122301499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0122301499==--
