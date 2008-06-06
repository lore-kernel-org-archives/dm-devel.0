From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW ./configure ./config ...
Date: 6 Jun 2008 20:33:14 -0000
Message-ID: <20080606203314.22713.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2008-06-06 20:33:14

Modified files:
	.              : WHATS_NEW configure configure.in 
	include        : configure.h.in 

Log message:
	Bring configure.in into line with the lvm2 version.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.237&r2=1.238
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.45&r2=1.46
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.47&r2=1.48
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/include/configure.h.in.diff?cvsroot=dm&r1=1.6&r2=1.7

--- device-mapper/WHATS_NEW	2008/06/06 19:22:09	1.237
+++ device-mapper/WHATS_NEW	2008/06/06 20:33:13	1.238
@@ -1,5 +1,6 @@
 Version 1.02.27 -
 ===============================
+  Bring configure.in into line with the lvm2 version.
 
 Version 1.02.26 - 6th June 2008
 ===============================
--- device-mapper/configure	2007/10/10 00:02:03	1.45
+++ device-mapper/configure	2008/06/06 20:33:13	1.46
@@ -680,35 +680,58 @@
 LN_S
 SET_MAKE
 RANLIB
+CFLOW_CMD
+CSCOPE_CMD
+ALLOCA
 LIBOBJS
+POW_LIB
 MSGFMT
-usrlibdir
-JOBS
-STATIC_LINK
-OWNER
-GROUP
-interface
-kerneldir
-missingkernel
-kernelvsn
-tmpdir
-COPTIMISE_FLAG
 CLDFLAGS
-LDDEPS
-LIB_SUFFIX
-DEBUG
-DM_LIB_VERSION
+CLDNOWHOLEARCHIVE
+CLDWHOLEARCHIVE
+CLUSTER
+CLVMD
+CMDLIB
 COMPAT
-DMIOCTLS
-LOCALEDIR
-INTL_PACKAGE
-INTL
-DEVICE_UID
+CONFDIR
+COPTIMISE_FLAG
+DEBUG
 DEVICE_GID
 DEVICE_MODE
+DEVICE_UID
+DEVMAPPER
+DMDIR
 DMEVENTD
+DMIOCTLS
+DM_LIB_VERSION
+FSADM
+GROUP
+HAVE_LIBDL
+HAVE_REALTIME
+HAVE_SELINUX
+INTL
+INTL_PACKAGE
+JOBS
+LDDEPS
+LIB_SUFFIX
+LOCALEDIR
+LVM1
+LVM1_FALLBACK
+LVM_VERSION
+MIRRORS
+OWNER
 PKGCONFIG
+POOL
+SNAPSHOTS
+STATICDIR
+STATIC_LINK
 LIB_PTHREAD
+interface
+kerneldir
+missingkernel
+kernelvsn
+tmpdir
+usrlibdir
 LTLIBOBJS'
 ac_subst_files=''
       ac_precious_vars='build_alias
@@ -1293,7 +1316,6 @@
 Optional Features:
   --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
   --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
-  --enable-jobs=NUM       Number of jobs to run simultaneously
   --enable-debug          Enable debugging
   --enable-compat         Enable support for old device-mapper versions
   --disable-driver        Disable calls to device-mapper in the kernel
@@ -1754,8 +1776,6 @@
 
 
 
-
-################################################################################
 ac_config_headers="$ac_config_headers include/configure.h"
 
 
@@ -1922,21 +1942,35 @@
 
 case "$host_os" in
 	linux*)
-		CFLAGS="$CFLAGS"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS -Wl,--version-script,.export.sym"
+		CLDWHOLEARCHIVE="-Wl,-whole-archive"
+		CLDNOWHOLEARCHIVE="-Wl,-no-whole-archive"
 		LDDEPS="$LDDEPS .export.sym"
-		LIB_SUFFIX="so"
-		DMIOCTLS="yes"
-		SELINUX="yes" ;;
+		LIB_SUFFIX=so
+		DEVMAPPER=yes
+		ODIRECT=yes
+		DMIOCTLS=yes
+		SELINUX=yes
+		REALTIME=yes
+		CLUSTER=internal
+		FSADM=no
+		;;
 	darwin*)
 		CFLAGS="$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS"
-		LDDEPS="$LDDEPS"
-		LIB_SUFFIX="dylib"
-		DMIOCTLS="no"
-		SELINUX="no" ;;
+		CLDWHOLEARCHIVE="-all_load"
+		CLDNOWHOLEARCHIVE=
+		LIB_SUFFIX=dylib
+		DEVMAPPER=yes
+		ODIRECT=no
+		DMIOCTLS=no
+		SELINUX=no
+		REALTIME=no
+		CLUSTER=none
+		FSADM=no
+		;;
 esac
 
 ################################################################################
@@ -2905,6 +2939,7 @@
 ac_compiler_gnu=$ac_cv_c_compiler_gnu
 
 
+
 ac_ext=c
 ac_cpp='$CPP $CPPFLAGS'
 ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&5'
@@ -3566,6 +3601,87 @@
 fi
 
 
+# Extract the first word of "cflow", so it can be a program name with args.
+set dummy cflow; ac_word=$2
+{ echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6; }
+if test "${ac_cv_path_CFLOW_CMD+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  case $CFLOW_CMD in
+  [\\/]* | ?:[\\/]*)
+  ac_cv_path_CFLOW_CMD="$CFLOW_CMD" # Let the user override the test with a path.
+  ;;
+  *)
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if { test -f "$as_dir/$ac_word$ac_exec_ext" && $as_test_x "$as_dir/$ac_word$ac_exec_ext"; }; then
+    ac_cv_path_CFLOW_CMD="$as_dir/$ac_word$ac_exec_ext"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+IFS=$as_save_IFS
+
+  ;;
+esac
+fi
+CFLOW_CMD=$ac_cv_path_CFLOW_CMD
+if test -n "$CFLOW_CMD"; then
+  { echo "$as_me:$LINENO: result: $CFLOW_CMD" >&5
+echo "${ECHO_T}$CFLOW_CMD" >&6; }
+else
+  { echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6; }
+fi
+
+
+# Extract the first word of "cscope", so it can be a program name with args.
+set dummy cscope; ac_word=$2
+{ echo "$as_me:$LINENO: checking for $ac_word" >&5
+echo $ECHO_N "checking for $ac_word... $ECHO_C" >&6; }
+if test "${ac_cv_path_CSCOPE_CMD+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  case $CSCOPE_CMD in
+  [\\/]* | ?:[\\/]*)
+  ac_cv_path_CSCOPE_CMD="$CSCOPE_CMD" # Let the user override the test with a path.
+  ;;
+  *)
+  as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
+for as_dir in $PATH
+do
+  IFS=$as_save_IFS
+  test -z "$as_dir" && as_dir=.
+  for ac_exec_ext in '' $ac_executable_extensions; do
+  if { test -f "$as_dir/$ac_word$ac_exec_ext" && $as_test_x "$as_dir/$ac_word$ac_exec_ext"; }; then
+    ac_cv_path_CSCOPE_CMD="$as_dir/$ac_word$ac_exec_ext"
+    echo "$as_me:$LINENO: found $as_dir/$ac_word$ac_exec_ext" >&5
+    break 2
+  fi
+done
+done
+IFS=$as_save_IFS
+
+  ;;
+esac
+fi
+CSCOPE_CMD=$ac_cv_path_CSCOPE_CMD
+if test -n "$CSCOPE_CMD"; then
+  { echo "$as_me:$LINENO: result: $CSCOPE_CMD" >&5
+echo "${ECHO_T}$CSCOPE_CMD" >&6; }
+else
+  { echo "$as_me:$LINENO: result: no" >&5
+echo "${ECHO_T}no" >&6; }
+fi
+
+
+
 ################################################################################
 
 
@@ -3982,6 +4098,73 @@
 
 fi
 
+{ echo "$as_me:$LINENO: checking for sys/wait.h that is POSIX.1 compatible" >&5
+echo $ECHO_N "checking for sys/wait.h that is POSIX.1 compatible... $ECHO_C" >&6; }
+if test "${ac_cv_header_sys_wait_h+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <sys/wait.h>
+#ifndef WEXITSTATUS
+# define WEXITSTATUS(stat_val) ((unsigned int) (stat_val) >> 8)
+#endif
+#ifndef WIFEXITED
+# define WIFEXITED(stat_val) (((stat_val) & 255) == 0)
+#endif
+
+int
+main ()
+{
+  int s;
+  wait (&s);
+  s = WIFEXITED (s) ? WEXITSTATUS (s) : 1;
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_header_sys_wait_h=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_header_sys_wait_h=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_header_sys_wait_h" >&5
+echo "${ECHO_T}$ac_cv_header_sys_wait_h" >&6; }
+if test $ac_cv_header_sys_wait_h = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_SYS_WAIT_H 1
+_ACEOF
+
+fi
+
 { echo "$as_me:$LINENO: checking whether time.h and sys/time.h may both be included" >&5
 echo $ECHO_N "checking whether time.h and sys/time.h may both be included... $ECHO_C" >&6; }
 if test "${ac_cv_header_time+set}" = set; then
@@ -4129,7 +4312,9 @@
 
 
 
-for ac_header in ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h sys/types.h unistd.h
+for ac_header in ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h \
+  stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h \
+  sys/types.h unistd.h
 do
 as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
 if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
@@ -4274,7 +4459,6 @@
 
 
 
-
 for ac_header in termios.h sys/statvfs.h
 do
 as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
@@ -4414,6 +4598,7 @@
 
 done
 
+
 ################################################################################
 { echo "$as_me:$LINENO: checking for an ANSI C-conforming const" >&5
 echo $ECHO_N "checking for an ANSI C-conforming const... $ECHO_C" >&6; }
@@ -4938,22 +5123,9 @@
 
 fi
 
-
-################################################################################
-
-
-
-
-
-
-
-
-for ac_func in memset mkdir rmdir strchr strdup strerror strrchr uname
-do
-as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
-{ echo "$as_me:$LINENO: checking for $ac_func" >&5
-echo $ECHO_N "checking for $ac_func... $ECHO_C" >&6; }
-if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
+{ echo "$as_me:$LINENO: checking for mode_t" >&5
+echo $ECHO_N "checking for mode_t... $ECHO_C" >&6; }
+if test "${ac_cv_type_mode_t+set}" = set; then
   echo $ECHO_N "(cached) $ECHO_C" >&6
 else
   cat >conftest.$ac_ext <<_ACEOF
@@ -4962,53 +5134,27 @@
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
-/* Define $ac_func to an innocuous variant, in case <limits.h> declares $ac_func.
-   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
-#define $ac_func innocuous_$ac_func
-
-/* System header to define __stub macros and hopefully few prototypes,
-    which can conflict with char $ac_func (); below.
-    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
-    <limits.h> exists even on freestanding compilers.  */
-
-#ifdef __STDC__
-# include <limits.h>
-#else
-# include <assert.h>
-#endif
-
-#undef $ac_func
-
-/* Override any GCC internal prototype to avoid an error.
-   Use char because int might match the return type of a GCC
-   builtin and then its argument prototype would still apply.  */
-#ifdef __cplusplus
-extern "C"
-#endif
-char $ac_func ();
-/* The GNU C library defines this for functions which it implements
-    to always fail with ENOSYS.  Some functions are actually named
-    something starting with __ and the normal name is an alias.  */
-#if defined __stub_$ac_func || defined __stub___$ac_func
-choke me
-#endif
-
+$ac_includes_default
+typedef mode_t ac__type_new_;
 int
 main ()
 {
-return $ac_func ();
+if ((ac__type_new_ *) 0)
+  return 0;
+if (sizeof (ac__type_new_))
+  return 0;
   ;
   return 0;
 }
 _ACEOF
-rm -f conftest.$ac_objext conftest$ac_exeext
-if { (ac_try="$ac_link"
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
 case "(($ac_try" in
   *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
   *) ac_try_echo=$ac_try;;
 esac
 eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
-  (eval "$ac_link") 2>conftest.er1
+  (eval "$ac_compile") 2>conftest.er1
   ac_status=$?
   grep -v '^ *+' conftest.er1 >conftest.err
   rm -f conftest.er1
@@ -5017,42 +5163,34 @@
   (exit $ac_status); } && {
 	 test -z "$ac_c_werror_flag" ||
 	 test ! -s conftest.err
-       } && test -s conftest$ac_exeext &&
-       $as_test_x conftest$ac_exeext; then
-  eval "$as_ac_var=yes"
+       } && test -s conftest.$ac_objext; then
+  ac_cv_type_mode_t=yes
 else
   echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	eval "$as_ac_var=no"
