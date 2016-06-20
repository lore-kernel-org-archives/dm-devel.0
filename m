From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/26] libmultipath: use (get,
	put)_multipath_config() accessors
Date: Mon, 20 Jun 2016 10:09:09 +0200
Message-ID: <1466410153-23896-23-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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

Use (get,put)_multipath_config() accessors to mark accesses
to the configuration.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c |  4 +--
 libmultipath/config.h           |  2 ++
 libmultipath/configure.c        | 71 +++++++++++++++++++++++++++++++++++------
 libmultipath/debug.c            |  3 ++
 libmultipath/discovery.c        | 28 +++++++++++++---
 libmultipath/discovery.h        |  2 +-
 libmultipath/parser.c           |  3 ++
 libmultipath/structs_vec.c      | 27 ++++++++++++++--
 libmultipath/wwids.c            | 22 +++++++++++--
 mpathpersist/main.c             | 12 +++++++
 multipath/main.c                | 14 +++++++-
 multipathd/cli_handlers.c       | 52 +++++++++++++++++++++++++-----
 multipathd/main.c               | 17 ++++++++--
 multipathd/uxlsnr.c             |  5 ---
 14 files changed, 222 insertions(+), 40 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 1c51397..c1f811a 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -203,7 +203,7 @@ int mpath_persistent_reserve_in (int fd, int rq_servact,
 		goto out;
 	}
 
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER) < 0) {
+	if (path_discovery(pathvec, DI_SYSFS | DI_CHECKER) < 0) {
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}
@@ -297,7 +297,7 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 		goto out;
 	}
 
