From: mwilck@suse.com
Subject: [PATCH 78/80] libmultipath: move reload_map() to
	multipathd
Date: Thu,  9 Jul 2020 13:03:28 +0200
Message-ID: <20200709110330.9917-5-mwilck@suse.com>
References: <20200709110330.9917-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709110330.9917-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

reload_map() is only used by multipathd. We don't have less exported
symbols though, because select_action() now needs to be exported.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 40 +---------------------------------------
 libmultipath/configure.h |  2 +-
 multipathd/main.c        | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index faead8c..b77c2a8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -688,8 +688,7 @@ select_reload_action(struct multipath *mpp, const struct multipath *cmpp,
 		reason);
 }
 
-static void
-select_action (struct multipath * mpp, vector curmp, int force_reload)
+void select_action (struct multipath *mpp, vector curmp, int force_reload)
 {
 	struct multipath * cmpp;
 	struct multipath * cmpp_by_name;
@@ -1478,40 +1477,3 @@ int get_refwwid(enum mpath_cmds cmd, const char *dev, enum devtypes dev_type,
 	pthread_cleanup_pop(1);
 	return ret;
 }
-
-int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
-	       int is_daemon)
-{
-	char params[PARAMS_SIZE] = {0};
-	struct path *pp;
-	int i, r;
-
-	update_mpp_paths(mpp, vecs->pathvec);
-	if (refresh) {
-		vector_foreach_slot (mpp->paths, pp, i) {
-			struct config *conf = get_multipath_config();
-			pthread_cleanup_push(put_multipath_config, conf);
-			r = pathinfo(pp, conf, DI_PRIO);
-			pthread_cleanup_pop(1);
-			if (r) {
-				condlog(2, "%s: failed to refresh pathinfo",
-					mpp->alias);
-				return 1;
-			}
-		}
-	}
-	if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
-		condlog(0, "%s: failed to setup map", mpp->alias);
-		return 1;
-	}
-	select_action(mpp, vecs->mpvec, 1);
-
-	r = domap(mpp, params, is_daemon);
-	if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
-		condlog(3, "%s: domap (%u) failure "
-			"for reload map", mpp->alias, r);
-		return 1;
-	}
-
-	return 0;
-}
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index d9a7de6..9907775 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -49,11 +49,11 @@ struct vectors;
 
 int setup_map (struct multipath * mpp, char * params, int params_size,
 	       struct vectors *vecs );
+void select_action (struct multipath *mpp, vector curmp, int force_reload);
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
 int get_refwwid (enum mpath_cmds cmd, const char *dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
-int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
 void trigger_paths_udev_change(struct multipath *mpp, bool is_mpath);
diff --git a/multipathd/main.c b/multipathd/main.c
index 29227cd..aa08807 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1909,6 +1909,43 @@ int update_prio(struct path *pp, int refresh_all)
 	return 1;
 }
 
+static int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
+		      int is_daemon)
+{
+	char params[PARAMS_SIZE] = {0};
+	struct path *pp;
+	int i, r;
+
+	update_mpp_paths(mpp, vecs->pathvec);
+	if (refresh) {
+		vector_foreach_slot (mpp->paths, pp, i) {
+			struct config *conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
+			r = pathinfo(pp, conf, DI_PRIO);
+			pthread_cleanup_pop(1);
+			if (r) {
+				condlog(2, "%s: failed to refresh pathinfo",
+					mpp->alias);
+				return 1;
+			}
+		}
+	}
+	if (setup_map(mpp, params, PARAMS_SIZE, vecs)) {
+		condlog(0, "%s: failed to setup map", mpp->alias);
+		return 1;
+	}
+	select_action(mpp, vecs->mpvec, 1);
+
+	r = domap(mpp, params, is_daemon);
+	if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
+		condlog(3, "%s: domap (%u) failure "
+			"for reload map", mpp->alias, r);
+		return 1;
+	}
+
+	return 0;
+}
+
 int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 {
 	if (reload_map(vecs, mpp, refresh, 1))
-- 
2.26.2
