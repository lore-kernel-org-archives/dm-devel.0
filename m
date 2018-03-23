From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/2] multipath: fix rcu thread cancellation hang
Date: Fri, 23 Mar 2018 15:00:46 -0500
Message-ID: <1521835246-29080-3-git-send-email-bmarzins@redhat.com>
References: <1521835246-29080-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521835246-29080-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

While the rcu code is waiting for a grace period to elapse, no threads
can register or unregister as rcu reader threads. If for some reason, a
thread never calls put_multipath_config() to exit a read side critical
section, then any threads trying to start or stop will hang. This can
happen if a thread is cancelled between calls to get_multipath_config()
and put_multipath_config(), and multipathd is reconfigured (which causes
the rcu code to wait for a grace period).

This patch fixes this issue in two ways. Where possible, it reorders the
code or saves config values into local variables to remove cancellation
points between calls to get_multipath_config() and
put_multipath_config().  In cases where this isn't possible (or where it
would cause a significant amount of extra work to be done) multipath now
pushes a cleanup handler to call put_multipath_config().

The only functions that were not modified were ones that were only
called by multipath or mpathpersist, since these are single threaded
and already disable rcu thread registration.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h      |  2 +-
 libmultipath/configure.c   | 90 +++++++++++++++++++++++++++-------------------
 libmultipath/devmapper.c   | 10 ++++--
 libmultipath/discovery.c   | 13 ++++---
 libmultipath/parser.c      |  3 +-
 libmultipath/structs_vec.c |  9 +++--
 libmultipath/uevent.c      | 15 ++++----
 libmultipath/wwids.c       | 18 +++++-----
 mpathpersist/main.c        |  2 +-
 multipath/main.c           |  2 +-
 multipathd/cli_handlers.c  | 86 ++++++++++++++++++++++++++++----------------
 multipathd/main.c          | 57 ++++++++++++++++++-----------
 tests/globals.c            |  2 +-
 13 files changed, 193 insertions(+), 116 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index a20ac2a..329f3ed 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -232,6 +232,6 @@ struct config *load_config (char * file);
 struct config * alloc_config (void);
 void free_config (struct config * conf);
 extern struct config *get_multipath_config(void);
-extern void put_multipath_config(struct config *);
+extern void put_multipath_config(void *);
 
 #endif
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index fa6e21c..61f68f8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -288,6 +288,8 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	 * propsel.c if in doubt.
 	 */
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
+
 	select_pgfailback(conf, mpp);
 	select_pgpolicy(conf, mpp);
 	select_selector(conf, mpp);
