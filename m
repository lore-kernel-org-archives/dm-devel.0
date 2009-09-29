From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 02/18] dm-exception-store-generalize-table-args
Date: Tue, 29 Sep 2009 18:53:27 -0400
Message-ID: <1254264823-11538-3-git-send-email-snitzer@redhat.com>
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

This patch is part of the work to generalize the dm-snapshot/
exception store API - necessary for future exception store
implementations.

This patch reworks 'dm_exception_store_create' arguments to make way for
cleaner interface when new constructor table format is introduced.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.c |   36 +++++++++++++++---------------
 drivers/md/dm-exception-store.h |    4 +-
 drivers/md/dm-snap.c            |   47 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 61 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 8f49f27..674b49b 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -187,16 +187,15 @@ int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
 	return 0;
 }
 
-int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
-			      unsigned *args_used,
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      int argc, char **argv,
 			      struct dm_exception_store **store)
 {
 	int r = 0;
 	struct dm_exception_store_type *type = NULL;
 	struct dm_exception_store *tmp_store;
-	char persistent;
 
-	if (argc < 3) {
+	if (argc < 2) {
 		ti->error = "Insufficient exception store arguments";
 		return -EINVAL;
 	}
@@ -207,16 +206,7 @@ int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 		return -ENOMEM;
 	}
 
-	persistent = toupper(*argv[1]);
-	if (persistent == 'P')
-		type = get_type("P");
-	else if (persistent == 'N')
-		type = get_type("N");
-	else {
-		ti->error = "Persistent flag is not P or N";
-		return -EINVAL;
-	}
-
+	type = get_type(type_name);
 	if (!type) {
 		ti->error = "Exception store type not recognised";
 		r = -EINVAL;
@@ -226,6 +216,12 @@ int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 	tmp_store->type = type;
 	tmp_store->ti = ti;
 
+	/*
+	 * COW-dev and chunk_size are common to all types of
+	 * exception stores and are stored directly in the
+	 * dm_exception_store and not passed on to the
+	 * constructor for the dm_exception_store_type
+	 */
 	r = dm_get_device(ti, argv[0], 0, 0,
 			  FMODE_READ | FMODE_WRITE, &tmp_store->cow);
 	if (r) {
@@ -233,17 +229,21 @@ int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
 		goto bad_cow;
 	}
 
-	r = set_chunk_size(tmp_store, argv[2], &ti->error);
-	if (r)
+	r = set_chunk_size(tmp_store, argv[1], &ti->error);
+	if (r) {
+		ti->error = "Unable to set chunk size";
 		goto bad_cow;
+	}
+
+	argc -= 2;
+	argv += 2;
 
-	r = type->ctr(tmp_store, 0, NULL);
+	r = type->ctr(tmp_store, argc, argv);
 	if (r) {
 		ti->error = "Exception store type constructor failed";
 		goto bad_ctr;
 	}
 
-	*args_used = 3;
 	*store = tmp_store;
 	return 0;
 
diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index 3e8fa02..2110e3b 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -172,8 +172,8 @@ int dm_exception_store_set_chunk_size(struct dm_exception_store *store,
 				      unsigned long chunk_size_ulong,
 				      char **error);
 
-int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
-			      unsigned *args_used,
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      int argc, char **argv,
 			      struct dm_exception_store **store);
 void dm_exception_store_destroy(struct dm_exception_store *store);
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3734289..109fbea 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/ctype.h>
 #include <linux/device-mapper.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
@@ -581,6 +582,43 @@ static int init_hash_tables(struct dm_snapshot *s)
 }
 
 /*
+ * create_exception_store
+ * @args_used: returned value enables snapshot_ctr 'feature args' processing
+ * @store: contains newly allocated dm_exception_store
+ *
+ * Possible formats for argv::
+ *     <COW-dev> p/n <chunk-size>
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int create_exception_store(struct dm_target *ti, unsigned argc,
+				  char **argv, unsigned *args_used,
+				  struct dm_exception_store **store)
+{
+	char *tmp_argv[2];
+	char old_type_name[2];
+
+	*store = NULL;
+
+	if (1 /* less change patch to patch */) {
+		if (argc < 3) {
+			ti->error = "Insufficient exception store arguments";
+			return -EINVAL;
+		}
+
+		tmp_argv[0] = argv[0];  /* COW dev */
+		tmp_argv[1] = argv[2];  /* chunk size */
+
+		*args_used = 3;
+		old_type_name[0] = toupper(*argv[1]);
+		old_type_name[1] = '\0';
+
+		return dm_exception_store_create(old_type_name, ti, 2,
+						 tmp_argv, store);
+	}
+}
+
+/*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
@@ -602,12 +640,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv++;
 	argc--;
 
-	r = dm_exception_store_create(ti, argc, argv, &args_used, &store);
-	if (r) {
-		ti->error = "Couldn't create exception store";
-		r = -EINVAL;
-		goto bad_args;
-	}
+	r = create_exception_store(ti, argc, argv, &args_used, &store);
+	if (r)
+		return r;
 
 	argv += args_used;
 	argc -= args_used;
-- 
1.6.2.5
