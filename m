From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/31] kpartx: search partitions by UUID,
	and rename
Date: Sun,  3 Sep 2017 00:38:32 +0200
Message-ID: <20170902223900.7339-4-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Partition mappings may have been created by other tools such as parted,
multipathd (during map renaming), or kpartx itself with different
delimiter (-p) option. In such cases kpartx fails, because the partition
mappings have a different name. However, we have a convention for UUID
mappings which seems to be more universal. So, when the search for the
named partition fails, search for the UUID instead and try to rename the
map.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 kpartx/devmapper.h |   5 ++-
 kpartx/kpartx.c    |  49 ++++++------------------
 3 files changed, 120 insertions(+), 42 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 3d382285..4aca0e51 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -188,7 +188,7 @@ addout:
 	return r;
 }
 
-int dm_map_present(char * str, char **uuid)
+static int dm_map_present(char *str, char **uuid)
 {
 	int r = 0;
 	struct dm_task *dmt;
@@ -226,6 +226,51 @@ out:
 	return r;
 }
 
+static int dm_rename (const char *old, const char *new)
+{
+	int r = 0;
+	struct dm_task *dmt;
+	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK;
+	uint32_t cookie = 0;
+
+	dmt = dm_task_create(DM_DEVICE_RENAME);
+	if (!dmt)
+		return r;
+
+	if (!dm_task_set_name(dmt, old) ||
+	    !dm_task_set_newname(dmt, new) ||
+	    !dm_task_no_open_count(dmt) ||
+	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
+		goto out;
+
+	r = dm_task_run(dmt);
+	dm_udev_wait(cookie);
+
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
+static const char *dm_find_uuid(const char *uuid)
+{
+	struct dm_task *dmt;
+	const char *name = NULL, *tmp;
+
+	if ((dmt = dm_task_create(DM_DEVICE_INFO)) == NULL)
+		return NULL;
+
+	if (!dm_task_set_uuid(dmt, uuid) ||
+	    !dm_task_run(dmt))
+		goto out;
+
+	tmp = dm_task_get_name(dmt);
+	if (tmp != NULL && *tmp != '\0')
+		name = strdup(tmp);
+
+out:
+	dm_task_destroy(dmt);
+	return name;
+}
 
 char *
 dm_mapname(int major, int minor)
@@ -340,7 +385,7 @@ out:
 }
 
 static int
-dm_get_map(char *mapname, char * outparams)
+dm_get_map(const char *mapname, char * outparams)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -589,3 +634,62 @@ dm_remove_partmaps (char * mapname, char *uuid, dev_t devt, int verbose)
 	struct remove_data rd = { verbose };
 	return do_foreach_partmaps(mapname, uuid, devt, remove_partmap, &rd);
 }
+
+int dm_find_part(const char *parent, const char *delim, int part,
+		 const char *parent_uuid,
+		 char *name, size_t namesiz, char **part_uuid, int verbose)
+{
+	int r;
+	char params[PARAMS_SIZE];
+	const char *tmp;
+	char *uuid;
+	int major, minor;
+	char dev_t[32];
+
+	if (!format_partname(name, namesiz, parent, delim, part)) {
+		if (verbose)
+			fprintf(stderr, "partname too small\n");
+		return 0;
+	}
+
+	r = dm_map_present(name, part_uuid);
+	if (r == 1 || parent_uuid == NULL || *parent_uuid == '\0')
+		return r;
+
+	uuid = make_prefixed_uuid(part, parent_uuid);
+	if (!uuid)
+		return 0;
+
+	tmp = dm_find_uuid(uuid);
+	if (tmp == NULL)
+		return r;
+
+	/* Sanity check on partition, see dm_foreach_partmaps */
+	if (dm_type(tmp, "linear") != 1)
+		goto out;
+
+	if (dm_devn(parent, &major, &minor))
+		goto out;
+	snprintf(dev_t, sizeof(dev_t), "%d:%d", major, minor);
+
+	if (dm_get_map(tmp, params))
+		goto out;
+
+	if (!strstr(params, dev_t))
+		goto out;
+
+	if (verbose)
+		fprintf(stderr, "found map %s for uuid %s, renaming to %s\n",
+		       tmp, uuid, name);
+
+	r = dm_rename(tmp, name);
+	if (r == 0) {
+		free(uuid);
+		if (verbose)
+			fprintf(stderr, "renaming %s->%s failed\n", tmp, name);
+	} else
+		*part_uuid = uuid;
+out:
+	free((void*)tmp);
+	return r;
+}
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 2e28c780..0ce4b0d5 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -13,12 +13,13 @@ int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *, int, uint16_t);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
 	       int, const char *, int, mode_t, uid_t, gid_t);
