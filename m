From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 11/20] libmultipath: don't try to set up
	failed wwids again
Date: Mon, 19 Mar 2018 16:01:46 +0100
Message-ID: <20180319150155.5363-12-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Once setting up a map has failed, don't try to set it up again.
This applies to "multipathd reconfigure" and even multipathd restart,
too. That's deliberate - if a WWID is marked as failed, we don't wont
to bother with it again, unless the admin explicitly tells us so.
Specifically, the exceptions are:

 1) multipathd add map $MAP
 2) multipathd add path $PATH
 3) multipath $PATH

In these cases, addmap() will eventually be called again, and the failed
flag will be set according to it's return status. Unless the reason for
the previous failure has been fixed, it may well be "failed" again.

Inofficially, it's also possible to manually remove a failed marker under
/dev/shm/multipath/failed_wwids and run "multipathd reconfigure".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c  |  5 +++--
 libmultipath/configure.h  |  3 ++-
 libmultipath/wwids.c      |  7 ++++++-
 libmultipath/wwids.h      |  3 ++-
 multipath/main.c          | 12 +++++++++---
 multipathd/cli_handlers.c |  5 +++--
 multipathd/main.c         | 13 +++++++------
 multipathd/main.h         |  8 ++++++++
 8 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 88e6687849f8..98b80337d899 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -981,7 +981,7 @@ out:
  * reloaded in DM if there's a difference. This is useful during startup.
  */
 int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
-		    int force_reload, enum mpath_cmds cmd)
+		    int force_reload, bool retry_failed, enum mpath_cmds cmd)
 {
 	int r = 1;
 	int k, i;
@@ -1032,7 +1032,8 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 			continue;
 
 		/* If find_multipaths was selected check if the path is valid */
-		if (!refwwid && !should_multipath(pp1, pathvec, curmp)) {
+		if (!refwwid && !should_multipath(pp1, pathvec, curmp,
+						  retry_failed)) {
 			orphan_path(pp1, "only one path");
 			continue;
 		}
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 8b56d33a1d0b..7e175c890d25 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -32,7 +32,8 @@ int setup_map (struct multipath * mpp, char * params, int params_size,
 	       struct vectors *vecs );
 int domap (struct multipath * mpp, char * params, int is_daemon);
 int reinstate_paths (struct multipath *mpp);
-int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload, enum mpath_cmds cmd);
+int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid,
+		    int force_reload, bool retry_failed, enum mpath_cmds cmd);
 int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index e0fdcb34dbc6..288a9ad50c73 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include <limits.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
@@ -273,12 +274,16 @@ out:
 }
 
 int
-should_multipath(struct path *pp1, vector pathvec, vector mpvec)
+should_multipath(struct path *pp1, vector pathvec, vector mpvec,
+		 bool retry_failed)
 {
 	int i, ignore_new;
 	struct path *pp2;
 	struct config *conf;
 
+	if (!retry_failed && is_failed_wwid(pp1->wwid))
+		return 0;
+
 	conf = get_multipath_config();
 	ignore_new = ignore_new_devs(conf);
 	if (!find_multipaths_on(conf) && !ignore_new) {
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index d00e1f58137c..911e8da720c5 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -12,7 +12,8 @@
 "#\n" \
 "# Valid WWIDs:\n"
 
-int should_multipath(struct path *pp, vector pathvec, vector mpvec);
+int should_multipath(struct path *pp, vector pathvec, vector mpvec,
+		     bool retry_failed);
 int remember_wwid(char *wwid);
 int check_wwids_file(char *wwid, int write_wwid);
 int remove_wwid(char *wwid);
diff --git a/multipath/main.c b/multipath/main.c
index 3944fd504de2..566404e56ef4 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -441,8 +441,12 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * Paths listed in the wwids file are always considered valid.
 		 */
 		if (cmd == CMD_VALID_PATH) {
-			if ((!find_multipaths_on(conf) && ignore_wwids(conf)) ||
-			    check_wwids_file(refwwid, 0) == 0)
+			if (is_failed_wwid(refwwid)) {
+				r = 1;
+				goto print_valid;
+			} else if ((!find_multipaths_on(conf) &&
+				  ignore_wwids(conf)) ||
+				 check_wwids_file(refwwid, 0) == 0)
 				r = 0;
 			if (r == 0 ||
 			    !find_multipaths_on(conf) || !ignore_wwids(conf)) {
@@ -504,9 +508,11 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 	/*
 	 * core logic entry point
+	 * If refwwid != NULL, user has given a device to multipath,
+	 * so retry even if this ID has failed before.
 	 */
 	r = coalesce_paths(&vecs, NULL, refwwid,
-			   conf->force_reload, cmd);
+			   conf->force_reload, refwwid != NULL, cmd);
 
 out:
 	if (refwwid)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 60ec48b9904a..202438795ee5 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -750,7 +750,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		pp->checkint = conf->checkint;
 	}
 	put_multipath_config(conf);
-	return ev_add_path(pp, vecs, 1);
+	return ev_add_path(pp, vecs, ADD_PATH_DOMAP_FORCE);
 blacklisted:
 	*reply = strdup("blacklisted\n");
 	*len = strlen(*reply) + 1;
@@ -813,7 +813,8 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 					 vecs->pathvec, &refwwid);
 			if (refwwid) {
 				if (coalesce_paths(vecs, NULL, refwwid,
-						   FORCE_RELOAD_NONE, CMD_NONE))
+						   FORCE_RELOAD_NONE, true,
+						   CMD_NONE))
 					condlog(2, "%s: coalesce_paths failed",
 									param);
 				dm_lib_release();
