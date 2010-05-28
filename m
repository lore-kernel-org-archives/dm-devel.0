From: zkabelac@sourceware.org
Subject: dmraid configure configure.in
Date: 28 May 2010 12:25:55 -0000
Message-ID: <20100528122555.12731.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 12:25:55

Modified files:
	.              : configure configure.in 

Log message:
	Add SED detection
	Add --with-staticdir
	Add --with-usrlibdir
	Remove default prefix change to /usr/share - keep /usr/local

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.7&r2=1.8

--- dmraid/configure	2010/05/27 20:59:44	1.7
+++ dmraid/configure	2010/05/28 12:25:54	1.8
@@ -635,9 +635,10 @@
 # include <unistd.h>
 #endif"
 
-ac_default_prefix=/usr/share
 ac_subst_vars='LTLIBOBJS
 LIBOBJS
+staticdir
+usrlibdir
 STATIC_LINK
 SOFLAG
 LIB_SO
@@ -675,6 +676,7 @@
 INSTALL_SCRIPT
 INSTALL_PROGRAM
 AWK
+SED
 target_os
 target_vendor
 target_cpu
@@ -728,6 +730,8 @@
 ac_user_opts='
 enable_option_checking
 enable_klibc
+with_staticdir
+with_usrlibdir
 enable_debug
 enable_debug_malloc
 enable_dietlibc
@@ -1391,6 +1395,12 @@
                           tools to it. Default is static libdmraid
   --disable-testing       Disable testing with mapped devices
 
+Optional Packages:
+  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
+  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
+  --with-staticdir=DIR    Static binary in DIR [EPREFIX/sbin]
+  --with-usrlibdir=DIR    User library in DIR [PREFIX/lib]
+
 Some influential environment variables:
   CC          C compiler command
   CFLAGS      C compiler flags
@@ -2000,6 +2010,77 @@
     NONENONEs,x,x, &&
   program_prefix=${target_alias}-
 
+{ $as_echo "$as_me:$LINENO: checking for a sed that does not truncate output" >&5
+$as_echo_n "checking for a sed that does not truncate output... " >&6; }
+if test "${ac_cv_path_SED+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+            ac_script=s/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb/
+     for ac_i in 1 2 3 4 5 6 7; do
+       ac_script="$ac_script$as_nl$ac_script"
+     done
+     echo "$ac_script" 2>/dev/null | sed 99q >conftest.sed
+     $as_unset ac_script || ac_script=
+     if test -z "$SED"; then
+  ac_path_SED_found=false
+  # Loop through the user's path and test for each of PROGNAME-LIST
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_prog in sed gsed; do
+    for ac_exec_ext in '' $ac_executable_extensions; do
+      ac_path_SED="$as_dir/$ac_prog$ac_exec_ext"
+      { test -f "$ac_path_SED" && $as_test_x "$ac_path_SED"; } || continue
+# Check for GNU ac_path_SED and select it if it is found.
+  # Check for GNU $ac_path_SED
+case `"$ac_path_SED" --version 2>&1` in
+*GNU*)
+  ac_cv_path_SED="$ac_path_SED" ac_path_SED_found=:;;
+*)
+  ac_count=0
+  $as_echo_n 0123456789 >"conftest.in"
+  while :
+  do
+    cat "conftest.in" "conftest.in" >"conftest.tmp"
+    mv "conftest.tmp" "conftest.in"
+    cp "conftest.in" "conftest.nl"
+    $as_echo '' >> "conftest.nl"
+    "$ac_path_SED" -f conftest.sed < "conftest.nl" >"conftest.out" 2>/dev/null || break
+    diff "conftest.out" "conftest.nl" >/dev/null 2>&1 || break
+    ac_count=`expr $ac_count + 1`
+    if test $ac_count -gt ${ac_path_SED_max-0}; then
+      # Best one so far, save it but keep looking for a better one
+      ac_cv_path_SED="$ac_path_SED"
+      ac_path_SED_max=$ac_count
+    fi
+    # 10*(2^10) chars as input seems more than enough
+    test $ac_count -gt 10 && break
+  done
+  rm -f conftest.in conftest.tmp conftest.nl conftest.out;;
+esac
+
+      $ac_path_SED_found && break 3
+    done
+  done
+done
+IFS=$as_save_IFS
+  if test -z "$ac_cv_path_SED"; then
+    { { $as_echo "$as_me:$LINENO: error: no acceptable sed could be found in \$PATH" >&5
+$as_echo "$as_me: error: no acceptable sed could be found in \$PATH" >&2;}
+   { (exit 1); exit 1; }; }
+  fi
+else
+  ac_cv_path_SED=$SED
+fi
+
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_path_SED" >&5
+$as_echo "$ac_cv_path_SED" >&6; }
+ SED="$ac_cv_path_SED"
+  rm -f conftest.sed
+
 for ac_prog in gawk mawk nawk awk
 do
   # Extract the first word of "$ac_prog", so it can be a program name with args.
@@ -5227,6 +5308,23 @@
 
 
 
+# Check whether --with-staticdir was given.
+if test "${with_staticdir+set}" = set; then
+  withval=$with_staticdir; staticdir=$withval
+else
+  staticdir='${exec_prefix}/sbin'
+fi
+
+
+
+# Check whether --with-usrlibdir was given.
+if test "${with_usrlibdir+set}" = set; then
+  withval=$with_usrlibdir; usrlibdir=$withval
+else
+  usrlibdir='${prefix}/lib'
+fi
+
+
 # Check whether --enable-debug was given.
 if test "${enable_debug+set}" = set; then
   enableval=$enable_debug; DEBUG=$enableval
@@ -5961,6 +6059,8 @@
 
 
 
+
+
 ac_config_files="$ac_config_files include/Makefile lib/Makefile man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
 
 cat >confcache <<\_ACEOF
--- dmraid/configure.in	2010/05/27 20:59:45	1.7
+++ dmraid/configure.in	2010/05/28 12:25:54	1.8
@@ -16,6 +16,7 @@
 AC_CANONICAL_SYSTEM
 
 dnl Checks for programs.
+AC_PROG_SED
 AC_PROG_AWK
 AC_PROG_INSTALL
 AC_PROG_LN_S
@@ -60,8 +61,16 @@
 	esac
 fi
 
-dnl -- prefix is /usr by default, the exec_prefix default is setup later
-AC_PREFIX_DEFAULT(/usr/share)
+dnl -- prefix is /usr/local by default, the exec_prefix default is setup later
+dnl AC_PREFIX_DEFAULT(/usr/share)
+
+AC_ARG_WITH(staticdir,
+  AC_HELP_STRING([--with-staticdir=DIR], [Static binary in DIR [[EPREFIX/sbin]]]),
+  [staticdir=$withval], [staticdir='${exec_prefix}/sbin'])
+
+AC_ARG_WITH(usrlibdir,
+  AC_HELP_STRING([--with-usrlibdir=DIR], [User library in DIR [[PREFIX/lib]]]),
+  [usrlibdir=$withval], [usrlibdir='${prefix}/lib'])
 
 dnl Enable Debugging
 AC_ARG_ENABLE(debug, 
@@ -212,6 +221,8 @@
 AC_SUBST(LIB_SO)
 AC_SUBST(SOFLAG)
 AC_SUBST(STATIC_LINK)
+AC_SUBST(usrlibdir)
+AC_SUBST(staticdir)
 
 dnl First and last lines should not contain files to generate in order to 
 dnl keep utility scripts running properly
