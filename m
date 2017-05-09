From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/6] libmultipath: refactor calls to get dm
	device info
Date: Tue,  9 May 2017 11:57:02 -0500
Message-ID: <1494349025-6561-4-git-send-email-bmarzins@redhat.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

Multipath has a number of functions that all do basically the same
thing to get members of the dm_info structure. This just refactors them
to use common code to do it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c  | 171 +++++++++-------------------------------------
 libmultipath/devmapper.h  |   3 +-
 multipathd/cli_handlers.c |  24 ++-----
 3 files changed, 42 insertions(+), 156 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 1c6b87e..2c4a13a 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -399,16 +399,16 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	return r;
 }
 
-int dm_map_present(const char * str)
+static int
+do_get_info(const char *name, struct dm_info *info)
 {
-	int r = 0;
+	int r = -1;
 	struct dm_task *dmt;
-	struct dm_info info;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
-		return 0;
+		return r;
 
-	if (!dm_task_set_name(dmt, str))
+	if (!dm_task_set_name(dmt, name))
 		goto out;
 
 	dm_task_no_open_count(dmt);
@@ -416,16 +416,25 @@ int dm_map_present(const char * str)
 	if (!dm_task_run(dmt))
 		goto out;
 
-	if (!dm_task_get_info(dmt, &info))
+	if (!dm_task_get_info(dmt, info))
 		goto out;
 
-	if (info.exists)
-		r = 1;
+	if (!info->exists)
+		goto out;
+
+	r = 0;
 out:
 	dm_task_destroy(dmt);
 	return r;
 }
 
+int dm_map_present(const char * str)
+{
+	struct dm_info info;
+
+	return (do_get_info(str, &info) == 0);
+}
+
 int dm_get_map(const char *name, unsigned long long *size, char *outparams)
 {
 	int r = 1;
@@ -646,29 +655,15 @@ out:
 static int
 dm_dev_t (const char * mapname, char * dev_t, int len)
 {
-	int r = 1;
-	struct dm_task *dmt;
 	struct dm_info info;
 
-	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
-		return 0;
-
-	if (!dm_task_set_name(dmt, mapname))
-		goto out;
-
-	if (!dm_task_run(dmt))
-		goto out;
-
-	if (!dm_task_get_info(dmt, &info) || !info.exists)
-		goto out;
+	if (do_get_info(mapname, &info) != 0)
+		return 1;
 
 	if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) > len)
-		goto out;
+		return 1;
 
-	r = 0;
-out:
-	dm_task_destroy(dmt);
-	return r;
+	return 0;
 }
 
 int
@@ -700,59 +695,16 @@ out:
 }
 
 int
-dm_get_major (char * mapname)
+dm_get_major_minor(const char *name, int *major, int *minor)
 {
-	int r = -1;
-	struct dm_task *dmt;
 	struct dm_info info;
 
-	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
-		return 0;
-
-	if (!dm_task_set_name(dmt, mapname))
-		goto out;
-
-	if (!dm_task_run(dmt))
-		goto out;
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	if (!info.exists)
-		goto out;
-
-	r = info.major;
-out:
-	dm_task_destroy(dmt);
-	return r;
-}
-
-int
-dm_get_minor (char * mapname)
-{
-	int r = -1;
-	struct dm_task *dmt;
-	struct dm_info info;
-
-	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
-		return 0;
-
-	if (!dm_task_set_name(dmt, mapname))
-		goto out;
-
-	if (!dm_task_run(dmt))
-		goto out;
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	if (!info.exists)
-		goto out;
+	if (do_get_info(name, &info) != 0)
+		return -1;
 
-	r = info.minor;
-out:
-	dm_task_destroy(dmt);
-	return r;
+	*major = info.major;
+	*minor = info.minor;
+	return 0;
 }
 
 static int
@@ -1070,31 +1022,12 @@ out:
 int
 dm_geteventnr (char *name)
 {
-	struct dm_task *dmt;
 	struct dm_info info;
-	int event = -1;
 
-	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+	if (do_get_info(name, &info) != 0)
 		return -1;
 
-	if (!dm_task_set_name(dmt, name))
-		goto out;
-
-	dm_task_no_open_count(dmt);
-
-	if (!dm_task_run(dmt))
-		goto out;
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	if (info.exists)
-		event = info.event_nr;
-
-out:
-	dm_task_destroy(dmt);
-
-	return event;
+	return info.event_nr;
 }
 
 char *
