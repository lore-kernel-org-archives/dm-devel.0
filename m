From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 1/4] dm_queue: add dm_queue and generic
	worker thread
Date: Fri, 23 Jun 2006 17:47:00 -0400 (EDT)
Message-ID: <20060623.174700.78704504.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds device-mapper generic queue feature (dm_queue)
so that targets can use it instead of using its own queuing mechanism.

The patch is for 2.6.17-rc6-mm1 + Alasdair's patches which was sent
to this ML (Subject: "Next set of device-mapper patches").

Regards,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 2.6.17-rc6-mm1.agk/drivers/md/dm-queue.c 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-queue.c
--- 2.6.17-rc6-mm1.agk/drivers/md/dm-queue.c	1969-12-31 19:00:00.000000000 -0500
+++ 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm-queue.c	2006-06-23 11:36:04.000000000 -0400
@@ -0,0 +1,168 @@
+/*
+ * Copyright (C) 2006 NEC Corporation
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm.h"
+#include "dm-bio-list.h"
+
+#include <linux/workqueue.h>
+
+struct workqueue_struct *kdmqd;
+
+struct dm_queue {
+	spinlock_t lock; /* protects .bios and .size */
+	struct bio_list bios;
+	unsigned int size;
+
+	struct dm_target *ti;
+	struct work_struct work;
+};
+
+int dm_queue_init()
+{
+	kdmqd = create_workqueue("dm_queue");
+	if (!kdmqd)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void dm_queue_exit()
+{
+	destroy_workqueue(kdmqd);
+}
+
+struct dm_queue *dm_queue_alloc(int nr)
+{
+	struct dm_queue *qs;
+
+	if (!nr)
+		return NULL;
+
+	qs = kzalloc(sizeof(struct dm_queue) * nr, GFP_KERNEL);
+
+	return qs;
+}
+EXPORT_SYMBOL_GPL(dm_queue_alloc);
+
+void dm_queue_free(struct dm_queue *qs)
+{
+	if (qs)
+		kfree(qs);
+}
+EXPORT_SYMBOL_GPL(dm_queue_free);
+
+void dm_queue_flush(struct dm_queue *q)
+{
+	/*
+	 * The work queue is shared by multiple targets and we cannot
+	 * flush the specific queue.
+	 */
+	flush_workqueue(kdmqd);
+}
+EXPORT_SYMBOL_GPL(dm_queue_flush);
+
+struct dm_queue *dm_queue_find(struct dm_queue *qs, unsigned int index)
+{
+	if (!qs)
+		return NULL;
+
+	return qs + index;
+}
+EXPORT_SYMBOL_GPL(dm_queue_find);
+
+int dm_queue_setup(struct dm_queue *q, void (*work)(void *),
+		    struct dm_target *ti)
+{
+	spin_lock_init(&q->lock);
+	bio_list_init(&q->bios);
+	q->size = 0;
+	q->ti = ti;
+	INIT_WORK(&q->work, work, q);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_queue_setup);
+
+int dm_queue_add_bio(struct dm_queue *q, struct bio *bio)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	bio_list_add(&q->bios, bio);
+	q->size++;
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_queue_add_bio);
+
+struct bio *dm_queue_pop_bio(struct dm_queue *q)
+{
+	struct bio *bio = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	bio = bio_list_pop(&q->bios);
+	if (bio)
+		q->size--;
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return bio;
+}
+EXPORT_SYMBOL_GPL(dm_queue_pop_bio);
+
+struct bio *dm_queue_get_bios(struct dm_queue *q)
+{
+	struct bio *bio = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	bio = bio_list_get(&q->bios);
+	q->size = 0;
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return bio;
+}
+EXPORT_SYMBOL_GPL(dm_queue_get_bios);
+
+unsigned int dm_queue_size(struct dm_queue *q)
+{
+	unsigned int s;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	s = q->size;
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return s;
+}
+EXPORT_SYMBOL_GPL(dm_queue_size);
+
+struct dm_target *dm_queue_get_target(struct dm_queue *q)
+{
+	return q->ti;
+}
+EXPORT_SYMBOL_GPL(dm_queue_get_target);
+
+void dm_queue_process(struct dm_queue *q)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	if (!q->size)
+		goto out;
+
+	queue_work(kdmqd, &q->work);
+
+out:
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL_GPL(dm_queue_process);
diff -rupN 2.6.17-rc6-mm1.agk/include/linux/device-mapper.h 2.6.17-rc6-mm1.agk.moveq/include/linux/device-mapper.h
--- 2.6.17-rc6-mm1.agk/include/linux/device-mapper.h	2006-06-09 16:50:42.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq/include/linux/device-mapper.h	2006-06-23 11:29:00.000000000 -0400
@@ -10,6 +10,7 @@
 
 #ifdef __KERNEL__
 
