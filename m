From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/3] Add options to multipathd to turn off
	queueing
Date: Thu, 12 Mar 2009 13:38:13 -0500
Message-ID: <1236883093-2989-4-git-send-email-bmarzins@redhat.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Even when the last path of a multipath device is deleted, it can't be
removed until all the queued IO is flushed. For devices that have
no_path_retry set to queue, this doesn't automatically happen.

This patch adds a "flush_on_last_del" config file option, that causes the
multipath device to automatically turn off queueing when the last path is
deleted.  It also adds the "disablequeueing" and "restorequeueing"
multipathd cli commands.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |    1 +
 libmultipath/config.h      |    3 +
 libmultipath/dict.c        |  117 ++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/propsel.c     |   32 ++++++++++++
 libmultipath/propsel.h     |    1 +
 libmultipath/structs.h     |    9 +++
 libmultipath/structs_vec.c |    1 +
 multipath.conf.annotated   |   30 +++++++++++
 multipath.conf.synthetic   |    1 +
 multipathd/cli.c           |    2 +
 multipathd/cli.h           |    4 ++
 multipathd/cli_handlers.c  |   90 +++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h  |    4 ++
 multipathd/main.c          |   12 +++++
 14 files changed, 307 insertions(+), 0 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 6d731d2..6393880 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -427,6 +427,7 @@ load_config (char * file)
 	conf->max_fds = 0;
 	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
+	conf->flush_on_last_del = 0;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index fb917f4..4523aa8 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -28,6 +28,7 @@ struct hwentry {
 	int no_path_retry;
 	int minio;
 	int pg_timeout;
+	int flush_on_last_del;
 	char * bl_product;
 };
 
@@ -43,6 +44,7 @@ struct mpentry {
 	int no_path_retry;
 	int minio;
 	int pg_timeout;
+	int flush_on_last_del;
 };
 
 struct config {
@@ -64,6 +66,7 @@ struct config {
 	int pg_timeout;
 	int max_fds;
 	int force_reload;
+	int flush_on_last_del;
 
 	char * dev;
 	char * sysfs_dir;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 2429a93..fc8516b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -247,6 +247,28 @@ def_pg_timeout_handler(vector strvec)
 }
 
 static int
+def_flush_on_last_del_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
+		conf->flush_on_last_del = FLUSH_DISABLED;
+	if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
+		conf->flush_on_last_del = FLUSH_ENABLED;
+	else
+		conf->flush_on_last_del = FLUSH_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
+static int
 names_handler(vector strvec)
 {
 	char * buff;
@@ -724,6 +746,32 @@ hw_pg_timeout_handler(vector strvec)
 	return 0;
 }
 
+static int
+hw_flush_on_last_del_handler(vector strvec)
+{
+	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	char * buff;
+
+	if (!hwe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
+		hwe->flush_on_last_del = FLUSH_DISABLED;
+	if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
+		hwe->flush_on_last_del = FLUSH_ENABLED;
+	else
+		hwe->flush_on_last_del = FLUSH_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * multipaths block handlers
  */
@@ -945,6 +993,32 @@ mp_pg_timeout_handler(vector strvec)
 	return 0;
 }
 
+static int
+mp_flush_on_last_del_handler(vector strvec)
+{
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+	char * buff;
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && strcmp(buff, "no") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "0") == 0))
+		mpe->flush_on_last_del = FLUSH_DISABLED;
+	if ((strlen(buff) == 3 && strcmp(buff, "yes") == 0) ||
+	    (strlen(buff) == 1 && strcmp(buff, "1") == 0))
+		mpe->flush_on_last_del = FLUSH_ENABLED;
+	else
+		mpe->flush_on_last_del = FLUSH_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * config file keywords printing
  */
@@ -1080,6 +1154,20 @@ snprint_mp_pg_timeout (char * buff, int len, void * data)
 }
 
 static int
+snprint_mp_flush_on_last_del (char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	switch (mpe->flush_on_last_del) {
+	case FLUSH_DISABLED:
+		return snprintf(buff, len, "no");
+	case FLUSH_ENABLED:
+		return snprintf(buff, len, "yes");
+	}
+	return 0;
+}
+
+static int
 snprint_hw_vendor (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -1295,6 +1383,20 @@ snprint_hw_pg_timeout (char * buff, int len, void * data)
 }
 
 static int
