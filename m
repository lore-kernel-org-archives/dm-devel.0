From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 01/10] libmultipath: add skip_kpartx option
Date: Fri, 28 Oct 2016 21:55:17 -0500
Message-ID: <1477709726-5442-2-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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

This option gives multipath the ability to stop kpartx from running. The
previous idea, the "no_partitions" feature, was not accepted in the
upstream kernel. This method uses one of the dm cookie subsystem flags
DM_SUBSYSTEM_UDEV_FLAG1, which can be checked by udev to skip running
kpartx when processing the event. This patch does most of the work
necessary to make this work.  It doesn't change kpartx.rules, however.

Also, if dm_suspend_and_flush_map fails, multipath doesn't know how the
device is configured. so, it simply checks if the device has any
partitions before attempting the remove, and if not, sets the
DM_SUBSYSTEM_UDEV_FLAG1 on the resume after failure, so that no
partitions will be generated.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  2 ++
 libmultipath/config.h      |  3 +++
 libmultipath/configure.c   |  5 +++--
 libmultipath/defaults.h    |  1 +
 libmultipath/devmapper.c   | 45 +++++++++++++++++++++++++++++++--------------
 libmultipath/devmapper.h   |  8 +++++++-
 libmultipath/dict.c        | 13 +++++++++++++
 libmultipath/propsel.c     | 18 ++++++++++++++++++
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  7 +++++++
 multipath/multipath.conf.5 | 17 +++++++++++++++++
 multipathd/cli_handlers.c  |  4 +++-
 12 files changed, 106 insertions(+), 18 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index ed51afb..bdcad80 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -347,6 +347,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(deferred_remove);
 	merge_num(delay_watch_checks);
 	merge_num(delay_wait_checks);
+	merge_num(skip_kpartx);
 
 	/*
 	 * Make sure features is consistent with
@@ -616,6 +617,7 @@ load_config (char * file)
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
 	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
 	conf->deferred_remove = DEFAULT_DEFERRED_REMOVE;
+	conf->skip_kpartx = DEFAULT_SKIP_KPARTX;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index a41207a..d59a993 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -65,6 +65,7 @@ struct hwentry {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int skip_kpartx;
 	char * bl_product;
 };
 
@@ -91,6 +92,7 @@ struct mpentry {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int skip_kpartx;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -141,6 +143,7 @@ struct config {
 	int ignore_new_devs;
 	int delayed_reconfig;
 	int uev_wait_timeout;
+	int skip_kpartx;
 	unsigned int version[3];
 
 	char * multipath_dir;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 707e6be..48f100b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -295,6 +295,7 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_deferred_remove(conf, mpp);
 	select_delay_watch_checks(conf, mpp);
 	select_delay_wait_checks(conf, mpp);
+	select_skip_kpartx(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
 	put_multipath_config(conf);
@@ -641,14 +642,14 @@ domap (struct multipath * mpp, char * params, int is_daemon)
 	case ACT_RENAME:
 		conf = get_multipath_config();
 		r = dm_rename(mpp->alias_old, mpp->alias,
-			      conf->partition_delim);
+			      conf->partition_delim, mpp->skip_kpartx);
 		put_multipath_config(conf);
 		break;
 
 	case ACT_FORCERENAME:
 		conf = get_multipath_config();
 		r = dm_rename(mpp->alias_old, mpp->alias,
-			      conf->partition_delim);
+			      conf->partition_delim, mpp->skip_kpartx);
 		put_multipath_config(conf);
 		if (r)
 			r = dm_addmap_reload(mpp, params, 0);
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 9af9a9a..a1fee9b 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -35,6 +35,7 @@
 #define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
 #define DEFAULT_FORCE_SYNC	0
 #define DEFAULT_PARTITION_DELIM	NULL
+#define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 89aa5da..ee61ff0 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -213,8 +213,9 @@ dm_prereq (void)
 static int
 dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t udev_flags, int deferred_remove) {
 	int r = 0;
-	int udev_wait_flag = (need_sync && (task == DM_DEVICE_RESUME ||
-					    task == DM_DEVICE_REMOVE));
+	int udev_wait_flag = ((need_sync || udev_flags) &&
+			      (task == DM_DEVICE_RESUME ||
+			       task == DM_DEVICE_REMOVE));
 	uint32_t cookie = 0;
 	struct dm_task *dmt;
 
@@ -266,11 +267,12 @@ dm_device_remove (const char *name, int needsync, int deferred_remove) {
 
 static int
 dm_addmap (int task, const char *target, struct multipath *mpp,
-	   char * params, int ro) {
+	   char * params, int ro, int skip_kpartx) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
 	uint32_t cookie = 0;
+	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
 
 	if (!(dmt = dm_task_create (task)))
 		return 0;
@@ -319,8 +321,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	dm_task_no_open_count(dmt);
 
 	if (task == DM_DEVICE_CREATE &&
-	    !dm_task_set_cookie(dmt, &cookie,
-				DM_UDEV_DISABLE_LIBRARY_FALLBACK))
+	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto freeout;
 
 	r = dm_task_run (dmt);
@@ -344,7 +345,8 @@ dm_addmap_create (struct multipath *mpp, char * params) {
 	for (ro = 0; ro <= 1; ro++) {
 		int err;
 
-		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro))
+		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
+			      mpp->skip_kpartx))
 			return 1;
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
@@ -371,7 +373,9 @@ extern int
 dm_addmap_reload (struct multipath *mpp, char *params, int flush)
 {
 	int r;
-	uint16_t udev_flags = flush ? 0 : MPATH_UDEV_RELOAD_FLAG;
+	uint16_t udev_flags = (flush ? 0 : MPATH_UDEV_RELOAD_FLAG) |
+			      ((mpp->skip_kpartx == SKIP_KPARTX_ON)?
+			       MPATH_UDEV_NO_KPARTX_FLAG : 0);
 
 	/*
 	 * DM_DEVICE_RELOAD cannot wait on a cookie, as
@@ -379,12 +383,13 @@ dm_addmap_reload (struct multipath *mpp, char *params, int flush)
 	 * DM_DEVICE_RESUME. So call DM_DEVICE_RESUME
 	 * after each successful call to DM_DEVICE_RELOAD.
 	 */