+	ac_cv_type_mode_t=no
 fi
 
-rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
-      conftest$ac_exeext conftest.$ac_ext
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
 fi
-ac_res=`eval echo '${'$as_ac_var'}'`
-	       { echo "$as_me:$LINENO: result: $ac_res" >&5
-echo "${ECHO_T}$ac_res" >&6; }
-if test `eval echo '${'$as_ac_var'}'` = yes; then
-  cat >>confdefs.h <<_ACEOF
-#define `echo "HAVE_$ac_func" | $as_tr_cpp` 1
+{ echo "$as_me:$LINENO: result: $ac_cv_type_mode_t" >&5
+echo "${ECHO_T}$ac_cv_type_mode_t" >&6; }
+if test $ac_cv_type_mode_t = yes; then
+  :
+else
+
+cat >>confdefs.h <<_ACEOF
+#define mode_t int
 _ACEOF
 
-else
-  { { echo "$as_me:$LINENO: error: bailing out" >&5
-echo "$as_me: error: bailing out" >&2;}
-   { (exit 1); exit 1; }; }
 fi
-done
 
-{ echo "$as_me:$LINENO: checking whether closedir returns void" >&5
-echo $ECHO_N "checking whether closedir returns void... $ECHO_C" >&6; }
-if test "${ac_cv_func_closedir_void+set}" = set; then
+{ echo "$as_me:$LINENO: checking for struct stat.st_rdev" >&5
+echo $ECHO_N "checking for struct stat.st_rdev... $ECHO_C" >&6; }
+if test "${ac_cv_member_struct_stat_st_rdev+set}" = set; then
   echo $ECHO_N "(cached) $ECHO_C" >&6
 else
-  if test "$cross_compiling" = yes; then
-  ac_cv_func_closedir_void=yes
-else
   cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
 _ACEOF
@@ -5060,20 +5198,1525 @@
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
 $ac_includes_default
-#include <$ac_header_dirent>
-#ifndef __cplusplus
-int closedir ();
-#endif
-
 int
 main ()
 {
-return closedir (opendir (".")) != 0;
+static struct stat ac_aggr;
+if (ac_aggr.st_rdev)
+return 0;
   ;
   return 0;
 }
 _ACEOF
