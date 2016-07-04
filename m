From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/26] multipath: make 'struct config' a local
	variable
Date: Mon,  4 Jul 2016 09:08:44 +0200
Message-ID: <1467616126-10036-25-git-send-email-hare@suse.de>
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

Instead of having a global 'struct config' we should be making
it a local variable. This enables us to track accesses and
will allow us a race-free configuration update.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c |  13 ++--
 libmpathpersist/mpath_persist.h |   6 +-
 libmultipath/config.c           |  13 ++--
 libmultipath/config.h           |   3 +-
 mpathpersist/main.c             |   7 +-
 multipath/main.c                |  20 ++++-
 multipathd/main.c               | 166 +++++++++++++++++++++++++++++-----------
 7 files changed, 163 insertions(+), 65 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index c1f811a..b037822 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -36,12 +36,15 @@
 
 struct udev *udev;
 
-int
+struct config *
 mpath_lib_init (struct udev *udev)
 {
-	if (load_config(DEFAULT_CONFIGFILE)){
+	struct config *conf;
+
+	conf = load_config(DEFAULT_CONFIGFILE);
+	if (!conf) {
 		condlog(0, "Failed to initialize multipath config.");
-		return 1;
+		return NULL;
 	}
 
 	if (conf->max_fds) {
@@ -54,11 +57,11 @@ mpath_lib_init (struct udev *udev)
 				   conf->max_fds, strerror(errno));
 	}
 
-	return 0;
+	return conf;
 }
 
 int
