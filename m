From: zkabelac@sourceware.org
Subject: dmraid configure.in configure
Date: 30 May 2010 22:25:38 -0000
Message-ID: <20100530222538.23796.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 22:25:37

Modified files:
	.              : configure.in configure 

Log message:
	Use AC_GNU_SOURCE for _GNU_SOURCE config.h define
	Try to use AC_SYS_LARGEFILE for large file support
	(comment out  AC_DEFINE(_LARGEFILE64_SOURCE)
	Add suppport for [--with-devmapper-event-prefix=PFX]
	Add DEVMAPPEREVENT_CFLAGS

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.11&r2=1.12

--- dmraid/configure.in	2010/05/30 19:15:26	1.11
+++ dmraid/configure.in	2010/05/30 22:25:36	1.12
@@ -37,6 +37,10 @@
 AC_PROG_CC
 AC_LANG(C)
 
+AC_GNU_SOURCE
+AC_SYS_LARGEFILE
+dnl AC_DEFINE(_LARGEFILE64_SOURCE, 1, [Define to 1 if you want compile with large file.])
+
 dnl Checks for header files.
 AC_HEADER_DIRENT
 AC_HEADER_STDC
@@ -208,8 +212,6 @@
 	FLAVOUR="${FLAVOUR}debug_malloc "
 fi
 
-AC_DEFINE(_LARGEFILE64_SOURCE, 1, [Define to 1 if you want compile with large file.])
-
 dnl Mess with default exec_prefix
 test "$exec_prefix" = NONE -a "$prefix" = NONE && exec_prefix=""
 
@@ -234,11 +236,24 @@
 
 dnl FIXME static linking would need some extension here
 dnl best would be to use pkg-config in Makefiles 
+AC_ARG_WITH(devmapper-event-prefix, 
+	AC_HELP_STRING([--with-devmapper-event-prefix=PFX],
+		[Where is 'd-m-e' library installed]),
+	[DEVMAPPEREVENT_LIBS="-L$withval/lib"
+	 DEVMAPPEREVENT_CFLAGS="-I$withval/include"],
+	[DEVMAPPEREVENT_LIBS=
+	 DEVMAPPEREVENT_CFLAGS=])
+save_LDFLAGS=$LDFLAGS
+save_CPPFLAGS=$CPPFLAGS
+LDFLAGS="$LDFLAGS $DEVMAPPEREVENT_LIBS"
+CPPFLAGS="$CPPFLAGS $DEVMAPPEREVENT_CFLAGS"
 AC_CHECK_LIB(devmapper-event, dm_task_set_name,
-	[DEVMAPPEREVENT_LIBS="-ldevmapper-event"],
-	[AC_MSG_ERROR([device-mapper-event library is either missing or is too old and badly linked.])])
+	[DEVMAPPEREVENT_LIBS="$DEVMAPPEREVENT_LIBS -ldevmapper-event"],
+	[AC_MSG_ERROR([device-mapper-event library is either missing or is too old and badly linked])])
 AC_CHECK_HEADERS(libdevmapper.h libdevmapper-event.h,,
-	[AC_MSG_ERROR([Missing headers device-mapper headers.])])
+	[AC_MSG_ERROR([Missing headers device-mapper headers])])
+CPPFLAGS=$save_CPPFLAGS
+LDFLAGS=$save_LDFLAGS
 
 VERSION=$srcdir/tools/VERSION
 DMRAID_LIB_MAJOR=$(cut -d. -f1 $VERSION)
@@ -252,6 +267,7 @@
 AC_SUBST(CLDFLAGS)
 AC_SUBST(DEBUG)
 AC_SUBST(DEBUG_MALLOC)
+AC_SUBST(DEVMAPPEREVENT_CFLAGS)
 AC_SUBST(DEVMAPPEREVENT_LIBS)
 AC_SUBST(DIETLIBC)
 AC_SUBST(DMRAID_LIB_DATE)
--- dmraid/configure	2010/05/30 19:15:26	1.11
+++ dmraid/configure	2010/05/30 22:25:37	1.12
@@ -652,6 +652,7 @@
 DMRAID_LIB_DATE
 DIETLIBC
 DEVMAPPEREVENT_LIBS
+DEVMAPPEREVENT_CFLAGS
 DEBUG_MALLOC
 DEBUG
 CLDFLAGS
@@ -736,6 +737,7 @@
 ac_user_opts='
 enable_option_checking
 enable_klibc
+enable_largefile
 with_staticdir
 with_usrlibdir
 enable_debug
@@ -749,6 +751,7 @@
 enable_static_link
 enable_shared_lib
 enable_testing
+with_devmapper_event_prefix
 '
       ac_precious_vars='build_alias
 host_alias
@@ -1385,6 +1388,7 @@
   --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
   --enable-klibc          Use this to link the tools to klibc. Set KLCC to the
                           absolute file name of klcc if not in the PATH.
+  --disable-largefile     omit support for large files
   --enable-debug          Enable debugging
   --enable-debug_malloc   Enable malloc debugging
   --enable-dietlibc       Use this to link the tools to dietlibc