+snprint_hw_flush_on_last_del (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	switch (hwe->flush_on_last_del) {
+	case FLUSH_DISABLED:
+		return snprintf(buff, len, "no");
+	case FLUSH_ENABLED:
+		return snprintf(buff, len, "yes");
+	}
+	return 0;
+}
+
+static int
 snprint_hw_path_checker (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -1509,6 +1611,18 @@ snprint_def_pg_timeout (char * buff, int len, void * data)
 }
 
 static int
+snprint_def_flush_on_last_del (char * buff, int len, void * data)
+{
+	switch (conf->flush_on_last_del) {
+	case FLUSH_DISABLED:
+		return snprintf(buff, len, "no");
+	case FLUSH_ENABLED:
+		return snprintf(buff, len, "yes");
+	}
+	return 0;
+}
+
+static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
 	if (conf->user_friendly_names == DEFAULT_USER_FRIENDLY_NAMES)
@@ -1565,6 +1679,7 @@ init_keywords(void)
 	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
+	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
@@ -1619,6 +1734,7 @@ init_keywords(void)
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
 	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_rr_min_io);
 	install_keyword("pg_timeout", &hw_pg_timeout_handler, &snprint_hw_pg_timeout);
+	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
@@ -1633,5 +1749,6 @@ init_keywords(void)
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_rr_min_io);
 	install_keyword("pg_timeout", &mp_pg_timeout_handler, &snprint_mp_pg_timeout);
+	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
 	install_sublevel_end();
 }
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 43611ff..c1bc591 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -279,6 +279,10 @@ select_prio (struct path * pp)
 extern int
 select_no_path_retry(struct multipath *mp)
 {
+	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS) {
+		condlog(0, "flush_on_last_del in progress");
+		mp->no_path_retry = NO_PATH_RETRY_FAIL;
+	}
 	if (mp->mpe && mp->mpe->no_path_retry != NO_PATH_RETRY_UNDEF) {
 		mp->no_path_retry = mp->mpe->no_path_retry;
 		condlog(3, "%s: no_path_retry = %i (multipath setting)",
@@ -368,3 +372,31 @@ select_pg_timeout(struct multipath *mp)
 	condlog(3, "pg_timeout = NONE (internal default)");
 	return 0;
 }
+
+extern int
+select_flush_on_last_del(struct multipath *mp)
+{
+	if (mp->flush_on_last_del == FLUSH_IN_PROGRESS)
+		return 0;
+	if (mp->mpe && mp->mpe->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = mp->mpe->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (multipath setting)",
+				mp->flush_on_last_del);
+		return 0;
+	}
+	if (mp->hwe && mp->hwe->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = mp->hwe->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (controler setting)",
+				mp->flush_on_last_del);
+		return 0;
+	}
+	if (conf->flush_on_last_del != FLUSH_UNDEF) {
+		mp->flush_on_last_del = conf->flush_on_last_del;
+		condlog(3, "flush_on_last_del = %i (config file default)",
+				mp->flush_on_last_del);
+		return 0;
+	}
+	mp->flush_on_last_del = FLUSH_UNDEF;
+	condlog(3, "flush_on_last_del = DISABLED (internal default)");
+	return 0;
+}
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 62802f8..818060b 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -10,4 +10,5 @@ int select_getuid (struct path * pp);
 int select_prio (struct path * pp);
 int select_no_path_retry(struct multipath *mp);
 int select_pg_timeout(struct multipath *mp);
