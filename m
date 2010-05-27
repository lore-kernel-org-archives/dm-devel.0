From: zkabelac@sourceware.org
Subject: dmraid ./configure ./configure.in lib/Makefile ...
Date: 27 May 2010 14:28:49 -0000
Message-ID: <20100527142849.31473.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	dmraid
Changes by:	zkabelac@sourceware.org	2010-05-27 14:28:48

Modified files:
	.              : configure configure.in 
	lib            : Makefile.in 
	tools          : Makefile.in 

Log message:
	Updated configure.in:
	removed test for libselinux/libsepol/libreadline -> devmapper deps.
	using AC_HELP_STRING()
	fixed some help string
	using AC_MSG_CHECKING and AC_MSG_RESULT instead of echo 1>&6
	removed multiline from AC_OUTPUT
	Added top_builddir to Makefile.in files
	Dropped linking of -lselinux -lsepol  (static linking is broken for now anyway).

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/configure	2009/09/17 11:25:57	1.4
+++ dmraid/configure	2010/05/27 14:28:47	1.5
@@ -737,8 +737,6 @@
 enable_debug_malloc
 enable_dietlibc
 enable_jobs
-enable_libselinux
-enable_libsepol
 enable_mini
 enable_led
 enable_intel_led
@@ -1386,18 +1384,17 @@
   --enable-debug_malloc   Enable malloc debugging
   --enable-dietlibc       Use this to link the tools to dietlibc
   --enable-jobs=NUM       Number of jobs to run simultaneously
-  --enable-libselinux     Use this to link the tools to libselinux
-  --enable-libsepol       Use this to link the tools to libsepol
-  --enable-mini           Use this to create a minimal binary suitable
-                          for early boot environments
+  --enable-mini           Use this to create a minimal binary suitable for
+                          early boot environments
   --enable-led            Use this to enable LED support
   --enable-intel_led      Use this to enable Intel LED support
-  --disable-native_log    Disable native metadata logging. Default is enabled
-  --enable-static_link    Use this to link the tools to the dmraid and devmapper
-                          libraries statically.  Default is dynamic linking
+  --disable-native_log    Disable native metadata logging [enabled]
+  --enable-static_link    Use this to link the tools to the dmraid and
+                          devmapper libraries statically. Default is dynamic
+                          linking
   --enable-shared_lib     Use this to generate shared libdmraid and link the
                           tools to it. Default is static libdmraid
-  --disable-testing        Enable testing with mapped devices
+  --disable-testing       Disable testing with mapped devices
 
 Optional Packages:
   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
@@ -5217,31 +5214,33 @@
 fi
 
 
-echo $ac_n "checking whether to enable debugging""... $ac_c" 1>&6
 # Check whether --enable-debug was given.
 if test "${enable_debug+set}" = set; then
-  enableval=$enable_debug; \
-DEBUG=yes
+  enableval=$enable_debug; DEBUG=$enableval
 else
   DEBUG=no
 fi
 
-echo "$ac_t""$DEBUG" 1>&6
+{ $as_echo "$as_me:$LINENO: checking whether to enable debugging" >&5
+$as_echo_n "checking whether to enable debugging... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DEBUG" >&5
+$as_echo "$DEBUG" >&6; }
 
-echo $ac_n "checking whether to enable malloc debugging""... $ac_c" 1>&6
 # Check whether --enable-debug_malloc was given.
 if test "${enable_debug_malloc+set}" = set; then
-  enableval=$enable_debug_malloc; \
-DEBUG_MALLOC=yes
+  enableval=$enable_debug_malloc; DEBUG_MALLOC=$enableval
 else
   DEBUG_MALLOC=no
 fi
 
-echo "$ac_t""$DEBUG" 1>&6
+{ $as_echo "$as_me:$LINENO: checking whether to enable malloc debugging" >&5
+$as_echo_n "checking whether to enable malloc debugging... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DEBUG_MALLOC" >&5
+$as_echo "$DEBUG_MALLOC" >&6; }
 
 # Check whether --enable-dietlibc was given.
 if test "${enable_dietlibc+set}" = set; then
