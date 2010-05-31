From: zkabelac@sourceware.org
Subject: dmraid ./configure ./configure.in ./make.tmpl. ...
Date: 31 May 2010 09:24:43 -0000
Message-ID: <20100531092443.23093.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-31 09:24:43

Modified files:
	.              : configure configure.in make.tmpl.in 
	lib            : Makefile.in 

Log message:
	Add configure detection for -ldl and -lpthread
	Check for devmapper installation
	Link all used libs by libdmraid and its plugin
	(do not expect devmapper-event will have devmapper and dl)
	Add few more linker flags for this detection

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.diff?cvsroot=dm&r1=1.12&r2=1.13
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/configure.in.diff?cvsroot=dm&r1=1.12&r2=1.13
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.13&r2=1.14
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.16&r2=1.17

--- dmraid/configure	2010/05/30 22:25:37	1.12
+++ dmraid/configure	2010/05/31 09:24:42	1.13
@@ -641,6 +641,7 @@
 usrlibdir
 STATIC_LINK
 SOFLAG
+PTHREAD_LIBS
 LIB_SO
 LD_DEPS
 JOBS
@@ -650,7 +651,10 @@
 DMRAID_LIB_MINOR
 DMRAID_LIB_MAJOR
 DMRAID_LIB_DATE
+DL_LIBS
 DIETLIBC
+DEVMAPPER_LIBS
+DEVMAPPER_CFLAGS
 DEVMAPPEREVENT_LIBS
 DEVMAPPEREVENT_CFLAGS
 DEBUG_MALLOC
@@ -751,7 +755,7 @@
 enable_static_link
 enable_shared_lib
 enable_testing
-with_devmapper_event_prefix
+with_devmapper_prefix
 '
       ac_precious_vars='build_alias
 host_alias
@@ -1410,8 +1414,8 @@
   --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
   --with-staticdir=DIR    Static binary in DIR [EPREFIX/sbin]
   --with-usrlibdir=DIR    User library in DIR [PREFIX/lib]
-  --with-devmapper-event-prefix=PFX
-                          Where is 'd-m-e' library installed
+  --with-devmapper-prefix=PFX
+                          Where is devmapper library installed
 
 Some influential environment variables:
   CC          C compiler command
@@ -8914,23 +8918,171 @@
 
 fi
 
+{ $as_echo "$as_me:$LINENO: checking for dlopen in -ldl" >&5
+$as_echo_n "checking for dlopen in -ldl... " >&6; }
+if test "${ac_cv_lib_dl_dlopen+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-ldl  $LIBS"
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
+char dlopen ();
+int
+main ()
+{
+return dlopen ();
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
+  ac_cv_lib_dl_dlopen=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
 
-# Check whether --with-devmapper-event-prefix was given.
-if test "${with_devmapper_event_prefix+set}" = set; then
-  withval=$with_devmapper_event_prefix; DEVMAPPEREVENT_LIBS="-L$withval/lib"
-	 DEVMAPPEREVENT_CFLAGS="-I$withval/include"
+	ac_cv_lib_dl_dlopen=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_dl_dlopen" >&5
+$as_echo "$ac_cv_lib_dl_dlopen" >&6; }
+if test "x$ac_cv_lib_dl_dlopen" = x""yes; then
+  DL_LIBS="-ldl"
 else
