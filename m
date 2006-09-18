From: Dan Smith <danms@us.ibm.com>
Subject: Latest dm-userspace kernel code
Date: Mon, 18 Sep 2006 07:52:48 -0700
Message-ID: <m38xkhmdkv.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1203991768=="
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
Cc: fujita.tomonori@lab.ntt.co.jp
List-Id: dm-devel.ids

--===============1203991768==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

This is the latest dm-userspace kernel code.  I have removed the
in-kernel remap cache and cleaned up a lot of code as a result.
Performance of the map cache/no cache versions seem to be about the
same.

I also tweaked the message protocol to be more rigid.  It now looks
more like the ringbuffer messages, which should allow an easier
transition to a ringbuffer approach.  This is not completely clean,
but I wanted to post it for visibility now that it seems to be stable
for me.

I will send the userspace example code shortly...

Comments appreciated.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

Signed-off-by: Dan Smith <danms@us.ibm.com>
diff -Naur linux-2.6.17.13-orig/drivers/md/dm-user.h linux-2.6.17.13-dmu/dr=
ivers/md/dm-user.h
=2D-- linux-2.6.17.13-orig/drivers/md/dm-user.h	1969-12-31 16:00:00.0000000=
00 -0800
+++ linux-2.6.17.13-dmu/drivers/md/dm-user.h	2006-09-15 14:20:48.000000000 =
-0700
@@ -0,0 +1,142 @@
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
+	struct list_head tx_requests; /* Requests to send to userspace     */
+	struct list_head rx_requests; /* Requests waiting for reply        */
+	struct list_head cp_requests; /* Requests waiting to be copied     */
+
+	struct list_head target_devs; /* List of devices we can target     */
+
+	void *transport_private;      /* Private data for userspace comms  */
+
+	char key[DMU_KEY_LEN];        /* Unique name string for device     */
+	struct kref users;            /* Self-destructing reference count  */
+
+	wait_queue_head_t wqueue;     /* To block while waiting for reqs   */
+
+	uint64_t block_size;          /* Block size for this device        */
+	uint64_t block_mask;          /* Mask for offset in block          */
+	unsigned int block_shift;     /* Shift to convert to/from block    */
+
+	struct kcopyd_client *kcopy;  /* Interface to kcopyd               */
+
+	/* FIXME: Remove after debugging */
+	atomic_t t_reqs;
+	atomic_t r_reqs;
+	atomic_t f_reqs;
+	atomic_t total;
+};
+
+struct dmu_request {
+	struct list_head list;        /* Our place on the request queue    */
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
diff -Naur linux-2.6.17.13-orig/drivers/md/dm-userspace.c linux-2.6.17.13-d=
mu/drivers/md/dm-userspace.c
=2D-- linux-2.6.17.13-orig/drivers/md/dm-userspace.c	1969-12-31 16:00:00.00=
0000000 -0800
+++ linux-2.6.17.13-dmu/drivers/md/dm-userspace.c	2006-09-15 14:20:48.00000=
0000 -0700
@@ -0,0 +1,575 @@
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
+
+	req->id =3D (uint64_t)(unsigned int)req;
+
+	spin_lock(&dev->lock);
+	list_add_tail(&req->list, &dev->tx_requests);
+	spin_unlock(&dev->lock);
+
+	wake_up(&dev->wqueue);
+}
+
+/* Handle the cleanup of a request once its endio has fired.  In
+ * general, the endio has been allowed to complete and all this does
+ * is clean up the request (or wait, if necessary).  In the case of a
+ * SYNC request, we may need to send a message to userspace
+ */
+static void endio_worker(void *data)
+{
+	struct dmu_request *req =3D data;
+	enum {RESCHED, REQ_SYNC, FREE_REQ} task;
+
+	spin_lock(&req->dev->lock);
+	if (dmu_get_flag(&req->flags, DMU_FLAG_SYNC))
+		task =3D REQ_SYNC;
+	else if (!list_empty(&req->list))
+		task =3D RESCHED;
+	else if (list_empty(&req->list))
+		task =3D FREE_REQ;
+	spin_unlock(&req->dev->lock);
+
+	if (task =3D=3D REQ_SYNC) {
+		req->type =3D DM_USERSPACE_SYNC_COMPLETE;
+		add_tx_request(req->dev, req);
+		atomic_inc(&req->dev->t_reqs);
+	} else if (task =3D=3D RESCHED) {
+		PREPARE_WORK(&req->task, endio_worker, req);
+		schedule_work(&req->task);
+	} else if (task =3D=3D FREE_REQ) {
+		atomic_dec(&req->dev->f_reqs);
+		mempool_free(req, request_pool);
+	}
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
+	INIT_LIST_HEAD(&dev->list);
+	INIT_LIST_HEAD(&dev->target_devs);
+	kref_init(&dev->users);
+	spin_lock_init(&dev->lock);
+
+	INIT_LIST_HEAD(&dev->tx_requests);
+	INIT_LIST_HEAD(&dev->rx_requests);
+	INIT_LIST_HEAD(&dev->cp_requests);
+
+	dev->block_size  =3D block_size;
+	dev->block_mask  =3D block_size - 1;
+	dev->block_shift =3D ffs(block_size) - 1;
+
+	printk("%s: %llu %llu %u\n",  dev->key,
+	       dev->block_size, dev->block_mask, dev->block_shift);
+
+	atomic_set(&dev->t_reqs, 0);
+	atomic_set(&dev->r_reqs, 0);
+	atomic_set(&dev->f_reqs, 0);
+	atomic_set(&dev->total, 0);
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
+static int dmu_map(struct dm_target *ti, struct bio *bio,
+		   union map_info *map_context)
+{
+	struct dmu_device *dev =3D (struct dmu_device *) ti->private;
+	struct dmu_request *req;
+
+	req =3D mempool_alloc(request_pool, GFP_NOIO);
+	if (!req) {
+		DMERR("Failed to alloc request");
+		return -1;
+	}
+
+	atomic_inc(&dev->t_reqs);
+	atomic_inc(&dev->total);
+
+	map_context->ptr =3D req;
+
+	/* FIXME: Need an allocation function here */
+	req->type =3D DM_USERSPACE_MAP_BLOCK_REQ;
+	req->dev =3D dev;
+	req->bio =3D bio;
+	req->u.block =3D dmu_block(dev, bio->bi_sector);
+	req->flags =3D 0;
+	INIT_LIST_HEAD(&req->deps);
+
+	if (bio_rw(bio))
+		dmu_set_flag(&req->flags, DMU_FLAG_WR);
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
+	printk("Requests: %u t:%u r:%u f:%u (%c%c)\n",
+	       atomic_read(&dev->total),
+	       atomic_read(&dev->t_reqs),
+	       atomic_read(&dev->r_reqs),
+	       atomic_read(&dev->f_reqs),
+	       list_empty(&dev->tx_requests) ? ' ':'T',
+	       list_empty(&dev->rx_requests) ? ' ':'R');
+	spin_unlock(&dev->lock);
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
+	if (error) {
+		DMERR("Error in dmu_end_io");
+		return -1;
+	}
+
+	INIT_WORK(&req->task, endio_worker, req);
+	schedule_work(&req->task);
+
+	if (dmu_get_flag(&req->flags, DMU_FLAG_SYNC))
+	    ret =3D 1;
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
diff -Naur linux-2.6.17.13-orig/drivers/md/dm-userspace-chardev.c linux-2.6=
.17.13-dmu/drivers/md/dm-userspace-chardev.c
=2D-- linux-2.6.17.13-orig/drivers/md/dm-userspace-chardev.c	1969-12-31 16:=
00:00.000000000 -0800
+++ linux-2.6.17.13-dmu/drivers/md/dm-userspace-chardev.c	2006-09-15 14:20:=
48.000000000 -0700
@@ -0,0 +1,614 @@
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
+static void add_rx_request(struct dmu_device *dev,
+			   struct dmu_request *req)
+{
+	spin_lock(&dev->lock);
+	list_add_tail(&req->list, &dev->rx_requests);
+	spin_unlock(&dev->lock);
+}
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
+	case DM_USERSPACE_GET_VERSION:
+		msg.hdr.msg_type =3D req->type;
+		msg.payload.ver.kernel_ver =3D
+			userspace_target.version[0] << 16 |
+			userspace_target.version[1] << 8  |
+			userspace_target.version[2];
+
+		break;
+
+	case DM_USERSPACE_MAP_BLOCK_REQ:
+		msg.hdr.msg_type =3D req->type;
+		msg.payload.map_req.org_block =3D req->u.block;
+		dmu_cpy_flag(&msg.payload.map_req.flags,
+			     req->flags, DMU_FLAG_RD);
+		dmu_cpy_flag(&msg.payload.map_req.flags,
+			     req->flags, DMU_FLAG_WR);
+
+		break;
+
+	case DM_USERSPACE_SYNC_COMPLETE:
+	case DM_USERSPACE_INVAL_COMPLETE:
+	case DM_USERSPACE_INVAL_FAILED:
+		msg.hdr.msg_type =3D DM_USERSPACE_STATUS;
+		msg.payload.status.status =3D req->type;
+		msg.payload.status.id_of_op =3D req->id;
+
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
+	if ((msg.hdr.msg_type !=3D DM_USERSPACE_MAP_BLOCK_REQ) &&
+	    (msg.hdr.msg_type !=3D DM_USERSPACE_STATUS)) {
+		printk("Sending weird message type %u\n", msg.hdr.msg_type);
+	}
+
+	if (req->type =3D=3D DM_USERSPACE_GET_VERSION) {
+		mempool_free(req, request_pool);
+	}
+
+	return ret;
+}
+
+struct dmu_request *pluck_next_request(struct dmu_device *dev)
+{
+	struct dmu_request *req =3D NULL;
+
+	spin_lock(&dev->lock);
+	if (!list_empty(&dev->tx_requests)) {
+		req =3D list_entry(dev->tx_requests.next,
+				 struct dmu_request, list);
+
+		list_del_init(&req->list);
+		atomic_dec(&dev->t_reqs);
+	}
+	spin_unlock(&dev->lock);
+
+	if (req && ((req->type =3D=3D DM_USERSPACE_MAP_BLOCK_REQ) ||
+		    (req->type =3D=3D DM_USERSPACE_SYNC_COMPLETE))) {
+		add_rx_request(dev, req);
+		atomic_inc(&dev->r_reqs);
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
+	if (ret < sizeof(struct dmu_msg))
+		DMINFO("Sent 0 requests to userspace");
+
+	return ret;
+}
+
+/*
+ * Adds the request to the front of the queue so it's picked up first
+ */
+static void add_urgent_request(struct dmu_device *dev,
+			       struct dmu_request *req)
+{
+
+	if (in_interrupt())
+		printk("%s in irq\n", __FUNCTION__);
+
+	spin_lock(&dev->lock);
+	list_add(&req->list, &dev->tx_requests);
+	spin_unlock(&dev->lock);
+
+	wake_up(&dev->wqueue);
+}
+
+static int version_request(struct dmu_msg_version *msg,
+			   struct dmu_device *dev, uint32_t id)
+{
+	struct dmu_request *req;
+
+	req =3D mempool_alloc(request_pool, GFP_NOIO);
+	if (!req) {
+		DMERR("Failed to alloc version response");
+		return 0;
+	}
+
+	atomic_inc(&dev->t_reqs);
+
+	req->dev =3D dev;
+	req->type =3D DM_USERSPACE_GET_VERSION;
+	add_urgent_request(dev, req);
+
+	return 1;
+}
+
+static struct dmu_request *pluck_dep_req(struct dmu_request *req)
+{
+	struct dmu_request *dreq =3D NULL;
+
+	spin_lock(&req->dev->lock);
+	if (list_empty(&req->deps)) {
+		/* Delete from cp_requests */
+		list_del_init(&req->list);
+	} else {
+		/* Get next dependent request */
+		dreq =3D list_entry(req->deps.next, struct dmu_request, list);
+		list_del_init(&dreq->list);
+	}
+	spin_unlock(&req->dev->lock);
+
+	return dreq;
+}
+
+static void flush_block(int read_err, unsigned int write_err, void *data)
+{
+	struct dmu_request *req =3D data;
+	struct dmu_request *dreq;
+
+	generic_make_request(req->bio);
+
+	while ((dreq =3D pluck_dep_req(req)))
+		generic_make_request(dreq->bio);
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
+	src.sector =3D org_block << dev->block_shift;
+	src.count =3D dev->block_size;
+
+	dst.bdev =3D dst_dev;
+	dst.sector =3D new_block << dev->block_shift;
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
+static int queue_dependent_request(struct dmu_request *req)
+{
+	struct dmu_request *dreq =3D NULL;
+	int found =3D 0;
+
+	spin_lock(&req->dev->lock);
+	list_for_each_entry(dreq, &req->dev->cp_requests, list) {
+		if (dmu_block(req->dev, req->bio->bi_sector) =3D=3D
+		    dmu_block(req->dev, dreq->bio->bi_sector)) {
+			list_add_tail(&req->list, &dreq->deps);
+			found =3D 1;
+			break;
+		}
+	}
+	spin_unlock(&req->dev->lock);
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
+	dmu_cpy_flag(&req->flags, msg->flags, DMU_FLAG_SYNC);
+
+	atomic_dec(&dev->r_reqs);
+	atomic_inc(&dev->f_reqs);
+
+	if (!queue_dependent_request(req)) {
+		if (dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST)) {
+			spin_lock(&dev->lock);
+			list_add(&req->list, &req->dev->cp_requests);
+			spin_unlock(&dev->lock);
+
+			copy_block(dev, src_dev->bdev, dst_dev->bdev, req,
+				   msg->org_block, msg->new_block,
+				   msg->offset);
+		} else {
+			flush_block(0, 0, req);
+		}
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
+	INIT_WORK(&req->task, map_worker, req);
+	schedule_work(&req->task);
+}
+
+static void do_sync_complete(struct dmu_device *dev, uint32_t id_of_op) {
+	struct dmu_request *req;
+
+	req =3D find_rx_request(dev, id_of_op);
+	if (!req) {
+		DMERR("Unable to complete unknown request: %u\n",
+		      id_of_op);
+		return;
+	}
+
+	atomic_dec(&req->dev->r_reqs);
+
+	dmu_clr_flag(&req->flags, DMU_FLAG_SYNC);
+
+	req->bio->bi_end_io(req->bio, 0, 0);
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
+
+		case DM_USERSPACE_GET_VERSION:
+			version_request(&msg.payload.ver, dev, msg.hdr.id);
+			break;
+
+		case DM_USERSPACE_MAP_BLOCK_RESP:
+			do_map_bio(dev, &msg.payload.map_rsp);
+			break;
+
+		case DM_USERSPACE_MAP_FAILED:
+			/* FIXME: Do something here */
+			DMERR("Userspace map failed");
+			break;
+
+		case DM_USERSPACE_STATUS:
+			if (msg.payload.status.status =3D=3D
+			    DM_USERSPACE_SYNC_COMPLETE) {
+				do_sync_complete(dev,
+						 msg.payload.status.id_of_op);
+			} else {
+				printk("Unknown status type %u\n",
+				       msg.payload.status.status);
+			}
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
diff -Naur linux-2.6.17.13-orig/drivers/md/Kconfig linux-2.6.17.13-dmu/driv=
ers/md/Kconfig
=2D-- linux-2.6.17.13-orig/drivers/md/Kconfig	2006-09-08 20:23:25.000000000=
 -0700
+++ linux-2.6.17.13-dmu/drivers/md/Kconfig	2006-09-15 14:20:48.000000000 -0=
700
@@ -237,6 +237,12 @@
        ---help---
          Allow volume managers to take writeable snapshots of a device.
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
diff -Naur linux-2.6.17.13-orig/drivers/md/Makefile linux-2.6.17.13-dmu/dri=
vers/md/Makefile
=2D-- linux-2.6.17.13-orig/drivers/md/Makefile	2006-09-08 20:23:25.00000000=
0 -0700
+++ linux-2.6.17.13-dmu/drivers/md/Makefile	2006-09-15 14:20:48.000000000 -=
0700
@@ -14,6 +14,7 @@
 		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
 		   raid6altivec8.o \
 		   raid6mmx.o raid6sse1.o raid6sse2.o
+dm-user-objs    :=3D dm-userspace.o dm-userspace-chardev.o
 hostprogs-y	:=3D mktables
=20
 # Note: link order is important.  All raid personalities
@@ -37,6 +38,7 @@
 obj-$(CONFIG_DM_SNAPSHOT)	+=3D dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+=3D dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+=3D dm-zero.o
+obj-$(CONFIG_DM_USERSPACE)      +=3D dm-user.o
=20
 quiet_cmd_unroll =3D UNROLL  $@
       cmd_unroll =3D $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
diff -Naur linux-2.6.17.13-orig/include/linux/dm-userspace.h linux-2.6.17.1=
3-dmu/include/linux/dm-userspace.h
=2D-- linux-2.6.17.13-orig/include/linux/dm-userspace.h	1969-12-31 16:00:00=
.000000000 -0800
+++ linux-2.6.17.13-dmu/include/linux/dm-userspace.h	2006-09-15 14:20:48.00=
0000000 -0700
@@ -0,0 +1,151 @@
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
+#define DM_USERSPACE_GET_VERSION      1
+#define DM_USERSPACE_MAP_BLOCK_REQ    2
+#define DM_USERSPACE_MAP_BLOCK_RESP   3
+#define DM_USERSPACE_MAP_FAILED       4
+#define DM_USERSPACE_MAP_INVALIDATE   5
+#define DM_USERSPACE_STATUS           6
+
+/*
+ * Status codes
+ */
+#define DM_USERSPACE_INVAL_COMPLETE   101
+#define DM_USERSPACE_INVAL_FAILED     102
+#define DM_USERSPACE_SYNC_COMPLETE    103
+
+/*
+ * Flags and associated macros
+ */
+#define DMU_FLAG_VALID       1
+#define DMU_FLAG_RD          2
+#define DMU_FLAG_WR          4
+#define DMU_FLAG_COPY_FIRST  8
+#define DMU_FLAG_TEMPORARY  16
+#define DMU_FLAG_DONE       32
+#define DMU_FLAG_SYNC       64
+#define DMU_FLAG_WAITING   128
+
+static int dmu_get_flag(uint32_t *flags, uint32_t flag)
+{
+	return (*flags & flag) !=3D 0;
+}
+
+static void dmu_set_flag(uint32_t *flags, uint32_t flag)
+{
+	*flags |=3D flag;
+}
+
+static void dmu_clr_flag(uint32_t *flags, uint32_t flag)
+{
+	*flags &=3D (~flag);
+}
+
+static void dmu_cpy_flag(uint32_t *flags, uint32_t src, uint32_t flag)
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
+/* DM_USERSPACE_GET_VERSION */
+struct dmu_msg_version {
+	uint32_t userspace_ver;
+	uint32_t kernel_ver;
+};
+
+/* For status codes */
+struct dmu_msg_status {
+	uint64_t id_of_op;
+	uint32_t status;
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
+	uint64_t org_block;
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
+		struct dmu_msg_version ver;
+		struct dmu_msg_status status;
+		struct dmu_msg_map_request map_req;
+		struct dmu_msg_map_response map_rsp;
+	} payload;
+};
+
+static inline int dmu_get_msg_len(int type)
+{
+	switch (type) {
+	case DM_USERSPACE_GET_VERSION:
+		return sizeof(struct dmu_msg_version);
+	case DM_USERSPACE_INVAL_COMPLETE:
+	case DM_USERSPACE_INVAL_FAILED:
+	case DM_USERSPACE_STATUS:
+		return sizeof(struct dmu_msg_status);
+	case DM_USERSPACE_MAP_BLOCK_REQ:
+		return sizeof(struct dmu_msg_map_request);
+	case DM_USERSPACE_MAP_BLOCK_RESP:
+	case DM_USERSPACE_MAP_FAILED:
+		return sizeof(struct dmu_msg_map_response);
+	default:
+		return -1;
+	};
+}
+
+#endif

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFDrLFwtEf7b4GJVQRAsCzAJ9agPFn/TjZoCaY4Vd9e7kxZGVHQwCeOjWV
2ZuXdmun4+MgoafOF7ruA8s=
=pGJb
-----END PGP SIGNATURE-----
--=-=-=--


--===============1203991768==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1203991768==--
