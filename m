From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 03/18] dm-snapshot-new-ctr-table-format
Date: Tue, 29 Sep 2009 18:53:28 -0400
Message-ID: <1254264823-11538-4-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

From: Jon Brassow <jbrassow@redhat.com>

This patch introduces the new constructor table formats for snapshots
and exception stores.  This allows for new exception store types and
allows for easy addition of future features to snapshots.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap-persistent.c |    9 +++++++--
 drivers/md/dm-snap-transient.c  |    9 +++++++--
 drivers/md/dm-snap.c            |   36 +++++++++++++++++++++++++++++-------
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index e69d632..7887e25 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -722,8 +722,13 @@ static unsigned persistent_status(struct dm_exception_store *store,
 	case STATUSTYPE_INFO:
 		break;
 	case STATUSTYPE_TABLE:
-		DMEMIT(" %s P %llu", store->cow->name,
-		       (unsigned long long)store->chunk_size);
+		if (!strcmp("P", store->type->name))
+			DMEMIT(" %s P %llu", store->cow->name,
+			       (unsigned long long)store->chunk_size);
+		else
+			DMEMIT(" %s 2 %s %llu", store->type->name,
+			       store->cow->name,
+			       (unsigned long long)store->chunk_size);
 	}
 
 	return sz;
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index cde5aa5..786d96d 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -91,8 +91,13 @@ static unsigned transient_status(struct dm_exception_store *store,
 	case STATUSTYPE_INFO:
 		break;
 	case STATUSTYPE_TABLE:
-		DMEMIT(" %s N %llu", store->cow->name,
-		       (unsigned long long)store->chunk_size);
+		if (!strcmp("N", store->type->name))
+			DMEMIT(" %s N %llu", store->cow->name,
+			       (unsigned long long)store->chunk_size);
+		else
+			DMEMIT(" %s 2 %s %llu", store->type->name,
+			       store->cow->name,
+			       (unsigned long long)store->chunk_size);
 	}
 
 	return sz;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 109fbea..b3cb063 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -587,7 +587,10 @@ static int init_hash_tables(struct dm_snapshot *s)
  * @store: contains newly allocated dm_exception_store
  *
  * Possible formats for argv::
+ * Backwards compatibility mode:
  *     <COW-dev> p/n <chunk-size>
+ * Current format:
+ *     <store type> <arg count> <COW> <chunk-size> [other args]
  *
  * Returns: 0 on success, -Exxx on error
  */
@@ -595,12 +598,14 @@ static int create_exception_store(struct dm_target *ti, unsigned argc,
 				  char **argv, unsigned *args_used,
 				  struct dm_exception_store **store)
 {
+	unsigned param_count;
 	char *tmp_argv[2];
 	char old_type_name[2];
 
 	*store = NULL;
 
-	if (1 /* less change patch to patch */) {
+	/* Detect old-style table line with type as second arg. */
+	if (!isdigit(*argv[1])) {
 		if (argc < 3) {
 			ti->error = "Insufficient exception store arguments";
 			return -EINVAL;
@@ -616,10 +621,29 @@ static int create_exception_store(struct dm_target *ti, unsigned argc,
 		return dm_exception_store_create(old_type_name, ti, 2,
 						 tmp_argv, store);
 	}
+
+	if (sscanf(argv[1], "%u", &param_count) != 1) {
+		ti->error = "Invalid exception store argument count";
+		return -EINVAL;
+	}
+
+	*args_used = 2 + param_count;
+
+	if (argc < *args_used) {
+		ti->error = "Insufficient exception store arguments";
+		return -EINVAL;
+	}
+
+	return dm_exception_store_create(argv[0], ti, param_count,
+					 argv + 2, store);
 }
 
 /*
- * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
+ * Construct a snapshot mapping.  Possible mapping tables include:
+ *     <origin_dev> <exception store args> <feature args>
+ * See 'create_exception_store' for format of <exception store args>.
+ *
+ * Returns: 0 on success, -XXX on error
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -630,10 +654,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct dm_exception_store *store;
 	unsigned args_used;
 
-	if (argc != 4) {
-		ti->error = "requires exactly 4 arguments";
-		r = -EINVAL;
-		goto bad_args;
+	if (argc < 4) {
+		ti->error = "too few arguments";
+		return -EINVAL;
 	}
 
 	origin_path = argv[0];
@@ -755,7 +778,6 @@ bad_origin:
 bad_snap:
 	dm_exception_store_destroy(store);
 
-bad_args:
 	return r;
 }
 
-- 
1.6.2.5
