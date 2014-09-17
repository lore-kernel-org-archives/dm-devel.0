From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm crypt: retain write ordering
Date: Wed, 17 Sep 2014 14:27:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1409171425060.15315@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is update "retain write ordering" patch that hopefully fixes the 
lockup.

Please test it in the situation where you saw performance degradation due 
to dm-crypt parallelization patches.



From: Mikulas Patocka <mpatocka@redhat.com>
    
Reorder outgoing write requests so they submitted in the same order they
were received in.
    
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   55 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 10 deletions(-)

Index: linux-3.16/drivers/md/dm-crypt.c
===================================================================
--- linux-3.16.orig/drivers/md/dm-crypt.c	2014-09-17 19:54:33.000000000 +0200
+++ linux-3.16/drivers/md/dm-crypt.c	2014-09-17 19:54:35.000000000 +0200
@@ -61,6 +61,8 @@ struct dm_crypt_io {
 	sector_t sector;
 
 	struct list_head list;
+
+	unsigned long sequence;
 } CRYPTO_MINALIGN_ATTR;
 
 struct dm_crypt_request {
@@ -135,6 +137,9 @@ struct crypt_config {
 	wait_queue_head_t write_thread_wait;
 	struct list_head write_thread_list;
 
+	unsigned long write_sequence;
+	atomic_long_t alloc_sequence;
+
 	char *cipher;
 	char *cipher_string;
 
@@ -1177,7 +1182,9 @@ static int dmcrypt_write(void *data)
 {
 	struct crypt_config *cc = data;
 	while (1) {
+		struct dm_crypt_io *io;
 		struct list_head local_list;
+		unsigned spinlock_breaker;
 		struct blk_plug plug;
 
 		DECLARE_WAITQUEUE(wait, current);
@@ -1185,8 +1192,31 @@ static int dmcrypt_write(void *data)
 		spin_lock_irq(&cc->write_thread_wait.lock);
 continue_locked:
 
-		if (!list_empty(&cc->write_thread_list))
-			goto pop_from_list;
+		INIT_LIST_HEAD(&local_list);
+		spinlock_breaker = 0;
+
+		while (!list_empty(&cc->write_thread_list)) {
+			io = container_of(cc->write_thread_list.next,
+					  struct dm_crypt_io, list);
+
+			BUG_ON((long)(io->sequence - cc->write_sequence) < 0);
+			if (io->sequence != cc->write_sequence)
+				break;
+
+			cc->write_sequence++;
+
+			list_del(&io->list);
+			list_add_tail(&io->list, &local_list);
+			if (unlikely(!(++spinlock_breaker & 63))) {
+				spin_unlock_irq(&cc->write_thread_wait.lock);
+				spin_lock_irq(&cc->write_thread_wait.lock);
+			}
+		}
+
+		if (!list_empty(&local_list)) {
+			spin_unlock_irq(&cc->write_thread_wait.lock);
+			goto flush_local_list;
+		}
 
 		__set_current_state(TASK_INTERRUPTIBLE);
 		__add_wait_queue(&cc->write_thread_wait, &wait);
@@ -1206,14 +1236,8 @@ continue_locked:
 		__remove_wait_queue(&cc->write_thread_wait, &wait);
 		goto continue_locked;
 
-pop_from_list:
-		local_list = cc->write_thread_list;
-		local_list.next->prev = &local_list;
-		local_list.prev->next = &local_list;
-		INIT_LIST_HEAD(&cc->write_thread_list);
-
-		spin_unlock_irq(&cc->write_thread_wait.lock);
 
+flush_local_list:
 		blk_start_plug(&plug);
 		do {
 			struct dm_crypt_io *io = container_of(local_list.next,
@@ -1231,6 +1255,7 @@ static void kcryptd_crypt_write_io_submi
 	struct bio *clone = io->ctx.bio_out;
 	struct crypt_config *cc = io->cc;
 	unsigned long flags;
+	struct dm_crypt_io *io_list;
 
 	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
@@ -1245,8 +1270,15 @@ static void kcryptd_crypt_write_io_submi
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
 	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
-	list_add_tail(&io->list, &cc->write_thread_list);
+	list_for_each_entry_reverse(io_list, &cc->write_thread_list, list) {
+		if ((long)(io_list->sequence - io->sequence) < 0) {
+			list_add(&io->list, &io_list->list);
+			goto added;
+		}
+	}
+	list_add(&io->list, &cc->write_thread_list);
 	wake_up_locked(&cc->write_thread_wait);
+added:
 	spin_unlock_irqrestore(&cc->write_thread_wait.lock, flags);
 }
 
@@ -1272,6 +1304,7 @@ static void kcryptd_crypt_write_convert(
 
 	io->ctx.bio_out = clone;
 	io->ctx.iter_out = clone->bi_iter;
+	io->sequence = (unsigned long)atomic_long_inc_return(&io->cc->alloc_sequence) - 1;
 
 	sector += bio_sectors(clone);
 
@@ -1822,6 +1855,8 @@ static int crypt_ctr(struct dm_target *t
 
 	init_waitqueue_head(&cc->write_thread_wait);
 	INIT_LIST_HEAD(&cc->write_thread_list);
+	cc->write_sequence = 0;
+	atomic_long_set(&cc->alloc_sequence, 0);
 
 	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write");
 	if (IS_ERR(cc->write_thread)) {
