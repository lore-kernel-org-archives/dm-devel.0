From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 12 Oct 2006 17:09:10 -0000
Message-ID: <20061012170910.27735.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-12 17:09:10

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	fix dmsetup usage display (missing \n and --noflush wrong place)

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.72&r2=1.73

--- device-mapper/dmsetup/dmsetup.c	2006/10/12 15:42:24	1.72
+++ device-mapper/dmsetup/dmsetup.c	2006/10/12 17:09:09	1.73
@@ -1506,12 +1506,12 @@
 static struct command _commands[] = {
 	{"create", "<dev_name> [-j|--major <major> -m|--minor <minor>]\n"
 	  "\t                  [-U|--uid <uid>] [-G|--gid <gid>] [-M|--mode <octal_mode>]\n"
-	  "\t                  [-u|uuid <uuid>]"
+	  "\t                  [-u|uuid <uuid>]\n"
 	  "\t                  [--notable | --table <table> | <table_file>]",
 	 1, 2, _create},
 	{"remove", "[-f|--force] <device>", 0, 1, _remove},
 	{"remove_all", "[-f|--force]", 0, 0, _remove_all},
-	{"suspend", "<device>", 0, 1, _suspend},
+	{"suspend", "[--noflush] <device>", 0, 1, _suspend},
 	{"resume", "<device>", 0, 1, _resume},
 	{"load", "<device> [<table_file>]", 0, 2, _load},
 	{"clear", "<device>", 0, 1, _clear},
@@ -1537,8 +1537,7 @@
 
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
-		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
-		"        [--noflush]\n\n");
+		"        [-r|--readonly] [--noopencount] [--nolockfs]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
