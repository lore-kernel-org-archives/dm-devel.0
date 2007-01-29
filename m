From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW dmsetup/dmsetup.c
Date: 29 Jan 2007 18:18:41 -0000
Message-ID: <20070129181841.19282.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-01-29 18:18:41

Modified files:
	.              : WHATS_NEW 
	dmsetup        : dmsetup.c 

Log message:
	Add dmsetup 'help' command and update usage text.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.164&r2=1.165
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.81&r2=1.82

--- device-mapper/WHATS_NEW	2007/01/29 17:45:32	1.164
+++ device-mapper/WHATS_NEW	2007/01/29 18:18:40	1.165
@@ -1,5 +1,6 @@
 Version 1.02.17 -
 ===================================
+  Add dmsetup 'help' command and update usage text.
   Use fixed-size fields in report interface and reorder.
 
 Version 1.02.16 - 25th January 2007
--- device-mapper/dmsetup/dmsetup.c	2007/01/29 17:45:32	1.81
+++ device-mapper/dmsetup/dmsetup.c	2007/01/29 18:18:41	1.82
@@ -1567,10 +1567,10 @@
 static const struct dm_report_field_type _report_fields[] = {
 /* *INDENT-OFF* */
 FIELD_F(TASK, STR, "Name", 16, dm_name, "name", "Name of mapped device.")
-FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique identifier for mapped device (optional).")
-FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "status", "Attributes.")
-FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Major number.")
-FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor", "Minor number.")
+FIELD_F(TASK, STR, "UUID", 32, dm_uuid, "uuid", "Unique (optional) identifier for mapped device.")
+FIELD_F(INFO, STR, "Stat", 4, dm_info_status, "status", "(L)ive, (I)nactive, (s)uspended, (r)ead-only, read-(w)rite.")
+FIELD_O(INFO, dm_info, NUM, "Maj", major, 3, int32, "major", "Block device major number.")
+FIELD_O(INFO, dm_info, NUM, "Min", minor, 3, int32, "minor", "Block device minor number.")
 FIELD_O(INFO, dm_info, NUM, "Open", open_count, 4, int32, "open_count", "Number of references to open device, if requested.")
 FIELD_O(INFO, dm_info, NUM, "Targ", target_count, 4, int32, "target_count", "Number of segments in live table, if present.")
 FIELD_O(INFO, dm_info, NUM, "Event", event_nr, 6, uint32, "event_nr", "Current event number.")
@@ -1673,10 +1673,13 @@
 		return _process_all(argc, argv, 0, _display_name);
 }
 
+static int _help(int argc, char **argv, void *data);
+
 /*
  * Dispatch table
  */
 static struct command _commands[] = {
+	{"help", "\n", 0, 0, _help},
 	{"create", "<dev_name> [-j|--major <major> -m|--minor <minor>]\n"
 	  "\t                  [-U|--uid <uid>] [-G|--gid <gid>] [-M|--mode <octal_mode>]\n"
 	  "\t                  [-u|uuid <uuid>]\n"
@@ -1710,14 +1713,17 @@
 
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
-		"        [-r|--readonly] [--noopencount] [--nolockfs]\n\n");
+		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
+		"        [-c|--columns] [-o <fields>] [--noheadings] [--separator <separator>]\n\n");
 	for (i = 0; _commands[i].name; i++)
 		fprintf(out, "\t%s %s\n", _commands[i].name, _commands[i].help);
 	fprintf(out, "\n<device> may be device name or -u <uuid> or "
 		     "-j <major> -m <minor>\n");
+	fprintf(out, "<fields> are comma-separated.  Use -c -o help for list.\n");
 	fprintf(out, "Table_file contents may be supplied on stdin.\n");
 	fprintf(out, "Tree options are: ascii, utf, vt100; compact, inverted, notrunc;\n"
-		     "                  [no]device, active, open, rw and uuid.\n\n");
+		     "                  [no]device, active, open, rw and uuid.\n");
+	fprintf(out, "\n");
 	return;
 }
 
@@ -1728,6 +1734,13 @@
 		     "[-o offset] [-f|loop_device] [file]\n\n");
 }
 
+static int _help(int argc, char **argv, void *data)
+{
+	_usage(stderr);
+
+	return 1;
+}
+
 static struct command *_find_command(const char *name)
 {
 	int i;
@@ -2096,7 +2109,7 @@
 		return 1;
 	}
 
-	if(!strcmp(base, "losetup") || !strcmp(base, "dmlosetup")){
+	if (!strcmp(base, "losetup") || !strcmp(base, "dmlosetup")){
 		r = _process_losetup_switches(base, argc, argv);
 		free(namebase);
 		return r;
