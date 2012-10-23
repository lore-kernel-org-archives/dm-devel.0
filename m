From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] dm-raid1: use per request data
Date: Mon, 22 Oct 2012 21:01:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210222101360.9956@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210222059170.9956@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1210222059170.9956@file.rdu.redhat.com>
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

dm-raid1: use per request data

Remove read_record_pool and use per_request_data instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   37 ++++---------------------------------
 1 file changed, 4 insertions(+), 33 deletions(-)

Index: linux-3.6.2-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm-raid1.c	2012-10-16 23:56:25.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm-raid1.c	2012-10-16 23:58:01.000000000 +0200
@@ -61,7 +61,6 @@ struct mirror_set {
 	struct dm_region_hash *rh;
 	struct dm_kcopyd_client *kcopyd_client;
 	struct dm_io_client *io_client;
-	mempool_t *read_record_pool;
 
 	/* recovery */
 	region_t nr_regions;
@@ -142,14 +141,11 @@ static void dispatch_bios(void *context,
 		queue_bio(ms, bio, WRITE);
 }
 
-#define MIN_READ_RECORDS 20
 struct dm_raid1_read_record {
 	struct mirror *m;
 	struct dm_bio_details details;
 };
 
-static struct kmem_cache *_dm_raid1_read_record_cache;
-
 /*
  * Every mirror should look like this one.
  */
@@ -879,19 +875,9 @@ static struct mirror_set *alloc_context(
 	atomic_set(&ms->suspend, 0);
 	atomic_set(&ms->default_mirror, DEFAULT_MIRROR);
 
-	ms->read_record_pool = mempool_create_slab_pool(MIN_READ_RECORDS,
-						_dm_raid1_read_record_cache);
-
-	if (!ms->read_record_pool) {
-		ti->error = "Error creating mirror read_record_pool";
-		kfree(ms);
-		return NULL;
-	}
-
 	ms->io_client = dm_io_client_create();
 	if (IS_ERR(ms->io_client)) {
 		ti->error = "Error creating dm_io client";
-		mempool_destroy(ms->read_record_pool);
 		kfree(ms);
  		return NULL;
 	}
@@ -903,7 +889,6 @@ static struct mirror_set *alloc_context(
 	if (IS_ERR(ms->rh)) {
 		ti->error = "Error creating dirty region hash";
 		dm_io_client_destroy(ms->io_client);
-		mempool_destroy(ms->read_record_pool);
 		kfree(ms);
 		return NULL;
 	}
@@ -919,7 +904,6 @@ static void free_context(struct mirror_s
 
 	dm_io_client_destroy(ms->io_client);
 	dm_region_hash_destroy(ms->rh);
-	mempool_destroy(ms->read_record_pool);
 	kfree(ms);
 }
 
@@ -1091,6 +1075,7 @@ static int mirror_ctr(struct dm_target *
 
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
+	ti->per_request_data = sizeof(struct dm_raid1_read_record);
 	ti->discard_zeroes_data_unsupported = true;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord",
@@ -1164,7 +1149,7 @@ static int mirror_map(struct dm_target *
 	int r, rw = bio_rw(bio);
 	struct mirror *m;
 	struct mirror_set *ms = ti->private;
-	struct dm_raid1_read_record *read_record = NULL;
+	struct dm_raid1_read_record *read_record;
 	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
 
 	if (rw == WRITE) {
@@ -1197,7 +1182,7 @@ static int mirror_map(struct dm_target *
 	if (unlikely(!m))
 		return -EIO;
 
-	read_record = mempool_alloc(ms->read_record_pool, GFP_NOIO);
+	read_record = dm_bio_get_per_request_data(bio, sizeof(struct dm_raid1_read_record));
 	dm_bio_record(&read_record->details, bio);
 	map_context->ptr = read_record;
 	read_record->m = m;
@@ -1257,7 +1242,6 @@ static int mirror_end_io(struct dm_targe
 			bd = &read_record->details;
 
 			dm_bio_restore(bd, bio);
-			mempool_free(read_record, ms->read_record_pool);
 			map_context->ptr = NULL;
 			queue_bio(ms, bio, rw);
 			return DM_ENDIO_INCOMPLETE;
@@ -1266,10 +1250,7 @@ static int mirror_end_io(struct dm_targe
 	}
 
 out:
-	if (read_record) {
-		mempool_free(read_record, ms->read_record_pool);
-		map_context->ptr = NULL;
-	}
+	map_context->ptr = NULL;
 
 	return error;
 }
@@ -1440,13 +1421,6 @@ static int __init dm_mirror_init(void)
 {
 	int r;
 
-	_dm_raid1_read_record_cache = KMEM_CACHE(dm_raid1_read_record, 0);
-	if (!_dm_raid1_read_record_cache) {
-		DMERR("Can't allocate dm_raid1_read_record cache");
-		r = -ENOMEM;
-		goto bad_cache;
-	}
-
 	r = dm_register_target(&mirror_target);
 	if (r < 0) {
 		DMERR("Failed to register mirror target");
@@ -1456,15 +1430,12 @@ static int __init dm_mirror_init(void)
 	return 0;
 
 bad_target:
-	kmem_cache_destroy(_dm_raid1_read_record_cache);
-bad_cache:
 	return r;
 }
 
 static void __exit dm_mirror_exit(void)
 {
 	dm_unregister_target(&mirror_target);
-	kmem_cache_destroy(_dm_raid1_read_record_cache);
 }
 
 /* Module hooks */
