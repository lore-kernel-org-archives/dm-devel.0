From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2] dm-crypt: fix a possible race condition on
	exit
Date: Thu, 19 Nov 2015 07:36:50 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511190733040.27567@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1511181637540.24040@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1511181637540.24040@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

I forgot to unlock the spinlock when terminating the thread - so here is 
new version of the patch.

From: Mikulas Patocka <mpatocka@redhat.com>

dm-crypt: fix a possible race condition on exit

I found a possible race condition on exit in dm-crypt. The kernel thread
executes __set_current_state(TASK_INTERRUPTIBLE), __add_wait_queue,
spin_unlock_irq and then tests kthread_should_stop(). It is possible that
the processor reorders memory accesses so that kthread_should_stop() is
executed before __set_current_state(TASK_INTERRUPTIBLE). If such
reordering happens, there is a possible race on thread termination:

CPU 0:
calls kthread_should_stop()
	it tests KTHREAD_SHOULD_STOP bit, returns false
CPU 1:
calls kthread_stop(cc->write_thread)
	sets the KTHREAD_SHOULD_STOP bit
	calls wake_up_process on the kernel thread, that sets the thread
		state to TASK_RUNNING
CPU 0:
sets __set_current_state(TASK_INTERRUPTIBLE)
spin_unlock_irq(&cc->write_thread_wait.lock)
schedule() - and the process is stuck and never terminates, because the
	state is TASK_INTERRUPTIBLE and wake_up_process on CPU 1 already
	terminated

Fix this race condition by using a new flag DM_CRYPT_EXIT_THREAD to signal
that the kernel thread should exit. The flag is set and tested while
holding cc->write_thread_wait.lock, so there is no possibility of racy
access to the flag.

We also remove set_task_state(current, TASK_RUNNING) following the
schedule(), it is not needed. When the process was woken up, its state was
already set to TASK_RUNNING. Other kernel code also doesn't set the state
to TASK_RUNNING following schedule() (for example, do_wait_for_common in
completion.c doesn't do it).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.0+
Fixes: dc2676210c42 ("dm crypt: offload writes to thread")

---
 drivers/md/dm-crypt.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: linux-4.4-rc1/drivers/md/dm-crypt.c
===================================================================
--- linux-4.4-rc1.orig/drivers/md/dm-crypt.c	2015-11-18 23:33:48.000000000 +0100
+++ linux-4.4-rc1/drivers/md/dm-crypt.c	2015-11-19 13:32:09.000000000 +0100
@@ -112,7 +112,8 @@ struct iv_tcw_private {
  * and encrypts / decrypts at the same time.
  */
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
-	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
+	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
+	     DM_CRYPT_EXIT_THREAD};
 
 /*
  * The fields in here must be read only after initialization.
@@ -1203,20 +1204,18 @@ continue_locked:
 		if (!RB_EMPTY_ROOT(&cc->write_tree))
 			goto pop_from_list;
 
+		if (unlikely(test_bit(DM_CRYPT_EXIT_THREAD, &cc->flags))) {
+			spin_unlock_irq(&cc->write_thread_wait.lock);
+			break;
+		}
+
 		__set_current_state(TASK_INTERRUPTIBLE);
 		__add_wait_queue(&cc->write_thread_wait, &wait);
 
 		spin_unlock_irq(&cc->write_thread_wait.lock);
 
-		if (unlikely(kthread_should_stop())) {
-			set_task_state(current, TASK_RUNNING);
-			remove_wait_queue(&cc->write_thread_wait, &wait);
-			break;
-		}
-
 		schedule();
 
-		set_task_state(current, TASK_RUNNING);
 		spin_lock_irq(&cc->write_thread_wait.lock);
 		__remove_wait_queue(&cc->write_thread_wait, &wait);
 		goto continue_locked;
@@ -1531,8 +1530,13 @@ static void crypt_dtr(struct dm_target *
 	if (!cc)
 		return;
 
-	if (cc->write_thread)
+	if (cc->write_thread) {
+		spin_lock_irq(&cc->write_thread_wait.lock);
+		set_bit(DM_CRYPT_EXIT_THREAD, &cc->flags);
+		wake_up_locked(&cc->write_thread_wait);
+		spin_unlock_irq(&cc->write_thread_wait.lock);
 		kthread_stop(cc->write_thread);
+	}
 
 	if (cc->io_queue)
 		destroy_workqueue(cc->io_queue);
