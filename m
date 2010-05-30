From: zkabelac@sourceware.org
Subject: dmraid make.tmpl.in
Date: 30 May 2010 22:13:57 -0000
Message-ID: <20100530221357.20407.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 22:13:56

Modified files:
	.              : make.tmpl.in 

Log message:
	Add support for DEVMAPPEREVENT_CFLAGS
	Use vpath for .c files

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.12&r2=1.13

--- dmraid/make.tmpl.in	2010/05/30 19:15:26	1.12
+++ dmraid/make.tmpl.in	2010/05/30 22:13:56	1.13
@@ -17,6 +17,7 @@
 LIBS = @LIBS@
 AWK = @AWK@
 SED = @SED@
+DEVMAPPEREVENT_CFLAGS = @DEVMAPPEREVENT_CFLAGS@
 DEVMAPPEREVENT_LIBS = @DEVMAPPEREVENT_LIBS@
 DMRAID_LIB_DATE = @DMRAID_LIB_DATE@
 DMRAID_LIB_MAJOR = @DMRAID_LIB_MAJOR@
@@ -49,6 +50,8 @@
   includedir = @KLIBC_INCLUDE_DIR@
 endif
 
+vpath %.c $(srcdir)
+
 # setup misc variables
 INSTALL_PROGRAM = $(INSTALL) $(STRIP)
 INSTALL_DIR = $(INSTALL) -d