-int dm_map_present (char *, char **);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(const char *mapname);
 int dm_devn (const char * mapname, int *major, int *minor);
 int dm_remove_partmaps (char * mapname, char *uuid, dev_t devt, int verbose);
-int dm_no_partitions(char * mapname);
+int dm_find_part(const char *parent, const char *delim, int part,
+		 const char *parent_uuid,
+		 char *name, size_t namesiz, char **part_uuid, int verbose);
 
 #endif /* _KPARTX_DEVMAPPER_H */
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 9ba78d01..ad486afd 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -150,18 +150,6 @@ set_delimiter (char * device, char * delimiter)
 		*delimiter = 'p';
 }
 
-static void
-strip_slash (char * device)
-{
-	char * p = device;
-
-	while (*(p++) != 0x0) {
-
-		if (*p == '/')
-			*p = '!';
-	}
-}
-
 static int
 find_devname_offset (char * device)
 {
@@ -527,21 +515,16 @@ main(int argc, char **argv){
 					continue;
 				}
 
-				if (safe_sprintf(partname, "%s%s%d",
-					     mapname, delim, j+1)) {
-					fprintf(stderr, "partname too small\n");
-					exit(1);
-				}
-				strip_slash(partname);
-
 				if (safe_sprintf(params, "%d:%d %" PRIu64 ,
 						 major(buf.st_rdev), minor(buf.st_rdev), slices[j].start)) {
 					fprintf(stderr, "params too small\n");
 					exit(1);
 				}
 
-				op = (dm_map_present(partname, &part_uuid) ?
-					DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
+				op = (dm_find_part(mapname, delim, j + 1, uuid,
+						   partname, sizeof(partname),
+						   &part_uuid, verbose) ?
+				      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
 				if (part_uuid && uuid) {
 					if (check_uuid(uuid, part_uuid, &reason) != 0) {
@@ -603,13 +586,6 @@ main(int argc, char **argv){
 						fprintf(stderr, "Invalid slice %d\n",
 							k);
 
-					if (safe_sprintf(partname, "%s%s%d",
-							 mapname, delim, j+1)) {
-						fprintf(stderr, "partname too small\n");
-						exit(1);
-					}
-					strip_slash(partname);
-
 					if (safe_sprintf(params, "%d:%d %" PRIu64,
 							 major(buf.st_rdev), minor(buf.st_rdev),
 							 slices[j].start)) {
@@ -617,8 +593,10 @@ main(int argc, char **argv){
 						exit(1);
 					}
 
-					op = (dm_map_present(partname,
-							     &part_uuid) ?
+					op = (dm_find_part(mapname, delim, j + 1, uuid,
+							   partname,
+							   sizeof(partname),
+							   &part_uuid, verbose) ?
 					      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
 					if (part_uuid && uuid) {
@@ -660,15 +638,10 @@ main(int argc, char **argv){
 
 			for (j = MAXSLICES-1; j >= 0; j--) {
 				char *part_uuid, *reason;
-				if (safe_sprintf(partname, "%s%s%d",
-					     mapname, delim, j+1)) {
-					fprintf(stderr, "partname too small\n");
-					exit(1);
-				}
-				strip_slash(partname);
-
 				if (slices[j].size ||
-				    !dm_map_present(partname, &part_uuid))
+				    !dm_find_part(mapname, delim, j + 1, uuid,
+						  partname, sizeof(partname),
+						  &part_uuid, verbose))
 					continue;
 
 				if (part_uuid && uuid) {
-- 
2.14.0
