From: mwilck@suse.com
Subject: [PATCH v3 77/80] libmultipath: log dm_task_run() errors
Date: Wed, 19 Aug 2020 15:17:47 +0200
Message-ID: <20200819131747.13400-3-mwilck@suse.com>
References: <20200819131747.13400-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200819131747.13400-1-mwilck@suse.com>
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

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 61 ++++++++++++++++++++++++++++++++--------
 libmultipath/devmapper.h |  4 +++
 multipathd/dmevents.c    |  4 ++-
 multipathd/waiter.c      |  2 ++
 4 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 38d1990..cc2de1d 100644
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
@@ -522,8 +527,10 @@ do_get_info(const char *name, struct dm_info *info)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out;
+	}
 
 	if (!dm_task_get_info(dmt, info))
 		goto out;
@@ -562,6 +569,7 @@ int dm_get_map(const char *name, unsigned long long *size, char *outparams)
 
 	errno = 0;
 	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		if (dm_task_get_errno(dmt) == ENXIO)
 			r = DMP_NOT_FOUND;
 		goto out;
@@ -602,8 +610,10 @@ dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
 	if (!dm_task_set_name (dmt, name))
 		goto uuidout;
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto uuidout;
+	}
 
 	uuidtmp = dm_task_get_uuid(dmt);
 	if (uuidtmp)
@@ -672,6 +682,7 @@ int dm_get_status(const char *name, char *outstatus)
 
 	errno = 0;
 	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_STATUS, dmt);
 		if (dm_task_get_errno(dmt) == ENXIO)
 			r = DMP_NOT_FOUND;
 		goto out;
@@ -723,8 +734,10 @@ int dm_type(const char *name, char *type)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
+	}
 
 	/* Fetch 1st target */
 	if (dm_get_next_target(dmt, NULL, &start, &length,
@@ -765,8 +778,10 @@ int dm_is_mpath(const char *name)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out_task;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out_task;
@@ -827,8 +842,10 @@ dm_map_present_by_uuid(const char *uuid)
 	if (!dm_task_set_uuid(dmt, prefixed_uuid))
 		goto out_task;
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out_task;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out_task;
@@ -871,8 +888,10 @@ dm_get_opencount (const char * mapname)
 	if (!dm_task_set_name(dmt, mapname))
 		goto out;
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_INFO, dmt);
 		goto out;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
@@ -1029,8 +1048,10 @@ int dm_flush_maps (int need_suspend, int retries)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run (dmt))
+	if (!dm_task_run (dmt)) {
+		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
+	}
 
 	if (!(names = dm_task_get_names (dmt)))
 		goto out;
@@ -1073,8 +1094,10 @@ dm_message(const char * mapname, char * message)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(2, DM_DEVICE_TARGET_MSG, dmt);
 		goto out;
+	}
 
 	r = 0;
 out:
@@ -1191,8 +1214,10 @@ dm_get_maps (vector mp)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
+	}
 
 	if (!(names = dm_task_get_names(dmt)))
 		goto out;
@@ -1283,6 +1308,7 @@ dm_mapname(int major, int minor)
 	}
 
 	if (!r) {
+		dm_log_error(2, DM_DEVICE_STATUS, dmt);
 		condlog(0, "%i:%i: timeout fetching map name", major, minor);
 		goto bad;
 	}
@@ -1318,8 +1344,10 @@ do_foreach_partmaps (const char * mapname,
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_LIST, dmt);
 		goto out;
+	}
 
 	if (!(names = dm_task_get_names(dmt)))
 		goto out;
@@ -1552,6 +1580,8 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
 	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
 		goto out;
 	r = dm_task_run(dmt);
+	if (!r)
+		dm_log_error(2, DM_DEVICE_RENAME, dmt);
 
 	dm_udev_wait(cookie);
 
@@ -1595,8 +1625,10 @@ int dm_reassign_table(const char *name, char *old, char *new)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_TABLE, dmt);
 		goto out;
+	}
 	if (!(reload_dmt = libmp_dm_task_create(DM_DEVICE_RELOAD)))
 		goto out;
 	if (!dm_task_set_name(reload_dmt, name))
@@ -1627,6 +1659,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
 		dm_task_no_open_count(reload_dmt);
 
 		if (!dm_task_run(reload_dmt)) {
+			dm_log_error(3, DM_DEVICE_RELOAD, reload_dmt);
 			condlog(3, "%s: failed to reassign targets", name);
 			goto out_reload;
 		}
@@ -1672,8 +1705,10 @@ int dm_reassign(const char *mapname)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_run(dmt))
+	if (!dm_task_run(dmt)) {
+		dm_log_error(3, DM_DEVICE_DEPS, dmt);
 		goto out;
+	}
 
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
@@ -1739,6 +1774,8 @@ int dm_setgeometry(struct multipath *mpp)
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
2.28.0