@@ -316,7 +318,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
 	select_flush_on_last_del(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 
 	if (mpp->marginal_path_double_failed_time > 0 &&
 	    mpp->marginal_path_err_sample_time > 0 &&
@@ -742,14 +744,16 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
 	struct config *conf;
+	int verbosity;
 
 	/*
 	 * last chance to quit before touching the devmaps
 	 */
 	if (mpp->action == ACT_DRY_RUN) {
 		conf = get_multipath_config();
-		print_multipath_topology(mpp, conf->verbosity);
+		verbosity = conf->verbosity;
 		put_multipath_config(conf);
+		print_multipath_topology(mpp, verbosity);
 		return DOMAP_DRY;
 	}
 
@@ -807,16 +811,18 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 
 	case ACT_RENAME:
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		r = dm_rename(mpp->alias_old, mpp->alias,
 			      conf->partition_delim, mpp->skip_kpartx);
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 		break;
 
 	case ACT_FORCERENAME:
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		r = dm_rename(mpp->alias_old, mpp->alias,
 			      conf->partition_delim, mpp->skip_kpartx);
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 		if (r) {
 			sysfs_set_max_sectors_kb(mpp, 1);
 			if (mpp->ghost_delay_tick > 0 &&
@@ -952,17 +958,19 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		}
 	}
 	vector_foreach_slot (pathvec, pp1, k) {
+		int invalid = 0;
 		/* skip this path for some reason */
 
 		/* 1. if path has no unique id or wwid blacklisted */
 		conf = get_multipath_config();
-		if (strlen(pp1->wwid) == 0 ||
-		    filter_path(conf, pp1) > 0) {
-			put_multipath_config(conf);
+		pthread_cleanup_push(put_multipath_config, conf);
+		if (strlen(pp1->wwid) == 0 || filter_path(conf, pp1) > 0)
+			invalid = 1;
+		pthread_cleanup_pop(1);
+		if (invalid) {
 			orphan_path(pp1, "wwid blacklisted");
 			continue;
 		}
-		put_multipath_config(conf);
 
 		/* 2. if path already coalesced */
 		if (pp1->mpp)
@@ -1082,9 +1090,12 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		}
 
 		if (!is_daemon && mpp->action != ACT_NOTHING) {
+			int verbosity;
+
 			conf = get_multipath_config();
-			print_multipath_topology(mpp, conf->verbosity);
+			verbosity = conf->verbosity;
 			put_multipath_config(conf);
+			print_multipath_topology(mpp, verbosity);
 		}
 
 		if (newmp) {
@@ -1174,6 +1185,7 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	char * refwwid = NULL, tmpwwid[WWID_SIZE];
 	int flags = DI_SYSFS | DI_WWID;
 	struct config *conf;
+	int invalid = 0;
 
 	if (!wwid)
 		return 1;
@@ -1201,9 +1213,10 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 				return 1;
 
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -1213,12 +1226,13 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 			}
 		}
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0) {
-			put_multipath_config(conf);
+		    filter_property(conf, pp->udev) > 0)
+			invalid = 1;
+		pthread_cleanup_pop(1);
+		if (invalid)
 			return 2;
-		}
-		put_multipath_config(conf);
 
 		refwwid = pp->wwid;
 		goto out;
@@ -1239,9 +1253,10 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 				return 1;
 
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -1251,12 +1266,13 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 			}
 		}
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0) {
-			put_multipath_config(conf);
+		    filter_property(conf, pp->udev) > 0)
+			invalid = 1;
+		pthread_cleanup_pop(1);
+		if (invalid)
 			return 2;
-		}
-		put_multipath_config(conf);
 		refwwid = pp->wwid;
 		goto out;
 	}
@@ -1268,22 +1284,24 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 			return 1;
 
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		ret = store_pathinfo(pathvec, conf, udevice,
 				     flags, &pp);
+		pthread_cleanup_pop(1);
 		udev_device_unref(udevice);
 		if (!pp) {
 			if (ret == 1)
-				condlog(0, "%s: can't store path info",
-					dev);
-			put_multipath_config(conf);
+				condlog(0, "%s: can't store path info", dev);
 			return ret;
 		}
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0) {
-			put_multipath_config(conf);
+		    filter_property(conf, pp->udev) > 0)
+			invalid = 1;
+		pthread_cleanup_pop(1);
+		if (invalid)
 			return 2;
-		}
-		put_multipath_config(conf);
 		refwwid = pp->wwid;
 		goto out;
 	}
