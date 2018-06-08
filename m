From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 20/28] libmultipath: allow dumping only "local"
	hwtable in snprint_config
Date: Fri,  8 Jun 2018 12:20:33 +0200
Message-ID: <20180608102041.22904-21-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This change is key for allowing to dump the "local" multipath configuration
only, i.e. those entries of the hardware table that match existing devices
in the system. By passing the output of the new helper function
get_used_hwes() as the last argument for snprint_config(), only the local
entries will be dumped.

The rationale is that "multipath -t" output is overwhelmingly long for most
use cases; in particular it's not useful as a template for creating a local
configuration.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c       |  8 +++++---
 libmultipath/print.h       |  3 ++-
 libmultipath/structs_vec.c | 19 +++++++++++++++++++
 libmultipath/structs_vec.h |  1 +
 libmultipath/vector.c      | 12 ++++++++++++
 libmultipath/vector.h      |  1 +
 multipath/main.c           |  2 +-
 multipathd/cli_handlers.c  |  8 ++++----
 tests/hwtable.c            |  4 ++--
 9 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7d4e2ace..af4c00e2 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1376,7 +1376,8 @@ snprint_hwentry (const struct config *conf,
 }
 
 static int snprint_hwtable(const struct config *conf,
-			   char *buff, int len, vector hwtable)
+			   char *buff, int len,
+			   const struct _vector *hwtable)
 {
 	int fwd = 0;
 	int i;
@@ -1781,7 +1782,8 @@ static int snprint_blacklist_except(const struct config *conf,
 	return fwd;
 }
 
-char *snprint_config(const struct config *conf, int *len)
+char *snprint_config(const struct config *conf, int *len,
+		     const struct _vector *hwtable)
 {
 	char *reply;
 	/* built-in config is >20kB already */
@@ -1810,7 +1812,7 @@ char *snprint_config(const struct config *conf, int *len)
 			continue;
 
 		c += snprint_hwtable(conf, c, reply + maxlen - c,
-				     conf->hwtable);
+				     hwtable ? hwtable : conf->hwtable);
 		if ((c - reply) == maxlen)
 			continue;
 
diff --git a/libmultipath/print.h b/libmultipath/print.h
index fed80d55..c63e0547 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -119,7 +119,8 @@ int _snprint_multipath_topology (const struct gen_multipath *, char *, int,
 	_snprint_multipath_topology (dm_multipath_to_gen(mpp), buf, len, v)
 int snprint_multipath_topology_json (char * buff, int len,
 				const struct vectors * vecs);
-char *snprint_config(const struct config *conf, int *len);
+char *snprint_config(const struct config *conf, int *len,
+		     const struct _vector *hwtable);
 int snprint_multipath_map_json (char * buff, int len,
 				const struct multipath * mpp, int last);
 int snprint_blacklist_report (struct config *, char *, int);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 38f04387..f87d69d4 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -445,3 +445,22 @@ void update_queue_mode_add_path(struct multipath *mpp)
 	}
 	condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_active);
 }
+
+vector get_used_hwes(const struct _vector *pathvec)
+{
+	int i, j;
+	struct path *pp;
+	struct hwentry *hwe;
+	vector v = vector_alloc();
+
+	if (v == NULL)
+		return NULL;
+
+	vector_foreach_slot(pathvec, pp, i) {
+		vector_foreach_slot_backwards(pp->hwe, hwe, j) {
+			vector_find_or_add_slot(v, hwe);
+		}
+	}
+
+	return v;
+}
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 4220ea33..f7777aaf 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -38,5 +38,6 @@ void update_queue_mode_add_path(struct multipath *mpp);
 int update_multipath_table (struct multipath *mpp, vector pathvec,
 			    int is_daemon);
 int update_multipath_status (struct multipath *mpp);
+vector get_used_hwes(const struct _vector *pathvec);
 
 #endif /* _STRUCTS_VEC_H */
diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index f741ae08..501cf4c5 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -196,3 +196,15 @@ vector_set_slot(vector v, void *value)
 	i = VECTOR_SIZE(v) - 1;
 	v->slot[i] = value;
 }
+
+int vector_find_or_add_slot(vector v, void *value)
+{
+	int n = find_slot(v, value);
+
+	if (n >= 0)
+		return n;
+	if (vector_alloc_slot(v) == NULL)
+		return -1;
+	vector_set_slot(v, value);
+	return VECTOR_SIZE(v) - 1;
+}
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index b9450ac8..41d2b896 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -82,6 +82,7 @@ extern void vector_set_slot(vector v, void *value);
 extern void vector_del_slot(vector v, int slot);
 extern void *vector_insert_slot(vector v, int slot, void *value);
 int find_slot(vector v, void * addr);
+int vector_find_or_add_slot(vector v, void *value);
 extern void vector_repack(vector v);
 extern void vector_dump(vector v);
 extern void dump_strvec(vector strvec);
diff --git a/multipath/main.c b/multipath/main.c
index 288251c3..87d80dd3 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -753,7 +753,7 @@ out:
 static int
 dump_config (struct config *conf)
 {
-	char * reply = snprint_config(conf, NULL);
+	char * reply = snprint_config(conf, NULL, NULL);
 
 	if (reply != NULL) {
 		printf("%s", reply);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6f043d7f..75cc8a9e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -245,15 +245,15 @@ show_map_json (char ** r, int * len, struct multipath * mpp,
 	return 0;
 }
 
-int
-show_config (char ** r, int * len)
+static int
+show_config (char ** r, int * len, const struct _vector *hwtable)
 {
 	struct config *conf;
 	char *reply;
 
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	reply = snprint_config(conf, len);
+	reply = snprint_config(conf, len, hwtable);
 	pthread_cleanup_pop(1);
 	if (reply == NULL)
 		return 1;
@@ -277,7 +277,7 @@ cli_list_config (void * v, char ** reply, int * len, void * data)
 {
 	condlog(3, "list config (operator)");
 
-	return show_config(reply, len);
+	return show_config(reply, len, NULL);
 }
 
 int
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 85924fb7..3c3caddd 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -454,7 +454,7 @@ static void replicate_config(const struct hwt_state *hwt)
 	condlog(1, "--- %s: replicating configuration", __func__);
 
 	conf = get_multipath_config();
-	cfg1 = snprint_config(conf, NULL);
+	cfg1 = snprint_config(conf, NULL, NULL);
 
 	assert_non_null(cfg1);
 	put_multipath_config(conf);
@@ -462,7 +462,7 @@ static void replicate_config(const struct hwt_state *hwt)
 	replace_config(hwt, cfg1);
 
 	conf = get_multipath_config();
-	cfg2 = snprint_config(conf, NULL);
+	cfg2 = snprint_config(conf, NULL, NULL);
 	assert_non_null(cfg2);
 	put_multipath_config(conf);
 
-- 
2.17.0
