From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/42] Do not trigger a map reload on priority
	updates
Date: Tue,  8 Jan 2013 14:53:47 +0100
Message-ID: <1357653259-62650-10-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

update_path_groups() is just there to update the priority groups,
so it should trigger a table reload only if the priority has
indeed changed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c  |   13 ++++++++-----
 libmultipath/configure.h  |    2 +-
 multipathd/cli_handlers.c |    2 +-
 multipathd/main.c         |   27 ++++++---------------------
 4 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 1bb45a3..0f1fe43 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -765,14 +765,17 @@ out:
 	return NULL;
 }
 
-extern int reload_map(struct vectors *vecs, struct multipath *mpp)
+extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh)
 {
-	char params[PARAMS_SIZE];
-	int r;
+	char params[PARAMS_SIZE] = {0};
+	struct path *pp;
+	int i, r;
 
 	update_mpp_paths(mpp, vecs->pathvec);
-
-	params[0] = '\0';
+	if (refresh) {
+		vector_foreach_slot (mpp->paths, pp, i)
+			pathinfo(pp, conf->hwtable, DI_PRIO);
+	}
 	if (setup_map(mpp, params, PARAMS_SIZE)) {
 		condlog(0, "%s: failed to setup map", mpp->alias);
 		return 1;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 6c1c493..d13c0ac 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -28,5 +28,5 @@ int domap (struct multipath * mpp, char * params);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload);
 char * get_refwwid (char * dev, enum devtypes dev_type, vector pathvec);
-int reload_map(struct vectors *vecs, struct multipath *mpp);
+int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh);
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 544cbfb..6053b5a 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -561,7 +561,7 @@ cli_reload(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
-	return reload_map(vecs, mpp);
+	return reload_map(vecs, mpp, 0);
 }
 
 int resize_map(struct multipath *mpp, unsigned long long size,
diff --git a/multipathd/main.c b/multipathd/main.c
index 84574b2..7fe9c5b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -674,11 +674,12 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 				uev->kernel);
 			return 1;
 		}
-		if (pp->mpp)
-			retval = reload_map(vecs, pp->mpp);
+		if (pp->mpp) {
+			retval = reload_map(vecs, pp->mpp, 0);
 
-		condlog(2, "%s: map %s reloaded (retval %d)",
-			uev->kernel, pp->mpp->alias, retval);
+			condlog(2, "%s: map %s reloaded (retval %d)",
+				uev->kernel, pp->mpp->alias, retval);
+		}
 
 	}
 
@@ -1086,25 +1087,9 @@ int update_prio(struct path *pp, int refresh_all)
 
 int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 {
-	int i;
-	struct path * pp;
-	char params[PARAMS_SIZE];
-
-	update_mpp_paths(mpp, vecs->pathvec);
-	if (refresh) {
-		vector_foreach_slot (mpp->paths, pp, i)
-			pathinfo(pp, conf->hwtable, DI_PRIO);
-	}
-	params[0] = '\0';
-	if (setup_map(mpp, params, PARAMS_SIZE))
+	if (reload_map(vecs, mpp, refresh))
 		return 1;
 
-	mpp->action = ACT_RELOAD;
-	if (domap(mpp, params) <= 0) {
-		condlog(0, "%s: failed to update map : %s", mpp->alias,
-			strerror(errno));
-		return 1;
-	}
 	dm_lib_release();
 	if (setup_multipath(vecs, mpp) != 0)
 		return 1;
-- 
1.7.4.2