-  enableval=$enable_dietlibc; DIETLIBC=yes
+  enableval=$enable_dietlibc; DIETLIBC=$enableval
 else
   DIETLIBC=no
 fi
@@ -5249,10 +5248,9 @@
 
 if test x$DIETLIBC = xyes; then
 	if test x$KLIBC = xyes; then
-		{ { $as_echo "$as_me:$LINENO: error: You can' enable both dietlibc and klibc!" >&5
-$as_echo "$as_me: error: You can' enable both dietlibc and klibc!" >&2;}
+		{ { $as_echo "$as_me:$LINENO: error: You cannot enable both dietlibc and klibc!" >&5
+$as_echo "$as_me: error: You cannot enable both dietlibc and klibc!" >&2;}
    { (exit 1); exit 1; }; }
-		exit 1
 	fi
         CC="diet gcc"
 	FLAVOUR="dietlibc "
@@ -5266,22 +5264,6 @@
 fi
 
 
-# Check whether --enable-libselinux was given.
-if test "${enable_libselinux+set}" = set; then
-  enableval=$enable_libselinux; LIBSELINUX=$enableval
-else
-  LIBSELINUX=no
-fi
-
-
-# Check whether --enable-libsepol was given.
-if test "${enable_libsepol+set}" = set; then
-  enableval=$enable_libsepol; LIBSEPOL=$enableval
-else
-  LIBSEPOL=no
-fi
-
-
 # Check whether --enable-mini was given.
 if test "${enable_mini+set}" = set; then
   enableval=$enable_mini; DMRAID_MINI=$enableval
@@ -5306,16 +5288,17 @@
 fi
 
 
-echo $ac_n "checking whether to disable native metadata logging""... $ac_c" 1>&6
 # Check whether --enable-native_log was given.
 if test "${enable_native_log+set}" = set; then
-  enableval=$enable_native_log; \
-DMRAID_NATIVE_LOG=$enableval
+  enableval=$enable_native_log; DMRAID_NATIVE_LOG=$enableval
 else
   DMRAID_NATIVE_LOG=yes
 fi
 
-echo "$ac_t""$DMRAID_NATIVE_LOG" 1>&6
+{ $as_echo "$as_me:$LINENO: checking whether to disable native metadata logging" >&5
+$as_echo_n "checking whether to disable native metadata logging... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DMRAID_NATIVE_LOG" >&5
+$as_echo "$DMRAID_NATIVE_LOG" >&6; }
 
 # Check whether --enable-static_link was given.
 if test "${enable_static_link+set}" = set; then
@@ -5333,18 +5316,17 @@
 fi
 
 
-echo $ac_n "checking whether to disable testing with mapped devices""... $ac_c" 1>&6
 # Check whether --enable-testing was given.
 if test "${enable_testing+set}" = set; then
-  enableval=$enable_testing; \
-DMRAID_TEST=$enableval
+  enableval=$enable_testing; DMRAID_TEST=$enableval
 else
   DMRAID_TEST=yes
 fi
 
-
-
-echo "$ac_t""$DEBUG" 1>&6
+{ $as_echo "$as_me:$LINENO: checking whether to disable testing with mapped devices" >&5
+$as_echo_n "checking whether to disable testing with mapped devices... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DMRAID_TEST" >&5
+$as_echo "$DMRAID_TEST" >&6; }
 
 if test x$LIB_SO = xyes; then
 	FLAVOUR="shared "
@@ -5353,10 +5335,9 @@
 if test x$STATIC_LINK = xyes; then
 	FLAVOUR="static "
 	if test x$LIB_SO = xyes; then
-		{ { $as_echo "$as_me:$LINENO: error: You can' enable both shared_lib and static_link!" >&5
-$as_echo "$as_me: error: You can' enable both shared_lib and static_link!" >&2;}
+		{ { $as_echo "$as_me:$LINENO: error: You cannot enable both shared_lib and static_link!" >&5
+$as_echo "$as_me: error: You cannot enable both shared_lib and static_link!" >&2;}
    { (exit 1); exit 1; }; }
-		exit 1
 	fi
 fi
 
@@ -5802,118 +5783,6 @@
 done
 
 
-if test x$READLINE = xyes; then
-	{ $as_echo "$as_me:$LINENO: checking for library containing tgetent" >&5
-$as_echo_n "checking for library containing tgetent... " >&6; }
-if test "${ac_cv_search_tgetent+set}" = set; then
-  $as_echo_n "(cached) " >&6
-else
-  ac_func_search_save_LIBS=$LIBS
-cat >conftest.$ac_ext <<_ACEOF
-/* confdefs.h.  */
-_ACEOF
-cat confdefs.h >>conftest.$ac_ext
-cat >>conftest.$ac_ext <<_ACEOF
-/* end confdefs.h.  */
-
-/* Override any GCC internal prototype to avoid an error.
-   Use char because int might match the return type of a GCC
-   builtin and then its argument prototype would still apply.  */
-#ifdef __cplusplus
-extern "C"
-#endif
-char tgetent ();
-int
-main ()
-{
-return tgetent ();
-  ;
-  return 0;
-}
-_ACEOF
-for ac_lib in '' ncurses curses termcap termlib; do
-  if test -z "$ac_lib"; then
-    ac_res="none required"
-  else
-    ac_res=-l$ac_lib
-    LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
-  fi
-  rm -f conftest.$ac_objext conftest$ac_exeext
-if { (ac_try="$ac_link"
-case "(($ac_try" in
-  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
-  *) ac_try_echo=$ac_try;;
-esac
-eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
-$as_echo "$ac_try_echo") >&5
-  (eval "$ac_link") 2>conftest.er1
-  ac_status=$?
-  grep -v '^ *+' conftest.er1 >conftest.err
-  rm -f conftest.er1
-  cat conftest.err >&5
-  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
-  (exit $ac_status); } && {
-	 test -z "$ac_c_werror_flag" ||
-	 test ! -s conftest.err
-       } && test -s conftest$ac_exeext && {
-	 test "$cross_compiling" = yes ||
-	 $as_test_x conftest$ac_exeext
-       }; then
-  ac_cv_search_tgetent=$ac_res
-else
-  $as_echo "$as_me: failed program was:" >&5
-sed 's/^/| /' conftest.$ac_ext >&5
-
-
-fi
-
-rm -rf conftest.dSYM
-rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
-      conftest$ac_exeext
-  if test "${ac_cv_search_tgetent+set}" = set; then
-  break
-fi
-done
-if test "${ac_cv_search_tgetent+set}" = set; then
-  :
-else
-  ac_cv_search_tgetent=no
-fi
-rm conftest.$ac_ext
-LIBS=$ac_func_search_save_LIBS
-fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_search_tgetent" >&5
-$as_echo "$ac_cv_search_tgetent" >&6; }
-ac_res=$ac_cv_search_tgetent
-if test "$ac_res" != no; then
-  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
-
-else
-  { { $as_echo "$as_me:$LINENO: error: termcap could not be found which is required for the
---enable-readline option (which is enabled by default).  Either disable readline
-support with --disable-readline or download and install termcap from:
-	ftp.gnu.org/gnu/termcap
-Note: if you are using precompiled packages you will also need the development
-  package as well (which may be called termcap-devel or something similar).
-Note: (n)curses also seems to work as a substitute for termcap.  This was
-  not found either - but you could try installing that as well.
-" >&5
-$as_echo "$as_me: error: termcap could not be found which is required for the
---enable-readline option (which is enabled by default).  Either disable readline
-support with --disable-readline or download and install termcap from:
-	ftp.gnu.org/gnu/termcap
-Note: if you are using precompiled packages you will also need the development
-  package as well (which may be called termcap-devel or something similar).
-Note: (n)curses also seems to work as a substitute for termcap.  This was
-  not found either - but you could try installing that as well.
-" >&2;}
-   { (exit 1); exit 1; }; }
-	exit
-
-fi
-
-fi
-
 if test x$KLIBC != xyes; then
 
 for ac_header in getopt.h
--- dmraid/configure.in	2009/09/17 11:25:57	1.4
+++ dmraid/configure.in	2010/05/27 14:28:47	1.5
@@ -74,70 +74,79 @@
   [ GROUP="$withval" ],
   [ GROUP="root" ])
 
