From: fujita <tomof@dd.iij4u.or.jp>
Subject: [PATCH 4/4] dm-userspace: use mmaped buffer instead of
 read/write system calls
Date: Sat, 30 Sep 2006 19:44:36 +0900
Message-ID: <200609301044.k8UAigeQ013351@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: danms@us.ibm.com
List-Id: dm-devel.ids

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Dcc: fujita.tomonori@lab.ntt.co.jp
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Use mmaped buffer instead of read/write system calls for kernel/user
communication. I've not tested this heavily, though seems to
works. Hopefully, good enough for performance comparisons.

Here's a user-space example code:

http://www.kernel.org/pub/linux/kernel/people/tomo/dmu/example-rb.c

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-user.h              |    2 
 drivers/md/dm-userspace-chardev.c |  300 ++++++++++++++++++++++++++-----------
 drivers/md/dm-userspace.c         |   20 --
 include/linux/dm-userspace.h      |    6 +
 4 files changed, 221 insertions(+), 107 deletions(-)

diff --git a/drivers/md/dm-user.h b/drivers/md/dm-user.h
index 06b251b..1f301f2 100644
--- a/drivers/md/dm-user.h
+++ b/drivers/md/dm-user.h
@@ -119,6 +119,8 @@ void cleanup_chardev_transport(void);
 void write_chardev_transport_info(struct dmu_device *dev,
 				  char *buf, unsigned int maxlen);
 
+extern void dmu_add_tx_request(struct dmu_device *dev, struct dmu_request *req);
+
 /* Return the block number for @sector */
 static inline u64 dmu_block(struct dmu_device *dev,
 			    sector_t sector)
diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
index ee55ca8..e3f85c7 100644
--- a/drivers/md/dm-userspace-chardev.c
+++ b/drivers/md/dm-userspace-chardev.c
@@ -2,6 +2,8 @@
  * Copyright (C) International Business Machines Corp., 2006
  * Author: Dan Smith <danms@us.ibm.com>
  *
+ * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; under version 2 of the License.
@@ -36,6 +38,12 @@ #include "dm-user.h"
 
 #define DM_MSG_PREFIX "dm-userspace"
 
