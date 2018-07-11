From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: use wake_up_process instead of a wait
	queue
Date: Wed, 11 Jul 2018 12:10:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1807111209540.6276@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a small simplification of dm-crypt - use wake_up_process instead
of a wait queue in a case where only one process may be waiting.
dm-writecache uses a similar pattern.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2018-07-10 00:29:54.970000000 +0200
+++ linux-2.6/drivers/md/dm-crypt.c	2018-07-11 16:42:32.364000000 +0200
@@ -144,7 +144,7 @@ struct crypt_config {
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
 
-	wait_queue_head_t write_thread_wait;
+	spinlock_t write_thread_lock;
 	struct task_struct *write_thread;
 	struct rb_root write_tree;
 
@@ -1620,36 +1620,31 @@ static int dmcrypt_write(void *data)
 		struct rb_root write_tree;
 		struct blk_plug plug;
 
-		DECLARE_WAITQUEUE(wait, current);
-
-		spin_lock_irq(&cc->write_thread_wait.lock);
+		spin_lock_irq(&cc->write_thread_lock);
 continue_locked:
 
 		if (!RB_EMPTY_ROOT(&cc->write_tree))
 			goto pop_from_list;
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		__add_wait_queue(&cc->write_thread_wait, &wait);
 
-		spin_unlock_irq(&cc->write_thread_wait.lock);
+		spin_unlock_irq(&cc->write_thread_lock);
 
 		if (unlikely(kthread_should_stop())) {
 			set_current_state(TASK_RUNNING);
-			remove_wait_queue(&cc->write_thread_wait, &wait);
 			break;
 		}
 
 		schedule();
 
 		set_current_state(TASK_RUNNING);
-		spin_lock_irq(&cc->write_thread_wait.lock);
-		__remove_wait_queue(&cc->write_thread_wait, &wait);
+		spin_lock_irq(&cc->write_thread_lock);
 		goto continue_locked;
 
 pop_from_list:
 		write_tree = cc->write_tree;
 		cc->write_tree = RB_ROOT;
-		spin_unlock_irq(&cc->write_thread_wait.lock);
+		spin_unlock_irq(&cc->write_thread_lock);
 
 		BUG_ON(rb_parent(write_tree.rb_node));
 
@@ -1693,7 +1688,9 @@ static void kcryptd_crypt_write_io_submi
 		return;
 	}
 
-	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
+	spin_lock_irqsave(&cc->write_thread_lock, flags);
+	if (RB_EMPTY_ROOT(&cc->write_tree))
+		wake_up_process(cc->write_thread);
 	rbp = &cc->write_tree.rb_node;
 	parent = NULL;
 	sector = io->sector;
@@ -1706,9 +1703,7 @@ static void kcryptd_crypt_write_io_submi
 	}
 	rb_link_node(&io->rb_node, parent, rbp);
 	rb_insert_color(&io->rb_node, &cc->write_tree);
-
-	wake_up_locked(&cc->write_thread_wait);
-	spin_unlock_irqrestore(&cc->write_thread_wait.lock, flags);
+	spin_unlock_irqrestore(&cc->write_thread_lock, flags);
 }
 
 static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
@@ -2835,7 +2830,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad;
 	}
 
-	init_waitqueue_head(&cc->write_thread_wait);
+	spin_lock_init(&cc->write_thread_lock);
 	cc->write_tree = RB_ROOT;
 
 	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write");
