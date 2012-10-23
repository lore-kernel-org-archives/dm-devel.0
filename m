From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] dm: introduce per request data
Date: Mon, 22 Oct 2012 21:01:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210222059170.9956@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm: introduce per request data

Introduce a field per_request_data in struct dm_target.

Targets can set this field in the constructor. If a target sets this
field to non-zero value, "per_request_data" bytes of auxliliary data is
allocated for each bio submitted to the target. These data can be used
for any purpose by the target.

Per-request data is accessed with dm_bio_get_per_request_data. The
argument data_size must be the same as the value per_request_data in
dm_target.

If the target has a pointer to per request data, it can get a pointer to
the bio with dm_per_request_data_get_bio function (data_size must be the
same ast the value passed to dm_bio_get_per_request_data).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c         |   12 +++++++++++-
 drivers/md/dm.c               |   33 +++++++++++++++------------------
 drivers/md/dm.h               |    2 +-
 include/linux/device-mapper.h |   30 ++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 20 deletions(-)

Index: linux-3.6.2-fast/drivers/md/dm.c
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm.c	2012-10-16 21:20:04.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm.c	2012-10-16 21:20:04.000000000 +0200
@@ -63,18 +63,6 @@ struct dm_io {
 };
 
 /*
- * For bio-based dm.
- * One of these is allocated per target within a bio.  Hopefully
- * this will be simplified out one day.
- */
-struct dm_target_io {
-	struct dm_io *io;
-	struct dm_target *ti;
-	union map_info info;
-	struct bio clone;
-};
-
-/*
  * For request-based dm.
  * One of these is allocated per request.
  */
@@ -1997,13 +1985,20 @@ static void free_dev(struct mapped_devic
 
 static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
-	struct dm_md_mempools *p;
+	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
 
-	if (md->io_pool && (md->tio_pool || dm_table_get_type(t) == DM_TYPE_BIO_BASED) && md->bs)
-		/* the md already has necessary mempools */
+	if (md->io_pool && (md->tio_pool || dm_table_get_type(t) == DM_TYPE_BIO_BASED) && md->bs) {
+		/*
+		 * The md already has necessary mempools. Reload just the
+		 * bioset because front_pad may have changed because
+		 * a different table was loaded.
+		 */
+		bioset_free(md->bs);
+		md->bs = p->bs;
+		p->bs = NULL;
 		goto out;
+	}
 
-	p = dm_table_get_md_mempools(t);
 	BUG_ON(!p || md->io_pool || md->tio_pool || md->bs);
 
 	md->io_pool = p->io_pool;
@@ -2753,7 +2748,7 @@ int dm_noflush_suspending(struct dm_targ
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, unsigned per_request_data)
 {
 	struct dm_md_mempools *pools = kmalloc(sizeof(*pools), GFP_KERNEL);
 	unsigned int pool_size = (type == DM_TYPE_BIO_BASED) ?
@@ -2762,6 +2757,8 @@ struct dm_md_mempools *dm_alloc_md_mempo
 	if (!pools)
 		return NULL;
 
+	per_request_data = roundup(per_request_data, __alignof__(struct dm_target_io));
+
 	pools->io_pool = (type == DM_TYPE_BIO_BASED) ?
 			 mempool_create_slab_pool(pool_size, _io_cache) :
 			 mempool_create_slab_pool(pool_size, _rq_bio_info_cache);
@@ -2776,7 +2773,7 @@ struct dm_md_mempools *dm_alloc_md_mempo
 	}
 
 	pools->bs = bioset_create(pool_size, (type == DM_TYPE_BIO_BASED) ?
-		offsetof(struct dm_target_io, clone) : 0);
+		per_request_data + offsetof(struct dm_target_io, clone) : 0);
 	if (!pools->bs)
 		goto free_tio_pool_and_out;
 
Index: linux-3.6.2-fast/drivers/md/dm-table.c
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm-table.c	2012-10-16 21:20:01.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm-table.c	2012-10-16 23:55:19.000000000 +0200
@@ -932,13 +932,23 @@ bool dm_table_request_based(struct dm_ta
 int dm_table_alloc_md_mempools(struct dm_table *t)
 {
 	unsigned type = dm_table_get_type(t);
+	unsigned per_request_data = 0;
 
 	if (unlikely(type == DM_TYPE_NONE)) {
 		DMWARN("no table type is set, can't allocate mempools");
 		return -EINVAL;
 	}
 
-	t->mempools = dm_alloc_md_mempools(type, t->integrity_supported);
+	if (type == DM_TYPE_BIO_BASED) {
+		unsigned i;
+		for (i = 0; i < t->num_targets; i++) {
+			struct dm_target *tgt = t->targets + i;
+			if (tgt->per_request_data > per_request_data)
+				per_request_data = tgt->per_request_data;
+		}
+	}
+
+	t->mempools = dm_alloc_md_mempools(type, t->integrity_supported, per_request_data);
 	if (!t->mempools)
 		return -ENOMEM;
 
Index: linux-3.6.2-fast/drivers/md/dm.h
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm.h	2012-10-16 21:13:41.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm.h	2012-10-16 21:20:04.000000000 +0200
@@ -159,7 +159,7 @@ void dm_kcopyd_exit(void);
 /*
  * Mempool operations
  */
-struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity);
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, unsigned per_request_data);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
 #endif
Index: linux-3.6.2-fast/include/linux/device-mapper.h
===================================================================
--- linux-3.6.2-fast.orig/include/linux/device-mapper.h	2012-10-16 21:20:01.000000000 +0200
+++ linux-3.6.2-fast/include/linux/device-mapper.h	2012-10-17 00:33:39.000000000 +0200
@@ -205,6 +205,12 @@ struct dm_target {
 	 */
 	unsigned num_discard_requests;
 
+	/*
+	 * The size of data allocated for every bio sent to the target.
+	 * The data is accessible with function dm_bio_get_per_request_data.
+	 */
+	unsigned per_request_data;
+
 	/* target specific data */
 	void *private;
 
@@ -241,6 +247,30 @@ struct dm_target_callbacks {
 	int (*congested_fn) (struct dm_target_callbacks *, int);
 };
 
+/*
+ * For bio-based dm.
+ * One of these is allocated per target within a bio.
+ * This structure shouldn't be touched by target drivers, it is here
+ * so that we can inline dm_bio_get_per_request_data and
+ * dm_per_request_data_get_bio.
+ */
+struct dm_target_io {
+	struct dm_io *io;
+	struct dm_target *ti;
+	union map_info info;
+	struct bio clone;
+};
+
+static inline void *dm_bio_get_per_request_data(struct bio *bio, size_t data_size)
+{
+	return (char *)bio - offsetof(struct dm_target_io, clone) - data_size;
+}
+
+static inline struct bio *dm_per_request_data_get_bio(void *data, size_t data_size)
+{
+	return (struct bio *)((char *)data + data_size + offsetof(struct dm_target_io, clone));
+}
+
 int dm_register_target(struct target_type *t);
 void dm_unregister_target(struct target_type *t);
 
