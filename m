From: mwilck@suse.com
Subject: [PATCH v2 76/80] libmultipath: select_action(): force
	udev reload for uninitialized maps
Date: Wed, 12 Aug 2020 13:35:40 +0200
Message-ID: <20200812113543.26576-2-mwilck@suse.com>
References: <20200812113543.26576-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113543.26576-1-mwilck@suse.com>
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

If we are in the reconfigure() code path, and we encounter maps to
be reloaded, we usually set the DM_SUBSYSTEM_UDEV_FLAG0 flag to tell
udev not to repeat device detection steps above the multipath layer.
However, if the map was previously uninitialized, we have to force
udev to reload.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 61 ++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index cc54818..ac57b88 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -660,6 +660,32 @@ sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
 	return err;
 }
 
+static void
+select_reload_action(struct multipath *mpp, const char *reason)
+{
+	struct udev_device *mpp_ud;
+	const char *env;
+
+	/*
+	 * MPATH_DEVICE_READY != 1 can mean two things:
+	 *  (a) no usable paths
+	 *  (b) device was never fully processed (e.g. udev killed)
+	 * If we are in this code path (startup or forced reconfigure),
+	 * (b) can mean that upper layers like kpartx have never been
+	 * run for this map. Thus force udev reload.
+	 */
+
+	mpp_ud = get_udev_for_mpp(cmpp);
+	env = udev_device_get_property_value(mpp_ud, "MPATH_DEVICE_READY");
+	if ((!env || strcmp(env, "1")) && count_active_paths(mpp) > 0)
+		mpp->force_udev_reload = 1;
+	udev_device_unref(mpp_ud);
+	mpp->action = ACT_RELOAD;
+	condlog(3, "%s: set ACT_RELOAD (%s%s)", mpp->alias,
+		mpp->force_udev_reload ? "forced, " : "",
+		reason);
+}
+
 static void
 select_action (struct multipath * mpp, vector curmp, int force_reload)
 {
@@ -728,9 +754,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 	    !!strstr(mpp->features, "queue_if_no_path") !=
 	    !!strstr(cmpp->features, "queue_if_no_path")) {
-		mpp->action =  ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (no_path_retry change)",
-			mpp->alias);
+		select_reload_action(cmpp, "no_path_retry change");
 		return;
 	}
 	if ((mpp->retain_hwhandler != RETAIN_HWHANDLER_ON ||
@@ -738,9 +762,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	    (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
 	     strncmp(cmpp->hwhandler, mpp->hwhandler,
 		    strlen(mpp->hwhandler)))) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (hwhandler change)",
-			mpp->alias);
+		select_reload_action(cmpp, "hwhandler change");
 		return;
 	}
 
@@ -748,9 +770,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	    !!strstr(mpp->features, "retain_attached_hw_handler") !=
 	    !!strstr(cmpp->features, "retain_attached_hw_handler") &&
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0)) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (retain_hwhandler change)",
-			mpp->alias);
+		select_reload_action(cmpp, "retain_hwhandler change");
 		return;
 	}
 
@@ -762,9 +782,10 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		remove_feature(&cmpp_feat, "queue_if_no_path");
 		remove_feature(&cmpp_feat, "retain_attached_hw_handler");
 		if (strncmp(mpp_feat, cmpp_feat, PARAMS_SIZE)) {
-			mpp->action =  ACT_RELOAD;
-			condlog(3, "%s: set ACT_RELOAD (features change)",
-				mpp->alias);
+			select_reload_action(cmpp, "features change");
+			FREE(cmpp_feat);
+			FREE(mpp_feat);
+			return;
 		}
 	}
 	FREE(cmpp_feat);
@@ -772,27 +793,19 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 
 	if (!cmpp->selector || strncmp(cmpp->selector, mpp->selector,
 		    strlen(mpp->selector))) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (selector change)",
-			mpp->alias);
+		select_reload_action(cmpp, "selector change");
 		return;
 	}
 	if (cmpp->minio != mpp->minio) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (minio change, %u->%u)",
-			mpp->alias, cmpp->minio, mpp->minio);
+		select_reload_action(cmpp, "minio change");
 		return;
 	}
 	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (path group number change)",
-			mpp->alias);
+		select_reload_action(cmpp, "path group number change");
 		return;
 	}
 	if (pgcmp(mpp, cmpp)) {
-		mpp->action = ACT_RELOAD;
-		condlog(3, "%s: set ACT_RELOAD (path group topology change)",
-			mpp->alias);
+		select_reload_action(cmpp, "path group topology change");
 		return;
 	}
 	if (cmpp->nextpg != mpp->bestpg) {
-- 
2.28.0