-rm -f conftest$ac_exeext
+rm -f conftest.$ac_objext
+if { (ac_try="$ac_compile"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_member_struct_stat_st_rdev=yes
+else
+  echo "$as_me: failed program was:" >&5
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_member_struct_stat_st_rdev=yes
+else
+  echo "$as_me: failed program was:" >&5
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
+{ echo "$as_me:$LINENO: result: $ac_cv_member_struct_stat_st_rdev" >&5
+echo "${ECHO_T}$ac_cv_member_struct_stat_st_rdev" >&6; }
+if test $ac_cv_member_struct_stat_st_rdev = yes; then
+
+cat >>confdefs.h <<_ACEOF
+#define HAVE_STRUCT_STAT_ST_RDEV 1
+_ACEOF
+
+
+fi
+
+{ echo "$as_me:$LINENO: checking whether struct tm is in sys/time.h or time.h" >&5
+echo $ECHO_N "checking whether struct tm is in sys/time.h or time.h... $ECHO_C" >&6; }
+if test "${ac_cv_struct_tm+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <sys/types.h>
+#include <time.h>
+
+int
+main ()
+{
+struct tm tm;
+				     int *p = &tm.tm_sec;
+ 				     return !p;
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_cv_struct_tm=time.h
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_struct_tm=sys/time.h
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_struct_tm" >&5
+echo "${ECHO_T}$ac_cv_struct_tm" >&6; }
+if test $ac_cv_struct_tm = sys/time.h; then
+
+cat >>confdefs.h <<\_ACEOF
+#define TM_IN_SYS_TIME 1
+_ACEOF
+
+fi
+
+
+################################################################################
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+for ac_func in gethostname getpagesize memset mkdir rmdir munmap setlocale \
+  strcasecmp strchr strdup strncasecmp strerror strrchr strstr strtol strtoul \
+  uname
+do
+as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
+{ echo "$as_me:$LINENO: checking for $ac_func" >&5
+echo $ECHO_N "checking for $ac_func... $ECHO_C" >&6; }
+if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  eval "$as_ac_var=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	eval "$as_ac_var=no"
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+ac_res=`eval echo '${'$as_ac_var'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+if test `eval echo '${'$as_ac_var'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_func" | $as_tr_cpp` 1
+_ACEOF
+
+else
+  { { echo "$as_me:$LINENO: error: bailing out" >&5
+echo "$as_me: error: bailing out" >&2;}
+   { (exit 1); exit 1; }; }
+fi
+done
+
+# The Ultrix 4.2 mips builtin alloca declared by alloca.h only works
+# for constant arguments.  Useless!
+{ echo "$as_me:$LINENO: checking for working alloca.h" >&5
+echo $ECHO_N "checking for working alloca.h... $ECHO_C" >&6; }
+if test "${ac_cv_working_alloca_h+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#include <alloca.h>
+int
+main ()
+{
+char *p = (char *) alloca (2 * sizeof (int));
+			  if (p) return 0;
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  ac_cv_working_alloca_h=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_working_alloca_h=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_working_alloca_h" >&5
+echo "${ECHO_T}$ac_cv_working_alloca_h" >&6; }
+if test $ac_cv_working_alloca_h = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_ALLOCA_H 1
+_ACEOF
+
+fi
+
+{ echo "$as_me:$LINENO: checking for alloca" >&5
+echo $ECHO_N "checking for alloca... $ECHO_C" >&6; }
+if test "${ac_cv_func_alloca_works+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#ifdef __GNUC__
+# define alloca __builtin_alloca
+#else
+# ifdef _MSC_VER
+#  include <malloc.h>
+#  define alloca _alloca
+# else
+#  ifdef HAVE_ALLOCA_H
+#   include <alloca.h>
+#  else
+#   ifdef _AIX
+ #pragma alloca
+#   else
+#    ifndef alloca /* predefined by HP cc +Olibcalls */
+char *alloca ();
+#    endif
+#   endif
+#  endif
+# endif
+#endif
+
+int
+main ()
+{
+char *p = (char *) alloca (1);
+				    if (p) return 0;
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  ac_cv_func_alloca_works=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_func_alloca_works=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_alloca_works" >&5
+echo "${ECHO_T}$ac_cv_func_alloca_works" >&6; }
+
+if test $ac_cv_func_alloca_works = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_ALLOCA 1
+_ACEOF
+
+else
+  # The SVR3 libPW and SVR4 libucb both contain incompatible functions
+# that cause trouble.  Some versions do not even contain alloca or
+# contain a buggy version.  If you still want to use their alloca,
+# use ar to extract alloca.o from them instead of compiling alloca.c.
+
+ALLOCA=\${LIBOBJDIR}alloca.$ac_objext
+
+cat >>confdefs.h <<\_ACEOF
+#define C_ALLOCA 1
+_ACEOF
+
+
+{ echo "$as_me:$LINENO: checking whether \`alloca.c' needs Cray hooks" >&5
+echo $ECHO_N "checking whether \`alloca.c' needs Cray hooks... $ECHO_C" >&6; }
+if test "${ac_cv_os_cray+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+#if defined CRAY && ! defined CRAY2
+webecray
+#else
+wenotbecray
+#endif
+
+_ACEOF
+if (eval "$ac_cpp conftest.$ac_ext") 2>&5 |
+  $EGREP "webecray" >/dev/null 2>&1; then
+  ac_cv_os_cray=yes
+else
+  ac_cv_os_cray=no
+fi
+rm -f conftest*
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_os_cray" >&5
+echo "${ECHO_T}$ac_cv_os_cray" >&6; }
+if test $ac_cv_os_cray = yes; then
+  for ac_func in _getb67 GETB67 getb67; do
+    as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
+{ echo "$as_me:$LINENO: checking for $ac_func" >&5
+echo $ECHO_N "checking for $ac_func... $ECHO_C" >&6; }
+if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  eval "$as_ac_var=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	eval "$as_ac_var=no"
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+ac_res=`eval echo '${'$as_ac_var'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+if test `eval echo '${'$as_ac_var'}'` = yes; then
+
+cat >>confdefs.h <<_ACEOF
+#define CRAY_STACKSEG_END $ac_func
+_ACEOF
+
+    break
+fi
+
+  done
+fi
+
+{ echo "$as_me:$LINENO: checking stack direction for C alloca" >&5
+echo $ECHO_N "checking stack direction for C alloca... $ECHO_C" >&6; }
+if test "${ac_cv_c_stack_direction+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test "$cross_compiling" = yes; then
+  ac_cv_c_stack_direction=0
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+int
+find_stack_direction ()
+{
+  static char *addr = 0;
+  auto char dummy;
+  if (addr == 0)
+    {
+      addr = &dummy;
+      return find_stack_direction ();
+    }
+  else
+    return (&dummy > addr) ? 1 : -1;
+}
+
+int
+main ()
+{
+  return find_stack_direction () < 0;
+}
+_ACEOF
+rm -f conftest$ac_exeext
+if { (ac_try="$ac_link"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_c_stack_direction=1
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_c_stack_direction=-1
+fi
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_c_stack_direction" >&5
+echo "${ECHO_T}$ac_cv_c_stack_direction" >&6; }
+
+cat >>confdefs.h <<_ACEOF
+#define STACK_DIRECTION $ac_cv_c_stack_direction
+_ACEOF
+
+
+fi
+
+{ echo "$as_me:$LINENO: checking whether closedir returns void" >&5
+echo $ECHO_N "checking whether closedir returns void... $ECHO_C" >&6; }
+if test "${ac_cv_func_closedir_void+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_closedir_void=yes
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+$ac_includes_default
+#include <$ac_header_dirent>
+#ifndef __cplusplus
+int closedir ();
+#endif
+
+int
+main ()
+{
+return closedir (opendir (".")) != 0;
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_func_closedir_void=no
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_closedir_void=yes
+fi
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_closedir_void" >&5
+echo "${ECHO_T}$ac_cv_func_closedir_void" >&6; }
+if test $ac_cv_func_closedir_void = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define CLOSEDIR_VOID 1
+_ACEOF
+
+fi
+
+
+for ac_header in vfork.h
+do
+as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  { echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+fi
+ac_res=`eval echo '${'$as_ac_Header'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+else
+  # Is the header compilable?
+{ echo "$as_me:$LINENO: checking $ac_header usability" >&5
+echo $ECHO_N "checking $ac_header usability... $ECHO_C" >&6; }
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_header_compiler=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_header_compiler=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+{ echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+echo "${ECHO_T}$ac_header_compiler" >&6; }
+
+# Is the header present?
+{ echo "$as_me:$LINENO: checking $ac_header presence" >&5
+echo $ECHO_N "checking $ac_header presence... $ECHO_C" >&6; }
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_cpp conftest.$ac_ext") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null && {
+	 test -z "$ac_c_preproc_warn_flag$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       }; then
+  ac_header_preproc=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  ac_header_preproc=no
+fi
+
+rm -f conftest.err conftest.$ac_ext
+{ echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+echo "${ECHO_T}$ac_header_preproc" >&6; }
+
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
+
+    ;;
+esac
+{ echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  eval "$as_ac_Header=\$ac_header_preproc"
+fi
+ac_res=`eval echo '${'$as_ac_Header'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+
+fi
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+
+done
+
+
+
+for ac_func in fork vfork
+do
+as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
+{ echo "$as_me:$LINENO: checking for $ac_func" >&5
+echo $ECHO_N "checking for $ac_func... $ECHO_C" >&6; }
+if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  eval "$as_ac_var=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	eval "$as_ac_var=no"
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+ac_res=`eval echo '${'$as_ac_var'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+if test `eval echo '${'$as_ac_var'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_func" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+done
+
+if test "x$ac_cv_func_fork" = xyes; then
+  { echo "$as_me:$LINENO: checking for working fork" >&5
+echo $ECHO_N "checking for working fork... $ECHO_C" >&6; }
+if test "${ac_cv_func_fork_works+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_fork_works=cross
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
+
+	  /* By Ruediger Kuhlmann. */
+	  return fork () < 0;
+
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_func_fork_works=yes
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_fork_works=no
+fi
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_fork_works" >&5
+echo "${ECHO_T}$ac_cv_func_fork_works" >&6; }
+
+else
+  ac_cv_func_fork_works=$ac_cv_func_fork
+fi
+if test "x$ac_cv_func_fork_works" = xcross; then
+  case $host in
+    *-*-amigaos* | *-*-msdosdjgpp*)
+      # Override, as these systems have only a dummy fork() stub
+      ac_cv_func_fork_works=no
+      ;;
+    *)
+      ac_cv_func_fork_works=yes
+      ;;
+  esac
+  { echo "$as_me:$LINENO: WARNING: result $ac_cv_func_fork_works guessed because of cross compilation" >&5
+echo "$as_me: WARNING: result $ac_cv_func_fork_works guessed because of cross compilation" >&2;}
+fi
+ac_cv_func_vfork_works=$ac_cv_func_vfork
+if test "x$ac_cv_func_vfork" = xyes; then
+  { echo "$as_me:$LINENO: checking for working vfork" >&5
+echo $ECHO_N "checking for working vfork... $ECHO_C" >&6; }
+if test "${ac_cv_func_vfork_works+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_vfork_works=cross
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Thanks to Paul Eggert for this test.  */
+$ac_includes_default
+#include <sys/wait.h>
+#ifdef HAVE_VFORK_H
+# include <vfork.h>
+#endif
+/* On some sparc systems, changes by the child to local and incoming
+   argument registers are propagated back to the parent.  The compiler
+   is told about this with #include <vfork.h>, but some compilers
+   (e.g. gcc -O) don't grok <vfork.h>.  Test for this by using a
+   static variable whose address is put into a register that is
+   clobbered by the vfork.  */
+static void
+#ifdef __cplusplus
+sparc_address_test (int arg)
+# else
+sparc_address_test (arg) int arg;
+#endif
+{
+  static pid_t child;
+  if (!child) {
+    child = vfork ();
+    if (child < 0) {
+      perror ("vfork");
+      _exit(2);
+    }
+    if (!child) {
+      arg = getpid();
+      write(-1, "", 0);
+      _exit (arg);
+    }
+  }
+}
+
+int
+main ()
+{
+  pid_t parent = getpid ();
+  pid_t child;
+
+  sparc_address_test (0);
+
+  child = vfork ();
+
+  if (child == 0) {
+    /* Here is another test for sparc vfork register problems.  This
+       test uses lots of local variables, at least as many local
+       variables as main has allocated so far including compiler
+       temporaries.  4 locals are enough for gcc 1.40.3 on a Solaris
+       4.1.3 sparc, but we use 8 to be safe.  A buggy compiler should
+       reuse the register of parent for one of the local variables,
+       since it will think that parent can't possibly be used any more
+       in this routine.  Assigning to the local variable will thus
+       munge parent in the parent process.  */
+    pid_t
+      p = getpid(), p1 = getpid(), p2 = getpid(), p3 = getpid(),
+      p4 = getpid(), p5 = getpid(), p6 = getpid(), p7 = getpid();
+    /* Convince the compiler that p..p7 are live; otherwise, it might
+       use the same hardware register for all 8 local variables.  */
+    if (p != p1 || p != p2 || p != p3 || p != p4
+	|| p != p5 || p != p6 || p != p7)
+      _exit(1);
+
+    /* On some systems (e.g. IRIX 3.3), vfork doesn't separate parent
+       from child file descriptors.  If the child closes a descriptor
+       before it execs or exits, this munges the parent's descriptor
+       as well.  Test for this by closing stdout in the child.  */
+    _exit(close(fileno(stdout)) != 0);
+  } else {
+    int status;
+    struct stat st;
+
+    while (wait(&status) != child)
+      ;
+    return (
+	 /* Was there some problem with vforking?  */
+	 child < 0
+
+	 /* Did the child fail?  (This shouldn't happen.)  */
+	 || status
+
+	 /* Did the vfork/compiler bug occur?  */
+	 || parent != getpid()
+
+	 /* Did the file descriptor bug occur?  */
+	 || fstat(fileno(stdout), &st) != 0
+	 );
+  }
+}
+_ACEOF
+rm -f conftest$ac_exeext
+if { (ac_try="$ac_link"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_func_vfork_works=yes
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_vfork_works=no
+fi
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_vfork_works" >&5
+echo "${ECHO_T}$ac_cv_func_vfork_works" >&6; }
+
+fi;
+if test "x$ac_cv_func_fork_works" = xcross; then
+  ac_cv_func_vfork_works=$ac_cv_func_vfork
+  { echo "$as_me:$LINENO: WARNING: result $ac_cv_func_vfork_works guessed because of cross compilation" >&5
+echo "$as_me: WARNING: result $ac_cv_func_vfork_works guessed because of cross compilation" >&2;}
+fi
+
+if test "x$ac_cv_func_vfork_works" = xyes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_WORKING_VFORK 1
+_ACEOF
+
+else
+
+cat >>confdefs.h <<\_ACEOF
+#define vfork fork
+_ACEOF
+
+fi
+if test "x$ac_cv_func_fork_works" = xyes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_WORKING_FORK 1
+_ACEOF
+
+fi
+
+{ echo "$as_me:$LINENO: checking whether lstat dereferences a symlink specified with a trailing slash" >&5
+echo $ECHO_N "checking whether lstat dereferences a symlink specified with a trailing slash... $ECHO_C" >&6; }
+if test "${ac_cv_func_lstat_dereferences_slashed_symlink+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_func_lstat_dereferences_slashed_symlink=yes
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_lstat_dereferences_slashed_symlink=no
+fi
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+else
+  # If the `ln -s' command failed, then we probably don't even
+  # have an lstat function.
+  ac_cv_func_lstat_dereferences_slashed_symlink=no
+fi
+rm -f conftest.sym conftest.file
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_lstat_dereferences_slashed_symlink" >&5
+echo "${ECHO_T}$ac_cv_func_lstat_dereferences_slashed_symlink" >&6; }
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
+
+fi
+
+{ echo "$as_me:$LINENO: checking whether lstat accepts an empty string" >&5
+echo $ECHO_N "checking whether lstat accepts an empty string... $ECHO_C" >&6; }
+if test "${ac_cv_func_lstat_empty_string_bug+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_lstat_empty_string_bug=yes
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
+  return lstat ("", &sbuf) == 0;
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_func_lstat_empty_string_bug=no
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_lstat_empty_string_bug=yes
+fi
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_lstat_empty_string_bug" >&5
+echo "${ECHO_T}$ac_cv_func_lstat_empty_string_bug" >&6; }
+if test $ac_cv_func_lstat_empty_string_bug = yes; then
+  case " $LIBOBJS " in
+  *" lstat.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS lstat.$ac_objext"
+ ;;
+esac
+
+
+cat >>confdefs.h <<_ACEOF
+#define HAVE_LSTAT_EMPTY_STRING_BUG 1
+_ACEOF
+
+fi
+
+
+for ac_header in stdlib.h
+do
+as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  { echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+fi
+ac_res=`eval echo '${'$as_ac_Header'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+else
+  # Is the header compilable?
+{ echo "$as_me:$LINENO: checking $ac_header usability" >&5
+echo $ECHO_N "checking $ac_header usability... $ECHO_C" >&6; }
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_compile") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest.$ac_objext; then
+  ac_header_compiler=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_header_compiler=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest.$ac_ext
+{ echo "$as_me:$LINENO: result: $ac_header_compiler" >&5
+echo "${ECHO_T}$ac_header_compiler" >&6; }
+
+# Is the header present?
+{ echo "$as_me:$LINENO: checking $ac_header presence" >&5
+echo $ECHO_N "checking $ac_header presence... $ECHO_C" >&6; }
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_cpp conftest.$ac_ext") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } >/dev/null && {
+	 test -z "$ac_c_preproc_warn_flag$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       }; then
+  ac_header_preproc=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+  ac_header_preproc=no
+fi
+
+rm -f conftest.err conftest.$ac_ext
+{ echo "$as_me:$LINENO: result: $ac_header_preproc" >&5
+echo "${ECHO_T}$ac_header_preproc" >&6; }
+
+# So?  What about this header?
+case $ac_header_compiler:$ac_header_preproc:$ac_c_preproc_warn_flag in
+  yes:no: )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&5
+echo "$as_me: WARNING: $ac_header: accepted by the compiler, rejected by the preprocessor!" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the compiler's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the compiler's result" >&2;}
+    ac_header_preproc=yes
+    ;;
+  no:yes:* )
+    { echo "$as_me:$LINENO: WARNING: $ac_header: present but cannot be compiled" >&5
+echo "$as_me: WARNING: $ac_header: present but cannot be compiled" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     check for missing prerequisite headers?" >&5
+echo "$as_me: WARNING: $ac_header:     check for missing prerequisite headers?" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: see the Autoconf documentation" >&5
+echo "$as_me: WARNING: $ac_header: see the Autoconf documentation" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&5
+echo "$as_me: WARNING: $ac_header:     section \"Present But Cannot Be Compiled\"" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: proceeding with the preprocessor's result" >&5
+echo "$as_me: WARNING: $ac_header: proceeding with the preprocessor's result" >&2;}
+    { echo "$as_me:$LINENO: WARNING: $ac_header: in the future, the compiler will take precedence" >&5
+echo "$as_me: WARNING: $ac_header: in the future, the compiler will take precedence" >&2;}
+
+    ;;
+esac
+{ echo "$as_me:$LINENO: checking for $ac_header" >&5
+echo $ECHO_N "checking for $ac_header... $ECHO_C" >&6; }
+if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  eval "$as_ac_Header=\$ac_header_preproc"
+fi
+ac_res=`eval echo '${'$as_ac_Header'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+
+fi
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+
+done
+
+{ echo "$as_me:$LINENO: checking for GNU libc compatible malloc" >&5
+echo $ECHO_N "checking for GNU libc compatible malloc... $ECHO_C" >&6; }
+if test "${ac_cv_func_malloc_0_nonnull+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
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
 if { (ac_try="$ac_link"
 case "(($ac_try" in
   *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
@@ -5093,32 +6736,141 @@
   ac_status=$?
   echo "$as_me:$LINENO: \$? = $ac_status" >&5
   (exit $ac_status); }; }; then
-  ac_cv_func_closedir_void=no
+  ac_cv_func_malloc_0_nonnull=yes
 else
   echo "$as_me: program exited with status $ac_status" >&5
 echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
 ( exit $ac_status )
-ac_cv_func_closedir_void=yes
+ac_cv_func_malloc_0_nonnull=no
 fi
 rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
 
 
 fi
-{ echo "$as_me:$LINENO: result: $ac_cv_func_closedir_void" >&5
-echo "${ECHO_T}$ac_cv_func_closedir_void" >&6; }
-if test $ac_cv_func_closedir_void = yes; then
+{ echo "$as_me:$LINENO: result: $ac_cv_func_malloc_0_nonnull" >&5
+echo "${ECHO_T}$ac_cv_func_malloc_0_nonnull" >&6; }
+if test $ac_cv_func_malloc_0_nonnull = yes; then
 
 cat >>confdefs.h <<\_ACEOF
-#define CLOSEDIR_VOID 1
+#define HAVE_MALLOC 1
+_ACEOF
+
+else
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
 _ACEOF
 
 fi
 
 
-for ac_header in stdlib.h
+
+{ echo "$as_me:$LINENO: checking for working memcmp" >&5
+echo $ECHO_N "checking for working memcmp... $ECHO_C" >&6; }
+if test "${ac_cv_func_memcmp_working+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  if test "$cross_compiling" = yes; then
+  ac_cv_func_memcmp_working=no
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
+
+  /* Some versions of memcmp are not 8-bit clean.  */
+  char c0 = '\100', c1 = '\200', c2 = '\201';
+  if (memcmp(&c0, &c2, 1) >= 0 || memcmp(&c1, &c2, 1) >= 0)
+    return 1;
+
+  /* The Next x86 OpenStep bug shows up only when comparing 16 bytes
+     or more and with at least one buffer not starting on a 4-byte boundary.
+     William Lewis provided this test program.   */
+  {
+    char foo[21];
+    char bar[21];
+    int i;
+    for (i = 0; i < 4; i++)
+      {
+	char *a = foo + i;
+	char *b = bar + i;
+	strcpy (a, "--------01111111");
+	strcpy (b, "--------10000000");
+	if (memcmp (a, b, 16) >= 0)
+	  return 1;
+      }
+    return 0;
+  }
+
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && { ac_try='./conftest$ac_exeext'
+  { (case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_try") 2>&5
+  ac_status=$?
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); }; }; then
+  ac_cv_func_memcmp_working=yes
+else
+  echo "$as_me: program exited with status $ac_status" >&5
+echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+( exit $ac_status )
+ac_cv_func_memcmp_working=no
+fi
+rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
+fi
+
+
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_memcmp_working" >&5
+echo "${ECHO_T}$ac_cv_func_memcmp_working" >&6; }
+test $ac_cv_func_memcmp_working = no && case " $LIBOBJS " in
+  *" memcmp.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS memcmp.$ac_objext"
+ ;;
+esac
+
+
+
+
+for ac_header in stdlib.h unistd.h
 do
 as_ac_Header=`echo "ac_cv_header_$ac_header" | $as_tr_sh`
 if { as_var=$as_ac_Header; eval "test \"\${$as_var+set}\" = set"; }; then
