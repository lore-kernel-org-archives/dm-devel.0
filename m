From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Fri, 27 Oct 2006 23:36:31 +0900
Message-ID: <200610271436.k9REaVOC020547@r-dd.iij4u.or.jp>
References: <20061025194412J.fujita.tomonori@lab.ntt.co.jp>
	<m31wotsvqy.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <m31wotsvqy.fsf@guaranine.beaverton.ibm.com>
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

From: Dan Smith <danms@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 1/2] dm-userspace: use ring buffer instead of	system call
Date: Fri, 27 Oct 2006 07:01:41 -0700

> FT> It's against on the top of the following patches:
> 
> Would you mind sending a patch against a vanilla tree?  I'm having a
> hard time getting the patches (old and new) to apply cleanly and in
> the right order.

No problem. Here's the patch against 2.6.18


> FT> In my experiments, the ring buffer interface provides 10% better
> FT> write performance with disktest benchmark, though dbench gives
> FT> comparable performances (about 340 MB/s).
> 
> This is good to hear.  I am interested in testing it in some of my
> real-life situations where performance is slower due to the high
> latency.  This mostly affects the boot time of Xen guests.
> 
> I have added kernel caching back into my local version (which only
> adds 200 lines).  It improves Xen guest boot performance
> significantly, but does not affect dbench performance.  I will be
> interested to see what kind of performance I can get from your
> ringbuffer version, as well as possibly a combination of the two.

I see. I'm looking forward to the results. Then I'll send some other
patches.

---
From 615787c8a3a716189d6ece9334c451ca9d0d5037 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 27 Oct 2006 23:27:28 +0900
Subject: [PATCH] dm-userspace: use ring buffer instead of system call

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/Kconfig                |    6 
 drivers/md/Makefile               |    2 
 drivers/md/dm-user.h              |  158 ++++++++
 drivers/md/dm-userspace-chardev.c |  777 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm-userspace.c         |  563 +++++++++++++++++++++++++++
 include/linux/dm-userspace.h      |  122 ++++++
 6 files changed, 1628 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index bf869ed..714b3b3 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -223,6 +223,12 @@ config DM_SNAPSHOT
        ---help---
          Allow volume managers to take writable snapshots of a device.
 
+config DM_USERSPACE
+       tristate "Userspace target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       ---help---
+	 A target that provides a userspace interface to device-mapper
+
 config DM_MIRROR
        tristate "Mirror target (EXPERIMENTAL)"
        depends on BLK_DEV_DM && EXPERIMENTAL
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 34957a6..a123456 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -14,6 +14,7 @@ raid456-objs	:= raid5.o raid6algos.o rai
 		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
 		   raid6altivec8.o \
 		   raid6mmx.o raid6sse1.o raid6sse2.o
+dm-user-objs    := dm-userspace.o dm-userspace-chardev.o
 hostprogs-y	:= mktables
 
 # Note: link order is important.  All raid personalities