+int select_flush_on_last_del(struct multipath *mp);
 int select_minio(struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index aeb4afd..eb21ab2 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -67,6 +67,14 @@ enum pgtimeouts {
 	PGTIMEOUT_NONE
 };
 
+
+enum flush_states {
+	FLUSH_UNDEF,
+	FLUSH_DISABLED,
+	FLUSH_ENABLED,
+	FLUSH_IN_PROGRESS,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
@@ -150,6 +158,7 @@ struct multipath {
 	int retry_tick;    /* remaining times for retries */
 	int minio;
 	int pg_timeout;
+	int flush_on_last_del;
 	unsigned long long size;
 	vector paths;
 	vector pg;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 785a766..0ff7273 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -321,6 +321,7 @@ retry:
 	select_pgfailback(mpp);
 	set_no_path_retry(mpp);
 	select_pg_timeout(mpp);
+	select_flush_on_last_del(mpp);
 
 	return 0;
 out:
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index bf15dc3..10aa5eb 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -99,6 +99,16 @@
 #	rr_min_io	100
 #
 #	#
+#	# name    : flush_on_last_del
+#	# scope   : multipathd
+#	# desc    : If set to "yes", multipathd will disable queueing when the
+#	#           last path to a device has been deleted.
+#	# values  : yes|no
+#	# default : no
+#	#
+#	flush_on_last_del       yes
+#
+#	#
 #	# name    : max_fds
 #	# scope   : multipathd
 #	# desc    : Sets the maximum number of open file descriptors for the
@@ -278,6 +288,16 @@
 #		#           to the next in the same path group
 #		#
 #		rr_min_io	100
+#
+#		#
+#		# name    : flush_on_last_del
+#		# scope   : multipathd
+#		# desc    : If set to "yes", multipathd will disable queueing
+#		#           when the last path to a device has been deleted.
+#		# values  : yes|no
+#		# default : no
+#		#
+#		flush_on_last_del       yes
 #	}
 #	multipath {
 #		wwid	1DEC_____321816758474
@@ -419,6 +439,16 @@
 #		rr_min_io	100
 #
 #		#
+#		# name    : flush_on_last_del
+#		# scope   : multipathd
+#		# desc    : If set to "yes", multipathd will disable queueing
+#		#           when the last path to a device has been deleted.
+#		# values  : yes|no
+#		# default : no
+#		#
+#		flush_on_last_del       yes
+#
+#		#
 #		# name    : product_blacklist
 #		# scope   : multipath & multipathd
 #		# desc    : product strings to blacklist for this vendor
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
index a762016..bf94c04 100644
--- a/multipath.conf.synthetic
+++ b/multipath.conf.synthetic
@@ -11,6 +11,7 @@
 #	prio			const
 #	path_checker		directio
 #	rr_min_io		100
+#	flush_on_last_del	no
 #	max_fds			8192
 #	rr_weight		priorities
 #	failback		immediate
diff --git a/multipathd/cli.c b/multipathd/cli.c
index c93aa83..c1af9fb 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -155,6 +155,8 @@ load_keys (void)
 	r += add_key(keys, "resume", RESUME, 0);
 	r += add_key(keys, "reinstate", REINSTATE, 0);
 	r += add_key(keys, "fail", FAIL, 0);
+	r += add_key(keys, "disablequeueing", DISABLEQ, 0);
+	r += add_key(keys, "restorequeueing", RESTOREQ, 0);
 	r += add_key(keys, "paths", PATHS, 0);
 	r += add_key(keys, "maps", MAPS, 0);
 	r += add_key(keys, "multipaths", MAPS, 0);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index d58a200..b33cd13 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -7,6 +7,8 @@ enum {
 	__RESUME,
 	__REINSTATE,
 	__FAIL,
+	__DISABLEQ,
+	__RESTOREQ,
 	__PATHS,
 	__MAPS,
 	__PATH,
@@ -32,6 +34,8 @@ enum {
 #define RESUME		(1 << __RESUME)
 #define REINSTATE	(1 << __REINSTATE)
 #define FAIL		(1 << __FAIL)
+#define DISABLEQ	(1 << __DISABLEQ)
+#define RESTOREQ	(1 << __RESTOREQ)
 #define PATHS		(1 << __PATHS)
 #define MAPS		(1 << __MAPS)
 #define PATH		(1 << __PATH)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6cf232a..a75373b 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -420,6 +420,96 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 }
 
 int
+cli_restore_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * mapname = get_keyparam(v, MAP);
+	struct multipath *mpp;
+	int minor;
+
+	condlog(2, "%s: restore map queueing (operator)", mapname);
+	if (sscanf(mapname, "dm-%d", &minor) == 1)
+		mpp = find_mp_by_minor(vecs->mpvec, minor);
+	else
+		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+
+	if (!mpp) {
+		condlog(0, "%s: invalid map name, cannot restore queueing", mapname);
+		return 1;
+	}
+
+	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+			mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
+		dm_queue_if_no_path(mpp->alias, 1);
+		if (mpp->nr_active > 0)
+			mpp->retry_tick = 0;
+		else
+			mpp->retry_tick = mpp->no_path_retry * conf->checkint;
+	}
+	return 0;
+}
+
+int
+cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	struct multipath *mpp;
+	int i;
+
+	condlog(2, "restore queueing (operator)");
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+		    mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
+			dm_queue_if_no_path(mpp->alias, 1);
+			if (mpp->nr_active > 0)
+				mpp->retry_tick = 0;
+			else
+				mpp->retry_tick = mpp->no_path_retry * conf->checkint;
+		}
+	}
+	return 0;
+}
+
+int
+cli_disable_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * mapname = get_keyparam(v, MAP);
+	struct multipath *mpp;
+	int minor;
+
+	condlog(2, "%s: disable map queueing (operator)", mapname);
+	if (sscanf(mapname, "dm-%d", &minor) == 1)
+		mpp = find_mp_by_minor(vecs->mpvec, minor);
+	else
+		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+
+	if (!mpp) {
+		condlog(0, "%s: invalid map name, cannot disable queueing", mapname);
+		return 1;
+	}
+
+	mpp->retry_tick = 0;
+	dm_queue_if_no_path(mpp->alias, 0);
+	return 0;
+}
+
+int
+cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	struct multipath *mpp;
+	int i;
+
+	condlog(2, "disable queueing (operator)");
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		mpp->retry_tick = 0;
+		dm_queue_if_no_path(mpp->alias, 0);
+	}
+	return 0;
+}
+
+int
 cli_switch_group(void * v, char ** reply, int * len, void * data)
 {
 	char * mapname = get_keyparam(v, MAP);
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index f57a160..10adaf9 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -17,6 +17,10 @@ int cli_add_map (void * v, char ** reply, int * len, void * data);
 int cli_del_map (void * v, char ** reply, int * len, void * data);
 int cli_switch_group(void * v, char ** reply, int * len, void * data);
 int cli_reconfigure(void * v, char ** reply, int * len, void * data);
+int cli_disable_queueing(void * v, char ** reply, int * len, void * data);
+int cli_disable_all_queueing(void * v, char ** reply, int * len, void * data);
+int cli_restore_queueing(void * v, char ** reply, int * len, void * data);
+int cli_restore_all_queueing(void * v, char ** reply, int * len, void * data);
 int cli_suspend(void * v, char ** reply, int * len, void * data);
 int cli_resume(void * v, char ** reply, int * len, void * data);
 int cli_reinstate(void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index dae9152..aedeeab 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -393,6 +393,7 @@ rescan:
 			return 1; /* leave path added to pathvec */
 
 		verify_paths(mpp, vecs, NULL);
+		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 	}
 	else {
@@ -503,6 +504,13 @@ ev_remove_path (char * devname, struct vectors * vecs)
 			 * flush_map will fail if the device is open
 			 */
 			strncpy(alias, mpp->alias, WWID_SIZE);
+			if (mpp->flush_on_last_del == FLUSH_ENABLED) {
+				condlog(2, "%s Last path deleted, disabling queueing", mpp->alias);
+				mpp->retry_tick = 0;
+				mpp->no_path_retry = NO_PATH_RETRY_FAIL;
+				mpp->flush_on_last_del = FLUSH_IN_PROGRESS;
+				dm_queue_if_no_path(mpp->alias, 0);
+			}
 			if (!flush_map(mpp, vecs)) {
 				condlog(2, "%s: removed map after"
 					" removing all paths",
@@ -725,6 +733,10 @@ uxlsnrloop (void * ap)
 	set_handler_callback(RESUME+MAP, cli_resume);
 	set_handler_callback(REINSTATE+PATH, cli_reinstate);
 	set_handler_callback(FAIL+PATH, cli_fail);
+	set_handler_callback(DISABLEQ+MAP, cli_disable_queueing);
+	set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
+	set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
+	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
 	set_handler_callback(QUIT, cli_quit);
 
 	uxsock_listen(&uxsock_trigger, ap);
-- 
1.5.3.3
