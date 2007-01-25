From: agk@sourceware.org
Subject: device-mapper/lib Makefile.in
Date: 25 Jan 2007 15:45:11 -0000
Message-ID: <20070125154511.2867.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-25 15:45:11

Modified files:
	lib            : Makefile.in 

Log message:
	don't remove libdm-common.h any more

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.31&r2=1.32

--- device-mapper/lib/Makefile.in	2007/01/16 18:03:40	1.31
+++ device-mapper/lib/Makefile.in	2007/01/25 15:45:10	1.32
@@ -90,7 +90,7 @@
 .PHONY: distclean_lib distclean
 
 distclean_lib: 
-	$(RM) libdm-common.h libdevmapper.pc
+	$(RM) libdevmapper.pc
 
 distclean: distclean_lib
 
