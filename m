From: zkabelac@sourceware.org
Subject: dmraid ./configure ./configure.in include/conf ...
Date: 29 May 2010 21:31:36 -0000
Message-ID: <20100529213136.29335.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-29 21:31:35

Modified files:
	.              : configure configure.in 
Added files:
	include        : config.h.in 

Log message:
	Add AC_PREREQ(2.57)
	Add include/config.h.in
	Add missing AC_TYPE/AC_CHECK_HEADERS/AC_FUNC reported by autoscan
	Switch from using -D flags to CFLAGS to config.h
	Remove DMRAID_VERSION and DMRAID_LIB_VERSION from AC_SUBST
	Replace AC_CANNONICAL_SYSTEM with AC_CANONICAL_TARGET
	Add AC_CANONICAL_HOST
	Use "$VAR" instead of x$VAR
	Remove some spaces at EOL

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/config.h.in.diff?cvsroot=dm&r1=NONE&r2=1.1
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.8&r2=1.9
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.8&r2=1.9

/cvs/dm/dmraid/include/config.h.in,v  -->  standard output
revision 1.1
--- dmraid/include/config.h.in
+++ -	2010-05-29 21:31:36.476767000 +0000
@@ -0,0 +1,247 @@
+/* include/config.h.in.  Generated from configure.in by autoheader.  */
+
+/* Define to 1 if you want Intel LED support. */
+#undef DMRAID_INTEL_LED
+
+/* Define to 1 if you want LED support. */
+#undef DMRAID_LED
+
+/* Define to 1 if you to create a minimal binary. */
+#undef DMRAID_MINI
+
+/* Define to 1 if you want native metadata logging. */
+#undef DMRAID_NATIVE_LOG
+
+/* Define to 1 if you want to test mapped devices. */
+#undef DMRAID_TEST
+
+/* Define to 1 if you have the <dirent.h> header file, and it defines `DIR'.
+   */
+#undef HAVE_DIRENT_H
+
+/* Define to 1 if you don't have `vprintf' but do have `_doprnt.' */
+#undef HAVE_DOPRNT
+
+/* Define to 1 if you have the <fcntl.h> header file. */
+#undef HAVE_FCNTL_H
+
+/* Define to 1 if you have the `getmntent' function. */
+#undef HAVE_GETMNTENT
+
+/* Define to 1 for longopt. */
+#undef HAVE_GETOPTLONG
+
+/* Define to 1 if you have the <getopt.h> header file. */
+#undef HAVE_GETOPT_H
+
+/* Define to 1 if you have the <inttypes.h> header file. */
+#undef HAVE_INTTYPES_H
+
+/* Define to 1 if you have the <limits.h> header file. */
+#undef HAVE_LIMITS_H
+
+/* Define to 1 if your system has a GNU libc compatible `malloc' function, and
+   to 0 otherwise. */
+#undef HAVE_MALLOC
+
+/* Define to 1 if you have the <malloc.h> header file. */
+#undef HAVE_MALLOC_H
+
+/* Define to 1 if you have the `memmove' function. */
+#undef HAVE_MEMMOVE
+
+/* Define to 1 if you have the <memory.h> header file. */
+#undef HAVE_MEMORY_H
+
+/* Define to 1 if you have the `memset' function. */
+#undef HAVE_MEMSET
+
+/* Define to 1 if you have the `mkdir' function. */
+#undef HAVE_MKDIR
+
+/* Define to 1 if you have the <mntent.h> header file. */
+#undef HAVE_MNTENT_H
+
+/* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
+#undef HAVE_NDIR_H
+
+/* Define to 1 if you have the <netinet/in.h> header file. */
+#undef HAVE_NETINET_IN_H
+
+/* Define to 1 if you have the <paths.h> header file. */
+#undef HAVE_PATHS_H
+
+/* Define to 1 if your system has a GNU libc compatible `realloc' function,
+   and to 0 otherwise. */
+#undef HAVE_REALLOC
+
+/* Define to 1 if you have the `rmdir' function. */
+#undef HAVE_RMDIR
+
+/* Define to 1 if you have the <stdint.h> header file. */
+#undef HAVE_STDINT_H
+
+/* Define to 1 if you have the <stdlib.h> header file. */
+#undef HAVE_STDLIB_H
+
+/* Define to 1 if you have the `strchr' function. */
+#undef HAVE_STRCHR
+
+/* Define to 1 if you have the `strerror' function. */
+#undef HAVE_STRERROR
+
+/* Define to 1 if you have the <strings.h> header file. */
+#undef HAVE_STRINGS_H
+
+/* Define to 1 if you have the <string.h> header file. */
+#undef HAVE_STRING_H
+
+/* Define to 1 if you have the `strpbrk' function. */
+#undef HAVE_STRPBRK
+
+/* Define to 1 if you have the `strrchr' function. */
+#undef HAVE_STRRCHR
+
+/* Define to 1 if you have the `strstr' function. */
+#undef HAVE_STRSTR
+
+/* Define to 1 if `st_rdev' is member of `struct stat'. */
+#undef HAVE_STRUCT_STAT_ST_RDEV
+
+/* Define to 1 if your `struct stat' has `st_rdev'. Deprecated, use
+   `HAVE_STRUCT_STAT_ST_RDEV' instead. */
+#undef HAVE_ST_RDEV
+
+/* Define to 1 if you have the <syslog.h> header file. */
+#undef HAVE_SYSLOG_H
+
+/* Define to 1 if you have the <sys/dir.h> header file, and it defines `DIR'.
+   */
+#undef HAVE_SYS_DIR_H
+
+/* Define to 1 if you have the <sys/file.h> header file. */
+#undef HAVE_SYS_FILE_H
+
+/* Define to 1 if you have the <sys/ioctl.h> header file. */
+#undef HAVE_SYS_IOCTL_H
+
+/* Define to 1 if you have the <sys/ndir.h> header file, and it defines `DIR'.
+   */
+#undef HAVE_SYS_NDIR_H
+
+/* Define to 1 if you have the <sys/stat.h> header file. */
+#undef HAVE_SYS_STAT_H
+
+/* Define to 1 if you have the <sys/types.h> header file. */
+#undef HAVE_SYS_TYPES_H
+
+/* Define to 1 if you have the `uname' function. */
+#undef HAVE_UNAME
+
+/* Define to 1 if you have the <unistd.h> header file. */
+#undef HAVE_UNISTD_H
+
+/* Define to 1 if you have the `vprintf' function. */
+#undef HAVE_VPRINTF
+
+/* Define to 1 if `lstat' dereferences a symlink specified with a trailing
+   slash. */
+#undef LSTAT_FOLLOWS_SLASHED_SYMLINK
+
+/* Define to the address where bug reports for this package should be sent. */
+#undef PACKAGE_BUGREPORT
+
+/* Define to the full name of this package. */
+#undef PACKAGE_NAME
+
+/* Define to the full name and version of this package. */
+#undef PACKAGE_STRING
+
+/* Define to the one symbol short name of this package. */
+#undef PACKAGE_TARNAME
+
+/* Define to the version of this package. */
+#undef PACKAGE_VERSION
+
+/* Define as the return type of signal handlers (`int' or `void'). */
+#undef RETSIGTYPE
+
+/* Define to 1 if you have the ANSI C header files. */
+#undef STDC_HEADERS
+
+/* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
+#undef TIME_WITH_SYS_TIME
+
+/* Define for Solaris 2.5.1 so the uint32_t typedef from <sys/synch.h>,
+   <pthread.h>, or <semaphore.h> is not used. If the typedef were allowed, the
+   #define below would cause a syntax error. */
+#undef _UINT32_T
+
+/* Define for Solaris 2.5.1 so the uint64_t typedef from <sys/synch.h>,
+   <pthread.h>, or <semaphore.h> is not used. If the typedef were allowed, the
+   #define below would cause a syntax error. */
+#undef _UINT64_T
+
+/* Define for Solaris 2.5.1 so the uint8_t typedef from <sys/synch.h>,
+   <pthread.h>, or <semaphore.h> is not used. If the typedef were allowed, the
+   #define below would cause a syntax error. */
+#undef _UINT8_T
+
+/* Define to empty if `const' does not conform to ANSI C. */
+#undef const
+
+/* Define to `__inline__' or `__inline' if that's what the C compiler
+   calls it, or to nothing if 'inline' is not supported under any name.  */
+#ifndef __cplusplus
+#undef inline
+#endif
+
+/* Define to the type of a signed integer type of width exactly 16 bits if
+   such a type exists and the standard includes do not define it. */
+#undef int16_t
+
+/* Define to the type of a signed integer type of width exactly 32 bits if
+   such a type exists and the standard includes do not define it. */
+#undef int32_t
+
+/* Define to the type of a signed integer type of width exactly 64 bits if
+   such a type exists and the standard includes do not define it. */
+#undef int64_t
+
+/* Define to the type of a signed integer type of width exactly 8 bits if such
+   a type exists and the standard includes do not define it. */
+#undef int8_t
+
+/* Define to rpl_malloc if the replacement function should be used. */
+#undef malloc
+
+/* Define to `int' if <sys/types.h> does not define. */
+#undef mode_t
+
+/* Define to `long int' if <sys/types.h> does not define. */
+#undef off_t
+
+/* Define to `int' if <sys/types.h> does not define. */
+#undef pid_t
+
+/* Define to rpl_realloc if the replacement function should be used. */
+#undef realloc
+
+/* Define to `unsigned int' if <sys/types.h> does not define. */
+#undef size_t
+
+/* Define to the type of an unsigned integer type of width exactly 16 bits if
+   such a type exists and the standard includes do not define it. */
+#undef uint16_t
+
+/* Define to the type of an unsigned integer type of width exactly 32 bits if
+   such a type exists and the standard includes do not define it. */
+#undef uint32_t
+
+/* Define to the type of an unsigned integer type of width exactly 64 bits if
+   such a type exists and the standard includes do not define it. */
+#undef uint64_t
+
+/* Define to the type of an unsigned integer type of width exactly 8 bits if
+   such a type exists and the standard includes do not define it. */
+#undef uint8_t
--- dmraid/configure	2010/05/28 12:25:54	1.8
+++ dmraid/configure	2010/05/29 21:31:35	1.9
@@ -598,6 +598,7 @@
 PACKAGE_STRING=
 PACKAGE_BUGREPORT=
 
+ac_unique_file="dmraid"
 ac_unique_file="lib/device/dev-io.h"
 # Factoring default headers for most tests.
 ac_includes_default="\
@@ -636,7 +637,6 @@
 #endif"
 
 ac_subst_vars='LTLIBOBJS
-LIBOBJS
 staticdir
 usrlibdir
 STATIC_LINK
@@ -646,11 +646,11 @@
 LD_DEPS
 JOBS
 DIETLIBC
-DMRAID_LIB_VERSION
-DMRAID_VERSION
 DEBUG_MALLOC
 DEBUG
 CLDFLAGS
+POW_LIB
+LIBOBJS
 EGREP
 GREP
 CPP
@@ -1851,6 +1851,7 @@
 
 
 
+
 ac_aux_dir=
 for ac_dir in autoconf "$srcdir"/autoconf; do
   if test -f "$ac_dir/install-sh"; then
@@ -1882,6 +1883,8 @@
 ac_configure="$SHELL $ac_aux_dir/configure"  # Please don't use this var.
 
 
