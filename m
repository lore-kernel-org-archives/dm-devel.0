From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 18/18] Make multipath ignore devices without
	mpath prefix
Date: Thu,  8 Oct 2015 14:44:51 -0500
Message-ID: <1444333491-16265-19-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Multpathd currently assumes that it controls all devices of "multipath"
type. In order to allow people to create multipath type devices outside
of the multipath-tools, this patch makes multipathd only modify devices
if they have a uuid that starts with "mpath-". This was a suggestion
from Hannes a couple of months ago.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c |  4 +--
 libmultipath/devmapper.c        | 67 ++++++++++++++++++++++++++++++-----------
 libmultipath/devmapper.h        |  1 +
 multipathd/main.c               |  2 +-
 4 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index eba26a2..113cf7f 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -168,7 +168,7 @@ int mpath_persistent_reserve_in (int fd, int rq_servact,
 
 	condlog(3, "alias = %s", alias);
 	map_present = dm_map_present(alias);
-	if (map_present && dm_type(alias, TGT_MPATH) <= 0){
+	if (map_present && !dm_is_mpath(alias)){
 		condlog( 0, "%s: not a multipath device.", alias);
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out;
@@ -258,7 +258,7 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	condlog(3, "alias = %s", alias);
 	map_present = dm_map_present(alias);
 
-	if (map_present && dm_type(alias, TGT_MPATH) <= 0){
+	if (map_present && !dm_is_mpath(alias)){
 		condlog(3, "%s: not a multipath device.", alias);
 		ret = MPATH_PR_DMMP_ERROR;
 		goto out;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 560d418..cef8522 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -581,6 +581,48 @@ out:
 	return r;
 }
 
+extern int
+dm_is_mpath(const char * name)
+{
+	int r = 0;
+	struct dm_task *dmt;
+	struct dm_info info;
+	uint64_t start, length;
+	char *target_type = NULL;
+	char *params;
+	const char *uuid;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_TABLE)))
+		return 0;
+
+	if (!dm_task_set_name(dmt, name))
+		goto out;
+
+	dm_task_no_open_count(dmt);
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!dm_task_get_info(dmt, &info) || !info.exists)
+		goto out;
+
+	uuid = dm_task_get_uuid(dmt);
+
+	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN) != 0)
+		goto out;
+
+	/* Fetch 1st target */
+	dm_get_next_target(dmt, NULL, &start, &length, &target_type, &params);
+
+	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
+		goto out;
+
+	r = 1;
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
 static int
 dm_dev_t (const char * mapname, char * dev_t, int len)
 {
@@ -698,10 +740,7 @@ _dm_flush_map (const char * mapname, int need_sync, int deferred_remove)
 {
 	int r;
 
-	if (!dm_map_present(mapname))
-		return 0;
-
-	if (dm_type(mapname, TGT_MPATH) <= 0)
+	if (!dm_is_mpath(mapname))
 		return 0; /* nothing to do */
 
 	if (dm_remove_partmaps(mapname, need_sync, deferred_remove))
@@ -751,10 +790,7 @@ dm_suspend_and_flush_map (const char * mapname)
 	unsigned long long mapsize;
 	char params[PARAMS_SIZE] = {0};
 
-	if (!dm_map_present(mapname))
-		return 0;
-
-	if (dm_type(mapname, TGT_MPATH) <= 0)
+	if (!dm_is_mpath(mapname))
 		return 0; /* nothing to do */
 
 	if (!dm_get_map(mapname, &mapsize, params)) {
@@ -915,7 +951,6 @@ dm_get_maps (vector mp)
 {
 	struct multipath * mpp;
 	int r = 1;
-	int info;
 	struct dm_task *dmt;
 	struct dm_names *names;
 	unsigned next = 0;
@@ -940,9 +975,7 @@ dm_get_maps (vector mp)
 	}
 
 	do {
-		info = dm_type(names->name, TGT_MPATH);
-
-		if (info <= 0)
+		if (!dm_is_mpath(names->name))
 			goto next;
 
 		mpp = alloc_multipath();
@@ -955,13 +988,11 @@ dm_get_maps (vector mp)
 		if (!mpp->alias)
 			goto out1;
 
-		if (info > 0) {
-			if (dm_get_map(names->name, &mpp->size, NULL))
-				goto out1;
+		if (dm_get_map(names->name, &mpp->size, NULL))
+			goto out1;
 
-			dm_get_uuid(names->name, mpp->wwid);
-			dm_get_info(names->name, &mpp->dmi);
-		}
+		dm_get_uuid(names->name, mpp->wwid);
+		dm_get_info(names->name, &mpp->dmi);
 
 		if (!vector_alloc_slot(mp))
 			goto out1;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 2613503..1752045 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -23,6 +23,7 @@ int dm_map_present (const char *);
 int dm_get_map(const char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
 int dm_type(const char *, char *);
+int dm_is_mpath(const char *);
 int _dm_flush_map (const char *, int, int);
 int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0)
diff --git a/multipathd/main.c b/multipathd/main.c
index 6c315ad..14afe0c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -295,7 +295,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 
 	map_present = dm_map_present(alias);
 
-	if (map_present && dm_type(alias, TGT_MPATH) <= 0) {
+	if (map_present && !dm_is_mpath(alias)) {
 		condlog(4, "%s: not a multipath map", alias);
 		return 0;
 	}
-- 
1.8.3.1
