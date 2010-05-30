From: zkabelac@sourceware.org
Subject: dmraid/lib Makefile.in
Date: 30 May 2010 22:21:32 -0000
Message-ID: <20100530222132.21903.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 22:21:31

Modified files:
	lib            : Makefile.in 

Log message:
	Remove VPATH
	Create complete TARGETS before include of make.tmpl
	Move LIB_SHARED and LIB_EVENTS_SHARED outside of 'if' block
	Add support for DEVMAPPEREVENT_CFLAGS
	Create  soname.major  link as well in libdir

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.15&r2=1.16

--- dmraid/lib/Makefile.in	2010/05/30 19:15:26	1.15
+++ dmraid/lib/Makefile.in	2010/05/30 22:21:31	1.16
@@ -7,7 +7,6 @@
 srcdir = @srcdir@
 top_srcdir = @top_srcdir@
 top_builddir = @top_builddir@
-VPATH = @srcdir@
 
 SOURCES  = \
 	activate/activate.c \
@@ -56,22 +55,22 @@
 
 LIB_STATIC = libdmraid.a
 LIB_EVENTS_NAME = libdmraid-events-isw
+LIB_SHARED = libdmraid.so
+LIB_EVENTS_SHARED=$(LIB_EVENTS_NAME).so
 USRLIB_RELPATH = $(shell echo $(abspath $(usrlibdir) $(libdir)) | \
   $(AWK) -f $(top_srcdir)/tools/relpath.awk)
 
 TARGETS = $(LIB_STATIC)
 
-include $(top_builddir)/make.tmpl
-
 ifeq ("@KLIBC@", "no")
 	ifeq ("@STATIC_LINK@", "no")
-		LIB_SHARED = libdmraid.so
-		LIB_EVENTS_SHARED=$(LIB_EVENTS_NAME).so
 		TARGETS += $(LIB_SHARED) $(LIB_EVENTS_SHARED)
 	endif
 endif
 
-all: $(TARGETS)
+include $(top_builddir)/make.tmpl
+
+INCLUDES += $(DEVMAPPEREVENT_CFLAGS)
 
 DMRAID_LIB_VERSION = $(DMRAID_LIB_MAJOR).$(DMRAID_LIB_MINOR).$(DMRAID_LIB_SUBMINOR)
 $(LIB_SHARED): $(OBJECTS) $(LD_DEPS)
@@ -95,11 +94,13 @@
 install_$(LIB_SHARED): $(LIB_SHARED)
 	$(INSTALL_PROGRAM) -D $< $(DESTDIR)$(libdir)/$(<F).$(DMRAID_LIB_VERSION)
 	$(INSTALL_DIR) $(DESTDIR)$(usrlibdir)
+	$(LN_S) -f $(<F).$(DMRAID_LIB_VERSION) $(DESTDIR)$(libdir)/$(<F).$(DMRAID_LIB_MAJOR)
 	$(LN_S) -f $(USRLIB_RELPATH)$(<F).$(DMRAID_LIB_VERSION) $(DESTDIR)$(usrlibdir)/$(<F)
 
 remove_$(LIB_SHARED):
-	$(RM) $(DESTDIR)$(libdir)/$(notdir $(LIB_SHARED)).$(DMRAID_LIB_VERSION)
 	$(RM) $(DESTDIR)$(usrlibdir)/$(notdir $(LIB_SHARED))
+	$(RM) $(DESTDIR)$(libdir)/$(notdir $(LIB_SHARED)).$(DMRAID_LIB_MAJOR)
+	$(RM) $(DESTDIR)$(libdir)/$(notdir $(LIB_SHARED)).$(DMRAID_LIB_VERSION)
 
 install_$(LIB_STATIC): $(LIB_STATIC)
 	$(INSTALL_DATA) -D $< $(DESTDIR)$(usrlibdir)/$(LIB_STATIC)
