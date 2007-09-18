From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW ./make.tmpl.in lib/M ...
Date: 18 Sep 2007 13:02:59 -0000
Message-ID: <20070918130259.24859.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-09-18 13:02:58

Modified files:
	.              : WHATS_NEW make.tmpl.in 
	lib            : Makefile.in 

Log message:
	Create a symlink, e.g., libdevmapper.so.1.02, in the build dir,
	alongside the .so file.  This helps build dynamically linked LVM.
	
	* lib/Makefile.in (VERSIONED_SHLIB): Define.
	* make.tmpl.in (TARGETS): Append $(VERSIONED_SHLIB).
	($(VERSIONED_SHLIB)): New rule.
	
	Author: Jim Meyering <jim@meyering.net>

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.204&r2=1.205
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/make.tmpl.in.diff?cvsroot=dm&r1=1.31&r2=1.32
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.35&r2=1.36

--- device-mapper/WHATS_NEW	2007/08/21 20:32:29	1.204
+++ device-mapper/WHATS_NEW	2007/09/18 13:02:58	1.205
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Create e.g., libdevmapper.so.1.02, in build dir alongside the .so file.
   Avoid static link failure with some SELinux libraries.
   Remove obsolete dmfs code from tree and update INSTALL.
 
--- device-mapper/make.tmpl.in	2007/01/11 16:23:21	1.31
+++ device-mapper/make.tmpl.in	2007/09/18 13:02:58	1.32
@@ -1,7 +1,7 @@
 # @configure_input@
 #
 # Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
-# Copyright (C) 2004 Red Hat, Inc. All rights reserved.
+# Copyright (C) 2004, 2007 Red Hat, Inc. All rights reserved.
 #
 # This file is part of the device-mapper userspace tools.
 #
@@ -123,7 +123,7 @@
 .PHONY: $(SUBDIRS) $(SUBDIRS.install) $(SUBDIRS.clean) $(SUBDIRS.distclean)
 .PHONY: $(SUBDIRS.pofile)
 
-TARGETS += $(LIB_SHARED) $(LIB_STATIC)
+TARGETS += $(LIB_SHARED) $(LIB_STATIC) $(VERSIONED_SHLIB)
 
 all: $(SUBDIRS) $(TARGETS)
 
@@ -172,6 +172,10 @@
 	$(CFLAGS) $(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
 endif
 
+$(VERSIONED_SHLIB): %.$(LIB_SUFFIX).$(LIB_VERSION): %.$(LIB_SUFFIX)
+	rm -f $@
+	$(LN_S) $< $@
+
 $(LIB_STATIC): $(OBJECTS)
 	$(RM) $@
 	$(AR) rs $@ $(OBJECTS)
--- device-mapper/lib/Makefile.in	2007/08/21 18:41:58	1.35
+++ device-mapper/lib/Makefile.in	2007/09/18 13:02:58	1.36
@@ -41,6 +41,7 @@
 else
   LIB_SHARED = $(interface)/libdevmapper.so
 endif
+VERSIONED_SHLIB = $(interface)/libdevmapper.$(LIB_SUFFIX).$(LIB_VERSION)
 
 DEFS += -DDEVICE_UID=@DEVICE_UID@ -DDEVICE_GID=@DEVICE_GID@ \
 	-DDEVICE_MODE=@DEVICE_MODE@
