From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 1/2] block: allow initialization of
	previously allocated request_queue
Date: Mon, 10 May 2010 18:55:38 -0400
Message-ID: <1273532139-23043-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

blk_init_queue() allocates the request_queue structure and then
initializes it as needed (request_fn, elevator, etc).

Split initialization out to blk_init_allocated_queue_node.
Introduce blk_init_allocated_queue wrapper function to model existing
blk_init_queue and blk_init_queue_node interfaces.

Export elv_register_queue to allow a newly added elevator to be
registered with sysfs.  Export elv_unregister_queue for symmetry.

These changes allow DM to initialize a device's request_queue with more
precision.  In particular, DM no longer unconditionally initializes a
full request_queue (elevator et al).  It only does so for a
request-based DM device.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       |   18 +++++++++++++++++-
 block/elevator.c       |    2 ++
 include/linux/blkdev.h |    5 +++++
 3 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9fe174d..bfd420c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -567,7 +567,23 @@ struct request_queue *
 blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 {
 	struct request_queue *q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	
+	return blk_init_allocated_queue_node(q, rfn, lock, node_id);
+}
+EXPORT_SYMBOL(blk_init_queue_node);
 
+struct request_queue *
+blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
+			 spinlock_t *lock)
+{
+	return blk_init_allocated_queue_node(q, rfn, lock, -1);
+}
+EXPORT_SYMBOL(blk_init_allocated_queue);
+
+struct request_queue *
+blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
+			      spinlock_t *lock, int node_id)
+{
 	if (!q)
 		return NULL;
 
@@ -601,7 +617,7 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	blk_put_queue(q);
 	return NULL;
 }
-EXPORT_SYMBOL(blk_init_queue_node);
+EXPORT_SYMBOL(blk_init_allocated_queue_node);
 
 int blk_get_queue(struct request_queue *q)
 {
diff --git a/block/elevator.c b/block/elevator.c
index 76e3702..6ec9137 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -921,6 +921,7 @@ int elv_register_queue(struct request_queue *q)
 	}
 	return error;
 }
+EXPORT_SYMBOL_GPL(elv_register_queue);
 
 static void __elv_unregister_queue(struct elevator_queue *e)
 {
@@ -933,6 +934,7 @@ void elv_unregister_queue(struct request_queue *q)
 	if (q)
 		__elv_unregister_queue(q->elevator);
 }
+EXPORT_SYMBOL_GPL(elv_unregister_queue);
 
 void elv_register(struct elevator_type *e)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6690e8b..89ce7a2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -917,7 +917,12 @@ extern void blk_abort_queue(struct request_queue *);
  */
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 					spinlock_t *lock, int node_id);
+extern struct request_queue *blk_init_allocated_queue_node(struct request_queue *,
+							   request_fn_proc *,
+							   spinlock_t *, int node_id);
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
+extern struct request_queue *blk_init_allocated_queue(struct request_queue *,
+						      request_fn_proc *, spinlock_t *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
-- 
1.6.6.1
