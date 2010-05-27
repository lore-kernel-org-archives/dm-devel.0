From: zkabelac@sourceware.org
Subject: dmraid make.tmpl.in
Date: 27 May 2010 13:27:33 -0000
Message-ID: <20100527132733.7729.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-27 13:27:31

Modified files:
	.              : make.tmpl.in 

Log message:
	Define datarootdir
	Move infodir and mandir as common part in front of KLIBC 'if'

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/make.tmpl.in.diff?cvsroot=dm&r1=1.3&r2=1.4

--- dmraid/make.tmpl.in	2010/03/16 16:02:16	1.3
+++ dmraid/make.tmpl.in	2010/05/27 13:27:29	1.4
@@ -25,21 +25,19 @@
 exec_prefix = @exec_prefix@
 bindir = @bindir@
 datadir = @datarootdir@
+datarootdir = @datarootdir@
+infodir = @infodir@
+mandir = @mandir@
 ifeq ("@KLIBC@", "no")
   libdir = @libdir@
   sbindir = @sbindir@
   includedir = @includedir@
-  infodir = @infodir@
-  mandir = @mandir@
 else
   libdir = @KLIBC_LIB_DIR@
   sbindir = @KLIBC_SBIN_DIR@
   includedir = @KLIBC_INCLUDE_DIR@
-  infodir = @infodir@
-  mandir = @mandir@
 endif
 
-
 # setup misc variables
 # define the ownership variables for the binaries and man pages
 OWNER = @OWNER@