@@ -5243,27 +6995,121 @@
 else
   eval "$as_ac_Header=\$ac_header_preproc"
 fi
-ac_res=`eval echo '${'$as_ac_Header'}'`
+ac_res=`eval echo '${'$as_ac_Header'}'`
+	       { echo "$as_me:$LINENO: result: $ac_res" >&5
+echo "${ECHO_T}$ac_res" >&6; }
+
+fi
+if test `eval echo '${'$as_ac_Header'}'` = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+_ACEOF
+
+fi
+
+done
+
+
+for ac_func in getpagesize
+do
+as_ac_var=`echo "ac_cv_func_$ac_func" | $as_tr_sh`
+{ echo "$as_me:$LINENO: checking for $ac_func" >&5
+echo $ECHO_N "checking for $ac_func... $ECHO_C" >&6; }
+if { as_var=$as_ac_var; eval "test \"\${$as_var+set}\" = set"; }; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  eval "$as_ac_var=yes"
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	eval "$as_ac_var=no"
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+ac_res=`eval echo '${'$as_ac_var'}'`
 	       { echo "$as_me:$LINENO: result: $ac_res" >&5
 echo "${ECHO_T}$ac_res" >&6; }
-
-fi
-if test `eval echo '${'$as_ac_Header'}'` = yes; then
+if test `eval echo '${'$as_ac_var'}'` = yes; then
   cat >>confdefs.h <<_ACEOF
-#define `echo "HAVE_$ac_header" | $as_tr_cpp` 1
+#define `echo "HAVE_$ac_func" | $as_tr_cpp` 1
 _ACEOF
 
 fi
-
 done
 
-{ echo "$as_me:$LINENO: checking for GNU libc compatible malloc" >&5
-echo $ECHO_N "checking for GNU libc compatible malloc... $ECHO_C" >&6; }
-if test "${ac_cv_func_malloc_0_nonnull+set}" = set; then
+{ echo "$as_me:$LINENO: checking for working mmap" >&5
+echo $ECHO_N "checking for working mmap... $ECHO_C" >&6; }
+if test "${ac_cv_func_mmap_fixed_mapped+set}" = set; then
   echo $ECHO_N "(cached) $ECHO_C" >&6
 else
   if test "$cross_compiling" = yes; then
-  ac_cv_func_malloc_0_nonnull=no
+  ac_cv_func_mmap_fixed_mapped=no
 else
   cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
@@ -5271,17 +7117,130 @@
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
-#if defined STDC_HEADERS || defined HAVE_STDLIB_H
-# include <stdlib.h>
-#else
+$ac_includes_default
+/* malloc might have been renamed as rpl_malloc. */
+#undef malloc
+
+/* Thanks to Mike Haertel and Jim Avera for this test.
+   Here is a matrix of mmap possibilities:
+	mmap private not fixed
+	mmap private fixed at somewhere currently unmapped
+	mmap private fixed at somewhere already mapped
+	mmap shared not fixed
+	mmap shared fixed at somewhere currently unmapped
+	mmap shared fixed at somewhere already mapped
+   For private mappings, we should verify that changes cannot be read()
+   back from the file, nor mmap's back from the file at a different
+   address.  (There have been systems where private was not correctly
+   implemented like the infamous i386 svr4.0, and systems where the
+   VM page cache was not coherent with the file system buffer cache
+   like early versions of FreeBSD and possibly contemporary NetBSD.)
+   For shared mappings, we should conversely verify that changes get
+   propagated back to all the places they're supposed to be.
+
+   Grep wants private fixed already mapped.
+   The main things grep needs to know about mmap are:
+   * does it exist and is it safe to write into the mmap'd area
+   * how to use it (BSD variants)  */
+
+#include <fcntl.h>
+#include <sys/mman.h>
+
+#if !defined STDC_HEADERS && !defined HAVE_STDLIB_H
 char *malloc ();
 #endif
 
+/* This mess was copied from the GNU getpagesize.h.  */
+#ifndef HAVE_GETPAGESIZE
+/* Assume that all systems that can run configure have sys/param.h.  */
+# ifndef HAVE_SYS_PARAM_H
+#  define HAVE_SYS_PARAM_H 1
+# endif
+
+# ifdef _SC_PAGESIZE
+#  define getpagesize() sysconf(_SC_PAGESIZE)
+# else /* no _SC_PAGESIZE */
+#  ifdef HAVE_SYS_PARAM_H
+#   include <sys/param.h>
+#   ifdef EXEC_PAGESIZE
+#    define getpagesize() EXEC_PAGESIZE
+#   else /* no EXEC_PAGESIZE */
+#    ifdef NBPG
+#     define getpagesize() NBPG * CLSIZE
+#     ifndef CLSIZE
+#      define CLSIZE 1
+#     endif /* no CLSIZE */
+#    else /* no NBPG */
+#     ifdef NBPC
+#      define getpagesize() NBPC
+#     else /* no NBPC */
+#      ifdef PAGESIZE
+#       define getpagesize() PAGESIZE
+#      endif /* PAGESIZE */
+#     endif /* no NBPC */
+#    endif /* no NBPG */
+#   endif /* no EXEC_PAGESIZE */
+#  else /* no HAVE_SYS_PARAM_H */
+#   define getpagesize() 8192	/* punt totally */
+#  endif /* no HAVE_SYS_PARAM_H */
+# endif /* no _SC_PAGESIZE */
+
+#endif /* no HAVE_GETPAGESIZE */
+
 int
 main ()
 {
-return ! malloc (0);
-  ;
+  char *data, *data2, *data3;
+  int i, pagesize;
+  int fd;
+
+  pagesize = getpagesize ();
+
+  /* First, make a file with some known garbage in it. */
+  data = (char *) malloc (pagesize);
+  if (!data)
+    return 1;
+  for (i = 0; i < pagesize; ++i)
+    *(data + i) = rand ();
+  umask (0);
+  fd = creat ("conftest.mmap", 0600);
+  if (fd < 0)
+    return 1;
+  if (write (fd, data, pagesize) != pagesize)
+    return 1;
+  close (fd);
+
+  /* Next, try to mmap the file at a fixed address which already has
+     something else allocated at it.  If we can, also make sure that
+     we see the same garbage.  */
+  fd = open ("conftest.mmap", O_RDWR);
+  if (fd < 0)
+    return 1;
+  data2 = (char *) malloc (2 * pagesize);
+  if (!data2)
+    return 1;
+  data2 += (pagesize - ((long int) data2 & (pagesize - 1))) & (pagesize - 1);
+  if (data2 != mmap (data2, pagesize, PROT_READ | PROT_WRITE,
+		     MAP_PRIVATE | MAP_FIXED, fd, 0L))
+    return 1;
+  for (i = 0; i < pagesize; ++i)
+    if (*(data + i) != *(data2 + i))
+      return 1;
+
+  /* Finally, make sure that changes to the mapped area do not
+     percolate back to the file as seen by read().  (This is a bug on
+     some variants of i386 svr4.0.)  */
+  for (i = 0; i < pagesize; ++i)
+    *(data2 + i) = *(data2 + i) + 1;
+  data3 = (char *) malloc (pagesize);
+  if (!data3)
+    return 1;
+  if (read (fd, data3, pagesize) != pagesize)
+    return 1;
+  for (i = 0; i < pagesize; ++i)
+    if (*(data + i) != *(data3 + i))
+      return 1;
+  close (fd);
   return 0;
 }
 _ACEOF
@@ -5305,58 +7264,38 @@
   ac_status=$?
   echo "$as_me:$LINENO: \$? = $ac_status" >&5
   (exit $ac_status); }; }; then
-  ac_cv_func_malloc_0_nonnull=yes
+  ac_cv_func_mmap_fixed_mapped=yes
 else
   echo "$as_me: program exited with status $ac_status" >&5
 echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
 ( exit $ac_status )
-ac_cv_func_malloc_0_nonnull=no
+ac_cv_func_mmap_fixed_mapped=no
 fi
 rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
 
 
 fi
-{ echo "$as_me:$LINENO: result: $ac_cv_func_malloc_0_nonnull" >&5
-echo "${ECHO_T}$ac_cv_func_malloc_0_nonnull" >&6; }
-if test $ac_cv_func_malloc_0_nonnull = yes; then
-
-cat >>confdefs.h <<\_ACEOF
-#define HAVE_MALLOC 1
-_ACEOF
-
-else
-  cat >>confdefs.h <<\_ACEOF
-#define HAVE_MALLOC 0
-_ACEOF
-
-   case " $LIBOBJS " in
-  *" malloc.$ac_objext "* ) ;;
-  *) LIBOBJS="$LIBOBJS malloc.$ac_objext"
- ;;
-esac
-
+{ echo "$as_me:$LINENO: result: $ac_cv_func_mmap_fixed_mapped" >&5
+echo "${ECHO_T}$ac_cv_func_mmap_fixed_mapped" >&6; }
+if test $ac_cv_func_mmap_fixed_mapped = yes; then
 
 cat >>confdefs.h <<\_ACEOF
-#define malloc rpl_malloc
+#define HAVE_MMAP 1
 _ACEOF
 
 fi
+rm -f conftest.mmap
 
-
-
-{ echo "$as_me:$LINENO: checking whether lstat dereferences a symlink specified with a trailing slash" >&5
-echo $ECHO_N "checking whether lstat dereferences a symlink specified with a trailing slash... $ECHO_C" >&6; }
-if test "${ac_cv_func_lstat_dereferences_slashed_symlink+set}" = set; then
+{ echo "$as_me:$LINENO: checking whether stat accepts an empty string" >&5
+echo $ECHO_N "checking whether stat accepts an empty string... $ECHO_C" >&6; }
+if test "${ac_cv_func_stat_empty_string_bug+set}" = set; then
   echo $ECHO_N "(cached) $ECHO_C" >&6
 else
-  rm -f conftest.sym conftest.file
-echo >conftest.file
-if test "$as_ln_s" = "ln -s" && ln -s conftest.file conftest.sym; then
   if test "$cross_compiling" = yes; then
-  ac_cv_func_lstat_dereferences_slashed_symlink=no
+  ac_cv_func_stat_empty_string_bug=yes
 else
   cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
@@ -5369,10 +7308,7 @@
 main ()
 {
 struct stat sbuf;
-     /* Linux will dereference the symlink and fail.
-	That is better in the sense that it means we will not
-	have to compile and use the lstat wrapper.  */
-     return lstat ("conftest.sym/", &sbuf) == 0;
+  return stat ("", &sbuf) == 0;
   ;
   return 0;
 }
@@ -5397,53 +7333,43 @@
   ac_status=$?
   echo "$as_me:$LINENO: \$? = $ac_status" >&5
   (exit $ac_status); }; }; then
-  ac_cv_func_lstat_dereferences_slashed_symlink=yes
+  ac_cv_func_stat_empty_string_bug=no
 else
   echo "$as_me: program exited with status $ac_status" >&5
 echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
 ( exit $ac_status )
-ac_cv_func_lstat_dereferences_slashed_symlink=no
+ac_cv_func_stat_empty_string_bug=yes
 fi
 rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
 
 
-else
-  # If the `ln -s' command failed, then we probably don't even
-  # have an lstat function.
-  ac_cv_func_lstat_dereferences_slashed_symlink=no
-fi
-rm -f conftest.sym conftest.file
-
 fi
-{ echo "$as_me:$LINENO: result: $ac_cv_func_lstat_dereferences_slashed_symlink" >&5
-echo "${ECHO_T}$ac_cv_func_lstat_dereferences_slashed_symlink" >&6; }
+{ echo "$as_me:$LINENO: result: $ac_cv_func_stat_empty_string_bug" >&5
+echo "${ECHO_T}$ac_cv_func_stat_empty_string_bug" >&6; }
+if test $ac_cv_func_stat_empty_string_bug = yes; then
+  case " $LIBOBJS " in
+  *" stat.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS stat.$ac_objext"
+ ;;
+esac
 
