From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/8] multipathd: add deferred_remove support
Date: Fri, 16 Jan 2015 14:23:30 -0600
Message-ID: <1421439812-11826-7-git-send-email-bmarzins@redhat.com>
References: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
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

This patch adds a new configuration option "deferrer_remove"  If this is
set to "yes", when the last path of a multipath device is removed,
multipathd will do a deferred remove on it.  This means that if the
device cannot immediately be removed, device mapper will automatically
remove it when the last user closes it.  If a path is added to the
device before then, the deferred remove will be cancelled.

Without this enabled, multipath will continue to work like before, where
it will attempt a regular remove when the last path is removed.  If
that fails because the device is in use, then the multipath device will
remain, even after the last user closes it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile      |   6 ++
 libmultipath/config.c      |   2 +
 libmultipath/config.h      |   3 +
 libmultipath/configure.c   |   1 +
 libmultipath/defaults.h    |   1 +
 libmultipath/devmapper.c   | 142 ++++++++++++++++++++++++++++++++++++++++-----
 libmultipath/devmapper.h   |  11 ++--
 libmultipath/dict.c        |  13 +++++
 libmultipath/propsel.c     |  26 +++++++++
 libmultipath/propsel.h     |   1 +
 libmultipath/structs.h     |   8 +++
 libmultipath/structs_vec.c |   3 +-
 multipath/multipath.conf.5 |  14 +++++
 multipathd/main.c          |  23 ++++++--
 14 files changed, 228 insertions(+), 26 deletions(-)

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 4b4f707..fc0f3d6 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -46,6 +46,12 @@ ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
 endif
 
+LIBDM_API_DEFERRED = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_deferred_remove' /usr/include/libdevmapper.h)
+
+ifneq ($(strip $(LIBDM_API_DEFERRED)),0)
+	CFLAGS += -DLIBDM_API_DEFERRED
+endif
+
 all: $(LIBS)
 
 $(LIBS): $(OBJS)
diff --git a/libmultipath/config.c b/libmultipath/config.c
index cbc8e4b..d4a5e10 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -340,6 +340,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(user_friendly_names);
 	merge_num(retain_hwhandler);
 	merge_num(detect_prio);
