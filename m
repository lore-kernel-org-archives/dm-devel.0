From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: improve performance of large
 linear writes on SSDs
Date: Wed, 15 Jan 2020 04:35:22 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001150432500.10972@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When dm-writecache is used with SSD as a cache device, it would submit
separate bio for each written block. The I/Os would be merged by the disk
scheduler, but this merging degrades performance.

This patch makes dm-writecache submit larger bios - we can submit large
bio as long as there is consecutive free space on the cache device.

Benchmark (arm64 with 64k page size, using /dev/ram0 as a cache device):

fio --bs=512k --iodepth=32 --size=400M --direct=1 --filename=/dev/mapper/cache --rw=randwrite --numjobs=1 --name=test

block	old	new
size	MiB/s	MiB/s
---------------------
512	181	700
1k	347	1256
2k	644	2020
4k	1183	2759
8k	1852	3333
16k	2469	3509
32k	2974	3670
64k	3404	3810

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-01-14 16:11:09.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-01-14 21:42:44.000000000 +0100
@@ -626,7 +626,7 @@ static void writecache_add_to_freelist(s
 	wc->freelist_size++;
 }
 
-static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc)
+static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc, sector_t expected_sector)
 {
 	struct wc_entry *e;
 
@@ -635,6 +635,8 @@ static struct wc_entry *writecache_pop_f
 		if (unlikely(!wc->current_free))
 			return NULL;
 		e = wc->current_free;
+		if (expected_sector != (sector_t)-1 && unlikely(cache_sector(wc, e) != expected_sector))
+			return NULL;
 		next = rb_next(&e->rb_node);
 		rb_erase(&e->rb_node, &wc->freetree);
 		if (unlikely(!next))
@@ -644,6 +646,8 @@ static struct wc_entry *writecache_pop_f
 		if (unlikely(list_empty(&wc->freelist)))
 			return NULL;
 		e = container_of(wc->freelist.next, struct wc_entry, lru);
+		if (expected_sector != (sector_t)-1 && unlikely(cache_sector(wc, e) != expected_sector))
+			return NULL;
 		list_del(&e->lru);
 	}
 	wc->freelist_size--;
@@ -1194,7 +1198,7 @@ read_next_block:
 					goto bio_copy;
 				}
 			}
-			e = writecache_pop_from_freelist(wc);
+			e = writecache_pop_from_freelist(wc, (sector_t)-1);
 			if (unlikely(!e)) {
 				writecache_wait_on_freelist(wc);
 				continue;
@@ -1206,9 +1210,25 @@ bio_copy:
 			if (WC_MODE_PMEM(wc)) {
 				bio_copy_block(wc, bio, memory_data(wc, e));
 			} else {
-				dm_accept_partial_bio(bio, wc->block_size >> SECTOR_SHIFT);
+				unsigned bio_size = wc->block_size;
+				sector_t start_cache_sec = cache_sector(wc, e);
+				sector_t current_cache_sec = start_cache_sec + (bio_size >> SECTOR_SHIFT);
+
+				while (bio_size < bio->bi_iter.bi_size) {
+					struct wc_entry *f = writecache_pop_from_freelist(wc, current_cache_sec);
+					if (!f)
+						break;
+					write_original_sector_seq_count(wc, f, bio->bi_iter.bi_sector + (bio_size >> SECTOR_SHIFT), wc->seq_count);
+					writecache_insert_entry(wc, f);
+					wc->uncommitted_blocks++;
+					bio_size += wc->block_size;
+					current_cache_sec += wc->block_size >> SECTOR_SHIFT;
+				}
+
 				bio_set_dev(bio, wc->ssd_dev->bdev);
-				bio->bi_iter.bi_sector = cache_sector(wc, e);
+				bio->bi_iter.bi_sector = start_cache_sec;
+				dm_accept_partial_bio(bio, bio_size >> SECTOR_SHIFT);
+
 				if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 					wc->uncommitted_blocks = 0;
 					queue_work(wc->writeback_wq, &wc->flush_work);
