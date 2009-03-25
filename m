From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 33] DM Exception Store: generalize table args
Date: Wed, 25 Mar 2009 16:33:42 -0500
Message-ID: <200903252133.n2PLXgCR020596@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-generalize-table-args.patch

From: Jonthan Brassow <jbrassow@redhat.com>

Rework 'dm_exception_store_create' arguments to make way for
cleaner interface when new constructor table format is
introduced.

[FIXME better /* comment */, don't use bad0, write full patch description, why buf[8]? ]
Signed-off-by: Jonthan Brassow <jbrassow@redhat.com>

---
 drivers/md/dm-exception-store.c |   33 +++++++++++++-----------
 drivers/md/dm-exception-store.h |    4 +--
 drivers/md/dm-snap.c            |   53 ++++++++++++++++++++++++++++++++++------
 3 files changed, 66 insertions(+), 24 deletions(-)

Index: linux-2.6.29/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.29.orig/drivers/md/dm-exception-store.c
+++ linux-2.6.29/drivers/md/dm-exception-store.c
@@ -190,16 +190,15 @@ static int set_chunk_size(struct dm_exce
 	return 0;
 }
 
-int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
-			      unsigned *args_used,
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      int argc, char **argv,
 			      struct dm_exception_store **store)
 {
 	int r = 0;
 	struct dm_exception_store_type *type;
 	struct dm_exception_store *tmp_store;
-	char persistent;
 
-	if (argc < 3) {
+	if (argc < 2) {
 		ti->error = "Insufficient exception store arguments";
 		return -EINVAL;
 	}
@@ -210,13 +209,7 @@ int dm_exception_store_create(struct dm_
 		return -ENOMEM;
 	}
 
-	persistent = toupper(*argv[1]);
-	if (persistent != 'P' && persistent != 'N') {
-		ti->error = "Persistent flag is not P or N";
-		return -EINVAL;
-	}
-
-	type = get_type(argv[1]);
+	type = get_type(type_name);
 	if (!type) {
 		ti->error = "Exception store type not recognised";
 		r = -EINVAL;
@@ -226,6 +219,12 @@ int dm_exception_store_create(struct dm_
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
@@ -233,17 +232,21 @@ int dm_exception_store_create(struct dm_
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
 
Index: linux-2.6.29/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.29.orig/drivers/md/dm-exception-store.h
+++ linux-2.6.29/drivers/md/dm-exception-store.h
@@ -168,8 +168,8 @@ static inline chunk_t sector_to_chunk(st
 int dm_exception_store_type_register(struct dm_exception_store_type *type);
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
-int dm_exception_store_create(struct dm_target *ti, int argc, char **argv,
-			      unsigned *args_used,
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      int argc, char **argv,
 			      struct dm_exception_store **store);
 void dm_exception_store_destroy(struct dm_exception_store *store);
 
Index: linux-2.6.29/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.29.orig/drivers/md/dm-snap.c
+++ linux-2.6.29/drivers/md/dm-snap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/ctype.h>
 #include <linux/device-mapper.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
@@ -571,6 +572,45 @@ static int init_hash_tables(struct dm_sn
 }
 
 /*
+ * create_exception_store
+ * @ti
+ * @argc
+ * @argv
+ * @args_used
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
+	char buf[8];
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
+		buf[0] = toupper(*argv[1]);
+		buf[1] = '\0';
+
+		return dm_exception_store_create(buf, ti, 2, tmp_argv, store);
+	}
+}
+
+/*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
@@ -592,12 +632,9 @@ static int snapshot_ctr(struct dm_target
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
@@ -1436,7 +1473,7 @@ static int __init dm_snapshot_init(void)
 	r = dm_register_target(&snapshot_target);
 	if (r) {
 		DMERR("snapshot target register failed %d", r);
-		return r;
+		goto bad0;
 	}
 
 	r = dm_register_target(&origin_target);
@@ -1493,6 +1530,8 @@ bad2:
 	dm_unregister_target(&origin_target);
 bad1:
 	dm_unregister_target(&snapshot_target);
+bad0:
+	dm_exception_store_exit();
 	return r;
 }
 