+	merge_num(deferred_remove);
 
 	/*
 	 * Make sure features is consistent with
@@ -412,6 +413,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->user_friendly_names = dhwe->user_friendly_names;
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 	hwe->detect_prio = dhwe->detect_prio;
+	conf->deferred_remove = DEFAULT_DEFERRED_REMOVE;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index b942a27..bc3fe53 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -59,6 +59,7 @@ struct hwentry {
 	int user_friendly_names;
 	int retain_hwhandler;
 	int detect_prio;
+	int deferred_remove;
 	char * bl_product;
 };
 
@@ -82,6 +83,7 @@ struct mpentry {
 	int flush_on_last_del;
 	int attribute_flags;
 	int user_friendly_names;
+	int deferred_remove;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -124,6 +126,7 @@ struct config {
 	int retain_hwhandler;
 	int detect_prio;
 	int force_sync;
+	int deferred_remove;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 1068a0a..a22d16a 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -289,6 +289,7 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_dev_loss(mpp);
 	select_reservation_key(mpp);
 	select_retain_hwhandler(mpp);
+	select_deferred_remove(mpp);
 
 	sysfs_set_scsi_tmo(mpp);
 	/*
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 99cf4b1..ccf1ebe 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -16,6 +16,7 @@
 #define DEFAULT_FAST_IO_FAIL	5
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
 #define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
+#define DEFAULT_DEFERRED_REMOVE DEFERRED_REMOVE_OFF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index cddb9de..69491a3 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -32,6 +32,8 @@
 #define UUID_PREFIX "mpath-"
 #define UUID_PREFIX_LEN 6
 
+static int dm_cancel_remove_partmaps(const char * mapname);
+
 #ifndef LIBDM_API_COOKIE
 static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
 {
@@ -105,7 +107,9 @@ dm_lib_prereq (void)
 {
 	char version[64];
 	int v[3];
-#if defined(DM_SUBSYSTEM_UDEV_FLAG0)
+#if defined(LIBDM_API_DEFERRED)
+	int minv[3] = {1, 2, 89};
+#elif defined(DM_SUBSYSTEM_UDEV_FLAG0)
 	int minv[3] = {1, 2, 82};
 #elif defined(LIBDM_API_COOKIE)
 	int minv[3] = {1, 2, 38};
@@ -203,8 +207,10 @@ dm_prereq (void)
 	return dm_drv_prereq();
 }
 
+#define do_deferred(x) ((x) == DEFERRED_REMOVE_ON || (x) == DEFERRED_REMOVE_IN_PROGRESS)
+
 static int
-dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t udev_flags) {
+dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t udev_flags, int deferred_remove) {
 	int r = 0;
 	int udev_wait_flag = (need_sync && (task == DM_DEVICE_RESUME ||
 					    task == DM_DEVICE_REMOVE));
@@ -222,7 +228,10 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 	if (no_flush)
 		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 #endif
-
+#ifdef LIBDM_API_DEFERRED
+	if (do_deferred(deferred_remove))
+		dm_task_deferred_remove(dmt);
+#endif
 	if (udev_wait_flag && !dm_task_set_cookie(dmt, &conf->cookie, ((conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0) | udev_flags))
 		goto out;
 	r = dm_task_run (dmt);
@@ -234,12 +243,18 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 
 extern int
 dm_simplecmd_flush (int task, const char *name, int needsync, uint16_t udev_flags) {
-	return dm_simplecmd(task, name, 0, needsync, udev_flags);
+	return dm_simplecmd(task, name, 0, needsync, udev_flags, 0);
 }
 
 extern int
 dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags) {
-	return dm_simplecmd(task, name, 1, 1, udev_flags);
+	return dm_simplecmd(task, name, 1, 1, udev_flags, 0);
+}
+
+static int
+dm_device_remove (const char *name, int needsync, int deferred_remove) {
+	return dm_simplecmd(DM_DEVICE_REMOVE, name, 0, needsync, 0,
+			    deferred_remove);
 }
 
 extern int
@@ -655,7 +670,7 @@ out:
 }
 
 extern int
-_dm_flush_map (const char * mapname, int need_sync)
+_dm_flush_map (const char * mapname, int need_sync, int deferred_remove)
 {
 	int r;
 
@@ -665,23 +680,46 @@ _dm_flush_map (const char * mapname, int need_sync)
 	if (dm_type(mapname, TGT_MPATH) <= 0)
 		return 0; /* nothing to do */
 
-	if (dm_remove_partmaps(mapname, need_sync))
+	if (dm_remove_partmaps(mapname, need_sync, deferred_remove))
 		return 1;
 
-	if (dm_get_opencount(mapname)) {
+	if (!do_deferred(deferred_remove) && dm_get_opencount(mapname)) {
 		condlog(2, "%s: map in use", mapname);
 		return 1;
 	}
 
-	r = dm_simplecmd_flush(DM_DEVICE_REMOVE, mapname, need_sync, 0);
+	r = dm_device_remove(mapname, need_sync, deferred_remove);
 
 	if (r) {
+		if (do_deferred(deferred_remove) && dm_map_present(mapname)) {
+			condlog(4, "multipath map %s remove deferred",
+				mapname);
+			return 2;
+		}
 		condlog(4, "multipath map %s removed", mapname);
 		return 0;
 	}
 	return 1;
 }
 
