From: heinzm@sourceware.org
Subject: dmraid ./dmraid.spec ./make.tmpl.in include/Ma ...
Date: 16 Mar 2010 16:02:18 -0000
Message-ID: <20100316160218.25976.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-03-16 16:02:17

Modified files:
	.              : dmraid.spec make.tmpl.in 
	include        : Makefile.in 
	lib            : Makefile.in 
	man            : Makefile.in 
	tools          : Makefile.in 

Log message:
	Adjust all Makefile.in to pay attention to DESTDIR setting

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/dmraid.spec.diff?cvsroot=dm&r1=1.12&r2=1.13
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/Makefile.in.diff?cvsroot=dm&r1=1.1&r2=1.2
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.5&r2=1.6
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/man/Makefile.in.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.5&r2=1.6

--- dmraid/dmraid.spec	2010/02/17 11:51:53	1.12
+++ dmraid/dmraid.spec	2010/03/16 16:02:15	1.13
@@ -6,7 +6,7 @@
 
 Summary: dmraid (Device-mapper RAID tool and library)
 Name: dmraid
-Version: 1.0.0.rc16
+Version: 1.0.0.rc16t
 Release: 4%{?dist}
 License: GPLv2+
 Group: System Environment/Base
@@ -65,8 +65,8 @@
 %build
 %define _libdir /%{_lib}
 
-%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_link --enable-led --enable-intel_led
-make DESTDIR=$RPM_BUILD_ROOT
+%configure --prefix=/usr --sbindir=/sbin --libdir=%{_libdir} --mandir=%{_mandir} --includedir=%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_link --enable-led --enable-intel_led
+make
 
 %install
 rm -rf $RPM_BUILD_ROOT
@@ -78,15 +78,7 @@
 (cd $RPM_BUILD_ROOT/sbin ; ln -f dmevent_tool dm_dso_reg_tool)
 (cd $RPM_BUILD_ROOT/%{_mandir}/man8 ; ln -f dmevent_tool.8 dm_dso_reg_tool.8 ; ln -f dmraid.8 dmraid.static.8)
 
