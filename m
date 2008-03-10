From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH 1/3] devmapper - don't modify api on selinux
	support
Date: Mon, 10 Mar 2008 21:02:27 +0100
Message-ID: <20080310200227.GA12454@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1580284891=="
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


--===============1580284891==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Always include dm_set_selinux_context in libdevmapper.

--- trunk.orig/lib/libdm-common.c
+++ trunk/lib/libdm-common.c
@@ -233,9 +233,9 @@
 	return 1;
 }
=20
-#ifdef HAVE_SELINUX
 int dm_set_selinux_context(const char *path, mode_t mode)
 {
+#ifdef HAVE_SELINUX
 	security_context_t scontext;
=20
 	if (is_selinux_enabled() <=3D 0)
@@ -256,9 +256,9 @@
 	}
=20
 	freecon(scontext);
+#endif
 	return 1;
 }
-#endif
=20
 static int _add_dev_node(const char *dev_name, uint32_t major, uint32_t mi=
nor,
 			 uid_t uid, gid_t gid, mode_t mode)
@@ -302,10 +302,8 @@
=20
 	log_debug("Created %s", path);
=20
-#ifdef HAVE_SELINUX
 	if (!dm_set_selinux_context(path, S_IFBLK))
 		return 0;
-#endif
=20
 	return 1;
 }
--=20
We fight only when there is no other choice.  We prefer the ways of
peaceful contact.
		-- Kirk, "Spectre of the Gun", stardate 4385.3

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkfVk9MACgkQnw66O/MvCNEuLgCglbk2VVluQBPNcnR2UwSZLsqD
qwAAmgIuZViiTP0p/+cqbLIF/+gqyiR8
=lhIg
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--


--===============1580284891==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1580284891==--
