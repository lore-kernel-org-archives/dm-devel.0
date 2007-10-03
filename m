From: meyering@sourceware.org
Subject: device-mapper lib/Makefile.in ./make.tmpl.in
Date: 3 Oct 2007 10:48:28 -0000
Message-ID: <20071003104828.12092.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-10-03 10:48:27

Modified files:
	lib            : Makefile.in 
	.              : make.tmpl.in 

Log message:
	Arrange for "make clean" to remove the symlink, too.
	
	* make.tmpl.in ($(VERSIONED_SHLIB)): Move rule to...
	* lib/Makefile.in ($(VERSIONED_SHLIB)): ...here, removing the
	$(interface)/ prefix.
	Reported by Milan Broz.
	
	Author: Jim Meyering <meyering@redhat.com>

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.36&r2=1.37
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/make.tmpl.in.diff?cvsroot=dm&r1=1.35&r2=1.36

--- device-mapper/lib/Makefile.in	2007/09/18 13:02:58	1.36
+++ device-mapper/lib/Makefile.in	2007/10/03 10:48:27	1.37
@@ -41,7 +41,7 @@
 else
   LIB_SHARED = $(interface)/libdevmapper.so
 endif
-VERSIONED_SHLIB = $(interface)/libdevmapper.$(LIB_SUFFIX).$(LIB_VERSION)
+VERSIONED_SHLIB = libdevmapper.$(LIB_SUFFIX).$(LIB_VERSION)
 
 DEFS += -DDEVICE_UID=@DEVICE_UID@ -DDEVICE_GID=@DEVICE_GID@ \
 	-DDEVICE_MODE=@DEVICE_MODE@
@@ -87,10 +87,13 @@
 	$(INSTALL) -D $(OWNER) $(GROUP) -m 555 $(STRIP) $< \
 		$(libdir)/libdevmapper.a.$(LIB_VERSION)
 
+$(VERSIONED_SHLIB): %.$(LIB_SUFFIX).$(LIB_VERSION): $(interface)/%.$(LIB_SUFFIX)
+	rm -f $@
+	$(LN_S) $< $@
+
 .PHONY: distclean_lib distclean
 
-distclean_lib: 
+distclean_lib:
 	$(RM) libdevmapper.pc
 
 distclean: distclean_lib
-
--- device-mapper/make.tmpl.in	2007/10/03 09:00:45	1.35
+++ device-mapper/make.tmpl.in	2007/10/03 10:48:27	1.36
@@ -172,10 +172,6 @@
 	$(CFLAGS) $(CLDFLAGS) $(OBJECTS) $(LIBS) -o $@
 endif
 
-$(VERSIONED_SHLIB): %.$(LIB_SUFFIX).$(LIB_VERSION): %.$(LIB_SUFFIX)
-	rm -f $(notdir $@)
-	$(LN_S) $< $(notdir $@)
-
 $(LIB_STATIC): $(OBJECTS)
 	$(RM) $@
 	$(AR) rs $@ $(OBJECTS)
