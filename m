From: zkabelac@sourceware.org
Subject: dmraid/tools Makefile.in
Date: 30 May 2010 17:39:03 -0000
Message-ID: <20100530173903.31350.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 17:39:02

Modified files:
	tools          : Makefile.in 

Log message:
	Add version.h to DISCLEAN_TARGETS
	Simplify install and remove targets

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.10&r2=1.11

--- dmraid/tools/Makefile.in	2010/05/28 08:37:37	1.10
+++ dmraid/tools/Makefile.in	2010/05/30 17:39:02	1.11
@@ -11,6 +11,7 @@
 DIETLIBC = @DIETLIBC@
 KLIBC = @KLIBC@
 
+DISTCLEAN_TARGETS += version.h
 INCLUDES += -I$(src_dir)
 
 SOURCES=\
@@ -24,14 +25,14 @@
 TARGETS=\
 	dmraid
 
-include $(top_builddir)/make.tmpl
-
 ifeq ("@KLIBC@", "no")
 	ifeq ("@STATIC_LINK@", "no")
 		TARGETS += dmevent_tool
 	endif
 endif
 
+include $(top_builddir)/make.tmpl
+
 DMRAIDLIBS=-ldmraid
 
 # FIXME: use pkg-config here to get the list of needed librarie
@@ -64,29 +65,20 @@
 	endif
 endif
 
-all: $(TARGETS)
-
-.PHONY: install_dmraid_tools remove_dmraid_tools
+.PHONY: install_dmraid_tools
 
-dmraid:	$(OBJECTS) $(top_builddir)/lib/libdmraid.a
+dmraid: $(OBJECTS) $(top_builddir)/lib/libdmraid.a
 	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) -L$(top_builddir)/lib $(DMRAIDLIBS) $(LIBS)
 
 dmevent_tool: $(OBJECTS2) $(top_builddir)/lib/libdmraid.a
 	$(CC) -o $@ $(OBJECTS2) $(INCLUDES) $(LDFLAGS) -L$(top_builddir)/lib \
-	  $(DMRAIDLIBS) $(DMEVENTTOOLLIBS) $(LIBS)
+		$(DMEVENTTOOLLIBS) $(DMRAIDLIBS) $(LIBS)
 
 install_dmraid_tools: $(TARGETS)
-	@echo "Installing $(TARGETS) in $(DESTDIR)$(sbindir)"; \
-	$(INSTALL_DIR) $(DESTDIR)$(sbindir); \
+	$(INSTALL_DIR) $(DESTDIR)$(sbindir)
 	$(INSTALL_PROGRAM) $(TARGETS) $(DESTDIR)$(sbindir)
 
 install: install_dmraid_tools
 
-remove_dmraid_tools:
-	@echo "Removing $(TARGETS) from $(DESTDIR)$(sbindir)"; \
-	for f in $(TARGETS); \
-	do \
-		rm -f $(DESTDIR)$(sbindir)/$$f; \
-	done
-
-remove:	remove_dmraid_tools
+remove:
+	$(RM) $(addprefix $(DESTDIR)$(sbindir)/,$(TARGETS))