-	if (path_discovery(pathvec, conf, DI_SYSFS | DI_CHECKER) < 0) {
+	if (path_discovery(pathvec, DI_SYSFS | DI_CHECKER) < 0) {
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out1;
 	}
diff --git a/libmultipath/config.h b/libmultipath/config.h
index c8f2c32..28904ff 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -192,5 +192,7 @@ int store_hwe (vector hwtable, struct hwentry *);
 int load_config (char * file);
 struct config * alloc_config (void);
 void free_config (struct config * conf);
+extern struct config *get_multipath_config(void);
+extern void put_multipath_config(struct config *);
 
 #endif
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 755288f..90062a5 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -257,6 +257,7 @@ extern int
 setup_map (struct multipath * mpp, char * params, int params_size)
 {
 	struct pathgroup * pgp;
+	struct config *conf;
 	int i;
 
 	/*
@@ -275,6 +276,7 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	/*
 	 * properties selectors
 	 */
+	conf = get_multipath_config();
 	select_pgfailback(conf, mpp);
 	select_pgpolicy(conf, mpp);
 	select_selector(conf, mpp);
@@ -295,6 +297,7 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_delay_wait_checks(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
+	put_multipath_config(conf);
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
@@ -582,12 +585,15 @@ extern int
 domap (struct multipath * mpp, char * params, int is_daemon)
 {
 	int r = DOMAP_FAIL;
+	struct config *conf;
 
 	/*
 	 * last chance to quit before touching the devmaps
 	 */
 	if (mpp->action == ACT_DRY_RUN) {
+		conf = get_multipath_config();
 		print_multipath_topology(mpp, conf->verbosity);
+		put_multipath_config(conf);
 		return DOMAP_DRY;
 	}
 
@@ -633,13 +639,17 @@ domap (struct multipath * mpp, char * params, int is_daemon)
 		break;
 
 	case ACT_RENAME:
+		conf = get_multipath_config();
 		r = dm_rename(mpp->alias_old, mpp->alias,
 			      conf->partition_delim);
+		put_multipath_config(conf);
 		break;
 
 	case ACT_FORCERENAME:
+		conf = get_multipath_config();
 		r = dm_rename(mpp->alias_old, mpp->alias,
 			      conf->partition_delim);
+		put_multipath_config(conf);
 		if (r)
 			r = dm_addmap_reload(mpp, params, 0);
 		break;
@@ -671,8 +681,10 @@ domap (struct multipath * mpp, char * params, int is_daemon)
 			if (mpp->action != ACT_CREATE)
 				mpp->action = ACT_NOTHING;
 			else {
+				conf = get_multipath_config();
 				mpp->wait_for_udev = 1;
 				mpp->uev_wait_tick = conf->uev_wait_timeout;
+				put_multipath_config(conf);
 			}
 		}
 		dm_setgeometry(mpp);
@@ -708,6 +720,8 @@ int check_daemon(void)
 	int fd;
 	char *reply;
 	int ret = 0;
+	unsigned int timeout;
+	struct config *conf;
 
 	fd = mpath_connect();
 	if (fd == -1)
@@ -715,7 +729,10 @@ int check_daemon(void)
 
 	if (send_packet(fd, "show daemon") != 0)
 		goto out;
-	if (recv_packet(fd, &reply, conf->uxsock_timeout) != 0)
+	conf = get_multipath_config();
+	timeout = conf->uxsock_timeout;
+	put_multipath_config(conf);
+	if (recv_packet(fd, &reply, timeout) != 0)
 		goto out;
 
 	if (strstr(reply, "shutdown"))
@@ -742,6 +759,8 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 	struct path * pp2;
 	vector curmp = vecs->mpvec;
 	vector pathvec = vecs->pathvec;
+	struct config *conf;
+	int allow_queueing;
 
 	/* ignore refwwid if it's empty */
 	if (refwwid && !strlen(refwwid))
@@ -756,11 +775,14 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		/* skip this path for some reason */
 
 		/* 1. if path has no unique id or wwid blacklisted */
+		conf = get_multipath_config();
 		if (strlen(pp1->wwid) == 0 ||
 		    filter_path(conf, pp1) > 0) {
+			put_multipath_config(conf);
 			orphan_path(pp1, "wwid blacklisted");
 			continue;
 		}
+		put_multipath_config(conf);
 
 		/* 2. if path already coalesced */
 		if (pp1->mpp)
@@ -851,7 +873,10 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		if (r == DOMAP_DRY)
 			continue;
 
-		if (!is_daemon && !conf->allow_queueing && !check_daemon()) {
+		conf = get_multipath_config();
+		allow_queueing = conf->allow_queueing;
+		put_multipath_config(conf);
+		if (!is_daemon && !allow_queueing && !check_daemon()) {
 			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
 				condlog(3, "%s: multipathd not running, unset "
@@ -876,8 +901,11 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			}
 		}
 
-		if (!is_daemon && mpp->action != ACT_NOTHING)
+		if (!is_daemon && mpp->action != ACT_NOTHING) {
+			conf = get_multipath_config();
 			print_multipath_topology(mpp, conf->verbosity);
+			put_multipath_config(conf);
+		}
 
 		if (newmp) {
 			if (mpp->action != ACT_REJECT) {
@@ -933,6 +961,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 	char buff[FILE_NAME_SIZE];
 	char * refwwid = NULL, tmpwwid[WWID_SIZE];
 	int flags = DI_SYSFS | DI_WWID;
+	struct config *conf;
 
 	if (!wwid)
 		return 1;
@@ -959,8 +988,10 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 				condlog(2, "%s: can't get udev device", buff);
 				return 1;
 			}
+			conf = get_multipath_config();
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
+			put_multipath_config(conf);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -969,9 +1000,13 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 				return ret;
 			}
 		}
+		conf = get_multipath_config();
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0)
+		    filter_property(conf, pp->udev) > 0) {
+			put_multipath_config(conf);
 			return 2;
+		}
+		put_multipath_config(conf);
 
 		refwwid = pp->wwid;
 		goto out;
@@ -991,8 +1026,10 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 				condlog(2, "%s: can't get udev device", dev);
 				return 1;
 			}
+			conf = get_multipath_config();
 			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
+			put_multipath_config(conf);
 			udev_device_unref(udevice);
 			if (!pp) {
 				if (ret == 1)
@@ -1001,10 +1038,13 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 				return ret;
 			}
 		}