+struct dmu_ring {
+	u32 r_idx;
+	unsigned long r_pages[DMU_RING_PAGES];
+	spinlock_t r_lock;
+};
+
 /* This allows for a cleaner separation between the dm-userspace
  * device-mapper target, and the userspace transport used.  Right now,
  * only a chardev transport exists, but it's possible that there could
@@ -45,8 +53,31 @@ struct chardev_transport {
 	struct cdev cdev;
 	dev_t ctl_dev;
 	struct dmu_device *parent;
+
+	struct dmu_ring tx;
+	struct dmu_ring rx;
+	wait_queue_head_t tx_poll_wait;
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
@@ -66,34 +97,39 @@ static struct dmu_request *find_rx_reque
 	return match;
 }
 
-static int have_pending_requests(struct dmu_device *dev)
-{
-	return atomic_read(&dev->t_reqs) != 0;
-}
-
-static int send_userspace_message(uint8_t __user *buffer,
-				  struct dmu_request *req)
+static int send_userspace_message(struct dmu_device *dev, struct dmu_request *req)
 {
+	struct chardev_transport *t = dev->transport_private;
 	int ret = 0;
-	struct dmu_msg msg;
+	struct dmu_msg *msg;
+	struct dmu_ring *ring = &t->tx;
+
+	spin_lock(&ring->r_lock);
+	msg = dmu_head_msg(ring, ring->r_idx);
+	if (!msg->hdr.status)
+		dmu_ring_idx_inc(ring);
+	else
+		ret = -EBUSY;
+	spin_unlock(&ring->r_lock);
 
-	memset(&msg, 0, sizeof(msg));
+	if (ret)
+		return ret;
 
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
 
@@ -102,10 +138,9 @@ static int send_userspace_message(uint8_
 		ret = 0;
 	}
 
-	if (copy_to_user(buffer, &msg, sizeof(msg)))
-		return -EFAULT;
-
-	ret = sizeof(msg);
+	msg->hdr.status = 1;
+	mb();
+	flush_dcache_page(virt_to_page(msg));
 
 	/* If this request is not on a list (the rx_requests list),
 	 * then it needs to be freed after sending
@@ -113,10 +148,12 @@ static int send_userspace_message(uint8_
 	if (list_empty(&req->list))
 		mempool_free(req, request_pool);
 
-	return ret;
+	wake_up_interruptible(&dev->wqueue);
+
+	return 0;
 }
 
-struct dmu_request *pluck_next_request(struct dmu_device *dev)
+static struct dmu_request *pluck_next_request(struct dmu_device *dev)
 {
 	struct dmu_request *req = NULL;
 	unsigned long flags;
@@ -142,56 +179,39 @@ struct dmu_request *pluck_next_request(s
 	return req;
 }
 
-ssize_t dmu_ctl_read(struct file *file, char __user *buffer,
-		     size_t size, loff_t *offset)
+static void delay_tx_request(struct dmu_device *dev, struct dmu_request *req)
 {
+	unsigned long flags;
 
-	struct dmu_device *dev = (struct dmu_device *)file->private_data;
-	struct dmu_request *req = NULL;
-	int ret = 0, r;
-
-        if (!capable(CAP_SYS_ADMIN))
-                return -EACCES;
-
-	if (size < sizeof(struct dmu_msg)) {
-		DMERR("Userspace buffer too small for a single message");
-		return 0;
-	}
-
-	while (!have_pending_requests(dev)) {
-		if (file->f_flags & O_NONBLOCK) {
-			return 0;
-		}
-
-		if (wait_event_interruptible(dev->wqueue,
-					     have_pending_requests(dev)))
-			return -ERESTARTSYS;
-	}
-
-	while (ret < size) {
-		if ((size - ret) < sizeof(struct dmu_msg))
-			break;
+	spin_lock(&dev->lock);
+	list_del_init(&req->list);
+	atomic_dec(&dev->r_reqs);
+	spin_unlock(&dev->lock);
 
-		req = pluck_next_request(dev);
-		if (!req)
-			break;
+	spin_lock_irqsave(&dev->tx_lock, flags);
+	list_add_tail(&req->list, &dev->tx_requests);
+	atomic_inc(&dev->t_reqs);
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+}
 
-		r = send_userspace_message((void *)(buffer + ret), req);
-		if (r == 0)
-			continue;
-		else if (r < 0)
-			return r;
+/* Add a request to a device's request queue */
+void dmu_add_tx_request(struct dmu_device *dev, struct dmu_request *req)
+{
+	int err;
 
-		ret += r;
-	}
+	BUG_ON(!list_empty(&req->list));
 
-	if (ret < sizeof(struct dmu_msg)) {
-		if (ret != 0)
-			DMERR("Sending partial message!");
-		DMINFO("Sent 0 requests to userspace");
+	if (req->type == DM_USERSPACE_MAP_BLOCK_REQ ||
+	    req->type == DM_USERSPACE_MAP_DONE) {
+		spin_lock(&dev->lock);
+		list_add_tail(&req->list, &dev->rx_requests);
+		atomic_inc(&dev->r_reqs);
+		spin_unlock(&dev->lock);
 	}
 
-	return ret;
+	err = send_userspace_message(dev, req);
+	if (err)
+		delay_tx_request(dev, req);
 }
 
 static struct dmu_request *pluck_dep_req(struct dmu_request *req)
