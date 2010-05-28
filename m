From: zkabelac@sourceware.org
Subject: dmraid ./make.tmpl.in lib/Makefile.in lib/vers ...
Date: 28 May 2010 09:17:26 -0000
Message-ID: <20100528091726.11697.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 09:17:25

Modified files:
	.              : make.tmpl.in 
	lib            : Makefile.in version.h 

Log message:
	Fix DMRAID_LIB_VERSION
	Add common cleandir target for clean and distclean
	Clean SOURCES2 generated files

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.10&r2=1.11
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/version.h.diff?cvsroot=dm&r1=1.10&r2=1.11

--- dmraid/make.tmpl.in	2010/05/27 20:59:45	1.7
+++ dmraid/make.tmpl.in	2010/05/28 09:17:24	1.8
@@ -41,7 +41,7 @@
 
 # setup misc variables
 DMRAID_VERSION := $(shell cat $(top_srcdir)/tools/VERSION)
-DMRAID_LIB_VERSION := $(shell sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[[^_]].*"\(.*\)"/\2/p' $(top_srcdir)/lib/version.h)
+DMRAID_LIB_VERSION := $(shell sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[^_].*"\(.*\)"/\2/p' $(top_srcdir)/lib/version.h)
 INSTALL_PROGRAM = $(INSTALL) $(STRIP)
 INSTALL_DIR = $(INSTALL) -d
 INSTALL_DATA = $(INSTALL) -m 644 -p
@@ -99,7 +99,7 @@
 SUBDIRS.clean := $(SUBDIRS:=.clean)
 SUBDIRS.distclean := $(SUBDIRS:=.distclean)
 
-.PHONY: all install distclean clean
+.PHONY: all install distclean clean cleandir
 .PHONY: $(SUBDIRS) $(SUBDIRS.install) $(SUBDIRS.clean) $(SUBDIRS.distclean)
 .PHONY: $(SUBDIRS.remove)
 
@@ -149,14 +149,15 @@
 	$(AR) r $@ $(OBJECTS)
 	$(RANLIB) $@
 
-clean: $(SUBDIRS.clean)
-	$(RM) $(OBJECTS) $(TARGETS) $(CLEAN_TARGETS) $(SOURCES:%.c=%.d)
-
-distclean: $(SUBDIRS.distclean)
-	$(RM) $(OBJECTS) $(TARGETS) $(CLEAN_TARGETS) $(SOURCES:%.c=%.d) \
-	      cscope.out \
-	      config.cache config.log config.status \
-	      Makefile make.tmpl core tools/version.h
+cleandir:
+	$(RM) $(OBJECTS) $(OBJECTS2) $(TARGETS) $(CLEAN_TARGETS) \
+		$(SOURCES:%.c=%.d) $(SOURCES2:%.c=%.d)
+
+clean: $(SUBDIRS.clean) cleandir
+
+distclean: $(SUBDIRS.distclean) cleandir
+	$(RM) cscope.out config.cache config.log config.status \
+		Makefile make.tmpl core tools/version.h
 
 ifeq (,$(findstring $(MAKECMDGOALS), clean distclean))
     ifdef SOURCES
--- dmraid/lib/Makefile.in	2010/05/28 08:46:04	1.10
+++ dmraid/lib/Makefile.in	2010/05/28 09:17:25	1.11
@@ -88,8 +88,8 @@
 	do \
 		n=$$(basename $${f}) ; \
  		if [[ "$$n" =~ .so$$ ]]; then \
-			$(INSTALL_PROGRAM) $$f $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
-			$(LN_S) -f $${n}.@DMRAID_LIB_VERSION@ $(DESTDIR)$(libdir)/$${n}; \
+			$(INSTALL_PROGRAM) $$f $(DESTDIR)$(libdir)/$${n}.$(DMRAID_LIB_VERSION); \
+			$(LN_S) -f $${n}.$(DMRAID_LIB_VERSION) $(DESTDIR)$(libdir)/$${n}; \
 		else \
 			$(INSTALL_PROGRAM) $$f $(DESTDIR)$(libdir)/$${n}; \
 		fi \
@@ -102,7 +102,7 @@
 	for f in $(INSTALL_TARGETS); \
 	do \
 		n=$$(basename $${f}) ; \
-		$(RM) $(DESTDIR)$(libdir)/$${n}.@DMRAID_LIB_VERSION@; \
+		$(RM) $(DESTDIR)$(libdir)/$${n}.$(DMRAID_LIB_VERSION); \
 		$(RM) $(DESTDIR)$(libdir)/$${n}; \
 	done
 
--- dmraid/lib/version.h	2010/02/17 11:51:53	1.10
+++ dmraid/lib/version.h	2010/05/28 09:17:25	1.11
@@ -1,6 +1,6 @@
 #ifndef	DMRAID_LIB_VERSION
 
-#define	DMRAID_LIB_VERSION		"1"
+#define	DMRAID_LIB_VERSION		"1.0.0"
 
 #define	DMRAID_LIB_MAJOR_VERSION	1
 #define	DMRAID_LIB_MINOR_VERSION	0
