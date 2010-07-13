From: zkabelac@sourceware.org
Subject: dmraid/tools commands.c
Date: 13 Jul 2010 20:14:41 -0000
Message-ID: <20100713201441.22021.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:14:41

Modified files:
	tools          : commands.c 

Log message:
	Use static for save_drive_name()

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/commands.c.diff?cvsroot=dm&r1=1.10&r2=1.11

--- dmraid/tools/commands.c	2010/05/30 22:12:43	1.10
+++ dmraid/tools/commands.c	2010/07/13 20:14:41	1.11
@@ -639,7 +639,7 @@
 }
 
 /* Save name of rebuild disk. */
-int
+static int
 save_drive_name(struct lib_context *lc, char *drive)
 {
 	lc->options[LC_REBUILD_DISK].opt++;
