From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 29 Jan 2007 18:45:08 -0000
Message-ID: <20070129184508.4957.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-29 18:45:08

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	help on help

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.84&r2=1.85

--- device-mapper/dmsetup/dmsetup.c	2007/01/29 18:43:27	1.84
+++ device-mapper/dmsetup/dmsetup.c	2007/01/29 18:45:08	1.85
@@ -1679,7 +1679,7 @@
  * Dispatch table
  */
 static struct command _commands[] = {
-	{"help", "\n", 0, 0, _help},
+	{"help", "[-c|-C|--columns]", 0, 0, _help},
 	{"create", "<dev_name> [-j|--major <major> -m|--minor <minor>]\n"
 	  "\t                  [-U|--uid <uid>] [-G|--gid <gid>] [-M|--mode <octal_mode>]\n"
 	  "\t                  [-u|uuid <uuid>]\n"
@@ -1714,7 +1714,7 @@
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
 		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
-		"        [-c|--columns] [-o <fields>] [-O|--sort <sort_fields>]\n"
+		"        [-c|-C|--columns] [-o <fields>] [-O|--sort <sort_fields>]\n"
 		"        [--noheadings] [--separator <separator>]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
