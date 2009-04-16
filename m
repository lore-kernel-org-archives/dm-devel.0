From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] fix crash in blk_queue_abort
Date: Thu, 16 Apr 2009 19:52:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This fixes a crash in blk_abort_queue. The crash can be triggered with 
device mapper multipath.

I believe that since there is method make_request_fn, the cleanest 
solution is to add another method, abort_queue_fn. But you can use 
different solution if you want (like testing some bit whether the device 
is request-based ... or so).

Mikulas

---

Fix a crash due to blk_abort_queue being called on non-request device.

The crash can be reproduced in the following way:

# dmsetup create alias1 --table "0 `blockdev --getsize /dev/sda` linear /dev/sda 0"
# dmsetup create alias2 --table "0 `blockdev --getsize /dev/sda` linear /dev/sda 0"
# dmsetup create mpath --table "0 `blockdev --getsize /dev/sda` multipath 0 0 2 1 round-robin 0 1 0 /dev/mapper/alias1 round-robin 0 1 0 /dev/mapper/alias2"
# dmsetup reload alias1 --table "0 `blockdev --getsize /dev/sda` error"
# dmsetup suspend alias1
# dmsetup resume alias1
# less -f /dev/mapper/mpath

TPC: <__lock_acquire+0x5c/0x1c00>
Caller[000000000047f468]: lock_acquire+0xa8/0xc0
Caller[000000000065a978]: _spin_lock_irqsave+0x38/0x60
Caller[000000000054f7b4]: blk_abort_queue+0x34/0x140
Caller[00000000100ffe04]: deactivate_path+0x44/0x60 [dm_multipath]
Caller[0000000000468898]: worker_thread+0x1d8/0x2e0
Caller[000000000046d4ac]: kthread+0x4c/0x80
Caller[000000000042bc1c]: kernel_thread+0x3c/0x60
Caller[000000000046d3e4]: kthreadd+0x104/0x180

The crash happens because queue spinlock pointer is NULL and blk_abort_queue is
called.

The problem is that blk_abort_queue assumes that the underlying device is
request-based. If it uses bios, not requests, it accesses uninitialized data
structures and crashes.

This patch changes it to provide a method, abort_queue_fn, that will
abort the queue. On request-based devices, it points to generic_abort_queue,
on non-request based devices it can be NULL (no abort) or the driver can
register its own abort function there.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c       |    1 +
 block/blk-timeout.c    |   10 ++++++++--
 include/linux/blkdev.h |    3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.30-rc2-devel/block/blk-core.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/block/blk-core.c	2009-04-16 22:20:59.000000000 +0200
+++ linux-2.6.30-rc2-devel/block/blk-core.c	2009-04-16 23:44:25.000000000 +0200
@@ -598,6 +598,7 @@ blk_init_queue_node(request_fn_proc *rfn
 		lock = &q->__queue_lock;
 
 	q->request_fn		= rfn;
+	q->abort_queue_fn	= generic_abort_queue;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
Index: linux-2.6.30-rc2-devel/block/blk-timeout.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/block/blk-timeout.c	2009-04-16 22:30:27.000000000 +0200
+++ linux-2.6.30-rc2-devel/block/blk-timeout.c	2009-04-16 23:46:28.000000000 +0200
@@ -205,7 +205,7 @@ void blk_add_timer(struct request *req)
  * @queue:	pointer to queue
  *
  */
-void blk_abort_queue(struct request_queue *q)
+void generic_abort_queue(struct request_queue *q)
 {
 	unsigned long flags;
 	struct request *rq, *tmp;
@@ -227,4 +227,10 @@ void blk_abort_queue(struct request_queu
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 }
-EXPORT_SYMBOL_GPL(blk_abort_queue);
+
+void blk_abort_queue(struct request_queue *q)
+{
+	if (q->abort_queue_fn)
+		q->abort_queue_fn(q);
+}
+EXPORT_SYMBOL(blk_abort_queue);
Index: linux-2.6.30-rc2-devel/include/linux/blkdev.h
===================================================================
--- linux-2.6.30-rc2-devel.orig/include/linux/blkdev.h	2009-04-16 22:20:43.000000000 +0200
+++ linux-2.6.30-rc2-devel/include/linux/blkdev.h	2009-04-16 22:32:27.000000000 +0200
@@ -267,6 +267,7 @@ struct request_pm_state
 
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
+typedef void (abort_queue_fn) (struct request_queue *q);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
 typedef int (prepare_discard_fn) (struct request_queue *, struct request *);
@@ -332,6 +333,7 @@ struct request_queue
 
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
+	abort_queue_fn		*abort_queue_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
 	prepare_discard_fn	*prepare_discard_fn;
@@ -903,6 +905,7 @@ extern bool blk_ordered_complete_seq(str
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern void generic_unplug_device(struct request_queue *);
+extern void generic_abort_queue(struct request_queue *);
 extern long nr_blockdev_pages(void);
 
 int blk_get_queue(struct request_queue *);
