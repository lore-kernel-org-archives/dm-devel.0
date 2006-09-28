From: Dan Smith <danms@us.ibm.com>
Subject: Latest dm-userspace kernel code
Date: Thu, 28 Sep 2006 13:59:06 -0700
Message-ID: <m3hcyr4sit.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0054804668=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0054804668==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

Here is my latest dm-userspace kernel code.  This has a lot of
cleanups and fixes since the last version.  We have been successfully
using this version for a while and believe it to be quite stable and
well-performing.  It is not intended to be in final form, but I think
it should be close to functionally complete.

I will post the updated userspace code shortly.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

Signed-off-by: Dan Smith <danms@us.ibm.com>
diff -Naur linux-2.6.18-orig/drivers/md/dm-user.h linux-2.6.18-dmu/drivers/=
md/dm-user.h
=2D-- linux-2.6.18-orig/drivers/md/dm-user.h	1969-12-31 16:00:00.000000000 =
-0800
+++ linux-2.6.18-dmu/drivers/md/dm-user.h	2006-09-28 13:49:18.000000000 -07=
00
@@ -0,0 +1,156 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
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
+	wait_queue_head_t wqueue;     /* To block while waiting for reqs   */
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
diff -Naur linux-2.6.18-orig/drivers/md/dm-userspace.c linux-2.6.18-dmu/dri=
vers/md/dm-userspace.c
=2D-- linux-2.6.18-orig/drivers/md/dm-userspace.c	1969-12-31 16:00:00.00000=
0000 -0800
+++ linux-2.6.18-dmu/drivers/md/dm-userspace.c	2006-09-28 13:49:18.00000000=
0 -0700
@@ -0,0 +1,585 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
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
+/* Add a request to a device's request queue */
+static void add_tx_request(struct dmu_device *dev,
+			   struct dmu_request *req)
+{
+	unsigned long flags;
+
+	BUG_ON(!list_empty(&req->list));
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
+	list_add_tail(&req->list, &dev->tx_requests);
+	atomic_inc(&dev->t_reqs);
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+
+	wake_up(&dev->wqueue);
+}
+
+static void endio_worker(void *data)
+{
+	struct dmu_request *req =3D data;
+	struct dmu_device *dev =3D req->dev;
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
+	struct target_device *target, *match =3D NULL;
+
+	spin_lock(&dev->lock);
+	list_for_each_entry(target, &dev->target_devs, list) {
+		if (target->bdev->bd_dev =3D=3D devno) {
+			match =3D target;
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
+	target =3D find_target(dev, devno);
+	if (target)
+		return target;
+
+	bdev =3D open_by_devnum(devno, FMODE_READ | FMODE_WRITE);
+	if (IS_ERR(bdev)) {
+		DMERR("Unable to lookup device %x", devno);
+		return NULL;
+	}
+
+	target =3D kmalloc(sizeof(*target), GFP_KERNEL);
+	if (!target) {
+		DMERR("Unable to alloc new target device");
+		return NULL;
+	}
+
+	target->bdev =3D bdev;
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
+	dev =3D container_of(ref, struct dmu_device, users);
+
+	spin_lock(&devices_lock);
+	list_del(&dev->list);
+	spin_unlock(&devices_lock);
+
+	list_for_each_safe(cursor, next, &dev->target_devs) {
+		struct target_device *target;
+
+		target =3D list_entry(cursor,
+				    struct target_device,
+				    list);
+
+		put_target(dev, target);
+	}
+
+	list_for_each_safe(cursor, next, &dev->tx_requests) {
+		struct dmu_request *req;
+
+		req =3D list_entry(cursor,
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
+		req =3D list_entry(cursor,
+				 struct dmu_request,
+				 list);
+
+		DMERR("Failing bio");
+		req->flags =3D 0;
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
+		req =3D list_entry(cursor,
+				 struct dmu_request,
+				 list);
+
+		DMERR("Failing bio");
+		req->flags =3D 0;
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
+	init_waitqueue_head(&dev->wqueue);
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
+	dev->block_size  =3D block_size;
+	dev->block_mask  =3D block_size - 1;
+	dev->block_shift =3D ffs(block_size) - 1;
+
+	atomic_set(&dev->t_reqs, 0);
+	atomic_set(&dev->r_reqs, 0);
+	atomic_set(&dev->f_reqs, 0);
+	atomic_set(&dev->total, 0);
+	atomic_set(&dev->idcounter, 0);
+
+	init_MUTEX(&dev->cp_sem);
+
+	ret =3D kcopyd_client_create(DMU_COPY_PAGES, &dev->kcopy);
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
+	dev =3D kmalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev =3D=3D NULL) {
+		DMERR("Failed to allocate new userspace device");
+		return NULL;
+	}
+
+	if (!init_dmu_device(dev, block_size))
+		goto bad1;
+
+	snprintf(dev->key, DMU_KEY_LEN, "%s", key);
+
+	ret =3D register_chardev_transport(dev);
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
+	struct dmu_device *match =3D NULL;
+
+	spin_lock(&devices_lock);
+
+	list_for_each_entry(dev, &devices, list) {
+		spin_lock(&dev->lock);
+		if (strncmp(dev->key, key, DMU_KEY_LEN) =3D=3D 0) {
+			match =3D dev;
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
+	int target_idx =3D 2;
+
+	if (argc < 3) {
+		ti->error =3D "Invalid argument count";
+		return -EINVAL;
+	}
+
+	device_key =3D argv[0];
+	block_size_param =3D argv[1];
+
+	block_size =3D simple_strtoul(block_size_param, NULL, 10) / 512;
+
+	dev =3D find_dmu_device(device_key);
+	if (dev =3D=3D NULL) {
+		dev =3D new_dmu_device(device_key,
+				     ti,
+				     block_size);
+		if (dev =3D=3D NULL) {
+			ti->error =3D "Failed to create device";
+			goto bad;
+		}
+	} else {
+		get_dev(dev);
+	}
+
+	spin_lock(&dev->lock);
+	if (dev->block_size !=3D block_size) {
+		ti->error =3D "Invalid block size";
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
+	ti->private  =3D dev;
+	ti->split_io =3D block_size;
+
+	return 0;
+
+ bad:
+	if (dev) {
+		spin_unlock(&dev->lock);
+	}
+ out:
+	if (dev) {
+		put_dev(dev);
+	}
+
+	return -EINVAL;
+}
+
+static void dmu_dtr(struct dm_target *ti)
+{
+	struct dmu_device *dev =3D (struct dmu_device *) ti->private;
+
+	put_dev(dev);
+}
+
+static void init_req(struct dmu_device *dev,
+		     struct bio *bio,
+		     struct dmu_request *req)
+{
+	req->id =3D (uint64_t) atomic_add_return(1, &dev->idcounter);
+
+	req->type =3D DM_USERSPACE_MAP_BLOCK_REQ;
+	req->dev =3D dev;
+	req->bio =3D bio;
+	req->u.block =3D dmu_block(dev, bio->bi_sector);
+	req->flags =3D 0;
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
+	struct dmu_device *dev =3D (struct dmu_device *) ti->private;
+	struct dmu_request *req;
+
+	if (unlikely(bio_barrier(bio))) {
+		printk("Refusing bio barrier\n");
+		return -EOPNOTSUPP;
+	}
+
+	wait_event_interruptible(dev->lowmem,
+				 atomic_read(&dev->total) <=3D 20000);
+
+	req =3D mempool_alloc(request_pool, GFP_NOIO);
+	if (!req) {
+		DMERR("Failed to alloc request");
+		return -1;
+	}
+
+	atomic_inc(&dev->total);
+
+	map_context->ptr =3D req;
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
+	struct dmu_device *dev =3D (struct dmu_device *) ti->private;
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
+			 dev->block_size * 512);
+		break;
+	}
+
+	return 0;
+}
+
+static int dmu_end_io(struct dm_target *ti, struct bio *bio,
+                        int error, union map_info *map_context)
+{
+	struct dmu_request *req =3D map_context->ptr;
+	int ret =3D 0;
+
+	if (error)
+		return -1;
+
+	if (dmu_get_flag(&req->flags, DMU_FLAG_SYNC)) {
+		req->type =3D DM_USERSPACE_MAP_DONE;
+		add_tx_request(req->dev, req);
+		ret =3D 1;
+	} else {
+		INIT_WORK(&req->task, endio_worker, req);
+		schedule_work(&req->task);
+	}
+
+	return ret;
+}
+
+struct target_type userspace_target =3D {
+	.name    =3D "userspace",
+	.version =3D {0, 1, 0},
+	.module  =3D THIS_MODULE,
+	.ctr     =3D dmu_ctr,
+	.dtr     =3D dmu_dtr,
+	.map     =3D dmu_map,
+	.status  =3D dmu_status,
+	.end_io  =3D dmu_end_io
+};
+
+int __init dm_userspace_init(void)
+{
+	int r =3D dm_register_target(&userspace_target);
+	if (r < 0) {
+		DMERR("Register failed %d", r);
+		return 0;
+	}
+
+	spin_lock_init(&devices_lock);
+
+	request_cache =3D
+		kmem_cache_create("dm-userspace-requests",
+				  sizeof(struct dmu_request),
+				  __alignof__ (struct dmu_request),
+				  0, NULL, NULL);
+	if (!request_cache) {
+		DMERR("Failed to allocate request cache");
+		goto bad;
+	}
+
+	request_pool =3D mempool_create(64,
+				      mempool_alloc_slab, mempool_free_slab,
+				      request_cache);
+	if (!request_pool) {
+		DMERR("Failed to allocate request pool");
+		goto bad2;
+	}
+
+	r =3D init_chardev_transport();
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
+		dev =3D list_entry(cursor, struct dmu_device, list);
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
+	r =3D dm_unregister_target(&userspace_target);
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
diff -Naur linux-2.6.18-orig/drivers/md/dm-userspace-chardev.c linux-2.6.18=
-dmu/drivers/md/dm-userspace-chardev.c
=2D-- linux-2.6.18-orig/drivers/md/dm-userspace-chardev.c	1969-12-31 16:00:=
00.000000000 -0800
+++ linux-2.6.18-dmu/drivers/md/dm-userspace-chardev.c	2006-09-28 13:49:18.=
000000000 -0700
@@ -0,0 +1,598 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
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
+/* This allows for a cleaner separation between the dm-userspace
+ * device-mapper target, and the userspace transport used.  Right now,
+ * only a chardev transport exists, but it's possible that there could
+ * be more in the future
+ */
+struct chardev_transport {
+	struct cdev cdev;
+	dev_t ctl_dev;
+	struct dmu_device *parent;
+};
+
+static struct dmu_request *find_rx_request(struct dmu_device *dev,
+					   uint64_t id)
+{
+	struct dmu_request *req, *next, *match =3D NULL;
+
+	spin_lock(&dev->lock);
+	list_for_each_entry_safe(req, next, &dev->rx_requests, list) {
+		if (req->id =3D=3D id) {
+			list_del_init(&req->list);
+			match =3D req;
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
+	return atomic_read(&dev->t_reqs) !=3D 0;
+}
+
+static int send_userspace_message(uint8_t __user *buffer,
+				  struct dmu_request *req)
+{
+	int ret =3D 0;
+	struct dmu_msg msg;
+
+	memset(&msg, 0, sizeof(msg));
+
+	msg.hdr.id =3D req->id;
+
+	switch (req->type) {
+	case DM_USERSPACE_MAP_BLOCK_REQ:
+		msg.hdr.msg_type =3D req->type;
+		msg.payload.map_req.org_block =3D req->u.block;
+		dmu_cpy_flag(&msg.payload.map_req.flags,
+			     req->flags, DMU_FLAG_WR);
+		break;
+
+	case DM_USERSPACE_MAP_DONE:
+		msg.hdr.msg_type =3D DM_USERSPACE_MAP_DONE;
+		msg.payload.map_done.id_of_op =3D req->id;
+		msg.payload.map_done.org_block =3D req->u.block;
+		dmu_cpy_flag(&msg.payload.map_done.flags,
+			     req->flags, DMU_FLAG_WR);
+		break;
+
+	default:
+		DMWARN("Unknown outgoing message type %i", req->type);
+		ret =3D 0;
+	}
+
+	if (copy_to_user(buffer, &msg, sizeof(msg)))
+		return -EFAULT;
+
+	ret =3D sizeof(msg);
+
+	/* If this request is not on a list (the rx_requests list),
+	 * then it needs to be freed after sending
+	 */
+	if (list_empty(&req->list))
+		mempool_free(req, request_pool);
+
+	return ret;
+}
+
+struct dmu_request *pluck_next_request(struct dmu_device *dev)
+{
+	struct dmu_request *req =3D NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
+	if (!list_empty(&dev->tx_requests)) {
+		req =3D list_entry(dev->tx_requests.next,
+				 struct dmu_request, list);
+		list_del_init(&req->list);
+=09=09
+		atomic_dec(&dev->t_reqs);
+	}
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+=09
+	if (req && ((req->type =3D=3D DM_USERSPACE_MAP_BLOCK_REQ) ||
+		    (req->type =3D=3D DM_USERSPACE_MAP_DONE))) {
+		spin_lock(&dev->lock);
+		list_add_tail(&req->list, &dev->rx_requests);
+		atomic_inc(&dev->r_reqs);
+		spin_unlock(&dev->lock);
+	}
+
+	return req;
+}
+
+ssize_t dmu_ctl_read(struct file *file, char __user *buffer,
+		     size_t size, loff_t *offset)
+{
+
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	struct dmu_request *req =3D NULL;
+	int ret =3D 0, r;
+
+        if (!capable(CAP_SYS_ADMIN))
+                return -EACCES;
+
+	if (size < sizeof(struct dmu_msg)) {
+		DMERR("Userspace buffer too small for a single message");
+		return 0;
+	}
+
+	while (!have_pending_requests(dev)) {
+		if (file->f_flags & O_NONBLOCK) {
+			return 0;
+		}
+
+		if (wait_event_interruptible(dev->wqueue,
+					     have_pending_requests(dev)))
+			return -ERESTARTSYS;
+	}
+
+	while (ret < size) {
+		if ((size - ret) < sizeof(struct dmu_msg))
+			break;
+
+		req =3D pluck_next_request(dev);
+		if (!req)
+			break;
+
+		r =3D send_userspace_message((void *)(buffer + ret), req);
+		if (r =3D=3D 0)
+			continue;
+		else if (r < 0)
+			return r;
+
+		ret +=3D r;
+	}
+
+	if (ret < sizeof(struct dmu_msg)) {
+		if (ret !=3D 0)
+			DMERR("Sending partial message!");
+		DMINFO("Sent 0 requests to userspace");
+	}
+
+	return ret;
+}
+
+static struct dmu_request *pluck_dep_req(struct dmu_request *req)
+{
+	struct dmu_request *dreq =3D NULL;
+
+	if (list_empty(&req->deps)) {
+		/* Delete from cp_requests */
+		list_del_init(&req->copy);
+	} else {
+		/* Get next dependent request */
+		dreq =3D list_entry(req->deps.next, struct dmu_request, list);
+		list_del_init(&dreq->list);
+	}
+
+	return dreq;
+}
+
+static void flush_block(int read_err, unsigned int write_err, void *data)
+{
+	struct dmu_request *req =3D data;
+	struct dmu_request *dreq;
+	uint64_t id =3D req->id;
+
+	if (read_err || write_err) {
+		DMERR("Failed to copy block!");
+		bio_io_error(req->bio, req->bio->bi_size);
+		while ((dreq =3D pluck_dep_req(req))) {
+			bio_io_error(dreq->bio, dreq->bio->bi_size);
+		}
+		return;
+	}
+
+	atomic_inc(&req->dev->f_reqs);
+	generic_make_request(req->bio);
+
+	down(&req->dev->cp_sem);
+	while ((dreq =3D pluck_dep_req(req))) {
+		if (id > dreq->id) {
+			printk(KERN_EMERG "Flushing %llu after %llu\n",
+			       dreq->id, id);
+		}
+		id =3D dreq->id;
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
+	src.bdev =3D src_dev;
+	src.sector =3D dmu_sector(dev, org_block);
+	src.count =3D dev->block_size;
+
+	dst.bdev =3D dst_dev;
+	dst.sector =3D dmu_sector(dev, new_block);
+	dst.sector +=3D offset;
+	dst.count =3D dev->block_size;
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
+	struct dmu_request *dreq =3D NULL;
+	int found =3D 0;
+
+	BUG_ON(!list_empty(&req->list));
+
+	down(&req->dev->cp_sem);
+
+	list_for_each_entry(dreq, &req->dev->cp_requests, copy) {
+		if (req->u.block =3D=3D dreq->u.block) {
+			list_add_tail(&req->list, &dreq->deps);
+			found =3D 1;
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
+	struct dmu_request *req =3D data;
+	struct dmu_msg_map_response *msg =3D &req->response;
+	struct dmu_device *dev =3D req->dev;
+	struct target_device *src_dev, *dst_dev;
+	int need_copy =3D dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST);
+
+	if (dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST)) {
+		src_dev =3D find_target(dev, MKDEV(msg->src_maj, msg->src_min));
+		if (!src_dev) {
+			DMERR("Failed to find src device %i:%i\n",
+			      msg->src_maj, msg->src_min);
+			goto fail;
+		}
+	} else
+		src_dev =3D NULL;
+
+	dst_dev =3D find_target(dev, MKDEV(msg->dst_maj, msg->dst_min));
+	if (!dst_dev) {
+		DMERR("Failed to find dest device %i:%i\n",
+		      msg->dst_maj, msg->dst_min);
+		goto fail;
+	}
+
+	/* Remap the bio */
+	req->bio->bi_sector =3D dmu_sector(dev, msg->new_block) +
+		dmu_sector_offset(dev, req->bio->bi_sector) +
+		msg->offset;
+	req->bio->bi_bdev =3D dst_dev->bdev;
+
+	dmu_set_flag(&req->flags, DMU_FLAG_SYNC);
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
+	req =3D find_rx_request(dev, msg->id_of_req);
+	if (!req) {
+		DMERR("Unable to complete unknown map: %llu\n",
+		      msg->id_of_req);
+		return;
+	}
+
+	memcpy(&req->response, msg, sizeof(req->response));
+
+#if 0
+	/* I think it would be nice to farm this out to a worker
+	 * thread, so that userspace does not have to do all the work,
+	 * but I wonder about the correctness of possibly reordering
+	 * requests to a single block
+	 */
+	INIT_WORK(&req->task, map_worker, req);
+	schedule_work(&req->task);
+#else
+	map_worker(req);
+#endif
+}
+
+static void do_map_done(struct dmu_device *dev, uint64_t id_of_op, int fai=
l)=20
+{
+	struct dmu_request *req;
+
+	req =3D find_rx_request(dev, id_of_op);
+	if (!req) {
+		DMERR("Unable to complete unknown request: %llu\n",
+		      id_of_op);
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
+=09
+	req =3D find_rx_request(dev, id_of_op);
+	if (!req) {
+		DMERR("Unable to fail unknown request: %llu\n",
+		      id_of_op);
+		return;
+	}
+
+	DMERR("Userspace failed to map id %llu (sector %llu)",
+	      id_of_op, req->bio->bi_sector);
+
+	bio_io_error(req->bio, req->bio->bi_size);
+
+	mempool_free(req, request_pool);
+}
+
+ssize_t dmu_ctl_write(struct file *file, const char __user *buffer,
+		      size_t size, loff_t *offset)
+{
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	int ret =3D 0;
+	struct dmu_msg msg;
+
+        if (!capable(CAP_SYS_ADMIN))
+                return -EACCES;
+
+	while ((ret + sizeof(msg)) <=3D size) {
+		if (copy_from_user(&msg, buffer+ret, sizeof(msg))) {
+			DMERR("%s copy_from_user failed!", __FUNCTION__);
+			ret =3D -EFAULT;
+			goto out;
+		}
+
+		ret +=3D sizeof(msg);
+
+		switch (msg.hdr.msg_type) {
+		case DM_USERSPACE_MAP_BLOCK_RESP:
+			do_map_bio(dev, &msg.payload.map_rsp);
+			break;
+
+		case DM_USERSPACE_MAP_FAILED:
+			do_map_failed(dev, msg.payload.map_rsp.id_of_req);
+			break;
+
+		case DM_USERSPACE_MAP_DONE:
+			do_map_done(dev, msg.payload.map_done.id_of_op, 0);
+			break;
+
+		case DM_USERSPACE_MAP_DONE_FAILED:
+			do_map_done(dev, msg.payload.map_done.id_of_op, 1);
+			break;
+
+		default:
+			DMWARN("Unknown incoming request type: %i",
+			       msg.hdr.msg_type);
+		}
+	}
+ out:
+	if (ret < sizeof(msg)) {
+		DMINFO("Received 0 responses from userspace");
+	}
+
+	return ret;
+}
+
+int dmu_ctl_open(struct inode *inode, struct file *file)
+{
+	struct chardev_transport *t;
+	struct dmu_device *dev;
+
+        if (!capable(CAP_SYS_ADMIN))
+                return -EACCES;
+
+	t =3D container_of(inode->i_cdev, struct chardev_transport, cdev);
+	dev =3D t->parent;
+
+	get_dev(dev);
+
+	file->private_data =3D dev;
+
+	return 0;
+}
+
+int dmu_ctl_release(struct inode *inode, struct file *file)
+{
+	struct dmu_device *dev;
+
+	dev =3D (struct dmu_device *)file->private_data;
+
+	put_dev(dev);
+
+	return 0;
+}
+
+unsigned dmu_ctl_poll(struct file *file, poll_table *wait)
+{
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	unsigned mask =3D 0;
+
+	poll_wait(file, &dev->wqueue, wait);
+
+	if (have_pending_requests(dev))
+		mask |=3D POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static struct file_operations ctl_fops =3D {
+	.open    =3D dmu_ctl_open,
+	.release =3D dmu_ctl_release,
+	.read    =3D dmu_ctl_read,
+	.write   =3D dmu_ctl_write,
+	.poll    =3D dmu_ctl_poll,
+	.owner   =3D THIS_MODULE,
+};
+
+static int get_free_minor(void)
+{
+	struct dmu_device *dev;
+	int minor =3D 0;
+
+	spin_lock(&devices_lock);
+
+	while (1) {
+		list_for_each_entry(dev, &devices, list) {
+			struct chardev_transport *t =3D dev->transport_private;
+			if (MINOR(t->ctl_dev) =3D=3D minor)
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
+	dev->transport_private =3D kmalloc(sizeof(struct chardev_transport),
+					 GFP_KERNEL);
+	t =3D dev->transport_private;
+
+	if (!t) {
+		DMERR("Failed to allocate chardev transport");
+		goto bad;
+	}
+
+	t->ctl_dev =3D MKDEV(MAJOR(dmu_dev), get_free_minor());
+	t->parent =3D dev;
+
+	cdev_init(&t->cdev, &ctl_fops);
+	t->cdev.owner =3D THIS_MODULE;
+	t->cdev.ops =3D &ctl_fops;
+
+	ret =3D cdev_add(&t->cdev, t->ctl_dev, 1);
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
+	struct chardev_transport *t =3D dev->transport_private;
+
+	cdev_del(&t->cdev);
+	kfree(t);
+}
+
+int init_chardev_transport(void)
+{
+	int r;
+
+	r =3D alloc_chrdev_region(&dmu_dev, 0, 10, "dm-userspace");
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
+	struct chardev_transport *t =3D dev->transport_private;
+
+	snprintf(buf, maxlen, "%x:%x",
+		 MAJOR(t->ctl_dev), MINOR(t->ctl_dev));
+}
diff -Naur linux-2.6.18-orig/drivers/md/Kconfig linux-2.6.18-dmu/drivers/md=
/Kconfig
=2D-- linux-2.6.18-orig/drivers/md/Kconfig	2006-09-19 20:42:06.000000000 -0=
700
+++ linux-2.6.18-dmu/drivers/md/Kconfig	2006-09-28 13:49:18.000000000 -0700
@@ -223,6 +223,12 @@
        ---help---
          Allow volume managers to take writable snapshots of a device.
=20
+config DM_USERSPACE
+       tristate "Userspace target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       ---help---
+	 A target that provides a userspace interface to device-mapper
+
 config DM_MIRROR
        tristate "Mirror target (EXPERIMENTAL)"
        depends on BLK_DEV_DM && EXPERIMENTAL
diff -Naur linux-2.6.18-orig/drivers/md/Kconfig.orig linux-2.6.18-dmu/drive=
rs/md/Kconfig.orig
=2D-- linux-2.6.18-orig/drivers/md/Kconfig.orig	1969-12-31 16:00:00.0000000=
00 -0800
+++ linux-2.6.18-dmu/drivers/md/Kconfig.orig	2006-09-19 20:42:06.000000000 =
-0700
@@ -0,0 +1,253 @@
+#
+# Block device driver configuration
+#
+
+menu "Multi-device support (RAID and LVM)"
+
+config MD
+	bool "Multiple devices driver support (RAID and LVM)"
+	help
+	  Support multiple physical spindles through a single logical device.
+	  Required for RAID and logical volume management.
+
+config BLK_DEV_MD
+	tristate "RAID support"
+	depends on MD
+	---help---
+	  This driver lets you combine several hard disk partitions into one
+	  logical block device. This can be used to simply append one
+	  partition to another one or to combine several redundant hard disks
+	  into a RAID1/4/5 device so as to provide protection against hard
+	  disk failures. This is called "Software RAID" since the combining of
+	  the partitions is done by the kernel. "Hardware RAID" means that the
+	  combining is done by a dedicated controller; if you have such a
+	  controller, you do not need to say Y here.
+
+	  More information about Software RAID on Linux is contained in the
+	  Software RAID mini-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>. There you will also learn
+	  where to get the supporting user space utilities raidtools.
+
+	  If unsure, say N.
+
+config MD_LINEAR
+	tristate "Linear (append) mode"
+	depends on BLK_DEV_MD
+	---help---
+	  If you say Y here, then your multiple devices driver will be able to
+	  use the so-called linear mode, i.e. it will combine the hard disk
+	  partitions by simply appending one to the other.
+
+	  To compile this as a module, choose M here: the module
+	  will be called linear.
+
+	  If unsure, say Y.
+
+config MD_RAID0
+	tristate "RAID-0 (striping) mode"
+	depends on BLK_DEV_MD
+	---help---
+	  If you say Y here, then your multiple devices driver will be able to
+	  use the so-called raid0 mode, i.e. it will combine the hard disk
+	  partitions into one logical device in such a fashion as to fill them
+	  up evenly, one chunk here and one chunk there. This will increase
+	  the throughput rate if the partitions reside on distinct disks.
+
+	  Information about Software RAID on Linux is contained in the
+	  Software-RAID mini-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>. There you will also
+	  learn where to get the supporting user space utilities raidtools.
+
+	  To compile this as a module, choose M here: the module
+	  will be called raid0.
+
+	  If unsure, say Y.
+
+config MD_RAID1
+	tristate "RAID-1 (mirroring) mode"
+	depends on BLK_DEV_MD
+	---help---
+	  A RAID-1 set consists of several disk drives which are exact copies
+	  of each other.  In the event of a mirror failure, the RAID driver
+	  will continue to use the operational mirrors in the set, providing
+	  an error free MD (multiple device) to the higher levels of the
+	  kernel.  In a set with N drives, the available space is the capacity
+	  of a single drive, and the set protects against a failure of (N - 1)
+	  drives.
+
+	  Information about Software RAID on Linux is contained in the
+	  Software-RAID mini-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  There you will also
+	  learn where to get the supporting user space utilities raidtools.
+
+	  If you want to use such a RAID-1 set, say Y.  To compile this code
+	  as a module, choose M here: the module will be called raid1.
+
+	  If unsure, say Y.
+
+config MD_RAID10
+	tristate "RAID-10 (mirrored striping) mode (EXPERIMENTAL)"
+	depends on BLK_DEV_MD && EXPERIMENTAL
+	---help---
+	  RAID-10 provides a combination of striping (RAID-0) and
+	  mirroring (RAID-1) with easier configuration and more flexible
+	  layout.
+	  Unlike RAID-0, but like RAID-1, RAID-10 requires all devices to
+	  be the same size (or at least, only as much as the smallest device
+	  will be used).
+	  RAID-10 provides a variety of layouts that provide different levels
+	  of redundancy and performance.
+
+	  RAID-10 requires mdadm-1.7.0 or later, available at:
+
+	  ftp://ftp.kernel.org/pub/linux/utils/raid/mdadm/
+
+	  If unsure, say Y.
+
+config MD_RAID456
+	tristate "RAID-4/RAID-5/RAID-6 mode"
+	depends on BLK_DEV_MD
+	---help---
+	  A RAID-5 set of N drives with a capacity of C MB per drive provides
+	  the capacity of C * (N - 1) MB, and protects against a failure
+	  of a single drive. For a given sector (row) number, (N - 1) drives
+	  contain data sectors, and one drive contains the parity protection.
+	  For a RAID-4 set, the parity blocks are present on a single drive,
+	  while a RAID-5 set distributes the parity across the drives in one
+	  of the available parity distribution methods.
+
+	  A RAID-6 set of N drives with a capacity of C MB per drive
+	  provides the capacity of C * (N - 2) MB, and protects
+	  against a failure of any two drives. For a given sector
+	  (row) number, (N - 2) drives contain data sectors, and two
+	  drives contains two independent redundancy syndromes.  Like
+	  RAID-5, RAID-6 distributes the syndromes across the drives
+	  in one of the available parity distribution methods.
+
+	  Information about Software RAID on Linux is contained in the
+	  Software-RAID mini-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>. There you will also
+	  learn where to get the supporting user space utilities raidtools.
+
+	  If you want to use such a RAID-4/RAID-5/RAID-6 set, say Y.  To
+	  compile this code as a module, choose M here: the module
+	  will be called raid456.
+
+	  If unsure, say Y.
+
+config MD_RAID5_RESHAPE
+	bool "Support adding drives to a raid-5 array (experimental)"
+	depends on MD_RAID456 && EXPERIMENTAL
+	---help---
+	  A RAID-5 set can be expanded by adding extra drives. This
+	  requires "restriping" the array which means (almost) every
+	  block must be written to a different place.
+
+          This option allows such restriping to be done while the array
+	  is online.  However it is still EXPERIMENTAL code.  It should
+	  work, but please be sure that you have backups.
+
+	  You will need mdadm version 2.4.1 or later to use this
+	  feature safely.  During the early stage of reshape there is
+	  a critical section where live data is being over-written.  A
+	  crash during this time needs extra care for recovery.  The
+	  newer mdadm takes a copy of the data in the critical section
+	  and will restore it, if necessary, after a crash.
+
+	  The mdadm usage is e.g.
+	       mdadm --grow /dev/md1 --raid-disks=3D6
+	  to grow '/dev/md1' to having 6 disks.
+
+	  Note: The array can only be expanded, not contracted.
+	  There should be enough spares already present to make the new
+	  array workable.
+
+config MD_MULTIPATH
+	tristate "Multipath I/O support"
+	depends on BLK_DEV_MD
+	help
+	  Multipath-IO is the ability of certain devices to address the same
+	  physical disk over multiple 'IO paths'. The code ensures that such
+	  paths can be defined and handled at runtime, and ensures that a
+	  transparent failover to the backup path(s) happens if a IO errors
+	  arrives on the primary path.
+
+	  If unsure, say N.
+
+config MD_FAULTY
+	tristate "Faulty test module for MD"
+	depends on BLK_DEV_MD
+	help
+	  The "faulty" module allows for a block device that occasionally returns
+	  read or write errors.  It is useful for testing.
+
+	  In unsure, say N.
+
+config BLK_DEV_DM
+	tristate "Device mapper support"
+	depends on MD
+	---help---
+	  Device-mapper is a low level volume manager.  It works by allowing
+	  people to specify mappings for ranges of logical sectors.  Various
+	  mapping types are available, in addition people may write their own
+	  modules containing custom mappings if they wish.
+
+	  Higher level volume managers such as LVM2 use this driver.
+
+	  To compile this as a module, choose M here: the module will be
+	  called dm-mod.
+
+	  If unsure, say N.
+
+config DM_CRYPT
+	tristate "Crypt target support"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	select CRYPTO
+	---help---
+	  This device-mapper target allows you to create a device that
+	  transparently encrypts the data on it. You'll need to activate
+	  the ciphers you're going to use in the cryptoapi configuration.
+
+	  Information on how to use dm-crypt can be found on
+
+	  <http://www.saout.de/misc/dm-crypt/>
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-crypt.
+
+	  If unsure, say N.
+
+config DM_SNAPSHOT
+       tristate "Snapshot target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       ---help---
+         Allow volume managers to take writable snapshots of a device.
+
+config DM_MIRROR
+       tristate "Mirror target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       ---help---
+         Allow volume managers to mirror logical volumes, also
+         needed for live data migration tools such as 'pvmove'.
+
+config DM_ZERO
+	tristate "Zero target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  A target that discards writes, and returns all zeroes for
+	  reads.  Useful in some recovery situations.
+
+config DM_MULTIPATH
+	tristate "Multipath target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Allow volume managers to support multipath hardware.
+
+config DM_MULTIPATH_EMC
+	tristate "EMC CX/AX multipath support (EXPERIMENTAL)"
+	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
+	---help---
+	  Multipath support for EMC CX/AX series hardware.
+
+endmenu
+
diff -Naur linux-2.6.18-orig/drivers/md/Makefile linux-2.6.18-dmu/drivers/m=
d/Makefile
=2D-- linux-2.6.18-orig/drivers/md/Makefile	2006-09-19 20:42:06.000000000 -=
0700
+++ linux-2.6.18-dmu/drivers/md/Makefile	2006-09-28 13:49:18.000000000 -0700
@@ -14,6 +14,7 @@
 		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
 		   raid6altivec8.o \
 		   raid6mmx.o raid6sse1.o raid6sse2.o
+dm-user-objs    :=3D dm-userspace.o dm-userspace-chardev.o
 hostprogs-y	:=3D mktables
=20
 # Note: link order is important.  All raid personalities
@@ -36,6 +37,7 @@
 obj-$(CONFIG_DM_SNAPSHOT)	+=3D dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+=3D dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+=3D dm-zero.o
+obj-$(CONFIG_DM_USERSPACE)      +=3D dm-user.o
=20
 quiet_cmd_unroll =3D UNROLL  $@
       cmd_unroll =3D $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
diff -Naur linux-2.6.18-orig/drivers/md/Makefile.orig linux-2.6.18-dmu/driv=
ers/md/Makefile.orig
=2D-- linux-2.6.18-orig/drivers/md/Makefile.orig	1969-12-31 16:00:00.000000=
000 -0800
+++ linux-2.6.18-dmu/drivers/md/Makefile.orig	2006-09-19 20:42:06.000000000=
 -0700
@@ -0,0 +1,107 @@
+#
+# Makefile for the kernel software RAID and LVM drivers.
+#
+
+dm-mod-objs	:=3D dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
+		   dm-ioctl.o dm-io.o kcopyd.o
+dm-multipath-objs :=3D dm-hw-handler.o dm-path-selector.o dm-mpath.o
+dm-snapshot-objs :=3D dm-snap.o dm-exception-store.o
+dm-mirror-objs	:=3D dm-log.o dm-raid1.o
+md-mod-objs     :=3D md.o bitmap.o
+raid456-objs	:=3D raid5.o raid6algos.o raid6recov.o raid6tables.o \
+		   raid6int1.o raid6int2.o raid6int4.o \
+		   raid6int8.o raid6int16.o raid6int32.o \
+		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
+		   raid6altivec8.o \
+		   raid6mmx.o raid6sse1.o raid6sse2.o
+hostprogs-y	:=3D mktables
+
+# Note: link order is important.  All raid personalities
+# and xor.o must come before md.o, as they each initialise=20
+# themselves, and md.o may use the personalities when it=20
+# auto-initialised.
+
+obj-$(CONFIG_MD_LINEAR)		+=3D linear.o
+obj-$(CONFIG_MD_RAID0)		+=3D raid0.o
+obj-$(CONFIG_MD_RAID1)		+=3D raid1.o
+obj-$(CONFIG_MD_RAID10)		+=3D raid10.o
+obj-$(CONFIG_MD_RAID456)	+=3D raid456.o xor.o
+obj-$(CONFIG_MD_MULTIPATH)	+=3D multipath.o
+obj-$(CONFIG_MD_FAULTY)		+=3D faulty.o
+obj-$(CONFIG_BLK_DEV_MD)	+=3D md-mod.o
+obj-$(CONFIG_BLK_DEV_DM)	+=3D dm-mod.o
+obj-$(CONFIG_DM_CRYPT)		+=3D dm-crypt.o
+obj-$(CONFIG_DM_MULTIPATH)	+=3D dm-multipath.o dm-round-robin.o
+obj-$(CONFIG_DM_MULTIPATH_EMC)	+=3D dm-emc.o
+obj-$(CONFIG_DM_SNAPSHOT)	+=3D dm-snapshot.o
+obj-$(CONFIG_DM_MIRROR)		+=3D dm-mirror.o
+obj-$(CONFIG_DM_ZERO)		+=3D dm-zero.o
+
+quiet_cmd_unroll =3D UNROLL  $@
+      cmd_unroll =3D $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
+                   < $< > $@ || ( rm -f $@ && exit 1 )
+
+ifeq ($(CONFIG_ALTIVEC),y)
+altivec_flags :=3D -maltivec -mabi=3Daltivec
+endif
+
+targets +=3D raid6int1.c
+$(obj)/raid6int1.c:   UNROLL :=3D 1
+$(obj)/raid6int1.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets +=3D raid6int2.c
+$(obj)/raid6int2.c:   UNROLL :=3D 2
+$(obj)/raid6int2.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets +=3D raid6int4.c
+$(obj)/raid6int4.c:   UNROLL :=3D 4
+$(obj)/raid6int4.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets +=3D raid6int8.c
+$(obj)/raid6int8.c:   UNROLL :=3D 8
+$(obj)/raid6int8.c:   $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets +=3D raid6int16.c
+$(obj)/raid6int16.c:  UNROLL :=3D 16
+$(obj)/raid6int16.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+targets +=3D raid6int32.c
+$(obj)/raid6int32.c:  UNROLL :=3D 32
+$(obj)/raid6int32.c:  $(src)/raid6int.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec1.o +=3D $(altivec_flags)
+targets +=3D raid6altivec1.c
+$(obj)/raid6altivec1.c:   UNROLL :=3D 1
+$(obj)/raid6altivec1.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec2.o +=3D $(altivec_flags)
+targets +=3D raid6altivec2.c
+$(obj)/raid6altivec2.c:   UNROLL :=3D 2
+$(obj)/raid6altivec2.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec4.o +=3D $(altivec_flags)
+targets +=3D raid6altivec4.c
+$(obj)/raid6altivec4.c:   UNROLL :=3D 4
+$(obj)/raid6altivec4.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+CFLAGS_raid6altivec8.o +=3D $(altivec_flags)
+targets +=3D raid6altivec8.c
+$(obj)/raid6altivec8.c:   UNROLL :=3D 8
+$(obj)/raid6altivec8.c:   $(src)/raid6altivec.uc $(src)/unroll.pl FORCE
+	$(call if_changed,unroll)
+
+quiet_cmd_mktable =3D TABLE   $@
+      cmd_mktable =3D $(obj)/mktables > $@ || ( rm -f $@ && exit 1 )
+
+targets +=3D raid6tables.c
+$(obj)/raid6tables.c: $(obj)/mktables FORCE
+	$(call if_changed,mktable)
diff -Naur linux-2.6.18-orig/include/linux/dm-userspace.h linux-2.6.18-dmu/=
include/linux/dm-userspace.h
=2D-- linux-2.6.18-orig/include/linux/dm-userspace.h	1969-12-31 16:00:00.00=
0000000 -0800
+++ linux-2.6.18-dmu/include/linux/dm-userspace.h	2006-09-28 13:49:18.00000=
0000 -0700
@@ -0,0 +1,115 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
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
+	return (*flags & flag) !=3D 0;
+}
+
+static inline void dmu_set_flag(uint32_t *flags, uint32_t flag)
+{
+	*flags |=3D flag;
+}
+
+static inline void dmu_clr_flag(uint32_t *flags, uint32_t flag)
+{
+	*flags &=3D (~flag);
+}
+
+static inline void dmu_cpy_flag(uint32_t *flags, uint32_t src, uint32_t fl=
ag)
+{
+	*flags =3D (*flags & ~flag) | (src & flag);
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
+#endif

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHDedwtEf7b4GJVQRAoElAJ94uQqWdUiNlMydoFFcAVVONp+CmgCbB/HG
L1284O6ZOL1Ln0C9d4hIyjw=
=Jj5B
-----END PGP SIGNATURE-----
--=-=-=--


--===============0054804668==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0054804668==--