@@ -402,54 +422,91 @@ ssize_t dmu_ctl_write(struct file *file,
 		      size_t size, loff_t *offset)
 {
 	struct dmu_device *dev = (struct dmu_device *)file->private_data;
-	int ret = 0;
-	struct dmu_msg msg;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->rx;
+	struct dmu_msg *msg;
+	struct dmu_request *req;
 
         if (!capable(CAP_SYS_ADMIN))
                 return -EACCES;
 
-	while ((ret + sizeof(msg)) <= size) {
-		if (copy_from_user(&msg, buffer+ret, sizeof(msg))) {
-			DMERR("%s copy_from_user failed!", __FUNCTION__);
-			ret = -EFAULT;
-			goto out;
-		}
+	while (1) {
+		msg = dmu_head_msg(ring, ring->r_idx);
 
-		ret += sizeof(msg);
+		if (!msg->hdr.status)
+			break;
+
+		/* do we need this? */
+		flush_dcache_page(virt_to_page(msg));
+		dmu_ring_idx_inc(ring);
 
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
 	}
- out:
-	if (ret < sizeof(msg))
-		DMINFO("Received 0 responses from userspace");
 
-	return ret;
+	while ((req = pluck_next_request(dev))) {
+		int err = send_userspace_message(dev, req);
+		if (err) {
+			delay_tx_request(dev, req);
+			break;
+		}
+	}
+
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
 	struct chardev_transport *t;
 	struct dmu_device *dev;
+	int ret;
 
         if (!capable(CAP_SYS_ADMIN))
                 return -EACCES;
@@ -457,19 +514,33 @@ int dmu_ctl_open(struct inode *inode, st
 	t = container_of(inode->i_cdev, struct chardev_transport, cdev);
 	dev = t->parent;
 
+	ret = dmu_ring_alloc(&t->tx);
+	if (ret)
+		goto free_tx;
+
+	ret = dmu_ring_alloc(&t->rx);
+	if (ret)
+		goto free_rx;
+
 	get_dev(dev);
 
 	file->private_data = dev;
 
 	return 0;
+free_rx:
+	dmu_ring_free(&t->rx);
+free_tx:
+	dmu_ring_free(&t->tx);
+	return ret;
 }
 
 int dmu_ctl_release(struct inode *inode, struct file *file)
 {
-	struct dmu_device *dev;
-
-	dev = (struct dmu_device *)file->private_data;
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
 
+	dmu_ring_free(&t->rx);
+	dmu_ring_free(&t->tx);
 	put_dev(dev);
 
 	return 0;
@@ -478,21 +549,72 @@ int dmu_ctl_release(struct inode *inode,
 unsigned dmu_ctl_poll(struct file *file, poll_table *wait)
 {
 	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->tx;
+	struct dmu_msg *msg;
 	unsigned mask = 0;
+	u32 idx;
 
 	poll_wait(file, &dev->wqueue, wait);
 
-	if (have_pending_requests(dev))
+	spin_lock(&ring->r_lock);
+
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
+	.mmap	 = dmu_ctl_mmap,
 	.poll    = dmu_ctl_poll,
 	.owner   = THIS_MODULE,
 };
diff --git a/drivers/md/dm-userspace.c b/drivers/md/dm-userspace.c
index 3f3d2ef..6074f6b 100644
--- a/drivers/md/dm-userspace.c
+++ b/drivers/md/dm-userspace.c
@@ -49,22 +49,6 @@ LIST_HEAD(devices);
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
 static void endio_worker(void *data)
 {
 	struct dmu_request *req = data;
@@ -431,7 +415,7 @@ static int dmu_map(struct dm_target *ti,
 
 	init_req(dev, bio, req);
 
-	add_tx_request(dev, req);
+	dmu_add_tx_request(dev, req);
 
 	return 0;
 }
@@ -480,7 +464,7 @@ static int dmu_end_io(struct dm_target *
 
 	if (dmu_get_flag(&req->flags, DMU_FLAG_SYNC)) {
 		req->type = DM_USERSPACE_MAP_DONE;
-		add_tx_request(req->dev, req);
+		dmu_add_tx_request(req->dev, req);
 		ret = 1;
 	} else {
 		INIT_WORK(&req->task, endio_worker, req);
diff --git a/include/linux/dm-userspace.h b/include/linux/dm-userspace.h
index 698093a..0d7f59e 100644
--- a/include/linux/dm-userspace.h
+++ b/include/linux/dm-userspace.h
@@ -65,6 +65,7 @@ static inline void dmu_cpy_flag(uint32_t
  */
 struct dmu_msg_header {
 	uint64_t id;
+	uint64_t status;
 	uint32_t msg_type;
 	uint32_t payload_len;
 };
@@ -112,4 +113,9 @@ struct dmu_msg {
 	} payload;
 };
 
+#define DMU_RING_SIZE (1UL << 18)
+#define DMU_RING_PAGES (DMU_RING_SIZE >> PAGE_SHIFT)
+#define DMU_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct dmu_msg))
+#define DMU_MAX_EVENTS (DMU_EVENT_PER_PAGE * DMU_RING_PAGES)
+
 #endif
-- 
1.4.1
