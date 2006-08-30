From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Add more fields for 'dmsetup info -o XXX'
Date: Wed, 30 Aug 2006 09:10:12 +0200
Message-ID: <44F539D4.20600@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000200030406070904020905"
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000200030406070904020905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

this patch adds more fields to the '-o' option for 'dmsetup info'.
I always found it slightly annoying that only the 'name' field was=20
supported; by supporting more fields it'll make parsing easier.
Supported fields are now 'name', 'major', 'minor', and 'uuid'.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------000200030406070904020905
Content-Type: text/x-patch;
 name="device-mapper-option-values.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="device-mapper-option-values.patch"

diff -pur device-mapper.1.02.09.orig/dmsetup/dmsetup.c device-mapper.1.02.09/dmsetup/dmsetup.c
--- device-mapper.1.02.09.orig/dmsetup/dmsetup.c	2006-08-10 22:53:21.000000000 +0200
+++ device-mapper.1.02.09/dmsetup/dmsetup.c	2006-08-30 08:34:53.000000000 +0200
@@ -108,6 +108,14 @@ enum {
 	NUM_SWITCHES
 };
 
+enum {
+	NAME_FIELD    = 1,
+	MAJOR_FIELD   = 2,
+	MINOR_FIELD   = 3,
+	UUID_FIELD    = 4,
+	INVALID_FIELD = 5,
+};
+
 static int _switches[NUM_SWITCHES];
 static int _values[NUM_SWITCHES];
 static int _num_devices;
@@ -211,9 +219,35 @@ static void _display_info_cols_noheading
 
 	uuid = dm_task_get_uuid(dmt);
 