@@ -1406,6 +1410,8 @@
   --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
   --with-staticdir=DIR    Static binary in DIR [EPREFIX/sbin]
   --with-usrlibdir=DIR    User library in DIR [PREFIX/lib]
+  --with-devmapper-event-prefix=PFX
+                          Where is 'd-m-e' library installed
 
 Some influential environment variables:
   CC          C compiler command
@@ -3478,259 +3484,6 @@
 
 
 
-
-
-
-
-
-ac_header_dirent=no
-for ac_hdr in dirent.h sys/ndir.h sys/dir.h ndir.h; do
-  as_ac_Header=`$as_echo "ac_cv_header_dirent_$ac_hdr" | $as_tr_sh`
-{ $as_echo "$as_me:$LINENO: checking for $ac_hdr that defines DIR" >&5
-$as_echo_n "checking for $ac_hdr that defines DIR... " >&6; }
-if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
-  $as_echo_n "(cached) " >&6
-else
-  cat >conftest.$ac_ext <<_ACEOF
-/* confdefs.h.  */
-_ACEOF
-cat confdefs.h >>conftest.$ac_ext
-cat >>conftest.$ac_ext <<_ACEOF
-/* end confdefs.h.  */
-#include <sys/types.h>
-#include <$ac_hdr>
-
-int
-main ()
-{
-if ((DIR *) 0)
-return 0;
-  ;
-  return 0;
-}
-_ACEOF
-rm -f conftest.$ac_objext
-if { (ac_try="$ac_compile"
-case "(($ac_try" in
-  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
-  *) ac_try_echo=$ac_try;;
-esac
-eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
-$as_echo "$ac_try_echo") >&5
-  (eval "$ac_compile") 2>conftest.er1
-  ac_status=$?
-  grep -v '^ *+' conftest.er1 >conftest.err
-  rm -f conftest.er1
-  cat conftest.err >&5
-  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
-  (exit $ac_status); } && {
-	 test -z "$ac_c_werror_flag" ||
-	 test ! -s conftest.err
-       } && test -s conftest.$ac_objext; then
-  eval "$as_ac_Header=yes"
-else
-  $as_echo "$as_me: failed program was:" >&5
-sed 's/^/| /' conftest.$ac_ext >&5
-
-	eval "$as_ac_Header=no"
-fi
-
-rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
-fi
-ac_res=`eval 'as_val=${'$as_ac_Header'}
-		 $as_echo "$as_val"'`
-	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
-$as_echo "$ac_res" >&6; }
-as_val=`eval 'as_val=${'$as_ac_Header'}
-		 $as_echo "$as_val"'`
-   if test "x$as_val" = x""yes; then
-  cat >>confdefs.h <<_ACEOF
-#define `$as_echo "HAVE_$ac_hdr" | $as_tr_cpp` 1
-_ACEOF
-
-ac_header_dirent=$ac_hdr; break
-fi
-
-done
-# Two versions of opendir et al. are in -ldir and -lx on SCO Xenix.
-if test $ac_header_dirent = dirent.h; then
-  { $as_echo "$as_me:$LINENO: checking for library containing opendir" >&5
-$as_echo_n "checking for library containing opendir... " >&6; }
-if test "${ac_cv_search_opendir+set}" = set; then
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
-char opendir ();
-int
-main ()
-{
-return opendir ();
-  ;
-  return 0;
-}
-_ACEOF
-for ac_lib in '' dir; do
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
-  ac_cv_search_opendir=$ac_res
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
-  if test "${ac_cv_search_opendir+set}" = set; then
-  break
-fi
-done
-if test "${ac_cv_search_opendir+set}" = set; then
-  :
-else
-  ac_cv_search_opendir=no
-fi
-rm conftest.$ac_ext
-LIBS=$ac_func_search_save_LIBS
-fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_search_opendir" >&5
-$as_echo "$ac_cv_search_opendir" >&6; }
-ac_res=$ac_cv_search_opendir
-if test "$ac_res" != no; then
-  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
-
-fi
-
-else
-  { $as_echo "$as_me:$LINENO: checking for library containing opendir" >&5
-$as_echo_n "checking for library containing opendir... " >&6; }
-if test "${ac_cv_search_opendir+set}" = set; then
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
-char opendir ();
-int
-main ()
-{
-return opendir ();
-  ;
-  return 0;
-}
-_ACEOF
-for ac_lib in '' x; do
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
-  ac_cv_search_opendir=$ac_res
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
-  if test "${ac_cv_search_opendir+set}" = set; then
-  break
-fi
-done
-if test "${ac_cv_search_opendir+set}" = set; then
-  :
-else
-  ac_cv_search_opendir=no
-fi
-rm conftest.$ac_ext
-LIBS=$ac_func_search_save_LIBS
-fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_search_opendir" >&5
-$as_echo "$ac_cv_search_opendir" >&6; }
-ac_res=$ac_cv_search_opendir
-if test "$ac_res" != no; then
-  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
-
-fi
-
-fi
-
 ac_ext=c
 ac_cpp='$CPP $CPPFLAGS'
 ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