-test $ac_cv_func_lstat_dereferences_slashed_symlink = yes &&
 
 cat >>confdefs.h <<_ACEOF
-#define LSTAT_FOLLOWS_SLASHED_SYMLINK 1
+#define HAVE_STAT_EMPTY_STRING_BUG 1
 _ACEOF
 
-
-if test $ac_cv_func_lstat_dereferences_slashed_symlink = no; then
-  case " $LIBOBJS " in
-  *" lstat.$ac_objext "* ) ;;
-  *) LIBOBJS="$LIBOBJS lstat.$ac_objext"
- ;;
-esac
-
 fi
 
-{ echo "$as_me:$LINENO: checking whether stat accepts an empty string" >&5
-echo $ECHO_N "checking whether stat accepts an empty string... $ECHO_C" >&6; }
-if test "${ac_cv_func_stat_empty_string_bug+set}" = set; then
+{ echo "$as_me:$LINENO: checking for working strtod" >&5
+echo $ECHO_N "checking for working strtod... $ECHO_C" >&6; }
+if test "${ac_cv_func_strtod+set}" = set; then
   echo $ECHO_N "(cached) $ECHO_C" >&6
 else
   if test "$cross_compiling" = yes; then
-  ac_cv_func_stat_empty_string_bug=yes
+  ac_cv_func_strtod=no
 else
   cat >conftest.$ac_ext <<_ACEOF
 /* confdefs.h.  */
@@ -5451,15 +7377,36 @@
 cat confdefs.h >>conftest.$ac_ext
 cat >>conftest.$ac_ext <<_ACEOF
 /* end confdefs.h.  */
+
 $ac_includes_default
+#ifndef strtod
+double strtod ();
+#endif
 int
-main ()
+main()
 {
-struct stat sbuf;
-  return stat ("", &sbuf) == 0;
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
 rm -f conftest$ac_exeext
 if { (ac_try="$ac_link"
@@ -5481,33 +7428,181 @@
   ac_status=$?
   echo "$as_me:$LINENO: \$? = $ac_status" >&5
   (exit $ac_status); }; }; then
-  ac_cv_func_stat_empty_string_bug=no
+  ac_cv_func_strtod=yes
 else
   echo "$as_me: program exited with status $ac_status" >&5
 echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
 ( exit $ac_status )
-ac_cv_func_stat_empty_string_bug=yes
+ac_cv_func_strtod=no
 fi
 rm -f core *.core core.conftest.* gmon.out bb.out conftest$ac_exeext conftest.$ac_objext conftest.$ac_ext
 fi
 
 
 fi
-{ echo "$as_me:$LINENO: result: $ac_cv_func_stat_empty_string_bug" >&5
-echo "${ECHO_T}$ac_cv_func_stat_empty_string_bug" >&6; }
-if test $ac_cv_func_stat_empty_string_bug = yes; then
+{ echo "$as_me:$LINENO: result: $ac_cv_func_strtod" >&5
+echo "${ECHO_T}$ac_cv_func_strtod" >&6; }
+if test $ac_cv_func_strtod = no; then
   case " $LIBOBJS " in
-  *" stat.$ac_objext "* ) ;;
-  *) LIBOBJS="$LIBOBJS stat.$ac_objext"
+  *" strtod.$ac_objext "* ) ;;
+  *) LIBOBJS="$LIBOBJS strtod.$ac_objext"
  ;;
 esac
 
+{ echo "$as_me:$LINENO: checking for pow" >&5
+echo $ECHO_N "checking for pow... $ECHO_C" >&6; }
+if test "${ac_cv_func_pow+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Define pow to an innocuous variant, in case <limits.h> declares pow.
+   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
+#define pow innocuous_pow
+
+/* System header to define __stub macros and hopefully few prototypes,
+    which can conflict with char pow (); below.
+    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+    <limits.h> exists even on freestanding compilers.  */
+
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+
+#undef pow
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char pow ();
+/* The GNU C library defines this for functions which it implements
+    to always fail with ENOSYS.  Some functions are actually named
+    something starting with __ and the normal name is an alias.  */
+#if defined __stub_pow || defined __stub___pow
+choke me
+#endif
+
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  ac_cv_func_pow=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_func_pow=no
+fi
 
-cat >>confdefs.h <<_ACEOF
-#define HAVE_STAT_EMPTY_STRING_BUG 1
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_pow" >&5
+echo "${ECHO_T}$ac_cv_func_pow" >&6; }
+
+if test $ac_cv_func_pow = no; then
+  { echo "$as_me:$LINENO: checking for pow in -lm" >&5
+echo $ECHO_N "checking for pow in -lm... $ECHO_C" >&6; }
+if test "${ac_cv_lib_m_pow+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lm  $LIBS"
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
+char pow ();
+int
+main ()
+{
+return pow ();
+  ;
+  return 0;
+}
 _ACEOF
+rm -f conftest.$ac_objext conftest$ac_exeext
+if { (ac_try="$ac_link"
+case "(($ac_try" in
+  *\"* | *\`* | *\\*) ac_try_echo=\$ac_try;;
+  *) ac_try_echo=$ac_try;;
+esac
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  ac_cv_lib_m_pow=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_m_pow=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_lib_m_pow" >&5
+echo "${ECHO_T}$ac_cv_lib_m_pow" >&6; }
+if test $ac_cv_lib_m_pow = yes; then
+  POW_LIB=-lm
+else
+  { echo "$as_me:$LINENO: WARNING: cannot find library containing definition of pow" >&5
+echo "$as_me: WARNING: cannot find library containing definition of pow" >&2;}
+fi
+
+fi
 
 fi
 
@@ -5700,13 +7795,6 @@
 
 
 ################################################################################
-# Check whether --enable-jobs was given.
-if test "${enable_jobs+set}" = set; then
-  enableval=$enable_jobs; JOBS=-j$enableval
-fi
-
-
-################################################################################
 { echo "$as_me:$LINENO: checking file owner" >&5
 echo $ECHO_N "checking file owner... $ECHO_C" >&6; }
 OWNER="root"
@@ -5801,6 +7889,8 @@
 
 if test x$DEBUG = xyes; then
 	COPTIMISE_FLAG=
+else
+	CSCOPE_CMD=
 fi
 
 ################################################################################
@@ -5850,20 +7940,10 @@
 
 
 ################################################################################
-# Check whether --enable-static_link was given.
-if test "${enable_static_link+set}" = set; then
-  enableval=$enable_static_link; STATIC_LINK=$enableval
-else
-  STATIC_LINK=no
-fi
-
-
-################################################################################
 if [ "x$exec_prefix" = xNONE -a "x$prefix" = xNONE ];
  then  exec_prefix="";
 fi;
 
-
 ################################################################################
 
 { echo "$as_me:$LINENO: checking for getline in -lc" >&5
@@ -6009,6 +8089,19 @@
 
 
 ################################################################################
+{ echo "$as_me:$LINENO: checking whether to use static linking" >&5
+echo $ECHO_N "checking whether to use static linking... $ECHO_C" >&6; }
+# Check whether --enable-static_link was given.
+if test "${enable_static_link+set}" = set; then
+  enableval=$enable_static_link; STATIC_LINK=$enableval
+else
+  STATIC_LINK=no
+fi
+
+{ echo "$as_me:$LINENO: result: $STATIC_LINK" >&5
+echo "${ECHO_T}$STATIC_LINK" >&6; }
+
+################################################################################
 { echo "$as_me:$LINENO: checking whether to enable selinux support" >&5
 echo $ECHO_N "checking whether to enable selinux support... $ECHO_C" >&6; }
 # Check whether --enable-selinux was given.
@@ -6178,11 +8271,11 @@
 echo "$as_me: WARNING: Disabling selinux" >&2;}
 	fi
 
-	# With --enable-static_link and selinux enabled, linking dmsetup
+	# With --enable-static_link and selinux enabled, linking
 	# fails on at least Debian unstable due to unsatisfied references
 	# to pthread_mutex_lock and _unlock.  See if we need -lpthread.
 	if test "$STATIC_LINK-$HAVE_SELINUX" = yes-yes; then
-		dm_saved_libs=$LIBS
+		lvm_saved_libs=$LIBS
 		LIBS="$LIBS -static"
 		{ echo "$as_me:$LINENO: checking for library containing pthread_mutex_lock" >&5
 echo $ECHO_N "checking for library containing pthread_mutex_lock... $ECHO_C" >&6; }
@@ -6268,7 +8361,7 @@
 				LIB_PTHREAD=-lpthread
 fi
 
-		LIBS=$dm_saved_libs
+		LIBS=$lvm_saved_libs
 	fi
 fi
 
@@ -6419,6 +8512,187 @@
 
 
 ################################################################################
+if test x$READLINE = xyes; then
+
+{ echo "$as_me:$LINENO: checking for readline in -lreadline" >&5
+echo $ECHO_N "checking for readline in -lreadline... $ECHO_C" >&6; }
+if test "${ac_cv_lib_readline_readline+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lreadline  $LIBS"
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
+char readline ();
+int
+main ()
+{
+return readline ();
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  ac_cv_lib_readline_readline=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_readline_readline=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_lib_readline_readline" >&5
+echo "${ECHO_T}$ac_cv_lib_readline_readline" >&6; }
+if test $ac_cv_lib_readline_readline = yes; then
+  cat >>confdefs.h <<_ACEOF
+#define HAVE_LIBREADLINE 1
+_ACEOF
+
+  LIBS="-lreadline $LIBS"
+
+else
+  { { echo "$as_me:$LINENO: error: GNU Readline could not be found which is required for the
+--enable-readline option (which is enabled by default).  Either disable readline
+support with --disable-readline or download and install readline from:
+	ftp.gnu.org/gnu/readline
+Note: if you are using precompiled packages you will also need the development
+package as well (which may be called readline-devel or something similar).
+" >&5
+echo "$as_me: error: GNU Readline could not be found which is required for the
+--enable-readline option (which is enabled by default).  Either disable readline
+support with --disable-readline or download and install readline from:
+	ftp.gnu.org/gnu/readline
+Note: if you are using precompiled packages you will also need the development
+package as well (which may be called readline-devel or something similar).
+" >&2;}
+   { (exit 1); exit 1; }; }
+
+fi
+
+	{ echo "$as_me:$LINENO: checking for rl_completion_matches" >&5
+echo $ECHO_N "checking for rl_completion_matches... $ECHO_C" >&6; }
+if test "${ac_cv_func_rl_completion_matches+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
+else
+  cat >conftest.$ac_ext <<_ACEOF
+/* confdefs.h.  */
+_ACEOF
+cat confdefs.h >>conftest.$ac_ext
+cat >>conftest.$ac_ext <<_ACEOF
+/* end confdefs.h.  */
+/* Define rl_completion_matches to an innocuous variant, in case <limits.h> declares rl_completion_matches.
+   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
+#define rl_completion_matches innocuous_rl_completion_matches
+
+/* System header to define __stub macros and hopefully few prototypes,
+    which can conflict with char rl_completion_matches (); below.
+    Prefer <limits.h> to <assert.h> if __STDC__ is defined, since
+    <limits.h> exists even on freestanding compilers.  */
+
+#ifdef __STDC__
+# include <limits.h>
+#else
+# include <assert.h>
+#endif
+
+#undef rl_completion_matches
+
+/* Override any GCC internal prototype to avoid an error.
+   Use char because int might match the return type of a GCC
+   builtin and then its argument prototype would still apply.  */
+#ifdef __cplusplus
+extern "C"
+#endif
+char rl_completion_matches ();
+/* The GNU C library defines this for functions which it implements
+    to always fail with ENOSYS.  Some functions are actually named
+    something starting with __ and the normal name is an alias.  */
+#if defined __stub_rl_completion_matches || defined __stub___rl_completion_matches
+choke me
+#endif
+
+int
+main ()
+{
+return rl_completion_matches ();
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
+eval "echo \"\$as_me:$LINENO: $ac_try_echo\"") >&5
+  (eval "$ac_link") 2>conftest.er1
+  ac_status=$?
+  grep -v '^ *+' conftest.er1 >conftest.err
+  rm -f conftest.er1
+  cat conftest.err >&5
+  echo "$as_me:$LINENO: \$? = $ac_status" >&5
+  (exit $ac_status); } && {
+	 test -z "$ac_c_werror_flag" ||
+	 test ! -s conftest.err
+       } && test -s conftest$ac_exeext &&
+       $as_test_x conftest$ac_exeext; then
+  ac_cv_func_rl_completion_matches=yes
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_func_rl_completion_matches=no
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_func_rl_completion_matches" >&5
+echo "${ECHO_T}$ac_cv_func_rl_completion_matches" >&6; }
+if test $ac_cv_func_rl_completion_matches = yes; then
+
+cat >>confdefs.h <<\_ACEOF
+#define HAVE_RL_COMPLETION_MATCHES 1
+_ACEOF
+
+fi
+
+fi
+
+################################################################################
 { echo "$as_me:$LINENO: checking whether to enable internationalisation" >&5
 echo $ECHO_N "checking whether to enable internationalisation... $ECHO_C" >&6; }
 # Check whether --enable-nls was given.
