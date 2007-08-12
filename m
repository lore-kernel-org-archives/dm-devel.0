From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: multipath-tool udev rules require missing dmsetup
	features
Date: Sun, 12 Aug 2007 18:27:17 +0200
Message-ID: <20070812162716.GA9108@bogon.ms20.nix>
References: <469EB881.6070207@csupomona.edu>
	<20070719061622.GB21899@pentland.suse.de>
	<20070720164635.GB459@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0eh6TmSyL6TZE2Uz"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070720164635.GB459@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Bastian Blank <waldi@debian.org>
List-Id: dm-devel.ids


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Alasdair,
On Fri, Jul 20, 2007 at 05:46:35PM +0100, Alasdair G Kergon wrote:
> On Thu, Jul 19, 2007 at 08:16:22AM +0200, Hannes Reinecke wrote:
> > As already said, it totally makes sense when you hack up dmsetup and then forget
> > about the patch. Sorry about this.
> > Alasdair, care to incorporate it?
> 
> Kay mentioned this patch to me at OLS.
> 
> My answer was that I want to see a generic implementation within the reporting
> code.  In other words a new command line flag would instruct the reporting code
> to produce its output in this sort of format.  The output needs to be useful
> when reporting on multiple objects at once, so to guarantee unique output
> lines, you might want to include fields acting as a unique key inside the
> variable names, which can be all-caps versions of the existing reporting field
> names.
Does the attached version look better?
Cheers,
 -- Guido

--0eh6TmSyL6TZE2Uz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="dmsetup-export.diff"

diff --git a/dmsetup/dmsetup.c b/dmsetup/dmsetup.c
index a86fed2..0226e77 100644
--- a/dmsetup/dmsetup.c
+++ b/dmsetup/dmsetup.c
@@ -108,6 +108,7 @@ enum {
 	READ_ONLY = 0,
 	COLS_ARG,
 	EXEC_ARG,
+	EXPORT_ARG,
 	FORCE_ARG,
 	GID_ARG,
 	MAJOR_ARG,
@@ -322,6 +323,33 @@ static int _display_info_cols(struct dm_task *dmt, struct dm_info *info)
 
 static void _display_info_long(struct dm_task *dmt, struct dm_info *info)
 {
+	enum { name = 0, state, tablestate, opencount,
+	       eventnumber, devno, numtargets, uuidname };
+
+	const char* info_formatstrings[] = {
+		[name]        = "Name:              %s\n",
+		[state]       = "State:             %s%s\n",
+		[tablestate]  = "Tables present:    %s%s%s\n",
+		[opencount]   = "Open count:        %d\n",
+		[eventnumber] = "Event number:      %" PRIu32 "\n",
+		[devno]       = "Major, minor:      %d, %d\n",
+		[numtargets]  = "Number of targets: %d\n",
+		[uuidname]    = "UUID: %s\n",
+		};
+
+	const char* export_formatstrings[] = {	
+		[name]        = "DM_NAME=%s\n",
+		[state]       = "DM_STATE=\"%s%s\"\n",
+		[tablestate]  = "DM_TABLE_STATE=\"%s%s%s\"\n",
+		[opencount]   = "DM_OPENCOUNT=%d\n",
+		[eventnumber] = "DM_LAST_EVENT_NR=%" PRIu32 "\n",
+		[devno]       = "DM_MAJOR=%d\nDM_MINOR=%d\n",
+		[numtargets]  = "DM_TARGET_COUNT=%d\n",
+		[uuidname]    = "DM_UUID=%s\n",
+ 		};
+
+	const char** format = _switches[EXPORT_ARG] ? export_formatstrings 
+	                                            : info_formatstrings;
 	const char *uuid;
 
 	if (!info->exists) {
@@ -329,31 +357,31 @@ static void _display_info_long(struct dm_task *dmt, struct dm_info *info)
 		return;
 	}
 
-	printf("Name:              %s\n", dm_task_get_name(dmt));
+	printf(format[name], dm_task_get_name(dmt));
 
-	printf("State:             %s%s\n",
+	printf(format[state],
 	       info->suspended ? "SUSPENDED" : "ACTIVE",
 	       info->read_only ? " (READ-ONLY)" : "");
 
 	if (!info->live_table && !info->inactive_table)
-		printf("Tables present:    None\n");
+		printf(format[tablestate], "", "", "None\n");
 	else
-		printf("Tables present:    %s%s%s\n",
+		printf(format[tablestate],
 		       info->live_table ? "LIVE" : "",
 		       info->live_table && info->inactive_table ? " & " : "",
 		       info->inactive_table ? "INACTIVE" : "");
 
 	if (info->open_count != -1)
-		printf("Open count:        %d\n", info->open_count);
+		printf(format[opencount], info->open_count);
 
-	printf("Event number:      %" PRIu32 "\n", info->event_nr);
-	printf("Major, minor:      %d, %d\n", info->major, info->minor);
+	printf(format[eventnumber], info->event_nr);
+	printf(format[devno], info->major, info->minor);
 
 	if (info->target_count != -1)
-		printf("Number of targets: %d\n", info->target_count);
+		printf(format[numtargets], info->target_count);
 
 	if ((uuid = dm_task_get_uuid(dmt)) && *uuid)
-		printf("UUID: %s\n", uuid);
+		printf(format[uuidname], uuid);
 
 	printf("\n");
 }
@@ -2355,6 +2383,7 @@ static int _process_switches(int *argc, char ***argv)
 		{"readonly", 0, &ind, READ_ONLY},
 		{"columns", 0, &ind, COLS_ARG},
 		{"exec", 1, &ind, EXEC_ARG},
+		{"export", 0, &ind, EXPORT_ARG},
 		{"force", 0, &ind, FORCE_ARG},
 		{"gid", 1, &ind, GID_ARG},
 		{"major", 1, &ind, MAJOR_ARG},
@@ -2431,12 +2460,14 @@ static int _process_switches(int *argc, char ***argv)
 
 	optarg = 0;
 	optind = OPTIND_INIT;
-	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCfG:j:m:M:no:O:ru:U:v",
+	while ((ind = -1, c = GETOPTLONG_FN(*argc, *argv, "cCefG:j:m:M:no:O:ru:U:v",
 					    long_options, NULL)) != -1) {
 		if (c == ':' || c == '?')
 			return 0;
 		if (c == 'c' || c == 'C' || ind == COLS_ARG)
 			_switches[COLS_ARG]++;
+		if (c == 'e' || ind == EXPORT_ARG)
+			_switches[EXPORT_ARG]++;
 		if (c == 'f' || ind == FORCE_ARG)
 			_switches[FORCE_ARG]++;
 		if (c == 'r' || ind == READ_ONLY)

--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--0eh6TmSyL6TZE2Uz--