@@ -4013,94 +3766,1184 @@
   rm -f conftest.in conftest.tmp conftest.nl conftest.out;;
 esac
 
-      $ac_path_GREP_found && break 3
-    done
-  done
+      $ac_path_GREP_found && break 3
+    done
+  done
+done
+IFS=$as_save_IFS
+  if test -z "$ac_cv_path_GREP"; then
+    { { $as_echo "$as_me:$LINENO: error: no acceptable grep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&5
+$as_echo "$as_me: error: no acceptable grep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&2;}
+   { (exit 1); exit 1; }; }
+  fi
+else
+  ac_cv_path_GREP=$GREP
+fi
+
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_path_GREP" >&5
+$as_echo "$ac_cv_path_GREP" >&6; }
+ GREP="$ac_cv_path_GREP"
+
+
+{ $as_echo "$as_me:$LINENO: checking for egrep" >&5
+$as_echo_n "checking for egrep... " >&6; }
+if test "${ac_cv_path_EGREP+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  if echo a | $GREP -E '(a|b)' >/dev/null 2>&1
+   then ac_cv_path_EGREP="$GREP -E"
+   else
+     if test -z "$EGREP"; then
+  ac_path_EGREP_found=false
+  # Loop through the user's path and test for each of PROGNAME-LIST
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH$PATH_SEPARATOR/usr/xpg4/bin
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_prog in egrep; do
+    for ac_exec_ext in '' $ac_executable_extensions; do
+      ac_path_EGREP="$as_dir/$ac_prog$ac_exec_ext"
+      { test -f "$ac_path_EGREP" && $as_test_x "$ac_path_EGREP"; } || continue
+# Check for GNU ac_path_EGREP and select it if it is found.
+  # Check for GNU $ac_path_EGREP
+case `"$ac_path_EGREP" --version 2>&1` in
+*GNU*)
+  ac_cv_path_EGREP="$ac_path_EGREP" ac_path_EGREP_found=:;;
+*)
+  ac_count=0
+  $as_echo_n 0123456789 >"conftest.in"
+  while :
+  do
+    cat "conftest.in" "conftest.in" >"conftest.tmp"
+    mv "conftest.tmp" "conftest.in"
+    cp "conftest.in" "conftest.nl"
+    $as_echo 'EGREP' >> "conftest.nl"
+    "$ac_path_EGREP" 'EGREP$' < "conftest.nl" >"conftest.out" 2>/dev/null || break
+    diff "conftest.out" "conftest.nl" >/dev/null 2>&1 || break
+    ac_count=`expr $ac_count + 1`
+    if test $ac_count -gt ${ac_path_EGREP_max-0}; then
+      # Best one so far, save it but keep looking for a better one
+      ac_cv_path_EGREP="$ac_path_EGREP"
+      ac_path_EGREP_max=$ac_count
+    fi
+    # 10*(2^10) chars as input seems more than enough
+    test $ac_count -gt 10 && break
+  done
+  rm -f conftest.in conftest.tmp conftest.nl conftest.out;;
+esac
+
+      $ac_path_EGREP_found && break 3
+    done
+  done
+done
+IFS=$as_save_IFS
+  if test -z "$ac_cv_path_EGREP"; then
+    { { $as_echo "$as_me:$LINENO: error: no acceptable egrep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&5
+$as_echo "$as_me: error: no acceptable egrep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&2;}
+   { (exit 1); exit 1; }; }
+  fi
+else
+  ac_cv_path_EGREP=$EGREP
+fi
+
+   fi
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_path_EGREP" >&5
+$as_echo "$ac_cv_path_EGREP" >&6; }
+ EGREP="$ac_cv_path_EGREP"
+
+
+{ $as_echo "$as_me:$LINENO: checking for ANSI C header files" >&5
+$as_echo_n "checking for ANSI C header files... " >&6; }
+if test "${ac_cv_header_stdc+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <float.h>
+
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_header_stdc=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_header_stdc=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+
+if test $ac_cv_header_stdc = yes; then
+  # SunOS 4.x string.h does not declare mem*, contrary to ANSI.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <string.h>
+
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "memchr" >/dev/null 2>&1; then
+  :
+else
+  ac_cv_header_stdc=no
+fi
+rm -f conftest*
+
+fi
+
+if test $ac_cv_header_stdc = yes; then
+  # ISC 2.0.2 stdlib.h does not declare free, contrary to ANSI.
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <stdlib.h>
+
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "free" >/dev/null 2>&1; then
+  :
+else
+  ac_cv_header_stdc=no
+fi
+rm -f conftest*
+
+fi
+
+if test $ac_cv_header_stdc = yes; then
+  # /bin/cc in Irix-4.0.5 gets non-ANSI ctype macros unless using -ansi.
+  if test "$cross_compiling" = yes; then
+  :
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <ctype.h>
+#include <stdlib.h>
+#if ((' ' & 0x0FF) == 0x020)
+# define ISLOWER(c) ('a' <= (c) && (c) <= 'z')
+# define TOUPPER(c) (ISLOWER(c) ? 'A' + ((c) - 'a') : (c))
+#else
+# define ISLOWER(c) \
+		   (('a' <= (c) && (c) <= 'i') \
+		     || ('j' <= (c) && (c) <= 'r') \
+		     || ('s' <= (c) && (c) <= 'z'))
+# define TOUPPER(c) (ISLOWER(c) ? ((c) | 0x40) : (c))
+#endif
+
+#define XOR(e, f) (((e) && !(f)) || (!(e) && (f)))
+int
+main ()
+{
+  int i;
+  for (i = 0; i < 256; i++)
+    if (XOR (islower (i), ISLOWER (i))
+	|| toupper (i) != TOUPPER (i))
+      return 2;
+  return 0;
+}
+_ACEOF
+rm -f conftest$ac_exeext
+if { (ac_try="$ac_link"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  :
+else
+  $as_echo "$as_me: program exited with status $ac_status" >&5
+$as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_header_stdc=no
+fi
+rm -rf conftest.dSYM
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+fi
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_header_stdc" >&5
+$as_echo "$ac_cv_header_stdc" >&6; }
+if test $ac_cv_header_stdc = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define STDC_HEADERS 1
+_ACEOF
+
+fi
+
+# On IRIX 5.3, sys/types and inttypes.h are conflicting.
+
+
+
+
+
+
+
+
+
+for ac_header in sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h \
+		  inttypes.h stdint.h unistd.h
+do
+as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
+{ $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
+$as_echo_n "checking for $ac_header... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+
+#include <$ac_header>
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  eval "$as_ac_Header=yes"
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	eval "$as_ac_Header=no"
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
+as_val=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+   if test "x$as_val" = x""yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+
+done
+
+
+
+  if test "${ac_cv_header_minix_config_h+set}" = set; then
+  { $as_echo "$as_me:$LINENO: checking for minix/config.h" >&5
+$as_echo_n "checking for minix/config.h... " >&6; }
+if test "${ac_cv_header_minix_config_h+set}" = set; then
+  $as_echo_n "(cached) " >&6
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_header_minix_config_h" >&5
+$as_echo "$ac_cv_header_minix_config_h" >&6; }
+else
+  # Is the header compilable?
+{ $as_echo "$as_me:$LINENO: checking minix/config.h usability" >&5
+$as_echo_n "checking minix/config.h usability... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+#include <minix/config.h>
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_header_compiler=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_header_compiler=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+{ $as_echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+$as_echo "$ac_header_compiler" >&6; }
+
+# Is the header present?
+{ $as_echo "$as_me:$LINENO: checking minix/config.h presence" >&5
+$as_echo_n "checking minix/config.h presence... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <minix/config.h>
+_ACEOF
+if { (ac_try="$ac_cpp conftest.$ac_ext"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_cpp conftest.$ac_ext") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null && {
+	 test -z "$ac_c_preproc_warn_flag$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       }; then
+  ac_header_preproc=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  ac_header_preproc=no
+fi
+
+rm -f conftest.err conftest.$ac_ext
+{ $as_echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+$as_echo "$ac_header_preproc" >&6; }
+
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h: accepted by the compiler, rejected by the preprocessor!" >&5
+$as_echo "$as_me: WARNING: minix/config.h: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h: proceeding with the compiler's result" >&5
+$as_echo "$as_me: WARNING: minix/config.h: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h: present but cannot be compiled" >&5
+$as_echo "$as_me: WARNING: minix/config.h: present but cannot be compiled" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h:     check for missing prerequisite headers?" >&5
+$as_echo "$as_me: WARNING: minix/config.h:     check for missing prerequisite headers?" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h: see the Autoconf documentation" >&5
+$as_echo "$as_me: WARNING: minix/config.h: see the Autoconf documentation" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h:     section \"Present But Cannot Be Compiled\"" >&5
+$as_echo "$as_me: WARNING: minix/config.h:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h: proceeding with the preprocessor's result" >&5
+$as_echo "$as_me: WARNING: minix/config.h: proceeding with the preprocessor's result" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: minix/config.h: in the future, the compiler will take precedence" >&5
+$as_echo "$as_me: WARNING: minix/config.h: in the future, the compiler will take precedence" >&2;}
+
+    ;;
+esac
+{ $as_echo "$as_me:$LINENO: checking for minix/config.h" >&5
+$as_echo_n "checking for minix/config.h... " >&6; }
+if test "${ac_cv_header_minix_config_h+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_header_minix_config_h=$ac_header_preproc
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_header_minix_config_h" >&5
+$as_echo "$ac_cv_header_minix_config_h" >&6; }
+
+fi
+if test "x$ac_cv_header_minix_config_h" = x""yes; then
+  MINIX=yes
+else
+  MINIX=
+fi
+
+
+  if test "$MINIX" = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define _POSIX_SOURCE 1
+_ACEOF
+
+
+cat >>confdefs.h <<\_ACEOF
+#define _POSIX_1_SOURCE 2
+_ACEOF
+
+
+cat >>confdefs.h <<\_ACEOF
+#define _MINIX 1
+_ACEOF
+
+  fi
+
+
+
+  { $as_echo "$as_me:$LINENO: checking whether it is safe to define __EXTENSIONS__" >&5
+$as_echo_n "checking whether it is safe to define __EXTENSIONS__... " >&6; }
+if test "${ac_cv_safe_to_define___extensions__+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+#	  define __EXTENSIONS__ 1
+	  $ac_includes_default
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_safe_to_define___extensions__=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_safe_to_define___extensions__=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_safe_to_define___extensions__" >&5
+$as_echo "$ac_cv_safe_to_define___extensions__" >&6; }
+  test $ac_cv_safe_to_define___extensions__ = yes &&
+    cat >>confdefs.h <<\_ACEOF
+#define __EXTENSIONS__ 1
+_ACEOF
+
+  cat >>confdefs.h <<\_ACEOF
+#define _ALL_SOURCE 1
+_ACEOF
+
+  cat >>confdefs.h <<\_ACEOF
+#define _GNU_SOURCE 1
+_ACEOF
+
+  cat >>confdefs.h <<\_ACEOF
+#define _POSIX_PTHREAD_SEMANTICS 1
+_ACEOF
+
+  cat >>confdefs.h <<\_ACEOF
+#define _TANDEM_SOURCE 1
+_ACEOF
+
+
+# Check whether --enable-largefile was given.
+if test "${enable_largefile+set}" = set; then
+  enableval=$enable_largefile;
+fi
+
+if test "$enable_largefile" != no; then
+
+  { $as_echo "$as_me:$LINENO: checking for special C compiler options needed for large files" >&5
+$as_echo_n "checking for special C compiler options needed for large files... " >&6; }
+if test "${ac_cv_sys_largefile_CC+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_sys_largefile_CC=no
+     if test "$GCC" != yes; then
+       ac_save_CC=$CC
+       while :; do
+	 # IRIX 6.2 and later do not support large files by default,
+	 # so use the C compiler's -n32 option if that helps.
+	 cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+ /* Check that off_t can represent 2**63 - 1 correctly.
+    We can't simply define LARGE_OFF_T to be 9223372036854775807,
+    since some C++ compilers masquerading as C compilers
+    incorrectly reject 9223372036854775807.  */
+#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
+  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
+		       && LARGE_OFF_T % 2147483647 == 1)
+		      ? 1 : -1];
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+	 rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  break
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext
+	 CC="$CC -n32"
+	 rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_sys_largefile_CC=' -n32'; break
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext
+	 break
+       done
+       CC=$ac_save_CC
+       rm -f conftest.$ac_ext
+    fi
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_sys_largefile_CC" >&5
+$as_echo "$ac_cv_sys_largefile_CC" >&6; }
+  if test "$ac_cv_sys_largefile_CC" != no; then
+    CC=$CC$ac_cv_sys_largefile_CC
+  fi
+
+  { $as_echo "$as_me:$LINENO: checking for _FILE_OFFSET_BITS value needed for large files" >&5
+$as_echo_n "checking for _FILE_OFFSET_BITS value needed for large files... " >&6; }
+if test "${ac_cv_sys_file_offset_bits+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  while :; do
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+ /* Check that off_t can represent 2**63 - 1 correctly.
+    We can't simply define LARGE_OFF_T to be 9223372036854775807,
+    since some C++ compilers masquerading as C compilers
+    incorrectly reject 9223372036854775807.  */
+#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
+  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
+		       && LARGE_OFF_T % 2147483647 == 1)
+		      ? 1 : -1];
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_sys_file_offset_bits=no; break
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#define _FILE_OFFSET_BITS 64
+#include <sys/types.h>
+ /* Check that off_t can represent 2**63 - 1 correctly.
+    We can't simply define LARGE_OFF_T to be 9223372036854775807,
+    since some C++ compilers masquerading as C compilers
+    incorrectly reject 9223372036854775807.  */
+#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
+  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
+		       && LARGE_OFF_T % 2147483647 == 1)
+		      ? 1 : -1];
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_sys_file_offset_bits=64; break
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+  ac_cv_sys_file_offset_bits=unknown
+  break
+done
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_sys_file_offset_bits" >&5
+$as_echo "$ac_cv_sys_file_offset_bits" >&6; }
+case $ac_cv_sys_file_offset_bits in #(
+  no | unknown) ;;
+  *)
+cat >>confdefs.h <<_ACEOF
+#define _FILE_OFFSET_BITS $ac_cv_sys_file_offset_bits
+_ACEOF
+;;
+esac
+rm -rf conftest*
+  if test $ac_cv_sys_file_offset_bits = unknown; then
+    { $as_echo "$as_me:$LINENO: checking for _LARGE_FILES value needed for large files" >&5
+$as_echo_n "checking for _LARGE_FILES value needed for large files... " >&6; }
+if test "${ac_cv_sys_large_files+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  while :; do
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+ /* Check that off_t can represent 2**63 - 1 correctly.
+    We can't simply define LARGE_OFF_T to be 9223372036854775807,
+    since some C++ compilers masquerading as C compilers
+    incorrectly reject 9223372036854775807.  */
+#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
+  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
+		       && LARGE_OFF_T % 2147483647 == 1)
+		      ? 1 : -1];
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_sys_large_files=no; break
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#define _LARGE_FILES 1
+#include <sys/types.h>
+ /* Check that off_t can represent 2**63 - 1 correctly.
+    We can't simply define LARGE_OFF_T to be 9223372036854775807,
+    since some C++ compilers masquerading as C compilers
+    incorrectly reject 9223372036854775807.  */
+#define LARGE_OFF_T (((off_t) 1 << 62) - 1 + ((off_t) 1 << 62))
+  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
+		       && LARGE_OFF_T % 2147483647 == 1)
+		      ? 1 : -1];
+int
+main ()
+{
+
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_sys_large_files=1; break
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+  ac_cv_sys_large_files=unknown
+  break
+done
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_sys_large_files" >&5
+$as_echo "$ac_cv_sys_large_files" >&6; }
+case $ac_cv_sys_large_files in #(
+  no | unknown) ;;
+  *)
+cat >>confdefs.h <<_ACEOF
+#define _LARGE_FILES $ac_cv_sys_large_files
+_ACEOF
+;;
+esac
+rm -rf conftest*
+  fi
+fi
+
+
+
+
+
+
+
+ac_header_dirent=no
+for ac_hdr in dirent.h sys/ndir.h sys/dir.h ndir.h; do
+  as_ac_Header=`$as_echo "ac_cv_header_dirent_$ac_hdr" | $as_tr_sh`
+{ $as_echo "$as_me:$LINENO: checking for $ac_hdr that defines DIR" >&5
+$as_echo_n "checking for $ac_hdr that defines DIR... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <$ac_hdr>
+
+int
+main ()
+{
+if ((DIR *) 0)
+return 0;
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  eval "$as_ac_Header=yes"
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	eval "$as_ac_Header=no"
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
+as_val=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+   if test "x$as_val" = x""yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_hdr" | $as_tr_cpp` 1
+_ACEOF
+
+ac_header_dirent=$ac_hdr; break
+fi
+
+done
+# Two versions of opendir et al. are in -ldir and -lx on SCO Xenix.
+if test $ac_header_dirent = dirent.h; then
+  { $as_echo "$as_me:$LINENO: checking for library containing opendir" >&5
+$as_echo_n "checking for library containing opendir... " >&6; }
+if test "${ac_cv_search_opendir+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_func_search_save_LIBS=$LIBS
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char opendir ();
+int
+main ()
+{
+return opendir ();
+  ;
+  return 0;
+}
+_ACEOF
+for ac_lib in '' dir; do
+  if test -z "$ac_lib"; then
+    ac_res="none required"
+  else
+    ac_res=-l$ac_lib
+    LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
+  fi
+  rm -f conftest.$ac_objext conftest$ac_exeext
+if { (ac_try="$ac_link"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext && {
+	 test "$cross_compiling" = yes ||
+	 $as_test_x conftest$ac_exeext
+       }; then
+  ac_cv_search_opendir=$ac_res
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext
+  if test "${ac_cv_search_opendir+set}" = set; then
+  break
+fi
 done
-IFS=$as_save_IFS
-  if test -z "$ac_cv_path_GREP"; then
-    { { $as_echo "$as_me:$LINENO: error: no acceptable grep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&5
-$as_echo "$as_me: error: no acceptable grep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&2;}
-   { (exit 1); exit 1; }; }
-  fi
+if test "${ac_cv_search_opendir+set}" = set; then
+  :
 else
-  ac_cv_path_GREP=$GREP
+  ac_cv_search_opendir=no
 fi
-
+rm conftest.$ac_ext
+LIBS=$ac_func_search_save_LIBS
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_path_GREP" >&5
-$as_echo "$ac_cv_path_GREP" >&6; }
- GREP="$ac_cv_path_GREP"
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_search_opendir" >&5
+$as_echo "$ac_cv_search_opendir" >&6; }
+ac_res=$ac_cv_search_opendir
+if test "$ac_res" != no; then
+  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
 
+fi
 
-{ $as_echo "$as_me:$LINENO: checking for egrep" >&5
-$as_echo_n "checking for egrep... " >&6; }
-if test "${ac_cv_path_EGREP+set}" = set; then
+else
+  { $as_echo "$as_me:$LINENO: checking for library containing opendir" >&5
+$as_echo_n "checking for library containing opendir... " >&6; }
+if test "${ac_cv_search_opendir+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
-  if echo a | $GREP -E '(a|b)' >/dev/null 2>&1
-   then ac_cv_path_EGREP="$GREP -E"
-   else
-     if test -z "$EGREP"; then
-  ac_path_EGREP_found=false
-  # Loop through the user's path and test for each of PROGNAME-LIST
-  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
-for as_dir in $PATH$PATH_SEPARATOR/usr/xpg4/bin
-do
-  IFS=$as_save_IFS
-  test -z "$as_dir" && as_dir=.
-  for ac_prog in egrep; do
-    for ac_exec_ext in '' $ac_executable_extensions; do
-      ac_path_EGREP="$as_dir/$ac_prog$ac_exec_ext"
-      { test -f "$ac_path_EGREP" && $as_test_x "$ac_path_EGREP"; } || continue
-# Check for GNU ac_path_EGREP and select it if it is found.
-  # Check for GNU $ac_path_EGREP
-case `"$ac_path_EGREP" --version 2>&1` in
-*GNU*)
-  ac_cv_path_EGREP="$ac_path_EGREP" ac_path_EGREP_found=:;;
-*)
-  ac_count=0
-  $as_echo_n 0123456789 >"conftest.in"
-  while :
-  do
-    cat "conftest.in" "conftest.in" >"conftest.tmp"
-    mv "conftest.tmp" "conftest.in"
-    cp "conftest.in" "conftest.nl"
-    $as_echo 'EGREP' >> "conftest.nl"
-    "$ac_path_EGREP" 'EGREP$' < "conftest.nl" >"conftest.out" 2>/dev/null || break
-    diff "conftest.out" "conftest.nl" >/dev/null 2>&1 || break
-    ac_count=`expr $ac_count + 1`
-    if test $ac_count -gt ${ac_path_EGREP_max-0}; then
-      # Best one so far, save it but keep looking for a better one
-      ac_cv_path_EGREP="$ac_path_EGREP"
-      ac_path_EGREP_max=$ac_count
-    fi
-    # 10*(2^10) chars as input seems more than enough
-    test $ac_count -gt 10 && break
-  done
-  rm -f conftest.in conftest.tmp conftest.nl conftest.out;;
+  ac_func_search_save_LIBS=$LIBS
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char opendir ();
+int
+main ()
+{
+return opendir ();
+  ;
+  return 0;
+}
+_ACEOF
+for ac_lib in '' x; do
+  if test -z "$ac_lib"; then
+    ac_res="none required"
+  else
+    ac_res=-l$ac_lib
+    LIBS="-l$ac_lib  $ac_func_search_save_LIBS"
+  fi
+  rm -f conftest.$ac_objext conftest$ac_exeext
+if { (ac_try="$ac_link"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
 esac
+eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
+$as_echo "$ac_try_echo") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext && {
+	 test "$cross_compiling" = yes ||
+	 $as_test_x conftest$ac_exeext
+       }; then
+  ac_cv_search_opendir=$ac_res
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
 
-      $ac_path_EGREP_found && break 3
-    done
-  done
+
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext
+  if test "${ac_cv_search_opendir+set}" = set; then
+  break
+fi
 done
-IFS=$as_save_IFS
-  if test -z "$ac_cv_path_EGREP"; then
-    { { $as_echo "$as_me:$LINENO: error: no acceptable egrep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&5
-$as_echo "$as_me: error: no acceptable egrep could be found in $PATH$PATH_SEPARATOR/usr/xpg4/bin" >&2;}
-   { (exit 1); exit 1; }; }
-  fi
+if test "${ac_cv_search_opendir+set}" = set; then
+  :
 else
-  ac_cv_path_EGREP=$EGREP
+  ac_cv_search_opendir=no
+fi
+rm conftest.$ac_ext
+LIBS=$ac_func_search_save_LIBS
 fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_search_opendir" >&5
+$as_echo "$ac_cv_search_opendir" >&6; }
+ac_res=$ac_cv_search_opendir
+if test "$ac_res" != no; then
+  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
 
-   fi
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_path_EGREP" >&5
-$as_echo "$ac_cv_path_EGREP" >&6; }
- EGREP="$ac_cv_path_EGREP"
 