+		conf = get_multipath_config();
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0)
+		    filter_property(conf, pp->udev) > 0) {
+			put_multipath_config(conf);
 			return 2;
-
+		}
+		put_multipath_config(conf);
 		refwwid = pp->wwid;
 		goto out;
 	}
@@ -1016,6 +1056,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 			condlog(2, "%s: can't get udev device", dev);
 			return 1;
 		}
+		conf = get_multipath_config();
 		ret = store_pathinfo(pathvec, conf, udevice,
 				     flags, &pp);
 		udev_device_unref(udevice);
@@ -1023,18 +1064,22 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 			if (ret == 1)
 				condlog(0, "%s: can't store path info",
 					dev);
+			put_multipath_config(conf);
 			return ret;
 		}
 		if (pp->udev && pp->uid_attribute &&
-		    filter_property(conf, pp->udev) > 0)
+		    filter_property(conf, pp->udev) > 0) {
+			put_multipath_config(conf);
 			return 2;
-
+		}
+		put_multipath_config(conf);
 		refwwid = pp->wwid;
 		goto out;
 	}
 
 	if (dev_type == DEV_DEVMAP) {
 
+		conf = get_multipath_config();
 		if (((dm_get_uuid(dev, tmpwwid)) == 0) && (strlen(tmpwwid))) {
 			refwwid = tmpwwid;
 			goto check;
@@ -1046,6 +1091,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 		if (get_user_friendly_wwid(dev, tmpwwid,
 					   conf->bindings_file) == 0) {
 			refwwid = tmpwwid;
+			put_multipath_config(conf);
 			goto check;
 		}
 
@@ -1063,9 +1109,12 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 check:
 		if (refwwid && strlen(refwwid)) {
 			if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
-					refwwid, NULL) > 0)
-			return 2;
+					refwwid, NULL) > 0) {
+				put_multipath_config(conf);
+				return 2;
+			}
 		}