@@ -1291,6 +1309,7 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 	if (dev_type == DEV_DEVMAP) {
 
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		if (((dm_get_uuid(dev, tmpwwid)) == 0) && (strlen(tmpwwid))) {
 			refwwid = tmpwwid;
 			goto check;
@@ -1302,7 +1321,6 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 		if (get_user_friendly_wwid(dev, tmpwwid,
 					   conf->bindings_file) == 0) {
 			refwwid = tmpwwid;
-			put_multipath_config(conf);
 			goto check;
 		}
 
@@ -1318,14 +1336,13 @@ int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
 			refwwid = dev;
 
 check:
-		if (refwwid && strlen(refwwid)) {
-			if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
-					refwwid, NULL) > 0) {
-				put_multipath_config(conf);
-				return 2;
-			}
-		}
-		put_multipath_config(conf);
+		if (refwwid && strlen(refwwid) &&
+		    filter_wwid(conf->blist_wwid, conf->elist_wwid, refwwid,
+				NULL) > 0)
+			invalid = 1;
+		pthread_cleanup_pop(1);
+		if (invalid)
+			return 2;
 	}
 out:
 	if (refwwid && strlen(refwwid)) {
@@ -1347,8 +1364,9 @@ int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 	if (refresh) {
 		vector_foreach_slot (mpp->paths, pp, i) {
 			struct config *conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			r = pathinfo(pp, conf, DI_PRIO);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 			if (r) {
 				condlog(2, "%s: failed to refresh pathinfo",
 					mpp->alias);
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9bafbc6..2a92105 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -241,12 +241,16 @@ void libmp_udev_set_sync_support(int on)
 void libmp_dm_init(void)
 {
 	struct config *conf;
+	int verbosity;
+	unsigned int version[3];
 
 	conf = get_multipath_config();
-	dm_init(conf->verbosity);
-	if (dm_prereq(conf->version))
-		exit(1);
+	verbosity = conf->verbosity;
+	memcpy(version, conf->version, sizeof(version));
 	put_multipath_config(conf);
+	dm_init(verbosity);
+	if (dm_prereq(version))
+		exit(1);
 	dm_udev_set_sync_support(libmp_dm_udev_sync);
 }
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9f2a9c9..1ef1dfa 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -170,10 +170,11 @@ path_discovery (vector pathvec, int flag)
 		if(devtype && !strncmp(devtype, "disk", 4)) {
 			total_paths++;
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			if (path_discover(pathvec, conf,
 					  udevice, flag) == PATHINFO_OK)
 				num_paths++;
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 		}
 		udev_device_unref(udevice);
 	}
@@ -1617,6 +1618,7 @@ get_prio (struct path * pp)
 {
 	struct prio * p;
 	struct config *conf;
+	int checker_timeout;
 
 	if (!pp)
 		return 0;
@@ -1624,9 +1626,10 @@ get_prio (struct path * pp)
 	p = &pp->prio;
 	if (!prio_selected(p)) {
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		select_detect_prio(conf, pp);
 		select_prio(conf, pp);
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 		if (!prio_selected(p)) {
 			condlog(3, "%s: no prio selected", pp->dev);
 			pp->priority = PRIO_UNDEF;
@@ -1634,8 +1637,9 @@ get_prio (struct path * pp)
 		}
 	}
 	conf = get_multipath_config();
-	pp->priority = prio_getprio(p, pp, conf->checker_timeout);
+	checker_timeout = conf->checker_timeout;
 	put_multipath_config(conf);
+	pp->priority = prio_getprio(p, pp, checker_timeout);
 	if (pp->priority < 0) {
 		condlog(3, "%s: %s prio error", pp->dev, prio_name(p));
 		pp->priority = PRIO_UNDEF;
@@ -1849,8 +1853,9 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 
 	if (!pp->uid_attribute && !pp->getuid) {
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		select_getuid(conf, pp);
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 	}
 
 	memset(pp->wwid, 0, WWID_SIZE);
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 2f9ab6e..b8b7e0d 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -171,8 +171,9 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
 			break;
 		case 'v':
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			r = kw->print(conf, buff + fwd, len - fwd, data);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 			if (!r) { /* no output if no value */
 				buff[0] = '\0';
 				return 0;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8c8fb25..38f0438 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -71,9 +71,10 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 			    store_path(mpp->paths, pp))
 					return 1;
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			ret = pathinfo(pp, conf,
 				       DI_PRIO | DI_CHECKER);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 			if (ret)
 				return 1;
 		}
@@ -276,7 +277,10 @@ update_multipath_strings(struct multipath *mpp, vector pathvec, int is_daemon)
 
 void enter_recovery_mode(struct multipath *mpp)
 {
+	int checkint;
 	struct config *conf = get_multipath_config();
+	checkint = conf->checkint;
+	put_multipath_config(conf);
 
 	/*
 	 * Enter retry mode.
@@ -284,10 +288,9 @@ void enter_recovery_mode(struct multipath *mpp)
 	 * starting retry.
 	 */
 	mpp->stat_queueing_timeouts++;
-	mpp->retry_tick = mpp->no_path_retry * conf->checkint + 1;
+	mpp->retry_tick = mpp->no_path_retry * checkint + 1;
 	condlog(1, "%s: Entering recovery mode: max_retries=%d",
 		mpp->alias, mpp->no_path_retry);
-	put_multipath_config(conf);
 }
 
 void
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index c6a9e8b..3955c49 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -162,8 +162,9 @@ uevent_get_wwid(struct uevent *uev)
 	struct config * conf;
 
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, uev->kernel);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 
 	val = uevent_get_env_var(uev, uid_attribute);
 	if (val)
@@ -188,6 +189,7 @@ uevent_need_merge(void)
 bool
 uevent_can_discard(struct uevent *uev)
 {
+	int invalid = 0;
 	struct config * conf;
 
 	/*
@@ -199,13 +201,14 @@ uevent_can_discard(struct uevent *uev)
 	 * filter paths devices by devnode
 	 */
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0) {
-		put_multipath_config(conf);
-		return true;
-	}
-	put_multipath_config(conf);
+			   uev->kernel) > 0)
+		invalid = 1;
+	pthread_cleanup_pop(1);
 
+	if (invalid)
+		return true;
 	return false;
 }
 
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index bc70a27..0ec9f25 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -92,8 +92,9 @@ replace_wwids(vector mp)
 	struct config *conf;
 
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 	if (fd < 0)
 		goto out;
 	if (!can_write) {
@@ -206,8 +207,9 @@ remove_wwid(char *wwid) {
 	}
 	condlog(3, "removing line '%s' from wwids file", str);
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 	if (fd < 0)
 		goto out;
 	if (!can_write) {
@@ -231,8 +233,9 @@ check_wwids_file(char *wwid, int write_wwid)
 	struct config *conf;
 
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 	if (fd < 0)
 		return -1;
 
@@ -273,17 +276,16 @@ out:
 int
 should_multipath(struct path *pp1, vector pathvec)
 {
-	int i, ignore_new_devs;
+	int i, ignore_new_devs, find_multipaths;
 	struct path *pp2;
 	struct config *conf;
 
 	conf = get_multipath_config();
 	ignore_new_devs = conf->ignore_new_devs;
-	if (!conf->find_multipaths && !ignore_new_devs) {
-		put_multipath_config(conf);
-		return 1;
-	}
+	find_multipaths = conf->find_multipaths;
 	put_multipath_config(conf);
+	if (find_multipaths && !ignore_new_devs)
+		return 1;
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
 	if (!ignore_new_devs) {
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 79b89e5..983599a 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -47,7 +47,7 @@ struct config *get_multipath_config(void)
 	return multipath_conf;
 }
 
-void put_multipath_config(struct config *conf)
+void put_multipath_config(void * arg)
 {
 	/* Noop for now */
 }
diff --git a/multipath/main.c b/multipath/main.c
index 716203e..d08c688 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -70,7 +70,7 @@ struct config *get_multipath_config(void)
 	return multipath_conf;
 }
 
-void put_multipath_config(struct config *conf)
+void put_multipath_config(void *arg)
 {
 	/* Noop for now */
 }
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 60ec48b..568060d 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -252,14 +252,16 @@ show_config (char ** r, int * len)
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
 	struct config *conf;
+	int fail = 0;
 
 	c = reply = MALLOC(maxlen);
 
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	while (again) {
 		if (!reply) {
-			put_multipath_config(conf);
-			return 1;
+			fail = 1;
+			break;
 		}
 		c = reply;
 		c += snprint_defaults(conf, c, reply + maxlen - c);
@@ -296,7 +298,9 @@ show_config (char ** r, int * len)
 			REALLOC_REPLY(reply, again, maxlen);
 		}
 	}
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
+	if (fail)
+		return 1;
 	*r = reply;
 	*len = (int)(c - reply + 1);
 	return 0;
@@ -714,34 +718,37 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 	struct path *pp;
 	int r;
 	struct config *conf;
+	int invalid = 0;
 
 	param = convert_dev(param, 1);
 	condlog(2, "%s: add path (operator)", param);
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   param) > 0) {
-		put_multipath_config(conf);
+			   param) > 0)
+		invalid = 1;
+	pthread_cleanup_pop(1);
+	if (invalid)
 		goto blacklisted;