-install -m 644 include/dmraid/*.h $RPM_BUILD_ROOT%{_includedir}/dmraid/
-
-# If requested, install the libdmraid and libdmraid-events (for dmeventd) DSO
-install -m 755 lib/libdmraid.so \
-	$RPM_BUILD_ROOT%{_libdir}/libdmraid.so.%{version}
-(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid.so.%{version} libdmraid.so ; ln -sf libdmraid.so.%{version} libdmraid.so.1)
-install -m 755 lib/libdmraid-events-isw.so \
-	$RPM_BUILD_ROOT%{_libdir}/libdmraid-events-isw.so.%{version}
-(cd $RPM_BUILD_ROOT/%{_libdir} ; ln -sf libdmraid-events-isw.so.%{version} libdmraid-events-isw.so ; ln -sf libdmraid-events-isw.so.%{version} libdmraid-events-isw.so.1)
+install -m 644 include/dmraid/*.h $RPM_BUILD_ROOT/%{_includedir}/dmraid/
 
 # Install logwatch config file and script for dmeventd
 install -m 644 logwatch/dmeventd.conf $RPM_BUILD_ROOT/etc/logwatch/conf/services/dmeventd.conf
@@ -150,7 +142,7 @@
 - move libraries to /lib* in order to avoid catch22
   with unmountable /usr
 
-* Wed Sep 09 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-1
+* Wed Oct 09 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc16-1
 - Updated
 
 * Wed Sep 17 2008 Heinz Mauelshagen <heinzm@redhat.com> - 1.0.0.rc15
--- dmraid/make.tmpl.in	2009/09/16 11:45:11	1.2
+++ dmraid/make.tmpl.in	2010/03/16 16:02:16	1.3
@@ -21,9 +21,10 @@
 SOFLAG += @SOFLAG@
 
 # Setup directory variables
-prefix = $(DESTDIR)@prefix@
-exec_prefix = $(DESTDIR)@exec_prefix@
+prefix = @prefix@
+exec_prefix = @exec_prefix@
 bindir = @bindir@
+datadir = @datarootdir@
 ifeq ("@KLIBC@", "no")
   libdir = @libdir@
   sbindir = @sbindir@
@@ -31,9 +32,9 @@
   infodir = @infodir@
   mandir = @mandir@
 else
-  libdir = $(DESTDIR)@KLIBC_LIB_DIR@
-  sbindir = $(DESTDIR)@KLIBC_SBIN_DIR@
-  includedir = $(DESTDIR)@KLIBC_INCLUDE_DIR@
+  libdir = @KLIBC_LIB_DIR@
+  sbindir = @KLIBC_SBIN_DIR@
+  includedir = @KLIBC_INCLUDE_DIR@
   infodir = @infodir@
   mandir = @mandir@
 endif
--- dmraid/include/Makefile.in	2008/02/22 16:57:35	1.1
+++ dmraid/include/Makefile.in	2010/03/16 16:02:16	1.2
@@ -16,15 +16,15 @@
 .PHONY: install_dmraid_headers remove_dmraid_headers
 
 install_dmraid_headers: $(HEADERS)
-	@echo "Installing $(HEADERS) in $(includedir)/dmraid"
-	mkdir -p $(includedir)/dmraid
-	$(INSTALL) $(STRIP) $(HEADERS) $(includedir)/dmraid
+	@echo "Installing $(HEADERS) in $(DESTDIR)$(includedir)/dmraid"
+	mkdir -p $(DESTDIR)$(includedir)/dmraid
+	$(INSTALL) $(STRIP) $(HEADERS) $(DESTDIR)$(includedir)/dmraid
 
 install: install_dmraid_headers
 
 remove_dmraid_headers:
-	@echo "Removing $(HEADERS) from $(includedir)/dmraid"
-	rm -f $(includedir)/dmraid
+	@echo "Removing $(HEADERS) from $(DESTDIR)$(includedir)/dmraid"
+	rm -f $(DESTDIR)$(includedir)/dmraid
 
 remove:        remove_dmraid_headers
 
--- dmraid/lib/Makefile.in	2010/03/02 15:27:38	1.5
+++ dmraid/lib/Makefile.in	2010/03/16 16:02:16	1.6
@@ -77,20 +77,21 @@
 .PHONY: install_dmraid_libs remove_dmraid_libs
 
 install_dmraid_libs: $(INSTALL_TARGETS)
-	@echo "Installing $(INSTALL_TARGETS) in $(libdir)"; \
-	mkdir -p $(libdir); \
+	@echo "Installing $(INSTALL_TARGETS) in $(DESTDIR)$(libdir)"; \
+	mkdir -p $(DESTDIR)$(libdir); \
 	for f in $(INSTALL_TARGETS); \
 	do \
 		n=$$(basename $${f}) ; \
-		if [[ "$$n" =~ '.so$$' ]]; then \
+ 		if [[ "$$n" =~ .so$$ ]]; then \
 			$(INSTALL) -m 555 $(STRIP) \
-				$$f $(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
-			$(LN_S) -f $${n}.@DMRAID_LIB_VERSION@ $(libdir)/$${n}; \
+				$$f $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
+			$(LN_S) -f $${n}.@DMRAID_LIB_VERSION@ $(DESTDIR)$(libdir)/$${n}; \
 		else \
-			$(INSTALL) -m 555 $(STRIP) $$f $(libdir)/$${n}; \
+			$(INSTALL) -m 555 $(STRIP) $$f $(DESTDIR)$(libdir)/$${n}; \
 		fi \
 	done
 
+
 install: install_dmraid_libs
 
 remove_dmraid_libs:
@@ -98,8 +99,10 @@
 	for f in $(INSTALL_TARGETS); \
 	do \
 		n=$$(basename $${f}) ; \
-		rm -f $(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
-		rm -f $(libdir)/$${n}; \
+		rm -f $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
+		rm -f $(DESTDIR)$(libdir)/$${n}; \
 	done
 
+
+
 remove:	remove_dmraid_libs
--- dmraid/man/Makefile.in	2009/09/16 11:45:17	1.2
+++ dmraid/man/Makefile.in	2010/03/16 16:02:16	1.3
@@ -16,21 +16,21 @@
 .PHONY:	install_dmraid_man remove_dmraid_man
 
 install_dmraid_man:
-	@echo "Installing $(MAN8) in $(MAN8DIR)"; \
-	mkdir -p $(MAN8DIR); \
+	@echo "Installing $(MAN8) in $(DESTDIR)$(MAN8DIR)"; \
+	mkdir -p $(DESTDIR)$(MAN8DIR); \
 	for f in $(MAN8); \
 	do \
-	   $(RM) $(MAN8DIR)/$$f; \
-	   @INSTALL@ -D -m 444 $$f $(MAN8DIR)/$$f; \
+	   $(RM) $(DESTDIR)$(MAN8DIR)/$$f; \
+	   @INSTALL@ -D -m 444 $$f $(DESTDIR)$(MAN8DIR)/$$f; \
 	done
 
 install:	install_dmraid_man
 
 remove_dmraid_man:
-	@echo "Removing $(MAN8) in $(MAN8DIR)"; \
+	@echo "Removing $(MAN8) in $(DESTDIR)$(MAN8DIR)"; \
 	for f in $(MAN8); \
 	do \
-	   $(RM) $(MAN8DIR)/$$f; \
+	   $(RM) $(DESTDIR)$(MAN8DIR)/$$f; \
 	done
 
 remove:	remove_dmraid_man
--- dmraid/tools/Makefile.in	2009/09/16 11:45:18	1.5
+++ dmraid/tools/Makefile.in	2010/03/16 16:02:16	1.6
@@ -79,17 +79,17 @@
 	      -L$(DESTDIR)$(libdir) $(DMRAIDLIBS) $(DMEVENTTOOLLIBS) $(DMRAIDLIBS) $(LIBS) 
 
 install_dmraid_tools: $(TARGETS)
-	@echo "Installing $(TARGETS) in $(sbindir)"; \
-	mkdir -p $(sbindir); \
-	$(INSTALL) $(STRIP) $(TARGETS) $(sbindir)
+	@echo "Installing $(TARGETS) in $(DESTDIR)$(sbindir)"; \
+	mkdir -p $(DESTDIR)$(sbindir); \
+	$(INSTALL) $(STRIP) $(TARGETS) $(DESTDIR)$(sbindir)
 
 install: install_dmraid_tools
 
 remove_dmraid_tools:
-	@echo "Removing $(TARGETS) from $(sbindir)"; \
+	@echo "Removing $(TARGETS) from $(DESTDIR)$(sbindir)"; \
 	for f in $(TARGETS); \
 	do \
-		rm -f $(sbindir)/$$f; \
+		rm -f $(DESTDIR)$(sbindir)/$$f; \
 	done
 
 remove:	remove_dmraid_tools
