From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 05/20] dm-crypt: Unify spinlock
Date: Tue, 21 Aug 2012 11:09:16 +0200
Message-ID: <7c25d1f54166e77bf2cb639ebd1a393212017ff5.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Remove "crypt_thread_spinlock" and use wait queue spinlock
"crypt_thread_wait.spinlock" instead.

This saves few atomic operations in the encryption thread.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cb0e26f..b251e15 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -130,7 +130,6 @@ struct crypt_config {
 	struct task_struct **crypt_threads;
 
 	wait_queue_head_t crypt_thread_wait;
-	spinlock_t crypt_thread_spinlock;
 	struct list_head crypt_thread_list;
 
 	char *cipher;
@@ -680,15 +679,16 @@ static int dmcrypt_thread(void *data)
 
 		DECLARE_WAITQUEUE(wait, current);
 
-		spin_lock(&cc->crypt_thread_spinlock);
+		spin_lock_irq(&cc->crypt_thread_wait.lock);
+continue_locked:
 
 		if (!list_empty(&cc->crypt_thread_list))
 			goto pop_from_list;
 
 		__set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&cc->crypt_thread_wait, &wait);
+		__add_wait_queue(&cc->crypt_thread_wait, &wait);
 
-		spin_unlock(&cc->crypt_thread_spinlock);
+		spin_unlock_irq(&cc->crypt_thread_wait.lock);
 
 		if (unlikely(kthread_should_stop())) {
 			set_task_state(current, TASK_RUNNING);
@@ -699,8 +699,9 @@ static int dmcrypt_thread(void *data)
 		schedule();
 
 		set_task_state(current, TASK_RUNNING);
-		remove_wait_queue(&cc->crypt_thread_wait, &wait);
-		continue;
+		spin_lock_irq(&cc->crypt_thread_wait.lock);
+		__remove_wait_queue(&cc->crypt_thread_wait, &wait);
+		goto continue_locked;
 
 pop_from_list:
 		n_dmreqs = 0;
@@ -712,7 +713,8 @@ pop_from_list:
 			dmreqs[n_dmreqs++] = dmreq;
 		} while (n_dmreqs < DMREQ_PULL_BATCH &&
 			 !list_empty(&cc->crypt_thread_list));
-		spin_unlock(&cc->crypt_thread_spinlock);
+
+		spin_unlock_irq(&cc->crypt_thread_wait.lock);
 
 		i = 0;
 		do {
@@ -805,10 +807,10 @@ static struct ablkcipher_request *crypt_alloc_req(struct crypt_config *cc,
 
 static void crypt_flush_batch(struct crypt_config *cc, struct list_head *batch)
 {
-	spin_lock(&cc->crypt_thread_spinlock);
+	spin_lock_irq(&cc->crypt_thread_wait.lock);
 	list_splice_tail(batch, &cc->crypt_thread_list);
-	spin_unlock(&cc->crypt_thread_spinlock);
-	wake_up_all(&cc->crypt_thread_wait);
+	wake_up_locked(&cc->crypt_thread_wait);
+	spin_unlock_irq(&cc->crypt_thread_wait.lock);
 	INIT_LIST_HEAD(batch);
 }
 
@@ -1750,7 +1752,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			cc->crypt_threads_size = i + 1;
 
 	init_waitqueue_head(&cc->crypt_thread_wait);
-	spin_lock_init(&cc->crypt_thread_spinlock);
 	INIT_LIST_HEAD(&cc->crypt_thread_list);
 
 	cc->crypt_threads = kzalloc(cc->crypt_threads_size *
-- 
1.7.10.4
