From: Dan Smith <danms@us.ibm.com>
Subject: [PATCH 1/2] Add userspace device-mapper target
Date: Mon, 29 Jan 2007 14:40:26 -0800
Message-ID: <m3lkjltq1x.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1508210349=="
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

--===============1508210349==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

This adds the dm-userspace kernel device-mapper target.  It contains
my latest changes, as well as Fujita's ringbuffer transport.

Comments welcome :)

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

Signed-off-by: Dan Smith <danms@us.ibm.com>

diff -r 50f87a6ffd94 drivers/md/Kconfig
=2D-- a/drivers/md/Kconfig	Thu Jan 25 17:50:37 2007 -0800
+++ b/drivers/md/Kconfig	Mon Jan 29 14:28:05 2007 -0800
@@ -236,6 +236,12 @@ config DM_SNAPSHOT
        ---help---
          Allow volume managers to take writable snapshots of a device.
=20
+config DM_USERSPACE
+       tristate "Userspace target (EXPERIMENTAL)"
+       depends on BLK_DEV_DM && EXPERIMENTAL
+       ---help---
+         A target that provides a userspace interface to device-mapper
+
 config DM_MIRROR
        tristate "Mirror target (EXPERIMENTAL)"
        depends on BLK_DEV_DM && EXPERIMENTAL
diff -r 50f87a6ffd94 drivers/md/Makefile
=2D-- a/drivers/md/Makefile	Thu Jan 25 17:50:37 2007 -0800
+++ b/drivers/md/Makefile	Mon Jan 29 14:28:05 2007 -0800
@@ -14,6 +14,8 @@ raid456-objs	:=3D raid5.o raid6algos.o rai
 		   raid6altivec1.o raid6altivec2.o raid6altivec4.o \
 		   raid6altivec8.o \
 		   raid6mmx.o raid6sse1.o raid6sse2.o
+dm-user-objs    :=3D dm-userspace.o dm-userspace-chardev.o \
+		   dm-userspace-cache.o
 hostprogs-y	:=3D mktables
=20
 # Note: link order is important.  All raid personalities
@@ -36,6 +38,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+=3D dm-snapshot
 obj-$(CONFIG_DM_SNAPSHOT)	+=3D dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+=3D dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+=3D dm-zero.o
+obj-$(CONFIG_DM_USERSPACE)      +=3D dm-user.o
=20
 quiet_cmd_unroll =3D UNROLL  $@
       cmd_unroll =3D $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
