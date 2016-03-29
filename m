From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 15/17] multipath: check partitions unused before
	removing
Date: Mon, 28 Mar 2016 22:13:12 -0500
Message-ID: <1459221194-23222-16-git-send-email-bmarzins@redhat.com>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
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

If kpartx partition devices are in-use, multipath will not be able to
perform a non-deferred remove of the multipath device.  So, before
starting the remove, multipath should verify that none of the partition
devices are currently in-use.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 libmultipath/devmapper.h |  2 +-
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index cef8522..36c1a20 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -36,6 +36,10 @@
 static int dm_cancel_remove_partmaps(const char * mapname);
 #endif
 
+static int do_foreach_partmaps(const char * mapname,
+			       int (*partmap_func)(const char *, void *),
+			       void *data);
+
 #ifndef LIBDM_API_COOKIE
 static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
 {
@@ -735,6 +739,26 @@ out:
 	return r;
 }
 
+static int
+partmap_in_use(const char *name, void *data)
+{
+	int part_count, *ret_count = (int *)data;
+	int open_count = dm_get_opencount(name);
+
+	if (ret_count)
+		(*ret_count)++;
+	part_count = 0;
+	if (open_count) {
+		if (do_foreach_partmaps(name, partmap_in_use, &part_count))
+			return 1;
+		if (open_count != part_count) {
+			condlog(2, "%s: map in use", name);
+			return 1;
+		}
+	}
+	return 0;
+}
+
 extern int
 _dm_flush_map (const char * mapname, int need_sync, int deferred_remove)
 {
@@ -743,6 +767,11 @@ _dm_flush_map (const char * mapname, int need_sync, int deferred_remove)
 	if (!dm_is_mpath(mapname))
 		return 0; /* nothing to do */
 
+	/* If you aren't doing a deferred remove, make sure that no
+	 * devices are in use */
+	if (!do_deferred(deferred_remove) && partmap_in_use(mapname, NULL))
+			return 1;
+
 	if (dm_remove_partmaps(mapname, need_sync, deferred_remove))
 		return 1;
 
@@ -851,7 +880,7 @@ dm_flush_maps (void)
 }
 
 int
-dm_message(char * mapname, char * message)
+dm_message(const char * mapname, char * message)
 {
 	int r = 1;
 	struct dm_task *dmt;
@@ -1092,7 +1121,8 @@ bad:
 }
 
 static int
-do_foreach_partmaps (const char * mapname, int (*partmap_func)(char *, void *),
+do_foreach_partmaps (const char * mapname,
+		     int (*partmap_func)(const char *, void *),
 		     void *data)
 {
 	struct dm_task *dmt;
@@ -1165,7 +1195,7 @@ struct remove_data {
 };
 
 static int
-remove_partmap(char *name, void *data)
+remove_partmap(const char *name, void *data)
 {
 	struct remove_data *rd = (struct remove_data *)data;
 
@@ -1192,7 +1222,7 @@ dm_remove_partmaps (const char * mapname, int need_sync, int deferred_remove)
 #ifdef LIBDM_API_DEFERRED
 
 static int
-cancel_remove_partmap (char *name, void *unused)
+cancel_remove_partmap (const char *name, void *unused)
 {
 	if (dm_get_opencount(name))
 		dm_cancel_remove_partmaps(name);
@@ -1312,13 +1342,13 @@ out:
 }
 
 struct rename_data {
-	char *old;
+	const char *old;
 	char *new;
 	char *delim;
 };
 
 static int
-rename_partmap (char *name, void *data)
+rename_partmap (const char *name, void *data)
 {
 	char buff[PARAMS_SIZE];
 	int offset;
@@ -1335,7 +1365,7 @@ rename_partmap (char *name, void *data)
 }
 
 int
-dm_rename_partmaps (char * old, char * new)
+dm_rename_partmaps (const char * old, char * new)
 {
 	struct rename_data rd;
 
@@ -1352,7 +1382,7 @@ dm_rename_partmaps (char * old, char * new)
 }
 
 int
-dm_rename (char * old, char * new)
+dm_rename (const char * old, char * new)
 {
 	int r = 0;
 	struct dm_task *dmt;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 1752045..0d27723 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -46,7 +46,7 @@ int dm_remove_partmaps (const char * mapname, int need_sync,
 			int deferred_remove);
 int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
-int dm_rename (char * old, char * new);
+int dm_rename (const char * old, char * new);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
-- 
1.8.3.1