-echo $ac_n "checking whether to enable debugging""... $ac_c" 1>&6
 dnl Enable Debugging
-AC_ARG_ENABLE(debug, [  --enable-debug          Enable debugging],  \
-DEBUG=yes, DEBUG=no)
-echo "$ac_t""$DEBUG" 1>&6
+AC_ARG_ENABLE(debug, 
+  AC_HELP_STRING([--enable-debug], [Enable debugging]),
+  [DEBUG=$enableval], [DEBUG=no])
+AC_MSG_CHECKING([whether to enable debugging])
+AC_MSG_RESULT([$DEBUG])
 
-echo $ac_n "checking whether to enable malloc debugging""... $ac_c" 1>&6
 dnl Enable malloc debugging
-AC_ARG_ENABLE(debug_malloc, [  --enable-debug_malloc   Enable malloc debugging],  \
-DEBUG_MALLOC=yes, DEBUG_MALLOC=no)
-echo "$ac_t""$DEBUG" 1>&6
+AC_ARG_ENABLE(debug_malloc, 
+  AC_HELP_STRING([--enable-debug_malloc], [Enable malloc debugging]),
+  [DEBUG_MALLOC=$enableval], [DEBUG_MALLOC=no])
+AC_MSG_CHECKING([whether to enable malloc debugging])
+AC_MSG_RESULT([$DEBUG_MALLOC])
 
 dnl Enables linking to dietlibc