@@ -6491,7 +8765,6 @@
 
 fi
 
-
 ################################################################################
 { echo "$as_me:$LINENO: checking for kernel directory" >&5
 echo $ECHO_N "checking for kernel directory... $ECHO_C" >&6; }
@@ -6595,11 +8868,7 @@
 { echo "$as_me:$LINENO: result: $interface" >&5
 echo "${ECHO_T}$interface" >&6; }
 
-if test "-f VERSION" ; then
-  DM_LIB_VERSION="\"`cat VERSION|sed -e \"s/([0-9.]*)/\0-$interface/\"`\""
-else
-  DM_LIB_VERSION="Unknown version ($interface)"
-fi
+DM_LIB_VERSION="\"`cat VERSION 2>/dev/null || echo Unknown`\""
 
 
 cat >>confdefs.h <<_ACEOF
@@ -6652,6 +8921,7 @@
 fi
 
 fi
+
 ################################################################################
 
 
@@ -6684,6 +8954,27 @@
 
 
 
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
+
 ################################################################################
 ac_config_files="$ac_config_files Makefile make.tmpl include/Makefile dmsetup/Makefile lib/Makefile lib/libdevmapper.pc dmeventd/Makefile dmeventd/libdevmapper-event.pc kernel/Makefile man/Makefile po/Makefile"
 
@@ -7379,39 +9670,103 @@
 LN_S!$LN_S$ac_delim
 SET_MAKE!$SET_MAKE$ac_delim
 RANLIB!$RANLIB$ac_delim
+CFLOW_CMD!$CFLOW_CMD$ac_delim
+CSCOPE_CMD!$CSCOPE_CMD$ac_delim
+ALLOCA!$ALLOCA$ac_delim
 LIBOBJS!$LIBOBJS$ac_delim
+POW_LIB!$POW_LIB$ac_delim
 MSGFMT!$MSGFMT$ac_delim
-usrlibdir!$usrlibdir$ac_delim
-JOBS!$JOBS$ac_delim
-STATIC_LINK!$STATIC_LINK$ac_delim
-OWNER!$OWNER$ac_delim
-GROUP!$GROUP$ac_delim
-interface!$interface$ac_delim
-kerneldir!$kerneldir$ac_delim
-missingkernel!$missingkernel$ac_delim
-kernelvsn!$kernelvsn$ac_delim
-tmpdir!$tmpdir$ac_delim
-COPTIMISE_FLAG!$COPTIMISE_FLAG$ac_delim
 CLDFLAGS!$CLDFLAGS$ac_delim
-LDDEPS!$LDDEPS$ac_delim
-LIB_SUFFIX!$LIB_SUFFIX$ac_delim
-DEBUG!$DEBUG$ac_delim
-DM_LIB_VERSION!$DM_LIB_VERSION$ac_delim
+CLDNOWHOLEARCHIVE!$CLDNOWHOLEARCHIVE$ac_delim
+CLDWHOLEARCHIVE!$CLDWHOLEARCHIVE$ac_delim
+CLUSTER!$CLUSTER$ac_delim
+CLVMD!$CLVMD$ac_delim
+CMDLIB!$CMDLIB$ac_delim
 COMPAT!$COMPAT$ac_delim
-DMIOCTLS!$DMIOCTLS$ac_delim
-LOCALEDIR!$LOCALEDIR$ac_delim
-INTL_PACKAGE!$INTL_PACKAGE$ac_delim
-INTL!$INTL$ac_delim
-DEVICE_UID!$DEVICE_UID$ac_delim
+CONFDIR!$CONFDIR$ac_delim
+COPTIMISE_FLAG!$COPTIMISE_FLAG$ac_delim
+DEBUG!$DEBUG$ac_delim
 DEVICE_GID!$DEVICE_GID$ac_delim
 DEVICE_MODE!$DEVICE_MODE$ac_delim
+DEVICE_UID!$DEVICE_UID$ac_delim
+DEVMAPPER!$DEVMAPPER$ac_delim
+DMDIR!$DMDIR$ac_delim
 DMEVENTD!$DMEVENTD$ac_delim
+DMIOCTLS!$DMIOCTLS$ac_delim
+DM_LIB_VERSION!$DM_LIB_VERSION$ac_delim
+FSADM!$FSADM$ac_delim
+GROUP!$GROUP$ac_delim
+HAVE_LIBDL!$HAVE_LIBDL$ac_delim
+HAVE_REALTIME!$HAVE_REALTIME$ac_delim
+HAVE_SELINUX!$HAVE_SELINUX$ac_delim
+INTL!$INTL$ac_delim
+INTL_PACKAGE!$INTL_PACKAGE$ac_delim
+_ACEOF
+
+  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 97; then
+    break
+  elif $ac_last_try; then
+    { { echo "$as_me:$LINENO: error: could not make $CONFIG_STATUS" >&5
+echo "$as_me: error: could not make $CONFIG_STATUS" >&2;}
+   { (exit 1); exit 1; }; }
+  else
+    ac_delim="$ac_delim!$ac_delim _$ac_delim!! "
+  fi
+done
+
+ac_eof=`sed -n '/^CEOF[0-9]*$/s/CEOF/0/p' conf$$subs.sed`
+if test -n "$ac_eof"; then
+  ac_eof=`echo "$ac_eof" | sort -nru | sed 1q`
+  ac_eof=`expr $ac_eof + 1`
+fi
+
+cat >>$CONFIG_STATUS <<_ACEOF
+cat >"\$tmp/subs-1.sed" <<\CEOF$ac_eof
+/@[a-zA-Z_][a-zA-Z_0-9]*@/!b
+_ACEOF
+sed '
+s/[,\\&]/\\&/g; s/@/@|#_!!_#|/g
+s/^/s,@/; s/!/@,|#_!!_#|/
+:n
+t n
+s/'"$ac_delim"'$/,g/; t
+s/$/\\/; p
+N; s/^.*\n//; s/[,\\&]/\\&/g; s/@/@|#_!!_#|/g; b n
+' >>$CONFIG_STATUS <conf$$subs.sed
+rm -f conf$$subs.sed
+cat >>$CONFIG_STATUS <<_ACEOF
+CEOF$ac_eof
+_ACEOF
+
+
+ac_delim='%!_!# '
+for ac_last_try in false false false false false :; do
+  cat >conf$$subs.sed <<_ACEOF
+JOBS!$JOBS$ac_delim
+LDDEPS!$LDDEPS$ac_delim
+LIB_SUFFIX!$LIB_SUFFIX$ac_delim
+LOCALEDIR!$LOCALEDIR$ac_delim
+LVM1!$LVM1$ac_delim
+LVM1_FALLBACK!$LVM1_FALLBACK$ac_delim
+LVM_VERSION!$LVM_VERSION$ac_delim
+MIRRORS!$MIRRORS$ac_delim
+OWNER!$OWNER$ac_delim
 PKGCONFIG!$PKGCONFIG$ac_delim
+POOL!$POOL$ac_delim
+SNAPSHOTS!$SNAPSHOTS$ac_delim
+STATICDIR!$STATICDIR$ac_delim
+STATIC_LINK!$STATIC_LINK$ac_delim
 LIB_PTHREAD!$LIB_PTHREAD$ac_delim
+interface!$interface$ac_delim
+kerneldir!$kerneldir$ac_delim
+missingkernel!$missingkernel$ac_delim
+kernelvsn!$kernelvsn$ac_delim
+tmpdir!$tmpdir$ac_delim
+usrlibdir!$usrlibdir$ac_delim
 LTLIBOBJS!$LTLIBOBJS$ac_delim
 _ACEOF
 
-  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 96; then
+  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 22; then
     break
   elif $ac_last_try; then
     { { echo "$as_me:$LINENO: error: could not make $CONFIG_STATUS" >&5
@@ -7429,8 +9784,8 @@
 fi
 
 cat >>$CONFIG_STATUS <<_ACEOF
-cat >"\$tmp/subs-1.sed" <<\CEOF$ac_eof
-/@[a-zA-Z_][a-zA-Z_0-9]*@/!b
+cat >"\$tmp/subs-2.sed" <<\CEOF$ac_eof
+/@[a-zA-Z_][a-zA-Z_0-9]*@/!b end
 _ACEOF
 sed '
 s/[,\\&]/\\&/g; s/@/@|#_!!_#|/g
@@ -7443,6 +9798,8 @@
 ' >>$CONFIG_STATUS <conf$$subs.sed
 rm -f conf$$subs.sed
 cat >>$CONFIG_STATUS <<_ACEOF
+:end
+s/|#_!!_#|//g
 CEOF$ac_eof
 _ACEOF
 
@@ -7690,7 +10047,7 @@
 s&@abs_top_builddir@&$ac_abs_top_builddir&;t t
 s&@INSTALL@&$ac_INSTALL&;t t
 $ac_datarootdir_hack
-" $ac_file_inputs | sed -f "$tmp/subs-1.sed" | sed 's/|#_!!_#|//g' >$tmp/out
+" $ac_file_inputs | sed -f "$tmp/subs-1.sed" | sed -f "$tmp/subs-2.sed" >$tmp/out
 
 test -z "$ac_datarootdir_hack$ac_datarootdir_seen" &&
   { ac_out=`sed -n '/\${datarootdir}/p' "$tmp/out"`; test -n "$ac_out"; } &&
--- device-mapper/configure.in	2007/10/10 00:02:03	1.47
+++ device-mapper/configure.in	2008/06/06 20:33:13	1.48
@@ -1,6 +1,6 @@
 ###############################################################################
 ## Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
-## Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+## Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
 ##
 ## This file is part of the device-mapper userspace tools.
 ##
@@ -11,7 +11,6 @@
 ## You should have received a copy of the GNU General Public License
 ## along with this program; if not, write to the Free Software Foundation,
 ## Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-## MA 02111-1307, USA
 ################################################################################
 
 AC_PREREQ(2.57)
@@ -19,13 +18,11 @@
 dnl -- Process this file with autoconf to produce a configure script.
 AC_INIT
 AC_CONFIG_SRCDIR([lib/libdevmapper.h])
-
-################################################################################
 AC_CONFIG_HEADERS(include/configure.h)
 
 ################################################################################
 dnl -- Setup the directory where autoconf has auxilary files
-AC_CONFIG_AUX_DIR(autoconf) 
+AC_CONFIG_AUX_DIR(autoconf)
 
 ################################################################################
 dnl -- Get system type
@@ -33,21 +30,35 @@
 
 case "$host_os" in
 	linux*)
-		CFLAGS="$CFLAGS"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS -Wl,--version-script,.export.sym"
+		CLDWHOLEARCHIVE="-Wl,-whole-archive"
+		CLDNOWHOLEARCHIVE="-Wl,-no-whole-archive"
 		LDDEPS="$LDDEPS .export.sym"
-		LIB_SUFFIX="so"
-		DMIOCTLS="yes"
-		SELINUX="yes" ;;
+		LIB_SUFFIX=so
+		DEVMAPPER=yes
+		ODIRECT=yes
+		DMIOCTLS=yes
+		SELINUX=yes
+		REALTIME=yes
+		CLUSTER=internal
+		FSADM=no
+		;;
 	darwin*)
 		CFLAGS="$CFLAGS -no-cpp-precomp -fno-common"
 		COPTIMISE_FLAG="-O2"
 		CLDFLAGS="$CLDFLAGS"
-		LDDEPS="$LDDEPS"
-		LIB_SUFFIX="dylib"
-		DMIOCTLS="no"
-		SELINUX="no" ;;
+		CLDWHOLEARCHIVE="-all_load"
+		CLDNOWHOLEARCHIVE=
+		LIB_SUFFIX=dylib
+		DEVMAPPER=yes
+		ODIRECT=no
+		DMIOCTLS=no
+		SELINUX=no
+		REALTIME=no
+		CLUSTER=none
+		FSADM=no
+		;;
 esac
 
 ################################################################################
