From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/7] libmultipath: change do_get_info returns
Date: Wed, 17 Jun 2020 19:24:21 -0500
Message-ID: <1592439867-18427-2-git-send-email-bmarzins@redhat.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Make do_get_info() differentiate between dm failures and missing
devices, and update callers to retain their current behavior. Also,
rename it and make it external. These changes will be used by future
commits.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 29 ++++++++++++++++-------------
 libmultipath/devmapper.h |  1 +
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 27d52398..b44f7545 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -496,8 +496,14 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	return 0;
 }
 
-static int
-do_get_info(const char *name, struct dm_info *info)
+/*
+ * Returns:
+ * -1: Error
+ *  0: device does not exist
+ *  1: device exists
+ */
+int
+do_dm_get_info(const char *name, struct dm_info *info)
 {
 	int r = -1;
 	struct dm_task *dmt;
@@ -516,10 +522,7 @@ do_get_info(const char *name, struct dm_info *info)
 	if (!dm_task_get_info(dmt, info))
 		goto out;
 
-	if (!info->exists)
-		goto out;
-
-	r = 0;
+	r = !!info->exists;
 out:
 	dm_task_destroy(dmt);
 	return r;
@@ -529,7 +532,7 @@ int dm_map_present(const char * str)
 {
 	struct dm_info info;
 
-	return (do_get_info(str, &info) == 0);
+	return (do_dm_get_info(str, &info) == 1);
 }
 
 int dm_get_map(const char *name, unsigned long long *size, char *outparams)
@@ -820,7 +823,7 @@ dm_dev_t (const char * mapname, char * dev_t, int len)
 {
 	struct dm_info info;
 
-	if (do_get_info(mapname, &info) != 0)
+	if (do_dm_get_info(mapname, &info) != 1)
 		return 1;
 
 	if (snprintf(dev_t, len, "%i:%i", info.major, info.minor) > len)
@@ -862,7 +865,7 @@ dm_get_major_minor(const char *name, int *major, int *minor)
 {
 	struct dm_info info;
 
-	if (do_get_info(name, &info) != 0)
+	if (do_dm_get_info(name, &info) != 1)
 		return -1;
 
 	*major = info.major;
@@ -1199,7 +1202,7 @@ dm_geteventnr (const char *name)
 {
 	struct dm_info info;
 
-	if (do_get_info(name, &info) != 0)
+	if (do_dm_get_info(name, &info) != 1)
 		return -1;
 
 	return info.event_nr;
@@ -1210,7 +1213,7 @@ dm_is_suspended(const char *name)
 {
 	struct dm_info info;
 
-	if (do_get_info(name, &info) != 0)
+	if (do_dm_get_info(name, &info) != 1)
 		return -1;
 
 	return info.suspended;
@@ -1383,7 +1386,7 @@ dm_get_deferred_remove (const char * mapname)
 {
 	struct dm_info info;
 
-	if (do_get_info(mapname, &info) != 0)
+	if (do_dm_get_info(mapname, &info) != 1)
 		return -1;
 
 	return info.deferred_remove;
@@ -1442,7 +1445,7 @@ dm_get_info (const char * mapname, struct dm_info ** dmi)
 	if (!*dmi)
 		return 1;
 
-	if (do_get_info(mapname, *dmi) != 0) {
+	if (do_dm_get_info(mapname, *dmi) != 1) {
 		memset(*dmi, 0, sizeof(struct dm_info));
 		FREE(*dmi);
 		*dmi = NULL;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 5ed7edc5..79c9afb2 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -66,6 +66,7 @@ char * dm_mapname(int major, int minor);
 int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
 int dm_get_uuid(const char *name, char *uuid, int uuid_len);
+int do_dm_get_info(const char *, struct dm_info *);
 int dm_get_info (const char * mapname, struct dm_info ** dmi);
 int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
-- 
2.17.2
