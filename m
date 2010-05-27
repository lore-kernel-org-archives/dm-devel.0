From: zkabelac@sourceware.org
Subject: dmraid/tools dmevent_tool.c
Date: 27 May 2010 20:56:36 -0000
Message-ID: <20100527205636.13554.qmail@sourceware.org>
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
Changes by:	zkabelac@sourceware.org	2010-05-27 20:56:36

Modified files:
	tools          : dmevent_tool.c 

Log message:
	Fix compiler warnings

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/dmraid/tools/dmevent_tool.c.diff?cvsroot=dm&r1=1.1&r2=1.2

--- dmraid/tools/dmevent_tool.c	2009/12/16 11:39:18	1.1
+++ dmraid/tools/dmevent_tool.c	2010/05/27 20:56:36	1.2
@@ -123,7 +123,7 @@
 }
 
 /* Increment option counters. */
-static _process_opt(int opt, const char *cmd)
+static void _process_opt(int opt, const char *cmd)
 {
 	struct opt_def_struct {
 		const char opt;		/* Option character. */
@@ -214,7 +214,7 @@
 /* main: Process command line options + arguments. */
 int main(int argc, char **argv)
 {
-	int opt, ret = 0;
+	int ret = 0;
 	char *cmd = basename(argv[0]);
 	enum display_opt display_option;
 
@@ -225,11 +225,12 @@
 		display_option = ALL;
 		if (!optc[OPT_r] && optc[OPT_u])
 			display_option = UNREGISTERED;
-		else if (optc[OPT_r] && !optc[OPT_u])
+		else if (optc[OPT_r] && !optc[OPT_u]) {
 			if (optc[OPT_a])
 				display_option = REGISTERED_WITH_UUID;
 			else if (optc[OPT_m])
 				display_option = REGISTERED_NO_UUID;
+		}
 		dm_all_monitored(display_option);
 	}
 	else if (optc[OPT_r])
