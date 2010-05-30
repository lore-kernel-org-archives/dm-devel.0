From: zkabelac@sourceware.org
Subject: dmraid/tools commands.c
Date: 30 May 2010 22:12:43 -0000
Message-ID: <20100530221243.20195.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-30 22:12:43

Modified files:
	tools          : commands.c 

Log message:
	Check for possible _GNU_SOURCE already defined

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.9&r2=1.10

--- dmraid/tools/commands.c	2010/03/19 13:56:49	1.9
+++ dmraid/tools/commands.c	2010/05/30 22:12:43	1.10
@@ -9,7 +9,9 @@
  */
 
 #ifdef HAVE_GETOPTLONG
+#ifndef _GNU_SOURCE
 # define _GNU_SOURCE
+#endif
 # include <getopt.h>
 #endif
 
