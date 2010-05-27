From: zkabelac@sourceware.org
Subject: dmraid/tools Makefile.in
Date: 27 May 2010 19:50:28 -0000
Message-ID: <20100527195028.22238.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-27 19:50:28

Modified files:
	tools          : Makefile.in 

Log message:
	Use top_builddir
	Link only with dmraid  (pthread is devmapper dependency)
	Do not link DMEVENTTOOLLIBS with dmraid
	-ldl is linked via libdmraid
	Use new INSTALL

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.8&r2=1.9

--- dmraid/tools/Makefile.in	2010/05/27 14:28:48	1.8
+++ dmraid/tools/Makefile.in	2010/05/27 19:50:28	1.9
@@ -1,5 +1,5 @@
 #
-# Copyright (C) 2004-2005  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
+# Copyright (C) 2004-2010  Heinz Mauelshagen, Red Hat GmbH. All rights reserved.
 #
 # See file LICENSE at the top of this source tree for license information.
 #
@@ -9,9 +9,9 @@
 top_builddir = @top_builddir@
 VPATH = @srcdir@
 DIETLIBC = @DIETLIBC@
-KIBC = @KLIBC@
+KLIBC = @KLIBC@
 
-INCLUDES += -I $(src_dir)
+INCLUDES += -I$(src_dir)
 
 SOURCES=\
 	dmraid.c \
@@ -21,7 +21,7 @@
 TARGETS=\
 	dmraid
 
-include $(top_srcdir)/make.tmpl
+include $(top_builddir)/make.tmpl
 
 ifeq ("@KLIBC@", "no")
 	ifeq ("@STATIC_LINK@", "no")
@@ -29,7 +29,7 @@
 	endif
 endif
 
-DMRAIDLIBS=-ldmraid -lpthread
+DMRAIDLIBS=-ldmraid
 
 # FIXME: use pkg-config here to get the list of needed librarie
 #  pkg-config --libs  devmapper
@@ -61,25 +61,21 @@
 	endif
 endif
 
-# Dynamic linker library
-LIBS += -ldl
-
 all: $(TARGETS)
 
 .PHONY: install_dmraid_tools remove_dmraid_tools
 
 dmraid:	$(OBJECTS) $(top_builddir)/lib/libdmraid.a
-	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) -L$(top_srcdir)/lib \
-	      -L$(DESTDIR)$(libdir) $(DMRAIDLIBS) $(DMEVENTTOOLLIBS) $(DMRAIDLIBS) $(LIBS) 
+	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) -L$(top_builddir)/lib $(DMRAIDLIBS) $(LIBS)
 
-dmevent_tool: $(top_srcdir)/lib/libdmraid.a
-	$(CC) -o $@ $@.c $(INCLUDES) $(LDFLAGS) -L$(top_srcdir)/lib \
-	      -L$(DESTDIR)$(libdir) $(DMRAIDLIBS) $(DMEVENTTOOLLIBS) $(DMRAIDLIBS) $(LIBS) 
+dmevent_tool: $(top_builddir)/lib/libdmraid.a
+	$(CC) -o $@ $@.c $(INCLUDES) $(LDFLAGS) -L$(top_builddir)/lib \
+	  $(DMRAIDLIBS) $(DMEVENTTOOLLIBS) $(LIBS)
 
 install_dmraid_tools: $(TARGETS)
 	@echo "Installing $(TARGETS) in $(DESTDIR)$(sbindir)"; \
-	mkdir -p $(DESTDIR)$(sbindir); \
-	$(INSTALL) $(STRIP) $(TARGETS) $(DESTDIR)$(sbindir)
+	$(INSTALL_DIR) $(DESTDIR)$(sbindir); \
+	$(INSTALL_PROGRAM) $(TARGETS) $(DESTDIR)$(sbindir)
 
 install: install_dmraid_tools
 
