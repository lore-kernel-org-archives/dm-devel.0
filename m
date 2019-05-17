From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 5/7] libmpathpersist: factor out
	initialization and teardown
Date: Sat, 18 May 2019 00:57:01 +0200
Message-ID: <20190517225703.16295-6-mwilck@suse.com>
References: <20190517225703.16295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190517225703.16295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dbond@redhat.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

mpath_presistent_reserve_{in,out} share a lot of common code
for initial data structure initialization (discovery) and teardown.
Factor this code out into mpath_persistent_reserve_init_vecs()
(global data structure initialization),
mpath_persistent_reserve_free_vecs (global teardown) and mpath_get_map()
(struct multipath setup for given map device).

Provide __mpath_presistent_reserve_{in,out}, which are the same
as their counterparts without leading underscores, but do not
call the global setup and teardown routines. This allows running
several PR commands in a row without having to re-initialize in
between. Because libmpathpersist is a public API, the previously
known functions don't change behavior.

Don't call path_discovery() any more during global initialization.
We rather do this lazily in the get_mpvec() call chain. dm_get_maps(),
OTOH, is part of the global initialization procedure. In get_mpvec(),
we don't delete non-matching maps any more, because we way want to
act on them later on.
---
 libmpathpersist/mpath_persist.c | 231 ++++++++++++++------------------
 libmpathpersist/mpath_persist.h |  40 ++++++
 2 files changed, 142 insertions(+), 129 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index fee1db72..ce72da67 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -164,48 +164,47 @@ mpath_prin_activepath (struct multipath *mpp, int rq_servact,
 int mpath_persistent_reserve_in (int fd, int rq_servact,
 	struct prin_resp *resp, int noisy, int verbose)
 {
-	struct stat info;
-	vector curmp = NULL;
-	vector pathvec = NULL;
-	char * alias;
-	struct multipath * mpp;
-	int map_present;
-	int major, minor;
-	int ret;
-	struct config *conf;
+	int ret = mpath_persistent_reserve_init_vecs(verbose);
 
-	conf = get_multipath_config();
-	conf->verbosity = verbose;
-	put_multipath_config(conf);
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+	ret = __mpath_persistent_reserve_in(fd, rq_servact, resp, noisy);
+	mpath_persistent_reserve_free_vecs();
+	return ret;
+}
 
-	if (fstat( fd, &info) != 0){
-		condlog(0, "stat error %d", fd);
-		return MPATH_PR_FILE_ERROR;
-	}
-	if(!S_ISBLK(info.st_mode)){
-		condlog(0, "Failed to get major:minor. fd = %d", fd);
-		return MPATH_PR_FILE_ERROR;
-	}
+int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
+	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
+{
+	int ret = mpath_persistent_reserve_init_vecs(verbose);
 
-	major = major(info.st_rdev);
-	minor = minor(info.st_rdev);
-	condlog(4, "Device %d:%d:  ", major, minor);
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+	ret = __mpath_persistent_reserve_out(fd, rq_servact, rq_scope, rq_type,
+					     paramp, noisy);
+	mpath_persistent_reserve_free_vecs();
+	return ret;
+}
 
-	/* get alias from major:minor*/
-	alias = dm_mapname(major, minor);
-	if (!alias){
-		condlog(0, "%d:%d failed to get device alias.", major, minor);
-		return MPATH_PR_DMMP_ERROR;
-	}
+static vector curmp;
+static vector pathvec;
 
-	condlog(3, "alias = %s", alias);
-	map_present = dm_map_present(alias);
-	if (map_present && dm_is_mpath(alias) != 1){
-		condlog( 0, "%s: not a multipath device.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out;
-	}
+void mpath_persistent_reserve_free_vecs(void)
+{
+	free_multipathvec(curmp, KEEP_PATHS);
+	free_pathvec(pathvec, FREE_PATHS);
+	curmp = pathvec = NULL;
+}
+
+int mpath_persistent_reserve_init_vecs(int verbose)
+{
+	struct config *conf = get_multipath_config();
 
+	conf->verbosity = verbose;
+	put_multipath_config(conf);
+
+	if (curmp)
+		return MPATH_PR_SUCCESS;
 	/*
 	 * allocate core vectors to store paths and multipaths
 	 */
@@ -213,70 +212,32 @@ int mpath_persistent_reserve_in (int fd, int rq_servact,
 	pathvec = vector_alloc ();
 
 	if (!curmp || !pathvec){
-		condlog (0, "%s: vector allocation failed.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		if (curmp)
-			vector_free(curmp);
-		if (pathvec)
-			vector_free(pathvec);
-		goto out;
-	}
-
-	if (path_discovery(pathvec, DI_SYSFS | DI_CHECKER) < 0) {
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out1;
+		condlog (0, "vector allocation failed.");
+		goto err;
 	}
 
-	/* get info of all paths from the dm device	*/
-	if (get_mpvec (curmp, pathvec, alias)){
-		condlog(0, "%s: failed to get device info.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out1;
-	}
+	if (dm_get_maps(curmp))
+		goto err;
 
-	mpp = find_mp_by_alias(curmp, alias);
-	if (!mpp){
-		condlog(0, "%s: devmap not registered.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out1;
-	}
-
-	ret = mpath_prin_activepath(mpp, rq_servact, resp, noisy);
+	return MPATH_PR_SUCCESS;
 
-out1:
-	free_multipathvec(curmp, KEEP_PATHS);
-	free_pathvec(pathvec, FREE_PATHS);
-out:
-	FREE(alias);
-	return ret;
+err:
+	mpath_persistent_reserve_free_vecs();
+	return MPATH_PR_DMMP_ERROR;
 }
 
-int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
-	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy, int verbose)
+static int mpath_get_map(int fd, char **palias, struct multipath **pmpp)
 {
-
+	int ret = MPATH_PR_DMMP_ERROR;
 	struct stat info;
-
-	vector curmp = NULL;
-	vector pathvec = NULL;
-
-	char * alias;
-	struct multipath * mpp;
-	int map_present;
 	int major, minor;
-	int ret;
-	uint64_t prkey;
-	struct config *conf;
-
-	conf = get_multipath_config();
-	conf->verbosity = verbose;
-	put_multipath_config(conf);
+	char *alias;
+	struct multipath *mpp;
 
-	if (fstat( fd, &info) != 0){
+	if (fstat(fd, &info) != 0){
 		condlog(0, "stat error fd=%d", fd);
 		return MPATH_PR_FILE_ERROR;
 	}
-
 	if(!S_ISBLK(info.st_mode)){
 		condlog(3, "Failed to get major:minor. fd=%d", fd);
 		return MPATH_PR_FILE_ERROR;
@@ -286,57 +247,73 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	minor = minor(info.st_rdev);
 	condlog(4, "Device  %d:%d", major, minor);
 
-	/* get WWN of the device from major:minor*/
+	/* get alias from major:minor*/
 	alias = dm_mapname(major, minor);
 	if (!alias){
+		condlog(0, "%d:%d failed to get device alias.", major, minor);
 		return MPATH_PR_DMMP_ERROR;
 	}
 
 	condlog(3, "alias = %s", alias);
-	map_present = dm_map_present(alias);
 
-	if (map_present && dm_is_mpath(alias) != 1){
+	if (dm_map_present(alias) && dm_is_mpath(alias) != 1){
 		condlog(3, "%s: not a multipath device.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out;
-	}
-
-	/*
-	 * allocate core vectors to store paths and multipaths
-	 */
-	curmp = vector_alloc ();
-	pathvec = vector_alloc ();
-
-	if (!curmp || !pathvec){
-		condlog (0, "%s: vector allocation failed.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		if (curmp)
-			vector_free(curmp);
-		if (pathvec)
-			vector_free(pathvec);
 		goto out;
 	}
 
-	if (path_discovery(pathvec, DI_SYSFS | DI_CHECKER) < 0) {
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out1;
-	}
-
 	/* get info of all paths from the dm device     */
 	if (get_mpvec(curmp, pathvec, alias)){
 		condlog(0, "%s: failed to get device info.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out1;
+		goto out;
 	}
 
 	mpp = find_mp_by_alias(curmp, alias);
 
 	if (!mpp) {
 		condlog(0, "%s: devmap not registered.", alias);
-		ret = MPATH_PR_DMMP_ERROR;
-		goto out1;
+		goto out;
 	}
 
+	ret = MPATH_PR_SUCCESS;
+	if (pmpp)
+		*pmpp = mpp;
+	if (palias) {
+		*palias = alias;
+		alias = NULL;
+	}
+out:
+	FREE(alias);
+	return ret;
+}
+
+int __mpath_persistent_reserve_in (int fd, int rq_servact,
+	struct prin_resp *resp, int noisy)
+{
+	struct multipath *mpp;
+	int ret;
+
+	ret = mpath_get_map(fd, NULL, &mpp);
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+
+	ret = mpath_prin_activepath(mpp, rq_servact, resp, noisy);
+
+	return ret;
+}
+
+int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
+	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
+{
+	struct multipath *mpp;
+	char *alias;
+	int ret;
+	uint64_t prkey;
+	struct config *conf;
+
+	ret = mpath_get_map(fd, &alias, &mpp);
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+
 	conf = get_multipath_config();
 	select_reservation_key(conf, mpp);
 	select_all_tg_pt(conf, mpp);
@@ -397,10 +374,6 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 		update_prkey(alias, 0);
 	}
 out1:
-	free_multipathvec(curmp, KEEP_PATHS);
-	free_pathvec(pathvec, FREE_PATHS);
-
-out:
 	FREE(alias);
 	return ret;
 }
@@ -412,22 +385,22 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 	struct multipath *mpp;
 	char params[PARAMS_SIZE], status[PARAMS_SIZE];
 
-	if (dm_get_maps (curmp)){
-		return 1;
-	}
-
 	vector_foreach_slot (curmp, mpp, i){
 		/*
 		 * discard out of scope maps
 		 */
-		if (mpp->alias && refwwid &&
-		    strncmp (mpp->alias, refwwid, WWID_SIZE - 1)){
-			free_multipath (mpp, KEEP_PATHS);
-			vector_del_slot (curmp, i);
-			i--;
+		if (!mpp->alias) {
+			condlog(0, "%s: map with empty alias!", __func__);
 			continue;
 		}
 
+		if (mpp->pg != NULL)
+			/* Already seen this one */
+			continue;
+
+		if (refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE - 1))
+			continue;
+
 		dm_get_map(mpp->alias, &mpp->size, params);
 		condlog(3, "params = %s", params);
 		dm_get_status(mpp->alias, status);
diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
index 9a84bc9c..7cf4faf9 100644
--- a/libmpathpersist/mpath_persist.h
+++ b/libmpathpersist/mpath_persist.h
@@ -213,6 +213,15 @@ extern int mpath_lib_exit (struct config *conf);
 extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp *resp,
 		int noisy, int verbose);
 
+/*
+ * DESCRIPTION :
+ * This function is like mpath_persistent_reserve_in(), except that it doesn't call
+ * mpath_persistent_reserve_init_vecs() and mpath_persistent_reserve_free_vecs()
+ * before and after the actual PR call.
+ */
+extern int __mpath_persistent_reserve_in(int fd, int rq_servact,
+		struct prin_resp *resp, int noisy);
+
 /*
  * DESCRIPTION :
  * This function sends PROUT command to the DM device and get the response.
@@ -238,6 +247,37 @@ extern int mpath_persistent_reserve_in (int fd, int rq_servact, struct prin_resp
 extern int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy,
 		int verbose);
+/*
+ * DESCRIPTION :
+ * This function is like mpath_persistent_reserve_out(), except that it doesn't call
+ * mpath_persistent_reserve_init_vecs() and mpath_persistent_reserve_free_vecs()
+ * before and after the actual PR call.
+ */
+extern int __mpath_persistent_reserve_out( int fd, int rq_servact, int rq_scope,
+		unsigned int rq_type, struct prout_param_descriptor *paramp,
+		int noisy);
+
+/*
+ * DESCRIPTION :
+ * This function allocates data structures and performs basic initialization and
+ * device discovery for later calls of __mpath_persistent_reserve_in() or
+ * __mpath_persistent_reserve_out().
+ * @verbose: Set verbosity level. Input argument. value:0 to 3. 0->disabled, 3->Max verbose
+ *
+ * RESTRICTIONS:
+ *
+ * RETURNS: MPATH_PR_SUCCESS if successful else returns any of the status specified
+ *       above in RETURN_STATUS.
+ */
+int mpath_persistent_reserve_init_vecs(int verbose);
+
+/*
+ * DESCRIPTION :
+ * This function frees data structures allocated by
+ * mpath_persistent_reserve_init_vecs().
+ */
+void mpath_persistent_reserve_free_vecs(void);
+
 
 #ifdef __cplusplus
 }
-- 
2.21.0
