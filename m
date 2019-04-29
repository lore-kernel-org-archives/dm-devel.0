From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 10/10] dm-integrity: implement synchronous mode
	for reboot handling
Date: Mon, 29 Apr 2019 14:57:26 +0200
Message-ID: <20190429125748.619296680@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-bitmap-sync-mode.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Unfortunatelly, there may be bios coming even after the reboot notifier
was called. We don't want these bios to make the bitmap dirty again.

This patch implements a synchronous mode - when a bio is about to be
terminated, we clean the bitmap and terminate the bio after the clean
operation succeeds. This obviously slows down bio processing, but it makes
sure that when all bios are finished, the bitmap will be clean.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-27 10:28:37.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-27 10:28:37.000000000 +0200
@@ -171,6 +171,8 @@ struct dm_integrity_c {
 	struct page_list *may_write_bitmap;
 	struct bitmap_block_status *bbs;
 	unsigned bitmap_flush_interval;
+	int synchronous_mode;
+	struct bio_list synchronous_bios;
 	struct delayed_work bitmap_flush_work;
 
 	struct crypto_skcipher *journal_crypt;
@@ -1382,6 +1384,14 @@ static void do_endio(struct dm_integrity
 	int r = dm_integrity_failed(ic);
 	if (unlikely(r) && !bio->bi_status)
 		bio->bi_status = errno_to_blk_status(r);
+	if (unlikely(ic->synchronous_mode) && bio_op(bio) == REQ_OP_WRITE) {
+		unsigned long flags;
+		spin_lock_irqsave(&ic->endio_wait.lock, flags);
+		bio_list_add(&ic->synchronous_bios, bio);
+		queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, 0);
+		spin_unlock_irqrestore(&ic->endio_wait.lock, flags);
+		return;
+	}
 	bio_endio(bio);
 }
 
@@ -2494,6 +2504,7 @@ static void bitmap_flush_work(struct wor
 	struct dm_integrity_c *ic = container_of(work, struct dm_integrity_c, bitmap_flush_work.work);
 	struct dm_integrity_range range;
 	unsigned long limit;
+	struct bio *bio;
 
 	dm_integrity_flush_buffers(ic);
 
@@ -2514,13 +2525,20 @@ static void bitmap_flush_work(struct wor
 			>> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit)
 			<< (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
 	}
-	DEBUG_print("zeroing journal\n");
+	/*DEBUG_print("zeroing journal\n");*/
 	block_bitmap_op(ic, ic->journal, 0, limit, BITMAP_OP_CLEAR);
 	block_bitmap_op(ic, ic->may_write_bitmap, 0, limit, BITMAP_OP_CLEAR);
 
 	rw_journal_sectors(ic, REQ_OP_WRITE, REQ_FUA | REQ_SYNC, 0, ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
 
-	remove_range(ic, &range);
+	spin_lock_irq(&ic->endio_wait.lock);
+	remove_range_unlocked(ic, &range);
+	while (unlikely((bio = bio_list_pop(&ic->synchronous_bios)) != NULL)) {
+		bio_endio(bio);
+		spin_unlock_irq(&ic->endio_wait.lock);
+		spin_lock_irq(&ic->endio_wait.lock);
+	}
+	spin_unlock_irq(&ic->endio_wait.lock);
 }
 
 
@@ -2720,16 +2738,27 @@ clear_journal:
 		init_journal_node(&ic->journal_tree[i]);
 }
 
-static int dm_integrity_reboot(struct notifier_block *n, unsigned long code, void *x)
+static void dm_integrity_enter_synchronous_mode(struct dm_integrity_c *ic)
 {
-	struct dm_integrity_c *ic = container_of(n, struct dm_integrity_c, reboot_notifier);
+	DEBUG_print("dm_integrity_enter_synchronous_mode\n");
 
 	if (ic->mode == 'B') {
-		DEBUG_print("dm_integrity_reboot\n");
+		ic->bitmap_flush_interval = msecs_to_jiffies(10) + 1;
+		ic->synchronous_mode = 1;
+
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 		queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, 0);
 		flush_workqueue(ic->commit_wq);
 	}
+}
+
+static int dm_integrity_reboot(struct notifier_block *n, unsigned long code, void *x)
+{
+	struct dm_integrity_c *ic = container_of(n, struct dm_integrity_c, reboot_notifier);
+
+	DEBUG_print("dm_integrity_reboot\n");
+
+	dm_integrity_enter_synchronous_mode(ic);
 
 	return NOTIFY_DONE;
 }
@@ -2853,6 +2882,10 @@ static void dm_integrity_resume(struct d
 	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
 	WARN_ON(register_reboot_notifier(&ic->reboot_notifier));
+
+#if 0
+	dm_integrity_enter_synchronous_mode(ic);
+#endif
 }
 
 static void dm_integrity_status(struct dm_target *ti, status_type_t type,
