From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] Don't add 'p' delimiter when you shouldn't
Date: Sun, 08 Jan 2012 22:08:23 -0500
Message-ID: <4F0A5A27.8090107@ubuntu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6788881619893088299=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============6788881619893088299==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigAF057FAAD5C0E79E65FA67B9"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAF057FAAD5C0E79E65FA67B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

The 'p' delimiter is supposed to be added when the base disk name
ends in a digit.  This decision was based on the name given on the
command line, not the canonical device name, so giving /dev/dm-0
instead of /dev/mapper/foo triggered the digit test and added the
'p'.  Changed test to use the canonical name rather than the given
name.

Index: b/kpartx/kpartx.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -310,12 +310,6 @@
 		device =3D loopdev;
 	}
=20
-	if (delim =3D=3D NULL) {
-		delim =3D malloc(DELIM_SIZE);
-		memset(delim, 0, DELIM_SIZE);
-		set_delimiter(device, delim);
-	}
-
 	off =3D find_devname_offset(device);
=20
 	if (!loopdev) {
@@ -331,6 +325,12 @@
 	if (!mapname)
 		mapname =3D device + off;
=20
+	if (delim =3D=3D NULL) {
+		delim =3D malloc(DELIM_SIZE);
+		memset(delim, 0, DELIM_SIZE);
+		set_delimiter(mapname, delim);
+	}
+
 	fd =3D open(device, O_RDONLY);
=20
 	if (fd =3D=3D -1) {


--------------enigAF057FAAD5C0E79E65FA67B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPClonAAoJEJrBOlT6nu75uIkH/ROUm2oKsiK6Kjhkj2k0KeZP
jhrP8UoK0AR6Tvk/AFFGhINe7RWxM0P2O8mhfRhs24A4Xv2yxtz0WkkCKmu0qGDM
TRetKN/jCV8tFVv2z87nV3Sdze5ekLakoMBY9Ik9VRbCGT7i5YRYEaHs0H9bgrJt
JNrnUXDzuajpyJPNSsuF+KIiw0r68kknSeNO0yypyAszqdiOxARcuRidfQlM7trB
qqoMwRzy6oLdnZCjyWpd5rKQpnFV3aGxpIwXc8emC8kRi0GYZLzDYmOlzrCBzmd+
XwZkNhDvpkE6eIuxVyvllAwldPTQ7b9c+JcncBdERWVExVrsTUN9YmFu6wcrj6I=
=xwtw
-----END PGP SIGNATURE-----

--------------enigAF057FAAD5C0E79E65FA67B9--


--===============6788881619893088299==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6788881619893088299==--
