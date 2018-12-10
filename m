From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 21/24] coalesce_paths(): use symbolic return
	value
Date: Mon, 10 Dec 2018 10:49:56 +0100
Message-ID: <20181210094959.11338-22-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Use an enum to represent the return value of coalesce_paths() to
improve readability of the code.
This patch doesn't introduce changes in behavior.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c  | 17 ++++++++---------
 libmultipath/configure.h  | 10 ++++++++++
 multipath/main.c          |  5 +++--
 multipathd/cli_handlers.c |  3 ++-
 multipathd/main.c         |  2 +-
 5 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index f48664a0..5daf0c13 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -998,8 +998,8 @@ out:
 int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 		    int force_reload, enum mpath_cmds cmd)
 {
-	int r = 1;
-	int k, i;
+	int ret = CP_FAIL;
+	int k, i, r;
 	int is_daemon = (cmd == CMD_NONE) ? 1 : 0;
 	char params[PARAMS_SIZE];
 	struct multipath * mpp;
@@ -1022,11 +1022,11 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 	}
 
 	if (VECTOR_SIZE(pathvec) == 0)
-		return 0;
+		return CP_OK;
 	size_mismatch_seen = calloc((VECTOR_SIZE(pathvec) - 1) / 64 + 1,
 				    sizeof(uint64_t));
 	if (size_mismatch_seen == NULL)
-		return 1;
+		return CP_FAIL;
 
 	vector_foreach_slot (pathvec, pp1, k) {
 		int invalid;
@@ -1130,6 +1130,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				remove_map(mpp, vecs, 0);
 				continue;
 			} else /* if (r == DOMAP_RETRY && !is_daemon) */ {
+				ret = CP_RETRY;
 				goto out;
 			}
 		}
@@ -1172,10 +1173,8 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 
 		if (newmp) {
 			if (mpp->action != ACT_REJECT) {
-				if (!vector_alloc_slot(newmp)) {
-					r = 1;
+				if (!vector_alloc_slot(newmp))
 					goto out;
-				}
 				vector_set_slot(newmp, mpp);
 			}
 			else
@@ -1206,10 +1205,10 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				condlog(2, "%s: remove (dead)", alias);
 		}
 	}
-	r = 0;
+	ret = CP_OK;
 out:
 	free(size_mismatch_seen);
-	return r;
+	return ret;
 }
 
 struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type)
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 8b56d33a..64520c57 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -23,6 +23,16 @@ enum actions {
 	ACT_IMPOSSIBLE,
 };
 
+/*
+ * Return value of coalesce_paths()
+ * CP_RETRY is only used in non-daemon case (multipath).
+ */
+enum {
+	CP_OK = 0,
+	CP_FAIL,
+	CP_RETRY,
+};
+
 #define FLUSH_ONE 1
 #define FLUSH_ALL 2
 
diff --git a/multipath/main.c b/multipath/main.c
index 98fee1c7..1d34b87b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -537,7 +537,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	vector curmp = NULL;
 	vector pathvec = NULL;
 	struct vectors vecs;
-	int r = 1;
+	int r = 1, rc;
 	int di_flag = 0;
 	char * refwwid = NULL;
 	char * dev = NULL;
@@ -752,8 +752,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	/*
 	 * core logic entry point
 	 */
-	r = coalesce_paths(&vecs, NULL, refwwid,
+	rc = coalesce_paths(&vecs, NULL, refwwid,
 			   conf->force_reload, cmd);
+	r = rc == CP_RETRY ? -1 : rc == CP_OK ? 0 : 1;
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index a0d57a53..4fbd8841 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -803,7 +803,8 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 				    vecs->pathvec, &refwwid);
 			if (refwwid) {
 				if (coalesce_paths(vecs, NULL, refwwid,
-						   FORCE_RELOAD_NONE, CMD_NONE))
+						   FORCE_RELOAD_NONE, CMD_NONE)
+				    != CP_OK)
 					condlog(2, "%s: coalesce_paths failed",
 									param);
 				dm_lib_release();
diff --git a/multipathd/main.c b/multipathd/main.c
index 04f02d99..fd1ac8fe 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2366,7 +2366,7 @@ configure (struct vectors * vecs)
 	ret = coalesce_paths(vecs, mpvec, NULL, force_reload, CMD_NONE);
 	if (force_reload == FORCE_RELOAD_WEAK)
 		force_reload = FORCE_RELOAD_YES;
-	if (ret) {
+	if (ret != CP_OK) {
 		condlog(0, "configure failed while coalescing paths");
 		goto fail;
 	}
-- 
2.19.2
