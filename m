From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/30] Deprecate pg_timeout
Date: Tue, 16 Jul 2013 09:12:58 +0200
Message-ID: <1373958801-103613-8-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

pg_timeout has been removed from dm-multipath, so deprecate it
from userspace, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c      |  2 --
 libmultipath/config.h      |  3 --
 libmultipath/configure.c   | 15 +---------
 libmultipath/devmapper.c   | 10 -------
 libmultipath/devmapper.h   |  1 -
 libmultipath/dict.c        | 75 +++-------------------------------------------
 libmultipath/propsel.c     | 39 ------------------------
 libmultipath/propsel.h     |  1 -
 libmultipath/structs.h     |  1 -
 libmultipath/structs_vec.c |  1 -
 multipath.conf.defaults    |  1 -
 11 files changed, 5 insertions(+), 144 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a322dfe..138e6b4 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -327,7 +327,6 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(no_path_retry);
 	merge_num(minio);
 	merge_num(minio_rq);
-	merge_num(pg_timeout);
 	merge_num(flush_on_last_del);
 	merge_num(fast_io_fail);
 	merge_num(dev_loss);
@@ -397,7 +396,6 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->no_path_retry = dhwe->no_path_retry;
 	hwe->minio = dhwe->minio;
 	hwe->minio_rq = dhwe->minio_rq;
-	hwe->pg_timeout = dhwe->pg_timeout;
 	hwe->flush_on_last_del = dhwe->flush_on_last_del;
 	hwe->fast_io_fail = dhwe->fast_io_fail;
 	hwe->dev_loss = dhwe->dev_loss;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 405a8f3..f1578a8 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -41,7 +41,6 @@ struct hwentry {
 	int no_path_retry;
 	int minio;
 	int minio_rq;
-	int pg_timeout;
 	int flush_on_last_del;
 	int fast_io_fail;
 	unsigned int dev_loss;
@@ -67,7 +66,6 @@ struct mpentry {
 	int no_path_retry;
 	int minio;
 	int minio_rq;
-	int pg_timeout;
 	int flush_on_last_del;
 	int attribute_flags;
 	int user_friendly_names;
@@ -93,7 +91,6 @@ struct config {
 	int no_path_retry;
 	int user_friendly_names;
 	int bindings_read_only;
-	int pg_timeout;
 	int max_fds;
 	int force_reload;
 	int queue_without_daemon;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e5048eb..1cf46cc 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -69,7 +69,6 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_rr_weight(mpp);
 	select_minio(mpp);
 	select_no_path_retry(mpp);
-	select_pg_timeout(mpp);
 	select_mode(mpp);
 	select_uid(mpp);
 	select_gid(mpp);
@@ -210,7 +209,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 			mpp->alias);
 		return;
 	}
-	if (!mpp->no_path_retry && !mpp->pg_timeout &&
+	if (!mpp->no_path_retry &&
 	    (strlen(cmpp->features) != strlen(mpp->features) ||
 	     strcmp(cmpp->features, mpp->features))) {
 		mpp->action =  ACT_RELOAD;
@@ -627,12 +626,6 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 						    "queue_if_no_path");
 			}
 		}
-		if (mpp->pg_timeout != PGTIMEOUT_UNDEF) {
-			if (mpp->pg_timeout == -PGTIMEOUT_NONE)
-				dm_set_pg_timeout(mpp->alias,  0);
-			else
-				dm_set_pg_timeout(mpp->alias, mpp->pg_timeout);
-		}
 
 		if (!conf->daemon && mpp->action != ACT_NOTHING)
 			print_multipath_topology(mpp, conf->verbosity);
@@ -821,12 +814,6 @@ extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh)
 		else
 			dm_queue_if_no_path(mpp->alias, 1);
 	}
-	if (mpp->pg_timeout != PGTIMEOUT_UNDEF) {
-		if (mpp->pg_timeout == -PGTIMEOUT_NONE)
-			dm_set_pg_timeout(mpp->alias,  0);
-		else
-			dm_set_pg_timeout(mpp->alias, mpp->pg_timeout);
-	}
 
 	return 0;
 }
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 67481c4..69f475c 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -806,16 +806,6 @@ dm_queue_if_no_path(char *mapname, int enable)
 	return dm_message(mapname, message);
 }
 
