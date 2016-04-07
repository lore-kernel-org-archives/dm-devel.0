From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 12/18] kpartx: verify partition devices
Date: Thu,  7 Apr 2016 18:20:06 -0500
Message-ID: <1460071212-21018-13-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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

When kpartx is modifies devices (either by removing them, or
reloading them), it doesn't first verify that the device really
is a partition of the expected device.  If a dm device just happens
to have the same name as a kpartx created device would, kpartx can
either delete that device or remap it, causing all sorts of problems.

This patch makes kpartx check the uuid to verify that the device it is
modifying really is a partition device for the correct dm device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c | 17 ++++++++++---
 kpartx/devmapper.h |  2 +-
 kpartx/kpartx.c    | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 82be990..e006bc3 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -167,12 +167,16 @@ addout:
 }
 
 extern int
-dm_map_present (char * str)
+dm_map_present (char * str, char **uuid)
 {
 	int r = 0;
 	struct dm_task *dmt;
+	const char *uuidtmp;
 	struct dm_info info;
 
+	if (uuid)
+		*uuid = NULL;
+
 	if (!(dmt = dm_task_create(DM_DEVICE_INFO)))
 		return 0;
 
@@ -187,8 +191,15 @@ dm_map_present (char * str)
 	if (!dm_task_get_info(dmt, &info))
 		goto out;
 
-	if (info.exists)
-		r = 1;
+	if (!info.exists)
+		goto out;
+
+	r = 1;
+	if (uuid) {
+		uuidtmp = dm_task_get_uuid(dmt);
+		if (uuidtmp && strlen(uuidtmp))
+			*uuid = strdup(uuidtmp);
+	}
 out:
 	dm_task_destroy(dmt);
 	return r;
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index ac1d5d9..436efe1 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -13,7 +13,7 @@ int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *, int, uint16_t);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
 	       int, const char *, int, mode_t, uid_t, gid_t);
-int dm_map_present (char *);
+int dm_map_present (char *, char **);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
 char * dm_mapuuid(int major, int minor);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 8047698..e8c35d4 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -191,6 +191,21 @@ get_hotplug_device(void)
 	return device;
 }
 
+static int
+check_uuid(char *uuid, char *part_uuid, char **err_msg) {
+	char *map_uuid = strchr(part_uuid, '-');
+	if (!map_uuid || strncmp(part_uuid, "part", 4) != 0) {
+		*err_msg = "not a kpartx partition";
+		return -1;
+	}
+	map_uuid++;
+	if (strcmp(uuid, map_uuid) != 0) {
+		*err_msg = "a partition of a different device";
+		return -1;
+	}
+	return 0;
+}
+
 int
 main(int argc, char **argv){
 	int i, j, m, n, op, off, arg, c, d, ro=0;
@@ -432,6 +447,8 @@ main(int argc, char **argv){
 
 		case DELETE:
 			for (j = MAXSLICES-1; j >= 0; j--) {
+				char *part_uuid, *reason;
+
 				if (safe_sprintf(partname, "%s%s%d",
 					     mapname, delim, j+1)) {
 					fprintf(stderr, "partname too small\n");
@@ -439,9 +456,18 @@ main(int argc, char **argv){
 				}
 				strip_slash(partname);
 
-				if (!dm_map_present(partname))
+				if (!dm_map_present(partname, &part_uuid))
 					continue;
 
+				if (part_uuid && uuid) {
+					if (check_uuid(uuid, part_uuid, &reason) != 0) {
+						fprintf(stderr, "%s is %s. Not removing\n", partname, reason);
+						free(part_uuid);
+						continue;
+					}
+					free(part_uuid);
+				}
+
 				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname,
 						  0, 0)) {
 					r++;
@@ -466,6 +492,8 @@ main(int argc, char **argv){
 		case UPDATE:
 			/* ADD and UPDATE share the same code that adds new partitions. */
 			for (j = 0, c = 0; j < n; j++) {
+				char *part_uuid, *reason;
+
 				if (slices[j].size == 0)
 					continue;
 
@@ -488,9 +516,19 @@ main(int argc, char **argv){
 					exit(1);
 				}
 
-				op = (dm_map_present(partname) ?
+				op = (dm_map_present(partname, &part_uuid) ?
 					DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
+				if (part_uuid && uuid) {
+					if (check_uuid(uuid, part_uuid, &reason) != 0) {
+						fprintf(stderr, "%s is already in use, and %s\n", partname, reason);
+						r++;
+						free(part_uuid);
+						continue;
+					}
+					free(part_uuid);
+				}
+
 				if (!dm_addmap(op, partname, DM_TARGET, params,
 					       slices[j].size, ro, uuid, j+1,
 					       buf.st_mode & 0777, buf.st_uid,
@@ -498,6 +536,7 @@ main(int argc, char **argv){
 					fprintf(stderr, "create/reload failed on %s\n",
 						partname);
 					r++;
+					continue;
 				}
 				if (op == DM_DEVICE_RELOAD &&
 				    !dm_simplecmd(DM_DEVICE_RESUME, partname,
@@ -505,6 +544,7 @@ main(int argc, char **argv){
 					fprintf(stderr, "resume failed on %s\n",
 						partname);
 					r++;
+					continue;
 				}
 
 				dm_devn(partname, &slices[j].major,
@@ -520,6 +560,7 @@ main(int argc, char **argv){
 			d = c;
 			while (c) {
 				for (j = 0; j < n; j++) {
+					char *part_uuid, *reason;
 					int k = slices[j].container - 1;
 
 					if (slices[j].size == 0)
@@ -552,9 +593,19 @@ main(int argc, char **argv){
 						exit(1);
 					}
 
-					op = (dm_map_present(partname) ?
+					op = (dm_map_present(partname,
+							     &part_uuid) ?
 					      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
+					if (part_uuid && uuid) {
+						if (check_uuid(uuid, part_uuid, &reason) != 0) {
+							fprintf(stderr, "%s is already in use, and %s\n", partname, reason);
+							free(part_uuid);
+							continue;
+						}
+						free(part_uuid);
+					}
+
 					dm_addmap(op, partname, DM_TARGET, params,
 						  slices[j].size, ro, uuid, j+1,
 						  buf.st_mode & 0777,
@@ -584,6 +635,7 @@ main(int argc, char **argv){
 			}
 
 			for (j = MAXSLICES-1; j >= 0; j--) {
+				char *part_uuid, *reason;
 				if (safe_sprintf(partname, "%s%s%d",
 					     mapname, delim, j+1)) {
 					fprintf(stderr, "partname too small\n");
@@ -591,9 +643,19 @@ main(int argc, char **argv){
 				}
 				strip_slash(partname);
 
-				if (slices[j].size || !dm_map_present(partname))
+				if (slices[j].size ||
+				    !dm_map_present(partname, &part_uuid))
 					continue;
 
+				if (part_uuid && uuid) {
+					if (check_uuid(uuid, part_uuid, &reason) != 0) {
+						fprintf(stderr, "%s is %s. Not removing\n", partname, reason);
+						free(part_uuid);
+						continue;
+					}
+					free(part_uuid);
+				}
+
 				if (!dm_simplecmd(DM_DEVICE_REMOVE,
 						  partname, 1, 0)) {
 					r++;
-- 
1.8.3.1