diff -r 50f87a6ffd94 drivers/md/dm-user.h
=2D-- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/md/dm-user.h	Mon Jan 29 14:28:05 2007 -0800
@@ -0,0 +1,176 @@
+/*
+ * Copyright IBM Corp., 2006
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
+#include <linux/dm-userspace.h>
+
+#include <linux/hardirq.h>
+#include <linux/slab.h>
+
+#define DMU_KEY_LEN 256
+
+extern struct target_type userspace_target;
+extern mempool_t *request_pool;
+extern dev_t dmu_dev;
+extern spinlock_t devices_lock;
+extern struct list_head devices;
+
+struct dmu_mappings;
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
+	/* We need to protect the TX/RX lists with a separate lock that is
+	 * always used with IRQs disabled because it is locked from
+	 * inside the endio function
+	 */
+	spinlock_t xmit_lock;
+	struct list_head tx_requests; /* Requests to send to userspace     */
+	struct list_head *rx_requests; /* Requests waiting for reply        */
+
+	struct dmu_mappings *mappings;
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
+
+	unsigned int request_slots;   /* Max number of reqs we will queue  */
+};
+
+struct dmu_request {
+	struct list_head list;        /* Our place on the request queue    */
+	struct list_head copy;        /* Our place on the copy list        */
+	struct dmu_device *dev;       /* The DMU device that owns us       */
+
+	struct block_device *target_dev;
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
+extern void add_tx_request(struct dmu_device *dev, struct dmu_request *req=
);
+extern void endio_worker(struct work_struct *work);
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
+int dmu_init_mappings(void);
+void dmu_cleanup_mappings(void);
+int dmu_make_mapping(struct dmu_device *dev,
+		     uint64_t org, uint64_t new, int64_t offset,
+		     struct block_device *dest, int rw);
+int dmu_map_from_mappings(struct dmu_device *dev,
+			  struct bio *bio);
+int dmu_alloc_mappings(struct dmu_mappings **m, uint32_t size);
+int dmu_remove_mapping(struct dmu_device *dev, uint64_t org);
+unsigned int dmu_remove_all_mappings(struct dmu_device *dev);
+
+#endif
diff -r 50f87a6ffd94 drivers/md/dm-userspace-cache.c
=2D-- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/md/dm-userspace-cache.c	Mon Jan 29 14:28:05 2007 -0800
@@ -0,0 +1,256 @@
+/*
+ * Copyright IBM Corp., 2006
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
+#include "dm.h"
+
+#include <linux/dm-userspace.h>
+
+#include "dm-user.h"
+
+#define DM_MSG_PREFIX "dm-userspace-cache"
+
+static struct kmem_cache *map_cache;
+
+struct dmu_mappings {
+	struct list_head *table;
+	uint32_t size;
+	uint32_t count;
+	struct semaphore sem;
+};
+
+struct dmu_map {
+	struct list_head list;
+	uint64_t org_block;
+	uint64_t new_block;
+	int64_t offset;
+	struct block_device *dest_dev;
+	int rw;
+};
+
+int dmu_alloc_mappings(struct dmu_mappings **mp, uint32_t size)
+{
+	struct dmu_mappings *m;
+	int i;
+
+	(*mp) =3D kmalloc(sizeof(*m), GFP_KERNEL);
+	if (!(*mp)) {
+		DMERR("Failed to alloc mappings");
+		return 0;
+	}
+=09
+	m =3D *mp;=09=20=20=20
+
+	m->table =3D kmalloc(sizeof(struct list_head) * size, GFP_KERNEL);
+	m->size =3D size;
+	m->count =3D 0;
+
+	for (i =3D 0; i < m->size; i++) {
+		INIT_LIST_HEAD(&m->table[i]);
+	}
+=09=09
+	init_MUTEX(&m->sem);
+
+	return 1;
+}
+
+int dmu_destroy_mappings(struct dmu_mappings *m)
+{
+	if (m->table)
+		kfree(m->table);
+=09=09=09
+	return 1;
+}
+
+static struct dmu_map *__dmu_find_mapping(struct dmu_mappings *m,
+					  uint64_t block)
+{
+	uint32_t bucket;
+	struct dmu_map *map;
+
+	bucket =3D ((uint32_t)block) % m->size;
+
+	list_for_each_entry(map, &m->table[bucket], list) {
+		if (map->org_block =3D=3D block)
+			return map;
+	}
+
+	return NULL;
+}
+
+static void __dmu_delete_mapping(struct dmu_mappings *m,
+				 struct dmu_map *map)
+{
+	m->count--;
+	list_del(&map->list);
+	kmem_cache_free(map_cache, map);
+}
+
+static int dmu_add_mapping(struct dmu_mappings *m,=20
+			   struct dmu_map *map)
+{
+	uint32_t bucket;
+	struct dmu_map *old;
+
+	down(&m->sem);
+
+	old =3D __dmu_find_mapping(m, map->org_block);
+	if (old)
+		__dmu_delete_mapping(m, old);
+
+	bucket =3D ((uint32_t)map->org_block) % m->size;
+=09
+	list_add(&map->list, &m->table[bucket]);
+	m->count++;
+
+	up(&m->sem);
+
+	return 1;
+}
+
+int dmu_map_from_mappings(struct dmu_device *dev,
+			  struct bio *bio)
+{
+	struct dmu_map *map;
+	int ret =3D 0;
+
+	down(&dev->mappings->sem);
+
+	map =3D __dmu_find_mapping(dev->mappings,
+				 dmu_block(dev, bio->bi_sector));
+
+	if (map && (bio_rw(bio) =3D=3D map->rw)) {
+=09=09
+		bio->bi_sector =3D dmu_sector(dev, map->new_block) +
+			dmu_sector_offset(dev, bio->bi_sector) +
+			map->offset;
+		bio->bi_bdev =3D map->dest_dev;
+		ret =3D 1;
+	}
+
+	up(&dev->mappings->sem);
+
+	return ret;
+}
+
+int dmu_make_mapping(struct dmu_device *dev,
+		     uint64_t org, uint64_t new, int64_t offset,
+		     struct block_device *dest, int rw)
+{
+	struct dmu_map *map;
+
+	/* FIXME */
+	map =3D kmem_cache_alloc(map_cache, GFP_NOIO);
+	if (!map) {
+		DMERR("Failed to alloc mapping");
+		return 0;
+	}
+
+	INIT_LIST_HEAD(&map->list);
+
+	map->org_block =3D org;
+	map->new_block =3D new;
+	map->dest_dev =3D dest;
+	map->offset =3D offset;
+	map->rw =3D rw;
+
+	return dmu_add_mapping(dev->mappings, map);
+}
+
+int dmu_remove_mapping(struct dmu_device *dev,
+		       uint64_t org)
+{
+	struct dmu_map *map;
+	int ret =3D 0;
+
+	down(&dev->mappings->sem);
+
+	map =3D __dmu_find_mapping(dev->mappings, org);
+	if (map) {
+		__dmu_delete_mapping(dev->mappings, map);
+		ret =3D 1;
+	}
+
+	up(&dev->mappings->sem);
+
+	return ret;
+}
+
+static unsigned int __destroy_bucket(struct dmu_mappings *m,
+				     unsigned int index)
+{
+	struct dmu_map *map, *next;
+	unsigned int count =3D 0;
+
+	list_for_each_entry_safe(map, next, &m->table[index], list) {
+		__dmu_delete_mapping(m, map);
+		count++;
+	}
+
+	return count;
+}
+
+unsigned int dmu_remove_all_mappings(struct dmu_device *dev)
+{
+	int i;
+	unsigned int count =3D 0;
+
+	down(&dev->mappings->sem);
+
+	for (i =3D 0; i < dev->mappings->size; i++) {
+		count +=3D __destroy_bucket(dev->mappings, i);
+	}
+=09
+	up(&dev->mappings->sem);
+
+	return count;
+}
+
+int dmu_init_mappings(void)
+{
+	map_cache =3D
+		kmem_cache_create("dm-userspace-mappings",
+				  sizeof(struct dmu_map),
+				  __alignof__ (struct dmu_map),
+				  0, NULL, NULL);
+	if (!map_cache) {
+		DMERR("Failed to allocate map cache");
+		return 0;
+	}
+
+	return 1;
+}
+
+void dmu_cleanup_mappings(void)
+{
+	kmem_cache_destroy(map_cache);
+}
+
+
diff -r 50f87a6ffd94 drivers/md/dm-userspace-chardev.c
=2D-- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/md/dm-userspace-chardev.c	Mon Jan 29 14:28:05 2007 -0800
@@ -0,0 +1,765 @@
+/*
+ * Copyright IBM Corp., 2006
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
+	if (r->r_idx =3D=3D DMU_MAX_EVENTS - 1)
+		r->r_idx =3D 0;
+	else
+		r->r_idx++;
+}
+
+static struct dmu_msg *dmu_head_msg(struct dmu_ring *r, u32 idx)
+{
+	u32 pidx, off;
+
+	pidx =3D idx / DMU_EVENT_PER_PAGE;
+	off =3D idx % DMU_EVENT_PER_PAGE;
+
+	return (struct dmu_msg *)
+		(r->r_pages[pidx] + sizeof(struct dmu_msg) * off);
+}
+
+static struct dmu_request *find_rx_request(struct dmu_device *dev,
+					   uint64_t id)
+{
+	struct dmu_request *req, *next, *match =3D NULL;
+	int count =3D 0;
+	struct list_head *list =3D &dev->rx_requests[id % DMU_CP_HASH];
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->xmit_lock, flags);
+	list_for_each_entry_safe(req, next, list, list) {
+		count++;
+		if (req->id =3D=3D id) {
+			list_del_init(&req->list);
+			match =3D req;
+			atomic_dec(&dev->r_reqs);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&dev->xmit_lock, flags);
+
+	return match;
+}
+
+static int have_pending_requests(struct dmu_device *dev)
+{
+	return atomic_read(&dev->t_reqs) !=3D 0;
+}
+
+static void send_userspace_message(struct dmu_msg *msg,
+				   struct dmu_request *req)
+{
+	memset(msg, 0, sizeof(*msg));
+
+	msg->hdr.id =3D req->id;
+
+	switch (req->type) {
+	case DM_USERSPACE_MAP_BLOCK_REQ:
+		msg->hdr.msg_type =3D req->type;
+		msg->payload.map_req.org_block =3D req->u.block;
+		dmu_cpy_flag(&msg->payload.map_req.flags,
+			     req->flags, DMU_FLAG_WR);
+		break;
+
+	case DM_USERSPACE_MAP_DONE:
+		msg->hdr.msg_type =3D DM_USERSPACE_MAP_DONE;
+		msg->payload.map_done.id_of_op =3D req->id;
+		msg->payload.map_done.org_block =3D req->u.block;
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
+ 		INIT_WORK(&req->task, endio_worker);
+		schedule_work(&req->task);
+	}
+}
+
+static void add_rx_request(struct dmu_request *req)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&req->dev->xmit_lock, flags);
+	list_add_tail(&req->list,=20
+		      &req->dev->rx_requests[req->id % DMU_CP_HASH]);
+	atomic_inc(&req->dev->r_reqs);
+	spin_unlock_irqrestore(&req->dev->xmit_lock, flags);
+}
+
+struct dmu_request *pluck_next_request(struct dmu_device *dev)
+{
+	struct dmu_request *req =3D NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->xmit_lock, flags);
+	if (!list_empty(&dev->tx_requests)) {
+		req =3D list_entry(dev->tx_requests.next,
+				 struct dmu_request, list);
+		list_del_init(&req->list);
+
+		atomic_dec(&dev->t_reqs);
+	}
+	spin_unlock_irqrestore(&dev->xmit_lock, flags);
+
+	if (req && ((req->type =3D=3D DM_USERSPACE_MAP_BLOCK_REQ) ||
+		    (req->type =3D=3D DM_USERSPACE_MAP_DONE)))
+		add_rx_request(req);
+
+	return req;
+}
+
+static struct dmu_msg *get_tx_msg(struct dmu_ring *ring)
+{
+	struct dmu_msg *msg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ring->r_lock, flags);
+	msg =3D dmu_head_msg(ring, ring->r_idx);
+	if (msg->hdr.status)
+		msg =3D NULL;
+	else
+		dmu_ring_idx_inc(ring);
+	spin_unlock_irqrestore(&ring->r_lock, flags);
+
+	return msg;
+}
+
+static void send_tx_request(struct dmu_msg *msg, struct dmu_request *req)
+{
+	struct chardev_transport *t =3D req->dev->transport_private;
+
+	send_userspace_message(msg, req);
+	msg->hdr.status =3D 1;
+	mb();
+	flush_dcache_page(virt_to_page(msg));
+	wake_up_interruptible(&t->poll_wait);
+}
+
+/* Add a request to a device's request queue */
+void add_tx_request(struct dmu_device *dev, struct dmu_request *req)
+{
+	unsigned long flags;
+	struct chardev_transport *t =3D dev->transport_private;
+	struct dmu_ring *ring =3D &t->tx;
+	struct dmu_msg *msg;
+
+	BUG_ON(!list_empty(&req->list));
+
+	msg =3D get_tx_msg(ring);
+
+	if (msg) {
+		add_rx_request(req);
+		send_tx_request(msg, req);
+	} else {
+		spin_lock_irqsave(&dev->xmit_lock, flags);
+		list_add_tail(&req->list, &dev->tx_requests);
+		atomic_inc(&dev->t_reqs);
+		spin_unlock_irqrestore(&dev->xmit_lock, flags);
+
+		wake_up_interruptible(&t->tx_wqueue);
+	}
+}
+
+static int dmu_txd(void *data)
+{
+
+	struct dmu_device *dev =3D data;
+	struct chardev_transport *t =3D dev->transport_private;
+	struct dmu_ring *ring =3D &t->tx;
+	struct dmu_request *req =3D NULL;
+	struct dmu_msg *msg;
+
+	while (!kthread_should_stop()) {
+		msg =3D dmu_head_msg(ring, ring->r_idx);
+
+		wait_event_interruptible(t->tx_wqueue,
+					 (!msg->hdr.status &&
+					  have_pending_requests(dev)) ||
+					 kthread_should_stop());
+
+		if (kthread_should_stop())
+			break;
+
+		msg =3D get_tx_msg(ring);
+		if (!msg)
+			continue;
+
+		req =3D pluck_next_request(dev);
+		BUG_ON(!req);
+
+		send_tx_request(msg, req);
+	}
+
+	return 0;
+}
+
+static void flush_block(int read_err, unsigned int write_err, void *data)
+{
+	struct dmu_request *req =3D data;
+
+	if (read_err || write_err) {
+		DMERR("Failed to copy block!");
+		bio_io_error(req->bio, req->bio->bi_size);
+		return;
+	}
+
+	atomic_inc(&req->dev->f_reqs);
+	generic_make_request(req->bio);
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
+static void map_worker(struct work_struct *work)
+{
+	struct dmu_request *req;
+	struct dmu_msg_map_response *msg;
+	struct dmu_device *dev;
+	struct target_device *src_dev, *dst_dev;
+=09
+	req =3D container_of(work, struct dmu_request, task);
+	msg =3D &req->response;
+	dev =3D req->dev;
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
+	req->target_dev =3D dst_dev->bdev;
+
+	/* Remap the bio */
+	req->bio->bi_sector =3D dmu_sector(dev, msg->new_block) +
+		dmu_sector_offset(dev, req->bio->bi_sector) +
+		msg->offset;
+	req->bio->bi_bdev =3D dst_dev->bdev;
+
+	dmu_cpy_flag(&req->flags, msg->flags, DMU_FLAG_SYNC);
+
+	if (dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST))
+		copy_block(dev, src_dev->bdev, dst_dev->bdev, req,
+			   req->u.block, msg->new_block,
+			   msg->offset);
+	else
+		flush_block(0, 0, req);
+
+	return;
+
+ fail:
+	bio_io_error(req->bio, req->bio->bi_size);
+}
+
+static void do_make_mapping(struct dmu_device *dev,
+			    struct dmu_msg_make_mapping *msg)
+{
+	struct target_device *target;
+
+	target =3D find_target(dev, MKDEV(msg->dev_maj, msg->dev_min));
+	if (!target) {
+		DMERR("Failed to find target device %i:%i\n",
+		      msg->dev_maj, msg->dev_min);
+		return;
+	}
+
+	dmu_make_mapping(dev,=20
+			 msg->org_block, msg->new_block, msg->offset,
+			 target->bdev, dmu_get_flag(&msg->flags, DMU_FLAG_WR));
+
+}
+
+static void do_kill_mapping(struct dmu_device *dev,
+			    struct dmu_msg_make_mapping *msg)
+{
+	if (!dmu_remove_mapping(dev, msg->org_block))
+		DMERR("Tried to remove non-existent mapping for %llu",
+		      msg->org_block);
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
+		      (unsigned long long) msg->id_of_req);
+		return;
+	}
+
+	memcpy(&req->response, msg, sizeof(req->response));
+
+	INIT_WORK(&req->task, map_worker);
+	schedule_work(&req->task);
+}
+
+static void do_map_done(struct dmu_device *dev, uint64_t id_of_op, int fai=
l)
+{
+	struct dmu_request *req;
+
+	req =3D find_rx_request(dev, id_of_op);
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
+	req =3D find_rx_request(dev, id_of_op);
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
+	struct dmu_device *dev =3D (struct dmu_device *) data;
+	struct chardev_transport *t =3D dev->transport_private;
+	struct dmu_ring *ring =3D &t->rx;
+	struct dmu_msg *msg;
+
+	while (!kthread_should_stop()) {
+		msg =3D dmu_head_msg(ring, ring->r_idx);
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
+		case DM_USERSPACE_MAKE_MAPPING:
+			do_make_mapping(dev, &msg->payload.make_mapping);
+			break;
+
+		case DM_USERSPACE_KILL_MAPPING:
+			do_kill_mapping(dev, &msg->payload.make_mapping);
+			break;
+
+		default:
+			DMWARN("Unknown incoming request type: %i",
+			       msg->hdr.msg_type);
+		}
+
+		msg->hdr.status =3D 0;
+		dmu_ring_idx_inc(ring);
+	}
+
+	return 0;
+}
+
+ssize_t dmu_ctl_write(struct file *file, const char __user *buffer,
+		      size_t size, loff_t *offset)
+{
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	struct chardev_transport *t =3D dev->transport_private;
+
+	wake_up(&t->tx_wqueue);
+	wake_up(&t->rx_wqueue);
+	return size;
+}
+
+static void dmu_ring_free(struct dmu_ring *r)
+{
+	int i;
+	for (i =3D 0; i < DMU_RING_PAGES; i++) {
+		if (!r->r_pages[i])
+			break;
+		free_page(r->r_pages[i]);
+		r->r_pages[i] =3D 0;
+	}
+}
+
+static int dmu_ring_alloc(struct dmu_ring *r)
+{
+	int i;
+
+	r->r_idx =3D 0;
+	spin_lock_init(&r->r_lock);
+
+	for (i =3D 0; i < DMU_RING_PAGES; i++) {
+		r->r_pages[i] =3D get_zeroed_page(GFP_KERNEL);
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
+	t =3D container_of(inode->i_cdev, struct chardev_transport, cdev);
+	dev =3D t->parent;
+
+	init_waitqueue_head(&t->poll_wait);
+	init_waitqueue_head(&t->tx_wqueue);
+	init_waitqueue_head(&t->rx_wqueue);
+
+	ret =3D dmu_ring_alloc(&t->tx);
+	if (ret)
+		return -ENOMEM;
+
+	ret =3D dmu_ring_alloc(&t->rx);
+	if (ret)
+		goto free_tx;
+
+	t->tx_task =3D kthread_run(dmu_txd, dev, "%s_tx", DM_MSG_PREFIX);
+	if (!t->tx_task)
+		goto free_rx;
+
+	t->rx_task =3D kthread_run(dmu_rxd, dev, "%s_rx", DM_MSG_PREFIX);
+	if (!t->rx_task) {
+		ret =3D -ENOMEM;
+		goto destroy_tx_task;
+	}
+
+	get_dev(dev);
+
+	file->private_data =3D dev;
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
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	struct chardev_transport *t =3D dev->transport_private;
+
+	kthread_stop(t->rx_task);
+	kthread_stop(t->tx_task);
+
+	dmu_ring_free(&t->rx);
+	dmu_ring_free(&t->tx);
+
+	put_dev(dev);
+
+	/* Stop taking requests when there is no userspace to service them */
+	dev->request_slots =3D 0;
+
+	return 0;
+}
+
+unsigned dmu_ctl_poll(struct file *file, poll_table *wait)
+{
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	struct chardev_transport *t =3D dev->transport_private;
+	struct dmu_ring *ring =3D &t->tx;
+	struct dmu_msg *msg;
+	unsigned mask =3D 0;
+	u32 idx;
+	unsigned long flags;
+
+	poll_wait(file, &t->poll_wait, wait);
+
+	spin_lock_irqsave(&ring->r_lock, flags);
+
+	idx =3D ring->r_idx ? ring->r_idx - 1 : DMU_MAX_EVENTS - 1;
+	msg =3D dmu_head_msg(ring, idx);
+	if (msg->hdr.status)
+		mask |=3D POLLIN | POLLRDNORM;
+
+	spin_unlock_irqrestore(&ring->r_lock, flags);
+
+	return mask;
+}
+
+static int dmu_ring_map(struct vm_area_struct *vma, unsigned long addr,
+			struct dmu_ring *ring)
+{
+	int i, err;
+
+	for (i =3D 0; i < DMU_RING_PAGES; i++) {
+		struct page *page =3D virt_to_page(ring->r_pages[i]);
+		err =3D vm_insert_page(vma, addr, page);
+		if (err)
+			return err;
+		addr +=3D PAGE_SIZE;
+	}
+
+	return 0;
+}
+
+static int dmu_ctl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	struct chardev_transport *t =3D dev->transport_private;
+	unsigned long addr;
+	int err;
+
+	if (vma->vm_pgoff)
+		return -EINVAL;
+
+	if (vma->vm_end - vma->vm_start !=3D DMU_RING_SIZE * 2) {
+		DMERR("mmap size must be %lu, not %lu \n",
+			DMU_RING_SIZE * 2, vma->vm_end - vma->vm_start);
+		return -EINVAL;
+	}
+
+	addr =3D vma->vm_start;
+	err =3D dmu_ring_map(vma, addr, &t->tx);
+	if (err)
+		return err;
+	err =3D dmu_ring_map(vma, addr + DMU_RING_SIZE, &t->rx);
+
+	/* Open the gates and wake anyone waiting */
+	/* FIXME: Magic number */
+	dev->request_slots =3D 20000;
+	wake_up_interruptible(&dev->lowmem);
+
+	return err;
+}
+
+static struct file_operations ctl_fops =3D {
+	.open    =3D dmu_ctl_open,
+	.release =3D dmu_ctl_release,
+	.write   =3D dmu_ctl_write,
+	.mmap    =3D dmu_ctl_mmap,
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
diff -r 50f87a6ffd94 drivers/md/dm-userspace.c
=2D-- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/md/dm-userspace.c	Mon Jan 29 14:28:05 2007 -0800
@@ -0,0 +1,568 @@
+/*
+ * Copyright IBM Corp., 2006
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
+struct kmem_cache *request_cache;
+mempool_t *request_pool;
+
+spinlock_t devices_lock;
+LIST_HEAD(devices);
+
+/* Device number for the control device */
+dev_t dmu_dev;
+
+void endio_worker(struct work_struct *work)
+{
+	struct dmu_request *req;
+	struct dmu_device *dev;
+
+	req =3D container_of(work, struct dmu_request, task);
+	dev  =3D req->dev;
+
+	spin_lock(&dev->lock);
+	if (list_empty(&req->list) && list_empty(&req->copy)) {
+		mempool_free(req, request_pool);
+		atomic_dec(&dev->f_reqs);
+		atomic_dec(&dev->total);
+		wake_up_interruptible(&dev->lowmem);
+	} else {
+		PREPARE_WORK(&req->task, endio_worker);
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
+		DMERR("%s in irq\n", __FUNCTION__);
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
+	int i;
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
+	for (i =3D 0; i < DMU_CP_HASH; i++) {
+		list_for_each_safe(cursor, next, &dev->rx_requests[i]) {
+			struct dmu_request *req;
+
+			req =3D list_entry(cursor,
+					 struct dmu_request,
+					 list);
+
+			DMERR("Failing bio");
+			req->flags =3D 0;
+			bio_io_error(req->bio, req->bio->bi_size);
+
+			list_del(&req->list);
+
+			mempool_free(req, request_pool);
+		}
+	}
+
+	dmu_remove_all_mappings(dev);
+
+	kcopyd_client_destroy(dev->kcopy);
+	unregister_chardev_transport(dev);
+
+	kfree(dev);
+}
+
+static int init_dmu_device(struct dmu_device *dev, u32 block_size)
+{
+	int ret, i;
+
+	init_waitqueue_head(&dev->lowmem);
+	INIT_LIST_HEAD(&dev->list);
+	INIT_LIST_HEAD(&dev->target_devs);
+	kref_init(&dev->users);
+	spin_lock_init(&dev->lock);
+	spin_lock_init(&dev->xmit_lock);
+
+	INIT_LIST_HEAD(&dev->tx_requests);
+
+	dev->rx_requests =3D kmalloc(sizeof(struct list_head) * DMU_CP_HASH,
+				   GFP_KERNEL);
+	if (!dev->rx_requests) {
+		DMERR("Failed to alloc RX hash\n");
+		return 0;
+	}
+
+	for (i =3D 0; i < DMU_CP_HASH; i++)
+		INIT_LIST_HEAD(&dev->rx_requests[i]);
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
+	dmu_alloc_mappings(&dev->mappings, 2048);
+
+	ret =3D kcopyd_client_create(DMU_COPY_PAGES, &dev->kcopy);
+	if (ret) {
+		DMERR("Failed to initialize kcopyd client");
+		return 0;
+	}
+
+	dev->request_slots =3D 0; /* Unable to queue reqs right away */
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
+	if (!dev) {
+		dev =3D new_dmu_device(device_key, ti, block_size);
+		if (!dev) {
+			ti->error =3D "Failed to create device";
+			goto bad;
+		}
+	} else
+		get_dev(dev);
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
+		DMINFO("Refusing bio barrier\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (dmu_map_from_mappings(dev, bio)) {
+		map_context->ptr =3D NULL;
+		return 1;
+	}
+
+	wait_event_interruptible(dev->lowmem,
+				 atomic_read(&dev->total) <=20
+				 dev->request_slots);
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
+	struct dmu_request *req =3D map_context->ptr;
+	int ret =3D 0;
+
+	if (error)
+		return -1;
+
+	if (!req)
+		return 0;
+
+	if (dmu_get_flag(&req->flags, DMU_FLAG_SYNC)) {
+		req->type =3D DM_USERSPACE_MAP_DONE;
+		add_tx_request(req->dev, req);
+		ret =3D 1;
+	} else {
+		INIT_WORK(&req->task, endio_worker);
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
+	r =3D dmu_init_mappings();
+	if (!r)
+		goto bad3;
+
+	r =3D init_chardev_transport();
+	if (!r)
+		goto bad4;
+
+	return 1;
+ bad4:
+	dmu_cleanup_mappings();
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
+	dmu_cleanup_mappings();
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
diff -r 50f87a6ffd94 include/linux/dm-userspace.h
=2D-- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/linux/dm-userspace.h	Mon Jan 29 14:28:05 2007 -0800
@@ -0,0 +1,123 @@
+/*
+ * Copyright IBM Corp., 2006
+ * Author: Dan Smith <danms@us.ibm.com>
+ *
+ * This file is released under the LGPL
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
+#define DM_USERSPACE_MAKE_MAPPING     6
+#define DM_USERSPACE_KILL_MAPPING     7
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
+struct dmu_msg_make_mapping {
+	uint64_t org_block;
+	uint64_t new_block;
+	int64_t offset;
+	uint32_t dev_maj;
+	uint32_t dev_min;
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
+		struct dmu_msg_make_mapping make_mapping;
+	} payload;
+};
+
+#define DMU_RING_SIZE (1UL << 16)
+#define DMU_RING_PAGES (DMU_RING_SIZE >> PAGE_SHIFT)
+#define DMU_EVENT_PER_PAGE (PAGE_SIZE / sizeof(struct dmu_msg))
+#define DMU_MAX_EVENTS (DMU_EVENT_PER_PAGE * DMU_RING_PAGES)
+
+#endif

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFvnfdwtEf7b4GJVQRAjOpAJ0WLFMBquwtQ/DmhC6o+HctzzfGqACgiCmz
fi2edalxJPlQsrZu/NAMNiQ=
=1bm5
-----END PGP SIGNATURE-----
--=-=-=--


--===============1508210349==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1508210349==--
