From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] libmultipath: simplify dm_get_name()
Date: Tue, 20 Jul 2010 10:10:29 +0200
Message-ID: <20100720081029.B414429EF6@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


dm_get_name() should just return the device-mapper table
name corresponding to a given uuid. Happily the uuid is
another primary key in the device-mapper hash table, so
we can just use it directly and do not have to loop over
all existing tables.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/devmapper.c   |   60 +++++++++++++++++++++++++++-----------------
 libmultipath/devmapper.h   |    2 +-
 libmultipath/propsel.c     |   11 +------
 libmultipath/structs_vec.c |    8 +----
 4 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 333659b..fb69ee8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -777,35 +777,49 @@ out:
 	return r;
 }
 
-extern int
-dm_get_name(char *uuid, char *name)
+extern char *
+dm_get_name(char *uuid)
 {
-	vector vec;
-	struct multipath *mpp;
-	int i, rc = 0;
-
-	vec = vector_alloc();
+	struct dm_task *dmt;
+	struct dm_info info;
+	char *prefixed_uuid, *name = NULL;
+	const char *nametmp;
 
-	if (!vec)
-		return 0;
+	dmt = dm_task_create(DM_DEVICE_INFO);
+	if (!dmt)
+		return NULL;
 
-	if (dm_get_maps(vec)) {
-		goto out;
+	prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
+	if (!prefixed_uuid) {
+		condlog(0, "cannot create prefixed uuid : %s\n",
+			strerror(errno));
+		goto freeout;
 	}
+	sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid);
+	if (!dm_task_set_uuid(dmt, prefixed_uuid))
+		goto freeout;
 
-	vector_foreach_slot(vec, mpp, i) {
-		if (!strcmp(uuid, mpp->wwid)) {
-			strcpy(name, mpp->alias);
-			rc=1;
-			break;
-		}
-	}
-out:
-	vector_foreach_slot(vec, mpp, i) {
-		free_multipath(mpp, KEEP_PATHS);
+	if (!dm_task_run(dmt))
+		goto freeout;
+
+	if (!dm_task_get_info(dmt, &info) || !info.exists)
+		goto freeout;
+
+	nametmp = dm_task_get_name(dmt);
+	if (nametmp && strlen(nametmp)) {
+		name = MALLOC(strlen(nametmp) + 1);
+		if (name)
+			strcpy(name, nametmp);
+	} else {
+		condlog(2, "%s: no device-mapper name found", uuid);
 	}
-	vector_free(vec);
-	return rc;
+
+freeout:
+	if (prefixed_uuid)
+		FREE(prefixed_uuid);
+	dm_task_destroy(dmt);
+
+	return name;
 }
 
 int
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index f3ffeaa..6c22bf3 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -37,6 +37,6 @@ int dm_remove_partmaps (const char * mapname, int need_sync);
 int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
 int dm_rename (char * old, char * new);
-int dm_get_name(char * uuid, char * name);
+char * dm_get_name(char * uuid);
 
 #endif /* _DEVMAPPER_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 3074ce1..9944675 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -247,15 +247,8 @@ select_alias (struct multipath * mp)
 			mp->alias = get_user_friendly_alias(mp->wwid,
 					conf->bindings_file, mp->alias_prefix);
 		}
-		if (mp->alias == NULL){
-			char *alias;
-			if ((alias = MALLOC(WWID_SIZE)) != NULL){
-				if (dm_get_name(mp->wwid, alias) == 1)
-					mp->alias = alias;
-				else
-					FREE(alias);
-			}
-		}
+		if (mp->alias == NULL)
+			mp->alias = dm_get_name(mp->wwid);
 		if (mp->alias == NULL)
 			mp->alias = STRDUP(mp->wwid);
 	}
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 51c41e8..c526a70 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -337,15 +337,11 @@ retry:
 	if (update_multipath_strings(mpp, vecs->pathvec)) {
 		char *new_alias;
 
-		new_alias = MALLOC(WWID_SIZE);
-		if (!new_alias) {
-			condlog(0, "%s: failed to allocate alias", mpp->alias);
-			goto out;
-		}
 		/*
 		 * detect an external rename of the multipath device
 		 */
-		if (dm_get_name(mpp->wwid, new_alias)) {
+		new_alias = dm_get_name(mpp->wwid);
+		if (new_alias) {
 			condlog(3, "%s multipath mapped device name has "
 				"changed from %s to %s", mpp->wwid,
 				mpp->alias, new_alias);
-- 
1.6.0.2
