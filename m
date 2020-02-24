From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/7] dm-writecache: implement gradual cleanup
Date: Mon, 24 Feb 2020 10:20:33 +0100
Message-ID: <20200224092053.135853080@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-writecache-gradual-cleanup.patch
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Alasdair Kergon <agk@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

This patch implements gradual cleanup for dm-writecache - if the block is
stored in the cache for too long, it will be written to the underlying
device and cleaned up.

The patch adds a new option "max_age" that specified the maximum age of a
block in milliseconds.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-02-23 18:16:22.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-02-23 18:16:22.000000000 +0100
@@ -26,6 +26,7 @@
 #define AUTOCOMMIT_BLOCKS_SSD		65536
 #define AUTOCOMMIT_BLOCKS_PMEM		64
 #define AUTOCOMMIT_MSEC			1000
+#define MAX_AGE_DIV			16
 
 #define BITMAP_GRANULARITY	65536
 #if BITMAP_GRANULARITY < PAGE_SIZE
@@ -88,6 +89,7 @@ struct wc_entry {
 		:47
 #endif
 	;
+	unsigned long age;
 #ifdef DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 	uint64_t original_sector;
 	uint64_t seq_count;
@@ -119,6 +121,7 @@ struct dm_writecache {
 	size_t writeback_size;
 	size_t freelist_high_watermark;
 	size_t freelist_low_watermark;
+	unsigned long max_age;
 
 	unsigned uncommitted_blocks;
 	unsigned autocommit_blocks;
@@ -130,6 +133,8 @@ struct dm_writecache {
 	struct timer_list autocommit_timer;
 	struct wait_queue_head freelist_wait;
 
+	struct timer_list max_age_timer;
+
 	atomic_t bio_in_progress[2];
 	struct wait_queue_head bio_in_progress_wait[2];
 
@@ -597,6 +602,7 @@ static void writecache_insert_entry(stru
 	rb_link_node(&ins->rb_node, parent, node);
 	rb_insert_color(&ins->rb_node, &wc->tree);
 	list_add(&ins->lru, &wc->lru);
+	ins->age = jiffies;
 }
 
 static void writecache_unlink(struct dm_writecache *wc, struct wc_entry *e)
@@ -632,6 +638,15 @@ static inline void writecache_verify_wat
 		queue_work(wc->writeback_wq, &wc->writeback_work);
 }
 
+static void writecache_max_age_timer(struct timer_list *t)
+{
+	struct dm_writecache *wc = from_timer(wc, t, max_age_timer);
+	if (!dm_suspended(wc->ti) && !writecache_has_error(wc)) {
+		queue_work(wc->writeback_wq, &wc->writeback_work);
+		mod_timer(&wc->max_age_timer, jiffies + wc->max_age / MAX_AGE_DIV);
+	}
+}
+
 static struct wc_entry *writecache_pop_from_freelist(struct dm_writecache *wc, sector_t expected_sector)
 {
 	struct wc_entry *e;
@@ -838,6 +853,7 @@ static void writecache_suspend(struct dm
 	bool flush_on_suspend;
 
 	del_timer_sync(&wc->autocommit_timer);
+	del_timer_sync(&wc->max_age_timer);
 
 	wc_lock(wc);
 	writecache_flush(wc);
@@ -974,6 +990,9 @@ erase_this:
 
 	writecache_verify_watermark(wc);
 
+	if (wc->max_age != -1UL)
+		mod_timer(&wc->max_age_timer, jiffies + wc->max_age / MAX_AGE_DIV);
+
 	wc_unlock(wc);
 }
 
@@ -1661,7 +1680,8 @@ restart:
 	wbl.size = 0;
 	while (!list_empty(&wc->lru) &&
 	       (wc->writeback_all ||
-		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark)) {
+		wc->freelist_size + wc->writeback_size <= wc->freelist_low_watermark ||
+		jiffies - container_of(wc->lru.prev, struct wc_entry, lru)->age >= wc->max_age - wc->max_age / MAX_AGE_DIV)) {
 
 		n_walked++;
 		if (unlikely(n_walked > WRITEBACK_LATENCY) &&
@@ -1924,9 +1944,11 @@ static int writecache_ctr(struct dm_targ
 	wc->ti = ti;
 
 	mutex_init(&wc->lock);
+	wc->max_age = -1UL;
 	writecache_poison_lists(wc);
 	init_waitqueue_head(&wc->freelist_wait);
 	timer_setup(&wc->autocommit_timer, writecache_autocommit_timer, 0);
+	timer_setup(&wc->max_age_timer, writecache_max_age_timer, 0);
 
 	for (i = 0; i < 2; i++) {
 		atomic_set(&wc->bio_in_progress[i], 0);
@@ -2100,6 +2122,14 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
 			wc->autocommit_time_set = true;
+		} else if (!strcasecmp(string, "max_age") && opt_params >= 1) {
+			unsigned max_age_msecs;
+			string = dm_shift_arg(&as), opt_params--;
+			if (sscanf(string, "%u%c", &max_age_msecs, &dummy) != 1)
+				goto invalid_optional;
+			if (max_age_msecs > 86400000)
+				goto invalid_optional;
+			wc->max_age = msecs_to_jiffies(max_age_msecs);
 		} else if (!strcasecmp(string, "cleaner")) {
 			wc->cleaner = true;
 		} else if (!strcasecmp(string, "fua")) {
@@ -2361,6 +2391,8 @@ static void writecache_status(struct dm_
 			DMEMIT(" autocommit_blocks %u", wc->autocommit_blocks);
 		if (wc->autocommit_time_set)
 			DMEMIT(" autocommit_time %u", jiffies_to_msecs(wc->autocommit_jiffies));
+		if (wc->max_age != -1UL)
+			DMEMIT(" max_age %u", jiffies_to_msecs(wc->max_age));
 		if (wc->cleaner)
 			DMEMIT(" cleaner");
 		if (wc->writeback_fua_set)
