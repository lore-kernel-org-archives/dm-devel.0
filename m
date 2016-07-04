From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/26] multipath: make 'cmd' internal to
	multipath program
Date: Mon,  4 Jul 2016 09:08:31 +0200
Message-ID: <1467616126-10036-12-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Only the multipath program is using the 'cmd' setting, so we
should be dropping it from the config structure and make it
a local variable for multipath.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.h |  1 -
 multipath/main.c      | 73 +++++++++++++++++++++++++--------------------------
 2 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index e0ace8c..3ed550c 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -97,7 +97,6 @@ struct mpentry {
 
 struct config {
 	int verbosity;
-	enum mpath_cmds cmd;
 	int pgpolicy_flag;
 	int pgpolicy;
 	enum devtypes dev_type;
diff --git a/multipath/main.c b/multipath/main.c
index bf2fd31..bd7da58 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -176,7 +176,7 @@ update_paths (struct multipath * mpp)
 }
 
 static int
-get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
+get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 {
 	int i;
 	struct multipath * mpp;
@@ -198,7 +198,7 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
 			continue;
 		}
 
-		if (conf->cmd == CMD_VALID_PATH)
+		if (cmd == CMD_VALID_PATH)
 			continue;
 
 		dm_get_map(mpp->alias, &mpp->size, params);
@@ -213,19 +213,19 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
 		 * If not in "fast list mode", we need to fetch information
 		 * about them
 		 */
-		if (conf->cmd != CMD_LIST_SHORT)
+		if (cmd != CMD_LIST_SHORT)
 			update_paths(mpp);
 
-		if (conf->cmd == CMD_LIST_LONG)
+		if (cmd == CMD_LIST_LONG)
 			mpp->bestpg = select_path_group(mpp);
 
 		disassemble_status(status, mpp);
 
-		if (conf->cmd == CMD_LIST_SHORT ||
-		    conf->cmd == CMD_LIST_LONG)
+		if (cmd == CMD_LIST_SHORT ||
+		    cmd == CMD_LIST_LONG)
 			print_multipath_topology(mpp, conf->verbosity);
 
-		if (conf->cmd == CMD_CREATE)
+		if (cmd == CMD_CREATE)
 			reinstate_paths(mpp);
 	}
 	return 0;
@@ -239,7 +239,7 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
  *   1: Failure
  */
 static int
