From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 05/12] multipathd: move helper functions to
	libmultipath
Date: Thu,  7 Dec 2017 12:48:59 -0600
Message-ID: <1512672546-12785-6-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This commit simply moves sync_map_state() and update_map() from
multipathd/main.c to libmultipath/structs_vec.c, to enable future
changes.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/structs_vec.h |  2 ++
 multipathd/main.c          | 72 --------------------------------------------
 multipathd/main.h          |  1 -
 4 files changed, 76 insertions(+), 73 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 22be8e0..eddeeaf 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -16,6 +16,8 @@
 #include "propsel.h"
 #include "discovery.h"
 #include "prio.h"
+#include "configure.h"
+#include "libdevmapper.h"
 
 /*
  * creates or updates mpp->paths reading mpp->pg
@@ -415,6 +417,78 @@ out:
 	return 1;
 }
 
+void
+sync_map_state(struct multipath *mpp)
+{
+	struct pathgroup *pgp;
+	struct path *pp;
+	unsigned int i, j;
+
+	if (!mpp->pg)
+		return;
+
+	vector_foreach_slot (mpp->pg, pgp, i){
+		vector_foreach_slot (pgp->paths, pp, j){
+			if (pp->state == PATH_UNCHECKED ||
+			    pp->state == PATH_WILD ||
+			    pp->state == PATH_DELAYED)
+				continue;
+			if (mpp->ghost_delay_tick > 0)
+				continue;
+			if ((pp->dmstate == PSTATE_FAILED ||
+			     pp->dmstate == PSTATE_UNDEF) &&
+			    (pp->state == PATH_UP || pp->state == PATH_GHOST))
+				dm_reinstate_path(mpp->alias, pp->dev_t);
+			else if ((pp->dmstate == PSTATE_ACTIVE ||
+				  pp->dmstate == PSTATE_UNDEF) &&
+				 (pp->state == PATH_DOWN ||
+				  pp->state == PATH_SHAKY))
+				dm_fail_path(mpp->alias, pp->dev_t);
+		}
+	}
+}
+
+int
+update_map (struct multipath *mpp, struct vectors *vecs)
+{
+	int retries = 3;
+	char params[PARAMS_SIZE] = {0};
+
+retry:
+	condlog(4, "%s: updating new map", mpp->alias);
+	if (adopt_paths(vecs->pathvec, mpp)) {
+		condlog(0, "%s: failed to adopt paths for new map update",
+			mpp->alias);
+		retries = -1;
+		goto fail;
+	}
+	verify_paths(mpp, vecs);
+	mpp->flush_on_last_del = FLUSH_UNDEF;
+	mpp->action = ACT_RELOAD;
+
+	if (setup_map(mpp, params, PARAMS_SIZE)) {
+		condlog(0, "%s: failed to setup new map in update", mpp->alias);
+		retries = -1;
+		goto fail;
+	}
+	if (domap(mpp, params, 1) <= 0 && retries-- > 0) {
+		condlog(0, "%s: map_udate sleep", mpp->alias);
+		sleep(1);
+		goto retry;
+	}
+	dm_lib_release();
+
+fail:
+	if (setup_multipath(vecs, mpp))
+		return 1;
+
+	sync_map_state(mpp);
+
+	if (retries < 0)
+		condlog(0, "%s: failed reload in new map update", mpp->alias);
+	return 0;
+}
+
 struct multipath *add_map_without_path (struct vectors *vecs, char *alias)
 {
 	struct multipath * mpp = alloc_multipath();
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 46f30af..54444e0 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -30,6 +30,8 @@ void remove_map_and_stop_waiter (struct multipath * mpp, struct vectors * vecs,
 void remove_maps (struct vectors * vecs);
 void remove_maps_and_stop_waiters (struct vectors * vecs);
 
+void sync_map_state (struct multipath *);
+int update_map (struct multipath *mpp, struct vectors *vecs);
 struct multipath * add_map_without_path (struct vectors * vecs, char * alias);
 struct multipath * add_map_with_path (struct vectors * vecs,
 				struct path * pp, int add_vec);
diff --git a/multipathd/main.c b/multipathd/main.c
index 25f1f52..93506ea 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -338,37 +338,6 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 	return 0;
 }
 
-void
-sync_map_state(struct multipath *mpp)
-{
-	struct pathgroup *pgp;
-	struct path *pp;
-	unsigned int i, j;
-
-	if (!mpp->pg)
-		return;
-
-	vector_foreach_slot (mpp->pg, pgp, i){
-		vector_foreach_slot (pgp->paths, pp, j){
-			if (pp->state == PATH_UNCHECKED ||
-			    pp->state == PATH_WILD ||
-			    pp->state == PATH_DELAYED)
-				continue;
-			if (mpp->ghost_delay_tick > 0)
-				continue;
-			if ((pp->dmstate == PSTATE_FAILED ||
-			     pp->dmstate == PSTATE_UNDEF) &&
-			    (pp->state == PATH_UP || pp->state == PATH_GHOST))
-				dm_reinstate_path(mpp->alias, pp->dev_t);
-			else if ((pp->dmstate == PSTATE_ACTIVE ||
-				  pp->dmstate == PSTATE_UNDEF) &&
-				 (pp->state == PATH_DOWN ||
-				  pp->state == PATH_SHAKY))
-				dm_fail_path(mpp->alias, pp->dev_t);
-		}
-	}
-}
-
 static void
 sync_maps_state(vector mpvec)
 {
@@ -416,47 +385,6 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 	return 0;
 }
 
-int
-update_map (struct multipath *mpp, struct vectors *vecs)
-{
-	int retries = 3;
-	char params[PARAMS_SIZE] = {0};
-
-retry:
-	condlog(4, "%s: updating new map", mpp->alias);
-	if (adopt_paths(vecs->pathvec, mpp)) {
-		condlog(0, "%s: failed to adopt paths for new map update",
-			mpp->alias);
-		retries = -1;
-		goto fail;
-	}
-	verify_paths(mpp, vecs);
-	mpp->flush_on_last_del = FLUSH_UNDEF;
-	mpp->action = ACT_RELOAD;
-
-	if (setup_map(mpp, params, PARAMS_SIZE)) {
-		condlog(0, "%s: failed to setup new map in update", mpp->alias);
-		retries = -1;
-		goto fail;
-	}
-	if (domap(mpp, params, 1) <= 0 && retries-- > 0) {
-		condlog(0, "%s: map_udate sleep", mpp->alias);
-		sleep(1);
-		goto retry;
-	}
-	dm_lib_release();
-
-fail:
-	if (setup_multipath(vecs, mpp))
-		return 1;
-
-	sync_map_state(mpp);
-
-	if (retries < 0)
-		condlog(0, "%s: failed reload in new map update", mpp->alias);
-	return 0;
-}
-
 static int
 uev_add_map (struct uevent * uev, struct vectors * vecs)
 {
diff --git a/multipathd/main.h b/multipathd/main.h
index 094b04f..ededdab 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -26,7 +26,6 @@ int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
-void sync_map_state (struct multipath *);
 int set_config_state(enum daemon_status);
 void * mpath_alloc_prin_response(int prin_sa);
 int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
-- 
2.7.4
