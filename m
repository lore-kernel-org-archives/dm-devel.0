From: zkabelac@sourceware.org
Subject: dmraid ./Makefile.in ./make.tmpl.in include/Ma ...
Date: 13 Jul 2010 19:09:12 -0000
Message-ID: <20100713190912.11375.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 19:09:06

Modified files:
	.              : Makefile.in make.tmpl.in 
	include        : Makefile.in 
	lib            : Makefile.in 

Log message:
	Add missing distclean targets

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/Makefile.in.diff?cvsroot=dm&r1=1.2&r2=1.3
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.14&r2=1.15
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/include/Makefile.in.diff?cvsroot=dm&r1=1.4&r2=1.5
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.17&r2=1.18

--- dmraid/Makefile.in	2010/05/30 17:36:18	1.2
+++ dmraid/Makefile.in	2010/07/13 19:09:04	1.3
@@ -9,7 +9,8 @@
 
 SUBDIRS = include lib man tools
 
-DISTCLEAN_TARGETS = make.tmpl core cscope.out config.cache config.log config.status
+DISTCLEAN_TARGETS = autom4te.cache make.tmpl core cscope.out \
+ config.cache config.log config.status
 
 all: tools
 
--- dmraid/make.tmpl.in	2010/05/31 09:24:42	1.14
+++ dmraid/make.tmpl.in	2010/07/13 19:09:04	1.15
@@ -156,7 +156,7 @@
 clean: $(SUBDIRS.clean) cleandir
 
 distclean: $(SUBDIRS.distclean) cleandir
-	$(RM) $(DISTCLEAN_TARGETS)
+	$(RM) -r $(DISTCLEAN_TARGETS)
 
 ifeq (,$(findstring $(MAKECMDGOALS), clean distclean))
     ifdef SOURCES
--- dmraid/include/Makefile.in	2010/05/28 08:44:58	1.4
+++ dmraid/include/Makefile.in	2010/07/13 19:09:05	1.5
@@ -9,6 +9,7 @@
 top_builddir = @top_builddir@
 
 HEADERS=$(wildcard $(top_srcdir)/include/dmraid/*.h)
+DISTCLEAN_TARGETS += config.h
 
 all:
 
--- dmraid/lib/Makefile.in	2010/05/31 09:24:42	1.17
+++ dmraid/lib/Makefile.in	2010/07/13 19:09:06	1.18
@@ -51,6 +51,7 @@
 endif
 
 SOURCES2 = events/$(LIB_EVENTS_NAME).c
+DISTCLEAN_TARGETS += version.h
 
 LIB_STATIC = libdmraid.a
 LIB_EVENTS_NAME = libdmraid-events-isw
