From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: dm-userspace (no in-kernel cache version)
Date: Tue, 12 Sep 2006 08:07:48 +0900
Message-ID: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
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

By request, I post my dm-userspace patch against linux-2.6.git (the
previous patch against Dan's patch).

As explained, this removes rmap (in-kernel cache) and use mmaped
buffer instead of read/write system calls for user/kernel communication.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
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
index 0000000..890e36a
--- /dev/null
+++ b/drivers/md/dm-user.h
@@ -0,0 +1,99 @@
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
+extern spinlock_t devices_lock;
+extern struct list_head devices;
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
+	struct list_head requests;    /* List of pending requests          */
+	struct list_head target_devs; /* List of devices we can target     */
+
+	void *transport_private;      /* Private data for userspace comms  */
+
+	char key[DMU_KEY_LEN];        /* Unique name string for device     */
+	struct kref users;            /* Self-destructing reference count  */
+
+	uint64_t block_size;          /* Block size for this device        */
+	uint64_t block_mask;          /* Mask for offset in block          */
+	unsigned int block_shift;     /* Shift to convert to/from block    */
+
+	struct kcopyd_client *kcopy;  /* Interface to kcopyd               */
+};
+
+struct dmu_request {
+	struct list_head list;        /* Our place in a remap bucket chain */
+	struct dmu_device *dev;       /* The DMU device that owns us       */
+	struct bio *bio;
+	u32 flags;
+};
+
+extern void dmu_map_done(struct dmu_device *dev, u64 id, uint32_t flags,
+			 uint32_t src_maj, uint32_t src_min,
+			 uint32_t dst_maj, uint32_t dst_min,
+			 u64 block, u64 offset);
+
+/* Character device transport functions */
+extern int register_chardev_transport(struct dmu_device *dev);
+extern void unregister_chardev_transport(struct dmu_device *dev);
+extern int init_chardev_transport(void);
+extern void cleanup_chardev_transport(void);
+extern void write_chardev_transport_info(struct dmu_device *dev,
+					 char *buf, unsigned int maxlen);
+
+extern int dmu_uspace_send_map_req(struct dmu_device *, u64, u32, u64);
+extern int dmu_uspace_send_map_status(struct dmu_device *, u64, u32);
+
+/* Increase the usage count for @dev */
+static inline void get_dev(struct dmu_device *dev)
+{
+	kref_get(&dev->users);
+}
+
+extern void destroy_dmu_device(struct kref *ref);
+/* Decrease the usage count for @dev */
+static inline void put_dev(struct dmu_device *dev)
+{
+	kref_put(&dev->users, destroy_dmu_device);
+}
+
+#endif
diff --git a/drivers/md/dm-userspace-chardev.c b/drivers/md/dm-userspace-chardev.c
new file mode 100644
index 0000000..5a4b0d3
--- /dev/null
+++ b/drivers/md/dm-userspace-chardev.c
@@ -0,0 +1,406 @@
+/*
+ * Copyright (C) International Business Machines Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
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
+static dev_t dmu_dev;
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
+	wait_queue_head_t tx_poll_wait;
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
+static struct dmu_event *dmu_head_event(struct dmu_ring *r, u32 idx)
+{
+	u32 pidx, off;
+
+	pidx = idx / DMU_EVENT_PER_PAGE;
+	off = idx % DMU_EVENT_PER_PAGE;
+
+	return (struct dmu_event *)
+		(r->r_pages[pidx] + sizeof(struct dmu_event) * off);
+}
+
+static int dmu_uspace_send_event(struct dmu_device *dev, u32 type,
+				 struct dmu_event *p)
+{
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_event *ev;
+	struct dmu_ring *ring = &t->tx;
+	int err = 0;
+
+	spin_lock(&ring->r_lock);
+
+	ev = dmu_head_event(ring, ring->r_idx);
+	if (!ev->status)
+		dmu_ring_idx_inc(ring);
+	else
+		err = -EBUSY;
+
+	spin_unlock(&ring->r_lock);
+
+	if (err) {
+		DMERR("Fail to send uspace %u\n", type);
+		return err;
+	}
+
+	memcpy(ev, p, sizeof(*ev));
+	ev->type = type;
+	ev->status = 1;
+	mb();
+
+	flush_dcache_page(virt_to_page(ev));
+
+	wake_up_interruptible(&t->tx_poll_wait);
+
+	return 0;
+}
+
+int dmu_uspace_send_map_req(struct dmu_device *dev, u64 id, u32 flags, u64 block)
+{
+	struct dmu_event ev;
+
+	ev.k.map_req.id = id;
+	ev.k.map_req.flags = flags;
+	ev.k.map_req.block = block;
+	return dmu_uspace_send_event(dev, DM_USERSPACE_MAP_BLOCK_REQ, &ev);
+}
+
+int dmu_uspace_send_map_status(struct dmu_device *dev, u64 id, u32 status)
+{
+	struct dmu_event ev;
+
+	ev.k.map_done.id = id;
+	ev.k.map_done.status = status;
+	return dmu_uspace_send_event(dev, DM_USERSPACE_MAP_BLOCK_DONE, &ev);
+}
+
+static void dmu_event_recv(struct dmu_device *dev, struct dmu_event *ev)
+{
+	switch (ev->type) {
+	case DM_USERSPACE_MAP_BLOCK_RSP:
+		dmu_map_done(dev, ev->u.map_rsp.id, ev->u.map_rsp.flags,
+			     ev->u.map_rsp.src_maj, ev->u.map_rsp.src_min,
+			     ev->u.map_rsp.dst_maj, ev->u.map_rsp.dst_min,
+			     ev->u.map_rsp.block, ev->u.map_rsp.offset);
+		break;
+	default:
+		printk("unknown type %d\n", ev->type);
+	}
+}
+
+static ssize_t dmu_ctl_write(struct file *file, const char __user * buffer,
+			     size_t count, loff_t * ppos)
+{
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->rx;
+	struct dmu_event *ev;
+
+	while (1) {
+		ev = dmu_head_event(ring, ring->r_idx);
+		if (!ev->status)
+			break;
+
+		/* do we need this? */
+		flush_dcache_page(virt_to_page(ev));
+
+		dmu_ring_idx_inc(ring);
+		dmu_event_recv(dev, ev);
+		ev->status = 0;
+	};
+
+	return count;
+}
+
+static void dmu_ring_free(struct dmu_ring *r)
+{
+	int i;
+	for (i = 0; i < DMU_RING_PAGES; i++)
+		free_page(r->r_pages[i]);
+}
+
+static int dmu_ring_alloc(struct dmu_ring *r)
+{
+	int i;
+
+	spin_lock_init(&r->r_lock);
+	for (i = 0; i < DMU_RING_PAGES; i++) {
+		r->r_pages[i] = get_zeroed_page(GFP_KERNEL);
+		if (!r->r_pages[i]) {
+			printk("out of memory\n");
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+static int dmu_ctl_open(struct inode *inode, struct file *file)
+{
+	struct chardev_transport *t;
+	struct dmu_device *dev;
+	int err;
+
+        if (!capable(CAP_SYS_ADMIN))
+                return -EACCES;
+
+	t = container_of(inode->i_cdev, struct chardev_transport, cdev);
+
+	init_waitqueue_head(&t->tx_poll_wait);
+	err = dmu_ring_alloc(&t->tx);
+	if (err)
+		goto free_tx;
+
+	err = dmu_ring_alloc(&t->rx);
+	if (err)
+		goto free_rx;
+
+	dev = t->parent;
+
+	get_dev(dev);
+
+	file->private_data = dev;
+
+	return 0;
+free_rx:
+	dmu_ring_free(&t->rx);
+free_tx:
+	dmu_ring_free(&t->tx);
+	return err;
+}
+
+static int dmu_ctl_release(struct inode *inode, struct file *file)
+{
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+
+	t = container_of(inode->i_cdev, struct chardev_transport, cdev);
+
+	dmu_ring_free(&t->rx);
+	dmu_ring_free(&t->tx);
+	put_dev(dev);
+
+	return 0;
+}
+
+static unsigned dmu_ctl_poll(struct file *file, poll_table *wait)
+{
+	struct dmu_device *dev = (struct dmu_device *)file->private_data;
+	struct chardev_transport *t = dev->transport_private;
+	struct dmu_ring *ring = &t->tx;
+	struct dmu_event *ev;
+	unsigned int mask = 0;
+	u32 idx;
+
+	poll_wait(file, &t->tx_poll_wait, wait);
+
+	spin_lock(&ring->r_lock);
+
+	idx = ring->r_idx ? ring->r_idx - 1 : DMU_MAX_EVENTS - 1;
+	ev = dmu_head_event(ring, idx);
+	if (ev->status)
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
+	.open		= dmu_ctl_open,
+	.release	= dmu_ctl_release,
+	.write		= dmu_ctl_write,
+	.mmap		= dmu_ctl_mmap,
+	.poll		= dmu_ctl_poll,
+	.owner		= THIS_MODULE,
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
+	dev->transport_private = kzalloc(sizeof(*t), GFP_KERNEL);
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
+	return 0;
+ bad:
+	kfree(t);
+	return -ENOMEM;
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
index 0000000..f57df7d
--- /dev/null
+++ b/drivers/md/dm-userspace.c
@@ -0,0 +1,544 @@
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
+#define DM_MSG_PREFIX "dm-userspace"
+
+#define DMU_COPY_PAGES     256
+
+static kmem_cache_t *request_cache;
+static mempool_t *request_pool;
+
+spinlock_t devices_lock;
+LIST_HEAD(devices);
+
+/* Return the block number for @sector */
+static inline u64 dmu_block(struct dmu_device *dev, sector_t sector)
+{
+	return sector >> dev->block_shift;
+}
+
+/* Return the sector offset in a block for @sector */
+static inline u64 dmu_sector_offset(struct dmu_device *dev, sector_t sector)
+{
+	return sector & dev->block_mask;
+}
+
+/* Return the starting sector for @block */
+static inline u64 dmu_sector(struct dmu_device *dev, uint64_t block)
+{
+	return block << dev->block_shift;
+}
+
+static struct target_device *find_target(struct dmu_device *dev,
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
+static struct target_device *get_target(struct dmu_device *dev,
+					dev_t devno)
+{
+
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
+	INIT_LIST_HEAD(&dev->list);
+	INIT_LIST_HEAD(&dev->requests);
+	INIT_LIST_HEAD(&dev->target_devs);
+	kref_init(&dev->users);
+	spin_lock_init(&dev->lock);
+
+	dev->block_size  = block_size;
+	dev->block_mask  = block_size - 1;
+	dev->block_shift = ffs(block_size) - 1;
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
+	if (ret)
+		goto bad2;
+
+	spin_lock(&devices_lock);
+	list_add(&dev->list, &devices);
+	spin_unlock(&devices_lock);
+
+	return dev;
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
+		dev = new_dmu_device(device_key,
+				     ti,
+				     block_size);
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
+static int dmu_map(struct dm_target *ti, struct bio *bio,
+		   union map_info *map_context)
+{
+	struct dmu_device *dev = (struct dmu_device *) ti->private;
+	struct dmu_request *req;
+	int err;
+
+	req = mempool_alloc(request_pool, GFP_NOIO);
+	if (!req) {
+		DMERR("Failed to allocate request");
+		return -1;
+	}
+
+	req->dev = dev;
+	req->bio = bio;
+
+	spin_lock(&dev->lock);
+	list_add_tail(&req->list, &dev->requests);
+	spin_unlock(&dev->lock);
+
+	err = dmu_uspace_send_map_req(dev, (u64)(unsigned long)req, 0,
+				      dmu_block(dev, bio->bi_sector));
+	if (err) {
+		spin_lock(&dev->lock);
+		list_del(&req->list);
+		spin_unlock(&dev->lock);
+
+		mempool_free(req, request_pool);
+		return -1;
+	}
+	map_context->ptr = req;
+
+	return 0;
+}
+
+static int dmu_status(struct dm_target *ti, status_type_t type,
+		      char *result, unsigned int maxlen)
+{
+	struct dmu_device *dev = (struct dmu_device *) ti->private;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		write_chardev_transport_info(dev, result, maxlen);
+		break;
+
+	case STATUSTYPE_TABLE:
+		snprintf(result, maxlen, "%s %llu",
+			 dev->key,
+			 dev->block_size * 512);
+		break;
+	}
+
+	return 0;
+}
+
+static int dmu_end_io(struct dm_target *ti, struct bio *bio,
+		      int error, union map_info *map_context)
+{
+	struct dmu_request *req = map_context->ptr;
+	int err;
+
+	if (req->flags & DMU_FLAG_WAITING) {
+		err = dmu_uspace_send_map_status(req->dev,
+						 (u64)(unsigned long)req, 0);
+		if (err)
+			DMERR("can't send notification %llu", (u64)(unsigned long)req);
+	}
+
+	mempool_free(req, request_pool);
+	return 0;
+}
+
+static struct target_type userspace_target = {
+	.name		= "userspace",
+	.version	= {0, 1, 0},
+	.module		= THIS_MODULE,
+	.ctr		= dmu_ctr,
+	.dtr		= dmu_dtr,
+	.map		= dmu_map,
+	.status		= dmu_status,
+	.end_io		= dmu_end_io
+};
+
+static void copy_block_done(int read_err, unsigned int write_err, void *data)
+{
+	struct dmu_request *req = data;
+	generic_make_request(req->bio);
+}
+
+static void copy_block(struct dmu_device *dev, struct block_device *src_dev,
+		       struct block_device *dst_dev, struct dmu_request *req,
+		       u64 block, u64 offset)
+{
+	struct io_region src, dst;
+	struct kcopyd_client *client;
+
+	src.bdev = src_dev;
+	src.sector = dmu_sector(dev, dmu_block(dev, req->bio->bi_sector));
+	src.count = dev->block_size;
+
+	dst.bdev = dst_dev;
+	dst.sector = dmu_sector(dev, block);
+	dst.sector += offset;
+	dst.count = dev->block_size;
+
+	client = dev->kcopy;
+
+	kcopyd_copy(client, &src, 1, &dst, 0, copy_block_done, req);
+}
+
+void dmu_map_done(struct dmu_device *dev, u64 id, uint32_t flags,
+		  uint32_t src_maj, uint32_t src_min,
+		  uint32_t dst_maj, uint32_t dst_min, u64 block, u64 offset)
+{
+	struct dmu_request *cur, *next, *req = NULL;
+	struct target_device *src_dev = NULL, *dst_dev;
+	struct bio *bio;
+
+	spin_lock(&dev->lock);
+	list_for_each_entry_safe(cur, next, &dev->requests, list) {
+		if ((u64) (unsigned long)cur == id) {
+			list_del(&cur->list);
+			req = cur;
+		}
+	}
+	spin_unlock(&dev->lock);
+
+	if (!req) {
+		DMERR("can't find %llu", (unsigned long long)id);
+		return;
+	}
+
+	bio = req->bio;
+	req->flags = flags;
+
+	if (flags & DMU_FLAG_VALID) {
+		if (flags & DMU_FLAG_COPY_FIRST) {
+			src_dev = find_target(dev, MKDEV(src_maj, src_min));
+			if (!src_dev)
+				goto eio;
+		}
+
+		dst_dev = find_target(dev, MKDEV(dst_maj, dst_min));
+		if (!dst_dev)
+			goto eio;
+
+		bio->bi_sector = dmu_sector(dev, block) +
+			dmu_sector_offset(dev, bio->bi_sector) + offset;
+		bio->bi_bdev = dst_dev->bdev;
+
+		if (flags & DMU_FLAG_COPY_FIRST)
+			copy_block(dev, src_dev->bdev, dst_dev->bdev,
+				   req, block, offset);
+		else
+			generic_make_request(bio);
+	}
+
+	return;
+eio:
+	bio_io_error(bio, bio->bi_size);
+}
+
+int __init dm_userspace_init(void)
+{
+	int err;
+
+	err = dm_register_target(&userspace_target);
+	if (err < 0) {
+		DMERR("Register failed %d", err);
+		return 0;
+	}
+
+	spin_lock_init(&devices_lock);
+
+	request_cache = kmem_cache_create("dm-userspace-requests",
+					  sizeof(struct dmu_request),
+					  __alignof__ (struct dmu_request),
+					  0, NULL, NULL);
+	if (!request_cache) {
+		DMERR("Failed to allocate request cache");
+		goto unregister_target;
+	}
+
+	request_pool = mempool_create(64,
+				      mempool_alloc_slab, mempool_free_slab,
+				      request_cache);
+	if (!request_pool) {
+		DMERR("Failed to allocate request pool");
+		goto request_cache_destroy;
+	}
+
+	err = init_chardev_transport();
+	if (!err)
+		goto request_pool_destroy;
+
+	return 1;
+
+request_pool_destroy:
+	mempool_destroy(request_pool);
+request_cache_destroy:
+	kmem_cache_destroy(request_cache);
+unregister_target:
+	dm_unregister_target(&userspace_target);
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
index 0000000..bfad3b6
--- /dev/null
+++ b/include/linux/dm-userspace.h
@@ -0,0 +1,81 @@
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
+#define DM_USERSPACE_MAP_BLOCK_REQ	1
+#define DM_USERSPACE_MAP_BLOCK_RSP	2
+#define DM_USERSPACE_MAP_BLOCK_DONE	3
+
+/*
+ * Flags and associated macros
+ */
+#define DMU_FLAG_VALID			(1 << 0)
+#define DMU_FLAG_RD			(1 << 1)
+#define DMU_FLAG_WR			(1 << 2)
+#define DMU_FLAG_COPY_FIRST		(1 << 3)
+#define DMU_FLAG_SYNC			(1 << 4)
+#define DMU_FLAG_WAITING		(1 << 5)
+
+struct dmu_event {
+	uint32_t status;
+	uint32_t type;
+
+	/* user -> kernel */
+	union {
+		struct {
+			aligned_u64 id;
+			uint32_t flags;
+			uint32_t src_maj;
+			uint32_t src_min;
+
+			uint32_t dst_maj;
+			uint32_t dst_min;
+			aligned_u64 block;
+			aligned_u64 offset;
+		} map_rsp;
+	} u;
+
+	/* kernel -> user */
+	union {
+		struct {
+			aligned_u64 id;
+			uint32_t flags;
+			aligned_u64 block;
+		} map_req;
+		struct {
+			aligned_u64 id;
+			uint32_t status;
+		} map_done;
+	} k;
+
+} __attribute__ ((aligned (sizeof(uint64_t))));
+
+#define DMU_RING_SIZE (1UL << 16)
+#define DMU_RING_PAGES (DMU_RING_SIZE >> PAGE_SHIFT)
+#define DMU_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct dmu_event))
+#define DMU_MAX_EVENTS (DMU_EVENT_PER_PAGE * DMU_RING_PAGES)
+
+#endif
