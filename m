From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Wed, 25 Oct 2006 21:09:31 +0900
Message-ID: <20061025210931M.fujita.tomonori@lab.ntt.co.jp>
References: <20061025194412J.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061025194412J.fujita.tomonori@lab.ntt.co.jp>
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

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [dm-devel] [PATCH 1/2] dm-userspace: use ring buffer instead of	system call
Date: Wed, 25 Oct 2006 19:44:12 +0900

> This is the updated version of the previous patch posted on Sep 30.
> 
> http://www.redhat.com/archives/dm-devel/2006-September/msg00146.html
> 
> It's against on the top of the following patches:
> 
> http://www.redhat.com/archives/dm-devel/2006-September/msg00130.html
> http://www.redhat.com/archives/dm-devel/2006-September/msg00132.html
> http://www.redhat.com/archives/dm-devel/2006-September/msg00133.html
> 
> In my experiments, the ring buffer interface provides 10% better write
> performance with disktest benchmark, though dbench gives comparable
> performances (about 340 MB/s).

Oops. The previous patch has problems when removing the kernel
module. Here's the fixed version.

I've also uploaded the patch and userspace code at:

http://www.kernel.org/pub/linux/kernel/people/tomo/dmu/20061025/

---
Replace the read/write interface for kernel/user communication with
mmapped buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-user.h              |    4 
 drivers/md/dm-userspace-chardev.c |  371 ++++++++++++++++++++++++++++---------
 drivers/md/dm-userspace.c         |   19 --
 include/linux/dm-userspace.h      |    7 +
 4 files changed, 290 insertions(+), 111 deletions(-)