@@ -55,26 +66,34 @@
 usrlibdir='${prefix}/lib'
 
 ################################################################################
-dnl -- Checks for programs.
+dnl -- Check for programs.
 AC_PROG_AWK
 AC_PROG_CC
+
+dnl probably no longer needed in 2008, but...
 AC_PROG_GCC_TRADITIONAL
 AC_PROG_INSTALL
 AC_PROG_LN_S
 AC_PROG_MAKE_SET
 AC_PROG_RANLIB
 
+AC_PATH_PROG(CFLOW_CMD, cflow)
+AC_PATH_PROG(CSCOPE_CMD, cscope)
+
 ################################################################################
-dnl -- Checks for header files.
+dnl -- Check for header files.
 AC_HEADER_DIRENT
 AC_HEADER_STDC
+AC_HEADER_SYS_WAIT
 AC_HEADER_TIME
 
-AC_CHECK_HEADERS(ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h sys/types.h unistd.h,,AC_MSG_ERROR(bailing out))
-
+AC_CHECK_HEADERS([ctype.h dirent.h errno.h fcntl.h getopt.h inttypes.h limits.h \
+  stdarg.h stdio.h stdlib.h string.h sys/ioctl.h sys/param.h sys/stat.h \
+  sys/types.h unistd.h], , [AC_MSG_ERROR(bailing out)])
 AC_CHECK_HEADERS(termios.h sys/statvfs.h)
+
 ################################################################################
-dnl -- Checks for typedefs, structures, and compiler characteristics.
+dnl -- Check for typedefs, structures, and compiler characteristics.
 AC_C_CONST
 AC_C_INLINE
 AC_CHECK_MEMBERS([struct stat.st_rdev])
@@ -82,13 +101,24 @@
 AC_TYPE_PID_T
 AC_TYPE_SIGNAL
 AC_TYPE_SIZE_T
+AC_TYPE_MODE_T
+AC_CHECK_MEMBERS([struct stat.st_rdev])
+AC_STRUCT_TM
 
 ################################################################################
-dnl -- Checks for functions
-AC_CHECK_FUNCS(memset mkdir rmdir strchr strdup strerror strrchr uname,,AC_MSG_ERROR(bailing out))
+dnl -- Check for functions
+AC_CHECK_FUNCS([gethostname getpagesize memset mkdir rmdir munmap setlocale \
+  strcasecmp strchr strdup strncasecmp strerror strrchr strstr strtol strtoul \
+  uname], , [AC_MSG_ERROR(bailing out)])
+AC_FUNC_ALLOCA
 AC_FUNC_CLOSEDIR_VOID
+AC_FUNC_FORK
+AC_FUNC_LSTAT
 AC_FUNC_MALLOC
+AC_FUNC_MEMCMP
+AC_FUNC_MMAP
 AC_FUNC_STAT
+AC_FUNC_STRTOD
 AC_FUNC_VPRINTF
 
 ################################################################################
@@ -96,10 +126,6 @@
 AC_PREFIX_DEFAULT(/usr)
 
 ################################################################################
-dnl -- Parallel make jobs?
-AC_ARG_ENABLE(jobs, [  --enable-jobs=NUM       Number of jobs to run simultaneously], JOBS=-j$enableval)
-
-################################################################################
 dnl -- Setup the ownership of the files
 AC_MSG_CHECKING(file owner)
 OWNER="root"
@@ -154,15 +180,17 @@
 AC_MSG_RESULT($DEVICE_MODE)
 
 ################################################################################
-dnl -- Enable Debugging
+dnl -- Enable debugging
 AC_MSG_CHECKING(whether to enable debugging)
 AC_ARG_ENABLE(debug,    [  --enable-debug          Enable debugging],
-DEBUG=$enableval, DEBUG=no)
+  DEBUG=$enableval, DEBUG=no)
 AC_MSG_RESULT($DEBUG)
 
 dnl -- Normally turn off optimisation for debug builds
 if test x$DEBUG = xyes; then
 	COPTIMISE_FLAG=
+else
+	CSCOPE_CMD=
 fi
 
 ################################################################################
@@ -174,29 +202,24 @@
 AC_MSG_RESULT($COPTIMISE_FLAG)
 
 ################################################################################
-dnl -- Disable Compatibility mode
+dnl -- Compatibility mode
 AC_ARG_ENABLE(compat,   [  --enable-compat         Enable support for old device-mapper versions],
-COMPAT=$enableval, COMPAT=no)
+  COMPAT=$enableval, COMPAT=no)
 
 ################################################################################
 dnl -- Disable ioctl
 AC_ARG_ENABLE(ioctl,   [  --disable-driver        Disable calls to device-mapper in the kernel],
-DMIOCTLS=$enableval)
+  DMIOCTLS=$enableval)
 
 ################################################################################
 dnl -- Enable dmeventd
 AC_ARG_ENABLE(dmeventd,   [  --enable-dmeventd       Build the new event daemon],
-DMEVENTD=$enableval, DMEVENTD=no)
+  DMEVENTD=$enableval, DMEVENTD=no)
 
 ################################################################################
 dnl -- Enable pkg-config
 AC_ARG_ENABLE(pkgconfig,   [  --enable-pkgconfig      Install pkgconfig support],
-PKGCONFIG=$enableval, PKGCONFIG=no)
-
-################################################################################
-dnl -- Enables staticly-linked tools
-AC_ARG_ENABLE(static_link, [  --enable-static_link    Use this to link the tools to their libraries
-                          statically.  Default is dynamic linking],  STATIC_LINK=$enableval, STATIC_LINK=no)
+  PKGCONFIG=$enableval, PKGCONFIG=no)
 
 ################################################################################
 dnl -- Clear default exec_prefix - install into /sbin rather than /usr/sbin
@@ -204,53 +227,65 @@
  then  exec_prefix="";
 fi;
 
-
 ################################################################################
 dnl -- getline included in recent libc
 
-AC_CHECK_LIB(c, getline, AC_DEFINE([HAVE_GETLINE], 1, [Define to 1 if getline is available.]))
+AC_CHECK_LIB(c, getline, AC_DEFINE([HAVE_GETLINE], 1,
+  [Define to 1 if getline is available.]))
 
 ################################################################################
 dnl -- canonicalize_file_name included in recent libc
 
-AC_CHECK_LIB(c, canonicalize_file_name, AC_DEFINE([HAVE_CANONICALIZE_FILE_NAME], 1, [Define to 1 if canonicalize_file_name is available.]))
+AC_CHECK_LIB(c, canonicalize_file_name,
+  AC_DEFINE([HAVE_CANONICALIZE_FILE_NAME], 1,
+    [Define to 1 if canonicalize_file_name is available.]))
+
+################################################################################
+dnl -- Enables statically-linked tools
+AC_MSG_CHECKING(whether to use static linking)
+AC_ARG_ENABLE(static_link,
+  [  --enable-static_link    Use this to link the tools to their libraries
+                          statically.  Default is dynamic linking],
+  STATIC_LINK=$enableval, STATIC_LINK=no)
+AC_MSG_RESULT($STATIC_LINK)
 
 ################################################################################
 dnl -- Disable selinux
 AC_MSG_CHECKING(whether to enable selinux support)
 AC_ARG_ENABLE(selinux, [  --disable-selinux       Disable selinux support],
-SELINUX=$enableval)
+  SELINUX=$enableval)
 AC_MSG_RESULT($SELINUX)
- 
+
 ################################################################################
 dnl -- Check for selinux
 if test x$SELINUX = xyes; then
 	AC_CHECK_LIB(sepol, sepol_check_context, HAVE_SEPOL=yes, HAVE_SEPOL=no)
 
 	if test x$HAVE_SEPOL = xyes; then
-		AC_DEFINE([HAVE_SEPOL], 1, [Define to 1 if sepol_check_context is available.])
+		AC_DEFINE([HAVE_SEPOL], 1,
+		  [Define to 1 if sepol_check_context is available.])
 		LIBS="-lsepol $LIBS"
 	fi
 
 	AC_CHECK_LIB(selinux, is_selinux_enabled, HAVE_SELINUX=yes, HAVE_SELINUX=no)
 
 	if test x$HAVE_SELINUX = xyes; then
-		AC_DEFINE([HAVE_SELINUX], 1, [Define to 1 if selinux is available.])
+		AC_DEFINE([HAVE_SELINUX], 1, [Define to 1 to include support for selinux.])
 		LIBS="-lselinux $LIBS"
 	else
 		AC_MSG_WARN(Disabling selinux)
 	fi
 
-	# With --enable-static_link and selinux enabled, linking dmsetup
+	# With --enable-static_link and selinux enabled, linking
 	# fails on at least Debian unstable due to unsatisfied references
 	# to pthread_mutex_lock and _unlock.  See if we need -lpthread.
 	if test "$STATIC_LINK-$HAVE_SELINUX" = yes-yes; then
-		dm_saved_libs=$LIBS
+		lvm_saved_libs=$LIBS
 		LIBS="$LIBS -static"
 		AC_SEARCH_LIBS([pthread_mutex_lock], [pthread],
 		  [test "$ac_cv_search_pthread_mutex_lock" = "none required" ||
 				LIB_PTHREAD=-lpthread])
-		LIBS=$dm_saved_libs
+		LIBS=$lvm_saved_libs
 	fi
 fi
 
@@ -259,6 +294,22 @@
 AC_CHECK_HEADERS(getopt.h, AC_DEFINE([HAVE_GETOPTLONG], 1, [Define to 1 if getopt_long is available.]))
 
 ################################################################################
+dnl -- Check for readline (Shamelessly copied from parted 1.4.17)
+if test x$READLINE = xyes; then
+	AC_CHECK_LIB(readline, readline, ,
+		AC_MSG_ERROR(
+GNU Readline could not be found which is required for the
+--enable-readline option (which is enabled by default).  Either disable readline
+support with --disable-readline or download and install readline from:
+	ftp.gnu.org/gnu/readline
+Note: if you are using precompiled packages you will also need the development
+package as well (which may be called readline-devel or something similar).
+)
+	)
+	AC_CHECK_FUNC(rl_completion_matches, AC_DEFINE([HAVE_RL_COMPLETION_MATCHES], 1, [Define to 1 if rl_completion_matches() is available.]))
+fi
+
+################################################################################
 dnl -- Internationalisation stuff
 AC_MSG_CHECKING(whether to enable internationalisation)
 AC_ARG_ENABLE(nls, [  --enable-nls            Enable Native Language Support],
@@ -275,12 +326,11 @@
 	fi;
 
 	AC_ARG_WITH(localedir,
-  		    [  --with-localedir=DIR    Translation files in DIR [[PREFIX/share/locale]] ],
-  		    [ LOCALEDIR="$withval" ],
-  		    [ LOCALEDIR='${prefix}/share/locale' ])
+		    [  --with-localedir=DIR    Translation files in DIR [[PREFIX/share/locale]] ],
+		    [ LOCALEDIR="$withval" ],
+		    [ LOCALEDIR='${prefix}/share/locale' ])
 fi
 
-
 ################################################################################
 dnl -- Where the linux src tree is
 AC_MSG_CHECKING(for kernel directory)
@@ -330,7 +380,7 @@
 fi
 
 if test "x${kernelvsn}" = x; then
-  if test "x${missingkernel}" = "x"; then 
+  if test "x${missingkernel}" = "x"; then
     kernelvsn=`awk -F ' = ' '/^VERSION/ {v=$2} /^PATCH/ {p=$2} /^SUBLEVEL/ {s=$2} /^EXTRAVERSION/ {e=$2} END {printf "%d.%d.%d%s",v,p,s,e}' $kerneldir/Makefile`
   else
     kernelvsn="UNKNOWN"
@@ -364,11 +414,7 @@
 fi
 AC_MSG_RESULT($interface)
 
-if test "-f VERSION" ; then
-  DM_LIB_VERSION="\"`cat VERSION|sed -e \"s/([[0-9.]]*)/\0-$interface/\"`\""
-else
-  DM_LIB_VERSION="Unknown version ($interface)"
-fi
+DM_LIB_VERSION="\"`cat VERSION 2>/dev/null || echo Unknown`\""
 
 AC_DEFINE_UNQUOTED(DM_LIB_VERSION, $DM_LIB_VERSION, [Library version])
 
