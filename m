From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 05/18] multipath: add support for
Date: Sat, 12 Jan 2013 00:04:42 -0600
Message-ID: <1357970695-3396-5-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This adds support for the retain_attached_hw_handler. When this is set to
"yes", if the kernel has already attached a hardware handler to the multipath
path devices, multipath will use that one, instead of its configured one. If
no hardware handler is already attached, multipath use its configured one, if
any.  To properly ignore this on older kernels, I had to makes some changes
to the version checking code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  5 +++-
 libmultipath/config.h    |  4 ++-
 libmultipath/configure.c |  7 +++--
 libmultipath/defaults.h  |  1 +
 libmultipath/devmapper.c | 34 ++++------------------
 libmultipath/devmapper.h |  8 +++++-
 libmultipath/dict.c      | 74 ++++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/dmparser.c  |  3 ++
 libmultipath/propsel.c   | 29 ++++++++++++++++++-
 libmultipath/propsel.h   |  1 +
 libmultipath/structs.h   |  7 +++++
 11 files changed, 138 insertions(+), 35 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 51b4f45..5b26298 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -326,6 +326,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(fast_io_fail);
 	merge_num(dev_loss);
 	merge_num(user_friendly_names);
+	merge_num(retain_hwhandler);
 
 	return 0;
 }
@@ -385,6 +386,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->fast_io_fail = dhwe->fast_io_fail;
 	hwe->dev_loss = dhwe->dev_loss;
 	hwe->user_friendly_names = dhwe->user_friendly_names;
+	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
@@ -501,7 +503,7 @@ load_config (char * file)
 		conf->verbosity = DEFAULT_VERBOSITY;
 
 	conf->udev = udev_new();
-	conf->dmrq = dm_drv_get_rq();
+	dm_drv_version(conf->version, TGT_MPATH);
 	conf->dev_type = DEV_NONE;
 	conf->minio = DEFAULT_MINIO;
 	conf->minio_rq = DEFAULT_MINIO_RQ;
@@ -517,6 +519,7 @@ load_config (char * file)
 	conf->checkint = DEFAULT_CHECKINT;
 	conf->max_checkint = MAX_CHECKINT(conf->checkint);
 	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
+	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 51fc492..7a1409f 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -46,6 +46,7 @@ struct hwentry {
 	int fast_io_fail;
 	unsigned int dev_loss;
 	int user_friendly_names;
+	int retain_hwhandler;
 	char * bl_product;
 };
 
@@ -75,7 +76,6 @@ struct mpentry {
 };
 
 struct config {
-	int dmrq;
 	int verbosity;
 	int dry_run;
 	int list;
@@ -109,6 +109,8 @@ struct config {
 	mode_t mode;
 	uint32_t cookie;
 	int reassign_maps;
+	int retain_hwhandler;
+	unsigned int version[3];
 
 	char * dev;
 	struct udev * udev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 0f1fe43..131b5ad 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -76,6 +76,7 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_fast_io_fail(mpp);
 	select_dev_loss(mpp);
 	select_reservation_key(mpp);
+	select_retain_hwhandler(mpp);
 
 	sysfs_set_scsi_tmo(mpp);
 	/*
@@ -217,8 +218,10 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias);
 		return;
 	}
-	if (!cmpp->selector || strncmp(cmpp->hwhandler, mpp->hwhandler,
-		    strlen(mpp->hwhandler))) {
+	if (mpp->retain_hwhandler != RETAIN_HWHANDLER_ON &&
+            (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
+	     strncmp(cmpp->hwhandler, mpp->hwhandler,
+		    strlen(mpp->hwhandler)))) {
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (hwhandler change)",
 			mpp->alias);
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 097c66f..f8a8774 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -16,6 +16,7 @@
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	1
 #define DEFAULT_FAST_IO_FAIL	5
+#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 89615b0..f474e97 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -98,12 +98,6 @@ dm_init(void) {
 	dm_log_init_verbose(conf ? conf->verbosity + 3 : 0);
 }
 
-#define VERSION_GE(v, minv) ( \
- (v[0] > minv[0]) || \
- ((v[0] == minv[0]) && (v[1] > minv[1])) || \
- ((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
-)
-
 static int
 dm_lib_prereq (void)
 {
@@ -126,7 +120,7 @@ dm_lib_prereq (void)
 	return 1;
 }
 
-static int
+int
 dm_drv_version (unsigned int * version, char * str)
 {
 	int r = 2;
@@ -135,6 +129,10 @@ dm_drv_version (unsigned int * version, char * str)
 	struct dm_versions *last_target;
 	unsigned int *v;
 
+	version[0] = 0;
+	version[1] = 0;
+	version[2] = 0;
+
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)))
 		return 1;
 
@@ -169,28 +167,6 @@ out:
 	return r;
 }
 
-int
-dm_drv_get_rq (void)
-{
-	unsigned int minv_dmrq[3] = {1, 1, 0};
-	unsigned int version[3] = {0, 0, 0};
-        unsigned int * v = version;
-
-	if (dm_drv_version(v, TGT_MPATH)) {
-		/* in doubt return least capable */
-		return 0;
-	}
-
-	/* test request based multipath capability */
-	if VERSION_GE(v, minv_dmrq) {
-		condlog(3, "activate request-based multipathing mode "
-			   "(driver >= v%u.%u.%u)",
-			minv_dmrq[0], minv_dmrq[1], minv_dmrq[2]);
-		return 1;
-	}
-	return 0;
-}
-
 static int
 dm_drv_prereq (void)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index b08aa31..bf8ee91 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -8,7 +8,7 @@
 
 void dm_init(void);
 int dm_prereq (void);
