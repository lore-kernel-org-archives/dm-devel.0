From: agk@sourceware.org
Subject: device-mapper dmsetup/dmsetup.c man/dmsetup.8
Date: 29 Nov 2007 14:44:29 -0000
Message-ID: <20071129144429.5726.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-11-29 14:44:28

Modified files:
	dmsetup        : dmsetup.c 
	man            : dmsetup.8 

Log message:
	refine specification of dmsetup readahead

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.97&r2=1.98
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/man/dmsetup.8.diff?cvsroot=dm&r1=1.19&r2=1.20

--- device-mapper/dmsetup/dmsetup.c	2007/11/27 20:57:05	1.97
+++ device-mapper/dmsetup/dmsetup.c	2007/11/29 14:44:28	1.98
@@ -150,6 +150,7 @@
 static char *_table;
 static char *_target;
 static char *_command;
+static uint32_t _read_ahead_flags;
 static struct dm_tree *_dtree;
 static struct dm_report *_report;
 static report_type_t _report_type;
@@ -497,9 +498,9 @@
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
 
-	/* FIXME Provide way to set read_ahead_flags */
 	if (_switches[READAHEAD_ARG] &&
-	    !dm_task_set_read_ahead(dmt, _int_args[READAHEAD_ARG], 0))
+	    !dm_task_set_read_ahead(dmt, _int_args[READAHEAD_ARG],
+				    _read_ahead_flags))
 		goto out;
 
 	if (!dm_task_run(dmt))
@@ -681,9 +682,9 @@
 	if (_switches[NOLOCKFS_ARG] && !dm_task_skip_lockfs(dmt))
 		goto out;
 
-	/* FIXME Provide way to set read_ahead_flags */
 	if (_switches[READAHEAD_ARG] &&
-	    !dm_task_set_read_ahead(dmt, _int_args[READAHEAD_ARG], 0))
+	    !dm_task_set_read_ahead(dmt, _int_args[READAHEAD_ARG],
+				    _read_ahead_flags))
 		goto out;
 
 	r = dm_task_run(dmt);
@@ -2037,8 +2038,8 @@
 
 	fprintf(out, "Usage:\n\n");
 	fprintf(out, "dmsetup [--version] [-v|--verbose [-v|--verbose ...]]\n"
-		"        [-r|--readonly] [--noopencount] [--nolockfs] "
-		    "[--readahead <sectors>]\n"
+		"        [-r|--readonly] [--noopencount] [--nolockfs]\n"
+		"        [--readahead [+]<sectors>|auto|none]\n"
 		"        [-c|-C|--columns] [-o <fields>] [-O|--sort <sort_fields>]\n"
 		"        [--noheadings] [--separator <separator>]\n\n");
 	for (i = 0; _commands[i].name; i++)
@@ -2382,7 +2383,7 @@
 
 static int _process_switches(int *argc, char ***argv, const char *dev_dir)
 {
-	char *base, *namebase;
+	char *base, *namebase, *s;
 	static int ind;
 	int c, r;
 
@@ -2425,6 +2426,7 @@
 	 */
 	memset(&_switches, 0, sizeof(_switches));
 	memset(&_int_args, 0, sizeof(_int_args));
+	_read_ahead_flags = 0;
 
 	namebase = strdup((*argv)[0]);
 	base = basename(namebase);
@@ -2535,10 +2537,25 @@
 			_switches[NOLOCKFS_ARG]++;
 		if ((ind == NOOPENCOUNT_ARG))
 			_switches[NOOPENCOUNT_ARG]++;
-		/* FIXME Accept auto/none & set read_ahead_flags too */
 		if ((ind == READAHEAD_ARG)) {
 			_switches[READAHEAD_ARG]++;
-			_int_args[READAHEAD_ARG] = atoi(optarg);
+			if (!strcasecmp(optarg, "auto"))
+				_int_args[READAHEAD_ARG] = DM_READ_AHEAD_AUTO;
+			else if (!strcasecmp(optarg, "none"))
+                		_int_args[READAHEAD_ARG] = DM_READ_AHEAD_NONE;
+			else {
+				for (s = optarg; isspace(*s); s++)
+					;
+				if (*s == '+')
+					_read_ahead_flags = DM_READ_AHEAD_MINIMUM_FLAG;
+				_int_args[READAHEAD_ARG] = atoi(optarg);
+				if (_int_args[READAHEAD_ARG] < -1) {
+					log_error("Negative read ahead value "
+						  "(%d) is not understood.",
+						  _int_args[READAHEAD_ARG]);
+					return 0;
+				}
+			}
 		}
 		if ((ind == SHOWKEYS_ARG))
 			_switches[SHOWKEYS_ARG]++;
--- device-mapper/man/dmsetup.8	2007/11/27 20:57:05	1.19
+++ device-mapper/man/dmsetup.8	2007/11/29 14:44:28	1.20
@@ -114,9 +114,14 @@
 .IP \fB-r|--readonly
 .br
 Set the table being loaded read-only.
-.IP \fB--readahead\ <sectors>
+.IP \fB--readahead\ [+]<sectors>|auto|none
 .br    
 Specify read ahead size in units of sectors.
+The default value is "auto" which allows the kernel to choose
+a suitable value automatically.  The + prefix lets you
+specify a minimum value which will not be used if it is
+smaller than the value chosen by the kernel.
+"None" is equivalent to specifying zero.
 .IP \fB--table\ <table>
 .br
 Specify a one-line table directly on the command line.