+ac_config_headers="$ac_config_headers include/config.h:include/config.h.in"
+
 
 # Make sure we can run config.sub.
 $SHELL "$ac_aux_dir/config.sub" sun4 >/dev/null 2>&1 ||
@@ -3461,6 +3464,12 @@
 ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
 ac_compiler_gnu=$ac_cv_c_compiler_gnu
 
+ac_ext=c
+ac_cpp='$CPP $CPPFLAGS'
+ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
+ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
+ac_compiler_gnu=$ac_cv_c_compiler_gnu
+
 
 
 
@@ -4265,6 +4274,68 @@
 
 fi
 
+{ $as_echo "$as_me:$LINENO: checking whether time.h and sys/time.h may both be included" >&5
+$as_echo_n "checking whether time.h and sys/time.h may both be included... " >&6; }
+if test "${ac_cv_header_time+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <sys/time.h>
+#include <time.h>
+
+int
+main ()
+{
+if ((struct tm *) 0)
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
+  ac_cv_header_time=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_header_time=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_header_time" >&5
+$as_echo "$ac_cv_header_time" >&6; }
+if test $ac_cv_header_time = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define TIME_WITH_SYS_TIME 1
+_ACEOF
+
+fi
+
 # On IRIX 5.3, sys/types and inttypes.h are conflicting.
 
 
@@ -4341,7 +4412,158 @@
 
 
 
-for ac_header in fcntl.h sys/ioctl.h unistd.h
+
+
+
+for ac_header in fcntl.h limits.h mntent.h paths.h sys/file.h sys/ioctl.h
+do
+as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  { $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
+$as_echo_n "checking for $ac_header... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
+fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
+else
+  # Is the header compilable?
+{ $as_echo "$as_me:$LINENO: checking $ac_header usability" >&5
+$as_echo_n "checking $ac_header usability... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
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
+{ $as_echo "$as_me:$LINENO: checking $ac_header presence" >&5
+$as_echo_n "checking $ac_header presence... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <$ac_header>
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
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+$as_echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+$as_echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+$as_echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+$as_echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+$as_echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+$as_echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+$as_echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+$as_echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
+
+    ;;
+esac
+{ $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
+$as_echo_n "checking for $ac_header... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
+else
+  eval "$as_ac_Header=\$ac_header_preproc"
+fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
+
+fi
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
+
+for ac_header in netinet/in.h syslog.h unistd.h
 do
 as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
@@ -4486,7 +4708,8 @@
 
 done
 
-if test x$KLIBC != xyes; then
+
+if test "$KLIBC" = yes; then
 
 for ac_header in malloc.h
 do
@@ -4812,13 +5035,16 @@
     ;;
 esac
 
-{ $as_echo "$as_me:$LINENO: checking for off_t" >&5
-$as_echo_n "checking for off_t... " >&6; }
-if test "${ac_cv_type_off_t+set}" = set; then
+
+  { $as_echo "$as_me:$LINENO: checking for int16_t" >&5
+$as_echo_n "checking for int16_t... " >&6; }
+if test "${ac_cv_c_int16_t+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
-  ac_cv_type_off_t=no
-cat >conftest.$ac_ext <<_ACEOF
+  ac_cv_c_int16_t=no
+     for ac_type in 'int16_t' 'int' 'long int' \
+	 'long long int' 'short int' 'signed char'; do
+       cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
@@ -4828,8 +5054,9 @@
 int
 main ()
 {
-if (sizeof (off_t))
-       return 0;
+static int test_array [1 - 2 * !(0 < ($ac_type) (((($ac_type) 1 << (16 - 2)) - 1) * 2 + 1))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -4862,8 +5089,10 @@
 int
 main ()
 {
-if (sizeof ((off_t)))
-	  return 0;
+static int test_array [1 - 2 * !(($ac_type) (((($ac_type) 1 << (16 - 2)) - 1) * 2 + 1)
+		 < ($ac_type) (((($ac_type) 1 << (16 - 2)) - 1) * 2 + 2))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -4891,7 +5120,11 @@
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_type_off_t=yes
+	case $ac_type in
+  int16_t) ac_cv_c_int16_t=yes ;;
+  *) ac_cv_c_int16_t=$ac_type ;;
+esac
+
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
@@ -4903,26 +5136,31 @@
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_int16_t" != no && break
+     done
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_off_t" >&5
-$as_echo "$ac_cv_type_off_t" >&6; }
-if test "x$ac_cv_type_off_t" = x""yes; then
-  :
-else
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_int16_t" >&5
+$as_echo "$ac_cv_c_int16_t" >&6; }
+  case $ac_cv_c_int16_t in #(
+  no|yes) ;; #(
+  *)
 
 cat >>confdefs.h <<_ACEOF
-#define off_t long int
+#define int16_t $ac_cv_c_int16_t
 _ACEOF
+;;
+  esac
 
-fi
 
-{ $as_echo "$as_me:$LINENO: checking for pid_t" >&5
-$as_echo_n "checking for pid_t... " >&6; }
-if test "${ac_cv_type_pid_t+set}" = set; then
+  { $as_echo "$as_me:$LINENO: checking for int32_t" >&5
+$as_echo_n "checking for int32_t... " >&6; }
+if test "${ac_cv_c_int32_t+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
-  ac_cv_type_pid_t=no
-cat >conftest.$ac_ext <<_ACEOF
+  ac_cv_c_int32_t=no
+     for ac_type in 'int32_t' 'int' 'long int' \
+	 'long long int' 'short int' 'signed char'; do
+       cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
@@ -4932,8 +5170,9 @@
 int
 main ()
 {
-if (sizeof (pid_t))
-       return 0;
+static int test_array [1 - 2 * !(0 < ($ac_type) (((($ac_type) 1 << (32 - 2)) - 1) * 2 + 1))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -4966,8 +5205,10 @@
 int
 main ()
 {
-if (sizeof ((pid_t)))
-	  return 0;
+static int test_array [1 - 2 * !(($ac_type) (((($ac_type) 1 << (32 - 2)) - 1) * 2 + 1)
+		 < ($ac_type) (((($ac_type) 1 << (32 - 2)) - 1) * 2 + 2))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -4995,7 +5236,11 @@
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_type_pid_t=yes
+	case $ac_type in
+  int32_t) ac_cv_c_int32_t=yes ;;
+  *) ac_cv_c_int32_t=$ac_type ;;
+esac
+
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
@@ -5007,26 +5252,31 @@
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_int32_t" != no && break
+     done
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_pid_t" >&5
-$as_echo "$ac_cv_type_pid_t" >&6; }
-if test "x$ac_cv_type_pid_t" = x""yes; then
-  :
-else
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_int32_t" >&5
+$as_echo "$ac_cv_c_int32_t" >&6; }
+  case $ac_cv_c_int32_t in #(
+  no|yes) ;; #(
+  *)
 
 cat >>confdefs.h <<_ACEOF
-#define pid_t int
+#define int32_t $ac_cv_c_int32_t
 _ACEOF
+;;
+  esac
 
-fi
 
-{ $as_echo "$as_me:$LINENO: checking for size_t" >&5
-$as_echo_n "checking for size_t... " >&6; }
-if test "${ac_cv_type_size_t+set}" = set; then
+  { $as_echo "$as_me:$LINENO: checking for int64_t" >&5
+$as_echo_n "checking for int64_t... " >&6; }
+if test "${ac_cv_c_int64_t+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
-  ac_cv_type_size_t=no
-cat >conftest.$ac_ext <<_ACEOF
+  ac_cv_c_int64_t=no
+     for ac_type in 'int64_t' 'int' 'long int' \
+	 'long long int' 'short int' 'signed char'; do
+       cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
@@ -5036,8 +5286,9 @@
 int
 main ()
 {
-if (sizeof (size_t))
-       return 0;
+static int test_array [1 - 2 * !(0 < ($ac_type) (((($ac_type) 1 << (64 - 2)) - 1) * 2 + 1))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -5070,8 +5321,10 @@
 int
 main ()
 {
-if (sizeof ((size_t)))
-	  return 0;
+static int test_array [1 - 2 * !(($ac_type) (((($ac_type) 1 << (64 - 2)) - 1) * 2 + 1)
+		 < ($ac_type) (((($ac_type) 1 << (64 - 2)) - 1) * 2 + 2))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -5099,7 +5352,11 @@
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_type_size_t=yes
+	case $ac_type in
+  int64_t) ac_cv_c_int64_t=yes ;;
+  *) ac_cv_c_int64_t=$ac_type ;;
+esac
+
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
@@ -5111,25 +5368,31 @@
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_int64_t" != no && break
+     done
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_size_t" >&5
-$as_echo "$ac_cv_type_size_t" >&6; }
-if test "x$ac_cv_type_size_t" = x""yes; then
-  :
-else
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_int64_t" >&5
+$as_echo "$ac_cv_c_int64_t" >&6; }
+  case $ac_cv_c_int64_t in #(
+  no|yes) ;; #(
+  *)
 
 cat >>confdefs.h <<_ACEOF
-#define size_t unsigned int
+#define int64_t $ac_cv_c_int64_t
 _ACEOF
+;;
+  esac
 
-fi
 
-{ $as_echo "$as_me:$LINENO: checking for struct stat.st_rdev" >&5
-$as_echo_n "checking for struct stat.st_rdev... " >&6; }
-if test "${ac_cv_member_struct_stat_st_rdev+set}" = set; then
+  { $as_echo "$as_me:$LINENO: checking for int8_t" >&5
+$as_echo_n "checking for int8_t... " >&6; }
+if test "${ac_cv_c_int8_t+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
-  cat >conftest.$ac_ext <<_ACEOF
+  ac_cv_c_int8_t=no
+     for ac_type in 'int8_t' 'int' 'long int' \
+	 'long long int' 'short int' 'signed char'; do
+       cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
@@ -5139,9 +5402,9 @@
 int
 main ()
 {
-static struct stat ac_aggr;
-if (ac_aggr.st_rdev)
-return 0;
+static int test_array [1 - 2 * !(0 < ($ac_type) (((($ac_type) 1 << (8 - 2)) - 1) * 2 + 1))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -5164,12 +5427,7 @@
 	 test -z "$ac_c_werror_flag" ||
 	 test ! -s conftest.err
        } && test -s conftest.$ac_objext; then
-  ac_cv_member_struct_stat_st_rdev=yes
-else
-  $as_echo "$as_me: failed program was:" >&5
-sed 's/^/| /' conftest.$ac_ext >&5
-
-	cat >conftest.$ac_ext <<_ACEOF
+  cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
@@ -5179,9 +5437,10 @@
 int
 main ()
 {
-static struct stat ac_aggr;
-if (sizeof ac_aggr.st_rdev)
-return 0;
+static int test_array [1 - 2 * !(($ac_type) (((($ac_type) 1 << (8 - 2)) - 1) * 2 + 1)
+		 < ($ac_type) (((($ac_type) 1 << (8 - 2)) - 1) * 2 + 2))];
+test_array [0] = 0
+
   ;
   return 0;
 }
@@ -5204,55 +5463,94 @@
 	 test -z "$ac_c_werror_flag" ||
 	 test ! -s conftest.err
        } && test -s conftest.$ac_objext; then