-	}
 
 	pp = find_path_by_dev(vecs->pathvec, param);
 	if (pp) {
 		condlog(2, "%s: path already in pathvec", param);
-		if (pp->mpp) {
-			put_multipath_config(conf);
+		if (pp->mpp)
 			return 0;
-		}
 	} else {
 		struct udev_device *udevice;
 
 		udevice = udev_device_new_from_subsystem_sysname(udev,
 								 "block",
 								 param);
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		r = store_pathinfo(vecs->pathvec, conf,
 				   udevice, DI_ALL, &pp);
+		pthread_cleanup_pop(1);
 		udev_device_unref(udevice);
 		if (!pp) {
-			put_multipath_config(conf);
 			if (r == 2)
 				goto blacklisted;
 			condlog(0, "%s: failed to store path info", param);
@@ -749,7 +756,6 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		}
 		pp->checkint = conf->checkint;
 	}
-	put_multipath_config(conf);
 	return ev_add_path(pp, vecs, 1);
 blacklisted:
 	*reply = strdup("blacklisted\n");
@@ -785,19 +791,22 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	char *refwwid, *alias = NULL;
 	int rc, count = 0;
 	struct config *conf;
+	int invalid = 0;
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: add map (operator)", param);
 
 	conf = get_multipath_config();