+struct dm_queue;
 struct dm_target;
 struct dm_table;
 struct dm_dev;
@@ -131,6 +132,10 @@ struct dm_target {
 
 	/* Used to provide an error string from the ctr */
 	char *error;
+
+	/* Generic queue for target */
+	struct dm_queue *queues;
+	unsigned int num_queues;
 };
 
 int dm_register_target(struct target_type *t);
@@ -238,5 +243,54 @@ int dm_swap_table(struct mapped_device *
  */
 int dm_create_error_table(struct dm_table **result, struct mapped_device *md);
 
+
+/*-----------------------------------------------------------------
+ * Functions for manipulating device-mapper queues.
+ *---------------------------------------------------------------*/
+
+/*
+ * First alloc queues.
+ */
+struct dm_queue *dm_queue_alloc(int nr);
+
+/*
+ * Then call this to get a specific queue from the allocated queues.
+ */
+struct dm_queue *dm_queue_find(struct dm_queue *qs, unsigned int index);
+
+/*
+ * Finally call this to make the queue ready for use.
+ */
+int dm_queue_setup(struct dm_queue *q, void (*fn)(void *),
+		   struct dm_target *ti);
+
+/*
+ * Free allocated queues.
+ */
+void dm_queue_free(struct dm_queue *qs);
+
+/*
+ * Flush the queue.
+ */
+void dm_queue_flush(struct dm_queue *q);
+
+/*
+ * Manipulations.
+ */
+int dm_queue_add_bio(struct dm_queue *q, struct bio *bio);
+struct bio *dm_queue_pop_bio(struct dm_queue *q);
+struct bio *dm_queue_get_bios(struct dm_queue *q);
+
+/*
+ * Info.
+ */
+unsigned int dm_queue_size(struct dm_queue *q);
+struct dm_target *dm_queue_get_target(struct dm_queue *q);
+
+/*
+ * Start processing a queue.
+ */
+void dm_queue_process(struct dm_queue *q);
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DEVICE_MAPPER_H */
diff -rupN 2.6.17-rc6-mm1.agk/drivers/md/dm.h 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.h
--- 2.6.17-rc6-mm1.agk/drivers/md/dm.h	2006-06-09 16:50:42.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.h	2006-06-23 11:18:54.000000000 -0400
@@ -39,6 +39,7 @@ struct dm_dev {
 };
 
 struct dm_table;
+struct dm_queue;
 
 /*-----------------------------------------------------------------
  * Internal table functions.
@@ -57,6 +58,12 @@ void dm_table_unplug_all(struct dm_table
 int dm_table_flush_all(struct dm_table *t);
 
 /*-----------------------------------------------------------------
+ * Queue functions.
+ *---------------------------------------------------------------*/
+int dm_queue_init(void);
+void dm_queue_exit(void);
+
+/*-----------------------------------------------------------------
  * A registry of target types.
  *---------------------------------------------------------------*/
 int dm_target_init(void);
diff -rupN 2.6.17-rc6-mm1.agk/drivers/md/dm.c 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.c
--- 2.6.17-rc6-mm1.agk/drivers/md/dm.c	2006-06-21 16:32:06.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq/drivers/md/dm.c	2006-06-23 11:17:29.000000000 -0400
@@ -176,6 +176,7 @@ static void local_exit(void)
 
 int (*_inits[])(void) __initdata = {
 	local_init,
+	dm_queue_init,
 	dm_target_init,
 	dm_linear_init,
 	dm_stripe_init,
@@ -184,6 +185,7 @@ int (*_inits[])(void) __initdata = {
 
 void (*_exits[])(void) = {
 	local_exit,
+	dm_queue_exit,
 	dm_target_exit,
 	dm_linear_exit,
 	dm_stripe_exit,
diff -rupN 2.6.17-rc6-mm1.agk/drivers/md/Makefile 2.6.17-rc6-mm1.agk.moveq/drivers/md/Makefile
--- 2.6.17-rc6-mm1.agk/drivers/md/Makefile	2006-06-05 20:57:02.000000000 -0400
+++ 2.6.17-rc6-mm1.agk.moveq/drivers/md/Makefile	2006-06-20 18:48:01.000000000 -0400
@@ -3,7 +3,7 @@
 #
 
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o kcopyd.o
+		   dm-ioctl.o dm-io.o kcopyd.o dm-queue.o
 dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-log.o dm-raid1.o
