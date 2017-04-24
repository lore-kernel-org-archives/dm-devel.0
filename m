From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/5] libmultipath: fix partition detection
Date: Mon, 24 Apr 2017 17:39:28 -0500
Message-ID: <1493073570-17167-4-git-send-email-bmarzins@redhat.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
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

The do_foreach_partmaps code could incorrectly list a device as a
partition of another device, because of two issues.  First, the check to
compare the dm UUID of two devices would allow two partition devices to
match, or a partition device to match with itself, instead of only
having a partition device match with the multipath device that it
belongs to.  Second, the code to check if a multipath device's
major:minor appeared in a partition device's table only used strstr
to check of the existance of the major:minor string. This meant that
any device with a minor number that started with the same digits would
match. for instance, checking for "253:10" would also match "253:102".

This patch fixes these issues.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 53 ++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 5fb9d9a..c7602cb 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -493,42 +493,35 @@ uuidout:
 
 int dm_get_uuid(char *name, char *uuid)
 {
-	char uuidtmp[WWID_SIZE];
-
-	if (dm_get_prefixed_uuid(name, uuidtmp))
+	if (dm_get_prefixed_uuid(name, uuid))
 		return 1;
 
-	if (!strncmp(uuidtmp, UUID_PREFIX, UUID_PREFIX_LEN))
-		strcpy(uuid, uuidtmp + UUID_PREFIX_LEN);
-	else
-		strcpy(uuid, uuidtmp);
-
+	if (!strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
+		memmove(uuid, uuid + UUID_PREFIX_LEN,
+			strlen(uuid + UUID_PREFIX_LEN) + 1);
 	return 0;
 }
 
-/*
- * returns:
- *    0 : if both uuids end with same suffix which starts with UUID_PREFIX
- *    1 : otherwise
- */
-int
-dm_compare_uuid(const char* mapname1, const char* mapname2)
+static int
+is_mpath_part(const char *part_name, const char *map_name)
 {
-	char *p1, *p2;
-	char uuid1[WWID_SIZE], uuid2[WWID_SIZE];
+	char *p;
+	char part_uuid[WWID_SIZE], map_uuid[WWID_SIZE];
 
-	if (dm_get_prefixed_uuid(mapname1, uuid1))
-		return 1;
+	if (dm_get_prefixed_uuid(part_name, part_uuid))
+		return 0;
 
-	if (dm_get_prefixed_uuid(mapname2, uuid2))
-		return 1;
+	if (dm_get_prefixed_uuid(map_name, map_uuid))
+		return 0;
 
-	p1 = strstr(uuid1, UUID_PREFIX);
-	p2 = strstr(uuid2, UUID_PREFIX);
-	if (p1 && p2 && !strcmp(p1, p2))
+	if (strncmp(part_uuid, "part", 4) != 0)
 		return 0;
 
-	return 1;
+	p = strstr(part_uuid, UUID_PREFIX);
+	if (p && !strcmp(p, map_uuid))
+		return 1;
+
+	return 0;
 }
 
 int dm_get_status(char *name, char *outstatus)
@@ -1162,6 +1155,7 @@ do_foreach_partmaps (const char * mapname,
 	unsigned long long size;
 	char dev_t[32];
 	int r = 1;
+	char *p;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
 		return 1;
@@ -1190,10 +1184,10 @@ do_foreach_partmaps (const char * mapname,
 		    (dm_type(names->name, TGT_PART) > 0) &&
 
 		    /*
-		     * and both uuid end with same suffix starting
-		     * at UUID_PREFIX
+		     * and the uuid of the target is a partition of the
+		     * uuid of the multipath device
 		     */
-		    (!dm_compare_uuid(names->name, mapname)) &&
+		    is_mpath_part(names->name, mapname) &&
 
 		    /*
 		     * and we can fetch the map table from the kernel
@@ -1203,7 +1197,8 @@ do_foreach_partmaps (const char * mapname,
 		    /*
 		     * and the table maps over the multipath map
 		     */
-		    strstr(params, dev_t)
+		    (p = strstr(params, dev_t)) &&
+		    !isdigit(*(p + strlen(dev_t)))
 		   ) {
 			if (partmap_func(names->name, data) != 0)
 				goto out;
-- 
1.8.3.1
