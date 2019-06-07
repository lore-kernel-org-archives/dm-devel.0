From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/30] libmultipath: add size argument to
	dm_get_uuid()
Date: Fri,  7 Jun 2019 15:05:31 +0200
Message-ID: <20190607130552.13203-10-mwilck@suse.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
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

The length of the uuid field in libdm is DM_UUID_LEN, which happens
to be one byte more than our WWID_SIZE. Handle this cleanly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 28 +++++++++++++++++-----------
 libmultipath/devmapper.h |  2 +-
 libmultipath/wwids.c     |  3 ++-
 multipathd/main.c        |  2 +-
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2e79667d..0f0c3a34 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -13,7 +13,9 @@
 #include <unistd.h>
 #include <errno.h>
 #include <sys/sysmacros.h>
+#include <linux/dm-ioctl.h>
 
+#include "util.h"
 #include "checkers.h"
 #include "vector.h"
 #include "structs.h"
@@ -554,7 +556,7 @@ out:
 }
 
 static int
-dm_get_prefixed_uuid(const char *name, char *uuid)
+dm_get_prefixed_uuid(const char *name, char *uuid, int uuid_len)
 {
 	struct dm_task *dmt;
 	const char *uuidtmp;
@@ -572,7 +574,7 @@ dm_get_prefixed_uuid(const char *name, char *uuid)
 
 	uuidtmp = dm_task_get_uuid(dmt);
 	if (uuidtmp)
-		strcpy(uuid, uuidtmp);
+		strlcpy(uuid, uuidtmp, uuid_len);
 	else
 		uuid[0] = '\0';
 
@@ -582,14 +584,18 @@ uuidout:
 	return r;
 }
 
-int dm_get_uuid(const char *name, char *uuid)
+int dm_get_uuid(const char *name, char *uuid, int uuid_len)
 {
-	if (dm_get_prefixed_uuid(name, uuid))
+	char tmp[DM_UUID_LEN];
+
+	if (dm_get_prefixed_uuid(name, tmp, sizeof(tmp)))
 		return 1;
 
-	if (!strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
-		memmove(uuid, uuid + UUID_PREFIX_LEN,
-			strlen(uuid + UUID_PREFIX_LEN) + 1);
+	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
+		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
+	else
+		uuid[0] = '\0';
+
 	return 0;
 }
 
@@ -597,12 +603,12 @@ static int
 is_mpath_part(const char *part_name, const char *map_name)
 {
 	char *p;
-	char part_uuid[WWID_SIZE], map_uuid[WWID_SIZE];
+	char part_uuid[DM_UUID_LEN], map_uuid[DM_UUID_LEN];
 
-	if (dm_get_prefixed_uuid(part_name, part_uuid))
+	if (dm_get_prefixed_uuid(part_name, part_uuid, sizeof(part_uuid)))
 		return 0;
 
-	if (dm_get_prefixed_uuid(map_name, map_uuid))
+	if (dm_get_prefixed_uuid(map_name, map_uuid, sizeof(map_uuid)))
 		return 0;
 
 	if (strncmp(part_uuid, "part", 4) != 0)
@@ -1066,7 +1072,7 @@ struct multipath *dm_get_multipath(const char *name)
 	if (dm_get_map(name, &mpp->size, NULL))
 		goto out;
 
-	dm_get_uuid(name, mpp->wwid);
+	dm_get_uuid(name, mpp->wwid, WWID_SIZE);
 	dm_get_info(name, &mpp->dmi);
 
 	return mpp;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index db75526c..7557a86b 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -63,7 +63,7 @@ int dm_get_major_minor (const char *name, int *major, int *minor);
 char * dm_mapname(int major, int minor);
 int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
-int dm_get_uuid(const char *name, char *uuid);
+int dm_get_uuid(const char *name, char *uuid, int uuid_len);
 int dm_get_info (const char * mapname, struct dm_info ** dmi);
 int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 53e79511..ef748125 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -294,7 +294,8 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 		char tmp_wwid[WWID_SIZE];
 		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
 
-		if (mp != NULL && dm_get_uuid(mp->alias, tmp_wwid) == 0 &&
+		if (mp != NULL &&
+		    dm_get_uuid(mp->alias, tmp_wwid, WWID_SIZE) == 0 &&
 		    !strncmp(tmp_wwid, pp1->wwid, WWID_SIZE)) {
 			condlog(3, "wwid %s is already multipathed, keeping it",
 				pp1->wwid);
diff --git a/multipathd/main.c b/multipathd/main.c
index eef84a39..2e4973d7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -406,7 +406,7 @@ set_multipath_wwid (struct multipath * mpp)
 	if (strlen(mpp->wwid))
 		return;
 
-	dm_get_uuid(mpp->alias, mpp->wwid);
+	dm_get_uuid(mpp->alias, mpp->wwid, WWID_SIZE);
 }
 
 static void set_no_path_retry(struct multipath *mpp)
-- 
2.21.0
