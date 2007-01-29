From: agk@sourceware.org
Subject: device-mapper/dmsetup dmsetup.c
Date: 29 Jan 2007 18:37:59 -0000
Message-ID: <20070129183759.32512.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-29 18:37:58

Modified files:
	dmsetup        : dmsetup.c 

Log message:
	add help -c for field list

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.82&r2=1.83

--- device-mapper/dmsetup/dmsetup.c	2007/01/29 18:18:41	1.82
+++ device-mapper/dmsetup/dmsetup.c	2007/01/29 18:37:57	1.83
@@ -1625,7 +1625,7 @@
 	if (_switches[SORT_ARG] && _string_args[SORT_ARG]) {
 		keys = _string_args[SORT_ARG];
 		buffered = 1;
-		if (!strcmp(c->name, "status") || !strcmp(c->name, "table")) {
+		if (c && (!strcmp(c->name, "status") || !strcmp(c->name, "table"))) {
 			err("--sort is not yet supported with status and table");
 			goto out;
 		}
@@ -1714,12 +1714,13 @@
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
 		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
-		"        [-c|--columns] [-o <fields>] [--noheadings] [--separator <separator>]\n\n");
+		"        [-c|--columns] [-o <fields>] [-O|--sort <sort_fields>]\n"
+		"        [--noheadings] [--separator <separator>]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
 		     "-j <major> -m <minor>\n");
-	fprintf(out, "<fields> are comma-separated.  Use -c -o help for list.\n");
+	fprintf(out, "<fields> are comma-separated.  Use 'help -c' for list.\n");
 	fprintf(out, "Table_file contents may be supplied on stdin.\n");
 	fprintf(out, "Tree options are: ascii, utf, vt100; compact, inverted, notrunc;\n"
 		     "                  [no]device, active, open, rw and uuid.\n");
@@ -1738,6 +1739,14 @@
 {
 	_usage(stderr);
 
+	if (_switches[COLS_ARG]) {
+		_switches[OPTIONS_ARG] = 1;
+		_string_args[OPTIONS_ARG] = (char *) "help";
+		_switches[SORT_ARG] = 0;
+	
+		(void) _report_init(NULL);
+	}
+
 	return 1;
 }
 
