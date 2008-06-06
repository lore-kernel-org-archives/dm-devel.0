From: agk@sourceware.org
Subject: device-mapper ./Makefile.in ./configure ./conf ...
Date: 6 Jun 2008 20:44:36 -0000
Message-ID: <20080606204436.29145.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2008-06-06 20:44:35

Modified files:
	.              : Makefile.in configure configure.in make.tmpl.in 
	lib            : Makefile.in libdm-common.c 

Log message:
	rename some config vars

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/Makefile.in.diff?cvsroot=dm&r1=1.17&r2=1.18
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.46&r2=1.47
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.48&r2=1.49
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/make.tmpl.in.diff?cvsroot=dm&r1=1.36&r2=1.37
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.37&r2=1.38
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.58&r2=1.59

--- device-mapper/Makefile.in	2006/07/05 17:29:12	1.17
+++ device-mapper/Makefile.in	2008/06/06 20:44:35	1.18
@@ -24,7 +24,7 @@
   SUBDIRS += po
 endif
 
-ifeq ("@DMEVENTD@", "yes")
+ifeq ("@BUILD_DMEVENTD@", "yes")
   SUBDIRS += dmeventd
 else
   ifeq ($(MAKECMDGOALS),distclean)
--- device-mapper/configure	2008/06/06 20:33:13	1.46
+++ device-mapper/configure	2008/06/06 20:44:35	1.47
@@ -686,23 +686,22 @@
 LIBOBJS
 POW_LIB
 MSGFMT
+BUILD_DMEVENTD
 CLDFLAGS
 CLDNOWHOLEARCHIVE
 CLDWHOLEARCHIVE
 CLUSTER
 CLVMD
 CMDLIB
-COMPAT
-CONFDIR
 COPTIMISE_FLAG
 DEBUG
-DEVICE_GID
-DEVICE_MODE
-DEVICE_UID
 DEVMAPPER
 DMDIR
-DMEVENTD
-DMIOCTLS
+DM_COMPAT
+DM_DEVICE_GID
+DM_DEVICE_MODE
+DM_DEVICE_UID
+DM_IOCTLS
 DM_LIB_VERSION
 FSADM
 GROUP
@@ -717,6 +716,7 @@
 LOCALEDIR
 LVM1
 LVM1_FALLBACK
+LVM_CONF_DIR
 LVM_VERSION
 MIRRORS
 OWNER
@@ -1950,7 +1950,7 @@
 		LIB_SUFFIX=so
 		DEVMAPPER=yes
 		ODIRECT=yes
-		DMIOCTLS=yes
+		DM_IOCTLS=yes
 		SELINUX=yes
 		REALTIME=yes
 		CLUSTER=internal
@@ -1965,7 +1965,7 @@
 		LIB_SUFFIX=dylib
 		DEVMAPPER=yes
 		ODIRECT=no
-		DMIOCTLS=no
+		DM_IOCTLS=no
 		SELINUX=no
 		REALTIME=no
 		CLUSTER=none
@@ -7836,13 +7836,13 @@
 
 # Check whether --with-device-uid was given.
 if test "${with_device_uid+set}" = set; then
-  withval=$with_device_uid;  DEVICE_UID="$withval"
+  withval=$with_device_uid;  DM_DEVICE_UID="$withval"
 else
-   DEVICE_UID="0"
+   DM_DEVICE_UID="0"
 fi
 
