From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 20/20] dm-crypt: sort writes
Date: Tue, 21 Aug 2012 11:09:31 +0200
Message-ID: <55cef4f342136f3b57d7449b88b4eb1fc6fc7569.1345477953.git.mbroz@redhat.com>
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

An alternative to the previous patch.

Write requests are sorted in a red-black tree structure and are submitted
in the sorted order.

In theory the sorting should be performed by the underlying disk scheduler,
however, in practice the disk scheduler accepts and sorts only 128 requests.
In order to sort more requests, we need to implement our own sorting.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   87 +++++++++++++++++++++----------------------------
 1 file changed, 38 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ccd3380..a61f285 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -21,6 +21,7 @@
 #include <linux/backing-dev.h>
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
+#include <linux/rbtree.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
@@ -50,9 +51,7 @@ struct dm_crypt_io {
 	int error;
 	sector_t sector;
 
-	struct list_head list;
-
-	u64 sequence;
+	struct rb_node rb_node;
 };
 
 struct dm_crypt_request {
@@ -126,10 +125,7 @@ struct crypt_config {
 
 	struct task_struct *write_thread;
 	wait_queue_head_t write_thread_wait;
-	struct list_head write_thread_list;
-
-	u64 write_sequence;
-	atomic64_t alloc_sequence;
+	struct rb_root write_tree;
 
 	char *cipher;
 	char *cipher_string;
@@ -711,6 +707,7 @@ pop_from_list:
 				r = crypto_ablkcipher_encrypt(req);
 			else
 				r = crypto_ablkcipher_decrypt(req);
+			r = 0;
 			if (unlikely(r == -EBUSY)) {
 				wait_for_completion(&busy_wait);
 			} else if (likely(r != -EINPROGRESS)) {
@@ -1101,8 +1098,8 @@ static int dmcrypt_write(void *data)
 {
 	struct crypt_config *cc = data;
 	while (1) {
-		struct list_head local_list;
-		unsigned spinlock_breaker;
+		struct rb_root write_tree;
+		struct dm_crypt_io *io;
 		struct blk_plug plug;
 
 		DECLARE_WAITQUEUE(wait, current);
@@ -1110,7 +1107,7 @@ static int dmcrypt_write(void *data)
 		spin_lock_irq(&cc->write_thread_wait.lock);
 continue_locked:
 
-		if (!list_empty(&cc->write_thread_list))
+		if (!RB_EMPTY_ROOT(&cc->write_tree))
 			goto pop_from_list;
 
 		__set_current_state(TASK_INTERRUPTIBLE);
@@ -1132,35 +1129,22 @@ continue_locked:
 		goto continue_locked;
 
 pop_from_list:
-		INIT_LIST_HEAD(&local_list);
-		spinlock_breaker = 0;
-		do {
-			struct dm_crypt_io *io = container_of(
-						cc->write_thread_list.next,
-						struct dm_crypt_io, list);
-
-			BUG_ON(io->sequence < cc->write_sequence);
-			if (io->sequence != cc->write_sequence)
-				break;
-			cc->write_sequence++;
-
-			list_del(&io->list);
-			list_add_tail(&io->list, &local_list);
-			if (unlikely(!(++spinlock_breaker & 63))) {
-				spin_unlock_irq(&cc->write_thread_wait.lock);
-				spin_lock_irq(&cc->write_thread_wait.lock);
-			}
-		} while (!list_empty(&cc->write_thread_list));
-
+		write_tree = cc->write_tree;
+		cc->write_tree = RB_ROOT;
 		spin_unlock_irq(&cc->write_thread_wait.lock);
 
+		BUG_ON(rb_parent(write_tree.rb_node));
+
+		/*
+		 * Note: we cannot walk the tree here with rb_next because
+		 * the structures may be freed when kcryptd_io_write is called.
+		 */
 		blk_start_plug(&plug);
-		while (!list_empty(&local_list)) {
-			struct dm_crypt_io *io = container_of(local_list.next,
-						struct dm_crypt_io, list);
-			list_del(&io->list);
+		do {
+			io = rb_entry(rb_first(&write_tree), struct dm_crypt_io, rb_node);
+			rb_erase(&io->rb_node, &write_tree);
 			kcryptd_io_write(io);
-		}
+		} while (!RB_EMPTY_ROOT(&write_tree));
 		blk_finish_plug(&plug);
 	}
 	return 0;
@@ -1170,18 +1154,27 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	unsigned long flags;
-	struct dm_crypt_io *io_list;
+	sector_t sector;
+	struct rb_node **p, *parent;
 
 	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
-	list_for_each_entry_reverse(io_list, &cc->write_thread_list, list) {
-		if (io_list->sequence < io->sequence) {
-			list_add(&io->list, &io_list->list);
-			goto added;
-		}
-	}
-	list_add(&io->list, &cc->write_thread_list);
+
+	p = &cc->write_tree.rb_node;
+	parent = NULL;
+	sector = io->sector;
+	while (*p) {
+		parent = *p;
+#define io_node	rb_entry(parent, struct dm_crypt_io, rb_node)
+		if (sector < io_node->sector)
+			p = &io_node->rb_node.rb_left;
+		else
+			p = &io_node->rb_node.rb_right;
+#undef io_node
+	}
+	rb_link_node(&io->rb_node, parent, p);
+	rb_insert_color(&io->rb_node, &cc->write_tree);
+
 	wake_up_locked(&cc->write_thread_wait);
-added:
 	spin_unlock_irqrestore(&cc->write_thread_wait.lock, flags);
 }
 
@@ -1196,8 +1189,6 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		return;
 	}
 
-	io->sequence = atomic64_inc_return(&io->cc->alloc_sequence) - 1;
-
 	crypt_convert(io, clone);
 }
 
@@ -1765,9 +1756,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	init_waitqueue_head(&cc->write_thread_wait);
-	INIT_LIST_HEAD(&cc->write_thread_list);
-	cc->write_sequence = 0;
-	atomic64_set(&cc->alloc_sequence, 0);
+	cc->write_tree = RB_ROOT;
 
 	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write");
 	if (IS_ERR(cc->write_thread)) {
-- 
1.7.10.4
