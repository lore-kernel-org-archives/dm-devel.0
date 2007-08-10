From: Jim Meyering <jim@meyering.net>
Subject: fix dmsetup link failure with --enable-static_link on
	Debian unstable
Date: Fri, 10 Aug 2007 21:49:34 +0200
Message-ID: <873ayrmapd.fsf@meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Configuring with --enable-static_link on Debian unstable
makes dmsetup fail to link:

    /usr/lib/gcc/i486-linux-gnu/4.1.3/../../../../lib/libselinux.a(setrans_client.o): In function `fini_context_translations':
    /build/buildd/libselinux-2.0.15/src/setrans_client.c:208: undefined reference to `pthread_mutex_lock'
    ...
    /usr/lib/gcc/i486-linux-gnu/4.1.3/libgcc_eh.a(unwind-dw2-fde-glibc.o): In function `__deregister_frame_info_bases':
    (.text+0x100e): undefined reference to `pthread_mutex_lock'
    ...
    collect2: ld returned 1 exit status
    make[1]: *** [dmsetup.static] Error 1
    make[1]: Leaving directory `/media/sda4/home/meyering/work/co/git-mirror/device-mapper/dmsetup'
    make: *** [dmsetup] Error 2

Here's the patch I'm using:

diff --git a/configure.in b/configure.in
index f57de3f..c1870f3 100644
--- a/configure.in
+++ b/configure.in
@@ -239,8 +239,22 @@ if test x$SELINUX = xyes; then
 	else
 		AC_MSG_WARN(Disabling selinux)
 	fi
+
+	# With --enable-static_link and selinux, linking dmsetup fails
+	# on at least Debian unstable due to unsatisfied references to
+	# pthread_mutex_lock and _unlock.  See if we need -lpthread.
+	if test $STATIC_LINK = yes; then
+		dm_saved_libs=$LIBS
+		LIBS="$LIBS -static"
+		AC_SEARCH_LIBS([pthread_mutex_lock], [pthread],
+		  [test "$ac_cv_search_pthread_mutex_lock" = "none required" ||
+				LIB_PTHREAD=-lpthread])
+		AC_SUBST([LIB_PTHREAD])
+		LIBS=$dm_saved_libs
+	fi
 fi

+
 ################################################################################
 dnl -- Check for getopt
 AC_CHECK_HEADERS(getopt.h, AC_DEFINE([HAVE_GETOPTLONG], 1, [Define to 1 if getopt_long is available.]))
diff --git a/dmsetup/Makefile.in b/dmsetup/Makefile.in
index 2dcedc7..b63c6f7 100644
--- a/dmsetup/Makefile.in
+++ b/dmsetup/Makefile.in
@@ -18,6 +18,7 @@ VPATH = @srcdir@
 
 TARGETS = dmsetup
 INSTALL_TYPE = install_dynamic
+LIB_PTHREAD = @LIB_PTHREAD@
 
 ifeq ("@STATIC_LINK@", "yes")
   TARGETS += dmsetup.static
@@ -35,7 +36,8 @@ dmsetup: $(OBJECTS) $(interfacedir)/libdevmapper.$(LIB_SUFFIX)
 
 dmsetup.static: $(OBJECTS) $(interfacedir)/libdevmapper.a
 	$(CC) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS) -static \
-	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS)
+	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS) \
+	      $(LIB_PTHREAD)
 
 install: $(INSTALL_TYPE)
 
