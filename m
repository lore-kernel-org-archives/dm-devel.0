From: Jim Meyering <jim@meyering.net>
Subject: Re: fix dmsetup link failure with --enable-static_link on
	Debian unstable
Date: Sat, 11 Aug 2007 10:49:43 +0200
Message-ID: <874pj6lal4.fsf@meyering.net>
References: <873ayrmapd.fsf@meyering.net>
	<20070810200624.GF2064@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070810200624.GF2064@agk.fab.redhat.com> (Alasdair G. Kergon's
	message of "Fri\, 10 Aug 2007 21\:06\:24 +0100")
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Alasdair G Kergon <agk@redhat.com> wrote:
> On Fri, Aug 10, 2007 at 09:49:34PM +0200, Jim Meyering wrote:
>> Configuring with --enable-static_link on Debian unstable
>> makes dmsetup fail to link:
>
> Only if dmeventd is enabled?  If so, the check must take that into account.
> If not, I'm curious what's pulling that in.

The link failure occurs regardless of whether dmeventd is enabled.
As you could see from the diagnostics, it is SELinux-related.
Build with "make LIBS=" (to attempt linking without -lselinux),
and you see which functions:

  ../lib/ioctl/libdevmapper.a(libdm-common.o): In function `dm_set_selinux_context':
  libdm-common.c:(.text+0x571): undefined reference to `is_selinux_enabled'
  libdm-common.c:(.text+0x58d): undefined reference to `matchpathcon'
  libdm-common.c:(.text+0x5dd): undefined reference to `lsetfilecon'
  libdm-common.c:(.text+0x5ec): undefined reference to `freecon'
  libdm-common.c:(.text+0x659): undefined reference to `freecon'
  collect2: ld returned 1 exit status
  make[1]: *** [dmsetup.static] Error 1

The test introduced by my initial patch was run only if $SELINUX = yes
(the default), by virtue of being in that if-block.  The one below
further restricts it to run only if $HAVE_SELINUX is also "yes".

If it's ok to commit this now, let me know what version of autoconf
to use when regenerating "configure".

diff --git a/configure.in b/configure.in
index f57de3f..924aa86 100644
--- a/configure.in
+++ b/configure.in
@@ -239,6 +239,18 @@ if test x$SELINUX = xyes; then
 	else
 		AC_MSG_WARN(Disabling selinux)
 	fi
+
+	# With --enable-static_link and selinux enabled, linking dmsetup
+	# fails on at least Debian unstable due to unsatisfied references
+	# to pthread_mutex_lock and _unlock.  See if we need -lpthread.
+	if test "$STATIC_LINK-$HAVE_SELINUX" = yes-yes; then
+		dm_saved_libs=$LIBS
+		LIBS="$LIBS -static"
+		AC_SEARCH_LIBS([pthread_mutex_lock], [pthread],
+		  [test "$ac_cv_search_pthread_mutex_lock" = "none required" ||
+				LIB_PTHREAD=-lpthread])
+		LIBS=$dm_saved_libs
+	fi
 fi
 
 ################################################################################
@@ -413,6 +425,7 @@ AC_SUBST(DEVICE_GID)
 AC_SUBST(DEVICE_MODE)
 AC_SUBST(DMEVENTD)
 AC_SUBST(PKGCONFIG)
+AC_SUBST([LIB_PTHREAD])
 
 ################################################################################
 dnl -- First and last lines should not contain files to generate in order to 
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
 