-	r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RW);
+	r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RW,
+		      SKIP_KPARTX_OFF);
 	if (!r) {
 		if (errno != EROFS)
 			return 0;
 		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp,
-			      params, ADDMAP_RO);
+			      params, ADDMAP_RO, SKIP_KPARTX_OFF);
 	}
 	if (r)
 		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, flush,
@@ -761,6 +766,12 @@ out:
 }
 
 static int
+has_partmap(const char *name, void *data)
+{
+	return 1;
+}
+
+static int
 partmap_in_use(const char *name, void *data)
 {
 	int part_count, *ret_count = (int *)data;
@@ -839,10 +850,16 @@ dm_suspend_and_flush_map (const char * mapname)
 	int s = 0, queue_if_no_path = 0;
 	unsigned long long mapsize;
 	char params[PARAMS_SIZE] = {0};
+	int udev_flags = 0;
 
 	if (!dm_is_mpath(mapname))
 		return 0; /* nothing to do */
 
+	/* if the device currently has no partitions, do not
+ 	   run kpartx on it if you fail to delete it */
+	if (do_foreach_partmaps(mapname, has_partmap, NULL) == 0)
+		udev_flags |= MPATH_UDEV_NO_KPARTX_FLAG;
+
 	if (!dm_get_map(mapname, &mapsize, params)) {
 		if (strstr(params, "queue_if_no_path"))
 			queue_if_no_path = 1;
@@ -861,7 +878,7 @@ dm_suspend_and_flush_map (const char * mapname)
 		return 0;
 	}
 	condlog(2, "failed to remove multipath map %s", mapname);
-	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, 0);
+	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags);
 	if (queue_if_no_path)
 		s = dm_queue_if_no_path((char *)mapname, 1);
 	return 1;
@@ -1380,7 +1397,7 @@ rename_partmap (const char *name, void *data)
 	for (offset = strlen(rd->old); name[offset] && !(isdigit(name[offset])); offset++); /* do nothing */
 	snprintf(buff, PARAMS_SIZE, "%s%s%s", rd->new, rd->delim,
 		 name + offset);
-	dm_rename(name, buff, rd->delim);
+	dm_rename(name, buff, rd->delim, SKIP_KPARTX_OFF);
 	condlog(4, "partition map %s renamed", name);
 	return 0;
 }
@@ -1403,11 +1420,12 @@ dm_rename_partmaps (const char * old, char * new, char *delim)
 }
 
 int
-dm_rename (const char * old, char * new, char *delim)
+dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 {
 	int r = 0;
 	struct dm_task *dmt;
 	uint32_t cookie;
+	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
 
 	if (dm_rename_partmaps(old, new, delim))
 		return r;
@@ -1423,8 +1441,7 @@ dm_rename (const char * old, char * new, char *delim)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_set_cookie(dmt, &cookie,
-				DM_UDEV_DISABLE_LIBRARY_FALLBACK))
+	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto out;
 	r = dm_task_run(dmt);
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 442d42e..e6d1090 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -12,6 +12,12 @@
 #define MPATH_UDEV_RELOAD_FLAG 0
 #endif
 
+#ifdef DM_SUBSYSTEM_UDEV_FLAG1
+#define MPATH_UDEV_NO_KPARTX_FLAG DM_SUBSYSTEM_UDEV_FLAG1
+#else
+#define MPATH_UDEV_NO_KPARTX_FLAG 0
+#endif
+
 void dm_init(int verbosity);
 int dm_prereq (void);
 int dm_drv_version (unsigned int * version, char * str);
@@ -46,7 +52,7 @@ int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
 int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
-int dm_rename (const char * old, char * new, char * delim);
+int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7c21e72..e0a3014 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -403,6 +403,15 @@ declare_def_snprint(uev_wait_timeout, print_int)
 declare_def_handler(strict_timing, set_yes_no)
 declare_def_snprint(strict_timing, print_yes_no)
 