-{ echo "$as_me:$LINENO: result: $DEVICE_UID" >&5
-echo "${ECHO_T}$DEVICE_UID" >&6; }
+{ echo "$as_me:$LINENO: result: $DM_DEVICE_UID" >&5
+echo "${ECHO_T}$DM_DEVICE_UID" >&6; }
 
 ################################################################################
 { echo "$as_me:$LINENO: checking device node gid" >&5
@@ -7851,13 +7851,13 @@
 
 # Check whether --with-device-gid was given.
 if test "${with_device_gid+set}" = set; then
-  withval=$with_device_gid;  DEVICE_GID="$withval"
+  withval=$with_device_gid;  DM_DEVICE_GID="$withval"
 else
-   DEVICE_GID="0"
+   DM_DEVICE_GID="0"
 fi
 
-{ echo "$as_me:$LINENO: result: $DEVICE_GID" >&5
-echo "${ECHO_T}$DEVICE_GID" >&6; }
+{ echo "$as_me:$LINENO: result: $DM_DEVICE_GID" >&5
+echo "${ECHO_T}$DM_DEVICE_GID" >&6; }
 
 ################################################################################
 { echo "$as_me:$LINENO: checking device node mode" >&5
@@ -7866,13 +7866,13 @@
 
 # Check whether --with-device-mode was given.
 if test "${with_device_mode+set}" = set; then
-  withval=$with_device_mode;  DEVICE_MODE="$withval"
+  withval=$with_device_mode;  DM_DEVICE_MODE="$withval"
 else
-   DEVICE_MODE="0600"
+   DM_DEVICE_MODE="0600"
 fi
 
-{ echo "$as_me:$LINENO: result: $DEVICE_MODE" >&5
-echo "${ECHO_T}$DEVICE_MODE" >&6; }
+{ echo "$as_me:$LINENO: result: $DM_DEVICE_MODE" >&5
+echo "${ECHO_T}$DM_DEVICE_MODE" >&6; }
 
 ################################################################################
 { echo "$as_me:$LINENO: checking whether to enable debugging" >&5
@@ -7908,25 +7908,25 @@
 ################################################################################
 # Check whether --enable-compat was given.
 if test "${enable_compat+set}" = set; then
-  enableval=$enable_compat; COMPAT=$enableval
+  enableval=$enable_compat; DM_COMPAT=$enableval
 else
-  COMPAT=no
+  DM_COMPAT=no
 fi
 
 
 ################################################################################
 # Check whether --enable-ioctl was given.
 if test "${enable_ioctl+set}" = set; then
-  enableval=$enable_ioctl; DMIOCTLS=$enableval
+  enableval=$enable_ioctl; DM_IOCTLS=$enableval
 fi
 
 
 ################################################################################
 # Check whether --enable-dmeventd was given.
 if test "${enable_dmeventd+set}" = set; then
-  enableval=$enable_dmeventd; DMEVENTD=$enableval
+  enableval=$enable_dmeventd; BUILD_DMEVENTD=$enableval
 else
-  DMEVENTD=no
+  BUILD_DMEVENTD=no
 fi
 
 
@@ -8879,7 +8879,7 @@
 ################################################################################
 
 
-if test "$DMEVENTD" = yes; then
+if test "$BUILD_DMEVENTD" = yes; then
 
 # Check whether --with-dmeventd-pidfile was given.
 if test "${with_dmeventd_pidfile+set}" = set; then
@@ -8898,7 +8898,7 @@
 
 
 
-if test "$DMEVENTD" = yes; then
+if test "$BUILD_DMEVENTD" = yes; then
         dmeventd_prefix="$exec_prefix"
         if test "x$dmeventd_prefix" = "xNONE"; then
                 dmeventd_prefix="$prefix"
@@ -9676,23 +9676,22 @@
 LIBOBJS!$LIBOBJS$ac_delim
 POW_LIB!$POW_LIB$ac_delim
 MSGFMT!$MSGFMT$ac_delim
+BUILD_DMEVENTD!$BUILD_DMEVENTD$ac_delim
 CLDFLAGS!$CLDFLAGS$ac_delim
 CLDNOWHOLEARCHIVE!$CLDNOWHOLEARCHIVE$ac_delim
 CLDWHOLEARCHIVE!$CLDWHOLEARCHIVE$ac_delim
 CLUSTER!$CLUSTER$ac_delim
 CLVMD!$CLVMD$ac_delim
 CMDLIB!$CMDLIB$ac_delim
-COMPAT!$COMPAT$ac_delim
-CONFDIR!$CONFDIR$ac_delim
 COPTIMISE_FLAG!$COPTIMISE_FLAG$ac_delim
 DEBUG!$DEBUG$ac_delim
-DEVICE_GID!$DEVICE_GID$ac_delim
-DEVICE_MODE!$DEVICE_MODE$ac_delim
-DEVICE_UID!$DEVICE_UID$ac_delim
 DEVMAPPER!$DEVMAPPER$ac_delim
 DMDIR!$DMDIR$ac_delim
-DMEVENTD!$DMEVENTD$ac_delim
-DMIOCTLS!$DMIOCTLS$ac_delim
+DM_COMPAT!$DM_COMPAT$ac_delim
+DM_DEVICE_GID!$DM_DEVICE_GID$ac_delim
+DM_DEVICE_MODE!$DM_DEVICE_MODE$ac_delim
+DM_DEVICE_UID!$DM_DEVICE_UID$ac_delim
+DM_IOCTLS!$DM_IOCTLS$ac_delim
 DM_LIB_VERSION!$DM_LIB_VERSION$ac_delim
 FSADM!$FSADM$ac_delim
 GROUP!$GROUP$ac_delim
@@ -9701,6 +9700,7 @@
 HAVE_SELINUX!$HAVE_SELINUX$ac_delim
 INTL!$INTL$ac_delim
 INTL_PACKAGE!$INTL_PACKAGE$ac_delim
+JOBS!$JOBS$ac_delim
 _ACEOF
 
   if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 97; then
@@ -9742,12 +9742,12 @@
 ac_delim='%!_!# '
 for ac_last_try in false false false false false :; do
   cat >conf$$subs.sed <<_ACEOF
-JOBS!$JOBS$ac_delim
 LDDEPS!$LDDEPS$ac_delim
 LIB_SUFFIX!$LIB_SUFFIX$ac_delim
 LOCALEDIR!$LOCALEDIR$ac_delim
 LVM1!$LVM1$ac_delim
 LVM1_FALLBACK!$LVM1_FALLBACK$ac_delim
+LVM_CONF_DIR!$LVM_CONF_DIR$ac_delim
 LVM_VERSION!$LVM_VERSION$ac_delim
 MIRRORS!$MIRRORS$ac_delim
 OWNER!$OWNER$ac_delim
--- device-mapper/configure.in	2008/06/06 20:33:13	1.48
+++ device-mapper/configure.in	2008/06/06 20:44:35	1.49
@@ -38,7 +38,7 @@
 		LIB_SUFFIX=so
 		DEVMAPPER=yes
 		ODIRECT=yes
-		DMIOCTLS=yes
+		DM_IOCTLS=yes
 		SELINUX=yes
 		REALTIME=yes
 		CLUSTER=internal
@@ -53,7 +53,7 @@
 		LIB_SUFFIX=dylib
 		DEVMAPPER=yes
 		ODIRECT=no
-		DMIOCTLS=no
+		DM_IOCTLS=no
 		SELINUX=no
 		REALTIME=no
 		CLUSTER=none
@@ -158,8 +158,8 @@
 
 AC_ARG_WITH(device-uid,
   [  --with-device-uid=UID   Set the owner used for new device nodes [[UID=0]] ],
-  [ DEVICE_UID="$withval" ], [ DEVICE_UID="0" ] )
-AC_MSG_RESULT($DEVICE_UID)
+  [ DM_DEVICE_UID="$withval" ], [ DM_DEVICE_UID="0" ] )
+AC_MSG_RESULT($DM_DEVICE_UID)
 
 ################################################################################
 dnl -- Setup device group ownership
@@ -167,8 +167,8 @@
 
 AC_ARG_WITH(device-gid,
   [  --with-device-gid=UID   Set the group used for new device nodes [[GID=0]] ],
-  [ DEVICE_GID="$withval" ], [ DEVICE_GID="0" ] )
-AC_MSG_RESULT($DEVICE_GID)
+  [ DM_DEVICE_GID="$withval" ], [ DM_DEVICE_GID="0" ] )
+AC_MSG_RESULT($DM_DEVICE_GID)
 
 ################################################################################
 dnl -- Setup device mode
@@ -176,8 +176,8 @@
 
 AC_ARG_WITH(device-mode,
   [  --with-device-mode=MODE Set the mode used for new device nodes [[MODE=0600]] ],
-  [ DEVICE_MODE="$withval" ], [ DEVICE_MODE="0600" ] )
-AC_MSG_RESULT($DEVICE_MODE)
+  [ DM_DEVICE_MODE="$withval" ], [ DM_DEVICE_MODE="0600" ] )
+AC_MSG_RESULT($DM_DEVICE_MODE)
 
 ################################################################################
 dnl -- Enable debugging
