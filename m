From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 2/3 v2] dm-writecache: convert wait queue to
 wake_up_process
Date: Thu, 7 Jun 2018 11:48:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806071147110.10781@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180606153201.708853388@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180606153201.708853388@debian.vm>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is second version of this patch - it also removes the label 
continue_locked, because it is no longer needed. If forgot to refresh the 
patch before sending it, so I sent an olded version.


From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 2/3 v2] dm-writecache: convert wait queue to wake_up_process

If there's just one process that can wait on a queue, we can use
wake_up_process. According to Linus, it is safe to call wake_up_process
on a process even if the process may be doing something else.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-06-05 22:54:49.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-06-07 17:44:11.000000000 +0200
@@ -10,7 +10,6 @@
 #include <linux/init.h>
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
-#include <linux/swait.h>
 #include <linux/dm-io.h>
 #include <linux/dm-kcopyd.h>
 #include <linux/dax.h>
@@ -168,7 +167,7 @@ struct dm_writecache {
 
 	struct dm_io_client *dm_io;
 
-	struct swait_queue_head endio_thread_wait;
+	raw_spinlock_t endio_list_lock;
 	struct list_head endio_list;
 	struct task_struct *endio_thread;
 
@@ -1273,10 +1272,11 @@ static void writecache_writeback_endio(s
 	struct dm_writecache *wc = wb->wc;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&wc->endio_thread_wait.lock, flags);
+	raw_spin_lock_irqsave(&wc->endio_list_lock, flags);
+	if (unlikely(list_empty(&wc->endio_list)))
+		wake_up_process(wc->endio_thread);
 	list_add_tail(&wb->endio_entry, &wc->endio_list);
-	swake_up_locked(&wc->endio_thread_wait);
-	raw_spin_unlock_irqrestore(&wc->endio_thread_wait.lock, flags);
+	raw_spin_unlock_irqrestore(&wc->endio_list_lock, flags);
 }
 
 static void writecache_copy_endio(int read_err, unsigned long write_err, void *ptr)
@@ -1286,10 +1286,11 @@ static void writecache_copy_endio(int re
 
 	c->error = likely(!(read_err | write_err)) ? 0 : -EIO;
 
-	raw_spin_lock_irq(&wc->endio_thread_wait.lock);
+	raw_spin_lock_irq(&wc->endio_list_lock);
+	if (unlikely(list_empty(&wc->endio_list)))
+		wake_up_process(wc->endio_thread);
 	list_add_tail(&c->endio_entry, &wc->endio_list);
-	swake_up_locked(&wc->endio_thread_wait);
-	raw_spin_unlock_irq(&wc->endio_thread_wait.lock);
+	raw_spin_unlock_irq(&wc->endio_list_lock);
 }
 
 static void __writecache_endio_pmem(struct dm_writecache *wc, struct list_head *list)
@@ -1364,33 +1365,28 @@ static int writecache_endio_thread(void
 	struct dm_writecache *wc = data;
 
 	while (1) {
-		DECLARE_SWAITQUEUE(wait);
 		struct list_head list;
 
-		raw_spin_lock_irq(&wc->endio_thread_wait.lock);
-continue_locked:
+		raw_spin_lock_irq(&wc->endio_list_lock);
 		if (!list_empty(&wc->endio_list))
 			goto pop_from_list;
 		set_current_state(TASK_INTERRUPTIBLE);
-		__prepare_to_swait(&wc->endio_thread_wait, &wait);
-		raw_spin_unlock_irq(&wc->endio_thread_wait.lock);
+		raw_spin_unlock_irq(&wc->endio_list_lock);
 
 		if (unlikely(kthread_should_stop())) {
-			finish_swait(&wc->endio_thread_wait, &wait);
+			set_current_state(TASK_RUNNING);
 			break;
 		}
 
 		schedule();
 
-		raw_spin_lock_irq(&wc->endio_thread_wait.lock);
-		__finish_swait(&wc->endio_thread_wait, &wait);
-		goto continue_locked;
+		continue;
 
 pop_from_list:
 		list = wc->endio_list;
 		list.next->prev = list.prev->next = &list;
 		INIT_LIST_HEAD(&wc->endio_list);
-		raw_spin_unlock_irq(&wc->endio_thread_wait.lock);
+		raw_spin_unlock_irq(&wc->endio_list_lock);
 
 		if (!WC_MODE_FUA(wc))
 			writecache_disk_flush(wc, wc->dev);
@@ -1848,7 +1844,7 @@ static int writecache_ctr(struct dm_targ
 	INIT_WORK(&wc->writeback_work, writecache_writeback);
 	INIT_WORK(&wc->flush_work, writecache_flush_work);
 
-	init_swait_queue_head(&wc->endio_thread_wait);
+	raw_spin_lock_init(&wc->endio_list_lock);
 	INIT_LIST_HEAD(&wc->endio_list);
 	wc->endio_thread = kthread_create(writecache_endio_thread, wc, "writecache_endio");
 	if (IS_ERR(wc->endio_thread)) {