@@ -377,9 +423,9 @@
 AH_TEMPLATE(DMEVENTD_PIDFILE, [Path to dmeventd pidfile.])
 if test "$DMEVENTD" = yes; then
 	AC_ARG_WITH(dmeventd-pidfile,
-  		    [  --with-dmeventd-pidfile=PATH    dmeventd pidfile [[/var/run/dmeventd.pid]] ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"$withval") ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"/var/run/dmeventd.pid") ])
+		    [  --with-dmeventd-pidfile=PATH    dmeventd pidfile [[/var/run/dmeventd.pid]] ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"$withval") ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PIDFILE,"/var/run/dmeventd.pid") ])
 fi
 
 AH_TEMPLATE(DMEVENTD_PATH, [Path to dmeventd binary.])
@@ -392,53 +438,75 @@
                 dmeventd_prefix=""
         fi
 	AC_ARG_WITH(dmeventd-path,
-  		    [  --with-dmeventd-path=PATH       dmeventd path [[${exec_prefix}/sbin/dmeventd]] ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
-  		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_prefix/sbin/dmeventd") ])
+		    [  --with-dmeventd-path=PATH       dmeventd path [[${exec_prefix}/sbin/dmeventd]] ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$withval") ],
+		    [ AC_DEFINE_UNQUOTED(DMEVENTD_PATH,"$dmeventd_prefix/sbin/dmeventd") ])
 fi
+
 ################################################################################
-AC_SUBST(usrlibdir)
-AC_SUBST(JOBS)
-AC_SUBST(STATIC_LINK)
-AC_SUBST(OWNER)
-AC_SUBST(GROUP)
-AC_SUBST(LIBS)
-AC_SUBST(interface)
-AC_SUBST(kerneldir)
-AC_SUBST(missingkernel)
-AC_SUBST(kernelvsn)
-AC_SUBST(tmpdir)
 AC_SUBST(CFLAGS)
-AC_SUBST(COPTIMISE_FLAG)
+AC_SUBST(CFLOW_CMD)
 AC_SUBST(CLDFLAGS)
-AC_SUBST(LDDEPS)
-AC_SUBST(LIB_SUFFIX)
-AC_SUBST(DEBUG)
-AC_SUBST(DM_LIB_VERSION)
+AC_SUBST(CLDNOWHOLEARCHIVE)
+AC_SUBST(CLDWHOLEARCHIVE)
+AC_SUBST(CLUSTER)
+AC_SUBST(CLVMD)
+AC_SUBST(CMDLIB)
 AC_SUBST(COMPAT)
-AC_SUBST(DMIOCTLS)
-AC_SUBST(MSGFMT)
-AC_SUBST(LOCALEDIR)
-AC_SUBST(INTL_PACKAGE)
-AC_SUBST(INTL)
-AC_SUBST(DEVICE_UID)
+AC_SUBST(CONFDIR)
+AC_SUBST(COPTIMISE_FLAG)
+AC_SUBST(CSCOPE_CMD)
+AC_SUBST(DEBUG)
 AC_SUBST(DEVICE_GID)
 AC_SUBST(DEVICE_MODE)
+AC_SUBST(DEVICE_UID)
+AC_SUBST(DEVMAPPER)
+AC_SUBST(DMDIR)
 AC_SUBST(DMEVENTD)
+AC_SUBST(DMIOCTLS)
+AC_SUBST(DM_LIB_VERSION)
+AC_SUBST(FSADM)
+AC_SUBST(GROUP)
+AC_SUBST(HAVE_LIBDL)
+AC_SUBST(HAVE_REALTIME)
+AC_SUBST(HAVE_SELINUX)
+AC_SUBST(INTL)
+AC_SUBST(INTL_PACKAGE)
+AC_SUBST(JOBS)
+AC_SUBST(LDDEPS)
+AC_SUBST(LIBS)
+AC_SUBST(LIB_SUFFIX)
+AC_SUBST(LOCALEDIR)
+AC_SUBST(LVM1)
+AC_SUBST(LVM1_FALLBACK)
+AC_SUBST(LVM_VERSION)
+AC_SUBST(MIRRORS)
+AC_SUBST(MSGFMT)
+AC_SUBST(OWNER)
 AC_SUBST(PKGCONFIG)
+AC_SUBST(POOL)
+AC_SUBST(SNAPSHOTS)
+AC_SUBST(STATICDIR)
+AC_SUBST(STATIC_LINK)
 AC_SUBST([LIB_PTHREAD])
+AC_SUBST(interface)
+AC_SUBST(kerneldir)
+AC_SUBST(missingkernel)
+AC_SUBST(kernelvsn)
+AC_SUBST(tmpdir)
+AC_SUBST(usrlibdir)
 
 ################################################################################
-dnl -- First and last lines should not contain files to generate in order to 
+dnl -- First and last lines should not contain files to generate in order to
 dnl -- keep utility scripts running properly
 AC_CONFIG_FILES([\
 Makefile								\
 make.tmpl                                                               \
 include/Makefile                                                        \
 dmsetup/Makefile							\
-lib/Makefile							 	\
+lib/Makefile								\
 lib/libdevmapper.pc							\
-dmeventd/Makefile						 	\
+dmeventd/Makefile							\
 dmeventd/libdevmapper-event.pc						\
 kernel/Makefile								\
 man/Makefile								\
--- device-mapper/include/configure.h.in	2007/08/14 19:11:31	1.6
+++ device-mapper/include/configure.h.in	2008/06/06 20:33:14	1.7
@@ -3,6 +3,14 @@
 /* Define to 1 if the `closedir' function returns void instead of `int'. */
 #undef CLOSEDIR_VOID
 
+/* Define to one of `_getb67', `GETB67', `getb67' for Cray-2 and Cray-YMP
+   systems. This function is required for `alloca.c' support on those systems.
+   */
+#undef CRAY_STACKSEG_END
+
+/* Define to 1 if using `alloca.c'. */
+#undef C_ALLOCA
+
 /* Path to dmeventd binary. */
 #undef DMEVENTD_PATH
 
@@ -12,6 +20,13 @@
 /* Library version */
 #undef DM_LIB_VERSION
 
+/* Define to 1 if you have `alloca', as a function or macro. */
+#undef HAVE_ALLOCA
+
+/* Define to 1 if you have <alloca.h> and it should be used (not on Ultrix).
+   */
+#undef HAVE_ALLOCA_H
+
 /* Define to 1 if canonicalize_file_name is available. */
 #undef HAVE_CANONICALIZE_FILE_NAME
 
@@ -30,6 +45,12 @@
 /* Define to 1 if you have the <fcntl.h> header file. */
 #undef HAVE_FCNTL_H
 
+/* Define to 1 if you have the `fork' function. */
+#undef HAVE_FORK
+
+/* Define to 1 if you have the `gethostname' function. */
+#undef HAVE_GETHOSTNAME
+
 /* Define to 1 if getline is available. */
 #undef HAVE_GETLINE
 
@@ -39,12 +60,22 @@
 /* Define to 1 if you have the <getopt.h> header file. */
 #undef HAVE_GETOPT_H
 
+/* Define to 1 if you have the `getpagesize' function. */
+#undef HAVE_GETPAGESIZE
+
 /* Define to 1 if you have the <inttypes.h> header file. */
 #undef HAVE_INTTYPES_H
 
+/* Define to 1 if you have the `readline' library (-lreadline). */
+#undef HAVE_LIBREADLINE
+
 /* Define to 1 if you have the <limits.h> header file. */
 #undef HAVE_LIMITS_H
 
+/* Define to 1 if `lstat' has the bug that it succeeds when given the
+   zero-length file name argument. */
+#undef HAVE_LSTAT_EMPTY_STRING_BUG
+
 /* Define to 1 if your system has a GNU libc compatible `malloc' function, and
    to 0 otherwise. */
 #undef HAVE_MALLOC
@@ -58,18 +89,30 @@
 /* Define to 1 if you have the `mkdir' function. */
 #undef HAVE_MKDIR
 
+/* Define to 1 if you have a working `mmap' system call. */
+#undef HAVE_MMAP
+
+/* Define to 1 if you have the `munmap' function. */
+#undef HAVE_MUNMAP
+
 /* Define to 1 if you have the <ndir.h> header file, and it defines `DIR'. */
 #undef HAVE_NDIR_H
 
+/* Define to 1 if rl_completion_matches() is available. */
+#undef HAVE_RL_COMPLETION_MATCHES
+
 /* Define to 1 if you have the `rmdir' function. */
 #undef HAVE_RMDIR
 
-/* Define to 1 if selinux is available. */
+/* Define to 1 to include support for selinux. */
 #undef HAVE_SELINUX
 
 /* Define to 1 if sepol_check_context is available. */
 #undef HAVE_SEPOL
 
+/* Define to 1 if you have the `setlocale' function. */
+#undef HAVE_SETLOCALE
+
 /* Define to 1 if `stat' has the bug that it succeeds when given the
    zero-length file name argument. */
 #undef HAVE_STAT_EMPTY_STRING_BUG
@@ -86,6 +129,9 @@
 /* Define to 1 if you have the <stdlib.h> header file. */
 #undef HAVE_STDLIB_H
 
+/* Define to 1 if you have the `strcasecmp' function. */
+#undef HAVE_STRCASECMP
+
 /* Define to 1 if you have the `strchr' function. */
 #undef HAVE_STRCHR
 
@@ -101,9 +147,21 @@
 /* Define to 1 if you have the <string.h> header file. */
 #undef HAVE_STRING_H
 
+/* Define to 1 if you have the `strncasecmp' function. */
+#undef HAVE_STRNCASECMP
+
 /* Define to 1 if you have the `strrchr' function. */
 #undef HAVE_STRRCHR
 
+/* Define to 1 if you have the `strstr' function. */
+#undef HAVE_STRSTR
+
+/* Define to 1 if you have the `strtol' function. */
+#undef HAVE_STRTOL
+
+/* Define to 1 if you have the `strtoul' function. */
+#undef HAVE_STRTOUL
+
 /* Define to 1 if `st_rdev' is member of `struct stat'. */
 #undef HAVE_STRUCT_STAT_ST_RDEV
 
@@ -130,6 +188,9 @@
 /* Define to 1 if you have the <sys/types.h> header file. */
 #undef HAVE_SYS_TYPES_H
 
+/* Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible. */
+#undef HAVE_SYS_WAIT_H
+
 /* Define to 1 if you have the <termios.h> header file. */
 #undef HAVE_TERMIOS_H
 
@@ -139,9 +200,21 @@
 /* Define to 1 if you have the <unistd.h> header file. */
 #undef HAVE_UNISTD_H
 
+/* Define to 1 if you have the `vfork' function. */
+#undef HAVE_VFORK
+
+/* Define to 1 if you have the <vfork.h> header file. */
+#undef HAVE_VFORK_H
+
 /* Define to 1 if you have the `vprintf' function. */
 #undef HAVE_VPRINTF
 
+/* Define to 1 if `fork' works. */
+#undef HAVE_WORKING_FORK
+
+/* Define to 1 if `vfork' works. */
+#undef HAVE_WORKING_VFORK
+
 /* Define to 1 if `lstat' dereferences a symlink specified with a trailing
    slash. */
 #undef LSTAT_FOLLOWS_SLASHED_SYMLINK
@@ -164,12 +237,23 @@
 /* Define as the return type of signal handlers (`int' or `void'). */
 #undef RETSIGTYPE
 
+/* If using the C implementation of alloca, define if you know the
+   direction of stack growth for your system; otherwise it will be
+   automatically deduced at runtime.
+	STACK_DIRECTION > 0 => grows toward higher addresses
+	STACK_DIRECTION < 0 => grows toward lower addresses
+	STACK_DIRECTION = 0 => direction of growth unknown */
+#undef STACK_DIRECTION
+
 /* Define to 1 if you have the ANSI C header files. */
 #undef STDC_HEADERS
 
 /* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
 #undef TIME_WITH_SYS_TIME
 
+/* Define to 1 if your <sys/time.h> declares `struct tm'. */
+#undef TM_IN_SYS_TIME
+
 /* Define to empty if `const' does not conform to ANSI C. */
 #undef const
 
@@ -182,6 +266,9 @@
 /* Define to rpl_malloc if the replacement function should be used. */
 #undef malloc
 
+/* Define to `int' if <sys/types.h> does not define. */
+#undef mode_t
+
 /* Define to `long int' if <sys/types.h> does not define. */
 #undef off_t
 
@@ -190,3 +277,6 @@
 
 /* Define to `unsigned int' if <sys/types.h> does not define. */
 #undef size_t
+
+/* Define as `fork' if `vfork' does not work. */
+#undef vfork