+#ifdef LIBDM_API_DEFERRED
+
+int
+dm_flush_map_nopaths(const char * mapname, int deferred_remove)
+{
+	return _dm_flush_map(mapname, 1, deferred_remove);
+}
+
+#else
+
+int
+dm_flush_map_nopaths(const char * mapname, int deferred_remove)
+{
+	return _dm_flush_map(mapname, 1, 0);
+}
+
+#endif
+
 extern int
 dm_suspend_and_flush_map (const char * mapname)
 {
@@ -1068,6 +1106,7 @@ out:
 
 struct remove_data {
 	int need_sync;
+	int deferred_remove;
 };
 
 static int
@@ -1076,25 +1115,98 @@ remove_partmap(char *name, void *data)
 	struct remove_data *rd = (struct remove_data *)data;
 
 	if (dm_get_opencount(name)) {
-		dm_remove_partmaps(name, rd->need_sync);
-		if (dm_get_opencount(name)) {
+		dm_remove_partmaps(name, rd->need_sync, rd->deferred_remove);
+		if (!do_deferred(rd->deferred_remove) &&
+		    dm_get_opencount(name)) {
 			condlog(2, "%s: map in use", name);
 			return 1;
 		}
 	}
 	condlog(4, "partition map %s removed", name);
-	dm_simplecmd_flush(DM_DEVICE_REMOVE, name,
-			   rd->need_sync, 0);
+	dm_device_remove(name, rd->need_sync, rd->deferred_remove);
 	return 0;
 }
 
 int
-dm_remove_partmaps (const char * mapname, int need_sync)
+dm_remove_partmaps (const char * mapname, int need_sync, int deferred_remove)
 {
-	struct remove_data rd = { need_sync };
+	struct remove_data rd = { need_sync, deferred_remove };
 	return do_foreach_partmaps(mapname, remove_partmap, &rd);
 }
 
+#ifdef LIBDM_API_DEFERRED
+
+static int
+cancel_remove_partmap (char *name, void *unused)
+{
+	if (dm_get_opencount(name))
+		dm_cancel_remove_partmaps(name);
+	if (dm_message(name, "@cancel_deferred_remove") != 0)
+		condlog(0, "%s: can't cancel deferred remove: %s", name,
+			strerror(errno));
+	return 0;
+}
+
+static int
+dm_get_deferred_remove (char * mapname)
+{
+	int r = -1;
+	struct dm_task *dmt;
+	struct dm_info info;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		return -1;
+
+	if (!dm_task_set_name(dmt, mapname))
+		goto out;
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!dm_task_get_info(dmt, &info))
+		goto out;
+
+	r = info.deferred_remove;
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
+static int
+dm_cancel_remove_partmaps(const char * mapname) {
+	return do_foreach_partmaps(mapname, cancel_remove_partmap, NULL);
+}
+
+int
+dm_cancel_deferred_remove (struct multipath *mpp)
+{
+	int r = 0;
+
+	if (!dm_get_deferred_remove(mpp->alias))
+		return 0;
+	if (mpp->deferred_remove == DEFERRED_REMOVE_IN_PROGRESS)
+		mpp->deferred_remove = DEFERRED_REMOVE_ON;
+
+	dm_cancel_remove_partmaps(mpp->alias);
+	r = dm_message(mpp->alias, "@cancel_deferred_remove");
+	if (r)
+		condlog(0, "%s: can't cancel deferred remove: %s", mpp->alias,
+				strerror(errno));
+	else
+		condlog(2, "%s: canceled deferred remove", mpp->alias);
+	return r;
+}
+
+#else
+
+int
+dm_cancel_deferred_remove (struct multipath *mpp)
+{
+	return 0;
+}
+
+#endif
+
 static struct dm_info *
 alloc_dminfo (void)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 6ea816c..5c8c50d 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -23,9 +23,11 @@ int dm_map_present (const char *);
 int dm_get_map(const char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
 int dm_type(const char *, char *);
-int _dm_flush_map (const char *, int);
-#define dm_flush_map(mapname) _dm_flush_map(mapname, 1)
-#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0)
+int _dm_flush_map (const char *, int, int);
+int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
+#define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0)
+#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0)
+int dm_cancel_deferred_remove(struct multipath *mpp);
 int dm_suspend_and_flush_map(const char * mapname);
 int dm_flush_maps (void);
 int dm_fail_path(char * mapname, char * path);
@@ -39,7 +41,8 @@ int dm_geteventnr (char *name);
 int dm_get_major (char *name);
 int dm_get_minor (char *name);
 char * dm_mapname(int major, int minor);
-int dm_remove_partmaps (const char * mapname, int need_sync);
+int dm_remove_partmaps (const char * mapname, int need_sync,
+			int deferred_remove);
 int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
 int dm_rename (char * old, char * new);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ab313f3..0f0ac05 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -374,6 +374,15 @@ declare_hw_snprint(detect_prio, print_yes_no_undef)
 declare_def_handler(force_sync, set_yes_no)
 declare_def_snprint(force_sync, print_yes_no)
 
+declare_def_handler(deferred_remove, set_yes_no_undef)
+declare_def_snprint_defint(deferred_remove, print_yes_no_undef, YNU_NO)
+declare_ovr_handler(deferred_remove, set_yes_no_undef)
+declare_ovr_snprint(deferred_remove, print_yes_no_undef)
+declare_hw_handler(deferred_remove, set_yes_no_undef)
+declare_hw_snprint(deferred_remove, print_yes_no_undef)
+declare_mp_handler(deferred_remove, set_yes_no_undef)
+declare_mp_snprint(deferred_remove, print_yes_no_undef)
+
 #define declare_def_attr_handler(option, function)			\
 static int								\
 def_ ## option ## _handler (vector strvec)				\
@@ -1245,6 +1254,7 @@ init_keywords(void)
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
+	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
 	install_keyword("partition_delimiter", &def_partition_delim_handler, &snprint_def_partition_delim);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
@@ -1313,6 +1323,7 @@ init_keywords(void)
 	install_keyword("user_friendly_names", &hw_user_friendly_names_handler, &snprint_hw_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
+	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_sublevel_end();
 
 	install_keyword_root("overrides", &overrides_handler);
@@ -1337,6 +1348,7 @@ init_keywords(void)
 	install_keyword("user_friendly_names", &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
+	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
@@ -1360,5 +1372,6 @@ init_keywords(void)
 	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
 	install_keyword("reservation_key", &mp_reservation_key_handler, &snprint_mp_reservation_key);
 	install_keyword("user_friendly_names", &mp_user_friendly_names_handler, &snprint_mp_user_friendly_names);
+	install_keyword("deferred_remove", &mp_deferred_remove_handler, &snprint_mp_deferred_remove);
 	install_sublevel_end();
 }
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 440802c..f5c158b 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -590,3 +590,29 @@ out:
 		(pp->detect_prio == DETECT_PRIO_ON)? "yes" : "no", origin);
 	return 0;
 }
+
+extern int
+select_deferred_remove (struct multipath *mp)
+{
+	char *origin;
+
+#ifndef LIBDM_API_DEFERRED
+	mp->deferred_remove = DEFERRED_REMOVE_OFF;
+	origin = "(not compiled with support)";
+	goto out;
+#endif
+	if (mp->deferred_remove == DEFERRED_REMOVE_IN_PROGRESS) {
+		condlog(3, "%s: deferred remove in progress", mp->alias);
+		return 0;
+	}
+	mp_set_mpe(deferred_remove);
+	mp_set_ovr(deferred_remove);
+	mp_set_hwe(deferred_remove);
+	mp_set_conf(deferred_remove);
+	mp_set_default(deferred_remove, DEFAULT_DEFERRED_REMOVE);
+out:
+	condlog(3, "%s: deferred_remove = %s %s", mp->alias,
+		(mp->deferred_remove == DEFERRED_REMOVE_ON)? "yes" : "no",
+		origin);
+	return 0;
+}
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 05c6a4e..ffb58a5 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -19,3 +19,4 @@ int select_dev_loss(struct multipath *mp);
 int select_reservation_key(struct multipath *mp);
 int select_retain_hwhandler (struct multipath * mp);
 int select_detect_prio(struct path * pp);
+int select_deferred_remove(struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 15e7e19..b6cfff8 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -120,6 +120,13 @@ enum detect_prio_states {
 	DETECT_PRIO_ON = YNU_YES,
 };
 
+enum deferred_remove_states {
+	DEFERRED_REMOVE_UNDEF = YNU_UNDEF,
+	DEFERRED_REMOVE_OFF = YNU_NO,
+	DEFERRED_REMOVE_ON = YNU_YES,
+	DEFERRED_REMOVE_IN_PROGRESS,
+};
+
 enum scsi_protocol {
 	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
 	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
@@ -213,6 +220,7 @@ struct multipath {
 	int attribute_flags;
 	int fast_io_fail;
 	int retain_hwhandler;
+	int deferred_remove;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 23f5bbb..a15e3c0 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -392,6 +392,8 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp, int reset)
 		select_pgfailback(mpp);
 		set_no_path_retry(mpp);
 		select_flush_on_last_del(mpp);
+		if (VECTOR_SIZE(mpp->paths) != 0)
+			dm_cancel_deferred_remove(mpp);
 	}
 
 	return 0;
@@ -564,7 +566,6 @@ int update_multipath (struct vectors *vecs, char *mapname, int reset)
 			}
 		}
 	}
