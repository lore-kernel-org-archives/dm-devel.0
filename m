From: Bastian Blank <bastian@waldi.eu.org>
Subject: Re: devmapper 1.02.03 breaks ABI
Date: Sun, 12 Feb 2006 11:41:57 +0100
Message-ID: <20060212104157.GO4513@wavehammer.waldi.eu.org>
References: <20060212102357.GA4134@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0902532835=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060212102357.GA4134@wavehammer.waldi.eu.org>
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


--===============0902532835==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline


--24zk1gE8NUlDmwG9
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2006 at 11:23:57AM +0100, Bastian Blank wrote:
> devmapper 1.02.03 breaks the ABI by removing the exported symbol dm_strdu=
p.

The attached patch reexports dm_strdup.

Bastian

--=20
Insufficient facts always invite danger.
		-- Spock, "Space Seed", stardate 3141.9

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=diff1
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D lib/.exported_symbols
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/.exported_symbols	(revision 226)
+++ lib/.exported_symbols	(local)
@@ -70,6 +70,7 @@
 dm_mknodes
 dm_malloc_aux
 dm_malloc_aux_debug
+dm_strdup
 dm_strdup_aux
 dm_free_aux
 dm_realloc_aux
=3D=3D=3D lib/Makefile.in
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/Makefile.in	(revision 226)
+++ lib/Makefile.in	(local)
@@ -23,6 +23,7 @@
 	libdm-common.c \
 	libdm-file.c \
 	libdm-deptree.c \
+	mm/abi.c \
 	mm/dbg_malloc.c \
 	mm/pool.c \
 	$(interface)/libdm-iface.c
=3D=3D=3D lib/mm/dbg_malloc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/mm/dbg_malloc.c	(revision 226)
+++ lib/mm/dbg_malloc.c	(local)
@@ -18,6 +18,12 @@
 #include <assert.h>
 #include <stdarg.h>
=20
+char *dm_strdup_real(const char *str);
+char *dm_strdup_real(const char *str)
+{
+	return dm_strdup(str);
+}
+
 char *dm_strdup_aux(const char *str)
 {
 	char *ret =3D dm_malloc(strlen(str) + 1);
=3D=3D=3D lib/mm/abi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/mm/abi.c	(revision 226)
+++ lib/mm/abi.c	(local)
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2006 Bastian Blank
+ *
+ * This file is part of the device-mapper userspace tools.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License v.2.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <stdarg.h>
+
+char *dm_strdup_real(const char *str);
+
+char *dm_strdup(const char *str)
+{
+	return dm_strdup_real(str);
+}
+

--h31gzZEtNLTqOjlF--

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEYEARECAAYFAkPvEPUACgkQnw66O/MvCNHC4QCcD+KeTEv+XhGANPErv3BA5w0A
I0cAn1WOtrOJ6NMneoMq85cdJYQDcpsZ
=jKIY
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--


--===============0902532835==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0902532835==--