+fi
 
 { $as_echo "$as_me:$LINENO: checking for ANSI C header files" >&5
 $as_echo_n "checking for ANSI C header files... " >&6; }
@@ -4342,79 +5185,6 @@
 
 fi
 
-# On IRIX 5.3, sys/types and inttypes.h are conflicting.
-
-
-
-
-
-
-
-
-
-for ac_header in sys/types.h sys/stat.h stdlib.h string.h memory.h strings.h \
-		  inttypes.h stdint.h unistd.h
-do
-as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
-{ $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
-$as_echo_n "checking for $ac_header... " >&6; }
-if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
-  $as_echo_n "(cached) " >&6
-else
-  cat >conftest.$ac_ext <<_ACEOF
-/* confdefs.h.  */
-_ACEOF
-cat confdefs.h >>conftest.$ac_ext
-cat >>conftest.$ac_ext <<_ACEOF
-/* end confdefs.h.  */
-$ac_includes_default
-
-#include <$ac_header>
-_ACEOF
-rm -f conftest.$ac_objext
-if { (ac_try="$ac_compile"
-case "(($ac_try" in
-  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
-  *) ac_try_echo=$ac_try;;
-esac
-eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
-$as_echo "$ac_try_echo") >&5
-  (eval "$ac_compile") 2>conftest.er1
-  ac_status=$?
-  grep -v '^ *+' conftest.er1 >conftest.err
-  rm -f conftest.er1
-  cat conftest.err >&5
-  $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
-  (exit $ac_status); } && {
-	 test -z "$ac_c_werror_flag" ||
-	 test ! -s conftest.err
-       } && test -s conftest.$ac_objext; then
-  eval "$as_ac_Header=yes"
-else
-  $as_echo "$as_me: failed program was:" >&5
-sed 's/^/| /' conftest.$ac_ext >&5
-
-	eval "$as_ac_Header=no"
-fi
-
-rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
-fi
-ac_res=`eval 'as_val=${'$as_ac_Header'}
-		 $as_echo "$as_val"'`
-	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
-$as_echo "$ac_res" >&6; }
-as_val=`eval 'as_val=${'$as_ac_Header'}
-		 $as_echo "$as_val"'`
-   if test "x$as_val" = x""yes; then
-  cat >>confdefs.h <<_ACEOF
-#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
-_ACEOF
-
-fi
-
-done
-
-
 
 
 