-  ac_cv_member_struct_stat_st_rdev=yes
+  :
 else
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_member_struct_stat_st_rdev=no
+	case $ac_type in
+  int8_t) ac_cv_c_int8_t=yes ;;
+  *) ac_cv_c_int8_t=$ac_type ;;
+esac
+
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_int8_t" != no && break
+     done
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_member_struct_stat_st_rdev" >&5
-$as_echo "$ac_cv_member_struct_stat_st_rdev" >&6; }
-if test "x$ac_cv_member_struct_stat_st_rdev" = x""yes; then
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_int8_t" >&5
+$as_echo "$ac_cv_c_int8_t" >&6; }
+  case $ac_cv_c_int8_t in #(
+  no|yes) ;; #(
+  *)
 
 cat >>confdefs.h <<_ACEOF
-#define HAVE_STRUCT_STAT_ST_RDEV 1
-_ACEOF
-
-
-cat >>confdefs.h <<\_ACEOF
-#define HAVE_ST_RDEV 1
+#define int8_t $ac_cv_c_int8_t
 _ACEOF
+;;
+  esac
 
-fi
-
-
-{ $as_echo "$as_me:$LINENO: checking whether time.h and sys/time.h may both be included" >&5
-$as_echo_n "checking whether time.h and sys/time.h may both be included... " >&6; }
-if test "${ac_cv_header_time+set}" = set; then
+{ $as_echo "$as_me:$LINENO: checking for mode_t" >&5
+$as_echo_n "checking for mode_t... " >&6; }
+if test "${ac_cv_type_mode_t+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
+  ac_cv_type_mode_t=no
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if (sizeof (mode_t))
+       return 0;
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
   cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
-#include <sys/types.h>
-#include <sys/time.h>
-#include <time.h>
-
+$ac_includes_default
 int
 main ()
 {
-if ((struct tm *) 0)
-return 0;
+if (sizeof ((mode_t)))
+	  return 0;
   ;
   return 0;
 }
@@ -5275,333 +5573,2032 @@
 	 test -z "$ac_c_werror_flag" ||
 	 test ! -s conftest.err
        } && test -s conftest.$ac_objext; then
-  ac_cv_header_time=yes
+  :
 else
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_header_time=no
+	ac_cv_type_mode_t=yes
 fi
 
 rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
-fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_header_time" >&5
-$as_echo "$ac_cv_header_time" >&6; }
-if test $ac_cv_header_time = yes; then
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
 
-cat >>confdefs.h <<\_ACEOF
-#define TIME_WITH_SYS_TIME 1
-_ACEOF
 
 fi
 
-
-if test x$KLIBC != xyes; then
-	case "$host_os" in
-		linux*)
-			CFLAGS=-O2
-			CLDFLAGS="-Wl,--version-script,.export.sym"
-			LD_DEPS=".export.sym"
-			SOFLAG="-shared" ;;
-	esac
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
 fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_mode_t" >&5
+$as_echo "$ac_cv_type_mode_t" >&6; }
+if test "x$ac_cv_type_mode_t" = x""yes; then
+  :
+else
 
+cat >>confdefs.h <<_ACEOF
+#define mode_t int
+_ACEOF
 
-
-# Check whether --with-staticdir was given.
-if test "${with_staticdir+set}" = set; then
-  withval=$with_staticdir; staticdir=$withval
-else
-  staticdir='${exec_prefix}/sbin'
 fi
 
+{ $as_echo "$as_me:$LINENO: checking for off_t" >&5
+$as_echo_n "checking for off_t... " >&6; }
+if test "${ac_cv_type_off_t+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_type_off_t=no
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if (sizeof (off_t))
+       return 0;
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
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if (sizeof ((off_t)))
+	  return 0;
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
+  :
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
 
+	ac_cv_type_off_t=yes
+fi
 
-# Check whether --with-usrlibdir was given.
-if test "${with_usrlibdir+set}" = set; then
-  withval=$with_usrlibdir; usrlibdir=$withval
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
 else
-  usrlibdir='${prefix}/lib'
-fi
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
 
 
-# Check whether --enable-debug was given.
-if test "${enable_debug+set}" = set; then
-  enableval=$enable_debug; DEBUG=$enableval
-else
-  DEBUG=no
 fi
 
-{ $as_echo "$as_me:$LINENO: checking whether to enable debugging" >&5
-$as_echo_n "checking whether to enable debugging... " >&6; }
-{ $as_echo "$as_me:$LINENO: result: $DEBUG" >&5
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_off_t" >&5
+$as_echo "$ac_cv_type_off_t" >&6; }
+if test "x$ac_cv_type_off_t" = x""yes; then
+  :
+else
+
+cat >>confdefs.h <<_ACEOF
+#define off_t long int
+_ACEOF
+
+fi
+
+{ $as_echo "$as_me:$LINENO: checking for pid_t" >&5
+$as_echo_n "checking for pid_t... " >&6; }
+if test "${ac_cv_type_pid_t+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_type_pid_t=no
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if (sizeof (pid_t))
+       return 0;
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
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if (sizeof ((pid_t)))
+	  return 0;
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
+  :
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_type_pid_t=yes
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_pid_t" >&5
+$as_echo "$ac_cv_type_pid_t" >&6; }
+if test "x$ac_cv_type_pid_t" = x""yes; then
+  :
+else
+
+cat >>confdefs.h <<_ACEOF
+#define pid_t int
+_ACEOF
+
+fi
+
+{ $as_echo "$as_me:$LINENO: checking for size_t" >&5
+$as_echo_n "checking for size_t... " >&6; }
+if test "${ac_cv_type_size_t+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_type_size_t=no
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if (sizeof (size_t))
+       return 0;
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
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+if (sizeof ((size_t)))
+	  return 0;
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
+  :
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_type_size_t=yes
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_size_t" >&5
+$as_echo "$ac_cv_type_size_t" >&6; }
+if test "x$ac_cv_type_size_t" = x""yes; then
+  :
+else
+
+cat >>confdefs.h <<_ACEOF
+#define size_t unsigned int
+_ACEOF
+
+fi
+
+
+  { $as_echo "$as_me:$LINENO: checking for uint16_t" >&5
+$as_echo_n "checking for uint16_t... " >&6; }
+if test "${ac_cv_c_uint16_t+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_c_uint16_t=no
+     for ac_type in 'uint16_t' 'unsigned int' 'unsigned long int' \
+	 'unsigned long long int' 'unsigned short int' 'unsigned char'; do
+       cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static int test_array [1 - 2 * !(($ac_type) -1 >> (16 - 1) == 1)];
+test_array [0] = 0
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
+  case $ac_type in
+  uint16_t) ac_cv_c_uint16_t=yes ;;
+  *) ac_cv_c_uint16_t=$ac_type ;;
+esac
+
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_uint16_t" != no && break
+     done
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_uint16_t" >&5
+$as_echo "$ac_cv_c_uint16_t" >&6; }
+  case $ac_cv_c_uint16_t in #(
+  no|yes) ;; #(
+  *)
+
+
+cat >>confdefs.h <<_ACEOF
+#define uint16_t $ac_cv_c_uint16_t
+_ACEOF
+;;
+  esac
+
+
+  { $as_echo "$as_me:$LINENO: checking for uint32_t" >&5
+$as_echo_n "checking for uint32_t... " >&6; }
+if test "${ac_cv_c_uint32_t+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_c_uint32_t=no
+     for ac_type in 'uint32_t' 'unsigned int' 'unsigned long int' \
+	 'unsigned long long int' 'unsigned short int' 'unsigned char'; do
+       cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static int test_array [1 - 2 * !(($ac_type) -1 >> (32 - 1) == 1)];
+test_array [0] = 0
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
+  case $ac_type in
+  uint32_t) ac_cv_c_uint32_t=yes ;;
+  *) ac_cv_c_uint32_t=$ac_type ;;
+esac
+
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_uint32_t" != no && break
+     done
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_uint32_t" >&5
+$as_echo "$ac_cv_c_uint32_t" >&6; }
+  case $ac_cv_c_uint32_t in #(
+  no|yes) ;; #(
+  *)
+
+cat >>confdefs.h <<\_ACEOF
+#define _UINT32_T 1
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define uint32_t $ac_cv_c_uint32_t
+_ACEOF
+;;
+  esac
+
+
+  { $as_echo "$as_me:$LINENO: checking for uint64_t" >&5
+$as_echo_n "checking for uint64_t... " >&6; }
+if test "${ac_cv_c_uint64_t+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_c_uint64_t=no
+     for ac_type in 'uint64_t' 'unsigned int' 'unsigned long int' \
+	 'unsigned long long int' 'unsigned short int' 'unsigned char'; do
+       cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static int test_array [1 - 2 * !(($ac_type) -1 >> (64 - 1) == 1)];
+test_array [0] = 0
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
+  case $ac_type in
+  uint64_t) ac_cv_c_uint64_t=yes ;;
+  *) ac_cv_c_uint64_t=$ac_type ;;
+esac
+
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_uint64_t" != no && break
+     done
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_uint64_t" >&5
+$as_echo "$ac_cv_c_uint64_t" >&6; }
+  case $ac_cv_c_uint64_t in #(
+  no|yes) ;; #(
+  *)
+
+cat >>confdefs.h <<\_ACEOF
+#define _UINT64_T 1
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define uint64_t $ac_cv_c_uint64_t
+_ACEOF
+;;
+  esac
+
+
+  { $as_echo "$as_me:$LINENO: checking for uint8_t" >&5
+$as_echo_n "checking for uint8_t... " >&6; }
+if test "${ac_cv_c_uint8_t+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_cv_c_uint8_t=no
+     for ac_type in 'uint8_t' 'unsigned int' 'unsigned long int' \
+	 'unsigned long long int' 'unsigned short int' 'unsigned char'; do
+       cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static int test_array [1 - 2 * !(($ac_type) -1 >> (8 - 1) == 1)];
+test_array [0] = 0
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
+  case $ac_type in
+  uint8_t) ac_cv_c_uint8_t=yes ;;
+  *) ac_cv_c_uint8_t=$ac_type ;;
+esac
+
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+       test "$ac_cv_c_uint8_t" != no && break
+     done
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_c_uint8_t" >&5
+$as_echo "$ac_cv_c_uint8_t" >&6; }
+  case $ac_cv_c_uint8_t in #(
+  no|yes) ;; #(
+  *)
+
+cat >>confdefs.h <<\_ACEOF
+#define _UINT8_T 1
+_ACEOF
+
+
+cat >>confdefs.h <<_ACEOF
+#define uint8_t $ac_cv_c_uint8_t
+_ACEOF
+;;
+  esac
+
+
+{ $as_echo "$as_me:$LINENO: checking for struct stat.st_rdev" >&5
+$as_echo_n "checking for struct stat.st_rdev... " >&6; }
+if test "${ac_cv_member_struct_stat_st_rdev+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static struct stat ac_aggr;
+if (ac_aggr.st_rdev)
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
+  ac_cv_member_struct_stat_st_rdev=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+static struct stat ac_aggr;
+if (sizeof ac_aggr.st_rdev)
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
+  ac_cv_member_struct_stat_st_rdev=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_member_struct_stat_st_rdev=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_member_struct_stat_st_rdev" >&5
+$as_echo "$ac_cv_member_struct_stat_st_rdev" >&6; }
+if test "x$ac_cv_member_struct_stat_st_rdev" = x""yes; then
+
+cat >>confdefs.h <<_ACEOF
+#define HAVE_STRUCT_STAT_ST_RDEV 1
+_ACEOF
+
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_ST_RDEV 1
+_ACEOF
+
+fi
+
+
+
+if test "$KLIBC" != yes; then
+	case "$host_os" in
+		linux*)
+			CFLAGS=-O2
+			CLDFLAGS="-Wl,--version-script,.export.sym"
+			LD_DEPS=".export.sym"
+			SOFLAG="-shared" ;;
+	esac
+fi
+
+
+
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
+# Check whether --enable-debug was given.
+if test "${enable_debug+set}" = set; then
+  enableval=$enable_debug; DEBUG=$enableval
+else
+  DEBUG=no
+fi
+
+{ $as_echo "$as_me:$LINENO: checking whether to enable debugging" >&5
+$as_echo_n "checking whether to enable debugging... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DEBUG" >&5
 $as_echo "$DEBUG" >&6; }
 
