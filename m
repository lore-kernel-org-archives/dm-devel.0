From: zkabelac@sourceware.org
Subject: dmraid ./configure ./configure.in ./make.tmpl. ...
Date: 30 May 2010 19:15:27 -0000
Message-ID: <20100530191527.13799.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 19:15:26

Modified files:
	.              : configure configure.in make.tmpl.in 
	include        : config.h.in 
	lib            : Makefile.in 

Log message:
	Add simplified detection for libdevmapper-event library
	
	Future extension to static linking might be needed
	
	Current check only detects devmapper-event library - as the new libdevmapper linking
	links libdevmapper library automaticaly as a dependency.
	
	In case this project would need to link with older version futher extension might
	be needed here (adding -ldevmapper check).

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.11&r2=1.12
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/config.h.in.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.14&r2=1.15

--- dmraid/configure	2010/05/30 17:44:55	1.10
+++ dmraid/configure	2010/05/30 19:15:26	1.11
@@ -651,6 +651,7 @@
 DMRAID_LIB_MAJOR
 DMRAID_LIB_DATE
 DIETLIBC
+DEVMAPPEREVENT_LIBS
 DEBUG_MALLOC
 DEBUG
 CLDFLAGS
@@ -8149,6 +8150,231 @@
 
 fi
 
+{ $as_echo "$as_me:$LINENO: checking for dm_task_set_name in -ldevmapper-event" >&5
+$as_echo_n "checking for dm_task_set_name in -ldevmapper-event... " >&6; }
+if test "${ac_cv_lib_devmapper_event_dm_task_set_name+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-ldevmapper-event  $LIBS"
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
+char dm_task_set_name ();
+int
+main ()
+{
+return dm_task_set_name ();
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
+  ac_cv_lib_devmapper_event_dm_task_set_name=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_devmapper_event_dm_task_set_name=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_devmapper_event_dm_task_set_name" >&5
+$as_echo "$ac_cv_lib_devmapper_event_dm_task_set_name" >&6; }
+if test "x$ac_cv_lib_devmapper_event_dm_task_set_name" = x""yes; then
+  DEVMAPPEREVENT_LIBS="-ldevmapper-event"
+else
+  { { $as_echo "$as_me:$LINENO: error: device-mapper-event library is either missing or is too old and badly linked." >&5
+$as_echo "$as_me: error: device-mapper-event library is either missing or is too old and badly linked." >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+
+
+for ac_header in libdevmapper.h libdevmapper-event.h
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
+else
+  { { $as_echo "$as_me:$LINENO: error: Missing headers device-mapper headers." >&5
+$as_echo "$as_me: error: Missing headers device-mapper headers." >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+done
+
+
 VERSION=$srcdir/tools/VERSION
 DMRAID_LIB_MAJOR=$(cut -d. -f1 $VERSION)
 DMRAID_LIB_MINOR=$(cut -d. -f2 $VERSION)
@@ -8177,6 +8403,7 @@
 
 
 
+
 ac_config_files="$ac_config_files include/Makefile lib/Makefile lib/version.h man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
 
 cat >confcache <<\_ACEOF
--- dmraid/configure.in	2010/05/30 17:44:55	1.10
+++ dmraid/configure.in	2010/05/30 19:15:26	1.11
@@ -232,6 +232,14 @@
 	AC_CHECK_HEADERS(getopt.h, AC_DEFINE(HAVE_GETOPTLONG, 1, [Define to 1 for longopt.]))
 fi
 
+dnl FIXME static linking would need some extension here
+dnl best would be to use pkg-config in Makefiles 
+AC_CHECK_LIB(devmapper-event, dm_task_set_name,
+	[DEVMAPPEREVENT_LIBS="-ldevmapper-event"],
+	[AC_MSG_ERROR([device-mapper-event library is either missing or is too old and badly linked.])])
+AC_CHECK_HEADERS(libdevmapper.h libdevmapper-event.h,,
+	[AC_MSG_ERROR([Missing headers device-mapper headers.])])
+
 VERSION=$srcdir/tools/VERSION
 DMRAID_LIB_MAJOR=$(cut -d. -f1 $VERSION)
 DMRAID_LIB_MINOR=$(cut -d. -f2 $VERSION)
@@ -244,6 +252,7 @@
 AC_SUBST(CLDFLAGS)
 AC_SUBST(DEBUG)
 AC_SUBST(DEBUG_MALLOC)
+AC_SUBST(DEVMAPPEREVENT_LIBS)
 AC_SUBST(DIETLIBC)
 AC_SUBST(DMRAID_LIB_DATE)
 AC_SUBST(DMRAID_LIB_MAJOR)
--- dmraid/make.tmpl.in	2010/05/30 17:44:55	1.11
+++ dmraid/make.tmpl.in	2010/05/30 19:15:26	1.12
@@ -17,11 +17,12 @@
 LIBS = @LIBS@
 AWK = @AWK@
 SED = @SED@
+DEVMAPPEREVENT_LIBS = @DEVMAPPEREVENT_LIBS@
+DMRAID_LIB_DATE = @DMRAID_LIB_DATE@
 DMRAID_LIB_MAJOR = @DMRAID_LIB_MAJOR@
 DMRAID_LIB_MINOR = @DMRAID_LIB_MINOR@
 DMRAID_LIB_SUBMINOR = @DMRAID_LIB_SUBMINOR@
 DMRAID_LIB_SUFFIX = @DMRAID_LIB_SUFFIX@
-DMRAID_LIB_DATE = @DMRAID_LIB_DATE@
 
 CFLAGS += @CFLAGS@
 CLDFLAGS += @CLDFLAGS@
--- dmraid/include/config.h.in	2010/05/30 17:44:55	1.2
+++ dmraid/include/config.h.in	2010/05/30 19:15:26	1.3
@@ -43,6 +43,12 @@
 /* Define to 1 if you have the <inttypes.h> header file. */
 #undef HAVE_INTTYPES_H
 
+/* Define to 1 if you have the <libdevmapper-event.h> header file. */
+#undef HAVE_LIBDEVMAPPER_EVENT_H
+
+/* Define to 1 if you have the <libdevmapper.h> header file. */
+#undef HAVE_LIBDEVMAPPER_H
+
 /* Define to 1 if you have the <limits.h> header file. */
 #undef HAVE_LIMITS_H
 
--- dmraid/lib/Makefile.in	2010/05/30 17:41:22	1.14
+++ dmraid/lib/Makefile.in	2010/05/30 19:15:26	1.15
@@ -75,12 +75,12 @@
 
 DMRAID_LIB_VERSION = $(DMRAID_LIB_MAJOR).$(DMRAID_LIB_MINOR).$(DMRAID_LIB_SUBMINOR)
 $(LIB_SHARED): $(OBJECTS) $(LD_DEPS)
-	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS) -ldevmapper-event \
+	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS) $(DEVMAPPEREVENT_LIBS) \
 		-shared -Wl,-soname,$(notdir $@).$(DMRAID_LIB_MAJOR) $(CLDFLAGS)
 
 $(LIB_EVENTS_SHARED): $(OBJECTS2)
 	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS2) \
-		-shared  -Wl,-soname,$(notdir $@) -ldevmapper-event -lpthread
+		-shared  -Wl,-soname,$(notdir $@) $(DEVMAPPEREVENT_LIBS) -lpthread
 
 .PHONY: $(addprefix install_,$(TARGETS)) $(addprefix remove_,$(TARGETS))
 
