From: zkabelac@sourceware.org
Subject: device-mapper dmeventd/Makefile.in ./WHATS_NEW
Date: 27 Jun 2008 15:36:51 -0000
Message-ID: <20080627153651.15060.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2008-06-27 15:36:51

Modified files:
	dmeventd       : Makefile.in 
	.              : WHATS_NEW 

Log message:
	Added generation of the versioned libdevmapper-event.so for LVM's test

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/Makefile.in.diff?cvsroot=dm&r1=1.19&r2=1.20
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.248&r2=1.249

--- device-mapper/dmeventd/Makefile.in	2007/08/21 16:26:06	1.19
+++ device-mapper/dmeventd/Makefile.in	2008/06/27 15:36:51	1.20
@@ -23,6 +23,7 @@
   LIB_SHARED = libdevmapper-event.dylib
 else
   LIB_SHARED = libdevmapper-event.so
+  VERSIONED_SHLIB = $(LIB_SHARED).$(LIB_VERSION)
 endif
 
 TARGETS = dmeventd
@@ -33,7 +34,7 @@
 LDFLAGS += -ldl -ldevmapper -lpthread
 CLDFLAGS += -ldl -ldevmapper -lpthread
 
-dmeventd: $(LIB_SHARED) dmeventd.o
+dmeventd: $(LIB_SHARED) $(VERSIONED_SHLIB) dmeventd.o
 	$(CC) -o $@ dmeventd.o $(CFLAGS) $(LDFLAGS) \
 	-L. -ldevmapper-event $(LIBS) -rdynamic
 
@@ -74,6 +75,10 @@
 		$(libdir)/libdevmapper-event.a.$(LIB_VERSION)
 	$(LN_S) -f libdevmapper-event.a.$(LIB_VERSION) $(libdir)/libdevmapper-event.a
 
+$(VERSIONED_SHLIB): $(LIB_SHARED)
+	$(RM) -f $@
+	$(LN_S) $(LIB_SHARED) $@
+
 .PHONY: distclean_lib distclean
 
 distclean_lib: 
--- device-mapper/WHATS_NEW	2008/06/25 19:52:51	1.248
+++ device-mapper/WHATS_NEW	2008/06/27 15:36:51	1.249
@@ -1,5 +1,6 @@
 Version 1.02.28 - 
 ================================
+  Added generation of the versioned libdevmapper-event.so for LVM's test
   Underline longer report help text headings.
 
 Version 1.02.27 - 25th June 2008
