From: zkabelac@sourceware.org
Subject: dmraid/lib Makefile.in
Date: 28 May 2010 12:35:02 -0000
Message-ID: <20100528123502.18489.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 12:35:02

Modified files:
	lib            : Makefile.in 

Log message:
	Reworked installation of libraries and plugins
	Using relpath.awk for path between  usrlibdir and libdir

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.11&r2=1.12

--- dmraid/lib/Makefile.in	2010/05/28 09:17:25	1.11
+++ dmraid/lib/Makefile.in	2010/05/28 12:35:01	1.12
@@ -47,18 +47,19 @@
 	format/partition/dos.c
 
 ifeq ("@STATIC_LINK@", "no")
-	SOURCES += register/dmreg.c
 # Dynamic linker library
-LIBS += -ldl
+	LIBS += -ldl
+	SOURCES += register/dmreg.c
 endif
 
 SOURCES2 = events/$(LIB_EVENTS_NAME).c
 
-LIB_STATIC=$(top_builddir)/lib/libdmraid.a
-LIB_EVENTS_NAME=libdmraid-events-isw
+LIB_STATIC = $(top_builddir)/lib/libdmraid.a
+LIB_EVENTS_NAME = libdmraid-events-isw
+USRLIB_RELPATH = $(shell echo $(abspath $(usrlibdir) $(libdir)) | \
+  $(AWK) -f $(top_srcdir)/tools/relpath.awk)
 
-TARGETS=$(LIB_STATIC)
-INSTALL_TARGETS=$(LIB_STATIC)
+TARGETS = $(LIB_STATIC)
 
 include $(top_builddir)/make.tmpl
 
@@ -67,43 +68,40 @@
 		LIB_SHARED=$(top_builddir)/lib/libdmraid.so
 		LIB_EVENTS_SHARED=$(LIB_EVENTS_NAME).so
 		TARGETS += $(LIB_SHARED) $(LIB_EVENTS_SHARED)
-		INSTALL_TARGETS += $(LIB_SHARED) $(LIB_EVENTS_SHARED)
 	endif
 endif
 
 all: $(TARGETS)
-	@echo $(TARGETS) $(INSTALL_TARGETS)
 
 $(LIB_EVENTS_SHARED): $(OBJECTS2)
 	$(CC) -o $@ $(INCLUDES) $(CFLAGS) $(LDFLAGS) $(OBJECTS2) \
 	  -shared  -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) \
 	  $(LIB_SHARED) -ldevmapper-event -lpthread
 
-.PHONY: install_dmraid_libs remove_dmraid_libs
+.PHONY: $(addprefix install_,$(TARGETS)) $(addprefix remove_,$(TARGETS))
+
+install_$(LIB_EVENTS_SHARED): $(LIB_EVENTS_SHARED)
+	$(INSTALL_PROGRAM) -D $< $(DESTDIR)$(libdir)/device-mapper/$(<F)
+	$(LN_S) -f device-mapper/$(<F) $(DESTDIR)$(libdir)/$(<F)
+
+remove_$(LIB_EVENTS_SHARED):
+	$(RM) $(DESTDIR)$(libdir)/device-mapper/$(notdir $(LIB_EVENTS_SHARED))
+	$(RM) $(DESTDIR)$(libdir)/$(notdir $(LIB_EVENTS_SHARED))
+
+install_$(LIB_SHARED): $(LIB_SHARED)
+	$(INSTALL_PROGRAM) -D $< $(DESTDIR)$(libdir)/$(<F).$(DMRAID_LIB_VERSION)
+	$(INSTALL_DIR) $(DESTDIR)$(usrlibdir)
+	$(LN_S) -f $(USRLIB_RELPATH)$(<F).$(DMRAID_LIB_VERSION) $(DESTDIR)$(usrlibdir)/$(<F)
+
+remove_$(LIB_SHARED):
+	$(RM) $(DESTDIR)$(libdir)/$(notdir $(LIB_SHARED)).$(DMRAID_LIB_VERSION)
+	$(RM) $(DESTDIR)$(usrlibdir)/$(notdir $(LIB_SHARED))
+
+install_$(LIB_STATIC): $(LIB_STATIC)
+	$(INSTALL_DATA) -D $< $(DESTDIR)$(usrlibdir)/$(LIB_STATIC)
 
-install_dmraid_libs: $(INSTALL_TARGETS)
-	@echo "Installing $(INSTALL_TARGETS) in $(DESTDIR)$(libdir)"; \
-	$(INSTALL_DIR) $(DESTDIR)$(libdir); \
-	for f in $(INSTALL_TARGETS); \
-	do \
-		n=$$(basename $${f}) ; \
- 		if [[ "$$n" =~ .so$$ ]]; then \
-			$(INSTALL_PROGRAM) $$f $(DESTDIR)$(libdir)/$${n}.$(DMRAID_LIB_VERSION); \
-			$(LN_S) -f $${n}.$(DMRAID_LIB_VERSION) $(DESTDIR)$(libdir)/$${n}; \
-		else \
-			$(INSTALL_PROGRAM) $$f $(DESTDIR)$(libdir)/$${n}; \
-		fi \
-	done
-
-install: install_dmraid_libs
-
-remove_dmraid_libs:
-	@echo "Removing $(INSTALL_TARGETS) from $(libdir)"; \
-	for f in $(INSTALL_TARGETS); \
-	do \
-		n=$$(basename $${f}) ; \
-		$(RM) $(DESTDIR)$(libdir)/$${n}.$(DMRAID_LIB_VERSION); \
-		$(RM) $(DESTDIR)$(libdir)/$${n}; \
-	done
+remove_$(LIB_STATIC):
+	$(RM) $(DESTDIR)$(usrlibdir)/$(notdir $(LIB_STATIC))
 
-remove:	remove_dmraid_libs
+install: $(addprefix install_,$(TARGETS))
+remove: $(addprefix remove_,$(TARGETS))