-int dm_drv_get_rq (void);
+int dm_drv_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, int);
 int dm_simplecmd_noflush (int, const char *);
 int dm_addmap_create (struct multipath *mpp, char *params);
@@ -47,4 +47,10 @@ int dm_setgeometry(struct multipath *mpp);
 void udev_wait(unsigned int c);
 void udev_set_sync_support(int c);
 
+#define VERSION_GE(v, minv) ( \
+ (v[0] > minv[0]) || \
+ ((v[0] == minv[0]) && (v[1] > minv[1])) || \
+ ((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
+)
+
 #endif /* _DEVMAPPER_H */
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 6dae335..88b4aba 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -629,6 +629,29 @@ wwids_file_handler(vector strvec)
 	return 0;
 }
 
+static int
+def_retain_hwhandler_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
+	    (strlen(buff) == 1 && !strcmp(buff, "0")))
+		conf->retain_hwhandler = RETAIN_HWHANDLER_OFF;
+	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
+		 (strlen(buff) == 1 && !strcmp(buff, "1")))
+		conf->retain_hwhandler = RETAIN_HWHANDLER_ON;
+	else
+		conf->retain_hwhandler = RETAIN_HWHANDLER_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -1250,6 +1273,33 @@ hw_names_handler(vector strvec)
 	return 0;
 }
 
+static int
+hw_retain_hwhandler_handler(vector strvec)
+{
+	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	char * buff;
+
+	if (!hwe)
+		return 1;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
+	    (strlen(buff) == 1 && !strcmp(buff, "0")))
+		hwe->retain_hwhandler = RETAIN_HWHANDLER_OFF;
+	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
+		 (strlen(buff) == 1 && !strcmp(buff, "1")))
+		hwe->retain_hwhandler = RETAIN_HWHANDLER_ON;
+	else
+		hwe->user_friendly_names = RETAIN_HWHANDLER_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * multipaths block handlers
  */
@@ -2274,6 +2324,19 @@ snprint_hw_user_friendly_names (char * buff, int len, void * data)
 }
 
 static int
+snprint_hw_retain_hwhandler_handler(char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (hwe->retain_hwhandler == RETAIN_HWHANDLER_ON)
+		return snprintf(buff, len, "yes");
+	else if (hwe->retain_hwhandler == RETAIN_HWHANDLER_OFF)
+		return snprintf(buff, len, "no");
+	else
+		return 0;
+}
+
+static int
 snprint_def_polling_interval (char * buff, int len, void * data)
 {
 	return snprintf(buff, len, "%i", conf->checkint);
@@ -2599,6 +2662,15 @@ snprint_def_reservation_key(char * buff, int len, void * data)
 }
 
 static int