@@ -6552,12 +7322,6 @@
 	FLAVOUR="${FLAVOUR}debug_malloc "
 fi
 
-
-cat >>confdefs.h <<\_ACEOF
-#define _LARGEFILE64_SOURCE 1
-_ACEOF
-
-
 test "$exec_prefix" = NONE -a "$prefix" = NONE && exec_prefix=""
 
 if test $ac_cv_c_compiler_gnu = yes; then
@@ -8150,6 +8914,20 @@
 
 fi
 
+
+# Check whether --with-devmapper-event-prefix was given.
+if test "${with_devmapper_event_prefix+set}" = set; then
+  withval=$with_devmapper_event_prefix; DEVMAPPEREVENT_LIBS="-L$withval/lib"
+	 DEVMAPPEREVENT_CFLAGS="-I$withval/include"
+else
+  DEVMAPPEREVENT_LIBS=
+	 DEVMAPPEREVENT_CFLAGS=
+fi
+
+save_LDFLAGS=$LDFLAGS
+save_CPPFLAGS=$CPPFLAGS
+LDFLAGS="$LDFLAGS $DEVMAPPEREVENT_LIBS"
+CPPFLAGS="$CPPFLAGS $DEVMAPPEREVENT_CFLAGS"
 { $as_echo "$as_me:$LINENO: checking for dm_task_set_name in -ldevmapper-event" >&5
 $as_echo_n "checking for dm_task_set_name in -ldevmapper-event... " >&6; }
 if test "${ac_cv_lib_devmapper_event_dm_task_set_name+set}" = set; then