-int
-dm_set_pg_timeout(char *mapname, int timeout_val)
-{
-	char message[24];
-
-	if (snprintf(message, 24, "set_pg_timeout %d", timeout_val) >= 24)
-		return 1;
-	return dm_message(mapname, message);
-}
-
 static int
 dm_groupmsg (char * msg, char * mapname, int index)
 {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index bf8ee91..8ea9dd3 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -27,7 +27,6 @@ int dm_flush_maps (void);
 int dm_fail_path(char * mapname, char * path);
 int dm_reinstate_path(char * mapname, char * path);
 int dm_queue_if_no_path(char *mapname, int enable);
-int dm_set_pg_timeout(char *mapname, int timeout_val);
 int dm_switchgroup(char * mapname, int index);
 int dm_enablegroup(char * mapname, int index);
 int dm_disablegroup(char * mapname, int index);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 14e7c57..757d220 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -470,7 +470,6 @@ def_checker_timeout_handler(vector strvec)
 static int
 def_pg_timeout_handler(vector strvec)
 {
-	int pg_timeout;
 	char * buff;
 
 	buff = set_value(strvec);
@@ -478,16 +477,7 @@ def_pg_timeout_handler(vector strvec)
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 4 && !strcmp(buff, "none"))
-		conf->pg_timeout = -PGTIMEOUT_NONE;
-	else if (sscanf(buff, "%d", &pg_timeout) == 1 && pg_timeout >= 0) {
-		if (pg_timeout == 0)
-			conf->pg_timeout = -PGTIMEOUT_NONE;
-		else
-			conf->pg_timeout = pg_timeout;
-	}
-	else
-		conf->pg_timeout = PGTIMEOUT_UNDEF;
+	/* Deprecated; device-mapper support has been removed */
 
 	FREE(buff);
 	return 0;
@@ -1214,28 +1204,14 @@ hw_minio_rq_handler(vector strvec)
 static int
 hw_pg_timeout_handler(vector strvec)
 {
-	int pg_timeout;
-	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
 	char *buff;
 
-	if (!hwe)
-		return 1;
-
 	buff = set_value(strvec);
 
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 4 && !strcmp(buff, "none"))
-		hwe->pg_timeout = -PGTIMEOUT_NONE;
-	else if (sscanf(buff, "%d", &pg_timeout) == 1 && pg_timeout >= 0) {
-		if (pg_timeout == 0)
-			hwe->pg_timeout = -PGTIMEOUT_NONE;
-		else
-			hwe->pg_timeout = pg_timeout;
-	}
-	else
-		hwe->pg_timeout = PGTIMEOUT_UNDEF;
+	/* Deprecated; device-mapper support has been removed */
 
 	FREE(buff);
 	return 0;
@@ -1648,27 +1624,14 @@ mp_minio_rq_handler(vector strvec)
 static int
 mp_pg_timeout_handler(vector strvec)
 {
-	int pg_timeout;
-	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
 	char *buff;
 
-	if (!mpe)
-		return 1;
-
 	buff = set_value(strvec);
 
 	if (!buff)
 		return 1;
-	if (strlen(buff) == 4 && !strcmp(buff, "none"))
-		mpe->pg_timeout = -PGTIMEOUT_NONE;
-	else if (sscanf(buff, "%d", &pg_timeout) == 1 && pg_timeout >= 0) {
-		if (pg_timeout == 0)
-			mpe->pg_timeout = -PGTIMEOUT_NONE;
-		else
-			mpe->pg_timeout = pg_timeout;
-	}
-	else
-		mpe->pg_timeout = PGTIMEOUT_UNDEF;
+
+	/* Deprecated; device-mapper support has been removed */
 
 	FREE(buff);
 	return 0;
@@ -1983,16 +1946,6 @@ snprint_mp_rr_min_io_rq (char * buff, int len, void * data)
 static int
 snprint_mp_pg_timeout (char * buff, int len, void * data)
 {
-	struct mpentry * mpe = (struct mpentry *)data;
-
-	switch (mpe->pg_timeout) {
-	case PGTIMEOUT_UNDEF:
-		break;
-	case -PGTIMEOUT_NONE:
-		return snprintf(buff, len, "\"none\"");
-	default:
-		return snprintf(buff, len, "%i", mpe->pg_timeout);
-	}
 	return 0;
 }
 
@@ -2330,19 +2283,6 @@ snprint_hw_rr_min_io_rq (char * buff, int len, void * data)
 static int
 snprint_hw_pg_timeout (char * buff, int len, void * data)
 {
-	struct hwentry * hwe = (struct hwentry *)data;
-
-	if (!hwe->pg_timeout)
-		return 0;
-
-	switch (hwe->pg_timeout) {
-	case PGTIMEOUT_UNDEF:
-		break;
-	case -PGTIMEOUT_NONE:
-		return snprintf(buff, len, "\"none\"");
-	default:
-		return snprintf(buff, len, "%i", hwe->pg_timeout);
-	}
 	return 0;
 }
 
@@ -2665,13 +2605,6 @@ snprint_def_checker_timeout (char *buff, int len, void *data)
 static int
 snprint_def_pg_timeout (char * buff, int len, void * data)
 {
-	switch (conf->pg_timeout) {
-	case PGTIMEOUT_UNDEF:
-	case -PGTIMEOUT_NONE:
-		return snprintf(buff, len, "\"none\"");
-	default:
-		return snprintf(buff, len, "%i", conf->pg_timeout);
-	}
 	return 0;
 }
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index a7e1fc2..613dafc 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -541,45 +541,6 @@ select_minio (struct multipath * mp)
 }
 
 extern int
-select_pg_timeout(struct multipath *mp)
-{
-	if (mp->mpe && mp->mpe->pg_timeout != PGTIMEOUT_UNDEF) {
-		mp->pg_timeout = mp->mpe->pg_timeout;
-		if (mp->pg_timeout > 0)
-			condlog(3, "%s: pg_timeout = %d (multipath setting)",
-				mp->alias, mp->pg_timeout);
-		else
-			condlog(3, "%s: pg_timeout = NONE (multipath setting)",
-				mp->alias);
-		return 0;
-	}
-	if (mp->hwe && mp->hwe->pg_timeout != PGTIMEOUT_UNDEF) {
-		mp->pg_timeout = mp->hwe->pg_timeout;
-		if (mp->pg_timeout > 0)
-			condlog(3, "%s: pg_timeout = %d (controller setting)",
-				mp->alias, mp->pg_timeout);
-		else
-			condlog(3, "%s: pg_timeout = NONE (controller setting)",
-				mp->alias);
-		return 0;
-	}
-	if (conf->pg_timeout != PGTIMEOUT_UNDEF) {
-		mp->pg_timeout = conf->pg_timeout;
-		if (mp->pg_timeout > 0)
-			condlog(3, "%s: pg_timeout = %d (config file default)",
-				mp->alias, mp->pg_timeout);
-		else
-			condlog(3,
-				"%s: pg_timeout = NONE (config file default)",
-				mp->alias);
-		return 0;
-	}
-	mp->pg_timeout = PGTIMEOUT_UNDEF;
-	condlog(3, "%s: pg_timeout = NONE (internal default)", mp->alias);
-	return 0;
-}
-
-extern int
 select_fast_io_fail(struct multipath *mp)
 {
 	if (mp->hwe && mp->hwe->fast_io_fail != MP_FAST_IO_FAIL_UNSET) {
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index eb1e534..05c6a4e 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -9,7 +9,6 @@ int select_checker(struct path *pp);
 int select_getuid (struct path * pp);
 int select_prio (struct path * pp);
 int select_no_path_retry(struct multipath *mp);
-int select_pg_timeout(struct multipath *mp);
 int select_flush_on_last_del(struct multipath *mp);
 int select_minio(struct multipath *mp);
 int select_mode(struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 59387d6..ef3d76f 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -201,7 +201,6 @@ struct multipath {
 	int no_path_retry; /* number of retries after all paths are down */
 	int retry_tick;    /* remaining times for retries */
 	int minio;
-	int pg_timeout;
 	int flush_on_last_del;
 	int attribute_flags;
 	int fast_io_fail;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 72622b0..186cd0e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -363,7 +363,6 @@ __setup_multipath (struct vectors * vecs, struct multipath * mpp, int reset)
 		select_rr_weight(mpp);
 		select_pgfailback(mpp);
 		set_no_path_retry(mpp);
-		select_pg_timeout(mpp);
 		select_flush_on_last_del(mpp);
 	}
 
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index ad32343..cd13369 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -17,7 +17,6 @@
 #	max_fds 1048576
 #	rr_weight "uniform"
 #	queue_without_daemon "yes"
-#	pg_timeout "none"
 #	flush_on_last_del "no"
 #	user_friendly_names "no"
 #	fast_io_fail_tmo 5
-- 
1.7.12.4