-AC_ARG_ENABLE(dietlibc, [  --enable-dietlibc       Use this to link the tools to dietlibc ], DIETLIBC=yes, DIETLIBC=no)
+AC_ARG_ENABLE(dietlibc, 
+  AC_HELP_STRING([--enable-dietlibc], [Use this to link the tools to dietlibc]),
+  [DIETLIBC=$enableval], [DIETLIBC=no])
 
 if test x$DIETLIBC = xyes; then
 	if test x$KLIBC = xyes; then
-		AC_MSG_ERROR(You can' enable both dietlibc and klibc!)
-		exit 1
+		AC_MSG_ERROR([You cannot enable both dietlibc and klibc!])
 	fi
         CC="diet gcc"
 	FLAVOUR="dietlibc "
 fi
 
-AC_ARG_ENABLE(jobs,  [  --enable-jobs=NUM       Number of jobs to run simultaneously], JOBS=-j$enableval, JOBS=-j1)
-
-dnl Enables linking to libselinux
-AC_ARG_ENABLE(libselinux, [  --enable-libselinux     Use this to link the tools to libselinux ], LIBSELINUX=$enableval, LIBSELINUX=no)
-
-dnl Enables linking to libselinux
-AC_ARG_ENABLE(libsepol, [  --enable-libsepol       Use this to link the tools to libsepol ], LIBSEPOL=$enableval, LIBSEPOL=no)
+AC_ARG_ENABLE(jobs,
+  AC_HELP_STRING([--enable-jobs=NUM], [Number of make jobs to run simultaneously]),
+  [JOBS=-j$enableval], [JOBS=-j1])
 
 dnl Enables mini binary
-AC_ARG_ENABLE(mini, [  --enable-mini           Use this to create a minimal binary suitable
-                          for early boot environments],  DMRAID_MINI=$enableval, DMRAID_MINI=no)
+AC_ARG_ENABLE(mini,
+  AC_HELP_STRING([--enable-mini], 
+    [Use this to create a minimal binary suitable for early boot environments]),
+  [DMRAID_MINI=$enableval], [DMRAID_MINI=no])
 
 dnl Enables LED support
-AC_ARG_ENABLE(led, [  --enable-led            Use this to enable LED support],  DMRAID_LED=$enableval, DMRAID_LED=no)
+AC_ARG_ENABLE(led, 
+  AC_HELP_STRING([--enable-led], [Use this to enable LED support]),
+  [DMRAID_LED=$enableval], [DMRAID_LED=no])
 
 dnl Enables Intel LED support
-AC_ARG_ENABLE(intel_led, [  --enable-intel_led      Use this to enable Intel LED support],  DMRAID_INTEL_LED=$enableval, DMRAID_INTEL_LED=no)
+AC_ARG_ENABLE(intel_led,
+  AC_HELP_STRING([--enable-intel_led], [Use this to enable Intel LED support]),
+  [DMRAID_INTEL_LED=$enableval], [DMRAID_INTEL_LED=no])
 
-echo $ac_n "checking whether to disable native metadata logging""... $ac_c" 1>&6
 dnl Disable native metadata logging
-AC_ARG_ENABLE(native_log, [  --disable-native_log    Disable native metadata logging. Default is enabled],  \
-DMRAID_NATIVE_LOG=$enableval, DMRAID_NATIVE_LOG=yes)
-echo "$ac_t""$DMRAID_NATIVE_LOG" 1>&6
+AC_ARG_ENABLE(native_log,
+  AC_HELP_STRING([--disable-native_log], [Disable native metadata logging [[enabled]]]),
+  [DMRAID_NATIVE_LOG=$enableval], [DMRAID_NATIVE_LOG=yes])
+AC_MSG_CHECKING([whether to disable native metadata logging])
+AC_MSG_RESULT([$DMRAID_NATIVE_LOG])
 
 dnl Enables staticly linked tools
-AC_ARG_ENABLE(static_link, [  --enable-static_link    Use this to link the tools to the dmraid and devmapper
-                          libraries statically.  Default is dynamic linking],  STATIC_LINK=$enableval, STATIC_LINK=no)
+AC_ARG_ENABLE(static_link,
+  AC_HELP_STRING([--enable-static_link],
+    [Use this to link the tools to the dmraid and devmapper libraries statically.
+    Default is dynamic linking]),
+  [STATIC_LINK=$enableval], [STATIC_LINK=no])
 
 dnl Enables shared libdmraid
 AC_ARG_ENABLE(shared_lib,
-                           [  --enable-shared_lib     Use this to generate shared libdmraid and link the
-                          tools to it. Default is static libdmraid],  LIB_SO=$enableval, LIB_SO=no)
+  AC_HELP_STRING([--enable-shared_lib], [Use this to generate shared
+    libdmraid and link the tools to it. Default is static libdmraid]),
+  [LIB_SO=$enableval], [LIB_SO=no])
 
