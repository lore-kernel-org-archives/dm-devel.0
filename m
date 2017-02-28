From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 29/33] kpartx: sanitize delete partitions
Date: Tue, 28 Feb 2017 17:23:25 +0100
Message-ID: <20170228162329.14517-30-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

kpartx has a rather braindead method for deleting partitions;
generating 'possible' partition names and trying to remove all
of them.
With this patch kpartx looks at the device-mapper devices on top
of the referenced device, and removes them if they found to be
kpartx-generated devices.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/devmapper.c | 229 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 kpartx/devmapper.h |   7 +-
 kpartx/kpartx.c    |  44 ++--------
 3 files changed, 229 insertions(+), 51 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 2acae25e..cf6650c6 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -252,7 +252,7 @@ out:
 }
 
 char *
-dm_mapuuid(int major, int minor)
+dm_mapuuid(const char *mapname)
 {
 	struct dm_task *dmt;
 	const char *tmp;
@@ -261,9 +261,9 @@ dm_mapuuid(int major, int minor)
 	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
 		return NULL;
 
+	if (!dm_task_set_name(dmt, mapname))
+		goto out;
 	dm_task_no_open_count(dmt);
-	dm_task_set_major(dmt, major);
-	dm_task_set_minor(dmt, minor);
 
 	if (!dm_task_run(dmt))
 		goto out;
@@ -277,7 +277,7 @@ out:
 }
 
 int
-dm_devn (char * mapname, int *major, int *minor)
+dm_devn (const char * mapname, int *major, int *minor)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -304,8 +304,8 @@ out:
 	return r;
 }
 
-int
-dm_get_map(int major, int minor, char * outparams)
+static int
+dm_get_map(char *mapname, char * outparams)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -316,8 +316,8 @@ dm_get_map(int major, int minor, char * outparams)
 	if (!(dmt = dm_task_create(DM_DEVICE_TABLE)))
 		return 1;
 
-	dm_task_set_major(dmt, major);
-	dm_task_set_minor(dmt, minor);
+	if (!dm_task_set_name(dmt, mapname))
+		goto out;
 	dm_task_no_open_count(dmt);
 
 	if (!dm_task_run(dmt))
@@ -334,15 +334,224 @@ out:
 	return r;
 }
 
+static int
+dm_get_opencount (const char * mapname)
+{
+	int r = -1;
+	struct dm_task *dmt;
+	struct dm_info info;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
+		return 0;
+
+	if (!dm_task_set_name(dmt, mapname))
+		goto out;
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!dm_task_get_info(dmt, &info))
+		goto out;
+
+	if (!info.exists)
+		goto out;
+
+	r = info.open_count;
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
+/*
+ * returns:
+ *    1 : match
+ *    0 : no match
+ *   -1 : empty map
+ */
+static int
+dm_type(const char * name, char * type)
+{
+	int r = 0;
+	struct dm_task *dmt;
+	uint64_t start, length;
+	char *target_type = NULL;
+	char *params;
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
+	/* Fetch 1st target */
+	dm_get_next_target(dmt, NULL, &start, &length,
+			   &target_type, &params);
+
+	if (!target_type)
+		r = -1;
+	else if (!strcmp(target_type, type))
+		r = 1;
+
+out:
+	dm_task_destroy(dmt);
+	return r;
+}
+
+/*
+ * returns:
+ *    0 : if both uuids end with same suffix which starts with UUID_PREFIX
+ *    1 : otherwise
+ */
+int
+dm_compare_uuid(const char *mapuuid, const char *partname)
+{
+	char *partuuid;
+	int r = 1;
+
+	partuuid = dm_mapuuid(partname);
+	if (!partuuid)
+		return 1;
+
+	if (!strncmp(partuuid, "part", 4)) {
+		char *p = strstr(partuuid, "mpath-");
+		if (p && !strcmp(mapuuid, p))
+			r = 0;
+	}
+	free(partuuid);
+	return r;
+}
+
+struct remove_data {
+	int verbose;
+};
+
+static int
+do_foreach_partmaps (const char * mapname, const char *uuid,
+		     int (*partmap_func)(const char *, void *),
+		     void *data)
+{
+	struct dm_task *dmt;
+	struct dm_names *names;
+	struct remove_data *rd = data;
+	unsigned next = 0;
+	char params[PARAMS_SIZE];
+	int major, minor;
+	char dev_t[32];
+	int r = 1;
+
+	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
+		return 1;
+
+	dm_task_no_open_count(dmt);
+
+	if (!dm_task_run(dmt))
+		goto out;
+
+	if (!(names = dm_task_get_names(dmt)))
+		goto out;
+
+	if (!names->dev) {
+		r = 0; /* this is perfectly valid */
+		goto out;
+	}
+
+	if (dm_devn(mapname, &major, &minor))
+		goto out;
+
+	sprintf(dev_t, "%d:%d", major, minor);
+	do {
+		/*
+		 * skip our devmap
+		 */
+		if (!strcmp(names->name, mapname))
+			goto next;
+
+		/*
+		 * skip if we cannot fetch the map table from the kernel
+		 */
+		if (dm_get_map(names->name, &params[0]))
+			goto next;
+
+		/*
+		 * skip if the table does not map over the multipath map
+		 */
+		if (!strstr(params, dev_t))
+			goto next;
+
+		/*
+		 * skip if devmap target is not "linear"
+		 */
+		if (!dm_type(names->name, "linear")) {
+			if (rd->verbose)
+				printf("%s: is not a linear target. Not removing\n",
+				       names->name);
+			goto next;
+		}
+
+		/*
+		 * skip if uuids don't match
+		 */
+		if (dm_compare_uuid(uuid, names->name)) {
+			if (rd->verbose)
+				printf("%s: is not a kpartx partition. Not removing\n",
+				       names->name);
+			goto next;
+		}
+
+		if (partmap_func(names->name, data) != 0)
+			goto out;
+	next:
+		next = names->next;
+		names = (void *) names + next;
+	} while (next);
+
+	r = 0;
+out:
+	dm_task_destroy (dmt);
+	return r;
+}
+
+static int
+remove_partmap(const char *name, void *data)
+{
+	struct remove_data *rd = (struct remove_data *)data;
+	int r = 0;
+
+	if (dm_get_opencount(name)) {
+		if (rd->verbose)
+			printf("%s is in use. Not removing", name);
+		return 1;
+	}
+	if (!dm_simplecmd(DM_DEVICE_REMOVE, name, 0, 0)) {
+		if (rd->verbose)
+			printf("%s: failed to remove\n", name);
+		r = 1;
+	} else if (rd->verbose)
+		printf("del devmap : %s\n", name);
+	return r;
+}
+
+int
+dm_remove_partmaps (char * mapname, char *uuid, int verbose)
+{
+	struct remove_data rd = { verbose };
+	return do_foreach_partmaps(mapname, uuid, remove_partmap, &rd);
+}
+
 #define FEATURE_NO_PART "no_partitions"
 
 int
