From: heinzm@sourceware.org
Subject: dmraid/tools Makefile.in
Date: 19 Mar 2010 11:29:26 -0000
Message-ID: <20100319112926.31937.qmail@sourceware.org>
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
Changes by:	heinzm@sourceware.org	2010-03-19 11:29:26

Modified files:
	tools          : Makefile.in 

Log message:
	Fix pthread link dependency

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/Makefile.in.diff?cvsroot=dm&r1=1.6&r2=1.7

--- dmraid/tools/Makefile.in	2010/03/16 16:02:16	1.6
+++ dmraid/tools/Makefile.in	2010/03/19 11:29:25	1.7
@@ -28,7 +28,7 @@
 	endif
 endif
 
-DMRAIDLIBS=-ldmraid
+DMRAIDLIBS=-ldmraid -lpthread
 
 ifeq ("@KLIBC@", "yes")
 	DMRAIDLIBS += -ldevmapper_klibc