+declare_def_handler(skip_kpartx, set_yes_no_undef)
+declare_def_snprint_defint(skip_kpartx, print_yes_no_undef, YNU_NO)
+declare_ovr_handler(skip_kpartx, set_yes_no_undef)
+declare_ovr_snprint(skip_kpartx, print_yes_no_undef)
+declare_hw_handler(skip_kpartx, set_yes_no_undef)
+declare_hw_snprint(skip_kpartx, print_yes_no_undef)
+declare_mp_handler(skip_kpartx, set_yes_no_undef)
+declare_mp_snprint(skip_kpartx, print_yes_no_undef)
+
 static int
 def_config_dir_handler(struct config *conf, vector strvec)
 {
@@ -1385,6 +1394,7 @@ init_keywords(vector keywords)
 	install_keyword("retrigger_tries", &def_retrigger_tries_handler, &snprint_def_retrigger_tries);
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
 	install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
+	install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint_def_skip_kpartx);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
@@ -1458,6 +1468,7 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
+	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_sublevel_end();
 
 	install_keyword_root("overrides", &overrides_handler);
@@ -1485,6 +1496,7 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
+	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
@@ -1511,5 +1523,6 @@ init_keywords(vector keywords)
 	install_keyword("deferred_remove", &mp_deferred_remove_handler, &snprint_mp_deferred_remove);
 	install_keyword("delay_watch_checks", &mp_delay_watch_checks_handler, &snprint_mp_delay_watch_checks);
 	install_keyword("delay_wait_checks", &mp_delay_wait_checks_handler, &snprint_mp_delay_wait_checks);
+	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
 	install_sublevel_end();
 }
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index aaf99fb..ec1fd92 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -665,4 +665,22 @@ out:
 	print_delay_checks(buff, 12, &mp->delay_wait_checks);
 	condlog(3, "%s: delay_wait_checks = %s %s", mp->alias, buff, origin);
 	return 0;
+
+}
+
+extern int
+select_skip_kpartx (struct config *conf, struct multipath * mp)
+{
+	char *origin;
+
+	mp_set_mpe(skip_kpartx);
+	mp_set_ovr(skip_kpartx);
+	mp_set_hwe(skip_kpartx);
+	mp_set_conf(skip_kpartx);
+	mp_set_default(skip_kpartx, DEFAULT_SKIP_KPARTX);
+out:
+	condlog(3, "%s: skip_kpartx = %s %s", mp->alias,
+		(mp->skip_kpartx == SKIP_KPARTX_ON)? "yes" : "no",
+		origin);
+	return 0;
 }
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 5941a5f..3e6d607 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -22,3 +22,4 @@ int select_detect_prio(struct config *conf, struct path * pp);
 int select_deferred_remove(struct config *conf, struct multipath *mp);
 int select_delay_watch_checks (struct config *conf, struct multipath * mp);
 int select_delay_wait_checks (struct config *conf, struct multipath * mp);
+int select_skip_kpartx (struct config *conf, struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index cb5d532..2078413 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -128,6 +128,12 @@ enum deferred_remove_states {
 	DEFERRED_REMOVE_IN_PROGRESS,
 };
 
+enum skip_kpartx_states {
+	SKIP_KPARTX_UNDEF = YNU_UNDEF,
+	SKIP_KPARTX_OFF = YNU_NO,
+	SKIP_KPARTX_ON = YNU_YES,
+};
+
 enum scsi_protocol {
 	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
 	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
@@ -243,6 +249,7 @@ struct multipath {
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
+	int skip_kpartx;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index eec319f..b7d7e59 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -842,6 +842,17 @@ Default value is: \fB30\fR
 .RE
 .
 .
+.TP
+.B skip_kpartx
+If set to
+.I yes
+, kpartx will not automatically create partitions on the device.
+.RS
+.TP
+The default is \fBno\fR
+.RE
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist section"
 .\" ----------------------------------------------------------------------------
@@ -972,6 +983,8 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
+.TP
+.B skip_kpartx
 .RE
 .PD
 .LP
@@ -1081,6 +1094,8 @@ section:
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
+.TP
+.B skip_kpartx
 .RE
 .PD
 .LP
@@ -1141,6 +1156,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .B delay_watch_checks
 .TP
 .B delay_wait_checks
+.TP
+.B skip_kpartx
 .RE
 .PD
 .LP
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 8ff4362..181b2b8 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1078,19 +1078,21 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, MAP);
 	int r;
 	struct multipath * mpp;
+	uint16_t udev_flags;
 
 	param = convert_dev(param, 0);
 	mpp = find_mp_by_alias(vecs->mpvec, param);
 	if (!mpp)
 		return 1;
 
+	udev_flags = (mpp->skip_kpartx)? MPATH_UDEV_NO_KPARTX_FLAG : 0;
 	if (mpp->wait_for_udev) {
 		condlog(2, "%s: device not fully created, failing resume",
 			mpp->alias);
 		return 1;
 	}
 
-	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0);
+	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, udev_flags);
 
 	condlog(2, "%s: resume (operator)", param);
 
-- 
1.8.3.1