-	if (_switches[OPTIONS_ARG])
-		printf("%s\n", dm_task_get_name(dmt));
-	else
+	if (_switches[OPTIONS_ARG]) {
+		int v = _values[OPTIONS_ARG];
+		int shift = 0;
+
+		while (v) {
+			if (v & 0x1) {
+				switch (shift) {
+				case NAME_FIELD:
+					printf("%s", 
+					       dm_task_get_name(dmt));
+					break;
+				case MAJOR_FIELD:
+					printf("%d", info->major);
+					break;
+				case MINOR_FIELD:
+					printf("%d", info->minor);
+					break;
+				case UUID_FIELD:
+					printf("%s", uuid);
+					break;
+				}
+			}
+			v >>= 1;
+			shift++;
+			if (v)
+				printf(":");
+		}
+		printf("\n");
+	} else
 		printf("%s:%d:%d:%s%s%s%s:%d:%d:%" PRIu32 ":%s\n",
 		       dm_task_get_name(dmt),
 		       info->major, info->minor,
@@ -236,17 +270,65 @@ static void _display_info_cols(struct dm
 	}
 
 	if (!_headings) {
-		if (_switches[OPTIONS_ARG])
-			printf("Name\n");
-		else
+		if (_switches[OPTIONS_ARG]) {
+			int v = _values[OPTIONS_ARG];
+			int shift = 0;
+
+			while (v) {
+				if (v & 0x1) {
+					switch (shift) {
+					case NAME_FIELD:
+						printf("Name             ");
+						break;
+					case MAJOR_FIELD:
+						printf("Maj ");
+						break;
+					case MINOR_FIELD:
+						printf("Min ");
+						break;
+					case UUID_FIELD:
+						printf("UUID");
+						break;
+					}
+				}
+				v >>= 1;
+				shift++;
+			}
+			printf("\n");
+		} else
 			printf("Name             Maj Min Stat Open Targ "
 			       "Event  UUID\n");
 		_headings = 1;
 	}
 
-	if (_switches[OPTIONS_ARG])
-		printf("%s\n", dm_task_get_name(dmt));
-	else {
+	uuid = dm_task_get_uuid(dmt);
+
+	if (_switches[OPTIONS_ARG]) {
+		int v = _values[OPTIONS_ARG];
+		int shift = 0;
+
+		while (v) {
+			if (v & 0x1) {
+				switch (shift) {
+				case NAME_FIELD:
+					printf("%-16s ", dm_task_get_name(dmt));
+					break;
+				case MAJOR_FIELD:
+					printf("%3d ", info->major);
+					break;
+				case MINOR_FIELD:
+					printf("%3d ", info->minor);
+					break;
+				case UUID_FIELD:
+					printf("%s", uuid);
+					break;
+				}
+			}
+			v >>= 1;
+			shift++;
+		}
+		printf("\n");
+	} else {
 		printf("%-16s %3d %3d %s%s%s%s %4d %4d %6" PRIu32 " ",
 		       dm_task_get_name(dmt),
 		       info->major, info->minor,
@@ -256,7 +338,7 @@ static void _display_info_cols(struct dm
 		       info->read_only ? "r" : "w",
 		       info->open_count, info->target_count, info->event_nr);
 
-		if ((uuid = dm_task_get_uuid(dmt)) && *uuid)
+		if (uuid && *uuid)
 			printf("%s", uuid);
 
 		printf("\n");
@@ -1606,6 +1688,35 @@ static int _process_tree_options(const c
 	return 1;
 }
 
+static int _process_fields(char *optarg)
+{
+	int flags = 0;
+	char *f, *e;
+
+	f = optarg;
+
+	while (f && *f) {
+		if (!strncmp("name", f, 4))
+			flags |= 1 << NAME_FIELD;
+		else if (!strncmp("major", f, 5))
+			flags |= 1 << MAJOR_FIELD;
+		else if (!strncmp("minor", f, 5))
+			flags |= 1 << MINOR_FIELD;
+		else if (!strncmp("uuid", f, 4))
+			flags |= 1 << UUID_FIELD;
+		else
+			flags |= 1 << INVALID_FIELD;
+
+		e = strchr(f, ',');
+		if (e)
+			f = e + 1;
+		else
+			f = NULL;
+	}
+
+	return flags;
+}
+
 static int _process_switches(int *argc, char ***argv)
 {
 	char *base, *namebase;
@@ -1656,7 +1767,7 @@ static int _process_switches(int *argc, 
 		_switches[OPTIONS_ARG]++;
 		_switches[MAJOR_ARG]++;
 		_switches[MINOR_ARG]++;
-		_fields = (char *) "name";
+		_values[OPTIONS_ARG] = NAME_FIELD;
 
 		if (*argc == 3) {
 			_values[MAJOR_ARG] = atoi((*argv)[1]);
@@ -1705,6 +1816,7 @@ static int _process_switches(int *argc, 
 		if (c == 'o' || ind == OPTIONS_ARG) {
 			_switches[OPTIONS_ARG]++;
 			_fields = optarg;
+			_values[OPTIONS_ARG] = _process_fields(optarg);
 		}
 		if (c == 'v' || ind == VERBOSE_ARG)
 			_switches[VERBOSE_ARG]++;
@@ -1760,8 +1872,9 @@ static int _process_switches(int *argc, 
 	}
 
 	if (_switches[COLS_ARG] && _switches[OPTIONS_ARG] &&
-	    strcmp(_fields, "name")) {
-		fprintf(stderr, "Only -o name is supported so far.\n");
+	    (_values[OPTIONS_ARG] & (1 << INVALID_FIELD))) {
+		fprintf(stderr, "Only 'name', 'major', 'minor', and"
+			" 'uuid' are supported so far.\n");
 		return 0;
 	}
 
Nur in device-mapper.1.02.09/dmsetup: dmsetup.c~.
diff -pur device-mapper.1.02.09.orig/man/dmsetup.8 device-mapper.1.02.09/man/dmsetup.8
--- device-mapper.1.02.09.orig/man/dmsetup.8	2006-08-10 16:11:03.000000000 +0200
+++ device-mapper.1.02.09/man/dmsetup.8	2006-08-30 08:39:43.000000000 +0200
@@ -35,7 +35,7 @@ dmsetup \- low level logical volume mana
 .B dmsetup info 
 .I [device_name]
 .br
-.B dmsetup info -c|-C|--columns [--noheadings] [-o name]
+.B dmsetup info -c|-C|--columns [--noheadings] [-o fields]
 .I [device_name]
 .br
 .B dmsetup deps
@@ -97,7 +97,8 @@ Tell the kernel not to supply the open r
 When creating a device, don't load any table.
 .IP \fB-o|--options
 .br
-Specify which fields to display.  Only \fB-o\ name\fP is supported.
+Specify which fields to display.  Only \fBname\fP, \fBmajor\fP,
+\fBminor\fP, and \fBuuid\fP are supported.
 .IP \fB-r|--readonly
 .br
 Set the table being loaded read-only.
Nur in device-mapper.1.02.09/man: dmsetup.8~.

--------------000200030406070904020905
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000200030406070904020905--