@@ -8216,10 +8994,10 @@
 { $as_echo "$as_me:$LINENO: result: $ac_cv_lib_devmapper_event_dm_task_set_name" >&5
 $as_echo "$ac_cv_lib_devmapper_event_dm_task_set_name" >&6; }
 if test "x$ac_cv_lib_devmapper_event_dm_task_set_name" = x""yes; then
-  DEVMAPPEREVENT_LIBS="-ldevmapper-event"
+  DEVMAPPEREVENT_LIBS="$DEVMAPPEREVENT_LIBS -ldevmapper-event"
 else
-  { { $as_echo "$as_me:$LINENO: error: device-mapper-event library is either missing or is too old and badly linked." >&5
-$as_echo "$as_me: error: device-mapper-event library is either missing or is too old and badly linked." >&2;}
+  { { $as_echo "$as_me:$LINENO: error: device-mapper-event library is either missing or is too old and badly linked" >&5
+$as_echo "$as_me: error: device-mapper-event library is either missing or is too old and badly linked" >&2;}
    { (exit 1); exit 1; }; }
 fi
 
@@ -8367,13 +9145,15 @@
 _ACEOF
 
 else
-  { { $as_echo "$as_me:$LINENO: error: Missing headers device-mapper headers." >&5
-$as_echo "$as_me: error: Missing headers device-mapper headers." >&2;}
+  { { $as_echo "$as_me:$LINENO: error: Missing headers device-mapper headers" >&5
+$as_echo "$as_me: error: Missing headers device-mapper headers" >&2;}
    { (exit 1); exit 1; }; }
 fi
 
 done
 
+CPPFLAGS=$save_CPPFLAGS
+LDFLAGS=$save_LDFLAGS
 
 VERSION=$srcdir/tools/VERSION
 DMRAID_LIB_MAJOR=$(cut -d. -f1 $VERSION)
@@ -8404,6 +9184,7 @@
 
 
 
+
 ac_config_files="$ac_config_files include/Makefile lib/Makefile lib/version.h man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
 
 cat >confcache <<\_ACEOF
