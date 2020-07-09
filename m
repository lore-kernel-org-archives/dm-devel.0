From: mwilck@suse.com
Subject: [PATCH 77/80] libmultipath: log dm_task_run() errors
Date: Thu,  9 Jul 2020 13:03:27 +0200
Message-ID: <20200709110330.9917-4-mwilck@suse.com>
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

Log the ioctl error messages from libdm.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 22 ++++++++-------
 libmultipath/devmapper.c | 61 ++++++++++++++++++++++++++++++++--------
 libmultipath/devmapper.h |  4 +++
 multipathd/dmevents.c    |  4 ++-
 multipathd/waiter.c      |  2 ++
 5 files changed, 70 insertions(+), 23 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index efb5808..faead8c 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -661,7 +661,8 @@ sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
 }
 
 static void
-select_reload_action(struct multipath *mpp, const char *reason)
+select_reload_action(struct multipath *mpp, const struct multipath *cmpp,
+		     const char *reason)
 {
 	struct udev_device *mpp_ud;
 	const char *env;
@@ -675,8 +676,9 @@ select_reload_action(struct multipath *mpp, const char *reason)
 	 * run for this map. Thus force udev reload.
 	 */
 
-	mpp_ud = get_udev_for_mpp(mpp);
+	mpp_ud = get_udev_for_mpp(cmpp);
 	env = udev_device_get_property_value(mpp_ud, "MPATH_DEVICE_READY");
+	condlog(3, "%s: %s: \"%s\"\n", __func__, mpp->alias, env);
 	if (!env || strcmp(env, "1"))
 		mpp->force_udev_reload = 1;
 	udev_device_unref(mpp_ud);
@@ -754,7 +756,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 	    !!strstr(mpp->features, "queue_if_no_path") !=
 	    !!strstr(cmpp->features, "queue_if_no_path")) {
-		select_reload_action(cmpp, "no_path_retry change");
+		select_reload_action(mpp, cmpp, "no_path_retry change");
 		return;
 	}
 	if ((mpp->retain_hwhandler != RETAIN_HWHANDLER_ON ||
@@ -762,7 +764,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	    (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
 	     strncmp(cmpp->hwhandler, mpp->hwhandler,
 		    strlen(mpp->hwhandler)))) {
-		select_reload_action(cmpp, "hwhandler change");
+		select_reload_action(mpp, cmpp, "hwhandler change");
 		return;
 	}
 
@@ -770,7 +772,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 	    !!strstr(mpp->features, "retain_attached_hw_handler") !=
 	    !!strstr(cmpp->features, "retain_attached_hw_handler") &&
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0)) {
-		select_reload_action(cmpp, "retain_hwhandler change");
+		select_reload_action(mpp, cmpp, "retain_hwhandler change");
 		return;
 	}
 
@@ -782,7 +784,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		remove_feature(&cmpp_feat, "queue_if_no_path");
 		remove_feature(&cmpp_feat, "retain_attached_hw_handler");
 		if (strncmp(mpp_feat, cmpp_feat, PARAMS_SIZE)) {
-			select_reload_action(cmpp, "features change");
+			select_reload_action(mpp, cmpp, "features change");
 			FREE(cmpp_feat);
 			FREE(mpp_feat);
 			return;
@@ -793,19 +795,19 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 
 	if (!cmpp->selector || strncmp(cmpp->selector, mpp->selector,
 		    strlen(mpp->selector))) {
-		select_reload_action(cmpp, "selector change");
+		select_reload_action(mpp, cmpp, "selector change");
 		return;
 	}
 	if (cmpp->minio != mpp->minio) {
-		select_reload_action(cmpp, "minio change");
+		select_reload_action(mpp, cmpp, "minio change");
 		return;
 	}
 	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
-		select_reload_action(cmpp, "path group number change");
+		select_reload_action(mpp, cmpp, "path group number change");
 		return;
 	}
 	if (pgcmp(mpp, cmpp)) {
-		select_reload_action(cmpp, "path group topology change");
+		select_reload_action(mpp, cmpp, "path group topology change");
 		return;
 	}
 	if (cmpp->nextpg != mpp->bestpg) {
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index fb7675c..46c7ec6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -182,6 +182,7 @@ dm_tgt_version (unsigned int * version, char * str)
 	dm_task_no_open_count(dmt);
 
 	if (!dm_task_run(dmt)) {
+		dm_log_error(2, DM_DEVICE_LIST_VERSIONS, dmt);
 		condlog(0, "Can not communicate with kernel DM");
 		goto out;
 	}
@@ -320,6 +321,8 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 		goto out;
 
 	r = dm_task_run (dmt);
+	if (!r)
+		dm_log_error(2, task, dmt);
 
 	if (udev_wait_flag)
 			dm_udev_wait(cookie);
@@ -410,6 +413,8 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 		goto freeout;
 
 	r = dm_task_run (dmt);
+	if (!r)
+		dm_log_error(2, task, dmt);
 
 	if (task == DM_DEVICE_CREATE)
 			dm_udev_wait(cookie);
@@ -521,8 +526,10 @@ do_get_info(const char *name, struct dm_info *info)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out;
+	}
 
 	if (!dm_task_get_info(dmt, info))
 		goto out;
