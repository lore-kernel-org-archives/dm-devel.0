From: zkabelac@sourceware.org
Subject: dmraid/lib Makefile.in
Date: 27 May 2010 19:47:49 -0000
Message-ID: <20100527194749.20819.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-27 19:47:49

Modified files:
	lib            : Makefile.in 

Log message:
	Use top_builddir
	Avoid linking libdmraid-events-isw to libdmraid (opened as plugin)
	Use new INSTALL

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.8&r2=1.9

--- dmraid/lib/Makefile.in	2010/05/27 14:28:48	1.8
+++ dmraid/lib/Makefile.in	2010/05/27 19:47:49	1.9
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+# Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
@@ -17,7 +17,6 @@
 	device/scan.c \
 	device/scsi.c \
 	display/display.c \
-	events/libdmraid-events-isw.c \
 	format/format.c \
 	locking/locking.c \
 	log/log.c \
@@ -49,22 +48,24 @@
 
 ifeq ("@STATIC_LINK@", "no")
 	SOURCES += register/dmreg.c
+# Dynamic linker library
+LIBS += -ldl
 endif
 
 OBJECTS=$(SOURCES:%.c=%.o)
 
-LIB_STATIC=$(top_srcdir)/lib/libdmraid.a
+LIB_STATIC=$(top_builddir)/lib/libdmraid.a
 LIB_EVENTS_NAME=libdmraid-events-isw
 
 TARGETS=$(LIB_STATIC)
 INSTALL_TARGETS=$(LIB_STATIC)
 
-include $(top_srcdir)/make.tmpl
+include $(top_builddir)/make.tmpl
 
 ifeq ("@KLIBC@", "no")
 	ifeq ("@STATIC_LINK@", "no")
-		LIB_SHARED=$(top_srcdir)/lib/libdmraid.so
-		LIB_EVENTS_SHARED=$(top_srcdir)/lib/$(LIB_EVENTS_NAME).so
+		LIB_SHARED=$(top_builddir)/lib/libdmraid.so
+		LIB_EVENTS_SHARED=$(LIB_EVENTS_NAME).so
 		TARGETS += $(LIB_SHARED) $(LIB_EVENTS_SHARED)
 		INSTALL_TARGETS += $(LIB_SHARED) $(LIB_EVENTS_SHARED)
 	endif
@@ -74,26 +75,26 @@
 	@echo $(TARGETS) $(INSTALL_TARGETS)
 
 $(LIB_EVENTS_SHARED):
-	$(CC) events/$(LIB_EVENTS_NAME).c $(INCLUDES) $(CFLAGS) $(LDFLAGS) -shared  -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) -o $@ -ldevmapper -ldevmapper-event $(LIB_SHARED) -lpthread
+	$(CC) -o $@ $(INCLUDES) $(CFLAGS) $(LDFLAGS) events/$(LIB_EVENTS_NAME).c \
+	  -shared  -Wl,-soname,$(notdir $@).$(DMRAID_LIB_VERSION) \
+	  $(LIB_SHARED) -ldevmapper-event -lpthread
 
 .PHONY: install_dmraid_libs remove_dmraid_libs
 
 install_dmraid_libs: $(INSTALL_TARGETS)
 	@echo "Installing $(INSTALL_TARGETS) in $(DESTDIR)$(libdir)"; \
-	mkdir -p $(DESTDIR)$(libdir); \
+	$(INSTALL_DIR) $(DESTDIR)$(libdir); \
 	for f in $(INSTALL_TARGETS); \
 	do \
 		n=$$(basename $${f}) ; \
  		if [[ "$$n" =~ .so$$ ]]; then \
-			$(INSTALL) -m 555 $(STRIP) \
-				$$f $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
+			$(INSTALL_PROGRAM) $$f $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
 			$(LN_S) -f $${n}.@DMRAID_LIB_VERSION@ $(DESTDIR)$(libdir)/$${n}; \
 		else \
-			$(INSTALL) -m 555 $(STRIP) $$f $(DESTDIR)$(libdir)/$${n}; \
+			$(INSTALL_PROGRAM) $$f $(DESTDIR)$(libdir)/$${n}; \
 		fi \
 	done
 
-
 install: install_dmraid_libs
 
 remove_dmraid_libs:
@@ -101,10 +102,8 @@
 	for f in $(INSTALL_TARGETS); \
 	do \
 		n=$$(basename $${f}) ; \
-		rm -f $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
-		rm -f $(DESTDIR)$(libdir)/$${n}; \
+		$(RM) $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
+		$(RM) $(DESTDIR)$(libdir)/$${n}; \
 	done
 
-
-
 remove:	remove_dmraid_libs