-# Check whether --enable-debug_malloc was given.
-if test "${enable_debug_malloc+set}" = set; then
-  enableval=$enable_debug_malloc; DEBUG_MALLOC=$enableval
+# Check whether --enable-debug_malloc was given.
+if test "${enable_debug_malloc+set}" = set; then
+  enableval=$enable_debug_malloc; DEBUG_MALLOC=$enableval
+else
+  DEBUG_MALLOC=no
+fi
+
+{ $as_echo "$as_me:$LINENO: checking whether to enable malloc debugging" >&5
+$as_echo_n "checking whether to enable malloc debugging... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DEBUG_MALLOC" >&5
+$as_echo "$DEBUG_MALLOC" >&6; }
+
+# Check whether --enable-dietlibc was given.
+if test "${enable_dietlibc+set}" = set; then
+  enableval=$enable_dietlibc; DIETLIBC=$enableval
+else
+  DIETLIBC=no
+fi
+
+
+if test x$DIETLIBC = xyes; then
+	if test x$KLIBC = xyes; then
+		{ { $as_echo "$as_me:$LINENO: error: You cannot enable both dietlibc and klibc!" >&5
+$as_echo "$as_me: error: You cannot enable both dietlibc and klibc!" >&2;}
+   { (exit 1); exit 1; }; }
+	fi
+        CC="diet gcc"
+	FLAVOUR="dietlibc "
+fi
+
+# Check whether --enable-jobs was given.
+if test "${enable_jobs+set}" = set; then
+  enableval=$enable_jobs; JOBS=-j$enableval
+else
+  JOBS=-j1
+fi
+
+
+# Check whether --enable-mini was given.
+if test "${enable_mini+set}" = set; then
+  enableval=$enable_mini; DMRAID_MINI=$enableval
+else
+  DMRAID_MINI=no
+fi
+
+
+# Check whether --enable-led was given.
+if test "${enable_led+set}" = set; then
+  enableval=$enable_led; DMRAID_LED=$enableval
+else
+  DMRAID_LED=no
+fi
+
+
+# Check whether --enable-intel_led was given.
+if test "${enable_intel_led+set}" = set; then
+  enableval=$enable_intel_led; DMRAID_INTEL_LED=$enableval
+else
+  DMRAID_INTEL_LED=no
+fi
+
+
+# Check whether --enable-native_log was given.
+if test "${enable_native_log+set}" = set; then
+  enableval=$enable_native_log; DMRAID_NATIVE_LOG=$enableval
+else
+  DMRAID_NATIVE_LOG=yes
+fi
+
+{ $as_echo "$as_me:$LINENO: checking whether to disable native metadata logging" >&5
+$as_echo_n "checking whether to disable native metadata logging... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DMRAID_NATIVE_LOG" >&5
+$as_echo "$DMRAID_NATIVE_LOG" >&6; }
+
+# Check whether --enable-static_link was given.
+if test "${enable_static_link+set}" = set; then
+  enableval=$enable_static_link; STATIC_LINK=$enableval
+else
+  STATIC_LINK=no
+fi
+
+
+# Check whether --enable-shared_lib was given.
+if test "${enable_shared_lib+set}" = set; then
+  enableval=$enable_shared_lib; LIB_SO=$enableval
+else
+  LIB_SO=no
+fi
+
+
+# Check whether --enable-testing was given.
+if test "${enable_testing+set}" = set; then
+  enableval=$enable_testing; DMRAID_TEST=$enableval
+else
+  DMRAID_TEST=yes
+fi
+
+{ $as_echo "$as_me:$LINENO: checking whether to disable testing with mapped devices" >&5
+$as_echo_n "checking whether to disable testing with mapped devices... " >&6; }
+{ $as_echo "$as_me:$LINENO: result: $DMRAID_TEST" >&5
+$as_echo "$DMRAID_TEST" >&6; }
+
+test "$LIB_SO" = yes && FLAVOUR="${FLAVOUR}shared "
+
+if test "$STATIC_LINK" = yes; then
+	if test "$LIB_SO" = yes; then
+		{ { $as_echo "$as_me:$LINENO: error: You cannot enable both shared_lib and static_link!" >&5
+$as_echo "$as_me: error: You cannot enable both shared_lib and static_link!" >&2;}
+   { (exit 1); exit 1; }; }
+	fi
+	FLAVOUR="${FLAVOUR}static "
+fi
+
+if test "$DMRAID_MINI" = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define DMRAID_MINI 1
+_ACEOF
+
+	FLAVOUR="${FLAVOUR}mini "
+else
+	if test "$DMRAID_NATIVE_LOG" = no; then
+		FLAVOUR="${FLAVOUR}no_native_log "
+	else
+
+cat >>confdefs.h <<\_ACEOF
+#define DMRAID_NATIVE_LOG 1
+_ACEOF
+
+	fi
+fi
+
+if test "$DMRAID_INTEL_LED" = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define DMRAID_INTEL_LED 1
+_ACEOF
+
+        DMRAID_LED=yes
+fi
+
+if test "$DMRAID_LED" = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define DMRAID_LED 1
+_ACEOF
+
+fi
+
+if test "$DMRAID_TEST" = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define DMRAID_TEST 1
+_ACEOF
+
+fi
+
+
+test "$DEBUG" = yes && FLAVOUR="${FLAVOUR}debug "
+test "$DEBUG_MALLOC" = yes && FLAVOUR="${FLAVOUR}debug_malloc "
+
+test "$exec_prefix" = NONE -a "$prefix" = NONE && exec_prefix=""
+
+if test $ac_cv_c_compiler_gnu = yes; then
+    { $as_echo "$as_me:$LINENO: checking whether $CC needs -traditional" >&5
+$as_echo_n "checking whether $CC needs -traditional... " >&6; }
+if test "${ac_cv_prog_gcc_traditional+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+    ac_pattern="Autoconf.*'x'"
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sgtty.h>
+Autoconf TIOCGETP
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "$ac_pattern" >/dev/null 2>&1; then
+  ac_cv_prog_gcc_traditional=yes
+else
+  ac_cv_prog_gcc_traditional=no
+fi
+rm -f conftest*
+
+
+  if test $ac_cv_prog_gcc_traditional = no; then
+    cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <termio.h>
+Autoconf TCGETA
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "$ac_pattern" >/dev/null 2>&1; then
+  ac_cv_prog_gcc_traditional=yes
+fi
+rm -f conftest*
+
+  fi
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_prog_gcc_traditional" >&5
+$as_echo "$ac_cv_prog_gcc_traditional" >&6; }
+  if test $ac_cv_prog_gcc_traditional = yes; then
+    CC="$CC -traditional"
+  fi
+fi
+
+{ $as_echo "$as_me:$LINENO: checking return type of signal handlers" >&5
+$as_echo_n "checking return type of signal handlers... " >&6; }
+if test "${ac_cv_type_signal+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <signal.h>
+
+int
+main ()
+{
+return *(signal (0, 0)) (0) == 1;
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
+  ac_cv_type_signal=int
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_type_signal=void
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_signal" >&5
+$as_echo "$ac_cv_type_signal" >&6; }
+
+cat >>confdefs.h <<_ACEOF
+#define RETSIGTYPE $ac_cv_type_signal
+_ACEOF
+
+
+
+for ac_func in vprintf
+do
+as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
+{ $as_echo "$as_me:$LINENO: checking for $ac_func" >&5
+$as_echo_n "checking for $ac_func... " >&6; }
+if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Define $ac_func to an innocuous variant, in case <limits.h> declares $ac_func.
+   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
+#define $ac_func innocuous_$ac_func
+
+/* System header to define __stub macros and hopefully few prototypes,
+    which can conflict with char $ac_func (); below.
+    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+    <limits.h> exists even on freestanding compilers.  */
+
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+
+#undef $ac_func
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char $ac_func ();
+/* The GNU C library defines this for functions which it implements
+    to always fail with ENOSYS.  Some functions are actually named
+    something starting with __ and the normal name is an alias.  */
+#if defined __stub_$ac_func || defined __stub___$ac_func
+choke me
+#endif
+
+int
+main ()
+{
+return $ac_func ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
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
+  eval "$as_ac_var=yes"
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	eval "$as_ac_var=no"
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+ac_res=`eval 'as_val=${'$as_ac_var'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
+as_val=`eval 'as_val=${'$as_ac_var'}
+		 $as_echo "$as_val"'`
+   if test "x$as_val" = x""yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_func" | $as_tr_cpp` 1
+_ACEOF
+
+{ $as_echo "$as_me:$LINENO: checking for _doprnt" >&5
+$as_echo_n "checking for _doprnt... " >&6; }
+if test "${ac_cv_func__doprnt+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Define _doprnt to an innocuous variant, in case <limits.h> declares _doprnt.
+   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
+#define _doprnt innocuous__doprnt
+
+/* System header to define __stub macros and hopefully few prototypes,
+    which can conflict with char _doprnt (); below.
+    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+    <limits.h> exists even on freestanding compilers.  */
+
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+
+#undef _doprnt
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char _doprnt ();
+/* The GNU C library defines this for functions which it implements
+    to always fail with ENOSYS.  Some functions are actually named
+    something starting with __ and the normal name is an alias.  */
+#if defined __stub__doprnt || defined __stub____doprnt
+choke me
+#endif
+
+int
+main ()
+{
+return _doprnt ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
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
+  ac_cv_func__doprnt=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_func__doprnt=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_func__doprnt" >&5
+$as_echo "$ac_cv_func__doprnt" >&6; }
+if test "x$ac_cv_func__doprnt" = x""yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_DOPRNT 1
+_ACEOF
+
+fi
+
+fi
+done
+
+
+# getmntent is in the standard C library on UNICOS, in -lsun on Irix 4,
+# -lseq on Dynix/PTX, -lgen on Unixware.
+{ $as_echo "$as_me:$LINENO: checking for library containing getmntent" >&5
+$as_echo_n "checking for library containing getmntent... " >&6; }
+if test "${ac_cv_search_getmntent+set}" = set; then
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
+char getmntent ();
+int
+main ()
+{
+return getmntent ();
+  ;
+  return 0;
+}
+_ACEOF
+for ac_lib in '' sun seq gen; do
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
+  ac_cv_search_getmntent=$ac_res
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
+  if test "${ac_cv_search_getmntent+set}" = set; then
+  break
+fi
+done
+if test "${ac_cv_search_getmntent+set}" = set; then
+  :
+else
+  ac_cv_search_getmntent=no
+fi
+rm conftest.$ac_ext
+LIBS=$ac_func_search_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_search_getmntent" >&5
+$as_echo "$ac_cv_search_getmntent" >&6; }
+ac_res=$ac_cv_search_getmntent
+if test "$ac_res" != no; then
+  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
+  ac_cv_func_getmntent=yes
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_GETMNTENT 1
+_ACEOF
+
+else
+  ac_cv_func_getmntent=no
+fi
+
+
+{ $as_echo "$as_me:$LINENO: checking whether lstat dereferences a symlink specified with a trailing slash" >&5
+$as_echo_n "checking whether lstat dereferences a symlink specified with a trailing slash... " >&6; }
+if test "${ac_cv_func_lstat_dereferences_slashed_symlink+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  rm -f conftest.sym conftest.file
+echo >conftest.file
+if test "$as_ln_s" = "ln -s" && ln -s conftest.file conftest.sym; then
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_lstat_dereferences_slashed_symlink=no
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+main ()
+{
+struct stat sbuf;
+     /* Linux will dereference the symlink and fail.
+	That is better in the sense that it means we will not
+	have to compile and use the lstat wrapper.  */
+     return lstat ("conftest.sym/", &sbuf) == 0;
+  ;
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
+  ac_cv_func_lstat_dereferences_slashed_symlink=yes
 else
-  DEBUG_MALLOC=no
+  $as_echo "$as_me: program exited with status $ac_status" >&5
+$as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_lstat_dereferences_slashed_symlink=no
+fi
+rm -rf conftest.dSYM
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
 
-{ $as_echo "$as_me:$LINENO: checking whether to enable malloc debugging" >&5
-$as_echo_n "checking whether to enable malloc debugging... " >&6; }
-{ $as_echo "$as_me:$LINENO: result: $DEBUG_MALLOC" >&5
-$as_echo "$DEBUG_MALLOC" >&6; }
 
-# Check whether --enable-dietlibc was given.
-if test "${enable_dietlibc+set}" = set; then
-  enableval=$enable_dietlibc; DIETLIBC=$enableval
 else
-  DIETLIBC=no
+  # If the `ln -s' command failed, then we probably don't even
+  # have an lstat function.
+  ac_cv_func_lstat_dereferences_slashed_symlink=no
 fi
+rm -f conftest.sym conftest.file
 
-
-if test x$DIETLIBC = xyes; then
-	if test x$KLIBC = xyes; then
-		{ { $as_echo "$as_me:$LINENO: error: You cannot enable both dietlibc and klibc!" >&5
-$as_echo "$as_me: error: You cannot enable both dietlibc and klibc!" >&2;}
-   { (exit 1); exit 1; }; }
-	fi
-        CC="diet gcc"
-	FLAVOUR="dietlibc "
 fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_func_lstat_dereferences_slashed_symlink" >&5
+$as_echo "$ac_cv_func_lstat_dereferences_slashed_symlink" >&6; }
+
+test $ac_cv_func_lstat_dereferences_slashed_symlink = yes &&
+
+cat >>confdefs.h <<_ACEOF
+#define LSTAT_FOLLOWS_SLASHED_SYMLINK 1
+_ACEOF
+
+
+if test $ac_cv_func_lstat_dereferences_slashed_symlink = no; then
+  case " $LIBOBJS " in
+  *" lstat.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS lstat.$ac_objext"
+ ;;
+esac
 