-mpath_lib_exit (void)
+mpath_lib_exit (struct config *conf)
 {
 	dm_lib_release();
 	dm_lib_exit();
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index a5e7868..ef24d64 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -172,9 +172,9 @@ struct prout_param_descriptor { 	/* PROUT parameter descriptor */
  *	before performing reservation management functions.
  * RESTRICTIONS:
  *
- * RETURNS: 0->Success, 1->Failed.
+ * RETURNS: struct config ->Success, NULL->Failed.
  */
-extern int mpath_lib_init (struct udev *udev);
+extern struct config * mpath_lib_init (struct udev *udev);
 
 
 /*
@@ -185,7 +185,7 @@ extern int mpath_lib_init (struct udev *udev);
  *
  * RETURNS: 0->Success, 1->Failed.
  */
-extern int mpath_lib_exit (void );
+extern int mpath_lib_exit (struct config *conf);
 
 
 /*
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 28e94b9..216ca22 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -576,14 +576,13 @@ process_config_dir(struct config *conf, vector keywords, char *dir)
 	}
 }
 
-int
+struct config *
 load_config (char * file)
 {
-	if (!conf)
-		conf = alloc_config();
+	struct config *conf = alloc_config();
 
-	if (!conf || !udev)
-		return 1;
+	if (!conf)
+		return NULL;
 
 	/*
 	 * internal defaults
@@ -731,9 +730,9 @@ load_config (char * file)
 	    !conf->wwids_file)
 		goto out;
 
-	return 0;
+	return conf;
 out:
 	free_config(conf);
-	return 1;
+	return NULL;
 }
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index a50e97b..8db35dd 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -172,7 +172,6 @@ struct config {
 	vector elist_property;
 };
 
-struct config * conf;
 extern struct udev * udev;
 
 struct hwentry * find_hwe (vector hwtable, char * vendor, char * product, char *revision);
@@ -189,7 +188,7 @@ void free_mptable (vector mptable);
 
 int store_hwe (vector hwtable, struct hwentry *);
 
-int load_config (char * file);
+struct config *load_config (char * file);
 struct config * alloc_config (void);
 void free_config (struct config * conf);
 extern struct config *get_multipath_config(void);
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 6c1c5e7..e4fb39c 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -83,6 +83,7 @@ int main (int argc, char * argv[])
 	void *resp = NULL;
 	struct transportid * tmp;
 	struct udev *udev = NULL;
+	struct config *conf;
 
 	if (optind == argc)
 	{
@@ -99,7 +100,7 @@ int main (int argc, char * argv[])
 	}
 
 	udev = udev_new();
-	mpath_lib_init(udev);
+	conf = mpath_lib_init(udev);
 	memset(transportids,0,MPATH_MX_TIDS);
 	multipath_conf = conf;
 
@@ -475,13 +476,13 @@ int main (int argc, char * argv[])
 	res = close (fd);
 	if (res < 0)
 	{
-		mpath_lib_exit();
+		mpath_lib_exit(conf);
 		udev_unref(udev);
 		return MPATH_PR_FILE_ERROR;
 	}
 
 out :
-	mpath_lib_exit();
+	mpath_lib_exit(conf);
 	udev_unref(udev);
 	return (ret >= 0) ? ret : MPATH_PR_OTHER;
 }
diff --git a/multipath/main.c b/multipath/main.c
index 40b7a76..2ed3003 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -148,6 +148,7 @@ update_paths (struct multipath * mpp)
 	int i, j;
 	struct pathgroup * pgp;
 	struct path * pp;
+	struct config *conf;
 
 	if (!mpp->pg)
 		return 0;
@@ -167,20 +168,26 @@ update_paths (struct multipath * mpp)
 					continue;
 				}
 				pp->mpp = mpp;
+				conf = get_multipath_config();
 				if (pathinfo(pp, conf, DI_ALL))
 					pp->state = PATH_UNCHECKED;
+				put_multipath_config(conf);
 				continue;
 			}
 			pp->mpp = mpp;
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD) {
+				conf = get_multipath_config();
 				if (pathinfo(pp, conf, DI_CHECKER))
 					pp->state = PATH_UNCHECKED;
+				put_multipath_config(conf);
 			}
 
 			if (pp->priority == PRIO_UNDEF) {
+				conf = get_multipath_config();
 				if (pathinfo(pp, conf, DI_PRIO))
 					pp->priority = PRIO_UNDEF;
+				put_multipath_config(conf);
 			}
 		}
 	}
@@ -234,8 +241,11 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 		disassemble_status(status, mpp);
 
 		if (cmd == CMD_LIST_SHORT ||
-		    cmd == CMD_LIST_LONG)
+		    cmd == CMD_LIST_LONG) {
+			struct config *conf = get_multipath_config();
 			print_multipath_topology(mpp, conf->verbosity);
+			put_multipath_config(conf);
+		}
 
 		if (cmd == CMD_CREATE)
 			reinstate_paths(mpp);
@@ -260,6 +270,7 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
+	struct config *conf;
 
 	/*
 	 * allocate core vectors to store paths and multipaths
@@ -279,6 +290,7 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 	/*
 	 * if we have a blacklisted device parameter, exit early
 	 */
+	conf = get_multipath_config();
 	if (dev && dev_type == DEV_DEVNODE &&
 	    cmd != CMD_REMOVE_WWID &&
 	    (filter_devnode(conf->blist_devnode,
@@ -286,8 +298,10 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 		if (cmd == CMD_VALID_PATH)
 			printf("%s is not a valid multipath device path\n",
 			       devpath);
+		put_multipath_config(conf);
 		goto out;
 	}
+	put_multipath_config(conf);
 	/*
 	 * scope limiting must be translated into a wwid
 	 * failing the translation is fatal (by policy)
@@ -493,10 +507,12 @@ main (int argc, char *argv[])
 	enum mpath_cmds cmd = CMD_CREATE;
 	enum devtypes dev_type;
 	char *dev = NULL;
+	struct config *conf;
 
 	udev = udev_new();
 	logsink = 0;
-	if (load_config(DEFAULT_CONFIGFILE))
+	conf = load_config(DEFAULT_CONFIGFILE);
+	if (!conf)
 		exit(1);
 	multipath_conf = conf;
 	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
diff --git a/multipathd/main.c b/multipathd/main.c
index c4d6f9f..cae4bf8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -220,6 +220,7 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 	struct pathgroup * pgp;
 	struct path * pp;
 	unsigned int i, j;
+	struct config *conf;
 
 	if (!mpp || mpp->pgfailback == -FAILBACK_MANUAL)
 		return 0;
@@ -227,10 +228,15 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 	/*
 	 * Refresh path priority values
 	 */
-	if (refresh)
-		vector_foreach_slot (mpp->pg, pgp, i)
-			vector_foreach_slot (pgp->paths, pp, j)
+	if (refresh) {
+		vector_foreach_slot (mpp->pg, pgp, i) {
+			vector_foreach_slot (pgp->paths, pp, j) {
+				conf = get_multipath_config();
 				pathinfo(pp, conf, DI_PRIO);
+				put_multipath_config(conf);
+			}
+		}
+	}
 
 	if (!mpp->pg || VECTOR_SIZE(mpp->paths) == 0)
 		return 0;
@@ -257,8 +263,12 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 {
 	struct multipath * ompp;
 	vector ompv = vecs->mpvec;
-	unsigned int i;
+	unsigned int i, reassign_maps;
+	struct config *conf;
 
+	conf = get_multipath_config();
+	reassign_maps = conf->reassign_maps;
+	put_multipath_config(conf);
 	vector_foreach_slot (ompv, ompp, i) {
 		condlog(3, "%s: coalesce map", ompp->alias);
 		if (!find_mp_by_wwid(nmpv, ompp->wwid)) {
@@ -288,7 +298,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 				dm_lib_release();
 				condlog(2, "%s devmap removed", ompp->alias);
 			}
-		} else if (conf->reassign_maps) {
+		} else if (reassign_maps) {
 			condlog(3, "%s: Reassign existing device-mapper"
 				" devices", ompp->alias);
 			dm_reassign(ompp->alias);
@@ -448,7 +458,8 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	char * refwwid;
 	struct multipath * mpp;
 	int map_present;
-	int r = 1;
+	int r = 1, delayed_reconfig, reassign_maps;
+	struct config *conf;
 
 	map_present = dm_map_present(alias);
 
@@ -465,9 +476,13 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 				/* setup multipathd removed the map */
 				return 1;
 		}
+		conf = get_multipath_config();
+		delayed_reconfig = conf->delayed_reconfig;
+		reassign_maps = conf->reassign_maps;
+		put_multipath_config(conf);
 		if (mpp->wait_for_udev) {
 			mpp->wait_for_udev = 0;
-			if (conf->delayed_reconfig &&
+			if (delayed_reconfig &&
 			    !need_to_delay_reconfig(vecs)) {
 				condlog(2, "reconfigure (delayed)");
 				set_config_state(DAEMON_CONFIGURE);
@@ -479,7 +494,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 		 * if we create a multipath mapped device as a result
 		 * of uev_add_path
 		 */
-		if (conf->reassign_maps) {
+		if (reassign_maps) {
 			condlog(3, "%s: Reassign existing device-mapper devices",
 				alias);
 			dm_reassign(alias);
@@ -584,6 +599,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
 	int ret = 0, i;
+	struct config *conf;
 
 	condlog(2, "%s: add path (uevent)", uev->kernel);
 	if (strstr(uev->kernel, "..") != NULL) {
@@ -607,8 +623,10 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 			condlog(3, "%s: reinitialize path", uev->kernel);
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
+			conf = get_multipath_config();
 			r = pathinfo(pp, conf,
 				     DI_ALL | DI_BLACKLIST);
+			put_multipath_config(conf);
 			if (r == PATHINFO_OK)
 				ret = ev_add_path(pp, vecs);
 			else if (r == PATHINFO_SKIPPED) {
@@ -632,8 +650,10 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	/*
 	 * get path vital state
 	 */
+	conf = get_multipath_config();
 	ret = alloc_path_with_pathinfo(conf, uev->udev,
 				       DI_ALL, &pp);
+	put_multipath_config(conf);
 	if (!pp) {
 		if (ret == PATHINFO_SKIPPED)
 			return 0;
@@ -645,7 +665,9 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	pthread_testcancel();
 	ret = store_path(vecs->pathvec, pp);
 	if (!ret) {
+		conf = get_multipath_config();
 		pp->checkint = conf->checkint;
+		put_multipath_config(conf);
 		ret = ev_add_path(pp, vecs);
 	} else {
 		condlog(0, "%s: failed to store path info, "
@@ -1040,6 +1062,7 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 {
 	int r = 0;
 	struct vectors * vecs;
+	struct config *conf;
 
 	vecs = (struct vectors *)trigger_data;
 
@@ -1076,9 +1099,13 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	/*
 	 * path add/remove event
 	 */
+	conf = get_multipath_config();
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0)
+			   uev->kernel) > 0) {
+		put_multipath_config(conf);
 		goto out;
+	}
+	put_multipath_config(conf);
 
 	if (!strncmp(uev->action, "add", 3)) {
 		r = uev_add_path(uev, vecs);
@@ -1291,7 +1318,8 @@ missing_uev_wait_tick(struct vectors *vecs)
 {
 	struct multipath * mpp;
 	unsigned int i;
-	int timed_out = 0;
+	int timed_out = 0, delayed_reconfig;
+	struct config *conf;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i) {
 		if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
@@ -1306,7 +1334,10 @@ missing_uev_wait_tick(struct vectors *vecs)
 		}
 	}
 
-	if (timed_out && conf->delayed_reconfig &&
+	conf = get_multipath_config();
+	delayed_reconfig = conf->delayed_reconfig;
+	put_multipath_config(conf);
+	if (timed_out && delayed_reconfig &&
 	    !need_to_delay_reconfig(vecs)) {
 		condlog(2, "reconfigure (delayed)");
 		set_config_state(DAEMON_CONFIGURE);
@@ -1356,12 +1387,15 @@ int update_prio(struct path *pp, int refresh_all)
 	struct path *pp1;
 	struct pathgroup * pgp;
 	int i, j, changed = 0;
+	struct config *conf;
 
 	if (refresh_all) {
 		vector_foreach_slot (pp->mpp->pg, pgp, i) {
 			vector_foreach_slot (pgp->paths, pp1, j) {
 				oldpriority = pp1->priority;
+				conf = get_multipath_config();
 				pathinfo(pp1, conf, DI_PRIO);
+				put_multipath_config(conf);
 				if (pp1->priority != oldpriority)
 					changed = 1;
 			}
@@ -1369,7 +1403,9 @@ int update_prio(struct path *pp, int refresh_all)
 		return changed;
 	}
 	oldpriority = pp->priority;
+	conf = get_multipath_config();
 	pathinfo(pp, conf, DI_PRIO);
+	put_multipath_config(conf);
 
 	if (pp->priority == oldpriority)
 		return 0;
@@ -1401,6 +1437,8 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	int add_active;
 	int disable_reinstate = 0;
 	int oldchkrstate = pp->chkrstate;
+	int retrigger_tries, checkint;
+	struct config *conf;
 
 	if ((pp->initialized == INIT_OK ||
 	     pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp)
@@ -1411,8 +1449,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (pp->tick)
 		return 0; /* don't check this path yet */
 
+	conf = get_multipath_config();
+	retrigger_tries = conf->retrigger_tries;
+	checkint = conf->checkint;
+	put_multipath_config(conf);
 	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV &&
-	    pp->retriggers < conf->retrigger_tries) {
+	    pp->retriggers < retrigger_tries) {
 		condlog(2, "%s: triggering change event to reinitialize",
 			pp->dev);
 		pp->initialized = INIT_REQUESTED_UDEV;
@@ -1426,7 +1468,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	 * provision a next check soonest,
 	 * in case we exit abnormaly from here
 	 */
-	pp->tick = conf->checkint;
+	pp->tick = checkint;
 
 	newstate = path_offline(pp);
 	/*
@@ -1437,24 +1479,30 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (newstate == PATH_REMOVED)
 		newstate = PATH_DOWN;
 
-	if (newstate == PATH_UP)
+	if (newstate == PATH_UP) {
+		conf = get_multipath_config();
 		newstate = get_state(pp, conf, 1);
-	else
+		put_multipath_config(conf);
+	} else
 		checker_clear_message(&pp->checker);
 
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
+		conf = get_multipath_config();
 		pathinfo(pp, conf, 0);
+		put_multipath_config(conf);
 		return 1;
 	}
 	if (!pp->mpp) {
 		if (!strlen(pp->wwid) && pp->initialized != INIT_MISSING_UDEV &&
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
 			condlog(2, "%s: add missing path", pp->dev);
+			conf = get_multipath_config();
 			if (pathinfo(pp, conf, DI_ALL) == 0) {
 				ev_add_path(pp, vecs);
 				pp->tick = 1;
 			}
+			put_multipath_config(conf);
 		}
 		return 0;
 	}
@@ -1510,7 +1558,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		 * upon state change, reset the checkint
 		 * to the shortest delay
 		 */
+		conf = get_multipath_config();
 		pp->checkint = conf->checkint;
+		put_multipath_config(conf);
 
 		if (newstate == PATH_DOWN || newstate == PATH_SHAKY) {
 			/*
@@ -1590,16 +1640,20 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 				return 0;
 			}
 		} else {
+			unsigned int max_checkint;
 			LOG_MSG(4, checker_message(&pp->checker));
-			if (pp->checkint != conf->max_checkint) {
+			conf = get_multipath_config();
+			max_checkint = conf->max_checkint;
+			put_multipath_config(conf);
+			if (pp->checkint != max_checkint) {
 				/*
 				 * double the next check delay.
 				 * max at conf->max_checkint
 				 */
-				if (pp->checkint < (conf->max_checkint / 2))
+				if (pp->checkint < (max_checkint / 2))
 					pp->checkint = 2 * pp->checkint;
 				else
-					pp->checkint = conf->max_checkint;
+					pp->checkint = max_checkint;
 
 				condlog(4, "%s: delay next check %is",
 					pp->dev_t, pp->checkint);
@@ -1611,7 +1665,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	}
 	else if (newstate == PATH_DOWN &&
 		 strlen(checker_message(&pp->checker))) {
-		if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
+		int log_checker_err;
+
+		conf = get_multipath_config();
+		log_checker_err = conf->log_checker_err;
+		put_multipath_config(conf);
+		if (log_checker_err == LOG_CHKR_ERR_ONCE)
 			LOG_MSG(3, checker_message(&pp->checker));
 		else
 			LOG_MSG(2, checker_message(&pp->checker));
@@ -1652,6 +1711,7 @@ checkerloop (void *ap)
 	unsigned int i;
 	struct itimerval timer_tick_it;
 	struct timeval last_time;
+	struct config *conf;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	vecs = (struct vectors *)ap;
@@ -1661,7 +1721,9 @@ checkerloop (void *ap)
 	 * init the path check interval
 	 */
 	vector_foreach_slot (vecs->pathvec, pp, i) {
+		conf = get_multipath_config();
 		pp->checkint = conf->checkint;
+		put_multipath_config(conf);
 	}
 
 	/* Tweak start time for initial path check */
@@ -1697,7 +1759,6 @@ checkerloop (void *ap)
 			condlog(4, "timeout waiting for DAEMON_IDLE");
 			continue;
 		}
-		strict_timing = conf->strict_timing;
 		if (vecs->pathvec) {
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(vecs->lock);
@@ -1733,10 +1794,15 @@ checkerloop (void *ap)
 		    gettimeofday(&end_time, NULL) == 0) {
 			timersub(&end_time, &start_time, &diff_time);
 			if (num_paths) {
+				unsigned int max_checkint;
+
 				condlog(3, "checked %d path%s in %lu.%06lu secs",
 					num_paths, num_paths > 1 ? "s" : "",
 					diff_time.tv_sec, diff_time.tv_usec);
-				if (diff_time.tv_sec > conf->max_checkint)
+				conf = get_multipath_config();
+				max_checkint = conf->max_checkint;
+				put_multipath_config(conf);
+				if (diff_time.tv_sec > max_checkint)
 					condlog(1, "path checkers took longer "
 						"than %lu seconds, consider "
 						"increasing max_polling_interval",
@@ -1745,6 +1811,9 @@ checkerloop (void *ap)
 		}
 
 		post_config_state(DAEMON_IDLE);
+		conf = get_multipath_config();
+		strict_timing = conf->strict_timing;
+		put_multipath_config(conf);
 		if (!strict_timing)
 			sleep(1);
 		else {
@@ -1768,7 +1837,9 @@ checkerloop (void *ap)
 			if (sigwait(&mask, &signo) != 0) {
 				condlog(3, "sigwait failed with error %d",
 					errno);
+				conf = get_multipath_config();
 				conf->strict_timing = 0;
+				put_multipath_config(conf);
 				break;
 			}
 		}
@@ -1783,6 +1854,7 @@ configure (struct vectors * vecs, int start_waiters)
 	struct path * pp;
 	vector mpvec;
 	int i, ret;
+	struct config *conf;
 
 	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc()))
 		return 1;
@@ -1801,6 +1873,7 @@ configure (struct vectors * vecs, int start_waiters)
 		return 1;
 
 	vector_foreach_slot (vecs->pathvec, pp, i){
+		conf = get_multipath_config();
 		if (filter_path(conf, pp) > 0){
 			vector_del_slot(vecs->pathvec, i);
 			free_path(pp);
@@ -1808,6 +1881,7 @@ configure (struct vectors * vecs, int start_waiters)
 		}
 		else
 			pp->checkint = conf->checkint;
+		put_multipath_config(conf);
 	}
 	if (map_discovery(vecs))
 		return 1;
@@ -1876,8 +1950,11 @@ need_to_delay_reconfig(struct vectors * vecs)
 int
 reconfigure (struct vectors * vecs)
 {
-	struct config * old = conf;
-	int retval = 1;
+	struct config * old, *conf;
+
+	conf = load_config(DEFAULT_CONFIGFILE);
+	if (!conf)
+		return 1;
 
 	/*
 	 * free old map and path vectors ... they use old conf state
@@ -1889,29 +1966,27 @@ reconfigure (struct vectors * vecs)
 		free_pathvec(vecs->pathvec, FREE_PATHS);
 
 	vecs->pathvec = NULL;
-	conf = NULL;
 
 	/* Re-read any timezone changes */
 	tzset();
 
-	if (!load_config(DEFAULT_CONFIGFILE)) {
-		dm_drv_version(conf->version, TGT_MPATH);
-		if (verbosity)
-			conf->verbosity = verbosity;
-		if (bindings_read_only)
-			conf->bindings_read_only = bindings_read_only;
-		if (ignore_new_devs)
-			conf->ignore_new_devs = ignore_new_devs;
-		configure(vecs, 1);
-		multipath_conf = conf;
-		free_config(old);
-		retval = 0;
-	} else {
-		conf = old;
-	}
+	dm_drv_version(conf->version, TGT_MPATH);
+	if (verbosity)
+		conf->verbosity = verbosity;
+	if (bindings_read_only)
+		conf->bindings_read_only = bindings_read_only;
+	if (ignore_new_devs)
+		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
 
-	return retval;
+	old = multipath_conf;
+	multipath_conf = conf;
+
+	configure(vecs, 1);
+
+	free_config(old);
+
+	return 0;
 }
 
 static struct vectors *
@@ -2097,6 +2172,7 @@ child (void * param)
 #endif
 	int rc;
 	int pid_fd = -1;
+	struct config *conf;
 	char *envp;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
@@ -2124,7 +2200,8 @@ child (void * param)
 	condlog(2, "--------start up--------");
 	condlog(2, "read " DEFAULT_CONFIGFILE);
 
-	if (load_config(DEFAULT_CONFIGFILE))
+	conf = load_config(DEFAULT_CONFIGFILE);
+	if (!conf)
 		goto failed;
 
 	if (verbosity)
@@ -2390,6 +2467,7 @@ main (int argc, char *argv[])
 	int arg;
 	int err;
 	int foreground = 0;
+	struct config *conf;
 
 	logsink = 1;
 
@@ -2425,7 +2503,8 @@ main (int argc, char *argv[])
 			logsink = -1;
 			break;
 		case 'k':
-			if (load_config(DEFAULT_CONFIGFILE))
+			conf = load_config(DEFAULT_CONFIGFILE);
+			if (!conf)
 				exit(1);
 			if (verbosity)
 				conf->verbosity = verbosity;
@@ -2448,7 +2527,8 @@ main (int argc, char *argv[])
 		char * s = cmd;
 		char * c = s;
 
-		if (load_config(DEFAULT_CONFIGFILE))
+		conf = load_config(DEFAULT_CONFIGFILE);
+		if (!conf)
 			exit(1);
 		if (verbosity)
 			conf->verbosity = verbosity;
-- 
2.6.6
