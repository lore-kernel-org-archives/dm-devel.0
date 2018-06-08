From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/28] libmultipath: use vector for for pp->hwe
	and mp->hwe
Date: Fri,  8 Jun 2018 12:20:25 +0200
Message-ID: <20180608102041.22904-13-mwilck@suse.com>
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

Change the data structure of "struct path" and "struct multipath"
such that the "hwe" entry is a vector of hwentry structures rather
than a single hwentry structure. Add respective code to the
constructors and destructors (note that mp->hwe is never allocated,
it's always a pointer to a path hwe).

Change find_hwe() to fill in the passed vector rather than returning
a hwentry pointer. Change the propsel code to look through vectors
of hwentries to determine a given property.

This patch just creates the new data structure and the functions to
deal with them, it doesn't introduce semantic changes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c    | 21 ++++++++++------
 libmultipath/config.h    |  6 ++---
 libmultipath/discovery.c | 10 ++++----
 libmultipath/propsel.c   | 53 ++++++++++++++++++++++++++++++++++------
 libmultipath/structs.c   |  6 +++++
 libmultipath/structs.h   |  4 +--
 6 files changed, 75 insertions(+), 25 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 9e2f166f..95a71447 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -113,27 +113,34 @@ static void _log_match(const char *fn, const struct hwentry *h,
 }
 #define log_match(h, v, p, r) _log_match(__func__, (h), (v), (p), (r))
 
-struct hwentry *
+int
 find_hwe (const struct _vector *hwtable,
-	  const char * vendor, const char * product, const char * revision)
+	  const char * vendor, const char * product, const char * revision,
+	  vector result)
 {
-	int i;
-	struct hwentry *tmp, *ret = NULL;
+	int i, n = 0;
+	struct hwentry *tmp;
 
 	/*
-	 * Search backwards here.
+	 * Search backwards here, and add forward.
 	 * User modified entries are attached at the end of
 	 * the list, so we have to check them first before
 	 * continuing to the generic entries
 	 */
+	vector_reset(result);
 	vector_foreach_slot_backwards (hwtable, tmp, i) {
 		if (hwe_regmatch(tmp, vendor, product, revision))
 			continue;
-		ret = tmp;
+		if (vector_alloc_slot(result) != NULL) {
+			vector_set_slot(result, tmp);
+			n++;
+		}
 		log_match(tmp, vendor, product, revision);
 		break;
 	}
-	return ret;
+	condlog(n > 1 ? 3 : 4, "%s: found %d hwtable matches for %s:%s:%s",
+		__func__, n, vendor, product, revision);
+	return n;
 }
 
 struct mpentry *find_mpe(vector mptable, char *wwid)
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 83eaf62f..e1cbd59b 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -213,9 +213,9 @@ struct config {
 
 extern struct udev * udev;
 
-struct hwentry * find_hwe (const struct _vector *hwtable,
-			   const char * vendor, const char * product,
-			   const char *revision);
+int find_hwe (const struct _vector *hwtable,
+	      const char * vendor, const char * product, const char *revision,
+	      vector result);
 struct mpentry * find_mpe (vector mptable, char * wwid);
 char * get_mpe_wwid (vector mptable, char * alias);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1ef1dfa7..b974d6cd 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1176,7 +1176,7 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, pp->rev);
+	find_hwe(hwtable, pp->vendor_id, pp->product_id, pp->rev, pp->hwe);
 
 	/*
 	 * host / bus / target / lun
@@ -1240,7 +1240,7 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 	condlog(3, "%s: serial = %s", pp->dev, pp->serial);
 	condlog(3, "%s: rev = %s", pp->dev, pp->rev);
 
-	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
+	find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL, pp->hwe);
 
 	return 0;
 }
@@ -1256,7 +1256,7 @@ rbd_sysfs_pathinfo (struct path * pp, vector hwtable)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
+	find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL, pp->hwe);
 	return 0;
 }
 
@@ -1297,7 +1297,7 @@ ccw_sysfs_pathinfo (struct path * pp, vector hwtable)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL);
+	find_hwe(hwtable, pp->vendor_id, pp->product_id, NULL, pp->hwe);
 
 	/*
 	 * host / bus / target / lun
@@ -1360,7 +1360,7 @@ cciss_sysfs_pathinfo (struct path * pp, vector hwtable)
 	/*
 	 * set the hwe configlet pointer
 	 */
