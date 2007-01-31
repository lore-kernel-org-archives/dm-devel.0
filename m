From: Andre Noll <maan@systemlinux.org>
Subject: boolian logic bug in vgremove
Date: Wed, 31 Jan 2007 16:30:06 +0100
Message-ID: <20070131153006.GA19569@skl-net.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0390338739=="
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0390338739==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

In the argument checking code of vgreduce.c there are two occasions of
'&' that really should be '&&'. Patch below.

Signed-off.by: Andre Noll <maan@systemlinux.org>
---
Index: vgreduce.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /cvs/lvm2/LVM2/tools/vgreduce.c,v
retrieving revision 1.55
diff -u -r1.55 vgreduce.c
--- vgreduce.c	9 Jan 2007 23:14:34 -0000	1.55
+++ vgreduce.c	31 Jan 2007 15:17:01 -0000
@@ -427,13 +427,13 @@
 	int ret =3D 1;
 	int consistent =3D 1;
=20
-	if (!argc & !arg_count(cmd, removemissing_ARG)) {
+	if (!argc && !arg_count(cmd, removemissing_ARG)) {
 		log_error("Please give volume group name and "
 			  "physical volume paths");
 		return EINVALID_CMD_LINE;
 	}
=20
-	if (!argc & arg_count(cmd, removemissing_ARG)) {
+	if (!argc && arg_count(cmd, removemissing_ARG)) {
 		log_error("Please give volume group name");
 		return EINVALID_CMD_LINE;
 	}

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFFwLX+Wto1QDEAkw8RAmTnAJ9SpPnw2hSSrgcxjdZliLQOy7R9wgCdFCu9
tv3BWmW7hsBYOEgG1VGmvHw=
=cfPT
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--


--===============0390338739==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0390338739==--
