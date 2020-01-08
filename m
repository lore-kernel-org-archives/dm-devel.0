From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: fix incorrect flush sequence when
 doing commit
Date: Wed, 8 Jan 2020 10:46:05 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001081043420.682@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, Maged Mokhtar <mmokhtar@petasan.org>
List-Id: dm-devel.ids

When commiting state, the function writecache_flush does the following:
1. write metadata (writecache_commit_flushed)
2. flush disk cache (writecache_commit_flushed)
3. wait for data writes to complete (writecache_wait_for_ios)
4. increase superblock seq_count
5. write the superblock
6. flush disk cache

It may happen that at step 3, when we wait for some write to finish, the 
disk may report the write as finished, but the write only hit the disk 
cache and it is not yet stored in persistent storage. At step 5 we write 
the superblock - it may happen that the superblock is written before the 
write that we waited for in step 3. If the machine crashes, it may result 
in incorect data being returned after reboot.

In order to fix the bug, we must swap steps 2 and 3 in the above sequence,
so that we first wait for writes to complete and then flush the disk
cache.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 4.18+
Fixes: 48debafe4f2f ("dm: add writecache target")

---
 drivers/md/dm-writecache.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-01-08 15:14:51.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-01-08 16:15:43.000000000 +0100
@@ -442,7 +442,13 @@ static void writecache_notify_io(unsigne
 		complete(&endio->c);
 }
 
-static void ssd_commit_flushed(struct dm_writecache *wc)
+static void writecache_wait_for_ios(struct dm_writecache *wc, int direction)
+{
+	wait_event(wc->bio_in_progress_wait[direction],
+		   !atomic_read(&wc->bio_in_progress[direction]));
+}
+
+static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 {
 	struct dm_io_region region;
 	struct dm_io_request req;
@@ -488,17 +494,20 @@ static void ssd_commit_flushed(struct dm
 	writecache_notify_io(0, &endio);
 	wait_for_completion_io(&endio.c);
 
+	if (wait_for_ios)
+		writecache_wait_for_ios(wc, WRITE);
+
 	writecache_disk_flush(wc, wc->ssd_dev);
 
 	memset(wc->dirty_bitmap, 0, wc->dirty_bitmap_size);
 }
 
-static void writecache_commit_flushed(struct dm_writecache *wc)
+static void writecache_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 {
 	if (WC_MODE_PMEM(wc))
 		wmb();
 	else
-		ssd_commit_flushed(wc);
+		ssd_commit_flushed(wc, wait_for_ios);
 }
 
 static void writecache_disk_flush(struct dm_writecache *wc, struct dm_dev *dev)
@@ -522,12 +531,6 @@ static void writecache_disk_flush(struct
 		writecache_error(wc, r, "error flushing metadata: %d", r);
 }
 
-static void writecache_wait_for_ios(struct dm_writecache *wc, int direction)
-{
-	wait_event(wc->bio_in_progress_wait[direction],
-		   !atomic_read(&wc->bio_in_progress[direction]));
-}
-
 #define WFE_RETURN_FOLLOWING	1
 #define WFE_LOWEST_SEQ		2
 
@@ -724,15 +727,12 @@ static void writecache_flush(struct dm_w
 		e = e2;
 		cond_resched();
 	}
-	writecache_commit_flushed(wc);
-
-	if (!WC_MODE_PMEM(wc))
-		writecache_wait_for_ios(wc, WRITE);
+	writecache_commit_flushed(wc, true);
 
 	wc->seq_count++;
 	pmem_assign(sb(wc)->seq_count, cpu_to_le64(wc->seq_count));
 	writecache_flush_region(wc, &sb(wc)->seq_count, sizeof sb(wc)->seq_count);
-	writecache_commit_flushed(wc);
+	writecache_commit_flushed(wc, false);
 
 	wc->overwrote_committed = false;
 
@@ -756,7 +756,7 @@ static void writecache_flush(struct dm_w
 	}
 
 	if (need_flush_after_free)
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 }
 
 static void writecache_flush_work(struct work_struct *work)
@@ -809,7 +809,7 @@ static void writecache_discard(struct dm
 	}
 
 	if (discarded_something)
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 }
 
 static bool writecache_wait_for_writeback(struct dm_writecache *wc)
@@ -958,7 +958,7 @@ erase_this:
 
 	if (need_flush) {
 		writecache_flush_all_metadata(wc);
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 	}
 
 	wc_unlock(wc);
@@ -1342,7 +1342,7 @@ static void __writecache_endio_pmem(stru
 			wc->writeback_size--;
 			n_walked++;
 			if (unlikely(n_walked >= ENDIO_LATENCY)) {
-				writecache_commit_flushed(wc);
+				writecache_commit_flushed(wc, false);
 				wc_unlock(wc);
 				wc_lock(wc);
 				n_walked = 0;
@@ -1423,7 +1423,7 @@ pop_from_list:
 			writecache_wait_for_ios(wc, READ);
 		}
 
-		writecache_commit_flushed(wc);
+		writecache_commit_flushed(wc, false);
 
 		wc_unlock(wc);
 	}
@@ -1766,10 +1766,10 @@ static int init_memory(struct dm_writeca
 		write_original_sector_seq_count(wc, &wc->entries[b], -1, -1);
 
 	writecache_flush_all_metadata(wc);
-	writecache_commit_flushed(wc);
+	writecache_commit_flushed(wc, false);
 	pmem_assign(sb(wc)->magic, cpu_to_le32(MEMORY_SUPERBLOCK_MAGIC));
 	writecache_flush_region(wc, &sb(wc)->magic, sizeof sb(wc)->magic);
-	writecache_commit_flushed(wc);
+	writecache_commit_flushed(wc, false);
 
 	return 0;
 }