-dm_no_partitions(int major, int minor)
+dm_no_partitions(char *mapname)
 {
 	char params[PARAMS_SIZE], *ptr;
 	int i, num_features;
 
-	if (dm_get_map(major, minor, params))
+	if (dm_get_map(mapname, params))
 		return 0;
 
 	ptr = params;
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 436efe11..9988ec0f 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -16,8 +16,9 @@ int dm_addmap (int, const char *, const char *, const char *, uint64_t,
 int dm_map_present (char *, char **);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
-char * dm_mapuuid(int major, int minor);
-int dm_devn (char * mapname, int *major, int *minor);
-int dm_no_partitions(int major, int minor);
+char * dm_mapuuid(const char *mapname);
+int dm_devn (const char * mapname, int *major, int *minor);
+int dm_remove_partmaps (char * mapname, char *uuid, int verbose);
+int dm_no_partitions(char * mapname);
 
 #endif /* _KPARTX_DEVMAPPER_H */
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 34527877..58e60ffe 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -355,17 +355,15 @@ main(int argc, char **argv){
 	off = find_devname_offset(device);
 
 	if (!loopdev) {
-		uuid = dm_mapuuid(major(buf.st_rdev), minor(buf.st_rdev));
 		mapname = dm_mapname(major(buf.st_rdev), minor(buf.st_rdev));
+		if (mapname)
+			uuid = dm_mapuuid(mapname);
 	}
 
-	if (!uuid)
-		uuid = device + off;
-
 	if (!mapname)
 		mapname = device + off;
-	else if (!force_devmap &&
-		 dm_no_partitions(major(buf.st_rdev), minor(buf.st_rdev))) {
+	if (!force_devmap &&
+		 dm_no_partitions(mapname)) {
 		/* Feature 'no_partitions' is set, return */
 		return 0;
 	}
@@ -453,42 +451,12 @@ main(int argc, char **argv){
 			break;
 
 		case DELETE:
-			for (j = MAXSLICES-1; j >= 0; j--) {
-				char *part_uuid, *reason;
-
-				if (safe_sprintf(partname, "%s%s%d",
-					     mapname, delim, j+1)) {
-					fprintf(stderr, "partname too small\n");
-					exit(1);
-				}
-				strip_slash(partname);
-
-				if (!dm_map_present(partname, &part_uuid))
-					continue;
-
-				if (part_uuid && uuid) {
-					if (check_uuid(uuid, part_uuid, &reason) != 0) {
-						fprintf(stderr, "%s is %s. Not removing\n", partname, reason);
-						free(part_uuid);
-						continue;
-					}
-					free(part_uuid);
-				}
-
-				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname,
-						  0, 0)) {
-					r++;
-					continue;
-				}
-				if (verbose)
-					printf("del devmap : %s\n", partname);
-			}
-
+			r = dm_remove_partmaps(mapname, uuid, verbose);
 			if (loopdev) {
 				if (del_loop(loopdev)) {
 					if (verbose)
 						printf("can't del loop : %s\n",
-							loopdev);
+						       loopdev);
 					exit(1);
 				}
 				printf("loop deleted : %s\n", loopdev);
-- 
2.11.0