-  DEVMAPPEREVENT_LIBS=
-	 DEVMAPPEREVENT_CFLAGS=
+  { { $as_echo "$as_me:$LINENO: error: dl library is missing" >&5
+$as_echo "$as_me: error: dl library is missing" >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+
+{ $as_echo "$as_me:$LINENO: checking for pthread_mutex_lock in -lpthread" >&5
+$as_echo_n "checking for pthread_mutex_lock in -lpthread... " >&6; }
+if test "${ac_cv_lib_pthread_pthread_mutex_lock+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-lpthread  $LIBS"
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
+char pthread_mutex_lock ();
+int
+main ()
+{
+return pthread_mutex_lock ();
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
+  ac_cv_lib_pthread_pthread_mutex_lock=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_pthread_pthread_mutex_lock=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_pthread_pthread_mutex_lock" >&5
+$as_echo "$ac_cv_lib_pthread_pthread_mutex_lock" >&6; }
+if test "x$ac_cv_lib_pthread_pthread_mutex_lock" = x""yes; then
+  PTHREAD_LIBS="-lpthread"
+else
+  { { $as_echo "$as_me:$LINENO: error: pthread library is missing" >&5
+$as_echo "$as_me: error: pthread library is missing" >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
+
+
+# Check whether --with-devmapper-prefix was given.
+if test "${with_devmapper_prefix+set}" = set; then
+  withval=$with_devmapper_prefix; DEVMAPPER_LIBS="-L$withval/lib"
+	 DEVMAPPER_CFLAGS="-I$withval/include"
+else
+  DEVMAPPER_LIBS=
+	 DEVMAPPER_CFLAGS=
 fi
 
 save_LDFLAGS=$LDFLAGS
 save_CPPFLAGS=$CPPFLAGS
-LDFLAGS="$LDFLAGS $DEVMAPPEREVENT_LIBS"
-CPPFLAGS="$CPPFLAGS $DEVMAPPEREVENT_CFLAGS"
-{ $as_echo "$as_me:$LINENO: checking for dm_task_set_name in -ldevmapper-event" >&5
-$as_echo_n "checking for dm_task_set_name in -ldevmapper-event... " >&6; }
-if test "${ac_cv_lib_devmapper_event_dm_task_set_name+set}" = set; then
+LDFLAGS="$LDFLAGS $DEVMAPPER_LIBS"
+CPPFLAGS="$CPPFLAGS $DEVMAPPER_CFLAGS"
+{ $as_echo "$as_me:$LINENO: checking for dm_event_handler_create in -ldevmapper-event" >&5
+$as_echo_n "checking for dm_event_handler_create in -ldevmapper-event... " >&6; }
+if test "${ac_cv_lib_devmapper_event_dm_event_handler_create+set}" = set; then
   $as_echo_n "(cached) " >&6
 else
   ac_check_lib_save_LIBS=$LIBS
@@ -8948,11 +9100,11 @@
 #ifdef __cplusplus
 extern "C"
 #endif
-char dm_task_set_name ();
+char dm_event_handler_create ();
 int
 main ()
 {
-return dm_task_set_name ();
+return dm_event_handler_create ();
   ;
   return 0;
 }
@@ -8978,12 +9130,12 @@
 	 test "$cross_compiling" = yes ||
 	 $as_test_x conftest$ac_exeext
        }; then
-  ac_cv_lib_devmapper_event_dm_task_set_name=yes
+  ac_cv_lib_devmapper_event_dm_event_handler_create=yes
 else
   $as_echo "$as_me: failed program was:" >&5
 sed 's/^/| /' conftest.$ac_ext >&5
 
-	ac_cv_lib_devmapper_event_dm_task_set_name=no
+	ac_cv_lib_devmapper_event_dm_event_handler_create=no
 fi
 
 rm -rf conftest.dSYM
@@ -8991,16 +9143,89 @@
       conftest$ac_exeext conftest.$ac_ext
 LIBS=$ac_check_lib_save_LIBS
 fi
-{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_devmapper_event_dm_task_set_name" >&5
-$as_echo "$ac_cv_lib_devmapper_event_dm_task_set_name" >&6; }
-if test "x$ac_cv_lib_devmapper_event_dm_task_set_name" = x""yes; then
-  DEVMAPPEREVENT_LIBS="$DEVMAPPEREVENT_LIBS -ldevmapper-event"
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_devmapper_event_dm_event_handler_create" >&5
+$as_echo "$ac_cv_lib_devmapper_event_dm_event_handler_create" >&6; }
+if test "x$ac_cv_lib_devmapper_event_dm_event_handler_create" = x""yes; then
+  DEVMAPPEREVENT_LIBS="$DEVMAPPER_LIBS -ldevmapper-event"
 else
   { { $as_echo "$as_me:$LINENO: error: device-mapper-event library is either missing or is too old and badly linked" >&5
 $as_echo "$as_me: error: device-mapper-event library is either missing or is too old and badly linked" >&2;}
    { (exit 1); exit 1; }; }
 fi
 
+{ $as_echo "$as_me:$LINENO: checking for dm_task_set_name in -ldevmapper" >&5
+$as_echo_n "checking for dm_task_set_name in -ldevmapper... " >&6; }
+if test "${ac_cv_lib_devmapper_dm_task_set_name+set}" = set; then
+  $as_echo_n "(cached) " >&6
+else
+  ac_check_lib_save_LIBS=$LIBS
+LIBS="-ldevmapper  $LIBS"
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
+  ac_cv_lib_devmapper_dm_task_set_name=yes
+else
+  $as_echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+	ac_cv_lib_devmapper_dm_task_set_name=no
+fi
+
+rm -rf conftest.dSYM
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext conftest.$ac_ext
+LIBS=$ac_check_lib_save_LIBS
+fi
+{ $as_echo "$as_me:$LINENO: result: $ac_cv_lib_devmapper_dm_task_set_name" >&5
+$as_echo "$ac_cv_lib_devmapper_dm_task_set_name" >&6; }
+if test "x$ac_cv_lib_devmapper_dm_task_set_name" = x""yes; then
+  DEVMAPPER_LIBS="$DEVMAPPER_LIBS -ldevmapper"
+else
+  { { $as_echo "$as_me:$LINENO: error: device-mapper library is missing" >&5
+$as_echo "$as_me: error: device-mapper library is missing" >&2;}
+   { (exit 1); exit 1; }; }
+fi
+
 
 
 for ac_header in libdevmapper.h libdevmapper-event.h
@@ -9185,6 +9410,10 @@
 
 
 
+
+
+
+
 ac_config_files="$ac_config_files include/Makefile lib/Makefile lib/version.h man/Makefile tools/Makefile tools/version.h Makefile make.tmpl"
 
 cat >confcache <<\_ACEOF
--- dmraid/configure.in	2010/05/30 22:25:36	1.12
+++ dmraid/configure.in	2010/05/31 09:24:42	1.13
@@ -234,22 +234,33 @@
 	AC_CHECK_HEADERS(getopt.h, AC_DEFINE(HAVE_GETOPTLONG, 1, [Define to 1 for longopt.]))
 fi
 
+AC_CHECK_LIB(dl, dlopen,
+	[DL_LIBS="-ldl"],
+	[AC_MSG_ERROR([dl library is missing])])
+
+AC_CHECK_LIB(pthread, pthread_mutex_lock,
+	[PTHREAD_LIBS="-lpthread"],
+	[AC_MSG_ERROR([pthread library is missing])])
+
 dnl FIXME static linking would need some extension here
 dnl best would be to use pkg-config in Makefiles 
-AC_ARG_WITH(devmapper-event-prefix, 
-	AC_HELP_STRING([--with-devmapper-event-prefix=PFX],
-		[Where is 'd-m-e' library installed]),
-	[DEVMAPPEREVENT_LIBS="-L$withval/lib"
-	 DEVMAPPEREVENT_CFLAGS="-I$withval/include"],
-	[DEVMAPPEREVENT_LIBS=
-	 DEVMAPPEREVENT_CFLAGS=])
+AC_ARG_WITH(devmapper-prefix,
+	AC_HELP_STRING([--with-devmapper-prefix=PFX],
+		[Where is devmapper library installed]),
+	[DEVMAPPER_LIBS="-L$withval/lib"
+	 DEVMAPPER_CFLAGS="-I$withval/include"],
+	[DEVMAPPER_LIBS=
+	 DEVMAPPER_CFLAGS=])
 save_LDFLAGS=$LDFLAGS
 save_CPPFLAGS=$CPPFLAGS
-LDFLAGS="$LDFLAGS $DEVMAPPEREVENT_LIBS"
-CPPFLAGS="$CPPFLAGS $DEVMAPPEREVENT_CFLAGS"
-AC_CHECK_LIB(devmapper-event, dm_task_set_name,
-	[DEVMAPPEREVENT_LIBS="$DEVMAPPEREVENT_LIBS -ldevmapper-event"],
+LDFLAGS="$LDFLAGS $DEVMAPPER_LIBS"
+CPPFLAGS="$CPPFLAGS $DEVMAPPER_CFLAGS"
+AC_CHECK_LIB(devmapper-event, dm_event_handler_create,
+	[DEVMAPPEREVENT_LIBS="$DEVMAPPER_LIBS -ldevmapper-event"],
 	[AC_MSG_ERROR([device-mapper-event library is either missing or is too old and badly linked])])
+AC_CHECK_LIB(devmapper, dm_task_set_name,
+	[DEVMAPPER_LIBS="$DEVMAPPER_LIBS -ldevmapper"],
+	[AC_MSG_ERROR([device-mapper library is missing])])
 AC_CHECK_HEADERS(libdevmapper.h libdevmapper-event.h,,
 	[AC_MSG_ERROR([Missing headers device-mapper headers])])
 CPPFLAGS=$save_CPPFLAGS
@@ -269,7 +280,10 @@
 AC_SUBST(DEBUG_MALLOC)
 AC_SUBST(DEVMAPPEREVENT_CFLAGS)
 AC_SUBST(DEVMAPPEREVENT_LIBS)
+AC_SUBST(DEVMAPPER_CFLAGS)
+AC_SUBST(DEVMAPPER_LIBS)
 AC_SUBST(DIETLIBC)
+AC_SUBST(DL_LIBS)
 AC_SUBST(DMRAID_LIB_DATE)
 AC_SUBST(DMRAID_LIB_MAJOR)
 AC_SUBST(DMRAID_LIB_MINOR)
@@ -280,6 +294,7 @@
 AC_SUBST(LD_DEPS)
 AC_SUBST(LIBS)
 AC_SUBST(LIB_SO)
+AC_SUBST(PTHREAD_LIBS)
 AC_SUBST(SOFLAG)
 AC_SUBST(STATIC_LINK)
 AC_SUBST(usrlibdir)
--- dmraid/make.tmpl.in	2010/05/30 22:13:56	1.13
+++ dmraid/make.tmpl.in	2010/05/31 09:24:42	1.14
@@ -19,11 +19,15 @@
 SED = @SED@
 DEVMAPPEREVENT_CFLAGS = @DEVMAPPEREVENT_CFLAGS@
 DEVMAPPEREVENT_LIBS = @DEVMAPPEREVENT_LIBS@
+DEVMAPPER_CFLAGS = @DEVMAPPER_CFLAGS@
+DEVMAPPER_LIBS = @DEVMAPPER_LIBS@
+DL_LIBS = @DL_LIBS@
 DMRAID_LIB_DATE = @DMRAID_LIB_DATE@
 DMRAID_LIB_MAJOR = @DMRAID_LIB_MAJOR@
 DMRAID_LIB_MINOR = @DMRAID_LIB_MINOR@
 DMRAID_LIB_SUBMINOR = @DMRAID_LIB_SUBMINOR@
 DMRAID_LIB_SUFFIX = @DMRAID_LIB_SUFFIX@
+PTHREAD_LIBS = @PTHREAD_LIBS@
 
 CFLAGS += @CFLAGS@
 CLDFLAGS += @CLDFLAGS@
--- dmraid/lib/Makefile.in	2010/05/30 22:21:31	1.16
+++ dmraid/lib/Makefile.in	2010/05/31 09:24:42	1.17
@@ -47,7 +47,6 @@
 
 ifeq ("@STATIC_LINK@", "no")
 # Dynamic linker library
-	LIBS += -ldl
 	SOURCES += register/dmreg.c
 endif
 
@@ -74,12 +73,15 @@
 
 DMRAID_LIB_VERSION = $(DMRAID_LIB_MAJOR).$(DMRAID_LIB_MINOR).$(DMRAID_LIB_SUBMINOR)
 $(LIB_SHARED): $(OBJECTS) $(LD_DEPS)
-	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS) $(DEVMAPPEREVENT_LIBS) \
-		-shared -Wl,-soname,$(notdir $@).$(DMRAID_LIB_MAJOR) $(CLDFLAGS)
+	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS) \
+		-shared -Wl,--discard-all -Wl,--no-undefined $(CLDFLAGS) \
+		-Wl,-soname,$(notdir $@).$(DMRAID_LIB_MAJOR) \
+		$(DEVMAPPEREVENT_LIBS) $(DEVMAPPER_LIBS) $(DL_LIBS) $(LIBS)
 
 $(LIB_EVENTS_SHARED): $(OBJECTS2)
 	$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJECTS2) \
-		-shared  -Wl,-soname,$(notdir $@) $(DEVMAPPEREVENT_LIBS) -lpthread
+		-shared -Wl,--discard-all -Wl,--no-undefined -Wl,-soname,$(notdir $@) \
+		$(LIB_SHARED) $(DEVMAPPEREVENT_LIBS) $(DEVMAPPER_LIBS) $(PTHREAD_LIBS) $(LIBS)
 
 .PHONY: $(addprefix install_,$(TARGETS)) $(addprefix remove_,$(TARGETS))
 