-	if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param, NULL) > 0) {
-		put_multipath_config(conf);
+	pthread_cleanup_push(put_multipath_config, conf);
+	if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param, NULL) > 0)
+		invalid = 1;
+	pthread_cleanup_pop(1);
+	if (invalid) {
 		*reply = strdup("blacklisted\n");
 		*len = strlen(*reply) + 1;
 		condlog(2, "%s: map blacklisted", param);
 		return 1;
 	}
-	put_multipath_config(conf);
 	do {
 		if (dm_get_major_minor(param, &major, &minor) < 0)
 			condlog(2, "%s: not a device mapper table", param);
@@ -975,9 +984,10 @@ cli_resize(void *v, char **reply, int *len, void *data)
 int
 cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
 {
-	struct config *conf = get_multipath_config();
+	struct config *conf;
 
 	condlog(2, "force queue_without_daemon (operator)");
+	conf = get_multipath_config();
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
 		conf->queue_without_daemon = QUE_NO_DAEMON_FORCE;
 	put_multipath_config(conf);
@@ -987,9 +997,10 @@ cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
 int
 cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
 {
-	struct config *conf = get_multipath_config();
+	struct config *conf;
 
 	condlog(2, "restore queue_without_daemon (operator)");
+	conf = get_multipath_config();
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_FORCE)
 		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
 	put_multipath_config(conf);
@@ -1017,10 +1028,11 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	conf = get_multipath_config();
 	mpp->disable_queueing = 0;
+	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	select_no_path_retry(conf, mpp);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 			mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
@@ -1044,10 +1056,11 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 
 	condlog(2, "restore queueing (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		struct config *conf = get_multipath_config();
 		mpp->disable_queueing = 0;
+		struct config *conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		select_no_path_retry(conf, mpp);
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 		    mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
 			dm_queue_if_no_path(mpp->alias, 1);
@@ -1279,14 +1292,17 @@ show_blacklist (char ** r, int * len)
 	char *reply = NULL;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
-	struct config *conf = get_multipath_config();
+	struct config *conf;
+	int fail = 0;
 
 	reply = MALLOC(maxlen);
 
+	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	while (again) {
 		if (!reply) {
-			put_multipath_config(conf);
-			return 1;
+			fail = 1;
+			break;
 		}
 
 		c = reply;
@@ -1294,11 +1310,12 @@ show_blacklist (char ** r, int * len)
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 	}
+	pthread_cleanup_pop(1);
 
+	if (fail)
+		return 1;
 	*r = reply;
 	*len = (int)(c - reply + 1);
-	put_multipath_config(conf);
-
 	return 0;
 }
 
@@ -1317,14 +1334,17 @@ show_devices (char ** r, int * len, struct vectors *vecs)
 	char *reply = NULL;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
-	struct config *conf = get_multipath_config();
+	struct config *conf;
+	int fail = 0;
 
 	reply = MALLOC(maxlen);
 
+	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	while (again) {
 		if (!reply) {
-			put_multipath_config(conf);
-			return 1;
+			fail = 1;
+			break;
 		}
 
 		c = reply;
@@ -1332,10 +1352,12 @@ show_devices (char ** r, int * len, struct vectors *vecs)
 		again = ((c - reply) == maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 	}
+	pthread_cleanup_pop(1);
 
+	if (fail)
+		return 1;
 	*r = reply;
 	*len = (int)(c - reply + 1);
-	put_multipath_config(conf);
 
 	return 0;
 }
@@ -1479,8 +1501,9 @@ cli_unsetprkey(void * v, char ** reply, int * len, void * data)
 		return 1;
 
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	ret = set_prkey(conf, mpp, 0);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 
 	return ret;
 }
@@ -1509,8 +1532,9 @@ cli_setprkey(void * v, char ** reply, int * len, void * data)
 	}
 
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	ret = set_prkey(conf, mpp, prkey);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 
 	return ret;
 }
