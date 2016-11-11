From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/3] allow multipath to retry removes of in-use
	devices
Date: Fri, 11 Nov 2016 16:58:22 -0600
Message-ID: <1478905103-9735-3-git-send-email-bmarzins@redhat.com>
References: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Occasionally, a multipath device is temporarily opened by things like
udev. This can cause the multipath flush commands to fail. While it is
possible to simply rerun the command, it can be very annoying for
scripts that are working with multipath devices. To deal with that,
it is now possible to tell multipath to retry failed removes. Either
running multipath with "-R <num>" or setting "remove_retries <num>"
in /etc/multipath.conf will make multipath retry failed removes
the specified number of times, with a 1 second delay between tries.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  1 +
 libmultipath/config.h      |  1 +
 libmultipath/devmapper.c   | 38 ++++++++++++++++++++------------------
 libmultipath/devmapper.h   |  4 ++--
 libmultipath/dict.c        |  4 ++++
 multipath/main.c           | 17 ++++++++++++-----
 multipath/multipath.8      |  7 +++++++
 multipath/multipath.conf.5 | 10 ++++++++++
 8 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 2d629ef..342f326 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -620,6 +620,7 @@ load_config (char * file)
 	conf->deferred_remove = DEFAULT_DEFERRED_REMOVE;
 	conf->skip_kpartx = DEFAULT_SKIP_KPARTX;
 	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
+	conf->remove_retries = 0;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index dbdaa44..eee28e7 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -145,6 +145,7 @@ struct config {
 	int uev_wait_timeout;
 	int skip_kpartx;
 	int disable_changed_wwids;
+	int remove_retries;
 	unsigned int version[3];
 
 	char * multipath_dir;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5aea5b6..aaab824 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -845,9 +845,9 @@ dm_flush_map_nopaths(const char * mapname, int deferred_remove)
 #endif
 
 extern int
-dm_suspend_and_flush_map (const char * mapname)
+dm_suspend_and_flush_map (const char * mapname, int retries)
 {
-	int s = 0, queue_if_no_path = 0;
+	int need_reset = 0, queue_if_no_path = 0;
 	unsigned long long mapsize;
 	char params[PARAMS_SIZE] = {0};
 	int udev_flags = 0;
@@ -865,27 +865,29 @@ dm_suspend_and_flush_map (const char * mapname)
 			queue_if_no_path = 1;
 	}
 
-	if (queue_if_no_path)
-		s = dm_queue_if_no_path((char *)mapname, 0);
-	/* Leave queue_if_no_path alone if unset failed */
-	if (s)
-		queue_if_no_path = 0;
-	else
-		s = dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
+	if (queue_if_no_path && dm_queue_if_no_path((char *)mapname, 0) == 0)
+		need_reset = 1;
 
-	if (!dm_flush_map(mapname)) {
-		condlog(4, "multipath map %s removed", mapname);
-		return 0;
-	}
+	do {
+		if (!queue_if_no_path || need_reset)
+			dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
+
+		if (!dm_flush_map(mapname)) {
+			condlog(4, "multipath map %s removed", mapname);
+			return 0;
+		}
+		dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags);
+		if (retries)
+			sleep(1);
+	} while (retries-- > 0);
 	condlog(2, "failed to remove multipath map %s", mapname);
-	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags);
-	if (queue_if_no_path)
-		s = dm_queue_if_no_path((char *)mapname, 1);
+	if (need_reset)
+		dm_queue_if_no_path((char *)mapname, 1);
 	return 1;
 }
 
 extern int
