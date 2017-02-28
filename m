From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/33] multipathd: use weaker "force_reload" at
	startup
Date: Tue, 28 Feb 2017 17:23:14 +0100
Message-ID: <20170228162329.14517-19-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

"force_reload" has originally been created to support multipath -r
(admin triggered reload). multipathd also uses this parameter
in DAEMON_CONFIGURE state, too. But this is causes unnecessary
device-mapper ioctls when multipathd is first started, if existing
maps have been discovered (perhaps set up by previous instance of
multipathd, e.g. in the initrd).

This patch introduces a weaker form of the force_reload parameter
to coalesce_paths(). The parameter can now take three values:
 * FORCE_RELOAD_NONE: existing maps aren't touched at all
 * FORCE_RELOAD_YES: all maps are rebuilt from scratch and (re)loaded in DM
 * FORCE_RELOAD_WEAK: existing maps are compared to the current conf and only
   reloaded in DM if there's a difference. This is useful during startup.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h     |  6 ++++++
 libmultipath/configure.c  | 16 ++++++++++++----
 multipath/main.c          |  2 +-
 multipathd/cli_handlers.c |  3 ++-
 multipathd/main.c         | 12 ++++++++++--
 5 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 9a90745b..16f8b1cc 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -36,6 +36,12 @@ enum mpath_cmds {
 	CMD_ADD_WWID,
 };
 
+enum force_reload_types {
+	FORCE_RELOAD_NONE,
+	FORCE_RELOAD_YES,
+	FORCE_RELOAD_WEAK,
+};
+
 struct hwentry {
 	char * vendor;
 	char * product;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 5ad30074..f164801b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -750,8 +750,15 @@ out:
 	return ret;
 }
 
-int coalesce_paths(struct vectors *vecs, vector newmp, char *refwwid,
-		   int force_reload, enum mpath_cmds cmd)
+/*
+ * The force_reload parameter determines how coalesce_paths treats existing maps.
+ * FORCE_RELOAD_NONE: existing maps aren't touched at all
+ * FORCE_RELOAD_YES: all maps are rebuilt from scratch and (re)loaded in DM
+ * FORCE_RELOAD_WEAK: existing maps are compared to the current conf and only
+ * reloaded in DM if there's a difference. This is useful during startup.
+ */
+int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
+		    int force_reload, enum mpath_cmds cmd)
 {
 	int r = 1;
 	int k, i;
@@ -769,7 +776,7 @@ int coalesce_paths(struct vectors *vecs, vector newmp, char *refwwid,
 	if (refwwid && !strlen(refwwid))
 		refwwid = NULL;
 
-	if (force_reload) {
+	if (force_reload != FORCE_RELOAD_NONE) {
 		vector_foreach_slot (pathvec, pp1, k) {
 			pp1->mpp = NULL;
 		}
@@ -858,7 +865,8 @@ int coalesce_paths(struct vectors *vecs, vector newmp, char *refwwid,
 		if (cmd == CMD_DRY_RUN)
 			mpp->action = ACT_DRY_RUN;
 		if (mpp->action == ACT_UNDEF)
-			select_action(mpp, curmp, force_reload);
+			select_action(mpp, curmp,
+				      force_reload == FORCE_RELOAD_YES ? 1 : 0);
 
 		r = domap(mpp, params, is_daemon);
 
diff --git a/multipath/main.c b/multipath/main.c
index ed57135a..4174d43d 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -578,7 +578,7 @@ main (int argc, char *argv[])
 			}
 			break;
 		case 'r':
-			conf->force_reload = 1;
+			conf->force_reload = FORCE_RELOAD_YES;
 			break;
 		case 'i':
 			conf->ignore_wwids = 1;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b20b0546..c59e7fdc 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -778,7 +778,8 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 			rc = get_refwwid(CMD_NONE, param, DEV_DEVMAP,
 					 vecs->pathvec, &refwwid);
 			if (refwwid) {
-				if (coalesce_paths(vecs, NULL, refwwid, 0, 1))
+				if (coalesce_paths(vecs, NULL, refwwid,
+						   FORCE_RELOAD_NONE, 1))
 					condlog(2, "%s: coalesce_paths failed",
 									param);
 				dm_lib_release();
diff --git a/multipathd/main.c b/multipathd/main.c
index 8f464bfb..e2e73749 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -535,7 +535,8 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	r = get_refwwid(CMD_NONE, dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
 	if (refwwid) {
-		r = coalesce_paths(vecs, NULL, refwwid, 0, CMD_NONE);
+		r = coalesce_paths(vecs, NULL, refwwid, FORCE_RELOAD_NONE,
+				   CMD_NONE);
 		dm_lib_release();
 	}
 
@@ -2039,6 +2040,7 @@ configure (struct vectors * vecs, int start_waiters)
 	vector mpvec;
 	int i, ret;
 	struct config *conf;
+	static int force_reload = FORCE_RELOAD_WEAK;
 
 	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc())) {
 		condlog(0, "couldn't allocate path vec in configure");
@@ -2082,8 +2084,14 @@ configure (struct vectors * vecs, int start_waiters)
 
 	/*
 	 * create new set of maps & push changed ones into dm
+	 * In the first call, use FORCE_RELOAD_WEAK to avoid making
+	 * superfluous ACT_RELOAD ioctls. Later calls are done
+	 * with FORCE_RELOAD_YES.
 	 */
-	if (coalesce_paths(vecs, mpvec, NULL, 1, CMD_NONE)) {
+	ret = coalesce_paths(vecs, mpvec, NULL, force_reload, CMD_NONE);
+	if (force_reload == FORCE_RELOAD_WEAK)
+		force_reload = FORCE_RELOAD_YES;
+	if (ret) {
 		condlog(0, "configure failed while coalescing paths");
 		return 1;
 	}
-- 
2.11.0