diff --git a/multipathd/main.c b/multipathd/main.c
index eccb046..9a4f671 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -246,7 +246,7 @@ struct config *get_multipath_config(void)
 	return rcu_dereference(multipath_conf);
 }
 
-void put_multipath_config(struct config *conf)
+void put_multipath_config(void *arg)
 {
 	rcu_read_unlock();
 }
@@ -270,8 +270,10 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 		vector_foreach_slot (mpp->pg, pgp, i) {
 			vector_foreach_slot (pgp->paths, pp, j) {
 				conf = get_multipath_config();
+				pthread_cleanup_push(put_multipath_config,
+						     conf);
 				pathinfo(pp, conf, DI_PRIO);
-				put_multipath_config(conf);
+				pthread_cleanup_pop(1);
 			}
 		}
 	}
@@ -430,6 +432,11 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 			if (pp->state != PATH_DOWN) {
 				struct config *conf = get_multipath_config();
 				int oldstate = pp->state;
+				int checkint;
+
+				conf = get_multipath_config();
+				checkint = conf->checkint;
+				put_multipath_config(conf);
 				condlog(2, "%s: mark as failed", pp->dev);
 				mpp->stat_path_failures++;
 				pp->state = PATH_DOWN;
@@ -441,9 +448,8 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 				 * if opportune,
 				 * schedule the next check earlier
 				 */
-				if (pp->tick > conf->checkint)
-					pp->tick = conf->checkint;
-				put_multipath_config(conf);
+				if (pp->tick > checkint)
+					pp->tick = checkint;
 			}
 		}
 	}
@@ -821,9 +827,10 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			r = pathinfo(pp, conf,
 				     DI_ALL | DI_BLACKLIST);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 			if (r == PATHINFO_OK)
 				ret = ev_add_path(pp, vecs, need_do_map);
 			else if (r == PATHINFO_SKIPPED) {
@@ -848,9 +855,10 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 	 * get path vital state
 	 */
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	ret = alloc_path_with_pathinfo(conf, uev->udev,
 				       uev->wwid, DI_ALL, &pp);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 	if (!pp) {
 		if (ret == PATHINFO_SKIPPED)
 			return 0;
@@ -1215,10 +1223,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) != PATHINFO_OK)
 				condlog(1, "%s: pathinfo failed after change uevent",
 					uev->kernel);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 		}
 
 		if (pp->initialized == INIT_REQUESTED_UDEV)
