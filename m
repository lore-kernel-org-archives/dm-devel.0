From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/9] dm-integrity: implement fair range locks
Date: Wed, 06 Jun 2018 17:33:10 +0200
Message-ID: <20180606153433.564158625@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-fair-wait.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

dm-integrity locks a range of sectors to prevent concurrent I/O or journal
writeback. These locks were not fair - so that many small overlapping I/Os
could starve a large I/O indefinitely.

This patch makes the range locks fair. The ranges that are waiting are
added to the list "wait_list". If a new I/O overlaps some of the waiting
I/Os, it is not dispatches, but it is also added to that wait list.
Entries on the wait list are processed in first-in-first-out order, so
that an I/O can't starve indefinitely.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   67 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-06-06 15:49:01.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-06-06 17:05:42.000000000 +0200
@@ -186,6 +186,7 @@ struct dm_integrity_c {
 
 	/* these variables are locked with endio_wait.lock */
 	struct rb_root in_progress;
+	struct list_head wait_list;
 	wait_queue_head_t endio_wait;
 	struct workqueue_struct *wait_wq;
 
@@ -233,7 +234,14 @@ struct dm_integrity_c {
 struct dm_integrity_range {
 	sector_t logical_sector;
 	unsigned n_sectors;
-	struct rb_node node;
+	bool waiting;
+	union {
+		struct rb_node node;
+		struct {
+			struct task_struct *task;
+			struct list_head wait_entry;
+		};
+	};
 };
 
 struct dm_integrity_io {
@@ -867,13 +875,27 @@ static void copy_from_journal(struct dm_
 	}
 }
 
-static bool add_new_range(struct dm_integrity_c *ic, struct dm_integrity_range *new_range)
+static bool ranges_overlap(struct dm_integrity_range *range1, struct dm_integrity_range *range2)
+{
+	return range1->logical_sector < range2->logical_sector + range2->n_sectors &&
+	       range2->logical_sector + range2->n_sectors > range2->logical_sector;
+}
+
+static bool add_new_range(struct dm_integrity_c *ic, struct dm_integrity_range *new_range, bool check_waiting)
 {
 	struct rb_node **n = &ic->in_progress.rb_node;
 	struct rb_node *parent;
 
 	BUG_ON((new_range->logical_sector | new_range->n_sectors) & (unsigned)(ic->sectors_per_block - 1));
 
+	if (likely(check_waiting)) {
+		struct dm_integrity_range *range;
+		list_for_each_entry(range, &ic->wait_list, wait_entry) {
+			if (unlikely(ranges_overlap(range, new_range)))
+				return false;
+		}
+	}
+
 	parent = NULL;
 
 	while (*n) {
@@ -898,7 +920,21 @@ static bool add_new_range(struct dm_inte
 static void remove_range_unlocked(struct dm_integrity_c *ic, struct dm_integrity_range *range)
 {
 	rb_erase(&range->node, &ic->in_progress);
-	wake_up_locked(&ic->endio_wait);
+	while (unlikely(!list_empty(&ic->wait_list))) {
+		struct dm_integrity_range *last_range = list_first_entry(&ic->wait_list, struct dm_integrity_range, wait_entry);
+		struct task_struct *last_range_task;
+		if (!ranges_overlap(range, last_range))
+			break;
+		last_range_task = last_range->task;
+		list_del(&last_range->wait_entry);
+		if (!add_new_range(ic, last_range, false)) {
+			last_range->task = last_range_task;
+			list_add(&last_range->wait_entry, &ic->wait_list);
+			break;
+		}
+		last_range->waiting = false;
+		wake_up_process(last_range_task);
+	}
 }
 
 static void remove_range(struct dm_integrity_c *ic, struct dm_integrity_range *range)
@@ -910,6 +946,19 @@ static void remove_range(struct dm_integ
 	spin_unlock_irqrestore(&ic->endio_wait.lock, flags);
 }
 
+static void wait_and_add_new_range(struct dm_integrity_c *ic, struct dm_integrity_range *new_range)
+{
+	new_range->waiting = true;
+	list_add_tail(&new_range->wait_entry, &ic->wait_list);
+	new_range->task = current;
+	do {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock_irq(&ic->endio_wait.lock);
+		io_schedule();
+		spin_lock_irq(&ic->endio_wait.lock);
+	} while (unlikely(new_range->waiting));
+}
+
 static void init_journal_node(struct journal_node *node)
 {
 	RB_CLEAR_NODE(&node->node);
@@ -1658,7 +1707,7 @@ retry:
 			}
 		}
 	}
-	if (unlikely(!add_new_range(ic, &dio->range))) {
+	if (unlikely(!add_new_range(ic, &dio->range, true))) {
 		/*
 		 * We must not sleep in the request routine because it could
 		 * stall bios on current->bio_list.
@@ -1670,10 +1719,8 @@ offload_to_thread:
 			INIT_WORK(&dio->work, integrity_bio_wait);
 			queue_work(ic->wait_wq, &dio->work);
 			return;
-		} else {
-			sleep_on_endio_wait(ic);
-			goto retry;
 		}
+		wait_and_add_new_range(ic, &dio->range);
 	}
 	spin_unlock_irq(&ic->endio_wait.lock);
 
@@ -1896,8 +1943,8 @@ static void do_journal_write(struct dm_i
 			io->range.n_sectors = (k - j) << ic->sb->log2_sectors_per_block;
 
 			spin_lock_irq(&ic->endio_wait.lock);
-			while (unlikely(!add_new_range(ic, &io->range)))
-				sleep_on_endio_wait(ic);
+			if (unlikely(!add_new_range(ic, &io->range, true)))
+				wait_and_add_new_range(ic, &io->range);
 
 			if (likely(!from_replay)) {
 				struct journal_node *section_node = &ic->journal_tree[i * ic->journal_section_entries];
@@ -2844,6 +2891,7 @@ static int dm_integrity_ctr(struct dm_ta
 	ti->per_io_data_size = sizeof(struct dm_integrity_io);
 
 	ic->in_progress = RB_ROOT;
+	INIT_LIST_HEAD(&ic->wait_list);
 	init_waitqueue_head(&ic->endio_wait);
 	bio_list_init(&ic->flush_bio_list);
 	init_waitqueue_head(&ic->copy_to_journal_wait);
@@ -3189,6 +3237,7 @@ static void dm_integrity_dtr(struct dm_t
 	struct dm_integrity_c *ic = ti->private;
 
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
+	BUG_ON(!list_empty(&ic->wait_list));
 
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