-# Check whether --enable-jobs was given.
-if test "${enable_jobs+set}" = set; then
-  enableval=$enable_jobs; JOBS=-j$enableval
-else
-  JOBS=-j1
 fi
 
 
-# Check whether --enable-mini was given.
-if test "${enable_mini+set}" = set; then
-  enableval=$enable_mini; DMRAID_MINI=$enableval
+for ac_header in stdlib.h
+do
+as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  { $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
+$as_echo_n "checking for $ac_header... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
+fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
 else
-  DMRAID_MINI=no
+  # Is the header compilable?
+{ $as_echo "$as_me:$LINENO: checking $ac_header usability" >&5
+$as_echo_n "checking $ac_header usability... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
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
+  ac_header_compiler=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_header_compiler=no
 fi
 
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+{ $as_echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+$as_echo "$ac_header_compiler" >&6; }
 
-# Check whether --enable-led was given.
-if test "${enable_led+set}" = set; then
-  enableval=$enable_led; DMRAID_LED=$enableval
+# Is the header present?
+{ $as_echo "$as_me:$LINENO: checking $ac_header presence" >&5
+$as_echo_n "checking $ac_header presence... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <$ac_header>
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
 else
-  DMRAID_LED=no
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  ac_header_preproc=no
 fi
 
+rm -f conftest.err conftest.$ac_ext
+{ $as_echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+$as_echo "$ac_header_preproc" >&6; }
 
-# Check whether --enable-intel_led was given.
-if test "${enable_intel_led+set}" = set; then
-  enableval=$enable_intel_led; DMRAID_INTEL_LED=$enableval
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+$as_echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+$as_echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+$as_echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+$as_echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+$as_echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+$as_echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+$as_echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+$as_echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
+
+    ;;
+esac
+{ $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
+$as_echo_n "checking for $ac_header... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
 else
-  DMRAID_INTEL_LED=no
+  eval "$as_ac_Header=\$ac_header_preproc"
 fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
 
+fi
+as_val=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+   if test "x$as_val" = x""yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
 
-# Check whether --enable-native_log was given.
-if test "${enable_native_log+set}" = set; then
-  enableval=$enable_native_log; DMRAID_NATIVE_LOG=$enableval
-else
-  DMRAID_NATIVE_LOG=yes
 fi
 
-{ $as_echo "$as_me:$LINENO: checking whether to disable native metadata logging" >&5
-$as_echo_n "checking whether to disable native metadata logging... " >&6; }
-{ $as_echo "$as_me:$LINENO: result: $DMRAID_NATIVE_LOG" >&5
-$as_echo "$DMRAID_NATIVE_LOG" >&6; }
+done
 
-# Check whether --enable-static_link was given.
-if test "${enable_static_link+set}" = set; then
-  enableval=$enable_static_link; STATIC_LINK=$enableval
+{ $as_echo "$as_me:$LINENO: checking for GNU libc compatible malloc" >&5
+$as_echo_n "checking for GNU libc compatible malloc... " >&6; }
+if test "${ac_cv_func_malloc_0_nonnull+set}" = set; then
+  $as_echo_n "(cached) " >&6
 else
-  STATIC_LINK=no
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_malloc_0_nonnull=no
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#if defined STDC_HEADERS || defined HAVE_STDLIB_H
+# include <stdlib.h>
+#else
+char *malloc ();
+#endif
+
+int
+main ()
+{
+return ! malloc (0);
+  ;
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
+  ac_cv_func_malloc_0_nonnull=yes
+else
+  $as_echo "$as_me: program exited with status $ac_status" >&5
+$as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_malloc_0_nonnull=no
+fi
+rm -rf conftest.dSYM
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
 
 
-# Check whether --enable-shared_lib was given.
-if test "${enable_shared_lib+set}" = set; then
-  enableval=$enable_shared_lib; LIB_SO=$enableval
-else
-  LIB_SO=no
 fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_func_malloc_0_nonnull" >&5
+$as_echo "$ac_cv_func_malloc_0_nonnull" >&6; }
+if test $ac_cv_func_malloc_0_nonnull = yes; then
 
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_MALLOC 1
+_ACEOF
 
-# Check whether --enable-testing was given.
-if test "${enable_testing+set}" = set; then
-  enableval=$enable_testing; DMRAID_TEST=$enableval
 else
-  DMRAID_TEST=yes
+  cat >>confdefs.h <<\_ACEOF
+#define HAVE_MALLOC 0
+_ACEOF
+
+   case " $LIBOBJS " in
+  *" malloc.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS malloc.$ac_objext"
+ ;;
+esac
+
+
+cat >>confdefs.h <<\_ACEOF
+#define malloc rpl_malloc
+_ACEOF
+
 fi
 
-{ $as_echo "$as_me:$LINENO: checking whether to disable testing with mapped devices" >&5
-$as_echo_n "checking whether to disable testing with mapped devices... " >&6; }
-{ $as_echo "$as_me:$LINENO: result: $DMRAID_TEST" >&5
-$as_echo "$DMRAID_TEST" >&6; }
 
-if test x$LIB_SO = xyes; then
-	FLAVOUR="shared "
+
+
+for ac_header in stdlib.h
+do
+as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  { $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
+$as_echo_n "checking for $ac_header... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
 fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
+else
+  # Is the header compilable?
+{ $as_echo "$as_me:$LINENO: checking $ac_header usability" >&5
+$as_echo_n "checking $ac_header usability... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
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
+  ac_header_compiler=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
 
-if test x$STATIC_LINK = xyes; then
-	FLAVOUR="static "
-	if test x$LIB_SO = xyes; then
-		{ { $as_echo "$as_me:$LINENO: error: You cannot enable both shared_lib and static_link!" >&5
-$as_echo "$as_me: error: You cannot enable both shared_lib and static_link!" >&2;}
-   { (exit 1); exit 1; }; }
-	fi
+	ac_header_compiler=no
 fi
 
-if test x$DMRAID_MINI = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_MINI"
-	FLAVOUR="${FLAVOUR}mini "
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+{ $as_echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+$as_echo "$ac_header_compiler" >&6; }
+
+# Is the header present?
+{ $as_echo "$as_me:$LINENO: checking $ac_header presence" >&5
+$as_echo_n "checking $ac_header presence... " >&6; }
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <$ac_header>
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
 else
-	if test x$DMRAID_NATIVE_LOG = xno; then
-		FLAVOUR="${FLAVOUR}no_native_log "
-	else
-        	CFLAGS="$CFLAGS -DDMRAID_NATIVE_LOG"
-	fi
-fi
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
 
-if test x$DMRAID_LED = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_LED"
+  ac_header_preproc=no
 fi
 
-if test x$DMRAID_TEST = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_TEST"
-fi
+rm -f conftest.err conftest.$ac_ext
+{ $as_echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+$as_echo "$ac_header_preproc" >&6; }
+
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+$as_echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+$as_echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+$as_echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+$as_echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+$as_echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+$as_echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+$as_echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { $as_echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+$as_echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
 
-if test x$DMRAID_INTEL_LED = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_LED -DDMRAID_INTEL_LED"
+    ;;
+esac
+{ $as_echo "$as_me:$LINENO: checking for $ac_header" >&5
+$as_echo_n "checking for $ac_header... " >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  $as_echo_n "(cached) " >&6
+else
+  eval "$as_ac_Header=\$ac_header_preproc"
 fi
+ac_res=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
 
-if test x$DEBUG = xyes; then
-	FLAVOUR="${FLAVOUR}debug "
 fi
+as_val=`eval 'as_val=${'$as_ac_Header'}
+		 $as_echo "$as_val"'`
+   if test "x$as_val" = x""yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
 
-if test x$DEBUG_MALLOC = xyes; then
-	FLAVOUR="${FLAVOUR}debug_malloc "
 fi
 
-if [ "x$exec_prefix" = xNONE -a "x$prefix" = xNONE ];
- then  exec_prefix="";
-fi;
+done
 
-if test $ac_cv_c_compiler_gnu = yes; then
-    { $as_echo "$as_me:$LINENO: checking whether $CC needs -traditional" >&5
-$as_echo_n "checking whether $CC needs -traditional... " >&6; }
-if test "${ac_cv_prog_gcc_traditional+set}" = set; then
+{ $as_echo "$as_me:$LINENO: checking for GNU libc compatible realloc" >&5
+$as_echo_n "checking for GNU libc compatible realloc... " >&6; }
+if test "${ac_cv_func_realloc_0_nonnull+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
-    ac_pattern="Autoconf.*'x'"
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_realloc_0_nonnull=no
+else
   cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
-#include <sgtty.h>
-Autoconf TIOCGETP
+#if defined STDC_HEADERS || defined HAVE_STDLIB_H
+# include <stdlib.h>
+#else
+char *realloc ();
+#endif
+
+int
+main ()
+{
+return ! realloc (0, 0);
+  ;
+  return 0;
+}
 _ACEOF
-if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
-  $EGREP "$ac_pattern" >/dev/null 2>&1; then
-  ac_cv_prog_gcc_traditional=yes
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
+  ac_cv_func_realloc_0_nonnull=yes
 else
-  ac_cv_prog_gcc_traditional=no
+  $as_echo "$as_me: program exited with status $ac_status" >&5
+$as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_realloc_0_nonnull=no
+fi
+rm -rf conftest.dSYM
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
-rm -f conftest*
 
 
-  if test $ac_cv_prog_gcc_traditional = no; then
-    cat >conftest.$ac_ext <<_ACEOF
-/* confdefs.h.  */
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_func_realloc_0_nonnull" >&5
+$as_echo "$ac_cv_func_realloc_0_nonnull" >&6; }
+if test $ac_cv_func_realloc_0_nonnull = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_REALLOC 1
 _ACEOF
-cat confdefs.h >>conftest.$ac_ext
-cat >>conftest.$ac_ext <<_ACEOF
-/* end confdefs.h.  */
-#include <termio.h>
-Autoconf TCGETA
+
+else
+  cat >>confdefs.h <<\_ACEOF
+#define HAVE_REALLOC 0
+_ACEOF
+
+   case " $LIBOBJS " in
+  *" realloc.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS realloc.$ac_objext"
+ ;;
+esac
+
+
+cat >>confdefs.h <<\_ACEOF
+#define realloc rpl_realloc
 _ACEOF
-if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
-  $EGREP "$ac_pattern" >/dev/null 2>&1; then
-  ac_cv_prog_gcc_traditional=yes
-fi
-rm -f conftest*
 
-  fi
-fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_prog_gcc_traditional" >&5
-$as_echo "$ac_cv_prog_gcc_traditional" >&6; }
-  if test $ac_cv_prog_gcc_traditional = yes; then
-    CC="$CC -traditional"
-  fi
 fi
 
-{ $as_echo "$as_me:$LINENO: checking return type of signal handlers" >&5
-$as_echo_n "checking return type of signal handlers... " >&6; }
-if test "${ac_cv_type_signal+set}" = set; then
+
+
+{ $as_echo "$as_me:$LINENO: checking for working strtod" >&5
+$as_echo_n "checking for working strtod... " >&6; }
+if test "${ac_cv_func_strtod+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_strtod=no
+else
   cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
-#include <sys/types.h>
-#include <signal.h>
 
+$ac_includes_default
+#ifndef strtod
+double strtod ();
+#endif
 int
-main ()
+main()
 {
-return *(signal (0, 0)) (0) == 1;
-  ;
+  {
+    /* Some versions of Linux strtod mis-parse strings with leading '+'.  */
+    char *string = " +69";
+    char *term;
+    double value;
+    value = strtod (string, &term);
+    if (value != 69 || term != (string + 4))
+      return 1;
+  }
+
+  {
+    /* Under Solaris 2.4, strtod returns the wrong value for the
+       terminating character under some conditions.  */
+    char *string = "NaN";
+    char *term;
+    strtod (string, &term);
+    if (term != string && *(term - 1) == 0)
+      return 1;
+  }
   return 0;
 }
+
 _ACEOF
-rm -f conftest.$ac_objext
-if { (ac_try="$ac_compile"
+rm -f conftest$ac_exeext
+if { (ac_try="$ac_link"
 case "(($ac_try" in
   *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
   *) ac_try_echo=$ac_try;;
 esac
 eval ac_try_echo="\"\$as_me:$LINENO: $ac_try_echo\""
 $as_echo "$ac_try_echo") >&5
-  (eval "$ac_compile") 2>conftest.er1
+  (eval "$ac_link") 2>&5
   ac_status=$?
-  grep -v '^ *+' conftest.er1 >conftest.err
-  rm -f conftest.er1
-  cat conftest.err >&5
   $as_echo "$as_me:$LINENO: \$? = $ac_status" >&5
-  (exit $ac_status); } && {
-	 test -z "$ac_c_werror_flag" ||
-	 test ! -s conftest.err
-       } && test -s conftest.$ac_objext; then
-  ac_cv_type_signal=int
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
+  ac_cv_func_strtod=yes
 else
-  $as_echo "$as_me: failed program was:" >&5
+  $as_echo "$as_me: program exited with status $ac_status" >&5
+$as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_type_signal=void
+( exit $ac_status )
+ac_cv_func_strtod=no
 fi
-
-rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+rm -rf conftest.dSYM
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_type_signal" >&5
-$as_echo "$ac_cv_type_signal" >&6; }
-
-cat >>confdefs.h <<_ACEOF
-#define RETSIGTYPE $ac_cv_type_signal
-_ACEOF
 
 
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_func_strtod" >&5
+$as_echo "$ac_cv_func_strtod" >&6; }
+if test $ac_cv_func_strtod = no; then
+  case " $LIBOBJS " in
+  *" strtod.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS strtod.$ac_objext"
+ ;;
+esac
 
-for ac_func in vprintf
-do
-as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
-{ $as_echo "$as_me:$LINENO: checking for $ac_func" >&5
-$as_echo_n "checking for $ac_func... " >&6; }
-if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
+{ $as_echo "$as_me:$LINENO: checking for pow" >&5
+$as_echo_n "checking for pow... " >&6; }
+if test "${ac_cv_func_pow+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
   cat >conftest.$ac_ext <<_ACEOF
@@ -5610,12 +7607,12 @@
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
-/* Define $ac_func to an innocuous variant, in case <limits.h> declares $ac_func.
+/* Define pow to an innocuous variant, in case <limits.h> declares pow.
    For example, HP-UX 11i <limits.h> declares gettimeofday.  */
-#define $ac_func innocuous_$ac_func
+#define pow innocuous_pow
 
 /* System header to define __stub macros and hopefully few prototypes,
-    which can conflict with char $ac_func (); below.
+    which can conflict with char pow (); below.
     Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
     <limits.h> exists even on freestanding compilers.  */
 
@@ -5625,7 +7622,7 @@
 # include <assert.h>
 #endif
 
-#undef $ac_func
+#undef pow
 
 /* Override any GCC internal prototype to avoid an error.
    Use char because int might match the return type of a GCC
@@ -5633,18 +7630,18 @@
 #ifdef __cplusplus
 extern "C"
 #endif
-char $ac_func ();
+char pow ();
 /* The GNU C library defines this for functions which it implements
     to always fail with ENOSYS.  Some functions are actually named
     something starting with __ and the normal name is an alias.  */
-#if defined __stub_$ac_func || defined __stub___$ac_func
+#if defined __stub_pow || defined __stub___pow
 choke me
 #endif
 
 int
 main ()
 {
-return $ac_func ();
+return pow ();
   ;
   return 0;
 }
@@ -5670,32 +7667,110 @@
 	 test "$cross_compiling" = yes ||
 	 $as_test_x conftest$ac_exeext
        }; then
-  eval "$as_ac_var=yes"
+  ac_cv_func_pow=yes
 else
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	eval "$as_ac_var=no"
+	ac_cv_func_pow=no
 fi
 
 rm -rf conftest.dSYM
 rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
       conftest$ac_exeext conftest.$ac_ext
 fi
-ac_res=`eval 'as_val=${'$as_ac_var'}
-		 $as_echo "$as_val"'`
-	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
-$as_echo "$ac_res" >&6; }
-as_val=`eval 'as_val=${'$as_ac_var'}
-		 $as_echo "$as_val"'`
-   if test "x$as_val" = x""yes; then
-  cat >>confdefs.h <<_ACEOF
-#define `$as_echo "HAVE_$ac_func" | $as_tr_cpp` 1
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_func_pow" >&5
+$as_echo "$ac_cv_func_pow" >&6; }
+
+if test $ac_cv_func_pow = no; then
+  { $as_echo "$as_me:$LINENO: checking for pow in -lm" >&5
+$as_echo_n "checking for pow in -lm... " >&6; }
+if test "${ac_cv_lib_m_pow+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lm  $LIBS"
+cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
 _ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
 
-{ $as_echo "$as_me:$LINENO: checking for _doprnt" >&5
-$as_echo_n "checking for _doprnt... " >&6; }
-if test "${ac_cv_func__doprnt+set}" = set; then
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char pow ();
+int
+main ()
+{
+return pow ();
+  ;
+  return 0;
+}
+_ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
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
+  ac_cv_lib_m_pow=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_m_pow=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_m_pow" >&5
+$as_echo "$ac_cv_lib_m_pow" >&6; }
+if test "x$ac_cv_lib_m_pow" = x""yes; then
+  POW_LIB=-lm
+else
+  { $as_echo "$as_me:$LINENO: WARNING: cannot find library containing definition of pow" >&5
+$as_echo "$as_me: WARNING: cannot find library containing definition of pow" >&2;}
+fi
+
+fi
+
+fi
+
+
+
+
+
+
+
+for ac_func in getmntent memmove memset mkdir rmdir uname
+do
+as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
+{ $as_echo "$as_me:$LINENO: checking for $ac_func" >&5
+$as_echo_n "checking for $ac_func... " >&6; }
+if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
   $as_echo_n "(cached) " >&6
 else
   cat >conftest.$ac_ext <<_ACEOF
@@ -5704,12 +7779,12 @@
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
-/* Define _doprnt to an innocuous variant, in case <limits.h> declares _doprnt.
+/* Define $ac_func to an innocuous variant, in case <limits.h> declares $ac_func.
    For example, HP-UX 11i <limits.h> declares gettimeofday.  */
-#define _doprnt innocuous__doprnt
+#define $ac_func innocuous_$ac_func
 
 /* System header to define __stub macros and hopefully few prototypes,
-    which can conflict with char _doprnt (); below.
+    which can conflict with char $ac_func (); below.
     Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
     <limits.h> exists even on freestanding compilers.  */
 
@@ -5719,7 +7794,7 @@
 # include <assert.h>
 #endif
 
-#undef _doprnt
+#undef $ac_func
 
 /* Override any GCC internal prototype to avoid an error.
    Use char because int might match the return type of a GCC
@@ -5727,18 +7802,18 @@
 #ifdef __cplusplus
 extern "C"
 #endif
-char _doprnt ();
+char $ac_func ();
 /* The GNU C library defines this for functions which it implements
     to always fail with ENOSYS.  Some functions are actually named
     something starting with __ and the normal name is an alias.  */
-#if defined __stub__doprnt || defined __stub____doprnt
+#if defined __stub_$ac_func || defined __stub___$ac_func
 choke me
 #endif
 
 int
 main ()
 {
-return _doprnt ();
+return $ac_func ();
   ;
   return 0;
 }
@@ -5764,36 +7839,38 @@
 	 test "$cross_compiling" = yes ||
 	 $as_test_x conftest$ac_exeext
        }; then