@@ -1246,8 +1255,9 @@ out:
 			int flag = DI_SYSFS | DI_WWID;
 
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			retval = alloc_path_with_pathinfo(conf, uev->udev, uev->wwid, flag, NULL);
-			put_multipath_config(conf);
+			pthread_cleanup_pop(1);
 
 			if (retval == PATHINFO_SKIPPED) {
 				condlog(3, "%s: spurious uevent, path is blacklisted", uev->kernel);
@@ -1739,8 +1749,10 @@ int update_prio(struct path *pp, int refresh_all)
 			vector_foreach_slot (pgp->paths, pp1, j) {
 				oldpriority = pp1->priority;
 				conf = get_multipath_config();
+				pthread_cleanup_push(put_multipath_config,
+						     conf);
 				pathinfo(pp1, conf, DI_PRIO);
-				put_multipath_config(conf);
+				pthread_cleanup_pop(1);
 				if (pp1->priority != oldpriority)
 					changed = 1;
 			}
@@ -1749,9 +1761,10 @@ int update_prio(struct path *pp, int refresh_all)
 	}
 	oldpriority = pp->priority;
 	conf = get_multipath_config();
+	pthread_cleanup_push(put_multipath_config, conf);
 	if (pp->state != PATH_DOWN)
 		pathinfo(pp, conf, DI_PRIO);
-	put_multipath_config(conf);
+	pthread_cleanup_pop(1);
 
 	if (pp->priority == oldpriority)
 		return 0;
@@ -1838,8 +1851,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 
 	if (newstate == PATH_UP) {
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		newstate = get_state(pp, conf, 1, newstate);
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 	} else
 		checker_clear_message(&pp->checker);
 
@@ -1852,8 +1866,9 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		pathinfo(pp, conf, 0);
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 		return 1;
 	}
 	if (!pp->mpp) {
@@ -1861,15 +1876,14 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
 			condlog(2, "%s: add missing path", pp->dev);
 			conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
 			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
+			pthread_cleanup_pop(1);
 			if (ret == PATHINFO_OK) {
 				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
-			} else if (ret == PATHINFO_SKIPPED) {
-				put_multipath_config(conf);
+			} else if (ret == PATHINFO_SKIPPED)
 				return -1;
-			}
-			put_multipath_config(conf);
 		}
 		return 0;
 	}
@@ -2268,6 +2282,7 @@ configure (struct vectors * vecs)
 
 	vector_foreach_slot (vecs->pathvec, pp, i){
 		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
 		if (filter_path(conf, pp) > 0){
 			vector_del_slot(vecs->pathvec, i);
 			free_path(pp);
@@ -2275,7 +2290,7 @@ configure (struct vectors * vecs)
 		}
 		else
 			pp->checkint = conf->checkint;
-		put_multipath_config(conf);
+		pthread_cleanup_pop(1);
 	}
 	if (map_discovery(vecs)) {
 		condlog(0, "configure failed at map discovery");
@@ -2587,6 +2602,7 @@ child (void * param)
 	int pid_fd = -1;
 	struct config *conf;
 	char *envp;
+	int queue_without_daemon;
 
 	mlockall(MCL_CURRENT | MCL_FUTURE);
 	signal_init();
@@ -2778,10 +2794,11 @@ child (void * param)
 
 	lock(&vecs->lock);
 	conf = get_multipath_config();
-	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
+	queue_without_daemon = conf->queue_without_daemon;
+	put_multipath_config(conf);
+	if (queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
-	put_multipath_config(conf);
 	remove_maps_and_stop_waiters(vecs);
 	unlock(&vecs->lock);
 
diff --git a/tests/globals.c b/tests/globals.c
index 80f57bd..07d970e 100644
--- a/tests/globals.c
+++ b/tests/globals.c
@@ -14,5 +14,5 @@ struct config *get_multipath_config(void)
 	return &conf;
 }
 
-void put_multipath_config(struct config* c)
+void put_multipath_config(void *arg)
 {}
-- 
2.7.4
