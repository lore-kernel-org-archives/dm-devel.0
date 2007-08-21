From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW ./configure ./config ...
Date: 21 Aug 2007 20:32:30 -0000
Message-ID: <20070821203230.17621.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-08-21 20:32:30

Modified files:
	.              : WHATS_NEW configure configure.in 
	dmsetup        : Makefile.in 

Log message:
	Avoid static link failure with some SELinux libraries.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.203&r2=1.204
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.43&r2=1.44
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.45&r2=1.46
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/Makefile.in.diff?cvsroot=dm&r1=1.17&r2=1.18

--- device-mapper/WHATS_NEW	2007/08/21 18:41:58	1.203
+++ device-mapper/WHATS_NEW	2007/08/21 20:32:29	1.204
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Avoid static link failure with some SELinux libraries.
   Remove obsolete dmfs code from tree and update INSTALL.
 
 Version 1.02.22 - 21st August 2007
--- device-mapper/configure	2007/08/21 18:41:58	1.43
+++ device-mapper/configure	2007/08/21 20:32:29	1.44
@@ -708,6 +708,7 @@
 DEVICE_MODE
 DMEVENTD
 PKGCONFIG
+LIB_PTHREAD
 LTLIBOBJS'
 ac_subst_files=''
       ac_precious_vars='build_alias
@@ -6176,6 +6177,99 @@
 		{ echo "$as_me:$LINENO: WARNING: Disabling selinux" >&5
 echo "$as_me: WARNING: Disabling selinux" >&2;}
 	fi
+
+	# With --enable-static_link and selinux enabled, linking dmsetup
+	# fails on at least Debian unstable due to unsatisfied references
+	# to pthread_mutex_lock and _unlock.  See if we need -lpthread.
+	if test "$STATIC_LINK-$HAVE_SELINUX" = yes-yes; then
+		dm_saved_libs=$LIBS
+		LIBS="$LIBS -static"
+		{ echo "$as_me:$LINENO: checking for library containing pthread_mutex_lock" >&5
+echo $ECHO_N "checking for library containing pthread_mutex_lock... $ECHO_C" >&6; }
+if test "${ac_cv_search_pthread_mutex_lock+set}" = set; then
+  echo $ECHO_N "(cached) $ECHO_C" >&6
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
+char pthread_mutex_lock ();
+int
+main ()
+{
+return pthread_mutex_lock ();
+  ;
+  return 0;
+}
+_ACEOF
+for ac_lib in '' pthread; do
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
+  ac_cv_search_pthread_mutex_lock=$ac_res
+else
+  echo "$as_me: failed program was:" >&5
+sed 's/^/| /' conftest.$ac_ext >&5
+
+
+fi
+
+rm -f core conftest.err conftest.$ac_objext conftest_ipa8_conftest.oo \
+      conftest$ac_exeext
+  if test "${ac_cv_search_pthread_mutex_lock+set}" = set; then
+  break
+fi
+done
+if test "${ac_cv_search_pthread_mutex_lock+set}" = set; then
+  :
+else
+  ac_cv_search_pthread_mutex_lock=no
+fi
+rm conftest.$ac_ext
+LIBS=$ac_func_search_save_LIBS
+fi
+{ echo "$as_me:$LINENO: result: $ac_cv_search_pthread_mutex_lock" >&5
+echo "${ECHO_T}$ac_cv_search_pthread_mutex_lock" >&6; }
+ac_res=$ac_cv_search_pthread_mutex_lock
+if test "$ac_res" != no; then
+  test "$ac_res" = "none required" || LIBS="$ac_res $LIBS"
+  test "$ac_cv_search_pthread_mutex_lock" = "none required" ||
+				LIB_PTHREAD=-lpthread
+fi
+
+		LIBS=$dm_saved_libs
+	fi
 fi
 
 ################################################################################
@@ -6589,6 +6683,7 @@
 
 
 
+
 ################################################################################
 ac_config_files="$ac_config_files Makefile make.tmpl include/Makefile dmsetup/Makefile lib/Makefile lib/libdevmapper.pc dmeventd/Makefile dmeventd/libdevmapper-event.pc kernel/Makefile man/Makefile po/Makefile"
 
@@ -7312,10 +7407,11 @@
 DEVICE_MODE!$DEVICE_MODE$ac_delim
 DMEVENTD!$DMEVENTD$ac_delim
 PKGCONFIG!$PKGCONFIG$ac_delim
+LIB_PTHREAD!$LIB_PTHREAD$ac_delim
 LTLIBOBJS!$LTLIBOBJS$ac_delim
 _ACEOF
 
-  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 95; then
+  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 96; then
     break
   elif $ac_last_try; then
     { { echo "$as_me:$LINENO: error: could not make $CONFIG_STATUS" >&5
@@ -7334,7 +7430,7 @@
 
 cat >>$CONFIG_STATUS <<_ACEOF
 cat >"\$tmp/subs-1.sed" <<\CEOF$ac_eof
-/@[a-zA-Z_][a-zA-Z_0-9]*@/!b end
+/@[a-zA-Z_][a-zA-Z_0-9]*@/!b
 _ACEOF
 sed '
 s/[,\\&]/\\&/g; s/@/@|#_!!_#|/g
@@ -7347,8 +7443,6 @@
 ' >>$CONFIG_STATUS <conf$$subs.sed
 rm -f conf$$subs.sed
 cat >>$CONFIG_STATUS <<_ACEOF
-:end
-s/|#_!!_#|//g
 CEOF$ac_eof
 _ACEOF
 
@@ -7596,7 +7690,7 @@
 s&@abs_top_builddir@&$ac_abs_top_builddir&;t t
 s&@INSTALL@&$ac_INSTALL&;t t
 $ac_datarootdir_hack
-" $ac_file_inputs | sed -f "$tmp/subs-1.sed" >$tmp/out
+" $ac_file_inputs | sed -f "$tmp/subs-1.sed" | sed 's/|#_!!_#|//g' >$tmp/out
 
 test -z "$ac_datarootdir_hack$ac_datarootdir_seen" &&
   { ac_out=`sed -n '/\${datarootdir}/p' "$tmp/out"`; test -n "$ac_out"; } &&
--- device-mapper/configure.in	2007/08/21 18:41:58	1.45
+++ device-mapper/configure.in	2007/08/21 20:32:29	1.46
@@ -240,6 +240,18 @@
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
@@ -414,6 +426,7 @@
 AC_SUBST(DEVICE_MODE)
 AC_SUBST(DMEVENTD)
 AC_SUBST(PKGCONFIG)
+AC_SUBST([LIB_PTHREAD])
 
 ################################################################################
 dnl -- First and last lines should not contain files to generate in order to 
--- device-mapper/dmsetup/Makefile.in	2007/08/21 16:26:06	1.17
+++ device-mapper/dmsetup/Makefile.in	2007/08/21 20:32:30	1.18
@@ -18,6 +18,7 @@
 
 TARGETS = dmsetup
 INSTALL_TYPE = install_dynamic
+LIB_PTHREAD = @LIB_PTHREAD@
 
 ifeq ("@STATIC_LINK@", "yes")
   TARGETS += dmsetup.static
@@ -35,7 +36,8 @@
 
 dmsetup.static: $(OBJECTS) $(interfacedir)/libdevmapper.a
 	$(CC) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS) -static \
-	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS)
+	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS) \
+	      $(LIB_PTHREAD)
 
 install: $(INSTALL_TYPE)
 