-	pp->hwe = find_hwe(hwtable, pp->vendor_id, pp->product_id, pp->rev);
+	find_hwe(hwtable, pp->vendor_id, pp->product_id, pp->rev, pp->hwe);
 
 	/*
 	 * host / bus / target / lun
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 018f4879..d645507e 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -44,6 +44,23 @@ do {									\
 	}								\
 } while(0)
 
+#define do_set_from_vec(type, var, src, dest, msg)			\
+do {									\
+	type *_p;							\
+	int i;								\
+									\
+	vector_foreach_slot(src, _p, i) {				\
+		if (_p->var) {						\
+			dest = _p->var;					\
+			origin = msg;					\
+			goto out;					\
+		}							\
+	}								\
+} while (0)
+
+#define do_set_from_hwe(var, src, dest, msg) \
+	do_set_from_vec(struct hwentry, var, src->hwe, dest, msg)
+
 static const char default_origin[] = "(setting: multipath internal)";
 static const char hwe_origin[] =
 	"(setting: storage device configuration)";
@@ -67,7 +84,7 @@ do {									\
 #define mp_set_mpe(var)							\
 do_set(var, mp->mpe, mp->var, multipaths_origin)
 #define mp_set_hwe(var)							\
-do_set(var, mp->hwe, mp->var, hwe_origin)
+do_set_from_hwe(var, mp, mp->var, hwe_origin)
 #define mp_set_ovr(var)							\
 do_set(var, conf->overrides, mp->var, overrides_origin)
 #define mp_set_conf(var)						\
@@ -78,7 +95,7 @@ do_default(mp->var, value)
 #define pp_set_mpe(var)							\
 do_set(var, mpe, pp->var, multipaths_origin)
 #define pp_set_hwe(var)							\
-do_set(var, pp->hwe, pp->var, hwe_origin)
+do_set_from_hwe(var, pp, pp->var, hwe_origin)
 #define pp_set_conf(var)						\
 do_set(var, conf, pp->var, conf_origin)
 #define pp_set_ovr(var)							\
@@ -250,8 +267,8 @@ want_user_friendly_names(struct config *conf, struct multipath * mp)
 	       multipaths_origin);
 	do_set(user_friendly_names, conf->overrides, user_friendly_names,
 	       overrides_origin);
-	do_set(user_friendly_names, mp->hwe, user_friendly_names,
-	       hwe_origin);
+	do_set_from_hwe(user_friendly_names, mp, user_friendly_names,
+			hwe_origin);
 	do_set(user_friendly_names, conf, user_friendly_names,
 	       conf_origin);
 	do_default(user_friendly_names, DEFAULT_USER_FRIENDLY_NAMES);
@@ -471,9 +488,9 @@ int select_checker(struct config *conf, struct path *pp)
 			checker_name = TUR;
 			goto out;
 		}
- 	}
+	}
 	do_set(checker_name, conf->overrides, checker_name, overrides_origin);
-	do_set(checker_name, pp->hwe, checker_name, hwe_origin);
+	do_set_from_hwe(checker_name, pp, checker_name, hwe_origin);
 	do_set(checker_name, conf, checker_name, conf_origin);
 	do_default(checker_name, DEFAULT_CHECKER);
 out:
@@ -547,6 +564,25 @@ do {									\
 	}								\
 } while(0)
 
+#define set_prio_from_vec(type, dir, src, msg, p)			\
+do {									\
+	type *_p;							\
+	int i;								\
+	char *prio_name = NULL, *prio_args = NULL;			\
+									\
+	vector_foreach_slot(src, _p, i) {				\
+		if (prio_name == NULL && _p->prio_name)		\
+			prio_name = _p->prio_name;			\
+		if (prio_args == NULL && _p->prio_args)		\
+			prio_args = _p->prio_args;			\
+	}								\
+	if (prio_name != NULL) {					\
+		prio_get(dir, p, prio_name, prio_args);			\
+		origin = msg;						\
+		goto out;						\
+	}								\
+} while (0)
+
 int select_prio(struct config *conf, struct path *pp)
 {
 	const char *origin;
@@ -563,7 +599,8 @@ int select_prio(struct config *conf, struct path *pp)
 	mpe = find_mpe(conf->mptable, pp->wwid);
 	set_prio(conf->multipath_dir, mpe, multipaths_origin);
 	set_prio(conf->multipath_dir, conf->overrides, overrides_origin);
-	set_prio(conf->multipath_dir, pp->hwe, hwe_origin);
+	set_prio_from_vec(struct hwentry, conf->multipath_dir,
+			  pp->hwe, hwe_origin, p);
 	set_prio(conf->multipath_dir, conf, conf_origin);
 	prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 	origin = default_origin;
@@ -616,7 +653,7 @@ select_minio_rq (struct config *conf, struct multipath * mp)
 
 	do_set(minio_rq, mp->mpe, mp->minio, multipaths_origin);
 	do_set(minio_rq, conf->overrides, mp->minio, overrides_origin);
-	do_set(minio_rq, mp->hwe, mp->minio, hwe_origin);
+	do_set_from_hwe(minio_rq, mp, mp->minio, hwe_origin);
 	do_set(minio_rq, conf, mp->minio, conf_origin);
 	do_default(mp->minio, DEFAULT_MINIO_RQ);
 out:
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 6df2f4ec..ae847d61 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -102,6 +102,11 @@ alloc_path (void)
 		pp->priority = PRIO_UNDEF;
 		checker_clear(&pp->checker);
 		dm_path_to_gen(pp)->ops = &dm_gen_path_ops;
+		pp->hwe = vector_alloc();
+		if (pp->hwe == NULL) {
+			free(pp);
+			return NULL;
+		}
 	}
 	return pp;
 }
@@ -125,6 +130,7 @@ free_path (struct path * pp)
 		udev_device_unref(pp->udev);
 		pp->udev = NULL;
 	}
+	vector_free(pp->hwe);
 
 	FREE(pp);
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index fef416b4..a801cd92 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -283,7 +283,7 @@ struct path {
 	int io_err_pathfail_starttime;
 	int find_multipaths_timeout;
 	/* configlet pointers */
-	struct hwentry * hwe;
+	vector hwe;
 	struct gen_path generic_path;
 };
 
@@ -342,7 +342,7 @@ struct multipath {
 	char * features;
 	char * hwhandler;
 	struct mpentry * mpe;
-	struct hwentry * hwe;
+	vector hwe;
 
 	/* threads */
 	pthread_t waiter;
-- 
2.17.0
