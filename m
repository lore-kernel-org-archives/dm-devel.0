From: heinzm@sourceware.org
Subject: dmraid/lib Makefile.in
Date: 16 Sep 2009 11:51:33 -0000
Message-ID: <20090916115133.17515.qmail@sourceware.org>
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
Module name:	dmraid
Changes by:	heinzm@sourceware.org	2009-09-16 11:51:32

Modified files:
	lib            : Makefile.in 

Log message:
	Avoid building dmreg.o

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/lib/Makefile.in.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/lib/Makefile.in	2009/09/16 11:45:12	1.3
+++ dmraid/lib/Makefile.in	2009/09/16 11:51:32	1.4
@@ -8,7 +8,7 @@
 top_srcdir = @top_srcdir@
 VPATH = @srcdir@
 
-SOURCES=\
+SOURCES  = \
 	activate/activate.c \
 	activate/devmapper.c \
 	device/ata.c \
@@ -45,7 +45,7 @@
 	format/ddf/ddf1_dump.c \
 	format/partition/dos.c
 
-ifeq ( "@STATIC_LINK", "no")
+ifeq ("@STATIC_LINK@", "no")
 	SOURCES += register/dmreg.c
 endif
 
