From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/7] dm-crypt: sort writes
Date: Fri, 13 Feb 2015 08:27:41 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502130827100.6449@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Write requests are sorted in a red-black tree structure and are submitted
in the sorted order.

In theory the sorting should be performed by the underlying disk scheduler,
however, in practice the disk scheduler accepts and sorts only 128 requests.
In order to sort more requests, we need to implement our own sorting.

In testing, it was shown that this patch slightly increases performance in
some situations

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   50 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 15 deletions(-)

Index: linux-3.19/drivers/md/dm-crypt.c
===================================================================
--- linux-3.19.orig/drivers/md/dm-crypt.c	2015-02-12 18:40:56.000000000 +0100
+++ linux-3.19/drivers/md/dm-crypt.c	2015-02-12 18:41:32.000000000 +0100
@@ -22,6 +22,7 @@
 #include <linux/backing-dev.h>
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
+#include <linux/rbtree.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
@@ -60,7 +61,7 @@ struct dm_crypt_io {
 	int error;
 	sector_t sector;
 
-	struct list_head list;
+	struct rb_node rb_node;
 } CRYPTO_MINALIGN_ATTR;
 
 struct dm_crypt_request {
@@ -133,7 +134,7 @@ struct crypt_config {
 
 	struct task_struct *write_thread;
 	wait_queue_head_t write_thread_wait;
-	struct list_head write_thread_list;
+	struct rb_root write_tree;
 
 	char *cipher;
 	char *cipher_string;
@@ -1172,7 +1173,7 @@ static int dmcrypt_write(void *data)
 {
 	struct crypt_config *cc = data;
 	while (1) {
-		struct list_head local_list;
+		struct rb_root write_tree;
 		struct blk_plug plug;
 
 		DECLARE_WAITQUEUE(wait, current);
@@ -1180,7 +1181,7 @@ static int dmcrypt_write(void *data)
 		spin_lock_irq(&cc->write_thread_wait.lock);
 continue_locked:
 
-		if (!list_empty(&cc->write_thread_list))
+		if (!RB_EMPTY_ROOT(&cc->write_tree))
 			goto pop_from_list;
 
 		__set_current_state(TASK_INTERRUPTIBLE);
@@ -1202,20 +1203,23 @@ continue_locked:
 		goto continue_locked;
 
 pop_from_list:
-		local_list = cc->write_thread_list;
-		local_list.next->prev = &local_list;
-		local_list.prev->next = &local_list;
-		INIT_LIST_HEAD(&cc->write_thread_list);
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
 		do {
-			struct dm_crypt_io *io = container_of(local_list.next,
-						struct dm_crypt_io, list);
-			list_del(&io->list);
+			struct dm_crypt_io *io = rb_entry(rb_first(&write_tree),
+						struct dm_crypt_io, rb_node);
+			rb_erase(&io->rb_node, &write_tree);
 			kcryptd_io_write(io);
-		} while (!list_empty(&local_list));
+		} while (!RB_EMPTY_ROOT(&write_tree));
 		blk_finish_plug(&plug);
 	}
 	return 0;
@@ -1226,6 +1230,8 @@ static void kcryptd_crypt_write_io_submi
 	struct bio *clone = io->ctx.bio_out;
 	struct crypt_config *cc = io->cc;
 	unsigned long flags;
+	sector_t sector;
+	struct rb_node **p, *parent;
 
 	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
@@ -1245,7 +1251,21 @@ static void kcryptd_crypt_write_io_submi
 	}
 
 	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
-	list_add_tail(&io->list, &cc->write_thread_list);
+	p = &cc->write_tree.rb_node;
+	parent = NULL;
+	sector = io->sector;
+	while (*p) {
+		parent = *p;
+#define io_node rb_entry(parent, struct dm_crypt_io, rb_node)
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
 	spin_unlock_irqrestore(&cc->write_thread_wait.lock, flags);
 }
@@ -1827,7 +1847,7 @@ static int crypt_ctr(struct dm_target *t
 	}
 
 	init_waitqueue_head(&cc->write_thread_wait);
-	INIT_LIST_HEAD(&cc->write_thread_list);
+	cc->write_tree = RB_ROOT;
 
 	cc->write_thread = kthread_create(dmcrypt_write, cc, "dmcrypt_write");
 	if (IS_ERR(cc->write_thread)) {
