From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH 3/3] devmapper - cleanup lists of linked libs
Date: Mon, 10 Mar 2008 21:04:38 +0100
Message-ID: <20080310200438.GC12454@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0998350357=="
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


--===============0998350357==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

--- trunk.orig/dmsetup/Makefile.in
+++ trunk/dmsetup/Makefile.in
@@ -18,7 +18,7 @@
=20
 TARGETS =3D dmsetup
 INSTALL_TYPE =3D install_dynamic
-LIB_PTHREAD =3D @LIB_PTHREAD@
+LDFLAGS_STATIC =3D @LDFLAGS_SELINUX_STATIC@
=20
 ifeq ("@STATIC_LINK@", "yes")
   TARGETS +=3D dmsetup.static
@@ -32,12 +32,11 @@
=20
 dmsetup: $(OBJECTS) $(interfacedir)/libdevmapper.$(LIB_SUFFIX)
 	$(CC) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS) \
-	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS)
+	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper
=20
 dmsetup.static: $(OBJECTS) $(interfacedir)/libdevmapper.a
 	$(CC) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS) -static \
-	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS) \
-	      $(LIB_PTHREAD)
+	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LDFLAGS_STATIC)
=20
 install: $(INSTALL_TYPE)
=20
--- trunk.orig/configure.in
+++ trunk/configure.in
@@ -229,29 +229,18 @@
=20
 	if test x$HAVE_SEPOL =3D xyes; then
 		AC_DEFINE([HAVE_SEPOL], 1, [Define to 1 if sepol_check_context is availa=
ble.])
-		LIBS=3D"-lsepol $LIBS"
+		LDFLAGS_SEPOL=3D"-lsepol"
 	fi
=20
 	AC_CHECK_LIB(selinux, is_selinux_enabled, HAVE_SELINUX=3Dyes, HAVE_SELINU=
X=3Dno)
=20
 	if test x$HAVE_SELINUX =3D xyes; then
 		AC_DEFINE([HAVE_SELINUX], 1, [Define to 1 if selinux is available.])
-		LIBS=3D"-lselinux $LIBS"
+		LDFLAGS_SELINUX=3D"-lselinux"
+		LDFLAGS_SELINUX_STATIC=3D"$LDFLAGS_SELINUX $LDFLAGS_SEPOL -lpthread"
 	else
 		AC_MSG_WARN(Disabling selinux)
 	fi
-
-	# With --enable-static_link and selinux enabled, linking dmsetup
-	# fails on at least Debian unstable due to unsatisfied references
-	# to pthread_mutex_lock and _unlock.  See if we need -lpthread.
-	if test "$STATIC_LINK-$HAVE_SELINUX" =3D yes-yes; then
-		dm_saved_libs=3D$LIBS
-		LIBS=3D"$LIBS -static"
-		AC_SEARCH_LIBS([pthread_mutex_lock], [pthread],
-		  [test "$ac_cv_search_pthread_mutex_lock" =3D "none required" ||
-				LIB_PTHREAD=3D-lpthread])
-		LIBS=3D$dm_saved_libs
-	fi
 fi
=20
 ##########################################################################=
######
@@ -402,7 +390,8 @@
 AC_SUBST(STATIC_LINK)
 AC_SUBST(OWNER)
 AC_SUBST(GROUP)
-AC_SUBST(LIBS)
+AC_SUBST(LDFLAGS_SELINUX)
+AC_SUBST(LDFLAGS_SELINUX_STATIC)
 AC_SUBST(interface)
 AC_SUBST(kerneldir)
 AC_SUBST(missingkernel)
@@ -426,7 +416,6 @@
 AC_SUBST(DEVICE_MODE)
 AC_SUBST(DMEVENTD)
 AC_SUBST(PKGCONFIG)
-AC_SUBST([LIB_PTHREAD])
=20
 ##########################################################################=
######
 dnl -- First and last lines should not contain files to generate in order =
to=20
--- trunk.orig/dmeventd/Makefile.in
+++ trunk/dmeventd/Makefile.in
@@ -35,7 +35,7 @@
=20
 dmeventd: $(LIB_SHARED) dmeventd.o
 	$(CC) -o $@ dmeventd.o $(CFLAGS) $(LDFLAGS) \
-	-L. -ldevmapper-event $(LIBS) -rdynamic
+	-L. -ldevmapper-event
=20
 .PHONY: install_dynamic install_static install_include \
 	install_pkgconfig install_dmeventd
--- trunk.orig/lib/Makefile.in
+++ trunk/lib/Makefile.in
@@ -43,6 +43,8 @@
 endif
 VERSIONED_SHLIB =3D libdevmapper.$(LIB_SUFFIX).$(LIB_VERSION)
=20
+LDFLAGS +=3D @LDFLAGS_SELINUX@
+
 DEFS +=3D -DDEVICE_UID=3D@DEVICE_UID@ -DDEVICE_GID=3D@DEVICE_GID@ \
 	-DDEVICE_MODE=3D@DEVICE_MODE@
=20
--- trunk.orig/make.tmpl.in
+++ trunk/make.tmpl.in
@@ -23,7 +23,6 @@
 INSTALL =3D @INSTALL@
 MSGFMT =3D @MSGFMT@
 LN_S =3D @LN_S@
-LIBS =3D @LIBS@
 DEFS +=3D @DEFS@
 CFLAGS +=3D @CFLAGS@
 CLDFLAGS +=3D @CLDFLAGS@
@@ -75,7 +74,6 @@
 endif
=20
 LDFLAGS +=3D -L$(interfacedir)
-CLDFLAGS +=3D -L$(interfacedir)
=20
 ifeq ("@COMPAT@", "yes")
   DEFS +=3D -DDM_COMPAT
@@ -89,7 +87,6 @@
 #DEFS +=3D -DBOUNDS_CHECK
=20
 #CFLAGS +=3D -pg
-#LDFLAGS +=3D -pg
=20
 STRIP=3D
 #STRIP =3D -s
@@ -163,13 +160,13 @@
 ifeq ("@LIB_SUFFIX@","so")
 $(LIB_SHARED): $(OBJECTS) $(LDDEPS)
 	$(CC) -shared -Wl,-soname,$(notdir $@).$(LIB_VERSION) \
-	$(CFLAGS) $(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
+	$(CFLAGS) $(LDFLAGS) $(CLDFLAGS) $(OBJECTS) -o $@
 endif
=20
 ifeq ("@LIB_SUFFIX@","dylib")
 $(LIB_SHARED): $(OBJECTS) $(LDDEPS)
 	$(CC) -dynamiclib -dylib_current_version,$(LIB_VERSION) \
-	$(CFLAGS) $(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
+	$(CFLAGS) $(LDFLAGS) $(CLDFLAGS) $(OBJECTS) -o $@
 endif
=20
 $(LIB_STATIC): $(OBJECTS)
--=20
Respect is a rational process
		-- McCoy, "The Galileo Seven", stardate 2822.3

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkfVlFYACgkQnw66O/MvCNH4FACdGH+/ZTW87TwcqG5983+nr9YS
iBoAoIjQMxpjce5UjUlscEh0TyFrKOA1
=bcMn
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--


--===============0998350357==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0998350357==--
