From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/8] libmultipath: refactor partmaps code
Date: Fri, 16 Jan 2015 14:23:28 -0600
Message-ID: <1421439812-11826-5-git-send-email-bmarzins@redhat.com>
References: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
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

There was a lot of code duplication between dm_remove_partmaps and
dm_rename_partmaps. This patch factors that out into
do_foreach_partmaps.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 156 +++++++++++++++++++----------------------------
 1 file changed, 62 insertions(+), 94 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 9e585f9..cddb9de 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -998,8 +998,9 @@ bad:
 	return NULL;
 }
 
-int
-dm_remove_partmaps (const char * mapname, int need_sync)
+static int
+do_foreach_partmaps (const char * mapname, int (*partmap_func)(char *, void *),
+		     void *data)
 {
 	struct dm_task *dmt;
 	struct dm_names *names;
@@ -1051,26 +1052,8 @@ dm_remove_partmaps (const char * mapname, int need_sync)
 		     */
 		    strstr(params, dev_t)
 		   ) {
-			/*
-			 * then it's a kpartx generated partition.
-			 * remove it.
-			 */
-			/*
-			 * if the opencount is 0 maybe some other
-			 * partitions depend on it.
-			 */
-			if (dm_get_opencount(names->name)) {
-				dm_remove_partmaps(names->name, need_sync);
-				if (dm_get_opencount(names->name)) {
-					condlog(2, "%s: map in use",
-						names->name);
-					goto out;
-				}
-			}
-			condlog(4, "partition map %s removed",
-				names->name);
-			dm_simplecmd_flush(DM_DEVICE_REMOVE, names->name,
-					   need_sync, 0);
+			if (partmap_func(names->name, data) != 0)
+				goto out;
 		}
 
 		next = names->next;
@@ -1083,6 +1066,35 @@ out:
 	return r;
 }
 
+struct remove_data {
+	int need_sync;
+};
+
+static int
+remove_partmap(char *name, void *data)
+{
+	struct remove_data *rd = (struct remove_data *)data;
+
+	if (dm_get_opencount(name)) {
+		dm_remove_partmaps(name, rd->need_sync);
+		if (dm_get_opencount(name)) {
+			condlog(2, "%s: map in use", name);
+			return 1;
+		}
+	}
+	condlog(4, "partition map %s removed", name);
+	dm_simplecmd_flush(DM_DEVICE_REMOVE, name,
+			   rd->need_sync, 0);
+	return 0;
+}
+
+int
+dm_remove_partmaps (const char * mapname, int need_sync)
+{
+	struct remove_data rd = { need_sync };
+	return do_foreach_partmaps(mapname, remove_partmap, &rd);
+}
+
 static struct dm_info *
 alloc_dminfo (void)
 {
@@ -1132,88 +1144,44 @@ out:
 	return r;
 }
 
-int
-dm_rename_partmaps (char * old, char * new)
+struct rename_data {
+	char *old;
+	char *new;
+	char *delim;
+};
+
+static int
+rename_partmap (char *name, void *data)
 {
-	struct dm_task *dmt;
-	struct dm_names *names;
-	unsigned next = 0;
 	char buff[PARAMS_SIZE];
-	unsigned long long size;
-	char dev_t[32];
-	int r = 1;
 	int offset;
-	char *delim;
+	struct rename_data *rd = (struct rename_data *)data;
 
-	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
-		return 1;
-
-	dm_task_no_open_count(dmt);
-
-	if (!dm_task_run(dmt))
-		goto out;
-
-	if (!(names = dm_task_get_names(dmt)))
-		goto out;
+	if (strncmp(name, rd->old, strlen(rd->old)) != 0)
+		return 0;
+	for (offset = strlen(rd->old); name[offset] && !(isdigit(name[offset])); offset++); /* do nothing */
+	snprintf(buff, PARAMS_SIZE, "%s%s%s", rd->new, rd->delim,
+		 name + offset);
+	dm_rename(name, buff);
+	condlog(4, "partition map %s renamed", name);
+	return 0;
+}
 
-	if (!names->dev) {
-		r = 0; /* this is perfectly valid */
-		goto out;
-	}
+int
+dm_rename_partmaps (char * old, char * new)
+{
+	struct rename_data rd;
 
-	if (dm_dev_t(old, &dev_t[0], 32))
-		goto out;
+	rd.old = old;
+	rd.new = new;
 
 	if (conf->partition_delim)
-		delim = conf->partition_delim;
+		rd.delim = conf->partition_delim;
 	if (isdigit(new[strlen(new)-1]))
-		delim = "p";
+		rd.delim = "p";
 	else
-		delim = "";
-
-	do {
-		if (
-		    /*
-		     * if devmap target is "linear"
-		     */
-		    (dm_type(names->name, TGT_PART) > 0) &&
-
-		    /*
-		     * and the multipath mapname and the part mapname start
-		     * the same
-		     */
-		    !strncmp(names->name, old, strlen(old)) &&
-
-		    /*
-		     * and we can fetch the map table from the kernel
-		     */
-		    !dm_get_map(names->name, &size, &buff[0]) &&
-
-		    /*
-		     * and the table maps over the multipath map
-		     */
-		    strstr(buff, dev_t)
-		   ) {
-				/*
-				 * then it's a kpartx generated partition.
-				 * Rename it.
-				 */
-				for (offset = strlen(old); names->name[offset] && !(isdigit(names->name[offset])); offset++); /* do nothing */
-				snprintf(buff, PARAMS_SIZE, "%s%s%s",
-					 new, delim, names->name + offset);
-				dm_rename(names->name, buff);
-				condlog(4, "partition map %s renamed",
-					names->name);
-		   }
-
-		next = names->next;
-		names = (void *) names + next;
-	} while (next);
-
-	r = 0;
-out:
-	dm_task_destroy (dmt);
-	return r;
+		rd.delim = "";
+	return do_foreach_partmaps(old, rename_partmap, &rd);
 }
 
 int
-- 
1.8.3.1