+snprint_def_retain_hwhandler_handler(char * buff, int len, void * data)
+{
+	if (conf->retain_hwhandler == RETAIN_HWHANDLER_ON)
+		return snprintf(buff, len, "yes");
+	else
+		return snprintf(buff, len, "no");
+}
+
+static int
 snprint_ble_simple (char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
@@ -2662,6 +2734,7 @@ init_keywords(void)
 	install_keyword("wwids_file", &wwids_file_handler, &snprint_def_wwids_file);
 	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
 	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
+	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler_handler);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
@@ -2723,6 +2796,7 @@ init_keywords(void)
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
 	install_keyword("user_friendly_names", &hw_names_handler, &snprint_hw_user_friendly_names);
+	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler_handler);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 5184c41..2562ba1 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -56,6 +56,7 @@ assemble_map (struct multipath * mp, char * params, int len)
 	int nr_priority_groups, initial_pg_nr;
 	char * p, * f;
 	char no_path_retry[] = "queue_if_no_path";
+	char retain_hwhandler[] = "retain_attached_hw_handler";
 	struct pathgroup * pgp;
 	struct path * pp;
 
@@ -81,6 +82,8 @@ assemble_map (struct multipath * mp, char * params, int len)
 	} else {
 		add_feature(&f, no_path_retry);
 	}
+	if (mp->retain_hwhandler == RETAIN_HWHANDLER_ON)
+		add_feature(&f, retain_hwhandler);
 
 	shift = snprintf(p, freechar, "%s %s %i %i",
 			 f, mp->hwhandler,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index b8c6b08..c03926a 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -513,7 +513,9 @@ select_minio_bio (struct multipath * mp)
 extern int
 select_minio (struct multipath * mp)
 {
-	if (conf->dmrq)
+	unsigned int minv_dmrq[3] = {1, 1, 0};
+
+	if (VERSION_GE(conf->version, minv_dmrq))
 		return select_minio_rq(mp);
 	else
 		return select_minio_bio(mp);
@@ -679,3 +681,28 @@ select_reservation_key (struct multipath * mp)
 	return 0;
 }
 
+extern int
+select_retain_hwhandler (struct multipath * mp)
+{
+	unsigned int minv_dm_retain[3] = {1, 5, 0};
+
+	if (!VERSION_GE(conf->version, minv_dm_retain)) {
+		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
+		condlog(3, "%s: retain_attached_hw_hander disabled (requires kernel version >= 1.5.0)", mp->alias);
+		return 0;
+	}
+
+	if (mp->hwe && mp->hwe->retain_hwhandler) {
+		mp->retain_hwhandler = mp->hwe->retain_hwhandler;
+		condlog(3, "%s: retain_attached_hw_handler = %d (controller default)", mp->alias, mp->retain_hwhandler);
+		return 0;
+	}
+	if (conf->retain_hwhandler) {
+		mp->retain_hwhandler = conf->retain_hwhandler;
+		condlog(3, "%s: retain_attached_hw_handler = %d (config file default)", mp->alias, mp->retain_hwhandler);
+		return 0;
+	}
+	mp->retain_hwhandler = 0;
+	condlog(3, "%s: retain_attached_hw_handler = %d (compiled in default)", mp->alias, mp->retain_hwhandler);
+	return 0;
+}
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 4e931d4..1bf6e45 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -18,3 +18,4 @@ int select_gid(struct multipath *mp);
 int select_fast_io_fail(struct multipath *mp);
 int select_dev_loss(struct multipath *mp);
 int select_reservation_key(struct multipath *mp);
+int select_retain_hwhandler (struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 16e940b..92cd2e4 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -101,6 +101,12 @@ enum user_friendly_names_states {
 	USER_FRIENDLY_NAMES_ON,
 };
 
+enum retain_hwhandler_states {
+	RETAIN_HWHANDLER_UNDEF,
+	RETAIN_HWHANDLER_OFF,
+	RETAIN_HWHANDLER_ON,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
@@ -192,6 +198,7 @@ struct multipath {
 	int flush_on_last_del;
 	int attribute_flags;
 	int fast_io_fail;
+	int retain_hwhandler;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
-- 
1.8.0