@@ -204,17 +204,17 @@
 ################################################################################
 dnl -- Compatibility mode
 AC_ARG_ENABLE(compat,   [  --enable-compat         Enable support for old device-mapper versions],
-  COMPAT=$enableval, COMPAT=no)
+  DM_COMPAT=$enableval, DM_COMPAT=no)
 
 ################################################################################
 dnl -- Disable ioctl
 AC_ARG_ENABLE(ioctl,   [  --disable-driver        Disable calls to device-mapper in the kernel],
-  DMIOCTLS=$enableval)
+  DM_IOCTLS=$enableval)
 
 ################################################################################
 dnl -- Enable dmeventd
 AC_ARG_ENABLE(dmeventd,   [  --enable-dmeventd       Build the new event daemon],
-  DMEVENTD=$enableval, DMEVENTD=no)
+  BUILD_DMEVENTD=$enableval, BUILD_DMEVENTD=no)
 
 ################################################################################
 dnl -- Enable pkg-config
@@ -421,7 +421,7 @@
 ################################################################################
 dnl -- dmeventd pidfile and executable path
 AH_TEMPLATE(DMEVENTD_PIDFILE, [Path to dmeventd pidfile.])
-if test "$DMEVENTD" = yes; then
+if test "$BUILD_DMEVENTD" = yes; then
 	AC_ARG_WITH(dmeventd-pidfile,
 		    [  --with-dmeventd-pidfile=PATH    dmeventd pidfile [[/var/run/dmeventd.pid]] ],
 		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"$withval") ],
