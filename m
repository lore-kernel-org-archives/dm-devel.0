From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] block: use timed offload
Date: Tue, 28 Jun 2016 20:19:43 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1606282018520.7298@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch introduces a timed bio offload.

When a process schedules and there are bios queued on
current->queued_bios, we submit a timer that redirects the queued bios to
a workqueue after a specific timeout (currently 1s).

The reason for the timer is that immediate bio offload could change
ordering of bios and it could theoretically cause performance regressions.
So, we offload bios only if the process is blocked for a certain amount of
time.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/bio.c      |   45 +++++++++++++++++++++++++++++++++------------
 block/blk-core.c |   19 +++++++++++++++++--
 2 files changed, 50 insertions(+), 14 deletions(-)

Index: linux-4.7-rc5-devel/block/bio.c
===================================================================
--- linux-4.7-rc5-devel.orig/block/bio.c	2016-06-28 17:05:40.000000000 +0200
+++ linux-4.7-rc5-devel/block/bio.c	2016-06-28 18:30:12.000000000 +0200
@@ -338,9 +338,10 @@ static void bio_alloc_rescue(struct work
 	struct bio *bio;
 
 	while (1) {
-		spin_lock(&bs->rescue_lock);
+		unsigned long flags;
+		spin_lock_irqsave(&bs->rescue_lock, flags);
 		bio = bio_list_pop(&bs->rescue_list);
-		spin_unlock(&bs->rescue_lock);
+		spin_unlock_irqrestore(&bs->rescue_lock, flags);
 
 		if (!bio)
 			break;
@@ -350,33 +351,53 @@ static void bio_alloc_rescue(struct work
 }
 
 /**
- * blk_flush_bio_list
- * @tsk: task_struct whose bio_list must be flushed
+ * blk_timer_flush_bio_list
  *
- * Pop bios queued on @tsk->bio_list and submit each of them to
+ * Pop bios queued on q->bio_list and submit each of them to
  * their rescue workqueue.
  *
- * If the bio doesn't have a bio_set, we leave it on @tsk->bio_list.
+ * If the bio doesn't have a bio_set, we leave it on q->bio_list.
  * However, stacking drivers should use bio_set, so this shouldn't be
  * an issue.
  */
-void blk_flush_bio_list(struct task_struct *tsk)
+static void blk_timer_flush_bio_list(unsigned long data)
 {
+	struct queued_bios *q = (struct queued_bios *)data;
 	struct bio *bio;
-	struct bio_list list = tsk->queued_bios->bio_list;
-	bio_list_init(&tsk->queued_bios->bio_list);
+
+	struct bio_list list = q->bio_list;
+	bio_list_init(&q->bio_list);
 
 	while ((bio = bio_list_pop(&list))) {
+		unsigned long flags;
 		struct bio_set *bs = bio->bi_pool;
 		if (unlikely(!bs)) {
-			bio_list_add(&tsk->queued_bios->bio_list, bio);
+			bio_list_add(&q->bio_list, bio);
 			continue;
 		}
 
-		spin_lock(&bs->rescue_lock);
+		spin_lock_irqsave(&bs->rescue_lock, flags);
 		bio_list_add(&bs->rescue_list, bio);
 		queue_work(bs->rescue_workqueue, &bs->rescue_work);
-		spin_unlock(&bs->rescue_lock);
+		spin_unlock_irqrestore(&bs->rescue_lock, flags);
+	}
+}
+
+#define BIO_RESCUE_TIMEOUT	HZ
+
+/**
+ * blk_flush_bio_list
+ * @tsk: task_struct whose bio_list must be flushed
+ *
+ * This function sets up a timer that flushes the queued bios.
+ */
+void blk_flush_bio_list(struct task_struct *tsk)
+{
+	struct queued_bios *q = tsk->queued_bios;
+	if (q->timer.function == NULL) {
+		setup_timer(&q->timer, blk_timer_flush_bio_list,
+			    (unsigned long)q);
+		mod_timer(&q->timer, jiffies + BIO_RESCUE_TIMEOUT);
 	}
 }
 
Index: linux-4.7-rc5-devel/block/blk-core.c
===================================================================
--- linux-4.7-rc5-devel.orig/block/blk-core.c	2016-06-28 16:46:01.000000000 +0200
+++ linux-4.7-rc5-devel/block/blk-core.c	2016-06-28 17:42:24.000000000 +0200
@@ -2078,6 +2078,7 @@ end_io:
 blk_qc_t generic_make_request(struct bio *bio)
 {
 	struct queued_bios queued_bios_on_stack;
+	struct queued_bios *q;
 	blk_qc_t ret = BLK_QC_T_NONE;
 
 	if (!generic_make_request_checks(bio))
@@ -2093,8 +2094,17 @@ blk_qc_t generic_make_request(struct bio
 	 * it is non-NULL, then a make_request is active, and new requests
 	 * should be added at the tail
 	 */
-	if (current->queued_bios) {
-		bio_list_add(&current->queued_bios->bio_list, bio);
+	q = current->queued_bios;
+	if (q) {
+		/*
+		 * The timer may modify q->bio_list. So we must stop the timer
+		 * before modifying the list.
+		 */
+		if (q->timer.function != NULL) {
+			del_timer_sync(&q->timer);
+			q->timer.function = NULL;
+		}
+		bio_list_add(&q->bio_list, bio);
 		goto out;
 	}
 
@@ -2114,6 +2124,7 @@ blk_qc_t generic_make_request(struct bio
 	 */
 	BUG_ON(bio->bi_next);
 	bio_list_init(&queued_bios_on_stack.bio_list);
+	queued_bios_on_stack.timer.function = NULL;
 	current->queued_bios = &queued_bios_on_stack;
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
@@ -2130,6 +2141,10 @@ blk_qc_t generic_make_request(struct bio
 			bio_io_error(bio);
 			bio = bio_next;
 		}
+		if (unlikely(queued_bios_on_stack.timer.function != NULL)) {
+			del_timer_sync(&queued_bios_on_stack.timer);
+			queued_bios_on_stack.timer.function = NULL;
+		}
 	} while (bio);
 	current->queued_bios = NULL; /* deactivate */
 
