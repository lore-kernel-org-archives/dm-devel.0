From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/23] libmultipath: use "const" in devmapper
	code
Date: Tue,  6 Mar 2018 00:14:51 +0100
Message-ID: <20180305231507.10386-8-mwilck@suse.com>
References: <20180305231507.10386-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-1-mwilck@suse.com>
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

Improve use of "const" qualifiers in libmultipath's devmapper code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 32 ++++++++++++++++----------------
 libmultipath/devmapper.h | 16 ++++++++--------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f112e1cb0e66..f61838cbe369 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -583,7 +583,7 @@ is_mpath_part(const char *part_name, const char *map_name)
 	return 0;
 }
 
-int dm_get_status(char *name, char *outstatus)
+int dm_get_status(const char *name, char *outstatus)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -807,7 +807,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	if (need_suspend &&
 	    !dm_get_map(mapname, &mapsize, params) &&
 	    strstr(params, "queue_if_no_path")) {
-		if (!dm_queue_if_no_path((char *)mapname, 0))
+		if (!dm_queue_if_no_path(mapname, 0))
 			queue_if_no_path = 1;
 		else
 			/* Leave queue_if_no_path alone if unset failed */
@@ -850,7 +850,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	} while (retries-- > 0);
 
 	if (queue_if_no_path == 1)
-		dm_queue_if_no_path((char *)mapname, 1);
+		dm_queue_if_no_path(mapname, 1);
 
 	return 1;
 }
@@ -938,7 +938,7 @@ out:
 }
 
 int
-dm_fail_path(char * mapname, char * path)
+dm_fail_path(const char * mapname, char * path)
 {
 	char message[32];
 
@@ -949,7 +949,7 @@ dm_fail_path(char * mapname, char * path)
 }
 
 int
-dm_reinstate_path(char * mapname, char * path)
+dm_reinstate_path(const char * mapname, char * path)
 {
 	char message[32];
 
@@ -960,7 +960,7 @@ dm_reinstate_path(char * mapname, char * path)
 }
 
 int
-dm_queue_if_no_path(char *mapname, int enable)
+dm_queue_if_no_path(const char *mapname, int enable)
 {
 	char *message;
 
@@ -973,7 +973,7 @@ dm_queue_if_no_path(char *mapname, int enable)
 }
 
 static int
-dm_groupmsg (char * msg, char * mapname, int index)
+dm_groupmsg (const char * msg, const char * mapname, int index)
 {
 	char message[32];
 
@@ -984,19 +984,19 @@ dm_groupmsg (char * msg, char * mapname, int index)
 }
 
 int
-dm_switchgroup(char * mapname, int index)
+dm_switchgroup(const char * mapname, int index)
 {
 	return dm_groupmsg("switch", mapname, index);
 }
 
 int
-dm_enablegroup(char * mapname, int index)
+dm_enablegroup(const char * mapname, int index)
 {
 	return dm_groupmsg("enable", mapname, index);
 }
 
 int
-dm_disablegroup(char * mapname, int index)
+dm_disablegroup(const char * mapname, int index)
 {
 	return dm_groupmsg("disable", mapname, index);
 }
@@ -1080,7 +1080,7 @@ out:
 }
 
 int
-dm_geteventnr (char *name)
+dm_geteventnr (const char *name)
 {
 	struct dm_info info;
 
@@ -1139,7 +1139,7 @@ dm_mapname(int major, int minor)
 
 	map = dm_task_get_name(dmt);
 	if (map && strlen(map))
-		response = STRDUP((char *)dm_task_get_name(dmt));
+		response = STRDUP((const char *)dm_task_get_name(dmt));
 
 	dm_task_destroy(dmt);
 	return response;
@@ -1264,7 +1264,7 @@ cancel_remove_partmap (const char *name, void *unused)
 }
 
 static int
-dm_get_deferred_remove (char * mapname)
+dm_get_deferred_remove (const char * mapname)
 {
 	struct dm_info info;
 
@@ -1412,10 +1412,10 @@ out:
 	return r;
 }
 
-void dm_reassign_deps(char *table, char *dep, char *newdep)
+void dm_reassign_deps(char *table, const char *dep, const char *newdep)
 {
-	char *p, *n;
-	char *newtable;
+	char *n;
+	const char *p, *newtable;
 
 	newtable = strdup(table);
 	if (!newtable)
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 558e6914074f..8c8ea6c29b27 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -38,7 +38,7 @@ int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present (const char *);
 int dm_get_map(const char *, unsigned long long *, char *);
-int dm_get_status(char *, char *);
+int dm_get_status(const char *, char *);
 int dm_type(const char *, char *);
 int dm_is_mpath(const char *);
 int _dm_flush_map (const char *, int, int, int, int);
@@ -49,14 +49,14 @@ int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
 	_dm_flush_map(mapname, 1, 0, 1, retries)
 int dm_cancel_deferred_remove(struct multipath *mpp);
 int dm_flush_maps (int retries);
-int dm_fail_path(char * mapname, char * path);
-int dm_reinstate_path(char * mapname, char * path);
-int dm_queue_if_no_path(char *mapname, int enable);
-int dm_switchgroup(char * mapname, int index);
-int dm_enablegroup(char * mapname, int index);
-int dm_disablegroup(char * mapname, int index);
+int dm_fail_path(const char * mapname, char * path);
+int dm_reinstate_path(const char * mapname, char * path);
+int dm_queue_if_no_path(const char *mapname, int enable);
+int dm_switchgroup(const char * mapname, int index);
+int dm_enablegroup(const char * mapname, int index);
+int dm_disablegroup(const char * mapname, int index);
 int dm_get_maps (vector mp);
-int dm_geteventnr (char *name);
+int dm_geteventnr (const char *name);
 int dm_is_suspended(const char *name);
 int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
-- 
2.16.1