@@ -429,7 +429,7 @@
 fi
 
 AH_TEMPLATE(DMEVENTD_PATH, [Path to dmeventd binary.])
-if test "$DMEVENTD" = yes; then
+if test "$BUILD_DMEVENTD" = yes; then
         dmeventd_prefix="$exec_prefix"
         if test "x$dmeventd_prefix" = "xNONE"; then
                 dmeventd_prefix="$prefix"
@@ -444,6 +444,7 @@
 fi
 
 ################################################################################
+AC_SUBST(BUILD_DMEVENTD)
 AC_SUBST(CFLAGS)
 AC_SUBST(CFLOW_CMD)
 AC_SUBST(CLDFLAGS)
@@ -452,18 +453,16 @@
 AC_SUBST(CLUSTER)
 AC_SUBST(CLVMD)
 AC_SUBST(CMDLIB)
-AC_SUBST(COMPAT)
-AC_SUBST(CONFDIR)
 AC_SUBST(COPTIMISE_FLAG)
 AC_SUBST(CSCOPE_CMD)
 AC_SUBST(DEBUG)
-AC_SUBST(DEVICE_GID)
-AC_SUBST(DEVICE_MODE)
-AC_SUBST(DEVICE_UID)
 AC_SUBST(DEVMAPPER)
 AC_SUBST(DMDIR)
-AC_SUBST(DMEVENTD)
-AC_SUBST(DMIOCTLS)
+AC_SUBST(DM_COMPAT)
+AC_SUBST(DM_DEVICE_GID)
+AC_SUBST(DM_DEVICE_MODE)
+AC_SUBST(DM_DEVICE_UID)
+AC_SUBST(DM_IOCTLS)
 AC_SUBST(DM_LIB_VERSION)
 AC_SUBST(FSADM)
 AC_SUBST(GROUP)
@@ -479,6 +478,7 @@
 AC_SUBST(LOCALEDIR)
 AC_SUBST(LVM1)
 AC_SUBST(LVM1_FALLBACK)
+AC_SUBST(LVM_CONF_DIR)
 AC_SUBST(LVM_VERSION)
 AC_SUBST(MIRRORS)
 AC_SUBST(MSGFMT)
--- device-mapper/make.tmpl.in	2007/10/03 10:48:27	1.36
+++ device-mapper/make.tmpl.in	2008/06/06 20:44:35	1.37
@@ -77,11 +77,11 @@
 LDFLAGS += -L$(interfacedir)
 CLDFLAGS += -L$(interfacedir)
 
-ifeq ("@COMPAT@", "yes")
+ifeq ("@DM_COMPAT@", "yes")
   DEFS += -DDM_COMPAT
 endif
 
-ifeq ("@DMIOCTLS@", "yes")
+ifeq ("@DM_IOCTLS@", "yes")
   DEFS += -DDM_IOCTLS
 endif
 
--- device-mapper/lib/Makefile.in	2007/10/03 10:48:27	1.37
+++ device-mapper/lib/Makefile.in	2008/06/06 20:44:35	1.38
@@ -43,8 +43,8 @@
 endif
 VERSIONED_SHLIB = libdevmapper.$(LIB_SUFFIX).$(LIB_VERSION)
 
-DEFS += -DDEVICE_UID=@DEVICE_UID@ -DDEVICE_GID=@DEVICE_GID@ \
-	-DDEVICE_MODE=@DEVICE_MODE@
+DEFS += -DDM_DEVICE_UID=@DM_DEVICE_UID@ -DDM_DEVICE_GID=@DM_DEVICE_GID@ \
+	-DDM_DEVICE_MODE=@DM_DEVICE_MODE@
 
 include ../make.tmpl
 
--- device-mapper/lib/libdm-common.c	2007/12/14 19:49:27	1.58
+++ device-mapper/lib/libdm-common.c	2008/06/06 20:44:35	1.59
@@ -120,9 +120,9 @@
 	dmt->type = type;
 	dmt->minor = -1;
 	dmt->major = -1;
-	dmt->uid = DEVICE_UID;
-	dmt->gid = DEVICE_GID;
-	dmt->mode = DEVICE_MODE;
+	dmt->uid = DM_DEVICE_UID;
+	dmt->gid = DM_DEVICE_GID;
+	dmt->mode = DM_DEVICE_MODE;
 	dmt->no_open_count = 0;
 	dmt->read_ahead = DM_READ_AHEAD_AUTO;
 	dmt->read_ahead_flags = 0;
