From: neilb@suse.de
Subject: [dmraid 3/3] Fix DESTDIR usage in Makefiles
Date: Tue, 02 Feb 2010 18:25:47 +1100
Message-ID: <20100202072801.604968735@suse.de>
References: <20100202072544.305994749@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=DESTDIR.fix
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The current practice of prefixing $DESTDIR to %prefix% does not work
well with the default values of various directories as set by
./configure.

If you
   ./configure
   make
   make install DESTDIR=/tmp/root

then the man page are installed in the system man pages, not in
/tmp/root at all, so library files are install in /tmp/root/tmp/root/lib.

This patch changes all the Makefiles to mention $DESTDIR explicitly
when installing, and removes the prepending of $DESTDIR in make.tmpl.

It also modifies the configure command in dmraid.spec to not prefix
all directories with RPM_BUILD_ROOT.


---
 dmraid.spec         |    4 ++--
 include/Makefile.in |   10 +++++-----
 lib/Makefile.in     |   16 +++++++++-------
 make.tmpl.in        |   10 +++++-----
 man/Makefile.in     |   12 ++++++------
 tools/Makefile.in   |   10 +++++-----
 6 files changed, 32 insertions(+), 30 deletions(-)

--- dmraid.orig/dmraid.spec
+++ dmraid/dmraid.spec
@@ -72,8 +72,8 @@ Device failure reporting has to be activ
 %build
 %define _libdir /%{_lib}
 
-%configure --prefix=${RPM_BUILD_ROOT}/usr --sbindir=${RPM_BUILD_ROOT}/sbin --libdir=${RPM_BUILD_ROOT}/%{_libdir} --mandir=${RPM_BUILD_ROOT}/%{_mandir} --includedir=${RPM_BUILD_ROOT}/%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_link --enable-led --enable-intel_led
-make DESTDIR=$RPM_BUILD_ROOT
+%configure --prefix=/usr --sbindir=/sbin --libdir=%{_libdir} --mandir=%{_mandir} --includedir=%{_includedir} --enable-debug --enable-libselinux --enable-libsepol --disable-static_link --enable-led --enable-intel_led
+make
 
 %install
 rm -rf $RPM_BUILD_ROOT
--- dmraid.orig/include/Makefile.in
+++ dmraid/include/Makefile.in
@@ -16,15 +16,15 @@ include $(top_srcdir)/make.tmpl
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
 
--- dmraid.orig/lib/Makefile.in
+++ dmraid/lib/Makefile.in
@@ -77,17 +77,17 @@ $(LIB_EVENTS_SHARED):
 .PHONY: install_dmraid_libs remove_dmraid_libs
 
 install_dmraid_libs: $(INSTALL_TARGETS)
-	@echo "Installing $(INSTALL_TARGETS) in $(libdir)"; \
-	mkdir -p $(libdir); \
+	@echo "Installing $(INSTALL_TARGETS) in $(DESTDIR)$(libdir)"; \
+	mkdir -p $(DESTDIR)$(libdir); \
 	for f in $(INSTALL_TARGETS); \
 	do \
 		n=$$(basename $${f}) ; \
 		if [[ "$$n" =~ .so$$ && ! "$$n" =~ libdmraid-events-.* ]]; then \
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
 
@@ -98,8 +98,10 @@ remove_dmraid_libs:
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
--- dmraid.orig/make.tmpl.in
+++ dmraid/make.tmpl.in
@@ -21,8 +21,8 @@ LD_DEPS += @LD_DEPS@
 SOFLAG += @SOFLAG@
 
 # Setup directory variables
-prefix = $(DESTDIR)@prefix@
-exec_prefix = $(DESTDIR)@exec_prefix@
+prefix = @prefix@
+exec_prefix = @exec_prefix@
 bindir = @bindir@
 ifeq ("@KLIBC@", "no")
   libdir = @libdir@
@@ -31,9 +31,9 @@ ifeq ("@KLIBC@", "no")
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
--- dmraid.orig/man/Makefile.in
+++ dmraid/man/Makefile.in
@@ -16,21 +16,21 @@ include $(top_srcdir)/make.tmpl
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
--- dmraid.orig/tools/Makefile.in
+++ dmraid/tools/Makefile.in
@@ -79,17 +79,17 @@ dmevent_tool: $(top_srcdir)/lib/libdmrai
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
