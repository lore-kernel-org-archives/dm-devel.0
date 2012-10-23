From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] dm-snap: use per request data
Date: Mon, 22 Oct 2012 21:02:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210222102210.9956@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210222059170.9956@file.rdu.redhat.com>
	<Pine.LNX.4.64.1210222101360.9956@file.rdu.redhat.com>
	<Pine.LNX.4.64.1210222101580.9956@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1210222101580.9956@file.rdu.redhat.com>
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

dm-snap: use per request data

Remove tracked_chunk_pool and use per_request_data instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

Index: linux-3.6.2-fast/drivers/md/dm-snap.c
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm-snap.c	2012-10-17 00:43:22.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm-snap.c	2012-10-17 00:49:27.000000000 +0200
@@ -79,7 +79,6 @@ struct dm_snapshot {
 
 	/* Chunks with outstanding reads */
 	spinlock_t tracked_chunk_lock;
-	mempool_t *tracked_chunk_pool;
 	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
 
 	/* The on disk metadata handler */
@@ -194,13 +193,11 @@ struct dm_snap_tracked_chunk {
 	chunk_t chunk;
 };
 
-static struct kmem_cache *tracked_chunk_cache;
-
 static struct dm_snap_tracked_chunk *track_chunk(struct dm_snapshot *s,
+						 struct bio *bio,
 						 chunk_t chunk)
 {
-	struct dm_snap_tracked_chunk *c = mempool_alloc(s->tracked_chunk_pool,
-							GFP_NOIO);
+	struct dm_snap_tracked_chunk *c = dm_bio_get_per_request_data(bio, sizeof(struct dm_snap_tracked_chunk));
 
 	c->chunk = chunk;
 
@@ -220,8 +217,6 @@ static void stop_tracking_chunk(struct d
 	spin_lock_irqsave(&s->tracked_chunk_lock, flags);
 	hlist_del(&c->node);
 	spin_unlock_irqrestore(&s->tracked_chunk_lock, flags);
-
-	mempool_free(c, s->tracked_chunk_pool);
 }
 
 static int __chunk_is_tracked(struct dm_snapshot *s, chunk_t chunk)
@@ -1122,14 +1117,6 @@ static int snapshot_ctr(struct dm_target
 		goto bad_pending_pool;
 	}
 
-	s->tracked_chunk_pool = mempool_create_slab_pool(MIN_IOS,
-							 tracked_chunk_cache);
-	if (!s->tracked_chunk_pool) {
-		ti->error = "Could not allocate tracked_chunk mempool for "
-			    "tracking reads";
-		goto bad_tracked_chunk_pool;
-	}
-
 	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
 		INIT_HLIST_HEAD(&s->tracked_chunk_hash[i]);
 
@@ -1137,6 +1124,7 @@ static int snapshot_ctr(struct dm_target
 
 	ti->private = s;
 	ti->num_flush_requests = num_flush_requests;
+	ti->per_request_data = sizeof(struct dm_snap_tracked_chunk);
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
@@ -1185,9 +1173,6 @@ bad_read_metadata:
 	unregister_snapshot(s);
 
 bad_load_and_register:
-	mempool_destroy(s->tracked_chunk_pool);
-
-bad_tracked_chunk_pool:
 	mempool_destroy(s->pending_pool);
 
 bad_pending_pool:
@@ -1292,8 +1277,6 @@ static void snapshot_dtr(struct dm_targe
 		BUG_ON(!hlist_empty(&s->tracked_chunk_hash[i]));
 #endif
 
-	mempool_destroy(s->tracked_chunk_pool);
-
 	__free_exceptions(s);
 
 	mempool_destroy(s->pending_pool);
@@ -1672,7 +1655,7 @@ static int snapshot_map(struct dm_target
 		}
 	} else {
 		bio->bi_bdev = s->origin->bdev;
-		map_context->ptr = track_chunk(s, chunk);
+		map_context->ptr = track_chunk(s, bio, chunk);
 	}
 
 out_unlock:
@@ -1735,7 +1718,7 @@ static int snapshot_merge_map(struct dm_
 		remap_exception(s, e, bio, chunk);
 
 		if (bio_rw(bio) == WRITE)
-			map_context->ptr = track_chunk(s, chunk);
+			map_context->ptr = track_chunk(s, bio, chunk);
 		goto out_unlock;
 	}
 
@@ -2283,17 +2266,8 @@ static int __init dm_snapshot_init(void)
 		goto bad_pending_cache;
 	}
 
-	tracked_chunk_cache = KMEM_CACHE(dm_snap_tracked_chunk, 0);
-	if (!tracked_chunk_cache) {
-		DMERR("Couldn't create cache to track chunks in use.");
-		r = -ENOMEM;
-		goto bad_tracked_chunk_cache;
-	}
-
 	return 0;
 
-bad_tracked_chunk_cache:
-	kmem_cache_destroy(pending_cache);
 bad_pending_cache:
 	kmem_cache_destroy(exception_cache);
 bad_exception_cache:
@@ -2319,7 +2293,6 @@ static void __exit dm_snapshot_exit(void
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
 	kmem_cache_destroy(exception_cache);
-	kmem_cache_destroy(tracked_chunk_cache);
 
 	dm_exception_store_exit();
 }