diff --git a/drivers/md/dm-user.h b/drivers/md/dm-user.h
index 06b251b..f1792ec 100644
--- a/drivers/md/dm-user.h
+++ b/drivers/md/dm-user.h
@@ -77,7 +77,6 @@ struct dmu_device {
 	char key[DMU_KEY_LEN];        /* Unique name string for device     */
 	struct kref users;            /* Self-destructing reference count  */
 
-	wait_queue_head_t wqueue;     /* To block while waiting for reqs   */
 	wait_queue_head_t lowmem;     /* To block while waiting for memory */
 
 	uint64_t block_size;          /* Block size for this device        */
@@ -108,6 +107,9 @@ struct dmu_request {
 };
 
 
+extern void add_tx_request(struct dmu_device *dev, struct dmu_request *req);
+extern void endio_worker(void *data);
+
 /* Find and grab a reference to a target device */
 struct target_device *find_target(struct dmu_device *dev,
 				  dev_t devno);
diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
index ee55ca8..4478a97 100644
--- a/drivers/md/dm-userspace-chardev.c
+++ b/drivers/md/dm-userspace-chardev.c
@@ -2,6 +2,8 @@
  * Copyright (C) International Business Machines Corp., 2006
  * Author: Dan Smith <danms@us.ibm.com>
  *
+ * (C) 2006 FUJITA Tomonori <tomof@acm.org>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; under version 2 of the License.
@@ -22,6 +24,7 @@ #include <linux/blkdev.h>
 #include <linux/mempool.h>
 #include <linux/dm-userspace.h>
 #include <linux/list.h>
+#include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
@@ -41,12 +44,47 @@ #define DM_MSG_PREFIX "dm-userspace"
  * only a chardev transport exists, but it's possible that there could
  * be more in the future
  */
+struct dmu_ring {
+	u32 r_idx;
+	unsigned long r_pages[DMU_RING_PAGES];
+	spinlock_t r_lock;
+};
+
 struct chardev_transport {
 	struct cdev cdev;
 	dev_t ctl_dev;
 	struct dmu_device *parent;
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
 };
 
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
 static struct dmu_request *find_rx_request(struct dmu_device *dev,
 					   uint64_t id)
 {
@@ -71,49 +109,48 @@ static int have_pending_requests(struct 
 	return atomic_read(&dev->t_reqs) != 0;
 }
 
-static int send_userspace_message(uint8_t __user *buffer,
-				  struct dmu_request *req)
+static void send_userspace_message(struct dmu_msg *msg,
+				   struct dmu_request *req)
 {
-	int ret = 0;
-	struct dmu_msg msg;
-
-	memset(&msg, 0, sizeof(msg));
+	memset(msg, 0, sizeof(*msg));
 
-	msg.hdr.id = req->id;
+	msg->hdr.id = req->id;
 
 	switch (req->type) {
 	case DM_USERSPACE_MAP_BLOCK_REQ:
-		msg.hdr.msg_type = req->type;
-		msg.payload.map_req.org_block = req->u.block;
-		dmu_cpy_flag(&msg.payload.map_req.flags,
+		msg->hdr.msg_type = req->type;
+		msg->payload.map_req.org_block = req->u.block;
+		dmu_cpy_flag(&msg->payload.map_req.flags,
 			     req->flags, DMU_FLAG_WR);
 		break;
 
 	case DM_USERSPACE_MAP_DONE:
-		msg.hdr.msg_type = DM_USERSPACE_MAP_DONE;
-		msg.payload.map_done.id_of_op = req->id;
-		msg.payload.map_done.org_block = req->u.block;
-		dmu_cpy_flag(&msg.payload.map_done.flags,
+		msg->hdr.msg_type = DM_USERSPACE_MAP_DONE;
+		msg->payload.map_done.id_of_op = req->id;
+		msg->payload.map_done.org_block = req->u.block;
+		dmu_cpy_flag(&msg->payload.map_done.flags,
 			     req->flags, DMU_FLAG_WR);
 		break;
 
 	default:
 		DMWARN("Unknown outgoing message type %i", req->type);
-		ret = 0;
 	}
 
-	if (copy_to_user(buffer, &msg, sizeof(msg)))
-		return -EFAULT;
-
-	ret = sizeof(msg);
-
 	/* If this request is not on a list (the rx_requests list),
 	 * then it needs to be freed after sending
 	 */
-	if (list_empty(&req->list))
-		mempool_free(req, request_pool);
+	if (list_empty(&req->list)) {
+ 		INIT_WORK(&req->task, endio_worker, req);
+		schedule_work(&req->task);
+	}
+}
 
-	return ret;
+static void add_rx_request(struct dmu_request *req)
+{
+	spin_lock(&req->dev->lock);
+	list_add_tail(&req->list, &req->dev->rx_requests);
+	atomic_inc(&req->dev->r_reqs);
+	spin_unlock(&req->dev->lock);
 }
 
 struct dmu_request *pluck_next_request(struct dmu_device *dev)
@@ -132,66 +169,94 @@ struct dmu_request *pluck_next_request(s
 	spin_unlock_irqrestore(&dev->tx_lock, flags);
 
 	if (req && ((req->type == DM_USERSPACE_MAP_BLOCK_REQ) ||
-		    (req->type == DM_USERSPACE_MAP_DONE))) {
-		spin_lock(&dev->lock);
-		list_add_tail(&req->list, &dev->rx_requests);
-		atomic_inc(&dev->r_reqs);
-		spin_unlock(&dev->lock);
-	}
+		    (req->type == DM_USERSPACE_MAP_DONE)))
+		add_rx_request(req);
 
 	return req;
 }
 
-ssize_t dmu_ctl_read(struct file *file, char __user *buffer,
-		     size_t size, loff_t *offset)
+static struct dmu_msg *get_tx_msg(struct dmu_ring *ring)
 {
+	struct dmu_msg *msg;
 
-	struct dmu_device *dev = (struct dmu_device *)file->private_data;
-	struct dmu_request *req = NULL;
-	int ret = 0, r;
+	spin_lock(&ring->r_lock);
+	msg = dmu_head_msg(ring, ring->r_idx);
+	if (msg->hdr.status)
+		msg = NULL;
+	else
+		dmu_ring_idx_inc(ring);
+	spin_unlock(&ring->r_lock);
 
-        if (!capable(CAP_SYS_ADMIN))
-                return -EACCES;
+	return msg;
+}
 
-	if (size < sizeof(struct dmu_msg)) {
-		DMERR("Userspace buffer too small for a single message");
-		return 0;
-	}
+static void send_tx_request(struct dmu_msg *msg, struct dmu_request *req)
+{
+	struct chardev_transport *t = req->dev->transport_private;
 
-	while (!have_pending_requests(dev)) {
-		if (file->f_flags & O_NONBLOCK) {
-			return 0;
-		}
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
 
-		if (wait_event_interruptible(dev->wqueue,
-					     have_pending_requests(dev)))
-			return -ERESTARTSYS;
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
 	}
+}
 
-	while (ret < size) {
-		if ((size - ret) < sizeof(struct dmu_msg))
-			break;
+static int dmu_txd(void *data)
+{
 
-		req = pluck_next_request(dev);
-		if (!req)
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
 			break;
 
-		r = send_userspace_message((void *)(buffer + ret), req);
-		if (r == 0)
+		msg = get_tx_msg(ring);
+		if (!msg)
 			continue;
-		else if (r < 0)
-			return r;
 
-		ret += r;
-	}
+		req = pluck_next_request(dev);
+		BUG_ON(!req);
 
-	if (ret < sizeof(struct dmu_msg)) {
-		if (ret != 0)
-			DMERR("Sending partial message!");
-		DMINFO("Sent 0 requests to userspace");
+		send_tx_request(msg, req);
 	}
 
-	return ret;
+	return 0;
 }
 
 static struct dmu_request *pluck_dep_req(struct dmu_request *req)
@@ -398,56 +463,93 @@ static void do_map_failed(struct dmu_dev
 	mempool_free(req, request_pool);
 }
 
-ssize_t dmu_ctl_write(struct file *file, const char __user *buffer,
-		      size_t size, loff_t *offset)
+static int dmu_rxd(void *data)
 {
-	struct dmu_device *dev = (struct dmu_device *)file->private_data;
-	int ret = 0;
-	struct dmu_msg msg;
+	struct dmu_device *dev = (struct dmu_device *) data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->rx;
+	struct dmu_msg *msg;
 
-        if (!capable(CAP_SYS_ADMIN))
-                return -EACCES;
+	while (!kthread_should_stop()) {
+		msg = dmu_head_msg(ring, ring->r_idx);
+		/* do we need this? */
+		flush_dcache_page(virt_to_page(msg));
 
-	while ((ret + sizeof(msg)) <= size) {
-		if (copy_from_user(&msg, buffer+ret, sizeof(msg))) {
-			DMERR("%s copy_from_user failed!", __FUNCTION__);
-			ret = -EFAULT;
-			goto out;
-		}
+		wait_event_interruptible(t->rx_wqueue, msg->hdr.status ||
+					kthread_should_stop());
 
-		ret += sizeof(msg);
+		if (kthread_should_stop())
+			break;
 
-		switch (msg.hdr.msg_type) {
+		switch (msg->hdr.msg_type) {
 		case DM_USERSPACE_MAP_BLOCK_RESP:
-			do_map_bio(dev, &msg.payload.map_rsp);
+			do_map_bio(dev, &msg->payload.map_rsp);
 			break;
 
 		case DM_USERSPACE_MAP_FAILED:
-			do_map_failed(dev, msg.payload.map_rsp.id_of_req);
+			do_map_failed(dev, msg->payload.map_rsp.id_of_req);
 			break;
 
 		case DM_USERSPACE_MAP_DONE:
-			do_map_done(dev, msg.payload.map_done.id_of_op, 0);
+			do_map_done(dev, msg->payload.map_done.id_of_op, 0);
 			break;
 
 		case DM_USERSPACE_MAP_DONE_FAILED:
-			do_map_done(dev, msg.payload.map_done.id_of_op, 1);
+			do_map_done(dev, msg->payload.map_done.id_of_op, 1);
 			break;
 
 		default:
 			DMWARN("Unknown incoming request type: %i",
-			       msg.hdr.msg_type);
+			       msg->hdr.msg_type);
 		}
+
+		msg->hdr.status = 0;
+		dmu_ring_idx_inc(ring);
 	}
- out:
-	if (ret < sizeof(msg))
-		DMINFO("Received 0 responses from userspace");
 
-	return ret;
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
 }
 
 int dmu_ctl_open(struct inode *inode, struct file *file)
 {
+	int ret;
 	struct chardev_transport *t;
 	struct dmu_device *dev;
 
@@ -457,18 +559,52 @@ int dmu_ctl_open(struct inode *inode, st
 	t = container_of(inode->i_cdev, struct chardev_transport, cdev);
 	dev = t->parent;
 
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
 	get_dev(dev);
 
 	file->private_data = dev;
 
 	return 0;
+destroy_tx_task:
+	kthread_stop(t->tx_task);
+free_rx:
+	dmu_ring_free(&t->rx);
+free_tx:
+	dmu_ring_free(&t->tx);
+	return ret;
 }
 
 int dmu_ctl_release(struct inode *inode, struct file *file)
 {
-	struct dmu_device *dev;
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+
+	kthread_stop(t->rx_task);
+	kthread_stop(t->tx_task);
 
-	dev = (struct dmu_device *)file->private_data;
+	dmu_ring_free(&t->rx);
+	dmu_ring_free(&t->tx);
 
 	put_dev(dev);
 
@@ -478,21 +614,72 @@ int dmu_ctl_release(struct inode *inode,
 unsigned dmu_ctl_poll(struct file *file, poll_table *wait)
 {
 	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->tx;
+	struct dmu_msg *msg;
 	unsigned mask = 0;
+	u32 idx;
+
+	poll_wait(file, &t->poll_wait, wait);
 
-	poll_wait(file, &dev->wqueue, wait);
+	spin_lock(&ring->r_lock);
 
-	if (have_pending_requests(dev))
+	idx = ring->r_idx ? ring->r_idx - 1 : DMU_MAX_EVENTS - 1;
+	msg = dmu_head_msg(ring, idx);
+	if (msg->hdr.status)
 		mask |= POLLIN | POLLRDNORM;
 
+	spin_unlock(&ring->r_lock);
+
 	return mask;
 }
 
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
 static struct file_operations ctl_fops = {
 	.open    = dmu_ctl_open,
 	.release = dmu_ctl_release,
-	.read    = dmu_ctl_read,
 	.write   = dmu_ctl_write,
+	.mmap    = dmu_ctl_mmap,
 	.poll    = dmu_ctl_poll,
 	.owner   = THIS_MODULE,
 };
diff --git a/drivers/md/dm-userspace.c b/drivers/md/dm-userspace.c
index 3f3d2ef..b6b8320 100644
--- a/drivers/md/dm-userspace.c
+++ b/drivers/md/dm-userspace.c
@@ -49,23 +49,7 @@ LIST_HEAD(devices);
 /* Device number for the control device */
 dev_t dmu_dev;
 
-/* Add a request to a device's request queue */
-static void add_tx_request(struct dmu_device *dev,
-			   struct dmu_request *req)
-{
-	unsigned long flags;
-
-	BUG_ON(!list_empty(&req->list));
-
-	spin_lock_irqsave(&dev->tx_lock, flags);
-	list_add_tail(&req->list, &dev->tx_requests);
-	atomic_inc(&dev->t_reqs);
-	spin_unlock_irqrestore(&dev->tx_lock, flags);
-
-	wake_up(&dev->wqueue);
-}
-
-static void endio_worker(void *data)
+void endio_worker(void *data)
 {
 	struct dmu_request *req = data;
 	struct dmu_device *dev = req->dev;
@@ -227,7 +211,6 @@ static int init_dmu_device(struct dmu_de
 {
 	int ret;
 
-	init_waitqueue_head(&dev->wqueue);
 	init_waitqueue_head(&dev->lowmem);
 	INIT_LIST_HEAD(&dev->list);
 	INIT_LIST_HEAD(&dev->target_devs);
diff --git a/include/linux/dm-userspace.h b/include/linux/dm-userspace.h
index 698093a..e249f51 100644
--- a/include/linux/dm-userspace.h
+++ b/include/linux/dm-userspace.h
@@ -67,6 +67,8 @@ struct dmu_msg_header {
 	uint64_t id;
 	uint32_t msg_type;
 	uint32_t payload_len;
+	uint32_t status;
+	uint32_t padding;
 };
 
 /* DM_USERSPACE_MAP_DONE
@@ -112,4 +114,9 @@ struct dmu_msg {
 	} payload;
 };
 
+#define DMU_RING_SIZE (1UL << 16)
+#define DMU_RING_PAGES (DMU_RING_SIZE >> PAGE_SHIFT)
+#define DMU_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct dmu_msg))
+#define DMU_MAX_EVENTS (DMU_EVENT_PER_PAGE * DMU_RING_PAGES)
+
 #endif
-- 
1.4.1.1