+		put_multipath_config(conf);
 	}
 out:
 	if (refwwid && strlen(refwwid)) {
@@ -1085,7 +1134,9 @@ extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 	update_mpp_paths(mpp, vecs->pathvec);
 	if (refresh) {
 		vector_foreach_slot (mpp->paths, pp, i) {
+			struct config *conf = get_multipath_config();
 			r = pathinfo(pp, conf, DI_PRIO);
+			put_multipath_config(conf);
 			if (r) {
 				condlog(2, "%s: failed to refresh pathinfo",
 					mpp->alias);
diff --git a/libmultipath/debug.c b/libmultipath/debug.c
index bad78a8..b2e344d 100644
--- a/libmultipath/debug.c
+++ b/libmultipath/debug.c
@@ -16,9 +16,12 @@ void dlog (int sink, int prio, const char * fmt, ...)
 {
 	va_list ap;
 	int thres;
+	struct config *conf;
 
 	va_start(ap, fmt);
+	conf = get_multipath_config();
 	thres = (conf) ? conf->verbosity : 0;
+	put_multipath_config(conf);
 
 	if (prio <= thres) {
 		if (sink < 1) {
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0cdcd77..d5215f9 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -133,11 +133,12 @@ path_discover (vector pathvec, struct config * conf,
 }
 
 int
-path_discovery (vector pathvec, struct config * conf, int flag)
+path_discovery (vector pathvec, int flag)
 {
 	struct udev_enumerate *udev_iter;
 	struct udev_list_entry *entry;
 	struct udev_device *udevice;
+	struct config *conf;
 	const char *devpath;
 	int num_paths = 0, total_paths = 0;
 
@@ -162,9 +163,11 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 		devtype = udev_device_get_devtype(udevice);
 		if(devtype && !strncmp(devtype, "disk", 4)) {
 			total_paths++;
+			conf = get_multipath_config();
 			if (path_discover(pathvec, conf,
 					  udevice, flag) == PATHINFO_OK)
 				num_paths++;
+			put_multipath_config(conf);
 		}
 		udev_device_unref(udevice);
 	}
@@ -1445,21 +1448,27 @@ get_state (struct path * pp, struct config *conf)
 static int
 get_prio (struct path * pp)
 {
+	struct prio * p;
+	struct config *conf;
+
 	if (!pp)
 		return 0;
 
-	struct prio * p = &pp->prio;
-
+	p = &pp->prio;
 	if (!prio_selected(p)) {
+		conf = get_multipath_config();
 		select_detect_prio(conf, pp);
 		select_prio(conf, pp);
+		put_multipath_config(conf);
 		if (!prio_selected(p)) {
 			condlog(3, "%s: no prio selected", pp->dev);
 			pp->priority = PRIO_UNDEF;
 			return 1;
 		}
 	}
+	conf = get_multipath_config();
 	pp->priority = prio_getprio(p, pp, conf->checker_timeout);
+	put_multipath_config(conf);
 	if (pp->priority < 0) {
 		condlog(3, "%s: %s prio error", pp->dev, prio_name(p));
 		pp->priority = PRIO_UNDEF;
@@ -1517,9 +1526,13 @@ get_uid (struct path * pp, int path_state)
 	char *c;
 	const char *origin = "unknown";
 	ssize_t len = 0;
+	struct config *conf;
 
-	if (!pp->uid_attribute && !pp->getuid)
+	if (!pp->uid_attribute && !pp->getuid) {
+		conf = get_multipath_config();
 		select_getuid(conf, pp);
+		put_multipath_config(conf);
+	}
 
 	if (!pp->udev) {
 		condlog(1, "%s: no udev information", pp->dev);
@@ -1545,6 +1558,8 @@ get_uid (struct path * pp, int path_state)
 			len = strlen(pp->wwid);
 		origin = "callout";
 	} else {
+		int retrigger;
+
 		if (pp->uid_attribute) {
 			len = get_udev_uid(pp, pp->uid_attribute);
 			origin = "udev";
@@ -1554,7 +1569,10 @@ get_uid (struct path * pp, int path_state)
 					pp->dev, strerror(-len));
 
 		}
-		if (len <= 0 && pp->retriggers >= conf->retrigger_tries &&
+		conf = get_multipath_config();
+		retrigger = conf->retrigger_tries;
+		put_multipath_config(conf);
+		if (len <= 0 && pp->retriggers >= retrigger &&
 		    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
 			len = get_vpd_uid(pp);
 			origin = "sysfs";
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index cfbc46c..1af75f1 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -30,7 +30,7 @@
 
 struct config;
 
-int path_discovery (vector pathvec, struct config * conf, int flag);
+int path_discovery (vector pathvec, int flag);
 
 int do_tur (char *);
 int path_offline (struct path *);
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 96bc872..82ce01c 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -164,6 +164,7 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw, void *data)
 	int r;
 	int fwd = 0;
 	char *f = fmt;
+	struct config *conf;
 
 	if (!kw || !kw->print)
 		return 0;
@@ -182,7 +183,9 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw, void *data)
 			fwd += snprintf(buff + fwd, len - fwd, "%s", kw->string);
 			break;
 		case 'v':
+			conf = get_multipath_config();
 			r = kw->print(conf, buff + fwd, len - fwd, data);
+			put_multipath_config(conf);
 			if (!r) { /* no output if no value */
 				buff = '\0';
 				return 0;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 11db3ae..de97b48 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -48,8 +48,9 @@ update_mpp_paths(struct multipath * mpp, vector pathvec)
 extern int
 adopt_paths (vector pathvec, struct multipath * mpp)
 {
-	int i;
+	int i, ret;
 	struct path * pp;
+	struct config *conf;
 
 	if (!mpp)
 		return 0;
@@ -69,8 +70,11 @@ adopt_paths (vector pathvec, struct multipath * mpp)
 			if (!find_path_by_dev(mpp->paths, pp->dev) &&
 			    store_path(mpp->paths, pp))
 					return 1;
-			if (pathinfo(pp, conf,
-				     DI_PRIO | DI_CHECKER))
+			conf = get_multipath_config();
+			ret = pathinfo(pp, conf,
+				       DI_PRIO | DI_CHECKER);
+			put_multipath_config(conf);
+			if (ret)
 				return 1;
 		}
 	}
@@ -237,9 +241,12 @@ extract_hwe_from_path(struct multipath * mpp)
 		condlog(3, "%s: product = %s", pp->dev, pp->product_id);
 		condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 		if (!pp->hwe) {
+			struct config *conf = get_multipath_config();
+
 			condlog(3, "searching hwtable");
 			pp->hwe = find_hwe(conf->hwtable, pp->vendor_id,
 					   pp->product_id, pp->rev);
+			put_multipath_config(conf);
 		}
 	}
 
@@ -355,10 +362,12 @@ set_no_path_retry(struct config *conf, struct multipath *mpp)
 	default:
 		dm_queue_if_no_path(mpp->alias, 1);
 		if (mpp->nr_active == 0) {
+			struct config *conf = get_multipath_config();
 			/* Enter retry mode */
 			mpp->retry_tick = mpp->no_path_retry * conf->checkint;
 			condlog(1, "%s: Entering recovery mode: max_retries=%d",
 				mpp->alias, mpp->no_path_retry);
+			put_multipath_config(conf);
 		}
 		break;
 	}
@@ -368,6 +377,8 @@ extern int
 __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 		   int reset, int is_daemon)
 {
+	struct config *conf;
+
 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		/* Error accessing table */
 		condlog(3, "%s: cannot access table", mpp->alias);
@@ -386,7 +397,9 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp,
 	}
 
 	set_multipath_wwid(mpp);
+	conf = get_multipath_config();
 	mpp->mpe = find_mpe(conf->hwtable, mpp->wwid);
+	put_multipath_config(conf);
 	condlog(3, "%s: discover", mpp->alias);
 
 	if (!mpp->hwe)
@@ -463,6 +476,7 @@ add_map_with_path (struct vectors * vecs,
 		   struct path * pp, int add_vec)
 {
 	struct multipath * mpp;
+	struct config *conf = NULL;
 
 	if (!strlen(pp->wwid))
 		return NULL;
@@ -470,8 +484,10 @@ add_map_with_path (struct vectors * vecs,
 	if (!(mpp = alloc_multipath()))
 		return NULL;
 
+	conf = get_multipath_config();
 	mpp->mpe = find_mpe(conf->hwtable, pp->wwid);
 	mpp->hwe = pp->hwe;
+	put_multipath_config(conf);
 
 	strcpy(mpp->wwid, pp->wwid);
 	find_existing_alias(mpp, vecs);
@@ -561,6 +577,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 				continue;
 
 			if (pp->state != PATH_DOWN) {
+				struct config *conf = get_multipath_config();
 				int oldstate = pp->state;
 				condlog(2, "%s: mark as failed", pp->dev);
 				mpp->stat_path_failures++;
@@ -575,6 +592,7 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 				 */
 				if (pp->tick > conf->checkint)
 					pp->tick = conf->checkint;
+				put_multipath_config(conf);
 			}
 		}
 	}
@@ -591,6 +609,8 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 void update_queue_mode_del_path(struct multipath *mpp)
 {
 	if (--mpp->nr_active == 0 && mpp->no_path_retry > 0) {
+		struct config *conf = get_multipath_config();
+
 		/*
 		 * Enter retry mode.
 		 * meaning of +1: retry_tick may be decremented in
@@ -600,6 +620,7 @@ void update_queue_mode_del_path(struct multipath *mpp)
 		mpp->retry_tick = mpp->no_path_retry * conf->checkint + 1;
 		condlog(1, "%s: Entering recovery mode: max_retries=%d",
 			mpp->alias, mpp->no_path_retry);
+		put_multipath_config(conf);
 	}
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
 }
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 567c93d..a7c3249 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -89,8 +89,11 @@ replace_wwids(vector mp)
 	struct multipath * mpp;
 	size_t len;
 	int ret = -1;
+	struct config *conf;
 
+	conf = get_multipath_config();
 	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
+	put_multipath_config(conf);
 	if (fd < 0)
 		goto out;
 	if (!can_write) {
@@ -188,6 +191,7 @@ remove_wwid(char *wwid) {
 	int fd, len, can_write;
 	char *str;
 	int ret = -1;
+	struct config *conf;
 
 	len = strlen(wwid) + 4; /* two slashes the newline and a zero byte */
 	str = malloc(len);
@@ -201,7 +205,9 @@ remove_wwid(char *wwid) {
 		goto out;
 	}
 	condlog(3, "removing line '%s' from wwids file", str);
+	conf = get_multipath_config();
 	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
+	put_multipath_config(conf);
 	if (fd < 0)
 		goto out;
 	if (!can_write) {
@@ -222,7 +228,11 @@ check_wwids_file(char *wwid, int write_wwid)
 {
 	int fd, can_write, found, ret;
 	FILE *f;
+	struct config *conf;
+
+	conf = get_multipath_config();
 	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
+	put_multipath_config(conf);
 	if (fd < 0)
 		return -1;
 
@@ -263,14 +273,20 @@ out:
 int
 should_multipath(struct path *pp1, vector pathvec)
 {
-	int i;
+	int i, ignore_new_devs;;
 	struct path *pp2;
+	struct config *conf;
 
-	if (!conf->find_multipaths && !conf->ignore_new_devs)
+	conf = get_multipath_config();
+	ignore_new_devs = conf->ignore_new_devs;
+	if (!conf->find_multipaths && !ignore_new_devs) {
+		put_multipath_config(conf);
 		return 1;
+	}
+	put_multipath_config(conf);
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
-	if (!conf->ignore_new_devs) {
+	if (!ignore_new_devs) {
 		vector_foreach_slot(pathvec, pp2, i) {
 			if (pp1->dev == pp2->dev)
 				continue;
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 5194511..6c1c5e7 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -41,6 +41,17 @@ int construct_transportid(const char * inp, struct transportid transid[], int nu
 
 int logsink;
 unsigned int mpath_mx_alloc_len;
+struct config *multipath_conf;
+
+struct config *get_multipath_config(void)
+{
+	return multipath_conf;
+}
+
+void put_multipath_config(struct config *conf)
+{
+	/* Noop for now */
+}
 
 int main (int argc, char * argv[])
 {
@@ -90,6 +101,7 @@ int main (int argc, char * argv[])
 	udev = udev_new();
 	mpath_lib_init(udev);
 	memset(transportids,0,MPATH_MX_TIDS);
+	multipath_conf = conf;
 
 	while (1)
 	{
diff --git a/multipath/main.c b/multipath/main.c
index 0d95572..40b7a76 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -61,6 +61,17 @@
 
 int logsink;
 struct udev *udev;
+struct config *multipath_conf;
+
+struct config *get_multipath_config(void)
+{
+	return multipath_conf;
+}
+
+void put_multipath_config(struct config *conf)
+{
+	/* Noop for now */
+}
 
 static int
 filter_pathvec (vector pathvec, char * refwwid)
@@ -346,7 +357,7 @@ configure (enum mpath_cmds cmd, enum devtypes dev_type, char *devpath)
 		/* maximum info */
 		di_flag = DI_ALL;
 
-	if (path_discovery(pathvec, conf, di_flag) < 0)
+	if (path_discovery(pathvec, di_flag) < 0)
 		goto out;
 
 	if (conf->verbosity > 2)
@@ -487,6 +498,7 @@ main (int argc, char *argv[])
 	logsink = 0;
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
+	multipath_conf = conf;
 	while ((arg = getopt(argc, argv, ":adchl::FfM:v:p:b:BritquwW")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 36c77da..84f430c 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -226,12 +226,16 @@ show_config (char ** r, int * len)
 	char * reply;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
+	struct config *conf;
 
 	c = reply = MALLOC(maxlen);
 
+	conf = get_multipath_config();
 	while (again) {
-		if (!reply)
+		if (!reply) {
+			put_multipath_config(conf);
 			return 1;
+		}
 		c = reply;
 		c += snprint_defaults(conf, c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
@@ -265,6 +269,7 @@ show_config (char ** r, int * len)
 			REALLOC_REPLY(reply, again, maxlen);
 		}
 	}
+	put_multipath_config(conf);
 	*r = reply;
 	*len = (int)(c - reply + 1);
 	return 0;
@@ -621,19 +626,24 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, PATH);
 	struct path *pp;
 	int r;
+	struct config *conf;
 
 	param = convert_dev(param, 1);
 	condlog(2, "%s: add path (operator)", param);
-
+	conf = get_multipath_config();
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   param) > 0)
+			   param) > 0) {
+		put_multipath_config(conf);
 		goto blacklisted;
+	}
 
 	pp = find_path_by_dev(vecs->pathvec, param);
 	if (pp) {
 		condlog(2, "%s: path already in pathvec", param);
-		if (pp->mpp)
+		if (pp->mpp) {
+			put_multipath_config(conf);
 			return 0;
+		}
 	} else {
 		struct udev_device *udevice;
 
@@ -644,6 +654,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 				   udevice, DI_ALL, &pp);
 		udev_device_unref(udevice);
 		if (!pp) {
+			put_multipath_config(conf);
 			if (r == 2)
 				goto blacklisted;
 			condlog(0, "%s: failed to store path info", param);
@@ -651,6 +662,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		}
 		pp->checkint = conf->checkint;
 	}
+	put_multipath_config(conf);
 	return ev_add_path(pp, vecs);
 blacklisted:
 	*reply = strdup("blacklisted\n");
@@ -685,16 +697,20 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	char dev_path[PATH_SIZE];
 	char *alias, *refwwid;
 	int rc, count = 0;
+	struct config *conf;
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: add map (operator)", param);
 
+	conf = get_multipath_config();
 	if (filter_wwid(conf->blist_wwid, conf->elist_wwid, param, NULL) > 0) {
+		put_multipath_config(conf);
 		*reply = strdup("blacklisted\n");
 		*len = strlen(*reply) + 1;
 		condlog(2, "%s: map blacklisted", param);
 		return 1;
 	}
+	put_multipath_config(conf);
 	do {
 		minor = dm_get_minor(param);
 		if (minor < 0)
@@ -880,18 +896,24 @@ cli_resize(void *v, char **reply, int *len, void *data)
 int
 cli_force_no_daemon_q(void * v, char ** reply, int * len, void * data)
 {
+	struct config *conf = get_multipath_config();
+
 	condlog(2, "force queue_without_daemon (operator)");
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_OFF)
 		conf->queue_without_daemon = QUE_NO_DAEMON_FORCE;
+	put_multipath_config(conf);
 	return 0;
 }
 
 int
 cli_restore_no_daemon_q(void * v, char ** reply, int * len, void * data)
 {
+	struct config *conf = get_multipath_config();
+
 	condlog(2, "restore queue_without_daemon (operator)");
 	if (conf->queue_without_daemon == QUE_NO_DAEMON_FORCE)
 		conf->queue_without_daemon = QUE_NO_DAEMON_OFF;
+	put_multipath_config(conf);
 	return 0;
 }
 
@@ -920,8 +942,11 @@ cli_restore_queueing(void *v, char **reply, int *len, void *data)
 		dm_queue_if_no_path(mpp->alias, 1);
 		if (mpp->nr_active > 0)
 			mpp->retry_tick = 0;
-		else
+		else {
+			struct config *conf = get_multipath_config();
 			mpp->retry_tick = mpp->no_path_retry * conf->checkint;
+			put_multipath_config(conf);
+		}
 	}
 	return 0;
 }
@@ -940,8 +965,11 @@ cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
 			dm_queue_if_no_path(mpp->alias, 1);
 			if (mpp->nr_active > 0)
 				mpp->retry_tick = 0;
-			else
+			else {
+				struct config *conf = get_multipath_config();
 				mpp->retry_tick = mpp->no_path_retry * conf->checkint;
+				put_multipath_config(conf);
+			}
 		}
 	}
 	return 0;
@@ -1154,12 +1182,15 @@ show_blacklist (char ** r, int * len)
 	char *reply = NULL;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
+	struct config *conf = get_multipath_config();
 
 	reply = MALLOC(maxlen);
 
 	while (again) {
-		if (!reply)
+		if (!reply) {
+			put_multipath_config(conf);
 			return 1;
+		}
 
 		c = reply;
 		c += snprint_blacklist_report(conf, c, maxlen);
@@ -1169,6 +1200,7 @@ show_blacklist (char ** r, int * len)
 
 	*r = reply;
 	*len = (int)(c - reply + 1);
+	put_multipath_config(conf);
 
 	return 0;
 }
@@ -1188,12 +1220,15 @@ show_devices (char ** r, int * len, struct vectors *vecs)
 	char *reply = NULL;
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
+	struct config *conf = get_multipath_config();
 
 	reply = MALLOC(maxlen);
 
 	while (again) {
-		if (!reply)
+		if (!reply) {
+			put_multipath_config(conf);
 			return 1;
+		}
 
 		c = reply;
 		c += snprint_devices(conf, c, maxlen, vecs);
@@ -1203,6 +1238,7 @@ show_devices (char ** r, int * len, struct vectors *vecs)
 
 	*r = reply;
 	*len = (int)(c - reply + 1);
+	put_multipath_config(conf);
 
 	return 0;
 }
diff --git a/multipathd/main.c b/multipathd/main.c
index d5cab97..6771f60 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -111,6 +111,8 @@ struct vectors * gvecs;
 
 struct udev * udev;
 
+struct config *multipath_conf;
+
 const char *
 daemon_status(void)
 {
@@ -199,6 +201,16 @@ int set_config_state(enum daemon_status state)
 	return rc;
 }
 
+struct config *get_multipath_config(void)
+{
+	return multipath_conf;
+}
+
+void put_multipath_config(struct config *conf)
+{
+	/* Noop for now */
+}
+
 static int
 need_switch_pathgroup (struct multipath * mpp, int refresh)
 {
@@ -1781,7 +1793,7 @@ configure (struct vectors * vecs, int start_waiters)
 	/*
 	 * probe for current path (from sysfs) and map (from dm) sets
 	 */
-	ret = path_discovery(vecs->pathvec, conf, DI_ALL);
+	ret = path_discovery(vecs->pathvec, DI_ALL);
 	if (ret < 0)
 		return 1;
 
@@ -1885,6 +1897,7 @@ reconfigure (struct vectors * vecs)
 		conf->bindings_read_only = old->bindings_read_only;
 		conf->ignore_new_devs = old->ignore_new_devs;
 		configure(vecs, 1);
+		multipath_conf = conf;
 		free_config(old);
 		retval = 0;
 	} else {
@@ -2109,7 +2122,7 @@ child (void * param)
 		goto failed;
 
 	uxsock_timeout = conf->uxsock_timeout;
-
+	multipath_conf = conf;
 	dm_init(conf->verbosity);
 	dm_drv_version(conf->version, TGT_MPATH);
 	if (init_checkers(conf->multipath_dir)) {
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 9912e00..abd1486 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -144,11 +144,6 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		return NULL;
 	}
 
-	if (!conf) {
-		condlog(1, "uxsock: configuration changed");
-		return NULL;
-	}
-
 	pthread_cleanup_push(uxsock_cleanup, NULL);
 
 	condlog(3, "uxsock: startup listener");
-- 
2.6.6