-  ac_cv_func__doprnt=yes
+  eval "$as_ac_var=yes"
 else
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_func__doprnt=no
+	eval "$as_ac_var=no"
 fi
 
 rm -rf conftest.dSYM
 rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
       conftest$ac_exeext conftest.$ac_ext
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_func__doprnt" >&5
-$as_echo "$ac_cv_func__doprnt" >&6; }
-if test "x$ac_cv_func__doprnt" = x""yes; then
-
-cat >>confdefs.h <<\_ACEOF
-#define HAVE_DOPRNT 1
+ac_res=`eval 'as_val=${'$as_ac_var'}
+		 $as_echo "$as_val"'`
+	       { $as_echo "$as_me:$LINENO: result: $ac_res" >&5
+$as_echo "$ac_res" >&6; }
+as_val=`eval 'as_val=${'$as_ac_var'}
+		 $as_echo "$as_val"'`
+   if test "x$as_val" = x""yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `$as_echo "HAVE_$ac_func" | $as_tr_cpp` 1
 _ACEOF
 
 fi
-
-fi
 done
 
 
 
 
 
-for ac_func in mkdir rmdir uname
+
+for ac_func in strchr strerror strpbrk strrchr strstr
 do
 as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
 { $as_echo "$as_me:$LINENO: checking for $ac_func" >&5
@@ -5894,7 +7971,7 @@
 done
 
 
-if test x$KLIBC != xyes; then
+if test "$KLIBC" != yes; then
 
 for ac_header in getopt.h
 do
@@ -6036,14 +8113,16 @@
   cat >>confdefs.h <<_ACEOF
 #define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
 _ACEOF
- CFLAGS="$CFLAGS -DHAVE_GETOPTLONG"
-fi
 
-done
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_GETOPTLONG 1
+_ACEOF
 
 fi
 
+done
 
+fi
 
 
 
@@ -6142,43 +8221,7 @@
 # Let make expand exec_prefix.
 test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'
 
-# Transform confdefs.h into DEFS.
-# Protect against shell expansion while executing Makefile rules.
-# Protect against Makefile macro expansion.
-#
-# If the first sed substitution is executed (which looks for macros that
-# take arguments), then branch to the quote section.  Otherwise,
-# look for a macro that doesn't take arguments.
-ac_script='
-:mline
-/\\$/{
- N
- s,\\\n,,
- b mline
-}
-t clear
-:clear
-s/^[	 ]*#[	 ]*define[	 ][	 ]*\([^	 (][^	 (]*([^)]*)\)[	 ]*\(.*\)/-D\1=\2/g
-t quote
-s/^[	 ]*#[	 ]*define[	 ][	 ]*\([^	 ][^	 ]*\)[	 ]*\(.*\)/-D\1=\2/g
-t quote
-b any
-:quote
-s/[	 `~#$^&*(){}\\|;'\''"<>?]/\\&/g
-s/\[/\\&/g
-s/\]/\\&/g
-s/\$/$$/g
-H
-:any
-${
-	g
-	s/^\n//
-	s/\n/ /g
-	p
-}
-'
-DEFS=`sed -n "$ac_script" confdefs.h`
-
+DEFS=-DHAVE_CONFIG_H
 
 ac_libobjs=
 ac_ltlibobjs=
@@ -6536,11 +8579,15 @@
 "*) set x $ac_config_files; shift; ac_config_files=$*;;
 esac
 
+case $ac_config_headers in *"
+"*) set x $ac_config_headers; shift; ac_config_headers=$*;;
+esac
 
 
 cat >>$CONFIG_STATUS <<_ACEOF || ac_write_fail=1
 # Files that config.status was made for.
 config_files="$ac_config_files"
+config_headers="$ac_config_headers"
 
 _ACEOF
 
@@ -6559,10 +8606,15 @@
       --recheck    update $as_me by reconfiguring in the same conditions
       --file=FILE[:TEMPLATE]
                    instantiate the configuration file FILE
+      --header=FILE[:TEMPLATE]
+                   instantiate the configuration header FILE
 
 Configuration files:
 $config_files
 
+Configuration headers:
+$config_headers
+
 Report bugs to <bug-autoconf@gnu.org>."
 
 _ACEOF
@@ -6617,7 +8669,19 @@
     esac
     CONFIG_FILES="$CONFIG_FILES '$ac_optarg'"
     ac_need_defaults=false;;
-  --he | --h |  --help | --hel | -h )
+  --header | --heade | --head | --hea )
+    $ac_shift
+    case $ac_optarg in
+    *\'*) ac_optarg=`$as_echo "$ac_optarg" | sed "s/'/'\\\\\\\\''/g"` ;;
+    esac
+    CONFIG_HEADERS="$CONFIG_HEADERS '$ac_optarg'"
+    ac_need_defaults=false;;
+  --he | --h)
+    # Conflict between --help and --header
+    { $as_echo "$as_me: error: ambiguous option: $1
+Try \`$0 --help' for more information." >&2
+   { (exit 1); exit 1; }; };;
+  --help | --hel | -h )
     $as_echo "$ac_cs_usage"; exit ;;
   -q | -quiet | --quiet | --quie | --qui | --qu | --q \
   | -silent | --silent | --silen | --sile | --sil | --si | --s)
@@ -6674,6 +8738,7 @@
 for ac_config_target in $ac_config_targets
 do
   case $ac_config_target in
+    "include/config.h") CONFIG_HEADERS="$CONFIG_HEADERS include/config.h:include/config.h.in" ;;
     "include/Makefile") CONFIG_FILES="$CONFIG_FILES include/Makefile" ;;
     "lib/Makefile") CONFIG_FILES="$CONFIG_FILES lib/Makefile" ;;
     "man/Makefile") CONFIG_FILES="$CONFIG_FILES man/Makefile" ;;
@@ -6695,6 +8760,7 @@
 # bizarre bug on SunOS 4.1.3.
 if $ac_need_defaults; then
   test "${CONFIG_FILES+set}" = set || CONFIG_FILES=$config_files
+  test "${CONFIG_HEADERS+set}" = set || CONFIG_HEADERS=$config_headers
 fi
 
 # Have a temporary directory for convenience.  Make it in the build tree
@@ -6878,8 +8944,120 @@
 cat >>$CONFIG_STATUS <<\_ACEOF || ac_write_fail=1
 fi # test -n "$CONFIG_FILES"
 
+# Set up the scripts for CONFIG_HEADERS section.
+# No need to generate them if there are no CONFIG_HEADERS.
+# This happens for instance with `./config.status Makefile'.
+if test -n "$CONFIG_HEADERS"; then
+cat >"$tmp/defines.awk" <<\_ACAWK ||
+BEGIN {
+_ACEOF
+
+# Transform confdefs.h into an awk script `defines.awk', embedded as
+# here-document in config.status, that substitutes the proper values into
+# config.h.in to produce config.h.
+
+# Create a delimiter string that does not exist in confdefs.h, to ease
+# handling of long lines.
+ac_delim='%!_!# '
+for ac_last_try in false false :; do
+  ac_t=`sed -n "/$ac_delim/p" confdefs.h`
+  if test -z "$ac_t"; then
+    break
+  elif $ac_last_try; then
+    { { $as_echo "$as_me:$LINENO: error: could not make $CONFIG_HEADERS" >&5
+$as_echo "$as_me: error: could not make $CONFIG_HEADERS" >&2;}
+   { (exit 1); exit 1; }; }
+  else
+    ac_delim="$ac_delim!$ac_delim _$ac_delim!! "
+  fi
+done
+
+# For the awk script, D is an array of macro values keyed by name,
+# likewise P contains macro parameters if any.  Preserve backslash
+# newline sequences.
+
+ac_word_re=[_$as_cr_Letters][_$as_cr_alnum]*
+sed -n '
+s/.\{148\}/&'"$ac_delim"'/g
+t rset
+:rset
+s/^[	 ]*#[	 ]*define[	 ][	 ]*/ /
+t def
+d
+:def
+s/\\$//
+t bsnl
+s/["\\]/\\&/g
+s/^ \('"$ac_word_re"'\)\(([^()]*)\)[	 ]*\(.*\)/P["\1"]="\2"\
+D["\1"]=" \3"/p
+s/^ \('"$ac_word_re"'\)[	 ]*\(.*\)/D["\1"]=" \2"/p
+d
+:bsnl
+s/["\\]/\\&/g
+s/^ \('"$ac_word_re"'\)\(([^()]*)\)[	 ]*\(.*\)/P["\1"]="\2"\
+D["\1"]=" \3\\\\\\n"\\/p
+t cont
+s/^ \('"$ac_word_re"'\)[	 ]*\(.*\)/D["\1"]=" \2\\\\\\n"\\/p
+t cont
+d
+:cont
+n
+s/.\{148\}/&'"$ac_delim"'/g
+t clear
+:clear
+s/\\$//
+t bsnlc
+s/["\\]/\\&/g; s/^/"/; s/$/"/p
+d
+:bsnlc
+s/["\\]/\\&/g; s/^/"/; s/$/\\\\\\n"\\/p
+b cont
+' <confdefs.h | sed '
+s/'"$ac_delim"'/"\\\
+"/g' >>$CONFIG_STATUS || ac_write_fail=1
+
+cat >>$CONFIG_STATUS <<_ACEOF || ac_write_fail=1
+  for (key in D) D_is_set[key] = 1
+  FS = ""
+}
+/^[\t ]*#[\t ]*(define|undef)[\t ]+$ac_word_re([\t (]|\$)/ {
+  line = \$ 0
+  split(line, arg, " ")
+  if (arg[1] == "#") {
+    defundef = arg[2]
+    mac1 = arg[3]
+  } else {
+    defundef = substr(arg[1], 2)
+    mac1 = arg[2]
+  }
+  split(mac1, mac2, "(") #)
+  macro = mac2[1]
+  prefix = substr(line, 1, index(line, defundef) - 1)
+  if (D_is_set[macro]) {
+    # Preserve the white space surrounding the "#".
+    print prefix "define", macro P[macro] D[macro]
+    next
+  } else {
+    # Replace #undef with comments.  This is necessary, for example,
+    # in the case of _POSIX_SOURCE, which is predefined and required
+    # on some systems where configure will not decide to define it.
+    if (defundef == "undef") {
+      print "/*", prefix defundef, macro, "*/"
+      next
+    }
+  }
+}
+{ print }
+_ACAWK
+_ACEOF
+cat >>$CONFIG_STATUS <<\_ACEOF || ac_write_fail=1
+  { { $as_echo "$as_me:$LINENO: error: could not setup config headers machinery" >&5
+$as_echo "$as_me: error: could not setup config headers machinery" >&2;}
+   { (exit 1); exit 1; }; }
+fi # test -n "$CONFIG_HEADERS"
+
 
-eval set X "  :F $CONFIG_FILES      "
+eval set X "  :F $CONFIG_FILES  :H $CONFIG_HEADERS    "
 shift
 for ac_tag
 do
@@ -7149,7 +9327,36 @@
 $as_echo "$as_me: error: could not create $ac_file" >&2;}
    { (exit 1); exit 1; }; }
  ;;
-
+  :H)
+  #
+  # CONFIG_HEADER
+  #
+  if test x"$ac_file" != x-; then
+    {
+      $as_echo "/* $configure_input  */" \
+      && eval '$AWK -f "$tmp/defines.awk"' "$ac_file_inputs"
+    } >"$tmp/config.h" \
+      || { { $as_echo "$as_me:$LINENO: error: could not create $ac_file" >&5
+$as_echo "$as_me: error: could not create $ac_file" >&2;}
+   { (exit 1); exit 1; }; }
+    if diff "$ac_file" "$tmp/config.h" >/dev/null 2>&1; then
+      { $as_echo "$as_me:$LINENO: $ac_file is unchanged" >&5
+$as_echo "$as_me: $ac_file is unchanged" >&6;}
+    else
+      rm -f "$ac_file"
+      mv "$tmp/config.h" "$ac_file" \
+	|| { { $as_echo "$as_me:$LINENO: error: could not create $ac_file" >&5
+$as_echo "$as_me: error: could not create $ac_file" >&2;}
+   { (exit 1); exit 1; }; }
+    fi
+  else
+    $as_echo "/* $configure_input  */" \
+      && eval '$AWK -f "$tmp/defines.awk"' "$ac_file_inputs" \
+      || { { $as_echo "$as_me:$LINENO: error: could not create -" >&5
+$as_echo "$as_me: error: could not create -" >&2;}
+   { (exit 1); exit 1; }; }
+  fi
+ ;;
 
 
   esac
--- dmraid/configure.in	2010/05/28 12:25:54	1.8
+++ dmraid/configure.in	2010/05/29 21:31:35	1.9
@@ -7,13 +7,17 @@
 # configure.in for dmraid
 
 dnl Process this file with autoconf to produce a configure script.
-AC_INIT(lib/device/dev-io.h)
+AC_PREREQ(2.57)
+AC_INIT(dmraid)
+AC_CONFIG_SRCDIR(lib/device/dev-io.h)
 
 dnl setup the directory where autoconf has auxilary files
-AC_CONFIG_AUX_DIR(autoconf) 
+AC_CONFIG_AUX_DIR(autoconf)
+AC_CONFIG_HEADERS([include/config.h:include/config.h.in])
 
 dnl Get system type
-AC_CANONICAL_SYSTEM
+AC_CANONICAL_HOST
+AC_CANONICAL_TARGET
 
 dnl Checks for programs.
 AC_PROG_SED
@@ -31,27 +35,41 @@
 dnl Checks for CC
 dnl This should be done after klibc check, as CC is changed
 AC_PROG_CC
+AC_LANG(C)
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
 AC_HEADER_STDC
-AC_CHECK_HEADERS(fcntl.h sys/ioctl.h unistd.h)
-if test x$KLIBC != xyes; then
+AC_HEADER_TIME
+AC_CHECK_HEADERS([fcntl.h limits.h mntent.h paths.h sys/file.h sys/ioctl.h])
+AC_CHECK_HEADERS([netinet/in.h syslog.h unistd.h])
+
+if test "$KLIBC" = yes; then
 	AC_CHECK_HEADERS(malloc.h)
 fi
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
 AC_C_INLINE
+AC_TYPE_INT16_T
+AC_TYPE_INT32_T
+AC_TYPE_INT64_T
+AC_TYPE_INT8_T
+AC_TYPE_MODE_T
 AC_TYPE_OFF_T
 AC_TYPE_PID_T
 AC_TYPE_SIZE_T
+AC_TYPE_UINT16_T
+AC_TYPE_UINT32_T
+AC_TYPE_UINT64_T
+AC_TYPE_UINT8_T
+
+dnl FIXME - HAVE_STRUCT_STAT_ST_RDEV
 AC_STRUCT_ST_RDEV
-AC_HEADER_TIME
 
 dnl Set system type flags
 dnl We do not want this with klibc
-if test x$KLIBC != xyes; then
+if test "$KLIBC" != yes; then
 	case "$host_os" in
 		linux*)
 			CFLAGS=-O2
@@ -73,21 +91,21 @@
   [usrlibdir=$withval], [usrlibdir='${prefix}/lib'])
 
 dnl Enable Debugging