-echo $ac_n "checking whether to disable testing with mapped devices""... $ac_c" 1>&6
 dnl Disable testing with mapped devices
-AC_ARG_ENABLE(testing, [  --disable-testing        Enable testing with mapped devices],  \
-DMRAID_TEST=$enableval, DMRAID_TEST=yes)
-
-
-echo "$ac_t""$DEBUG" 1>&6
+AC_ARG_ENABLE(testing,
+  AC_HELP_STRING([--disable-testing], [Disable testing with mapped devices]),
+  [DMRAID_TEST=$enableval], [DMRAID_TEST=yes])
+AC_MSG_CHECKING([whether to disable testing with mapped devices])
+AC_MSG_RESULT([$DMRAID_TEST])
 
 if test x$LIB_SO = xyes; then
 	FLAVOUR="shared "
@@ -146,8 +155,7 @@
 if test x$STATIC_LINK = xyes; then
 	FLAVOUR="static "
 	if test x$LIB_SO = xyes; then
-		AC_MSG_ERROR(You can' enable both shared_lib and static_link!)
-		exit 1
+		AC_MSG_ERROR([You cannot enable both shared_lib and static_link!])
 	fi
 fi
 
@@ -193,23 +201,6 @@
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(mkdir rmdir uname)
 
-dnl check for termcap (Shamelessly copied from parted 1.4.17)
-if test x$READLINE = xyes; then
-	AC_SEARCH_LIBS(tgetent, ncurses curses termcap termlib, ,
-		AC_MSG_ERROR(
-termcap could not be found which is required for the
---enable-readline option (which is enabled by default).  Either disable readline
-support with --disable-readline or download and install termcap from:
-	ftp.gnu.org/gnu/termcap
-Note: if you are using precompiled packages you will also need the development
-  package as well (which may be called termcap-devel or something similar).
-Note: (n)curses also seems to work as a substitute for termcap.  This was
-  not found either - but you could try installing that as well.
-)
-	exit
-	)
-fi
-
 dnl Klibc do not currently support getopt_long, but the test passes anyhow as
 dnl it calls gcc -E without considering CFLAGS ...
 if test x$KLIBC != xyes; then
@@ -242,8 +233,6 @@
 AC_SUBST(LD_DEPS)
 AC_SUBST(FLAVOUR)
 AC_SUBST(LIBS)
-AC_SUBST(LIBSELINUX)
-AC_SUBST(LIBSEPOL)
 AC_SUBST(LIB_SO)
 AC_SUBST(OWNER)
 AC_SUBST(SOFLAG)
@@ -251,12 +240,12 @@
 
 dnl First and last lines should not contain files to generate in order to 
 dnl keep utility scripts running properly
-AC_OUTPUT( 								\
-include/Makefile						 	\
-lib/Makefile							 	\
-man/Makefile								\
-tools/Makefile								\
-tools/version.h								\
-Makefile								\
-make.tmpl                                                               \
+AC_OUTPUT(
+include/Makefile
+lib/Makefile
+man/Makefile
+tools/Makefile
+tools/version.h
+Makefile
+make.tmpl
 )
--- dmraid/lib/Makefile.in	2010/03/18 16:53:16	1.7
+++ dmraid/lib/Makefile.in	2010/05/27 14:28:48	1.8
@@ -6,6 +6,7 @@
 
 srcdir = @srcdir@
 top_srcdir = @top_srcdir@
+top_builddir = @top_builddir@
 VPATH = @srcdir@
 
 SOURCES  = \
--- dmraid/tools/Makefile.in	2010/03/19 11:29:25	1.7
+++ dmraid/tools/Makefile.in	2010/05/27 14:28:48	1.8
@@ -6,6 +6,7 @@
 
 srcdir = @srcdir@
 top_srcdir = @top_srcdir@
+top_builddir = @top_builddir@
 VPATH = @srcdir@
 DIETLIBC = @DIETLIBC@
 KIBC = @KLIBC@
@@ -30,6 +31,8 @@
 
 DMRAIDLIBS=-ldmraid -lpthread
 
+# FIXME: use pkg-config here to get the list of needed librarie
+#  pkg-config --libs  devmapper
 ifeq ("@KLIBC@", "yes")
 	DMRAIDLIBS += -ldevmapper_klibc
 else
@@ -45,13 +48,8 @@
 		endif
 	endif
 
-	ifeq ("@LIBSELINUX@", "yes")
-		DMRAIDLIBS += -lselinux
-	endif
-
-	ifeq ("@LIBSEPOL@", "yes")
-		DMRAIDLIBS += -lsepol
-	endif
+#	DMRAIDLIBS += -lselinux
+#	DMRAIDLIBS += -lsepol
 endif
 
 # We just link klibc static and get it over with
@@ -70,7 +68,7 @@
 
 .PHONY: install_dmraid_tools remove_dmraid_tools
 
-dmraid:	$(OBJECTS) $(top_srcdir)/lib/libdmraid.a
+dmraid:	$(OBJECTS) $(top_builddir)/lib/libdmraid.a
 	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) -L$(top_srcdir)/lib \
 	      -L$(DESTDIR)$(libdir) $(DMRAIDLIBS) $(DMEVENTTOOLLIBS) $(DMRAIDLIBS) $(LIBS) 
 
