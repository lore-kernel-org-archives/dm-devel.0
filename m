From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: convert ffs to __ffs
Date: Fri, 2 Oct 2015 11:21:24 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1510021119260.7505@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

ffs counts bit starting with 1 (for the least significant bit), __ffs
counts bits starting with 0. This patch changes various occurrences of ffs
to __ffs and removes subtraction of 1 from the result.

Note that __ffs (unlike ffs) is not defined when called with zero
argument, but it is not called with zero argument in any of these cases.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c                |   10 +++++-----
 drivers/md/dm-cache-policy-cleaner.c |    2 +-
 drivers/md/dm-cache-policy-mq.c      |    2 +-
 drivers/md/dm-cache-policy-smq.c     |    2 +-
 drivers/md/dm-exception-store.c      |    2 +-
 drivers/md/dm-region-hash.c          |    2 +-
 drivers/md/dm-snap-persistent.c      |    2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-4.3-rc3/drivers/md/dm-bufio.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-bufio.c	2015-09-30 15:43:08.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-bufio.c	2015-09-30 15:43:34.000000000 +0200
@@ -1598,11 +1598,11 @@ struct dm_bufio_client *dm_bufio_client_
 
 	c->bdev = bdev;
 	c->block_size = block_size;
-	c->sectors_per_block_bits = ffs(block_size) - 1 - SECTOR_SHIFT;
-	c->pages_per_block_bits = (ffs(block_size) - 1 >= PAGE_SHIFT) ?
-				  ffs(block_size) - 1 - PAGE_SHIFT : 0;
-	c->blocks_per_page_bits = (ffs(block_size) - 1 < PAGE_SHIFT ?
-				  PAGE_SHIFT - (ffs(block_size) - 1) : 0);
+	c->sectors_per_block_bits = __ffs(block_size) - SECTOR_SHIFT;
+	c->pages_per_block_bits = (__ffs(block_size) >= PAGE_SHIFT) ?
+				  __ffs(block_size) - PAGE_SHIFT : 0;
+	c->blocks_per_page_bits = (__ffs(block_size) < PAGE_SHIFT ?
+				  PAGE_SHIFT - __ffs(block_size) : 0);
 
 	c->aux_size = aux_size;
 	c->alloc_callback = alloc_callback;
Index: linux-4.3-rc3/drivers/md/dm-cache-policy-cleaner.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-cache-policy-cleaner.c	2015-09-30 15:43:39.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-cache-policy-cleaner.c	2015-09-30 15:43:50.000000000 +0200
@@ -83,7 +83,7 @@ static struct list_head *list_pop(struct
 static int alloc_hash(struct hash *hash, unsigned elts)
 {
 	hash->nr_buckets = next_power(elts >> 4, 16);
-	hash->hash_bits = ffs(hash->nr_buckets) - 1;
+	hash->hash_bits = __ffs(hash->nr_buckets);
 	hash->table = vzalloc(sizeof(*hash->table) * hash->nr_buckets);
 
 	return hash->table ? 0 : -ENOMEM;
Index: linux-4.3-rc3/drivers/md/dm-cache-policy-mq.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-cache-policy-mq.c	2015-09-30 15:44:05.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-cache-policy-mq.c	2015-09-30 15:44:08.000000000 +0200
@@ -1410,7 +1410,7 @@ static struct dm_cache_policy *mq_create
 	mq->generation_period = max((unsigned) from_cblock(cache_size), 1024U);
 
 	mq->nr_buckets = next_power(from_cblock(cache_size) / 2, 16);
-	mq->hash_bits = ffs(mq->nr_buckets) - 1;
+	mq->hash_bits = __ffs(mq->nr_buckets);
 	mq->table = vzalloc(sizeof(*mq->table) * mq->nr_buckets);
 	if (!mq->table)
 		goto bad_alloc_table;
Index: linux-4.3-rc3/drivers/md/dm-cache-policy-smq.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-cache-policy-smq.c	2015-09-30 15:42:27.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-cache-policy-smq.c	2015-09-30 15:42:33.000000000 +0200
@@ -566,7 +566,7 @@ static int h_init(struct hash_table *ht,
 
 	ht->es = es;
 	nr_buckets = roundup_pow_of_two(max(nr_entries / 4u, 16u));
-	ht->hash_bits = ffs(nr_buckets) - 1;
+	ht->hash_bits = __ffs(nr_buckets);
 
 	ht->buckets = vmalloc(sizeof(*ht->buckets) * nr_buckets);
 	if (!ht->buckets)
Index: linux-4.3-rc3/drivers/md/dm-exception-store.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-exception-store.c	2015-09-30 15:42:49.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-exception-store.c	2015-09-30 15:42:54.000000000 +0200
@@ -183,7 +183,7 @@ int dm_exception_store_set_chunk_size(st
 
 	store->chunk_size = chunk_size;
 	store->chunk_mask = chunk_size - 1;
-	store->chunk_shift = ffs(chunk_size) - 1;
+	store->chunk_shift = __ffs(chunk_size);
 
 	return 0;
 }
Index: linux-4.3-rc3/drivers/md/dm-region-hash.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-region-hash.c	2015-09-30 15:42:58.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-region-hash.c	2015-09-30 15:43:03.000000000 +0200
@@ -193,7 +193,7 @@ struct dm_region_hash *dm_region_hash_cr
 	rh->max_recovery = max_recovery;
 	rh->log = log;
 	rh->region_size = region_size;
-	rh->region_shift = ffs(region_size) - 1;
+	rh->region_shift = __ffs(region_size);
 	rwlock_init(&rh->hash_lock);
 	rh->mask = nr_buckets - 1;
 	rh->nr_buckets = nr_buckets;
Index: linux-4.3-rc3/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-4.3-rc3.orig/drivers/md/dm-snap-persistent.c	2015-09-30 15:43:55.000000000 +0200
+++ linux-4.3-rc3/drivers/md/dm-snap-persistent.c	2015-09-30 15:44:00.000000000 +0200
@@ -321,7 +321,7 @@ static int read_header(struct pstore *ps
 		    bdev_logical_block_size(dm_snap_cow(ps->store->snap)->
 					    bdev) >> 9);
 		ps->store->chunk_mask = ps->store->chunk_size - 1;
-		ps->store->chunk_shift = ffs(ps->store->chunk_size) - 1;
+		ps->store->chunk_shift = __ffs(ps->store->chunk_size);
 		chunk_size_supplied = 0;
 	}
 
