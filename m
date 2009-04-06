From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 33] DM Snapshot: shot new ctr table format
Date: Mon, 6 Apr 2009 16:32:46 -0500
Message-ID: <200904062132.n36LWkDk019844@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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

Patch name: dm-snapshot-new-ctr-table-format.patch

From: Jonathan Brassow <jbrassow@redhat.com>

Introduce the new constructor table formats for snapshots
and exception stores.  This allows for new exception store
types and allows for easy addition of future features to
snapshots.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

---
 drivers/md/dm-snap-persistent.c |    9 ++++++--
 drivers/md/dm-snap-transient.c  |    9 ++++++--
 drivers/md/dm-snap.c            |   41 +++++++++++++++++++++++++++++++++-------
 3 files changed, 48 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -708,8 +708,13 @@ static unsigned persistent_status(struct
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
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -91,8 +91,13 @@ static unsigned transient_status(struct 
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
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -580,7 +580,10 @@ static int init_hash_tables(struct dm_sn
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
@@ -588,12 +591,14 @@ static int create_exception_store(struct
 				  char **argv, unsigned *args_used,
 				  struct dm_exception_store **store)
 {
+	unsigned param_count;
 	char *tmp_argv[2];
 	char buf[8];
 
 	*store = NULL;
 
-	if (1 /* less change patch to patch */) {
+	/* Detect old-style table line with type as second arg. */
+	if (!isdigit(*argv[1])) {
 		if (argc < 3) {
 			ti->error = "Insufficient exception store arguments";
 			return -EINVAL;
@@ -608,10 +613,34 @@ static int create_exception_store(struct
 
 		return dm_exception_store_create(buf, ti, 2, tmp_argv, store);
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
+ * snapshot_ctr
+ * @ti
+ * @argc
+ * @argv
+ *
+ * Construct a snapshot mapping.  Possible mapping tables include:
+ *     <origin_dev> <exception store args> <feature args>
+ * See 'create_exception_store' for format of <exception store args>.
+ *
+ * Returns: 0 on success, -XXX on error
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -622,10 +651,9 @@ static int snapshot_ctr(struct dm_target
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
@@ -741,7 +769,6 @@ bad_origin:
 bad_snap:
 	dm_exception_store_destroy(store);
 
-bad_args:
 	return r;
 }
 