@@ -1262,26 +1195,12 @@ cancel_remove_partmap (const char *name, void *unused)
 static int
 dm_get_deferred_remove (char * mapname)
 {
-	int r = -1;
-	struct dm_task *dmt;
 	struct dm_info info;
 
-	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+	if (do_get_info(mapname, &info) != 0)
 		return -1;
 
-	if (!dm_task_set_name(dmt, mapname))
-		goto out;
-
-	if (!dm_task_run(dmt))
-		goto out;
-
-	if (!dm_task_get_info(dmt, &info))
-		goto out;
-
-	r = info.deferred_remove;
-out:
-	dm_task_destroy(dmt);
-	return r;
+	return info.deferred_remove;
 }
 
 static int
@@ -1328,9 +1247,6 @@ alloc_dminfo (void)
 int
 dm_get_info (char * mapname, struct dm_info ** dmi)
 {
-	int r = 1;
-	struct dm_task *dmt = NULL;
-
 	if (!mapname)
 		return 1;
 
@@ -1340,32 +1256,13 @@ dm_get_info (char * mapname, struct dm_info ** dmi)
 	if (!*dmi)
 		return 1;
 
-	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
-		goto out;
-
-	if (!dm_task_set_name(dmt, mapname))
-		goto out;
-
-	dm_task_no_open_count(dmt);
-
-	if (!dm_task_run(dmt))
-		goto out;
-
-	if (!dm_task_get_info(dmt, *dmi))
-		goto out;
-
-	r = 0;
-out:
-	if (r) {
+	if (do_get_info(mapname, *dmi) != 0) {
 		memset(*dmi, 0, sizeof(struct dm_info));
 		FREE(*dmi);
 		*dmi = NULL;
+		return 1;
 	}
-
-	if (dmt)
-		dm_task_destroy(dmt);
-
-	return r;
+	return 0;
 }
 
 struct rename_data {
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index aca4454..5b66865 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -52,8 +52,7 @@ int dm_enablegroup(char * mapname, int index);
 int dm_disablegroup(char * mapname, int index);
 int dm_get_maps (vector mp);
 int dm_geteventnr (char *name);
-int dm_get_major (char *name);
-int dm_get_minor (char *name);
+int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
 int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index d598039..04c7386 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -746,7 +746,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, MAP);
 	int major, minor;
 	char dev_path[PATH_SIZE];
-	char *alias, *refwwid;
+	char *refwwid, *alias = NULL;
 	int rc, count = 0;
 	struct config *conf;
 
@@ -763,14 +763,12 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 	}
 	put_multipath_config(conf);
 	do {
-		minor = dm_get_minor(param);
-		if (minor < 0)
+		if (dm_get_major_minor(param, &major, &minor) < 0)
 			condlog(2, "%s: not a device mapper table", param);
-		major = dm_get_major(param);
-		if (major < 0)
-			condlog(2, "%s: not a device mapper table", param);
-		sprintf(dev_path, "dm-%d", minor);
-		alias = dm_mapname(major, minor);
+		else {
+			sprintf(dev_path, "dm-%d", minor);
+			alias = dm_mapname(major, minor);
+		}
 		/*if there is no mapname found, we first create the device*/
 		if (!alias && !count) {
 			condlog(2, "%s: mapname not found for %d:%d",
@@ -804,23 +802,15 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
 	int major, minor;
-	char dev_path[PATH_SIZE];
 	char *alias;
 	int rc;
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: remove map (operator)", param);
-	minor = dm_get_minor(param);
-	if (minor < 0) {
-		condlog(2, "%s: not a device mapper table", param);
-		return 1;
-	}
-	major = dm_get_major(param);
-	if (major < 0) {
+	if (dm_get_major_minor(param, &major, &minor) < 0) {
 		condlog(2, "%s: not a device mapper table", param);
 		return 1;
 	}
-	sprintf(dev_path,"dm-%d", minor);
 	alias = dm_mapname(major, minor);
 	if (!alias) {
 		condlog(2, "%s: mapname not found for %d:%d",
-- 
1.8.3.1
