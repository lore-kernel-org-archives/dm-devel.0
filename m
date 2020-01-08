From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: SB remove seq_count
Date: Wed, 8 Jan 2020 12:04:46 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001081202001.7856@file01.intranet.prod.int.rdu2.redhat.com>
References: <598c7c64-9b11-3407-2060-8d43b1ef1241@petasan.org>
	<d76f7245-034c-f225-00fe-f33c5e9abf1a@petasan.org>
	<alpine.LRH.2.02.2001021144450.18253@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2001021144450.18253@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Maged Mokhtar <mmokhtar@petasan.org>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

BTW. I would be interested if this patch improves performance for you. 
Could you test it?

(you also need my previous patch posted here 
https://www.redhat.com/archives/dm-devel/2020-January/msg00027.html )

Mikulas




dm-writecache: use REQ_FUA when writing the superblock

When writing the superblock, it may be better to submit just one I/O with
the FUA bit set instead of two I/Os.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-01-08 17:56:41.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-01-08 17:56:49.000000000 +0100
@@ -448,7 +448,7 @@ static void writecache_wait_for_ios(stru
 		   !atomic_read(&wc->bio_in_progress[direction]));
 }
 
-static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
+static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios, bool use_fua)
 {
 	struct dm_io_region region;
 	struct dm_io_request req;
@@ -479,7 +479,7 @@ static void ssd_commit_flushed(struct dm
 		region.sector += wc->start_sector;
 		atomic_inc(&endio.count);
 		req.bi_op = REQ_OP_WRITE;
-		req.bi_op_flags = REQ_SYNC;
+		req.bi_op_flags = REQ_SYNC | (use_fua ? REQ_FUA : 0);
 		req.mem.type = DM_IO_VMA;
 		req.mem.ptr.vma = (char *)wc->memory_map + (size_t)i * BITMAP_GRANULARITY;
 		req.client = wc->dm_io;
@@ -497,17 +497,18 @@ static void ssd_commit_flushed(struct dm
 	if (wait_for_ios)
 		writecache_wait_for_ios(wc, WRITE);
 
-	writecache_disk_flush(wc, wc->ssd_dev);
+	if (!use_fua)
+		writecache_disk_flush(wc, wc->ssd_dev);
 
 	memset(wc->dirty_bitmap, 0, wc->dirty_bitmap_size);
 }
 
-static void writecache_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
+static void writecache_commit_flushed(struct dm_writecache *wc, bool wait_for_ios, bool use_fua)
 {
 	if (WC_MODE_PMEM(wc))
 		wmb();
 	else
-		ssd_commit_flushed(wc, wait_for_ios);
+		ssd_commit_flushed(wc, wait_for_ios, use_fua);
 }
 
 static void writecache_disk_flush(struct dm_writecache *wc, struct dm_dev *dev)
@@ -727,12 +728,12 @@ static void writecache_flush(struct dm_w
 		e = e2;
 		cond_resched();
 	}
-	writecache_commit_flushed(wc, true);
+	writecache_commit_flushed(wc, true, false);
 
 	wc->seq_count++;
 	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
 	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
-	writecache_commit_flushed(wc, false);
+	writecache_commit_flushed(wc, false, true);
 
 	wc->overwrote_committed = false;
 
@@ -756,7 +757,7 @@ static void writecache_flush(struct dm_w
 	}
 
 	if (need_flush_after_free)
-		writecache_commit_flushed(wc, false);
+		writecache_commit_flushed(wc, false, false);
 }
 
 static void writecache_flush_work(struct work_struct *work)
@@ -809,7 +810,7 @@ static void writecache_discard(struct dm
 	}
 
 	if (discarded_something)
-		writecache_commit_flushed(wc, false);
+		writecache_commit_flushed(wc, false, false);
 }
 
 static bool writecache_wait_for_writeback(struct dm_writecache *wc)
@@ -958,7 +959,7 @@ erase_this:
 
 	if (need_flush) {
 		writecache_flush_all_metadata(wc);
-		writecache_commit_flushed(wc, false);
+		writecache_commit_flushed(wc, false, false);
 	}
 
 	wc_unlock(wc);
@@ -1342,7 +1343,7 @@ static void __writecache_endio_pmem(stru
 			wc->writeback_size--;
 			n_walked++;
 			if (unlikely(n_walked >= ENDIO_LATENCY)) {
-				writecache_commit_flushed(wc, false);
+				writecache_commit_flushed(wc, false, false);
 				wc_unlock(wc);
 				wc_lock(wc);
 				n_walked = 0;
@@ -1423,7 +1424,7 @@ pop_from_list:
 			writecache_wait_for_ios(wc, READ);
 		}
 
-		writecache_commit_flushed(wc, false);
+		writecache_commit_flushed(wc, false, false);
 
 		wc_unlock(wc);
 	}
@@ -1766,10 +1767,10 @@ static int init_memory(struct dm_writeca
 		write_original_sector_seq_count(wc, &wc->entries[b], -1, -1);
 
 	writecache_flush_all_metadata(wc);
-	writecache_commit_flushed(wc, false);
+	writecache_commit_flushed(wc, false, false);
 	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
 	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
-	writecache_commit_flushed(wc, false);
+	writecache_commit_flushed(wc, false, false);
 
 	return 0;
 }
