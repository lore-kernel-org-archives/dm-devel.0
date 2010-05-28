From: zkabelac@sourceware.org
Subject: dmraid make.tmpl.in
Date: 28 May 2010 12:31:40 -0000
Message-ID: <20100528123140.15089.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-28 12:31:40

Modified files:
	.              : make.tmpl.in 

Log message:
	Define  AWK and SED vars
	Used  $(SED) for DMRAID_LIB_VERSION

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.8&r2=1.9

--- dmraid/make.tmpl.in	2010/05/28 09:17:24	1.8
+++ dmraid/make.tmpl.in	2010/05/28 12:31:39	1.9
@@ -15,6 +15,9 @@
 MKDIR_P = @MKDIR_P@
 LN_S = @LN_S@
 LIBS = @LIBS@
+AWK = @AWK@
+SED = @SED@
+
 CFLAGS += @CFLAGS@
 CLDFLAGS += @CLDFLAGS@
 LDFLAGS += @LDFLAGS@
@@ -29,6 +32,7 @@
 datarootdir = @datarootdir@
 infodir = @infodir@
 mandir = @mandir@
+usrlibdir = @usrlibdir@
 ifeq ("@KLIBC@", "no")
   libdir = @libdir@
   sbindir = @sbindir@
@@ -41,7 +45,7 @@
 
 # setup misc variables
 DMRAID_VERSION := $(shell cat $(top_srcdir)/tools/VERSION)
-DMRAID_LIB_VERSION := $(shell sed --quiet 's/^.*\(DMRAID_LIB_VERSION\)[^_].*"\(.*\)"/\2/p' $(top_srcdir)/lib/version.h)
+DMRAID_LIB_VERSION := $(shell $(SED) --quiet 's/^.*\(DMRAID_LIB_VERSION\)[^_].*"\(.*\)"/\2/p' $(top_srcdir)/lib/version.h)
 INSTALL_PROGRAM = $(INSTALL) $(STRIP)
 INSTALL_DIR = $(INSTALL) -d
 INSTALL_DATA = $(INSTALL) -m 644 -p