-
 	return 0;
 }
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index b823990..1587b1c 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -422,6 +422,16 @@ only one checker will run at a time.  This is useful in the case where many
 multipathd checkers running in parallel causes significant CPU pressure. The
 Default is
 .I no
+.TP
+.B deferred_remove
+If set to
+.I yes
+, multipathd will do a deferred remove instead of a regular remove when the
+last path device has been deleted.  This means that if the multipath device is
+still in use, it will be freed when the last user closes it.  If path is added
+to the multipath device before the last user closes it, the deferred remove
+will be canceled. Default is
+.I no
 .
 .SH "blacklist section"
 The
@@ -540,6 +550,8 @@ section:
 .B features
 .TP
 .B reservation_key
+.TP
+.B deferred_remove
 .RE
 .PD
 .LP
@@ -630,6 +642,8 @@ section:
 .B retain_attached_hw_handler
 .TP
 .B detect_prio
+.TP
+.B deferred_remove
 .RE
 .PD
 .LP
diff --git a/multipathd/main.c b/multipathd/main.c
index a194c80..f9e3f33 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -218,19 +218,30 @@ sync_maps_state(vector mpvec)
 }
 
 static int
-flush_map(struct multipath * mpp, struct vectors * vecs)
+flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 {
+	int r;
+
+	if (nopaths)
+		r = dm_flush_map_nopaths(mpp->alias, mpp->deferred_remove);
+	else
+		r = dm_flush_map(mpp->alias);
 	/*
 	 * clear references to this map before flushing so we can ignore
 	 * the spurious uevent we may generate with the dm_flush_map call below
 	 */
-	if (dm_flush_map(mpp->alias)) {
+	if (r) {
 		/*
 		 * May not really be an error -- if the map was already flushed
 		 * from the device mapper by dmsetup(8) for instance.
 		 */
-		condlog(0, "%s: can't flush", mpp->alias);
-		return 1;
+		if (r == 1)
+			condlog(0, "%s: can't flush", mpp->alias);
+		else {
+			condlog(2, "%s: devmap deferred remove", mpp->alias);
+			mpp->deferred_remove = DEFERRED_REMOVE_IN_PROGRESS;
+		}
+		return r;
 	}
 	else {
 		dm_lib_release();
@@ -376,7 +387,7 @@ ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
 			mpp->alias, mpp->dmi->minor, minor);
 		return 0;
 	}
-	return flush_map(mpp, vecs);
+	return flush_map(mpp, vecs, 0);
 }
 
 static int
@@ -627,7 +638,7 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 				mpp->flush_on_last_del = FLUSH_IN_PROGRESS;
 				dm_queue_if_no_path(mpp->alias, 0);
 			}
-			if (!flush_map(mpp, vecs)) {
+			if (!flush_map(mpp, vecs, 1)) {
 				condlog(2, "%s: removed map after"
 					" removing all paths",
 					alias);
-- 
1.8.3.1