@@ -561,6 +568,7 @@ int dm_get_map(const char *name, unsigned long long *size, char *outparams)
 
 	errno = 0;
 	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		if (dm_task_get_errno(dmt) == ENXIO)
 			r = DMP_NOT_FOUND;
 		goto out;
@@ -601,8 +609,10 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
 	if (!dm_task_set_name (dmt, name))
 		goto uuidout;
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto uuidout;
+	}
 
 	uuidtmp = dm_task_get_uuid(dmt);
 	if (uuidtmp)
@@ -671,6 +681,7 @@ int dm_get_status(const char *name, char *outstatus)
 
 	errno = 0;
 	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_STATUS, dmt);
 		if (dm_task_get_errno(dmt) == ENXIO)
 			r = DMP_NOT_FOUND;
 		goto out;
@@ -722,8 +733,10 @@ int dm_type(const char *name, char *type)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
+	}
 
 	/* Fetch 1st target */
 	if (dm_get_next_target(dmt, NULL, &start, &length,
@@ -764,8 +777,10 @@ int dm_is_mpath(const char *name)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out_task;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out_task;
@@ -826,8 +841,10 @@ dm_map_present_by_uuid(const char *uuid)
 	if (!dm_task_set_uuid(dmt, prefixed_uuid))
 		goto out_task;
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out_task;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out_task;
@@ -870,8 +887,10 @@ dm_get_opencount (const char * mapname)
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
@@ -1028,8 +1047,10 @@ int dm_flush_maps (int need_suspend, int retries)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run (dmt))
+	if (!dm_task_run (dmt)) {
+		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
+	}
 
 	if (!(names = dm_task_get_names (dmt)))
 		goto out;
@@ -1072,8 +1093,10 @@ dm_message(const char * mapname, char * message)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(2, DM_DEVICE_TARGET_MSG, dmt);
 		goto out;
+	}
 
 	r = 0;
 out:
@@ -1190,8 +1213,10 @@ dm_get_maps (vector mp)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
+	}
 
 	if (!(names = dm_task_get_names(dmt)))
 		goto out;
@@ -1280,6 +1305,7 @@ dm_mapname(int major, int minor)
 	}
 
 	if (!r) {
+		dm_log_error(2, DM_DEVICE_STATUS, dmt);
 		condlog(0, "%i:%i: timeout fetching map name", major, minor);
 		goto bad;
 	}
@@ -1315,8 +1341,10 @@ do_foreach_partmaps (const char * mapname,
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
+	}
 
 	if (!(names = dm_task_get_names(dmt)))
 		goto out;
@@ -1550,6 +1578,8 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto out;
 	r = dm_task_run(dmt);
+	if (!r)
+		dm_log_error(2, DM_DEVICE_RENAME, dmt);
 
 	dm_udev_wait(cookie);
 
@@ -1593,8 +1623,10 @@ int dm_reassign_table(const char *name, char *old, char *new)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
+	}
 	if (!(reload_dmt = libmp_dm_task_create(DM_DEVICE_RELOAD)))
 		goto out;
 	if (!dm_task_set_name(reload_dmt, name))
@@ -1625,6 +1657,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
 		dm_task_no_open_count(reload_dmt);
 
 		if (!dm_task_run(reload_dmt)) {
+			dm_log_error(3, DM_DEVICE_RELOAD, reload_dmt);
 			condlog(3, "%s: failed to reassign targets", name);
 			goto out_reload;
 		}
@@ -1670,8 +1703,10 @@ int dm_reassign(const char *mapname)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_DEPS, dmt);
 		goto out;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
@@ -1737,6 +1772,8 @@ int dm_setgeometry(struct multipath *mpp)
 	}
 
 	r = dm_task_run(dmt);
+	if (!r)
+		dm_log_error(3, DM_DEVICE_SET_GEOMETRY, dmt);
 out:
 	dm_task_destroy(dmt);
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 6dd178c..f568ab5 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -85,4 +85,8 @@ struct multipath *dm_get_multipath(const char *name);
 	((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
 )
 
+#define dm_log_error(lvl, cmd, dmt)			      \
+	condlog(lvl, "%s: libdm task=%d error: %s", __func__, \
+		cmd, strerror(dm_task_get_errno(dmt)))	      \
+
 #endif /* _DEVMAPPER_H */
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index b22b47d..b235dd4 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -156,8 +156,10 @@ static int dm_get_events(void)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto fail;
+	}
 
 	if (!(names = dm_task_get_names(dmt)))
 		goto fail;
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index e645766..16fbdc8 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -119,6 +119,8 @@ static int waiteventloop (struct event_thread *waiter)
 
 	pthread_testcancel();
 	r = dm_task_run(waiter->dmt);
+	if (!r)
+		dm_log_error(2, DM_DEVICE_WAITEVENT, waiter->dmt);
 	pthread_testcancel();
 
 	pthread_sigmask(SIG_SETMASK, &oldset, NULL);
-- 
2.26.2