-AC_ARG_ENABLE(debug, 
+AC_ARG_ENABLE(debug,
   AC_HELP_STRING([--enable-debug], [Enable debugging]),
   [DEBUG=$enableval], [DEBUG=no])
 AC_MSG_CHECKING([whether to enable debugging])
 AC_MSG_RESULT([$DEBUG])
 
 dnl Enable malloc debugging
-AC_ARG_ENABLE(debug_malloc, 
+AC_ARG_ENABLE(debug_malloc,
   AC_HELP_STRING([--enable-debug_malloc], [Enable malloc debugging]),
   [DEBUG_MALLOC=$enableval], [DEBUG_MALLOC=no])
 AC_MSG_CHECKING([whether to enable malloc debugging])
 AC_MSG_RESULT([$DEBUG_MALLOC])
 
 dnl Enables linking to dietlibc
-AC_ARG_ENABLE(dietlibc, 
+AC_ARG_ENABLE(dietlibc,
   AC_HELP_STRING([--enable-dietlibc], [Use this to link the tools to dietlibc]),
   [DIETLIBC=$enableval], [DIETLIBC=no])
 
@@ -105,12 +123,12 @@
 
 dnl Enables mini binary
 AC_ARG_ENABLE(mini,
-  AC_HELP_STRING([--enable-mini], 
+  AC_HELP_STRING([--enable-mini],
     [Use this to create a minimal binary suitable for early boot environments]),
   [DMRAID_MINI=$enableval], [DMRAID_MINI=no])
 
 dnl Enables LED support
-AC_ARG_ENABLE(led, 
+AC_ARG_ENABLE(led,
   AC_HELP_STRING([--enable-led], [Use this to enable LED support]),
   [DMRAID_LED=$enableval], [DMRAID_LED=no])
 
@@ -146,64 +164,64 @@
 AC_MSG_CHECKING([whether to disable testing with mapped devices])
 AC_MSG_RESULT([$DMRAID_TEST])
 
-if test x$LIB_SO = xyes; then
-	FLAVOUR="shared "
-fi
+test "$LIB_SO" = yes && FLAVOUR="${FLAVOUR}shared "
 
-if test x$STATIC_LINK = xyes; then
-	FLAVOUR="static "
-	if test x$LIB_SO = xyes; then
+if test "$STATIC_LINK" = yes; then
+	if test "$LIB_SO" = yes; then
 		AC_MSG_ERROR([You cannot enable both shared_lib and static_link!])
 	fi
+	FLAVOUR="${FLAVOUR}static "
 fi
 
-if test x$DMRAID_MINI = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_MINI"
+if test "$DMRAID_MINI" = yes; then
+	AC_DEFINE(DMRAID_MINI, 1, [Define to 1 if you to create a minimal binary.])
 	FLAVOUR="${FLAVOUR}mini "
 else
-	if test x$DMRAID_NATIVE_LOG = xno; then
+	if test "$DMRAID_NATIVE_LOG" = no; then
 		FLAVOUR="${FLAVOUR}no_native_log "
 	else
-        	CFLAGS="$CFLAGS -DDMRAID_NATIVE_LOG"
+		AC_DEFINE(DMRAID_NATIVE_LOG, 1,
+			  [Define to 1 if you want native metadata logging.])
 	fi
 fi
 
-if test x$DMRAID_LED = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_LED"
+if test "$DMRAID_INTEL_LED" = yes; then
+        AC_DEFINE(DMRAID_INTEL_LED, 1, [Define to 1 if you want Intel LED support.])
+        DMRAID_LED=yes
 fi
 
-if test x$DMRAID_TEST = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_TEST"
+if test "$DMRAID_LED" = yes; then
+        AC_DEFINE(DMRAID_LED, 1, [Define to 1 if you want LED support.])
 fi
 
-if test x$DMRAID_INTEL_LED = xyes; then
-        CFLAGS="$CFLAGS -DDMRAID_LED -DDMRAID_INTEL_LED"
+if test "$DMRAID_TEST" = yes; then
+        AC_DEFINE(DMRAID_TEST, 1, [Define to 1 if you want to test mapped devices.])
 fi
 
-if test x$DEBUG = xyes; then
-	FLAVOUR="${FLAVOUR}debug "
-fi
 
-if test x$DEBUG_MALLOC = xyes; then
-	FLAVOUR="${FLAVOUR}debug_malloc "
-fi
+test "$DEBUG" = yes && FLAVOUR="${FLAVOUR}debug "
+test "$DEBUG_MALLOC" = yes && FLAVOUR="${FLAVOUR}debug_malloc "
 
 dnl Mess with default exec_prefix
-if [[ "x$exec_prefix" = xNONE -a "x$prefix" = xNONE ]];
- then  exec_prefix="";
-fi;
+test "$exec_prefix" = NONE -a "$prefix" = NONE && exec_prefix=""
 
 dnl Checks for library functions.
 AC_PROG_GCC_TRADITIONAL
 AC_TYPE_SIGNAL
 AC_FUNC_VPRINTF
-AC_CHECK_FUNCS(mkdir rmdir uname)
+AC_FUNC_GETMNTENT
+AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
+AC_FUNC_MALLOC
+AC_FUNC_REALLOC
+AC_FUNC_STRTOD
+AC_CHECK_FUNCS([getmntent memmove memset mkdir rmdir uname])
+AC_CHECK_FUNCS([strchr strerror strpbrk strrchr strstr])
 
 dnl Klibc do not currently support getopt_long, but the test passes anyhow as
 dnl it calls gcc -E without considering CFLAGS ...
-if test x$KLIBC != xyes; then
-	dnl Check for getopt
-	AC_CHECK_HEADERS(getopt.h, CFLAGS="$CFLAGS -DHAVE_GETOPTLONG")
+if test "$KLIBC" != yes; then
+	dnl Check for getopt  (FIXME)
+	AC_CHECK_HEADERS(getopt.h, AC_DEFINE(HAVE_GETOPTLONG, 1, [Define to 1 for longopt.]))
 fi
 
 AC_SUBST(CC)
@@ -211,8 +229,6 @@
 AC_SUBST(CLDFLAGS)
 AC_SUBST(DEBUG)
 AC_SUBST(DEBUG_MALLOC)
-AC_SUBST(DMRAID_VERSION)
-AC_SUBST(DMRAID_LIB_VERSION)
 AC_SUBST(DIETLIBC)
 AC_SUBST(JOBS)
 AC_SUBST(LD_DEPS)
@@ -224,7 +240,7 @@
 AC_SUBST(usrlibdir)
 AC_SUBST(staticdir)
 
-dnl First and last lines should not contain files to generate in order to 
+dnl First and last lines should not contain files to generate in order to
 dnl keep utility scripts running properly
 AC_OUTPUT(
 include/Makefile