-configure (void)
+configure (enum mpath_cmds cmd)
 {
 	vector curmp = NULL;
 	vector pathvec = NULL;
@@ -268,10 +268,10 @@ configure (void)
 	 * if we have a blacklisted device parameter, exit early
 	 */
 	if (dev && conf->dev_type == DEV_DEVNODE &&
-	    conf->cmd != CMD_REMOVE_WWID &&
+	    cmd != CMD_REMOVE_WWID &&
 	    (filter_devnode(conf->blist_devnode,
 			    conf->elist_devnode, dev) > 0)) {
-		if (conf->cmd == CMD_VALID_PATH)
+		if (cmd == CMD_VALID_PATH)
 			printf("%s is not a valid multipath device path\n",
 			       conf->dev);
 		goto out;
@@ -281,17 +281,17 @@ configure (void)
 	 * failing the translation is fatal (by policy)
 	 */
 	if (conf->dev) {
-		int failed = get_refwwid(conf->cmd, conf->dev, conf->dev_type,
+		int failed = get_refwwid(cmd, conf->dev, conf->dev_type,
 					 pathvec, &refwwid);
 		if (!refwwid) {
 			condlog(4, "%s: failed to get wwid", conf->dev);
-			if (failed == 2 && conf->cmd == CMD_VALID_PATH)
+			if (failed == 2 && cmd == CMD_VALID_PATH)
 				printf("%s is not a valid multipath device path\n", conf->dev);
 			else
 				condlog(3, "scope is nul");
 			goto out;
 		}
-		if (conf->cmd == CMD_REMOVE_WWID) {
+		if (cmd == CMD_REMOVE_WWID) {
 			r = remove_wwid(refwwid);
 			if (r == 0)
 				printf("wwid '%s' removed\n", refwwid);
@@ -302,7 +302,7 @@ configure (void)
 			}
 			goto out;
 		}
-		if (conf->cmd == CMD_ADD_WWID) {
+		if (cmd == CMD_ADD_WWID) {
 			r = remember_wwid(refwwid);
 			if (r == 0)
 				printf("wwid '%s' added\n", refwwid);
@@ -317,7 +317,7 @@ configure (void)
 		 * paths to determine if this path should be multipathed. To
 		 * do this, we put off the check until after discovering all
 		 * the paths */
-		if (conf->cmd == CMD_VALID_PATH &&
+		if (cmd == CMD_VALID_PATH &&
 		    (!conf->find_multipaths || !conf->ignore_wwids)) {
 			if (conf->ignore_wwids ||
 			    check_wwids_file(refwwid, 0) == 0)
@@ -335,10 +335,10 @@ configure (void)
 	if (conf->dev)
 		di_flag = DI_WWID;
 
-	if (conf->cmd == CMD_LIST_LONG)
+	if (cmd == CMD_LIST_LONG)
 		/* extended path info '-ll' */
 		di_flag |= DI_SYSFS | DI_CHECKER;
-	else if (conf->cmd == CMD_LIST_SHORT)
+	else if (cmd == CMD_LIST_SHORT)
 		/* minimum path info '-l' */
 		di_flag |= DI_SYSFS;
 	else
@@ -353,13 +353,13 @@ configure (void)
 
 	get_path_layout(pathvec, 0);
 
-	if (get_dm_mpvec(curmp, pathvec, refwwid))
+	if (get_dm_mpvec(cmd, curmp, pathvec, refwwid))
 		goto out;
 
 	filter_pathvec(pathvec, refwwid);
 
 
-	if (conf->cmd == CMD_VALID_PATH) {
+	if (cmd == CMD_VALID_PATH) {
 		/* This only happens if find_multipaths is and
 		 * ignore_wwids is set.
 		 * If there is currently a multipath device matching
@@ -372,7 +372,7 @@ configure (void)
 		goto out;
 	}
 
-	if (conf->cmd != CMD_CREATE && conf->cmd != CMD_DRY_RUN) {
+	if (cmd != CMD_CREATE && cmd != CMD_DRY_RUN) {
 		r = 0;
 		goto out;
 	}
@@ -381,7 +381,7 @@ configure (void)
 	 * core logic entry point
 	 */
 	r = coalesce_paths(&vecs, NULL, refwwid,
-			   conf->force_reload, conf->cmd);
+			   conf->force_reload, cmd);
 
 out:
 	if (refwwid)
@@ -479,13 +479,12 @@ main (int argc, char *argv[])
 	extern char *optarg;
 	extern int optind;
 	int r = 1;
+	enum mpath_cmds cmd = CMD_CREATE;
 
 	udev = udev_new();
 	logsink = 0;
 	if (load_config(DEFAULT_CONFIGFILE, udev))
 		exit(1);
-	/* Default to CMD_CREATE */
-	conf->cmd = CMD_CREATE;
 	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
@@ -509,11 +508,11 @@ main (int argc, char *argv[])
 			conf->allow_queueing = 1;
 			break;
 		case 'c':
-			conf->cmd = CMD_VALID_PATH;
+			cmd = CMD_VALID_PATH;
 			break;
 		case 'd':
-			if (conf->cmd == CMD_CREATE)
-				conf->cmd = CMD_DRY_RUN;
+			if (cmd == CMD_CREATE)
+				cmd = CMD_DRY_RUN;
 			break;
 		case 'f':
 			conf->remove = FLUSH_ONE;
@@ -523,9 +522,9 @@ main (int argc, char *argv[])
 			break;
 		case 'l':
 			if (optarg && !strncmp(optarg, "l", 1))
-				conf->cmd = CMD_LIST_LONG;
+				cmd = CMD_LIST_LONG;
 			else
-				conf->cmd = CMD_LIST_SHORT;
+				cmd = CMD_LIST_SHORT;
 
 			break;
 		case 'M':
@@ -554,17 +553,17 @@ main (int argc, char *argv[])
 			usage(argv[0]);
 			exit(0);
 		case 'u':
-			conf->cmd = CMD_VALID_PATH;
+			cmd = CMD_VALID_PATH;
 			conf->dev_type = DEV_UEVENT;
 			break;
 		case 'w':
-			conf->cmd = CMD_REMOVE_WWID;
+			cmd = CMD_REMOVE_WWID;
 			break;
 		case 'W':
-			conf->cmd = CMD_RESET_WWIDS;
+			cmd = CMD_RESET_WWIDS;
 			break;
 		case 'a':
-			conf->cmd = CMD_ADD_WWID;
+			cmd = CMD_ADD_WWID;
 			break;
 		case ':':
 			fprintf(stderr, "Missing option argument\n");
@@ -630,12 +629,12 @@ main (int argc, char *argv[])
 		goto out;
 	}
 
-	if (conf->cmd == CMD_VALID_PATH &&
+	if (cmd == CMD_VALID_PATH &&
 	    (!conf->dev || conf->dev_type == DEV_DEVMAP)) {
 		condlog(0, "the -c option requires a path to check");
 		goto out;
 	}
-	if (conf->cmd == CMD_VALID_PATH &&
+	if (cmd == CMD_VALID_PATH &&
 	    conf->dev_type == DEV_UEVENT) {
 		int fd;
 
@@ -647,11 +646,11 @@ main (int argc, char *argv[])
 		}
 		mpath_disconnect(fd);
 	}
-	if (conf->cmd == CMD_REMOVE_WWID && !conf->dev) {
+	if (cmd == CMD_REMOVE_WWID && !conf->dev) {
 		condlog(0, "the -w option requires a device");
 		goto out;
 	}
-	if (conf->cmd == CMD_RESET_WWIDS) {
+	if (cmd == CMD_RESET_WWIDS) {
 		struct multipath * mpp;
 		int i;
 		vector curmp;
@@ -684,7 +683,7 @@ main (int argc, char *argv[])
 		r = dm_flush_maps();
 		goto out;
 	}
-	while ((r = configure()) < 0)
+	while ((r = configure(cmd)) < 0)
 		condlog(3, "restart multipath configuration process");
 
 out:
-- 
2.6.6