-dm_flush_maps (void)
+dm_flush_maps (int retries)
 {
 	int r = 0;
 	struct dm_task *dmt;
@@ -907,7 +909,7 @@ dm_flush_maps (void)
 		goto out;
 
 	do {
-		r |= dm_suspend_and_flush_map(names->name);
+		r |= dm_suspend_and_flush_map(names->name, retries);
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index e6d1090..411177d 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -35,8 +35,8 @@ int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0)
 #define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0)
 int dm_cancel_deferred_remove(struct multipath *mpp);
-int dm_suspend_and_flush_map(const char * mapname);
-int dm_flush_maps (void);
+int dm_suspend_and_flush_map(const char * mapname, int retries);
+int dm_flush_maps (int retries);
 int dm_fail_path(char * mapname, char * path);
 int dm_reinstate_path(char * mapname, char * path);
 int dm_queue_if_no_path(char *mapname, int enable);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 61b6910..6e4ec71 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -415,6 +415,9 @@ declare_mp_snprint(skip_kpartx, print_yes_no_undef)
 declare_def_handler(disable_changed_wwids, set_yes_no)
 declare_def_snprint(disable_changed_wwids, print_yes_no)
 
+declare_def_handler(remove_retries, set_int)
+declare_def_snprint(remove_retries, print_int)
+
 static int
 def_config_dir_handler(struct config *conf, vector strvec)
 {
@@ -1399,6 +1402,7 @@ init_keywords(vector keywords)
 	install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
 	install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint_def_skip_kpartx);
 	install_keyword("disable_changed_wwids", &def_disable_changed_wwids_handler, &snprint_def_disable_changed_wwids);
+	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/multipath/main.c b/multipath/main.c
index 06add30..171c08b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -103,8 +103,8 @@ usage (char * progname)
 	fprintf (stderr, VERSION_STRING);
 	fprintf (stderr, "Usage:\n");
 	fprintf (stderr, "  %s [-a|-c|-w|-W] [-d] [-r] [-i] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
-	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
-	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
+	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [-R num] [dev]\n", progname);
+	fprintf (stderr, "  %s -F [-v lvl] [-R num]\n", progname);
 	fprintf (stderr, "  %s -t\n", progname);
 	fprintf (stderr, "  %s -h\n", progname);
 	fprintf (stderr,
@@ -137,6 +137,7 @@ usage (char * progname)
 		"          . 1 print created devmap names only\n"
 		"          . 2 default verbosity\n"
 		"          . 3 print debug information\n"
+		"  -R num  number of times to retry removes of in-use devices\n"
 		"  dev     action limited to:\n"
 		"          . multipath named 'dev' (ex: mpath0) or\n"
 		"          . multipath whose wwid is 'dev' (ex: 60051..)\n"
@@ -514,6 +515,7 @@ main (int argc, char *argv[])
 	enum devtypes dev_type = DEV_NONE;
 	char *dev = NULL;
 	struct config *conf;
+	int retries = -1;
 
 	udev = udev_new();
 	logsink = 0;
@@ -522,7 +524,7 @@ main (int argc, char *argv[])
 		exit(1);
 	multipath_conf = conf;
 	conf->retrigger_tries = 0;
-	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BrR:itquwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -602,6 +604,9 @@ main (int argc, char *argv[])
 		case 'a':
 			cmd = CMD_ADD_WWID;
 			break;
+		case 'R':
+			retries = atoi(optarg);
+			break;
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
 			usage(argv[0]);
@@ -708,16 +713,18 @@ main (int argc, char *argv[])
 		vector_free(curmp);
 		goto out;
 	}
+	if (retries < 0)
+		retries = conf->remove_retries;
 	if (conf->remove == FLUSH_ONE) {
 		if (dev_type == DEV_DEVMAP) {
-			r = dm_suspend_and_flush_map(dev);
+			r = dm_suspend_and_flush_map(dev, retries);
 		} else
 			condlog(0, "must provide a map name to remove");
 
 		goto out;
 	}
 	else if (conf->remove == FLUSH_ALL) {
-		r = dm_flush_maps();
+		r = dm_flush_maps(retries);
 		goto out;
 	}
 	while ((r = configure(cmd, dev_type, dev)) < 0)
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index f0b1ff0..b9436e5 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -28,6 +28,8 @@ multipath \- Device mapper target autoconfig.
 .RB [\| \-h | \-l | \-ll | \-f | \-t | \-F | \-B | \-c | \-q | \|-r | \|-i | \-a | \|-u | \-w | \-W \|]
 .RB [\| \-p\ \c
 .IR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
+.RB [\| \-R\ \c
+.IR retries \|]
 .RB [\| device \|]
 .
 .
@@ -155,6 +157,11 @@ in \fI/sys/class/fc_transport/target*/node_name\fR.
 Existing maps are not modified.
 .
 .TP
+.BI \-R " retries"
+Number of times to retry flushing multipath devices that are in-use. The default
+is \fI0\fR.
+.
+.TP
 .BI device
 Update only the devmap specified by
 .IR device ,
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index fa2df48..266f06b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -864,6 +864,16 @@ Default value is \fBno\fR
 .RE
 .
 .
+.TP
+.B remove_retries
+This sets how may times multipath will retry removing a device that is in-use.
+Between each attempt, multipath will sleep 1 second.
+.RS
+.TP
+Default value is \fB0\fR
+.RE
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist section"
 .\" ----------------------------------------------------------------------------
-- 
1.8.3.1
