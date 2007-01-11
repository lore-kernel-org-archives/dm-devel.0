From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW ./make.tmpl.in dmeve ...
Date: 11 Jan 2007 16:23:23 -0000
Message-ID: <20070111162323.13495.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-11 16:23:22

Modified files:
	.              : WHATS_NEW make.tmpl.in 
	dmeventd       : Makefile.in 
	dmsetup        : Makefile.in 
	lib            : Makefile.in 

Log message:
	Use CFLAGS when linking so mixed sparc builds can supply -m64.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.140&r2=1.141
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/make.tmpl.in.diff?cvsroot=dm&r1=1.30&r2=1.31
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/Makefile.in.diff?cvsroot=dm&r1=1.17&r2=1.18
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/Makefile.in.diff?cvsroot=dm&r1=1.15&r2=1.16
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.29&r2=1.30

--- device-mapper/WHATS_NEW	2007/01/09 19:44:07	1.140
+++ device-mapper/WHATS_NEW	2007/01/11 16:23:21	1.141
@@ -1,5 +1,6 @@
 Version 1.02.14 - 
 =============================
+  Use CFLAGS when linking so mixed sparc builds can supply -m64.
   Add dm_tree_use_no_flush_suspend().
   Lots of dmevent changes.
   Export dm_basename().
--- device-mapper/make.tmpl.in	2006/05/10 19:38:25	1.30
+++ device-mapper/make.tmpl.in	2007/01/11 16:23:21	1.31
@@ -163,13 +163,13 @@
 ifeq ("@LIB_SUFFIX@","so")
 $(LIB_SHARED): $(OBJECTS) $(LDDEPS)
 	$(CC) -shared -Wl,-soname,$(notdir $@).$(LIB_VERSION) \
-	$(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
+	$(CFLAGS) $(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
 endif
 
 ifeq ("@LIB_SUFFIX@","dylib")
 $(LIB_SHARED): $(OBJECTS) $(LDDEPS)
 	$(CC) -dynamiclib -dylib_current_version,$(LIB_VERSION) \
-	$(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
+	$(CFLAGS) $(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
 endif
 
 $(LIB_STATIC): $(OBJECTS)
--- device-mapper/dmeventd/Makefile.in	2007/01/08 15:18:52	1.17
+++ device-mapper/dmeventd/Makefile.in	2007/01/11 16:23:22	1.18
@@ -34,7 +34,7 @@
 CLDFLAGS += -ldl -ldevmapper -lpthread
 
 dmeventd: $(LIB_SHARED) dmeventd.o
-	$(CC) -o $@ dmeventd.o $(LDFLAGS) \
+	$(CC) -o $@ dmeventd.o $(CFLAGS) $(LDFLAGS) \
 	-L. -ldevmapper-event $(LIBS) -rdynamic
 
 .PHONY: install_dynamic install_static install_include \
--- device-mapper/dmsetup/Makefile.in	2005/01/27 16:16:52	1.15
+++ device-mapper/dmsetup/Makefile.in	2007/01/11 16:23:22	1.16
@@ -30,11 +30,11 @@
 include ../make.tmpl
 
 dmsetup: $(OBJECTS) $(interfacedir)/libdevmapper.$(LIB_SUFFIX)
-	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) \
+	$(CC) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS) \
 	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS)
 
 dmsetup.static: $(OBJECTS) $(interfacedir)/libdevmapper.a
-	$(CC) -o $@ $(OBJECTS) $(LDFLAGS) -static \
+	$(CC) -o $@ $(OBJECTS) $(CFLAGS) $(LDFLAGS) -static \
 	      -L$(interfacedir) -L$(DESTDIR)/lib -ldevmapper $(LIBS)
 
 install: $(INSTALL_TYPE)
--- device-mapper/lib/Makefile.in	2006/08/21 12:04:49	1.29
+++ device-mapper/lib/Makefile.in	2007/01/11 16:23:22	1.30
@@ -38,8 +38,8 @@
   LIB_SHARED = $(interface)/libdevmapper.so
 endif
 
-CFLAGS += -DDEVICE_UID=@DEVICE_UID@ -DDEVICE_GID=@DEVICE_GID@ \
-	  -DDEVICE_MODE=@DEVICE_MODE@
+DEFS += -DDEVICE_UID=@DEVICE_UID@ -DDEVICE_GID=@DEVICE_GID@ \
+	-DDEVICE_MODE=@DEVICE_MODE@
 
 include ../make.tmpl
 
