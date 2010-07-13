From: zkabelac@sourceware.org
Subject: dmraid/tools dmevent_tool.c
Date: 13 Jul 2010 20:15:35 -0000
Message-ID: <20100713201535.22558.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-07-13 20:15:35

Modified files:
	tools          : dmevent_tool.c 

Log message:
	Use static for _test_user_id()

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/dmevent_tool.c.diff?cvsroot=dm&r1=1.2&r2=1.3

--- dmraid/tools/dmevent_tool.c	2010/05/27 20:56:36	1.2
+++ dmraid/tools/dmevent_tool.c	2010/07/13 20:15:31	1.3
@@ -114,7 +114,7 @@
 		"\n" , cmd, options, cmd, cmd, cmd, cmd, cmd, cmd, cmd);
 }
 
-void _test_user_id(void)
+static void _test_user_id(void)
 {
 	if (geteuid()) {
 		fprintf(stderr, "This utility needs to be run as root.\n");