diff --git a/multipathd/main.c b/multipathd/main.c
index ea8c413f28c6..8fd7d2b75cba 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -933,7 +933,8 @@ rescan:
 		mpp->action = ACT_RELOAD;
 		extract_hwe_from_path(mpp);
 	} else {
-		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec)) {
+		if (!should_multipath(pp, vecs->pathvec, vecs->mpvec,
+				      need_do_map == ADD_PATH_DOMAP_FORCE)) {
 			orphan_path(pp, "only one path");
 			return 0;
 		}
@@ -953,7 +954,7 @@ rescan:
 	/* persistent reservation check*/
 	mpath_pr_event_handle(pp);
 
-	if (!need_do_map)
+	if (need_do_map == ADD_PATH_DOMAP_NO)
 		return 0;
 
 	if (!dm_map_present(mpp->alias)) {
@@ -1863,7 +1864,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			conf = get_multipath_config();
 			ret = pathinfo(pp, conf, DI_ALL | DI_BLACKLIST);
 			if (ret == PATHINFO_OK) {
-				ev_add_path(pp, vecs, 1);
+				ev_add_path(pp, vecs, ADD_PATH_DOMAP_YES);
 				pp->tick = 1;
 			} else if (ret == PATHINFO_SKIPPED) {
 				put_multipath_config(conf);
@@ -1989,7 +1990,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		}
 		if (!disable_reinstate && reinstate_path(pp, add_active)) {
 			condlog(3, "%s: reload map", pp->dev);
-			ev_add_path(pp, vecs, 1);
+			ev_add_path(pp, vecs, ADD_PATH_DOMAP_YES);
 			pp->tick = 1;
 			return 0;
 		}
@@ -2012,7 +2013,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			/* Clear IO errors */
 			if (reinstate_path(pp, 0)) {
 				condlog(3, "%s: reload map", pp->dev);
-				ev_add_path(pp, vecs, 1);
+				ev_add_path(pp, vecs, ADD_PATH_DOMAP_YES);
 				pp->tick = 1;
 				return 0;
 			}
@@ -2288,7 +2289,7 @@ configure (struct vectors * vecs)
 	 * superfluous ACT_RELOAD ioctls. Later calls are done
 	 * with FORCE_RELOAD_YES.
 	 */
-	ret = coalesce_paths(vecs, mpvec, NULL, force_reload, CMD_NONE);
+	ret = coalesce_paths(vecs, mpvec, NULL, force_reload, false, CMD_NONE);
 	if (force_reload == FORCE_RELOAD_WEAK)
 		force_reload = FORCE_RELOAD_YES;
 	if (ret) {
diff --git a/multipathd/main.h b/multipathd/main.h
index af395589ff93..a92650cd958b 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -22,6 +22,14 @@ void exit_daemon(void);
 const char * daemon_status(void);
 int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
+/*
+ * 3rd argument of ev_add_path()
+ */
+enum {
+	ADD_PATH_DOMAP_NO = 0,	  /* don't call domap */
+	ADD_PATH_DOMAP_YES = 1,	  /* call domap, don't retry failed */
+	ADD_PATH_DOMAP_FORCE = 2, /* call domap, retry previously failed */
+};
 int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
 int ev_add_map (char *, const char *, struct vectors *);
-- 
2.16.1
