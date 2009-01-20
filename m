From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 12 of 12]: dm-snapshot-new-ctr-table-format.patch
Date: Tue, 20 Jan 2009 14:14:27 -0600
Message-ID: <1232482467.19993.48.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

 brassow

Introduce the new constructor table formats for snapshots
and exception stores.  This allows for new exception store
types and allows for easy addition of future features to
snapshots.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -698,8 +698,13 @@ static int persistent_status(struct dm_e
 	case STATUSTYPE_INFO:
 		break;
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s P %llu", store->cow->name,
-		       (unsigned long long)store->chunk_size);
+		if (!strcmp("P", store->type->name))
+			DMEMIT("%s P %llu", store->cow->name,
+			       (unsigned long long)store->chunk_size);
+		else
+			DMEMIT("%s 2 %s %llu", store->type->name,
+			       store->cow->name,
+			       (unsigned long long)store->chunk_size);
 	}
 
 	return sz;
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -91,8 +91,13 @@ static int transient_status(struct dm_ex
 	case STATUSTYPE_INFO:
 		break;
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s N %llu", store->cow->name,
-		       (unsigned long long)store->chunk_size);
+		if (!strcmp("N", store->type->name))
+			DMEMIT("%s N %llu", store->cow->name,
+			       (unsigned long long)store->chunk_size);
+		else
+			DMEMIT("%s 2 %s %llu", store->type->name,
+			       store->cow->name,
+			       (unsigned long long)store->chunk_size);
 	}
 
 	return sz;
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/ctype.h>
 #include <linux/device-mapper.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
@@ -579,7 +580,10 @@ static int init_hash_tables(struct dm_sn
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
@@ -587,11 +591,13 @@ static int create_exception_store(struct
                                  char **argv, unsigned *args_used,
                                  struct dm_exception_store **store)
 {
+	unsigned param_count;
 	char *tmp_argv[2];
 
 	*store = NULL;
 
-	if (1 /* less change patch to patch */) {
+	/* Detect old-style table line with type as second arg. */
+	if (!isdigit(*argv[1])) {
 		if (argc < 3) {
 			ti->error = "Insufficient exception store arguments";
 			return -EINVAL;
@@ -605,10 +611,34 @@ static int create_exception_store(struct
 		return dm_exception_store_create(toupper(*argv[1]), ti, 2,
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
@@ -619,10 +649,9 @@ static int snapshot_ctr(struct dm_target
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
@@ -737,7 +766,6 @@ bad_origin:
 bad_snap:
 	dm_exception_store_destroy(store);
 
-bad_args:
 	return r;
 }
 