@@ -36,6 +37,7 @@ obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_USERSPACE)      += dm-user.o
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
diff --git a/drivers/md/dm-user.h b/drivers/md/dm-user.h
new file mode 100644
index 0000000..f1792ec
--- /dev/null
+++ b/drivers/md/dm-user.h
@@ -0,0 +1,158 @@
+/*
+ * Copyright (C) International Business Machines Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef __DM_USER_H
+#define __DM_USER_H
+
+#include <linux/hardirq.h>
+
+#define DMU_KEY_LEN 256
+
+extern struct target_type userspace_target;
+extern mempool_t *request_pool;
+extern dev_t dmu_dev;
+extern spinlock_t devices_lock;
+extern struct list_head devices;
+
+#define DMU_CP_HASH 1024
+
+/*
+ * A block device that we can send bios to
+ */
+struct target_device {
+	struct list_head list;        /* Our place in the targets list      */
+	struct block_device *bdev;    /* The target block_device            */
+	struct kref users;            /* Self-destructing reference count   */
+};
+
+/*
+ * A dm-userspace device, which consists of multiple targets sharing a
+ * common key
+ */
+struct dmu_device {
+	struct list_head list;        /* Our place in the devices list     */
+
+	spinlock_t lock;              /* Protects all the fields below     */
+
+	/* We need to protect the TX list with a separate lock that is
+	 * always used with IRQs disabled because it is locked from
+	 * inside the endio function
+	 */
+	spinlock_t tx_lock;
+	struct list_head tx_requests; /* Requests to send to userspace     */
+
+	struct list_head rx_requests; /* Requests waiting for reply        */
+
+	struct semaphore cp_sem;      /* Protection for cp_requests        */
+	struct list_head cp_requests; /* Requests waiting to be copied     */
+
+	/* Accounting */
+	atomic_t t_reqs;              /* Waiting to be sent to userspace   */
+	atomic_t r_reqs;              /* Waiting for a response from uspace*/
+	atomic_t f_reqs;              /* Submitted, waiting for endio      */
+	atomic_t total;               /* Total requests allocated          */
+
+	atomic_t idcounter;           /* Counter for making request IDs    */
+
+	struct list_head target_devs; /* List of devices we can target     */
+
+	void *transport_private;      /* Private data for userspace comms  */
+
+	char key[DMU_KEY_LEN];        /* Unique name string for device     */
+	struct kref users;            /* Self-destructing reference count  */
+
+	wait_queue_head_t lowmem;     /* To block while waiting for memory */
+
+	uint64_t block_size;          /* Block size for this device        */
+	uint64_t block_mask;          /* Mask for offset in block          */
+	unsigned int block_shift;     /* Shift to convert to/from block    */
+
+	struct kcopyd_client *kcopy;  /* Interface to kcopyd               */
+};
+
+struct dmu_request {
+	struct list_head list;        /* Our place on the request queue    */
+	struct list_head copy;        /* Our place on the copy list        */
+	struct dmu_device *dev;       /* The DMU device that owns us       */
+
+	int type;                     /* Type of request                   */
+	uint32_t flags;               /* Attribute flags                   */
+	uint64_t id;                  /* Unique ID for sync with userspace */
+	union {
+		uint64_t block;       /* The block in question             */
+	} u;
+
+	struct list_head deps;        /* Requests depending on this one    */
+	struct bio *bio;              /* The bio this request represents   */
+
+	struct work_struct task;      /* Async task to run for this req    */
+
+	struct dmu_msg_map_response response; /* FIXME: Clean this up      */
+};
+
+
+extern void add_tx_request(struct dmu_device *dev, struct dmu_request *req);
+extern void endio_worker(void *data);
+
+/* Find and grab a reference to a target device */
+struct target_device *find_target(struct dmu_device *dev,
+				  dev_t devno);
+/* Character device transport functions */
+int register_chardev_transport(struct dmu_device *dev);
+void unregister_chardev_transport(struct dmu_device *dev);
+int init_chardev_transport(void);
+void cleanup_chardev_transport(void);
+void write_chardev_transport_info(struct dmu_device *dev,
+				  char *buf, unsigned int maxlen);
+
+/* Return the block number for @sector */
+static inline u64 dmu_block(struct dmu_device *dev,
+			    sector_t sector)
+{
+	return sector >> dev->block_shift;
+}
+
+/* Return the sector offset in a block for @sector */
+static inline u64 dmu_sector_offset(struct dmu_device *dev,
+				    sector_t sector)
+{
+	return sector & dev->block_mask;
+}
+
+/* Return the starting sector for @block */
+static inline u64 dmu_sector(struct dmu_device *dev,
+			     uint64_t block)
+{
+	return block << dev->block_shift;
+}
+
+/* Increase the usage count for @dev */
+static inline void get_dev(struct dmu_device *dev)
+{
+	kref_get(&dev->users);
+}
+
+/* Decrease the usage count for @dev */
+void destroy_dmu_device(struct kref *ref);
+static inline void put_dev(struct dmu_device *dev)
+{
+	kref_put(&dev->users, destroy_dmu_device);
+}
+
+#endif
diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
new file mode 100644
index 0000000..4478a97
--- /dev/null
+++ b/drivers/md/dm-userspace-chardev.c
@@ -0,0 +1,777 @@
+/*
+ * Copyright (C) International Business Machines Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * (C) 2006 FUJITA Tomonori <tomof@acm.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/spinlock.h>
+#include <linux/blkdev.h>
+#include <linux/mempool.h>
+#include <linux/dm-userspace.h>
+#include <linux/list.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/poll.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <asm/uaccess.h>
+
+#include "dm.h"
+#include "dm-bio-list.h"
+#include "kcopyd.h"
+#include "dm-user.h"
+
+#define DM_MSG_PREFIX "dm-userspace"
+
+/* This allows for a cleaner separation between the dm-userspace
+ * device-mapper target, and the userspace transport used.  Right now,
+ * only a chardev transport exists, but it's possible that there could
+ * be more in the future
+ */
+struct dmu_ring {
+	u32 r_idx;
+	unsigned long r_pages[DMU_RING_PAGES];
+	spinlock_t r_lock;
+};
+
+struct chardev_transport {
+	struct cdev cdev;
+	dev_t ctl_dev;
+	struct dmu_device *parent;
+
+	struct dmu_ring tx;
+	struct dmu_ring rx;
+
+	struct task_struct *tx_task;
+	struct task_struct *rx_task;
+
+	wait_queue_head_t tx_wqueue;
+	wait_queue_head_t rx_wqueue;
+	wait_queue_head_t poll_wait;
+};
+
+static inline void dmu_ring_idx_inc(struct dmu_ring *r)
+{
+	if (r->r_idx == DMU_MAX_EVENTS - 1)
+		r->r_idx = 0;
+	else
+		r->r_idx++;
+}
+
+static struct dmu_msg *dmu_head_msg(struct dmu_ring *r, u32 idx)
+{
+	u32 pidx, off;
+
+	pidx = idx / DMU_EVENT_PER_PAGE;
+	off = idx % DMU_EVENT_PER_PAGE;
+
+	return (struct dmu_msg *)
+		(r->r_pages[pidx] + sizeof(struct dmu_msg) * off);
+}
+
+static struct dmu_request *find_rx_request(struct dmu_device *dev,
+					   uint64_t id)
+{
+	struct dmu_request *req, *next, *match = NULL;
+
+	spin_lock(&dev->lock);
+	list_for_each_entry_safe(req, next, &dev->rx_requests, list) {
+		if (req->id == id) {
+			list_del_init(&req->list);
+			match = req;
+			atomic_dec(&dev->r_reqs);
+			break;
+		}
+	}
+	spin_unlock(&dev->lock);
+
+	return match;
+}
+
+static int have_pending_requests(struct dmu_device *dev)
+{
+	return atomic_read(&dev->t_reqs) != 0;
+}
+
+static void send_userspace_message(struct dmu_msg *msg,
+				   struct dmu_request *req)
+{
+	memset(msg, 0, sizeof(*msg));
+
+	msg->hdr.id = req->id;
+
+	switch (req->type) {
+	case DM_USERSPACE_MAP_BLOCK_REQ:
+		msg->hdr.msg_type = req->type;
+		msg->payload.map_req.org_block = req->u.block;
+		dmu_cpy_flag(&msg->payload.map_req.flags,
+			     req->flags, DMU_FLAG_WR);
+		break;
+
+	case DM_USERSPACE_MAP_DONE:
+		msg->hdr.msg_type = DM_USERSPACE_MAP_DONE;
+		msg->payload.map_done.id_of_op = req->id;
+		msg->payload.map_done.org_block = req->u.block;
+		dmu_cpy_flag(&msg->payload.map_done.flags,
+			     req->flags, DMU_FLAG_WR);
+		break;
+
+	default:
+		DMWARN("Unknown outgoing message type %i", req->type);
+	}
+
+	/* If this request is not on a list (the rx_requests list),
+	 * then it needs to be freed after sending
+	 */
+	if (list_empty(&req->list)) {
+ 		INIT_WORK(&req->task, endio_worker, req);
+		schedule_work(&req->task);
+	}
+}
+
+static void add_rx_request(struct dmu_request *req)
+{
+	spin_lock(&req->dev->lock);
+	list_add_tail(&req->list, &req->dev->rx_requests);
+	atomic_inc(&req->dev->r_reqs);
+	spin_unlock(&req->dev->lock);
+}
+
+struct dmu_request *pluck_next_request(struct dmu_device *dev)
+{
+	struct dmu_request *req = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
+	if (!list_empty(&dev->tx_requests)) {
+		req = list_entry(dev->tx_requests.next,
+				 struct dmu_request, list);
+		list_del_init(&req->list);
+
+		atomic_dec(&dev->t_reqs);
+	}
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+
+	if (req && ((req->type == DM_USERSPACE_MAP_BLOCK_REQ) ||
+		    (req->type == DM_USERSPACE_MAP_DONE)))
+		add_rx_request(req);
+
+	return req;
+}
+
+static struct dmu_msg *get_tx_msg(struct dmu_ring *ring)
+{
+	struct dmu_msg *msg;
+
+	spin_lock(&ring->r_lock);
+	msg = dmu_head_msg(ring, ring->r_idx);
+	if (msg->hdr.status)
+		msg = NULL;
+	else
+		dmu_ring_idx_inc(ring);
+	spin_unlock(&ring->r_lock);
+
+	return msg;
+}
+
+static void send_tx_request(struct dmu_msg *msg, struct dmu_request *req)
+{
+	struct chardev_transport *t = req->dev->transport_private;
+
+	send_userspace_message(msg, req);
+	msg->hdr.status = 1;
+	mb();
+	flush_dcache_page(virt_to_page(msg));
+	wake_up_interruptible(&t->poll_wait);
+}
+
+/* Add a request to a device's request queue */
+void add_tx_request(struct dmu_device *dev, struct dmu_request *req)
+{
+	unsigned long flags;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->tx;
+	struct dmu_msg *msg;
+
+	BUG_ON(!list_empty(&req->list));
+
+	msg = get_tx_msg(ring);
+
+	if (msg) {
+		add_rx_request(req);
+		send_tx_request(msg, req);
+	} else {
+		spin_lock_irqsave(&dev->tx_lock, flags);
+		list_add_tail(&req->list, &dev->tx_requests);
+		atomic_inc(&dev->t_reqs);
+		spin_unlock_irqrestore(&dev->tx_lock, flags);
+
+		wake_up_interruptible(&t->tx_wqueue);
+	}
+}
+
+static int dmu_txd(void *data)
+{
+
+	struct dmu_device *dev = data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->tx;
+	struct dmu_request *req = NULL;
+	struct dmu_msg *msg;
+
+	while (!kthread_should_stop()) {
+		msg = dmu_head_msg(ring, ring->r_idx);
+
+		wait_event_interruptible(t->tx_wqueue,
+					 (!msg->hdr.status &&
+					  have_pending_requests(dev)) ||
+					 kthread_should_stop());
+
+		if (kthread_should_stop())
+			break;
+
+		msg = get_tx_msg(ring);
+		if (!msg)
+			continue;
+
+		req = pluck_next_request(dev);
+		BUG_ON(!req);
+
+		send_tx_request(msg, req);
+	}
+
+	return 0;
+}
+
+static struct dmu_request *pluck_dep_req(struct dmu_request *req)
+{
+	struct dmu_request *dreq = NULL;
+
+	if (list_empty(&req->deps)) {
+		/* Delete from cp_requests */
+		list_del_init(&req->copy);
+	} else {
+		/* Get next dependent request */
+		dreq = list_entry(req->deps.next, struct dmu_request, list);
+		list_del_init(&dreq->list);
+	}
+
+	return dreq;
+}
+
+static void flush_block(int read_err, unsigned int write_err, void *data)
+{
+	struct dmu_request *req = data;
+	struct dmu_request *dreq;
+	uint64_t id = req->id;
+
+	if (read_err || write_err) {
+		DMERR("Failed to copy block!");
+		bio_io_error(req->bio, req->bio->bi_size);
+		while ((dreq = pluck_dep_req(req))) {
+			bio_io_error(dreq->bio, dreq->bio->bi_size);
+		}
+		return;
+	}
+
+	atomic_inc(&req->dev->f_reqs);
+	generic_make_request(req->bio);
+
+	down(&req->dev->cp_sem);
+	while ((dreq = pluck_dep_req(req))) {
+		if (id > dreq->id) {
+			printk(KERN_EMERG "Flushing %llu after %llu\n",
+			       (unsigned long long) dreq->id,
+			       (unsigned long long) id);
+		}
+		id = dreq->id;
+		atomic_inc(&req->dev->f_reqs);
+		generic_make_request(dreq->bio);
+	}
+	up(&req->dev->cp_sem);
+}
+
+static void copy_block(struct dmu_device *dev,
+		       struct block_device *src_dev,
+		       struct block_device *dst_dev,
+		       struct dmu_request *req,
+		       uint64_t org_block,
+		       uint64_t new_block,
+		       int64_t offset)
+{
+	struct io_region src, dst;
+
+	src.bdev = src_dev;
+	src.sector = dmu_sector(dev, org_block);
+	src.count = dev->block_size;
+
+	dst.bdev = dst_dev;
+	dst.sector = dmu_sector(dev, new_block);
+	dst.sector += offset;
+	dst.count = dev->block_size;
+
+	kcopyd_copy(dev->kcopy, &src, 1, &dst, 0, flush_block, req);
+}
+
+/*
+ * Queues @req with a waiting request to the same block, if one
+ * exists.  Returns nonzero if queued.
+ */
+static int maybe_queue_dependent_request(struct dmu_request *req,
+					 int is_copy_first)
+{
+	struct dmu_request *dreq = NULL;
+	int found = 0;
+
+	BUG_ON(!list_empty(&req->list));
+
+	down(&req->dev->cp_sem);
+
+	list_for_each_entry(dreq, &req->dev->cp_requests, copy) {
+		if (req->u.block == dreq->u.block) {
+			list_add_tail(&req->list, &dreq->deps);
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found && is_copy_first) {
+		BUG_ON(!list_empty(&req->copy));
+		list_add(&req->copy, &req->dev->cp_requests);
+	}
+
+	up(&req->dev->cp_sem);
+
+	return found;
+}
+
+static void map_worker(void *data)
+{
+	struct dmu_request *req = data;
+	struct dmu_msg_map_response *msg = &req->response;
+	struct dmu_device *dev = req->dev;
+	struct target_device *src_dev, *dst_dev;
+	int need_copy = dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST);
+
+	if (need_copy) {
+		src_dev = find_target(dev, MKDEV(msg->src_maj, msg->src_min));
+		if (!src_dev) {
+			DMERR("Failed to find src device %i:%i\n",
+			      msg->src_maj, msg->src_min);
+			goto fail;
+		}
+	} else
+		src_dev = NULL;
+
+	dst_dev = find_target(dev, MKDEV(msg->dst_maj, msg->dst_min));
+	if (!dst_dev) {
+		DMERR("Failed to find dest device %i:%i\n",
+		      msg->dst_maj, msg->dst_min);
+		goto fail;
+	}
+
+	/* Remap the bio */
+	req->bio->bi_sector = dmu_sector(dev, msg->new_block) +
+		dmu_sector_offset(dev, req->bio->bi_sector) +
+		msg->offset;
+	req->bio->bi_bdev = dst_dev->bdev;
+
+	dmu_cpy_flag(&req->flags, msg->flags, DMU_FLAG_SYNC);
+
+	if (!maybe_queue_dependent_request(req, need_copy)) {
+		if (need_copy)
+			copy_block(dev, src_dev->bdev, dst_dev->bdev, req,
+				   req->u.block, msg->new_block,
+				   msg->offset);
+		else
+			flush_block(0, 0, req);
+	}
+
+	return;
+
+ fail:
+	bio_io_error(req->bio, req->bio->bi_size);
+}
+
+static void do_map_bio(struct dmu_device *dev,
+		       struct dmu_msg_map_response *msg)
+{
+	struct dmu_request *req;
+
+	req = find_rx_request(dev, msg->id_of_req);
+	if (!req) {
+		DMERR("Unable to complete unknown map: %llu\n",
+		      (unsigned long long) msg->id_of_req);
+		return;
+	}
+
+	memcpy(&req->response, msg, sizeof(req->response));
+
+	INIT_WORK(&req->task, map_worker, req);
+	schedule_work(&req->task);
+}
+
+static void do_map_done(struct dmu_device *dev, uint64_t id_of_op, int fail)
+{
+	struct dmu_request *req;
+
+	req = find_rx_request(dev, id_of_op);
+	if (!req) {
+		DMERR("Unable to complete unknown request: %llu\n",
+		      (unsigned long long) id_of_op);
+		return;
+	}
+
+	dmu_clr_flag(&req->flags, DMU_FLAG_SYNC);
+
+	req->bio->bi_end_io(req->bio, req->bio->bi_size, fail);
+}
+
+static void do_map_failed(struct dmu_device *dev, uint64_t id_of_op)
+{
+	struct dmu_request *req;
+
+	req = find_rx_request(dev, id_of_op);
+	if (!req) {
+		DMERR("Unable to fail unknown request: %llu\n",
+		      (unsigned long long) id_of_op);
+		return;
+	}
+
+	DMERR("Userspace failed to map id %llu (sector %llu)",
+	      (unsigned long long) id_of_op,
+	      (unsigned long long) req->bio->bi_sector);
+
+	bio_io_error(req->bio, req->bio->bi_size);
+
+	mempool_free(req, request_pool);
+}
+
+static int dmu_rxd(void *data)
+{
+	struct dmu_device *dev = (struct dmu_device *) data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->rx;
+	struct dmu_msg *msg;
+
+	while (!kthread_should_stop()) {
+		msg = dmu_head_msg(ring, ring->r_idx);
+		/* do we need this? */
+		flush_dcache_page(virt_to_page(msg));
+
+		wait_event_interruptible(t->rx_wqueue, msg->hdr.status ||
+					kthread_should_stop());
+
+		if (kthread_should_stop())
+			break;
+
+		switch (msg->hdr.msg_type) {
+		case DM_USERSPACE_MAP_BLOCK_RESP:
+			do_map_bio(dev, &msg->payload.map_rsp);
+			break;
+
+		case DM_USERSPACE_MAP_FAILED:
+			do_map_failed(dev, msg->payload.map_rsp.id_of_req);
+			break;
+
+		case DM_USERSPACE_MAP_DONE:
+			do_map_done(dev, msg->payload.map_done.id_of_op, 0);
+			break;
+
+		case DM_USERSPACE_MAP_DONE_FAILED:
+			do_map_done(dev, msg->payload.map_done.id_of_op, 1);
+			break;
+
+		default:
+			DMWARN("Unknown incoming request type: %i",
+			       msg->hdr.msg_type);
+		}
+
+		msg->hdr.status = 0;
+		dmu_ring_idx_inc(ring);
+	}
+
+	return 0;
+}
+
+ssize_t dmu_ctl_write(struct file *file, const char __user *buffer,
+		      size_t size, loff_t *offset)
+{
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+
+	wake_up(&t->tx_wqueue);
+	wake_up(&t->rx_wqueue);
+	return size;
+}
+
+static void dmu_ring_free(struct dmu_ring *r)
+{
+	int i;
+	for (i = 0; i < DMU_RING_PAGES; i++) {
+		if (!r->r_pages[i])
+			break;
+		free_page(r->r_pages[i]);
+		r->r_pages[i] = 0;
+	}
+}
+
+static int dmu_ring_alloc(struct dmu_ring *r)
+{
+	int i;
+
+	r->r_idx = 0;
+	spin_lock_init(&r->r_lock);
+
+	for (i = 0; i < DMU_RING_PAGES; i++) {
+		r->r_pages[i] = get_zeroed_page(GFP_KERNEL);
+		if (!r->r_pages[i])
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+int dmu_ctl_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct chardev_transport *t;
+	struct dmu_device *dev;
+
+        if (!capable(CAP_SYS_ADMIN))
+                return -EACCES;
+
+	t = container_of(inode->i_cdev, struct chardev_transport, cdev);
+	dev = t->parent;
+
+	init_waitqueue_head(&t->poll_wait);
+	init_waitqueue_head(&t->tx_wqueue);
+	init_waitqueue_head(&t->rx_wqueue);
+
+	ret = dmu_ring_alloc(&t->tx);
+	if (ret)
+		return -ENOMEM;
+
+	ret = dmu_ring_alloc(&t->rx);
+	if (ret)
+		goto free_tx;
+
+	t->tx_task = kthread_run(dmu_txd, dev, "%s_tx", DM_MSG_PREFIX);
+	if (!t->tx_task)
+		goto free_rx;
+
+	t->rx_task = kthread_run(dmu_rxd, dev, "%s_rx", DM_MSG_PREFIX);
+	if (!t->rx_task) {
+		ret = -ENOMEM;
+		goto destroy_tx_task;
+	}
+
+	get_dev(dev);
+
+	file->private_data = dev;
+
+	return 0;
+destroy_tx_task:
+	kthread_stop(t->tx_task);
+free_rx:
+	dmu_ring_free(&t->rx);
+free_tx:
+	dmu_ring_free(&t->tx);
+	return ret;
+}
+
+int dmu_ctl_release(struct inode *inode, struct file *file)
+{
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+
+	kthread_stop(t->rx_task);
+	kthread_stop(t->tx_task);
+
+	dmu_ring_free(&t->rx);
+	dmu_ring_free(&t->tx);
+
+	put_dev(dev);
+
+	return 0;
+}
+
+unsigned dmu_ctl_poll(struct file *file, poll_table *wait)
+{
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->tx;
+	struct dmu_msg *msg;
+	unsigned mask = 0;
+	u32 idx;
+
+	poll_wait(file, &t->poll_wait, wait);
+
+	spin_lock(&ring->r_lock);
+
+	idx = ring->r_idx ? ring->r_idx - 1 : DMU_MAX_EVENTS - 1;
+	msg = dmu_head_msg(ring, idx);
+	if (msg->hdr.status)
+		mask |= POLLIN | POLLRDNORM;
+
+	spin_unlock(&ring->r_lock);
+
+	return mask;
+}
+
+static int dmu_ring_map(struct vm_area_struct *vma, unsigned long addr,
+			struct dmu_ring *ring)
+{
+	int i, err;
+
+	for (i = 0; i < DMU_RING_PAGES; i++) {
+		struct page *page = virt_to_page(ring->r_pages[i]);
+		err = vm_insert_page(vma, addr, page);
+		if (err)
+			return err;
+		addr += PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+static int dmu_ctl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+	unsigned long addr;
+	int err;
+
+	if (vma->vm_pgoff)
+		return -EINVAL;
+
+	if (vma->vm_end - vma->vm_start != DMU_RING_SIZE * 2) {
+		DMERR("mmap size must be %lu, not %lu \n",
+			DMU_RING_SIZE * 2, vma->vm_end - vma->vm_start);
+		return -EINVAL;
+	}
+
+	addr = vma->vm_start;
+	err = dmu_ring_map(vma, addr, &t->tx);
+	if (err)
+		return err;
+	err = dmu_ring_map(vma, addr + DMU_RING_SIZE, &t->rx);
+
+	return err;
+}
+
+static struct file_operations ctl_fops = {
+	.open    = dmu_ctl_open,
+	.release = dmu_ctl_release,
+	.write   = dmu_ctl_write,
+	.mmap    = dmu_ctl_mmap,
+	.poll    = dmu_ctl_poll,
+	.owner   = THIS_MODULE,
+};
+
+static int get_free_minor(void)
+{
+	struct dmu_device *dev;
+	int minor = 0;
+
+	spin_lock(&devices_lock);
+
+	while (1) {
+		list_for_each_entry(dev, &devices, list) {
+			struct chardev_transport *t = dev->transport_private;
+			if (MINOR(t->ctl_dev) == minor)
+				goto dupe;
+		}
+		break;
+	dupe:
+		minor++;
+	}
+
+	spin_unlock(&devices_lock);
+
+	return minor;
+}
+
+int register_chardev_transport(struct dmu_device *dev)
+{
+	struct chardev_transport *t;
+	int ret;
+
+	dev->transport_private = kmalloc(sizeof(struct chardev_transport),
+					 GFP_KERNEL);
+	t = dev->transport_private;
+
+	if (!t) {
+		DMERR("Failed to allocate chardev transport");
+		goto bad;
+	}
+
+	t->ctl_dev = MKDEV(MAJOR(dmu_dev), get_free_minor());
+	t->parent = dev;
+
+	cdev_init(&t->cdev, &ctl_fops);
+	t->cdev.owner = THIS_MODULE;
+	t->cdev.ops = &ctl_fops;
+
+	ret = cdev_add(&t->cdev, t->ctl_dev, 1);
+	if (ret < 0) {
+		DMERR("Failed to register control device %d:%d",
+		       MAJOR(t->ctl_dev), MINOR(t->ctl_dev));
+		goto bad;
+	}
+
+	return 1;
+
+ bad:
+	kfree(t);
+	return 0;
+}
+
+void unregister_chardev_transport(struct dmu_device *dev)
+{
+	struct chardev_transport *t = dev->transport_private;
+
+	cdev_del(&t->cdev);
+	kfree(t);
+}
+
+int init_chardev_transport(void)
+{
+	int r;
+
+	r = alloc_chrdev_region(&dmu_dev, 0, 10, "dm-userspace");
+	if (r) {
+		DMERR("Failed to allocate chardev region");
+		return 0;
+	} else
+		return 1;
+}
+
+void cleanup_chardev_transport(void)
+{
+	unregister_chrdev_region(dmu_dev, 10);
+}
+
+void write_chardev_transport_info(struct dmu_device *dev,
+			char *buf, unsigned int maxlen)
+{
+	struct chardev_transport *t = dev->transport_private;
+
+	snprintf(buf, maxlen, "%x:%x",
+		 MAJOR(t->ctl_dev), MINOR(t->ctl_dev));
+}
diff --git a/drivers/md/dm-userspace.c b/drivers/md/dm-userspace.c
new file mode 100644
index 0000000..b6b8320
--- /dev/null
+++ b/drivers/md/dm-userspace.c
@@ -0,0 +1,563 @@
+/*
+ * Copyright (C) International Business Machines Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/types.h>
+#include <linux/poll.h>
+
+#include <linux/dm-userspace.h>
+
+#include "dm.h"
+#include "dm-bio-list.h"
+#include "kcopyd.h"
+#include "dm-user.h"
+
+#define DMU_COPY_PAGES     256
+
+#define DM_MSG_PREFIX     "dm-userspace"
+
+static kmem_cache_t *request_cache;
+mempool_t *request_pool;
+
+spinlock_t devices_lock;
+LIST_HEAD(devices);
+
+/* Device number for the control device */
+dev_t dmu_dev;
+
+void endio_worker(void *data)
+{
+	struct dmu_request *req = data;
+	struct dmu_device *dev = req->dev;
+
+	spin_lock(&dev->lock);
+	if (list_empty(&req->list) && list_empty(&req->copy)) {
+		mempool_free(req, request_pool);
+		atomic_dec(&dev->f_reqs);
+		atomic_dec(&dev->total);
+		wake_up_interruptible(&dev->lowmem);
+	} else {
+		PREPARE_WORK(&req->task, endio_worker, req);
+		schedule_work(&req->task);
+	}
+	spin_unlock(&dev->lock);
+}
+
+/* Return an already-bound target device */
+struct target_device *find_target(struct dmu_device *dev,
+					 dev_t devno)
+{
+	struct target_device *target, *match = NULL;
+
+	spin_lock(&dev->lock);
+	list_for_each_entry(target, &dev->target_devs, list) {
+		if (target->bdev->bd_dev == devno) {
+			match = target;
+			break;
+		}
+	}
+	spin_unlock(&dev->lock);
+
+	return match;
+}
+
+/* Find a new target device and bind it to our device */
+static struct target_device *get_target(struct dmu_device *dev,
+					dev_t devno)
+{
+	struct target_device *target;
+	struct block_device *bdev;
+
+	target = find_target(dev, devno);
+	if (target)
+		return target;
+
+	bdev = open_by_devnum(devno, FMODE_READ | FMODE_WRITE);
+	if (IS_ERR(bdev)) {
+		DMERR("Unable to lookup device %x", devno);
+		return NULL;
+	}
+
+	target = kmalloc(sizeof(*target), GFP_KERNEL);
+	if (!target) {
+		DMERR("Unable to alloc new target device");
+		return NULL;
+	}
+
+	target->bdev = bdev;
+	INIT_LIST_HEAD(&target->list);
+
+	if (in_interrupt())
+		printk("%s in irq\n", __FUNCTION__);
+
+	spin_lock(&dev->lock);
+	list_add_tail(&target->list, &dev->target_devs);
+	spin_unlock(&dev->lock);
+
+	return target;
+}
+
+/* Caller must hold dev->lock */
+static void put_target(struct dmu_device *dev,
+		       struct target_device *target)
+{
+	list_del(&target->list);
+
+	bd_release(target->bdev);
+	blkdev_put(target->bdev);
+
+	kfree(target);
+}
+
+void destroy_dmu_device(struct kref *ref)
+{
+	struct dmu_device *dev;
+	struct list_head *cursor, *next;
+
+	dev = container_of(ref, struct dmu_device, users);
+
+	spin_lock(&devices_lock);
+	list_del(&dev->list);
+	spin_unlock(&devices_lock);
+
+	list_for_each_safe(cursor, next, &dev->target_devs) {
+		struct target_device *target;
+
+		target = list_entry(cursor,
+				    struct target_device,
+				    list);
+
+		put_target(dev, target);
+	}
+
+	list_for_each_safe(cursor, next, &dev->tx_requests) {
+		struct dmu_request *req;
+
+		req = list_entry(cursor,
+				 struct dmu_request,
+				 list);
+
+		DMERR("Failing unsent bio");
+		bio_io_error(req->bio, req->bio->bi_size);
+
+		list_del(&req->list);
+
+		mempool_free(req, request_pool);
+	}
+
+	list_for_each_safe(cursor, next, &dev->rx_requests) {
+		struct dmu_request *req;
+
+		req = list_entry(cursor,
+				 struct dmu_request,
+				 list);
+
+		DMERR("Failing bio");
+		req->flags = 0;
+		bio_io_error(req->bio, req->bio->bi_size);
+
+		list_del(&req->list);
+
+		mempool_free(req, request_pool);
+	}
+
+	list_for_each_safe(cursor, next, &dev->cp_requests) {
+		struct dmu_request *req;
+
+		req = list_entry(cursor,
+				 struct dmu_request,
+				 list);
+
+		DMERR("Failing bio");
+		req->flags = 0;
+		bio_io_error(req->bio, req->bio->bi_size);
+
+		list_del(&req->list);
+
+		mempool_free(req, request_pool);
+	}
+
+	kcopyd_client_destroy(dev->kcopy);
+	unregister_chardev_transport(dev);
+
+	kfree(dev);
+}
+
+static int init_dmu_device(struct dmu_device *dev, u32 block_size)
+{
+	int ret;
+
+	init_waitqueue_head(&dev->lowmem);
+	INIT_LIST_HEAD(&dev->list);
+	INIT_LIST_HEAD(&dev->target_devs);
+	kref_init(&dev->users);
+	spin_lock_init(&dev->lock);
+	spin_lock_init(&dev->tx_lock);
+
+	INIT_LIST_HEAD(&dev->tx_requests);
+	INIT_LIST_HEAD(&dev->rx_requests);
+	INIT_LIST_HEAD(&dev->cp_requests);
+
+	dev->block_size  = block_size;
+	dev->block_mask  = block_size - 1;
+	dev->block_shift = ffs(block_size) - 1;
+
+	atomic_set(&dev->t_reqs, 0);
+	atomic_set(&dev->r_reqs, 0);
+	atomic_set(&dev->f_reqs, 0);
+	atomic_set(&dev->total, 0);
+	atomic_set(&dev->idcounter, 0);
+
+	init_MUTEX(&dev->cp_sem);
+
+	ret = kcopyd_client_create(DMU_COPY_PAGES, &dev->kcopy);
+	if (ret) {
+		DMERR("Failed to initialize kcopyd client");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct dmu_device *new_dmu_device(char *key,
+					 struct dm_target *ti,
+					 u32 block_size)
+{
+	struct dmu_device *dev;
+	int                ret;
+
+	dev = kmalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		DMERR("Failed to allocate new userspace device");
+		return NULL;
+	}
+
+	if (!init_dmu_device(dev, block_size))
+		goto bad1;
+
+	snprintf(dev->key, DMU_KEY_LEN, "%s", key);
+
+	ret = register_chardev_transport(dev);
+	if (!ret)
+		goto bad2;
+
+	spin_lock(&devices_lock);
+	list_add(&dev->list, &devices);
+	spin_unlock(&devices_lock);
+
+	return dev;
+
+ bad2:
+	put_dev(dev);
+ bad1:
+	kfree(dev);
+	DMERR("Failed to create device");
+	return NULL;
+}
+
+static struct dmu_device *find_dmu_device(const char *key)
+{
+	struct dmu_device *dev;
+	struct dmu_device *match = NULL;
+
+	spin_lock(&devices_lock);
+
+	list_for_each_entry(dev, &devices, list) {
+		spin_lock(&dev->lock);
+		if (strncmp(dev->key, key, DMU_KEY_LEN) == 0) {
+			match = dev;
+			spin_unlock(&dev->lock);
+			break;
+		}
+		spin_unlock(&dev->lock);
+	}
+
+	spin_unlock(&devices_lock);
+
+	return match;
+}
+
+static int dmu_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	uint64_t block_size;
+	struct dmu_device *dev;
+	char *device_key;
+	char *block_size_param;
+	int target_idx = 2;
+
+	if (argc < 3) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	device_key = argv[0];
+	block_size_param = argv[1];
+
+	block_size = simple_strtoul(block_size_param, NULL, 10) / 512;
+
+	dev = find_dmu_device(device_key);
+	if (!dev) {
+		dev = new_dmu_device(device_key, ti, block_size);
+		if (!dev) {
+			ti->error = "Failed to create device";
+			goto bad;
+		}
+	} else
+		get_dev(dev);
+
+	spin_lock(&dev->lock);
+	if (dev->block_size != block_size) {
+		ti->error = "Invalid block size";
+		goto bad;
+	}
+	spin_unlock(&dev->lock);
+
+	/* Resolve target devices */
+	do {
+		int maj, min;
+		sscanf(argv[target_idx], "%i:%i", &maj, &min);
+		if (!get_target(dev, MKDEV(maj, min))) {
+			DMERR("Failed to find target device %i:%i (%s)",
+			      maj, min, argv[target_idx]);
+			goto out;
+		}
+	} while (++target_idx < argc);
+
+	ti->private  = dev;
+	ti->split_io = block_size;
+
+	return 0;
+
+ bad:
+	if (dev)
+		spin_unlock(&dev->lock);
+ out:
+	if (dev)
+		put_dev(dev);
+
+	return -EINVAL;
+}
+
+static void dmu_dtr(struct dm_target *ti)
+{
+	struct dmu_device *dev = (struct dmu_device *) ti->private;
+
+	put_dev(dev);
+}
+
+static void init_req(struct dmu_device *dev,
+		     struct bio *bio,
+		     struct dmu_request *req)
+{
+	req->id = (uint64_t) atomic_add_return(1, &dev->idcounter);
+
+	req->type = DM_USERSPACE_MAP_BLOCK_REQ;
+	req->dev = dev;
+	req->bio = bio;
+	req->u.block = dmu_block(dev, bio->bi_sector);
+	req->flags = 0;
+	INIT_LIST_HEAD(&req->deps);
+	INIT_LIST_HEAD(&req->list);
+	INIT_LIST_HEAD(&req->copy);
+
+	if (bio_rw(bio))
+		dmu_set_flag(&req->flags, DMU_FLAG_WR);
+}
+
+static int dmu_map(struct dm_target *ti, struct bio *bio,
+		   union map_info *map_context)
+{
+	struct dmu_device *dev = (struct dmu_device *) ti->private;
+	struct dmu_request *req;
+
+	if (unlikely(bio_barrier(bio))) {
+		printk("Refusing bio barrier\n");
+		return -EOPNOTSUPP;
+	}
+
+	wait_event_interruptible(dev->lowmem,
+				 atomic_read(&dev->total) <= 20000);
+
+	req = mempool_alloc(request_pool, GFP_NOIO);
+	if (!req) {
+		DMERR("Failed to alloc request");
+		return -1;
+	}
+
+	atomic_inc(&dev->total);
+
+	map_context->ptr = req;
+
+	init_req(dev, bio, req);
+
+	add_tx_request(dev, req);
+
+	return 0;
+}
+
+static int dmu_status(struct dm_target *ti, status_type_t type,
+		      char *result, unsigned int maxlen)
+{
+	struct dmu_device *dev = (struct dmu_device *) ti->private;
+
+	/* FIXME: Remove after debug */
+	spin_lock(&dev->lock);
+	printk("Requests: %u t:%u r:%u f:%u (%c%c%c)\n",
+	       atomic_read(&dev->total),
+	       atomic_read(&dev->t_reqs),
+	       atomic_read(&dev->r_reqs),
+	       atomic_read(&dev->f_reqs),
+	       list_empty(&dev->tx_requests) ? ' ':'T',
+	       list_empty(&dev->rx_requests) ? ' ':'R',
+	       list_empty(&dev->cp_requests) ? ' ':'C');
+	spin_unlock(&dev->lock);
+
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		write_chardev_transport_info(dev, result, maxlen);
+		break;
+
+	case STATUSTYPE_TABLE:
+		snprintf(result, maxlen, "%s %llu",
+			 dev->key,
+			 (unsigned long long) dev->block_size * 512);
+		break;
+	}
+
+	return 0;
+}
+
+static int dmu_end_io(struct dm_target *ti, struct bio *bio,
+                        int error, union map_info *map_context)
+{
+	struct dmu_request *req = map_context->ptr;
+	int ret = 0;
+
+	if (error)
+		return -1;
+
+	if (dmu_get_flag(&req->flags, DMU_FLAG_SYNC)) {
+		req->type = DM_USERSPACE_MAP_DONE;
+		add_tx_request(req->dev, req);
+		ret = 1;
+	} else {
+		INIT_WORK(&req->task, endio_worker, req);
+		schedule_work(&req->task);
+	}
+
+	return ret;
+}
+
+struct target_type userspace_target = {
+	.name    = "userspace",
+	.version = {0, 1, 0},
+	.module  = THIS_MODULE,
+	.ctr     = dmu_ctr,
+	.dtr     = dmu_dtr,
+	.map     = dmu_map,
+	.status  = dmu_status,
+	.end_io  = dmu_end_io
+};
+
+int __init dm_userspace_init(void)
+{
+	int r = dm_register_target(&userspace_target);
+	if (r < 0) {
+		DMERR("Register failed %d", r);
+		return 0;
+	}
+
+	spin_lock_init(&devices_lock);
+
+	request_cache =
+		kmem_cache_create("dm-userspace-requests",
+				  sizeof(struct dmu_request),
+				  __alignof__ (struct dmu_request),
+				  0, NULL, NULL);
+	if (!request_cache) {
+		DMERR("Failed to allocate request cache");
+		goto bad;
+	}
+
+	request_pool = mempool_create(64,
+				      mempool_alloc_slab, mempool_free_slab,
+				      request_cache);
+	if (!request_pool) {
+		DMERR("Failed to allocate request pool");
+		goto bad2;
+	}
+
+	r = init_chardev_transport();
+	if (!r)
+		goto bad3;
+
+	return 1;
+
+ bad3:
+	mempool_destroy(request_pool);
+ bad2:
+	kmem_cache_destroy(request_cache);
+ bad:
+	dm_unregister_target(&userspace_target);
+
+	return 0;
+}
+
+void __exit dm_userspace_exit(void)
+{
+	int r;
+	struct list_head *cursor, *next;
+	struct dmu_device *dev;
+
+	spin_lock(&devices_lock);
+
+	list_for_each_safe(cursor, next, &devices) {
+		dev = list_entry(cursor, struct dmu_device, list);
+		list_del(cursor);
+		destroy_dmu_device(&dev->users);
+		DMERR("Destroying hanging device %s", dev->key);
+	}
+
+	spin_unlock(&devices_lock);
+
+	cleanup_chardev_transport();
+
+	mempool_destroy(request_pool);
+	kmem_cache_destroy(request_cache);
+
+	r = dm_unregister_target(&userspace_target);
+	if (r < 0)
+		DMERR("unregister failed %d", r);
+}
+
+module_init(dm_userspace_init);
+module_exit(dm_userspace_exit);
+
+MODULE_DESCRIPTION(DM_NAME " userspace target");
+MODULE_AUTHOR("Dan Smith");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/dm-userspace.h b/include/linux/dm-userspace.h
new file mode 100644
index 0000000..e249f51
--- /dev/null
+++ b/include/linux/dm-userspace.h
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) International Business Machines Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef __DM_USERSPACE_H
+#define __DM_USERSPACE_H
+
+#include <linux/types.h>
+
+/*
+ * Message Types
+ */
+#define DM_USERSPACE_MAP_BLOCK_REQ    1
+#define DM_USERSPACE_MAP_BLOCK_RESP   2
+#define DM_USERSPACE_MAP_FAILED       3
+#define DM_USERSPACE_MAP_DONE         4
+#define DM_USERSPACE_MAP_DONE_FAILED  5
+
+/*
+ * Flags and associated macros
+ */
+#define DMU_FLAG_VALID       1
+#define DMU_FLAG_WR          2
+#define DMU_FLAG_COPY_FIRST  4
+#define DMU_FLAG_SYNC        8
+
+static inline int dmu_get_flag(uint32_t *flags, uint32_t flag)
+{
+	return (*flags & flag) != 0;
+}
+
+static inline void dmu_set_flag(uint32_t *flags, uint32_t flag)
+{
+	*flags |= flag;
+}
+
+static inline void dmu_clr_flag(uint32_t *flags, uint32_t flag)
+{
+	*flags &= (~flag);
+}
+
+static inline void dmu_cpy_flag(uint32_t *flags, uint32_t src, uint32_t flag)
+{
+	*flags = (*flags & ~flag) | (src & flag);
+}
+
+/*
+ * This message header is sent in front of every message, in both
+ * directions
+ */
+struct dmu_msg_header {
+	uint64_t id;
+	uint32_t msg_type;
+	uint32_t payload_len;
+	uint32_t status;
+	uint32_t padding;
+};
+
+/* DM_USERSPACE_MAP_DONE
+ * DM_USERSPACE_MAP_DONE_FAILED
+ */
+struct dmu_msg_map_done {
+	uint64_t id_of_op;
+	uint64_t org_block;
+	uint32_t flags;
+};
+
+/* DM_USERSPACE_MAP_BLOCK_REQ */
+struct dmu_msg_map_request {
+	uint64_t org_block;
+
+	uint32_t flags;
+};
+
+/* DM_USERSPACE_MAP_BLOCK_RESP
+ * DM_USERSPACE_MAP_BLOCK_FAILED
+ */
+struct dmu_msg_map_response {
+	uint64_t new_block;
+	int64_t offset;
+
+	uint64_t id_of_req;
+	uint32_t flags;
+
+	uint32_t src_maj;
+	uint32_t src_min;
+
+	uint32_t dst_maj;
+	uint32_t dst_min;
+};
+
+/* A full message */
+struct dmu_msg {
+	struct dmu_msg_header hdr;
+	union {
+		struct dmu_msg_map_done map_done;
+		struct dmu_msg_map_request map_req;
+		struct dmu_msg_map_response map_rsp;
+	} payload;
+};
+
+#define DMU_RING_SIZE (1UL << 16)
+#define DMU_RING_PAGES (DMU_RING_SIZE >> PAGE_SHIFT)
+#define DMU_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct dmu_msg))
+#define DMU_MAX_EVENTS (DMU_EVENT_PER_PAGE * DMU_RING_PAGES)
+
+#endif
-- 
1.4.1
