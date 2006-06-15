From: Dan Smith <danms@us.ibm.com>
Subject: [PATCH] Add dm-userspace target
Date: Thu, 15 Jun 2006 08:59:21 -0700
Message-ID: <m37j3i1kbq.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2133654510=="
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
Cc: Ryan Grimm <grimm@us.ibm.com>
List-Id: dm-devel.ids

--===============2133654510==
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: multipart/mixed; boundary="=-=-="

--=-=-=

This patch adds the dm-userspace target to the kernel.  I have tested
it successfully on both i386 and x86_64 SMP machines.

The idea of dm-userspace is to export an interface for userspace
control over device-mapper block placement decisions.  It effectively
allows device-mapper target logic to be implemented in userspace.

I have a library that provides a simple record-based userspace
interface for communication with a dm-userspace target, available
here:

  http://static.danplanet.com/dm-userspace/libdmu-0.3.tar.gz

The library tarball also contains an example.c, which demonstrates how
to write a userspace application (in about 16 lines of actual code).

I would really like feedback about the kernel module.  I'm definitely
willing to do whatever work is needed to make this an acceptable part
of device-mapper.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=dm-userspace_06152006.patch
Content-Transfer-Encoding: quoted-printable

diff -Naur linux-2.6.16.20-orig/drivers/md/dm-userspace.c linux-2.6.16.20-d=
mu/drivers/md/dm-userspace.c
=2D-- linux-2.6.16.20-orig/drivers/md/dm-userspace.c	1969-12-31 16:00:00.00=
0000000 -0800
+++ linux-2.6.16.20-dmu/drivers/md/dm-userspace.c	2006-06-14 11:10:01.00000=
0000 -0700
@@ -0,0 +1,1612 @@
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
+
+#define DMU_DEBUG      0
+
+#define DMU_COPY_PAGES 256
+#define DMU_KEY_LEN    256
+
+#define DMU_PREFIX     "dm-userspace: "
+#define DMU_SET_ERROR(ti, msg) ti->error =3D DMU_PREFIX msg
+
+#if DMU_DEBUG
+#define DPRINTK( s, arg... ) printk(DMU_PREFIX s, ##arg)
+#else
+#define DPRINTK( s, arg... )
+#endif
+
+kmem_cache_t *request_cache;
+kmem_cache_t *remap_cache;
+
+static int enable_watchdog =3D 0;
+static struct work_struct wd;
+
+static spinlock_t devices_lock;
+static LIST_HEAD(devices);
+
+/* Device number for the control device */
+static dev_t our_dev;
+
+struct target_device {
+	struct list_head list;
+	struct block_device *bdev;
+	struct kref users;
+};
+
+struct hash_table {
+	struct list_head *table;
+	uint64_t size;
+	uint32_t mask;
+	uint64_t count;
+};
+
+/* A dm-userspace device, which consists of multiple targets sharing a
+ * common key
+ */
+struct dmu_device {
+	spinlock_t lock;
+	struct list_head list;
+	struct list_head requests;
+	struct list_head target_devs;
+
+	struct hash_table remaps;
+
+	struct cdev cdev;
+	dev_t ctl_dev;
+
+	char key[DMU_KEY_LEN];
+	struct kref users;
+
+	wait_queue_head_t wqueue;
+
+	uint64_t block_size;
+	uint64_t block_mask;
+	unsigned int block_shift;
+
+	struct kcopyd_client *kcopyd_client;
+
+	/*
+	 * Count of the number of outstanding requests that have been
+	 * made against this device, but have not yet been flushed
+	 */
+	atomic_t remap_ct;
+
+	uint32_t id_counter;
+};
+
+struct userspace_request {
+	spinlock_t lock;
+	struct list_head list;
+	struct dmu_device *dev;
+	int type;
+	int sent;
+	uint32_t flags;
+	uint32_t id;
+	union {
+		struct bio_list bios;
+		uint64_t block;
+	} u;
+	atomic_t refcnt;
+};
+
+struct dmu_map {
+	spinlock_t lock;
+	uint64_t org_block; /* Original block */
+	uint64_t new_block; /* Destination block */
+	int64_t offset;
+	uint32_t flags;
+	struct target_device *src;
+	struct target_device *dest;
+	struct bio_list bios;
+	struct list_head list;
+	struct dmu_device *dev;
+
+	struct dmu_map *next; /* Next remap that is dependent on this one */
+};
+
+/* Forward delcarations */
+static struct file_operations ctl_fops;
+static void copy_block(struct dmu_map *remap);
+static void remap_flusher(struct dmu_map *remap);
+
+/*
+ * Return the block number for @sector
+ */
+static inline u64 dmu_block(struct dmu_device *dev,
+				 sector_t sector)
+{
+	return sector >> dev->block_shift;
+}
+
+/*
+ * Return the sector offset in a block for @sector
+ */
+static inline u64 dmu_sector_offset(struct dmu_device *dev,
+				 sector_t sector)
+{
+	return sector & dev->block_mask;
+}
+
+/*
+ * Return the starting sector for @block
+ */
+static inline u64 dmu_sector(struct dmu_device *dev,
+				  uint64_t block)
+{
+	return block << dev->block_shift;
+}
+
+static void copy_or_flush(struct dmu_map *remap)
+{
+	int copy;
+
+	spin_lock(&remap->lock);
+	copy =3D dmu_get_flag(&remap->flags, DMU_FLAG_COPY_FIRST);
+	spin_unlock(&remap->lock);
+
+	if (copy)
+		copy_block(remap);
+	else
+		remap_flusher(remap);
+}
+
+static void error_bios(struct bio_list *bios)
+{
+	struct bio *bio;
+	int count =3D 0;
+
+	while ((bio =3D bio_list_pop(bios)) !=3D NULL) {
+		bio_io_error(bio, bio->bi_size);
+		count++;
+	}
+
+	if (count)
+		printk(KERN_ERR DMU_PREFIX
+		       "*** Failed %i requests\n", count);
+}
+
+static void init_remap(struct dmu_device *dev, struct dmu_map *remap)
+{
+	spin_lock_init(&remap->lock);
+	remap->org_block =3D remap->new_block =3D 0;
+	remap->offset =3D 0;
+	remap->flags =3D 0;
+	remap->src =3D remap->dest =3D NULL;
+	bio_list_init(&remap->bios);
+	INIT_LIST_HEAD(&remap->list);
+	remap->dev =3D dev;
+	remap->next =3D NULL;
+}
+
+static void init_request(struct dmu_device *dev,
+			 int type,
+			 struct userspace_request *req)
+{
+	spin_lock_init(&req->lock);
+	INIT_LIST_HEAD(&req->list);
+	req->dev =3D dev;
+	req->type =3D type;
+	req->sent =3D 0;
+	req->flags =3D 0;
+	if (type =3D=3D DM_USERSPACE_COPY_FINISHED) {
+		req->u.block =3D 0;
+		req->id =3D 0;
+	} else {
+		bio_list_init(&req->u.bios);
+		spin_lock(&dev->lock);
+		dev->id_counter++;
+		if (dev->id_counter =3D=3D 0)
+			dev->id_counter =3D 1;
+		req->id =3D dev->id_counter;
+		spin_unlock(&dev->lock);
+	}
+	atomic_set(&req->refcnt, 0);
+}
+
+static void destroy_remap(struct dmu_map *remap)
+{
+	error_bios(&remap->bios);
+}
+
+/*
+ * For an even block distribution, this is not too bad, but it could
+ * probably be better
+ */
+static uint32_t ht_hash(struct hash_table *ht, uint64_t block)
+{
+	return (uint32_t)block & ht->mask;
+}
+
+static int ht_init(struct hash_table *ht, unsigned long size)
+{
+	uint64_t i;
+	unsigned long pages;
+	unsigned int order =3D ffs((size * sizeof(struct list_head *)) /
+				 PAGE_SIZE);
+
+	DPRINTK("Going to allocate 2^%u pages for %lu-entry table\n",
+		order, size);
+
+	pages =3D __get_free_pages(GFP_ATOMIC, order);
+	if (!pages) {
+		DPRINTK("Failed to allocate hash table (%lu)\n", size);
+		return 0;
+	}
+
+	ht->table =3D (void *)pages;
+	ht->size =3D size;
+	ht->count =3D 0;
+	ht->mask =3D size - 1;
+
+	for (i =3D 0; i < size; i++)
+		INIT_LIST_HEAD(&ht->table[i]);
+
+	return 1;
+}
+
+static void ht_insert_bucket(struct dmu_map *map, struct list_head *list)
+{
+	list_add_tail(&map->list, list);
+}
+
+/*
+ * I'm sure this is quite dumb, but it works for now
+ */
+static int ht_should_grow(struct hash_table *ht)
+{
+	return ht->count > (2 * (ht->size / 4));
+}
+
+static void ht_grow_table(struct hash_table *ht);
+static void ht_insert_map(struct hash_table *ht, struct dmu_map *map)
+{
+	uint32_t addr;
+
+	addr =3D ht_hash(ht, map->org_block) & ht->mask;
+
+	BUG_ON(addr >=3D ht->size);
+
+	ht_insert_bucket(map, &ht->table[addr]);
+	ht->count++;
+
+	if (ht_should_grow(ht))
+		ht_grow_table(ht);
+}
+
+static void ht_delete_map(struct hash_table *ht, struct dmu_map *map)
+{
+	list_del(&map->list);
+	BUG_ON(ht->count =3D=3D 0);
+	ht->count--;
+}
+
+static struct dmu_map *ht_find_map(struct hash_table *ht, uint64_t block)
+{
+	uint32_t addr;
+	struct dmu_map *m;
+
+	addr =3D ht_hash(ht, block) & ht->mask;
+
+	BUG_ON(addr >=3D ht->size);
+
+	list_for_each_entry(m, &ht->table[addr], list) {
+		if (m->org_block =3D=3D block)
+			return m;
+	}
+
+	return NULL;
+}
+
+static struct dmu_map *ht_find_map_dev(struct dmu_device *dev, uint64_t bl=
ock)
+{
+	struct dmu_map *remap;
+
+	spin_lock(&dev->lock);
+
+	remap =3D ht_find_map(&dev->remaps, block);
+
+	spin_unlock(&dev->lock);
+
+	return remap;
+}
+
+static void ht_grow_table(struct hash_table *ht)
+{
+	struct hash_table old_table;
+	uint64_t i;
+
+	old_table =3D *ht;
+
+	if (!ht_init(ht, old_table.size * 2)) {
+		DPRINTK("Can't grow table to %llu\n",
+			old_table.size * 2);
+		return;
+	}
+
+	DPRINTK("Growing from %llu to %llu\n",
+		old_table.size, ht->size);
+
+	for (i =3D 0; i < old_table.size; i++ ) {
+		struct dmu_map *m, *n;
+		list_for_each_entry_safe(m, n, &old_table.table[i],
+					 list) {
+			list_del_init(&m->list);
+			ht_insert_map(ht, m);
+		}
+	}
+
+	free_pages((unsigned long)old_table.table,
+		   ffs((old_table.size * sizeof(struct list_head *))
+		       / PAGE_SIZE));
+}
+
+static uint64_t ht_destroy_table(struct hash_table *ht)
+{
+	uint64_t i, count =3D 0;
+	struct dmu_map *m, *n;
+
+	for (i =3D 0; i < ht->size; i++) {
+		list_for_each_entry_safe(m, n, &ht->table[i], list) {
+			ht_delete_map(ht, m);
+			kmem_cache_free(remap_cache, m);
+			count++;
+		}
+	}
+
+	return count;
+}
+
+static struct target_device *get_target(struct dmu_device *dev,
+					dev_t devno)
+{
+
+	struct target_device *target;
+	struct block_device *bdev;
+
+	spin_lock(&dev->lock);
+	list_for_each_entry(target, &dev->target_devs, list) {
+		if (target->bdev->bd_dev =3D=3D devno) {
+			spin_unlock(&dev->lock);
+			goto out;
+		}
+	}
+	spin_unlock(&dev->lock);
+
+	bdev =3D open_by_devnum(devno, FMODE_READ | FMODE_WRITE);
+	if (IS_ERR(bdev)) {
+		printk(KERN_ERR DMU_PREFIX "Unable to lookup device %x\n",
+		       devno);
+		return NULL;
+	}
+
+	target =3D kmalloc(sizeof(*target), GFP_KERNEL);
+	if (!target) {
+		printk(KERN_ERR DMU_PREFIX
+		       "Unable to alloc new target device\n");
+		return NULL;
+	}
+
+	target->bdev =3D bdev;
+	INIT_LIST_HEAD(&target->list);
+
+	spin_lock(&dev->lock);
+	list_add_tail(&target->list, &dev->target_devs);
+	spin_unlock(&dev->lock);
+
+ out:
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
+/*
+ * Add a request to the device's request queue
+ */
+static void add_request(struct dmu_device *dev,
+			       struct userspace_request *req)
+{
+	spin_lock(&dev->lock);
+	list_add_tail(&req->list, &dev->requests);
+	spin_unlock(&dev->lock);
+
+	wake_up(&dev->wqueue);
+}
+
+/*
+ *
+ */
+static int have_pending_requests(struct dmu_device *dev)
+{
+	struct userspace_request *req;
+	int ret =3D 0;
+
+	spin_lock(&dev->lock);
+
+	list_for_each_entry(req, &dev->requests, list) {
+		if (!req->sent) {
+			ret =3D 1;
+			break;
+		}
+	}
+
+	spin_unlock(&dev->lock);
+
+	return ret;
+}
+
+/*
+ * This periodically dumps out some debug information.  It's really
+ * only useful while developing.
+ */
+static void watchdog(void *data)
+{
+	unsigned int v_remaps, i_remaps, reqs, s_reqs, devs =3D 0;
+	struct dmu_device *dev;
+	struct dmu_map *map;
+	struct userspace_request *req;
+	uint64_t i;
+
+	spin_lock(&devices_lock);
+
+	list_for_each_entry(dev, &devices, list) {
+		spin_lock(&dev->lock);
+
+		v_remaps =3D i_remaps =3D reqs =3D s_reqs =3D 0;
+
+		for (i =3D 0; i < dev->remaps.size; i++) {
+			list_for_each_entry(map, &dev->remaps.table[i], list)
+				if (dmu_get_flag(&map->flags, DMU_FLAG_VALID))
+					v_remaps++;
+				else
+					i_remaps++;
+		}
+
+		list_for_each_entry(req, &dev->requests, list)
+			if (req->sent)
+				s_reqs++;
+			else
+				reqs++;
+
+		printk("Device %x:%x: "
+		       "  reqs: %u/%u "
+		       "  inv maps: %u "
+		       "  val maps: %u (%i)\n",
+		       MAJOR(dev->ctl_dev), MINOR(dev->ctl_dev),
+		       reqs, s_reqs, i_remaps, v_remaps,
+		       atomic_read(&dev->remap_ct));
+		devs++;
+
+		spin_unlock(&dev->lock);
+	}
+
+	spin_unlock(&devices_lock);
+
+	schedule_delayed_work(&wd, HZ);
+}
+
+static void __bio_remap(struct bio *bio,
+		      struct dmu_map *remap)
+{
+	BUG_ON(remap->dest =3D=3D NULL);
+
+	bio->bi_sector =3D dmu_sector(remap->dev, remap->new_block) +
+		dmu_sector_offset(remap->dev, bio->bi_sector) +
+		remap->offset;
+
+	bio->bi_bdev =3D remap->dest->bdev;
+}
+
+/*
+   Pop, remap, and flush a bio.  Set VALID flag if no bios
+   available
+*/
+static struct bio *pop_and_remap(struct dmu_map *remap)
+{
+	struct bio *bio =3D NULL;
+
+	spin_lock(&remap->lock);
+
+	bio =3D bio_list_pop(&remap->bios);
+	if (bio)
+		__bio_remap(bio, remap);
+	else {
+		/* If there are no more bios, we must set the VALID
+		   flag before we release the lock */
+		dmu_set_flag(&remap->flags, DMU_FLAG_VALID);
+	}
+
+	spin_unlock(&remap->lock);
+
+	return bio;
+}
+
+static void get_remap_attrs(struct dmu_map *remap,
+			    int *copy_first,
+			    int *temporary,
+			    struct dmu_map **next)
+{
+	spin_lock(&remap->lock);
+
+	*copy_first =3D dmu_get_flag(&remap->flags, DMU_FLAG_COPY_FIRST);
+	*temporary =3D dmu_get_flag(&remap->flags, DMU_FLAG_TEMPORARY);
+	*next =3D remap->next;
+	remap->next =3D NULL;
+
+	spin_unlock(&remap->lock);
+}
+
+static void remap_flusher(struct dmu_map *remap)
+{
+	struct bio *bio;
+	struct userspace_request *req;
+	int copy_first =3D 0, temporary =3D 0;
+	struct dmu_map *next;
+
+	DPRINTK("Flushing bios for block %llu:%llu\n",
+	       remap->org_block, remap->new_block);
+
+	while (1) {
+
+		bio =3D pop_and_remap(remap);
+
+		if (bio)
+			generic_make_request(bio);
+		else
+			break;
+
+		atomic_dec(&remap->dev->remap_ct);
+
+		DPRINTK("Flushed %llu:%llu (%u bytes)\n",
+			dmu_block(remap->dev, bio->bi_sector),
+			dmu_sector_offset(remap->dev, bio->bi_sector),
+			bio->bi_size);
+	}
+
+	get_remap_attrs(remap, &copy_first, &temporary, &next);
+
+	if (next)
+		copy_or_flush(next);
+
+	/* Notify userspace */
+	if (copy_first) {
+		req =3D kmem_cache_alloc(request_cache, GFP_KERNEL);
+		if (!req) {
+			printk(KERN_ERR DMU_PREFIX
+			       "Failed to allocate copy response\n");
+			return;
+		}
+
+		init_request(remap->dev, DM_USERSPACE_COPY_FINISHED, req);
+
+		req->u.block =3D remap->org_block;
+
+		add_request(remap->dev, req);
+	}
+
+	if (temporary) {
+		destroy_remap(remap);
+		kmem_cache_free(remap_cache, remap);
+	}
+}
+
+static void destroy_dmu_device(struct kref *ref)
+{
+	struct dmu_device *dev;
+	struct list_head *cursor, *next;
+	uint64_t remaps;
+
+	dev =3D container_of(ref, struct dmu_device, users);
+
+	DPRINTK("Destroying device: %s\n", dev->key);
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
+	remaps =3D ht_destroy_table(&dev->remaps);
+	DPRINTK("Destroyed %llu/%llu remaps\n", remaps, dev->remaps.count);
+
+	list_for_each_safe(cursor, next, &dev->requests) {
+		struct userspace_request *req;
+
+		req =3D list_entry(cursor,
+				 struct userspace_request,
+				 list);
+
+		list_del(&req->list);
+
+		error_bios(&req->u.bios);
+
+		kmem_cache_free(request_cache, req);
+	}
+
+	kcopyd_client_destroy(dev->kcopyd_client);
+
+	cdev_del(&dev->cdev);
+	kfree(dev);
+}
+
+static inline void get_dev(struct dmu_device *dev)
+{
+	DPRINTK("get on %s\n", dev->key);
+	kref_get(&dev->users);
+}
+
+static inline void put_dev(struct dmu_device *dev)
+{
+	DPRINTK("put on %s\n", dev->key);
+	kref_put(&dev->users, destroy_dmu_device);
+}
+
+static int get_free_minor(void)
+{
+	struct dmu_device *dev;
+	int minor =3D 0;
+
+	spin_lock(&devices_lock);
+
+	list_for_each_entry(dev, &devices, list) {
+		if (MINOR(dev->ctl_dev) !=3D minor)
+			break;
+		minor++;
+	}
+
+	spin_unlock(&devices_lock);
+
+	return minor;
+}
+
+static int init_dmu_device(struct dmu_device *dev, u32 block_size)
+{
+	int ret;
+
+	cdev_init(&dev->cdev, &ctl_fops);
+	dev->cdev.owner =3D THIS_MODULE;
+	dev->cdev.ops =3D &ctl_fops;
+
+	init_waitqueue_head(&dev->wqueue);
+	INIT_LIST_HEAD(&dev->list);
+	INIT_LIST_HEAD(&dev->requests);
+	INIT_LIST_HEAD(&dev->target_devs);
+	kref_init(&dev->users);
+	spin_lock_init(&dev->lock);
+
+	atomic_set(&dev->remap_ct, 0);
+	dev->id_counter =3D 1; /* reserve 0 for unsolicited maps */
+
+	if (!ht_init(&dev->remaps, 2048)) {
+		printk(KERN_ERR DMU_PREFIX
+		       "Unable to allocate hash table\n");
+		return 0;
+	}
+
+	dev->block_size  =3D block_size;
+	dev->block_mask  =3D block_size - 1;
+	dev->block_shift =3D ffs(block_size) - 1;
+
+	ret =3D kcopyd_client_create(DMU_COPY_PAGES, &dev->kcopyd_client);
+	if (ret) {
+		printk(DMU_PREFIX "Failed to initialize kcopyd client\n");
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
+	struct dmu_device *dev, *ptr;
+	int                ret;
+
+	dev =3D kmalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev =3D=3D NULL) {
+		printk(DMU_PREFIX "Failed to allocate new userspace device\n");
+		return NULL;
+	}
+
+	if (!init_dmu_device(dev, block_size))
+		goto bad1;
+
+	snprintf(dev->key, DMU_KEY_LEN, "%s", key);
+
+	DPRINTK("New device with size %llu mask 0x%llX shift %u\n",
+		dev->block_size, dev->block_mask, dev->block_shift);
+
+	dev->ctl_dev =3D MKDEV(MAJOR(our_dev), get_free_minor());
+
+	ret =3D cdev_add(&dev->cdev, dev->ctl_dev, 1);
+	if (ret < 0) {
+		printk(DMU_PREFIX "Failed to register control device %d:%d\n",
+		       MAJOR(dev->ctl_dev), MINOR(dev->ctl_dev));
+		goto bad2;
+	}
+
+	DPRINTK("Registered new control interface: %i:%i\n",
+		MAJOR(dev->ctl_dev), MINOR(dev->ctl_dev));
+
+	spin_lock(&devices_lock);
+	if (list_empty(&devices))
+		list_add(&dev->list, &devices);
+	else
+		list_for_each_entry(ptr, &devices, list)
+			if (MINOR(ptr->ctl_dev) < MINOR(dev->ctl_dev))
+				list_add(&dev->list, &ptr->list);
+	spin_unlock(&devices_lock);
+
+	return dev;
+
+ bad2:
+	cdev_del(&dev->cdev);
+ bad1:
+	kfree(dev);
+	printk(KERN_ERR DMU_PREFIX "Failed to create device\n");
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
+
+	if (argc < 2) {
+		DMU_SET_ERROR(ti, "Invalid argument count");
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
+			DMU_SET_ERROR(ti, "Failed to create device");
+			goto bad;
+		}
+	} else {
+		get_dev(dev);
+	}
+
+	spin_lock(&dev->lock);
+	if (dev->block_size !=3D block_size) {
+		DMU_SET_ERROR(ti, "Invalid block size");
+		goto bad;
+	}
+	spin_unlock(&dev->lock);
+
+	ti->private  =3D dev;
+	ti->split_io =3D block_size;
+
+	DPRINTK("  block-size:  %llu sectors\n", dev->block_size);
+	DPRINTK("  block-shift: %u\n", dev->block_shift);
+	DPRINTK("  block-mask:  %llx\n", dev->block_mask);
+
+	return 0;
+
+ bad:
+	if (dev) {
+		spin_unlock(&dev->lock);
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
+
+	DPRINTK("destroyed %d:%d\n", (int)ti->begin, (int)ti->len);
+}
+
+/* Search @dev for an outstanding request for remapping @block */
+static struct userspace_request *find_existing_req(struct dmu_device *dev,
+						   uint64_t block)
+{
+	struct userspace_request *req;
+	struct userspace_request *maybe =3D NULL;
+
+	spin_lock(&dev->lock);
+
+	list_for_each_entry(req, &dev->requests, list) {
+		if ((req->type =3D=3D DM_USERSPACE_MAP_BLOCK) &&
+		    (dmu_block(dev, req->u.bios.head->bi_sector) =3D=3D block)) {
+			if (maybe) {
+				atomic_dec(&maybe->refcnt);
+			}
+			maybe =3D req;
+			atomic_inc(&maybe->refcnt);
+		}
+	}
+
+	spin_unlock(&dev->lock);
+
+	return maybe;
+}
+
+static int make_new_request(struct dmu_device *dev, struct bio *bio)
+{
+	struct userspace_request *req;
+
+	req =3D kmem_cache_alloc(request_cache, GFP_KERNEL);
+	if (req =3D=3D NULL)
+		goto bad;
+
+	init_request(dev, DM_USERSPACE_MAP_BLOCK, req);
+
+	dmu_set_flag(&req->flags, DMU_FLAG_RD);
+	if (bio_rw(bio))
+		dmu_set_flag(&req->flags, DMU_FLAG_WR);
+	else
+		dmu_clr_flag(&req->flags, DMU_FLAG_WR);
+	bio_list_add(&req->u.bios, bio);
+
+	add_request(dev, req);
+
+	DPRINTK("Queued %s request for sector " SECTOR_FORMAT "\n",
+		dmu_get_flag(&req->flags, DMU_FLAG_WR) ? "write" : "read",
+		bio->bi_sector);
+
+	return 0;
+
+ bad:
+	printk(KERN_ERR DMU_PREFIX "Failed to queue bio!\n");
+	return -1;
+}
+
+static int dmu_map_remap_case(struct dmu_device *dev,
+			      struct dmu_map *remap,
+			      struct bio *bio)
+{
+	int ret =3D 0;
+
+	spin_lock(&remap->lock);
+
+	if (dmu_get_flag(&remap->flags, DMU_FLAG_WR) !=3D bio_rw(bio)) {
+		ret =3D -1;
+	} else {
+		if (dmu_get_flag(&remap->flags, DMU_FLAG_VALID)) {
+			__bio_remap(bio, remap);
+			ret =3D 1;
+			atomic_dec(&dev->remap_ct);
+		} else {
+			bio_list_add(&remap->bios, bio);
+		}
+	}
+
+	spin_unlock(&remap->lock);
+
+	return ret;
+}
+
+static int dmu_map_request_case(struct dmu_device *dev,
+				struct userspace_request *req,
+				struct bio *bio)
+{
+	int ret =3D 0;
+	int req_rw =3D dmu_get_flag(&req->flags, DMU_FLAG_WR);
+
+	spin_lock(&req->lock);
+
+	if (!req_rw && bio_rw(bio) && !req->sent) {
+		/* Convert to R/W and Queue */
+		dmu_set_flag(&req->flags, DMU_FLAG_WR);
+		bio_list_add(&req->u.bios, bio);
+	} else if (!req_rw && bio_rw(bio) && req->sent) {
+		/* Can't convert, must re-request */
+		ret =3D -1;
+	} else {
+		/* Queue */
+		bio_list_add(&req->u.bios, bio);
+	}
+
+	spin_unlock(&req->lock);
+
+	return ret;
+}
+
+static int dmu_map(struct dm_target *ti, struct bio *bio,
+		   union map_info *map_context)
+{
+	struct dmu_device *dev =3D (struct dmu_device *) ti->private;
+	struct dmu_map *remap;
+	struct userspace_request *req;
+	int ret =3D 0;
+	u64 block;
+
+	atomic_inc(&dev->remap_ct);
+
+	block =3D dmu_block(dev, bio->bi_sector);
+
+	remap =3D ht_find_map_dev(dev, block);
+	if (remap) {
+		ret =3D dmu_map_remap_case(dev, remap, bio);
+		if (ret >=3D 0)
+			goto done;
+	}
+
+	req =3D find_existing_req(dev, block);
+	if (req) {
+		ret =3D dmu_map_request_case(dev, req, bio);
+		atomic_dec(&req->refcnt);
+		if (ret >=3D 0)
+			goto done;
+	}
+
+	ret =3D make_new_request(dev, bio);
+
+ done:
+	return ret;
+}
+
+static int dmu_status(struct dm_target *ti, status_type_t type,
+		      char *result, unsigned int maxlen)
+{
+	struct dmu_device *dev =3D (struct dmu_device *) ti->private;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		snprintf(result, maxlen, "%x:%x\n",
+			 MAJOR(dev->ctl_dev),
+			 MINOR(dev->ctl_dev));
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
+static struct target_type userspace_target =3D {
+	.name    =3D "userspace",
+	.version =3D {0, 1, 0},
+	.module  =3D THIS_MODULE,
+	.ctr     =3D dmu_ctr,
+	.dtr     =3D dmu_dtr,
+	.map     =3D dmu_map,
+	.status  =3D dmu_status,
+};
+
+static int format_userspace_message(struct dmu_write *msg,
+				      struct userspace_request *req)
+{
+	int ret =3D 1;
+
+	spin_lock(&req->lock);
+
+	if (req->sent)
+		goto out;
+
+	msg->id =3D req->id;
+	msg->type =3D req->type;
+	dmu_cpy_flag(&msg->flags, req->flags, DMU_FLAG_RD);
+	dmu_cpy_flag(&msg->flags, req->flags, DMU_FLAG_WR);
+
+	switch (msg->type) {
+	case DM_USERSPACE_MAP_BLOCK:
+		msg->org_block =3D dmu_block(req->dev,
+					   req->u.bios.head->bi_sector);
+		DPRINTK("Asking userspace to map %llu (%c)\n",
+			msg->org_block,
+			dmu_get_flag(&msg->flags, DMU_FLAG_WR) ? 'W' : 'R');
+		break;
+
+	case DM_USERSPACE_COPY_FINISHED:
+	case DM_USERSPACE_INVAL_COMPLETE:
+	case DM_USERSPACE_INVAL_FAILED:
+		msg->org_block =3D req->u.block;
+		break;
+
+	default:
+		printk(KERN_INFO DMU_PREFIX
+		       "Unknown message type %i\n", msg->type);
+		ret =3D 0;
+	}
+
+	req->sent =3D 1;
+
+ out:
+	spin_unlock(&req->lock);
+
+	if (msg->type !=3D DM_USERSPACE_MAP_BLOCK) {
+		/* COPY_FINISHED, et al messages don't get responses,
+		 * so we take them off the request queue here
+		 */
+		list_del(&req->list);
+		kmem_cache_free(request_cache, req);
+	}
+
+	return ret;
+}
+
+ssize_t dmu_ctl_read(struct file *file, char __user *buffer,
+		     size_t size, loff_t *offset)
+{
+
+	struct dmu_device  *dev =3D (struct dmu_device *)file->private_data;
+	struct dmu_write   *msg;
+	struct userspace_request *req =3D NULL;
+	struct userspace_request *next;
+	int                 ret =3D 0;
+	int                 num_reqs, req_idx =3D 0;
+
+	num_reqs =3D size / sizeof(*msg);
+
+	if (num_reqs =3D=3D 0)
+		return -EINVAL;
+
+	msg =3D kmalloc(num_reqs * sizeof(*msg), GFP_KERNEL);
+	if (!msg) {
+		printk(KERN_ERR DMU_PREFIX
+		       "Failed to alloc %i reqs!\n", num_reqs);
+		return -ENOMEM;
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
+	spin_lock(&dev->lock);
+
+	list_for_each_entry_safe(req, next, &dev->requests, list) {
+
+		if (!format_userspace_message(&msg[req_idx], req))
+			continue;
+
+		ret +=3D sizeof(*msg);
+		if (++req_idx >=3D num_reqs) {
+			break;
+		}
+	}
+
+	spin_unlock(&dev->lock);
+
+	if (copy_to_user(buffer, msg, sizeof(*msg) * req_idx)) {
+		DPRINTK("control read copy_to_user failed!\n");
+		ret =3D -EFAULT;
+	}
+
+	kfree(msg);
+
+	return ret;
+}
+
+static void copy_callback(int read_err,
+                          unsigned int write_err,
+                          void *data)
+{
+	remap_flusher((struct dmu_map *)data);
+}
+
+static void copy_block(struct dmu_map *remap)
+{
+	struct io_region src, dst;
+	struct kcopyd_client *client;
+
+	spin_lock(&remap->lock);
+
+	src.bdev =3D remap->src->bdev;
+	src.sector =3D remap->org_block << remap->dev->block_shift;
+	src.count =3D remap->dev->block_size;
+
+	dst.bdev =3D remap->dest->bdev;
+	dst.sector =3D (remap->new_block << remap->dev->block_shift);
+	dst.sector +=3D remap->offset;
+	dst.count =3D remap->dev->block_size;
+
+	DPRINTK("Copying: "
+		SECTOR_FORMAT "(" SECTOR_FORMAT "):" SECTOR_FORMAT " -> "
+		SECTOR_FORMAT "(" SECTOR_FORMAT "):" SECTOR_FORMAT "\n",
+		remap->org_block,
+		src.sector,
+		src.count * 512,
+		remap->new_block,
+		dst.sector,
+		dst.count * 512);
+
+	client =3D remap->dev->kcopyd_client;
+
+	spin_unlock(&remap->lock);
+
+	kcopyd_copy(client, &src, 1, &dst, 0, copy_callback, remap);
+}
+
+static int remap_request(struct dmu_write *msg,
+			 struct dmu_device *dev,
+			 struct userspace_request *req)
+
+{
+	struct dmu_map *remap =3D NULL, *parent =3D NULL;
+	struct target_device *s_dev =3D NULL, *d_dev =3D NULL;
+	int is_chained =3D 0;
+	struct bio_list bio_holder;
+
+	if (dmu_get_flag(&msg->flags, DMU_FLAG_COPY_FIRST)) {
+		s_dev =3D get_target(dev, MKDEV(msg->src_maj, msg->src_min));
+		if (!s_dev) {
+			printk(KERN_ERR DMU_PREFIX
+			       "Failed to find src device %i:%i\n",
+			       msg->src_maj, msg->src_min);
+			goto bad;
+		}
+	}
+
+	d_dev =3D get_target(dev, MKDEV(msg->dest_maj, msg->dest_min));
+	if (!d_dev) {
+		printk(KERN_ERR DMU_PREFIX "Failed to find dst device %i:%i\n",
+		       msg->dest_maj, msg->dest_min);
+		goto bad;
+	}
+
+	if (req) {
+		while (atomic_read(&req->refcnt) !=3D 0) {
+			DPRINTK("Waiting for exclusive use of request\n");
+			schedule();
+		}
+
+		spin_lock(&req->lock);
+		bio_holder =3D req->u.bios;
+		spin_unlock(&req->lock);
+	} else {
+		bio_list_init(&bio_holder);
+	}
+
+	/* Allocate a new remap early (before grabbing locks), since
+	   we will most likely need it */
+	remap =3D kmem_cache_alloc(remap_cache, GFP_KERNEL);
+	if (!remap) {
+		printk(KERN_ERR DMU_PREFIX "Failed to alloc remap!");
+		goto bad;
+	}
+	init_remap(dev, remap);
+	spin_lock(&remap->lock);
+	remap->org_block =3D msg->org_block;
+
+	spin_lock(&dev->lock);
+
+	/* Here, we insert the new remap into the table, and remove
+	   the existing map, if present, all in one locked operation */
+
+	parent =3D ht_find_map(&dev->remaps, msg->org_block);
+	if (parent) {
+
+		spin_lock(&parent->lock);
+
+		if (!dmu_get_flag(&parent->flags, DMU_FLAG_VALID)) {
+			if (dmu_get_flag(&parent->flags, DMU_FLAG_WR) =3D=3D
+			    dmu_get_flag(&msg->flags, DMU_FLAG_WR) &&
+			    (parent->new_block =3D=3D msg->new_block)) {
+				/* Perms match for this not-yet-valid remap,
+				   so tag our bios on to it and bail */
+				bio_list_merge(&parent->bios,
+					       &bio_holder);
+
+				spin_unlock(&parent->lock);
+				spin_unlock(&dev->lock);
+				kmem_cache_free(remap_cache, remap);
+				return 1;
+			} else {
+				/* Remove parent from remap table, and
+				   chain our new remap to this one so
+				   it will fire when parent goes
+				   valid */
+				list_del(&parent->list);
+				if (parent->next) {
+					DPRINTK("Parent already chained!\n");
+					BUG();
+				}
+				parent->next =3D remap;
+				dmu_set_flag(&parent->flags,
+					     DMU_FLAG_TEMPORARY);
+				is_chained =3D 1;
+			}
+		} else {
+			/* Remove existing valid remap */
+			list_del(&parent->list);
+			destroy_remap(parent);
+			kmem_cache_free(remap_cache, parent);
+		}
+
+		spin_unlock(&parent->lock);
+	}
+
+	ht_insert_map(&dev->remaps, remap);
+
+	spin_unlock(&dev->lock);
+
+	remap->new_block  =3D msg->new_block;
+	remap->offset     =3D msg->offset;
+	remap->src        =3D s_dev;
+	remap->dest       =3D d_dev;
+	remap->dev        =3D dev;
+
+	dmu_clr_flag(&remap->flags, DMU_FLAG_VALID);
+	dmu_cpy_flag(&remap->flags, msg->flags, DMU_FLAG_TEMPORARY);
+	dmu_cpy_flag(&remap->flags, msg->flags, DMU_FLAG_WR);
+	dmu_cpy_flag(&remap->flags, msg->flags, DMU_FLAG_RD);
+	dmu_cpy_flag(&remap->flags, msg->flags, DMU_FLAG_COPY_FIRST);
+
+	remap->bios =3D bio_holder;
+
+	spin_unlock(&remap->lock);
+
+	if (! is_chained)
+		copy_or_flush(remap);
+
+	return 1;
+
+ bad:
+	printk(KERN_ERR DMU_PREFIX "Remap error: chaos may ensue\n");
+
+	return 0;
+}
+
+static int invalidate_request(struct dmu_write *msg,
+			      struct dmu_device *dev)
+{
+	struct dmu_map *remap;
+	struct userspace_request *req;
+	int ret =3D 1;
+
+	remap =3D ht_find_map_dev(dev, msg->org_block);
+	if (!remap)
+		ret =3D 0;
+	else {
+		spin_lock(&dev->lock);
+		spin_lock(&remap->lock);
+		if (dmu_get_flag(&remap->flags, DMU_FLAG_VALID))
+			ht_delete_map(&dev->remaps, remap);
+		else
+			ret =3D 0;
+		spin_unlock(&remap->lock);
+		spin_unlock(&dev->lock);
+	}
+
+	req =3D kmem_cache_alloc(request_cache, GFP_KERNEL);
+	if (!req) {
+		printk(KERN_ERR DMU_PREFIX
+		       "Failed to allocate request\n");
+		return 0;
+	}
+
+	if (ret) {
+		DPRINTK("Invalidated mapping for: %llu\n",
+			msg->org_block);
+		init_request(dev, DM_USERSPACE_INVAL_COMPLETE, req);
+	} else {
+		DPRINTK("Failed to invalidate mapping for: %llu\n",
+			msg->org_block);
+		init_request(dev, DM_USERSPACE_INVAL_FAILED, req);
+	}
+
+	req->u.block =3D msg->org_block;
+
+	add_request(dev, req);
+
+	return ret;
+}
+
+ssize_t dmu_ctl_write(struct file *file, const char __user *buffer,
+		      size_t size, loff_t *offset)
+{
+
+	struct dmu_device *dev =3D (struct dmu_device *)file->private_data;
+	struct dmu_write msg;
+	struct userspace_request *next;
+	struct userspace_request *req =3D NULL, *match =3D NULL;
+	int num_resp, resp_idx;
+	int ret =3D 0;
+
+	num_resp =3D size / sizeof(struct dmu_write);
+
+	if (num_resp =3D=3D 0)
+		return -EINVAL;
+
+	for (resp_idx =3D 0; resp_idx < num_resp; resp_idx++) {
+		if (copy_from_user(&msg, buffer+ret, sizeof(msg))) {
+			printk(DMU_PREFIX
+			       "control_write copy_from_user failed!\n");
+			ret =3D -EFAULT;
+			goto out;
+		}
+
+		ret +=3D sizeof(msg);
+
+		match =3D NULL;
+		/* See if we have a pending request that matches this */
+		spin_lock(&dev->lock);
+		list_for_each_entry_safe(req, next, &dev->requests, list) {
+			if ((req->type =3D=3D DM_USERSPACE_MAP_BLOCK) &&
+			    (req->id =3D=3D msg.id)) {
+				list_del(&req->list);
+				match =3D req;
+				break;
+			}
+		}
+		spin_unlock(&dev->lock);
+
+		if (!match)
+			DPRINTK("Processing unsolicited request: %u\n",
+				msg.id);
+
+		switch (msg.type) {
+
+		case DM_USERSPACE_MAP_BLOCK:
+			DPRINTK("Got map: %llu -> %llu:%lli (%i:%i) [%c]\n",
+				msg.org_block,
+				msg.new_block,
+				msg.offset,
+				msg.dest_maj,
+				msg.dest_min,
+				dmu_get_flag(&msg.flags, DMU_FLAG_WR)?'W':'R');
+			remap_request(&msg, dev, match);
+			break;
+
+		case DM_USERSPACE_MAP_FAILED:
+			if (match) {
+				printk(KERN_EMERG DMU_PREFIX
+				       "userspace reported "
+				       "failure to map sector %lu\n",
+				       (unsigned long)
+				       match->u.bios.head->bi_sector);
+
+				spin_lock(&match->lock);
+				error_bios(&match->u.bios);
+				spin_unlock(&match->lock);
+			}
+			break;
+
+		case DM_USERSPACE_MAP_INVALIDATE:
+			invalidate_request(&msg, dev);
+			break;
+
+		default:
+			printk(KERN_ERR DMU_PREFIX
+			       "Unknown request type: %i\n", msg.type);
+		}
+
+		if (match)
+			kmem_cache_free(request_cache, match);
+	}
+ out:
+	return ret;
+}
+
+int dmu_ctl_open(struct inode *inode, struct file *file)
+{
+	struct dmu_device *dev;
+
+	dev =3D container_of(inode->i_cdev, struct dmu_device, cdev);
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
+	struct dmu_device *dev;
+	unsigned mask =3D 0;
+
+	dev =3D (struct dmu_device *)file->private_data;
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
+int __init dm_userspace_init(void)
+{
+	int r =3D dm_register_target(&userspace_target);
+	if (r < 0) {
+		DMERR(DMU_PREFIX "Register failed %d", r);
+		return 0;
+	}
+
+	spin_lock_init(&devices_lock);
+
+	if (enable_watchdog) {
+		INIT_WORK(&wd, watchdog, NULL);
+		schedule_delayed_work(&wd, HZ);
+	}
+
+	request_cache =3D
+		kmem_cache_create("dm-userspace-requests",
+				  sizeof(struct userspace_request),
+				  __alignof__ (struct userspace_request),
+				  0, NULL, NULL);
+	if (!request_cache) {
+		DMERR(DMU_PREFIX "Failed to allocate request cache\n");
+		goto bad;
+	}
+
+	remap_cache =3D
+		kmem_cache_create("dm-userspace-remaps",
+				  sizeof(struct dmu_map),
+				  __alignof__ (struct dmu_map),
+				  0, NULL, NULL);
+	if (!remap_cache) {
+		DMERR(DMU_PREFIX "Failed to allocate remap cache\n");
+		goto bad2;
+	}
+
+	r =3D alloc_chrdev_region(&our_dev, 0, 10, "dm-userspace");
+	if (r) {
+		DMERR(DMU_PREFIX "Failed to allocate chardev region\n");
+		goto bad3;
+	}
+
+	DPRINTK(DMU_PREFIX "Loaded (major %i)\n", MAJOR(our_dev));
+
+	return 1;
+
+ bad3:
+	kmem_cache_destroy(remap_cache);
+ bad2:
+	kmem_cache_destroy(request_cache);
+ bad:
+	dm_unregister_target(&userspace_target);
+	return 0;
+
+}
+
+void __exit dm_userspace_exit(void)
+{
+	int r;
+	struct list_head *cursor, *next;
+	struct dmu_device *dev;
+
+	DPRINTK(DMU_PREFIX "Unloading\n");
+
+	if (enable_watchdog)
+		if (!cancel_delayed_work(&wd))
+			flush_scheduled_work();
+
+	spin_lock(&devices_lock);
+
+	list_for_each_safe(cursor, next, &devices) {
+		dev =3D list_entry(cursor, struct dmu_device, list);
+		list_del(cursor);
+	}
+
+	spin_unlock(&devices_lock);
+
+	unregister_chrdev_region(our_dev, 10);
+
+	kmem_cache_destroy(request_cache);
+	kmem_cache_destroy(remap_cache);
+
+	r =3D dm_unregister_target(&userspace_target);
+	if (r < 0)
+		DMERR(DMU_PREFIX "unregister failed %d", r);
+}
+
+module_init(dm_userspace_init);
+module_exit(dm_userspace_exit);
+
+module_param(enable_watchdog, int, S_IRUGO);
+
+MODULE_DESCRIPTION(DM_NAME " userspace target");
+MODULE_AUTHOR("Dan Smith");
+MODULE_LICENSE("GPL");
diff -Naur linux-2.6.16.20-orig/drivers/md/Kconfig linux-2.6.16.20-dmu/driv=
ers/md/Kconfig
=2D-- linux-2.6.16.20-orig/drivers/md/Kconfig	2006-06-05 10:18:23.000000000=
 -0700
+++ linux-2.6.16.20-dmu/drivers/md/Kconfig	2006-06-14 07:15:09.000000000 -0=
700
@@ -210,6 +210,12 @@
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
diff -Naur linux-2.6.16.20-orig/drivers/md/Makefile linux-2.6.16.20-dmu/dri=
vers/md/Makefile
=2D-- linux-2.6.16.20-orig/drivers/md/Makefile	2006-06-05 10:18:23.00000000=
0 -0700
+++ linux-2.6.16.20-dmu/drivers/md/Makefile	2006-06-14 07:15:09.000000000 -=
0700
@@ -37,6 +37,7 @@
 obj-$(CONFIG_DM_SNAPSHOT)	+=3D dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+=3D dm-mirror.o
 obj-$(CONFIG_DM_ZERO)		+=3D dm-zero.o
+obj-$(CONFIG_DM_USERSPACE)      +=3D dm-userspace.o
=20
 quiet_cmd_unroll =3D UNROLL  $@
       cmd_unroll =3D $(PERL) $(srctree)/$(src)/unroll.pl $(UNROLL) \
diff -Naur linux-2.6.16.20-orig/include/linux/dm-userspace.h linux-2.6.16.2=
0-dmu/include/linux/dm-userspace.h
=2D-- linux-2.6.16.20-orig/include/linux/dm-userspace.h	1969-12-31 16:00:00=
.000000000 -0800
+++ linux-2.6.16.20-dmu/include/linux/dm-userspace.h	2006-06-14 11:10:01.00=
0000000 -0700
@@ -0,0 +1,88 @@
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
+#ifdef __KERNEL__
+# include <linux/types.h>
+#else
+# include <stdint.h>
+#endif
+
+/*
+ * Message Types
+ */
+#define DM_USERSPACE_MAP_BLOCK        1
+#define DM_USERSPACE_MAP_FAILED       2
+#define DM_USERSPACE_MAP_INVALIDATE   3
+#define DM_USERSPACE_COPY_FINISHED  100
+#define DM_USERSPACE_INVAL_COMPLETE 101
+#define DM_USERSPACE_INVAL_FAILED   102
+
+/*
+ * Flags and associated macros
+ */
+#define DMU_FLAG_VALID       1
+#define DMU_FLAG_RD          2
+#define DMU_FLAG_WR          4
+#define DMU_FLAG_COPY_FIRST  8
+#define DMU_FLAG_TEMPORARY  16
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
+ * This is the message that is passed back and forth between the
+ * kernel and the user application
+ */
+struct dmu_write {
+	uint64_t org_block;    /* Block that was accessed */
+	uint64_t new_block;    /* The new block it should go to */
+  	int64_t offset;        /* Sector offset of the block, if needed  */
+
+	uint32_t id;           /* Unique ID for this request */
+	uint32_t type;         /* Type of request */
+	uint32_t flags;        /* Flags */
+
+	uint32_t src_maj;      /* The source device for copying */
+	uint32_t src_min;
+
+	uint32_t dest_maj;     /* Destination device for copying, and */
+	uint32_t dest_min;     /* for the block access                */
+};
+
+#endif

--=-=-=
Content-Transfer-Encoding: quoted-printable

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=--

--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEkYPdwtEf7b4GJVQRAq6VAJ9HGLRPoix2Le07956xu7eWvJxNywCghnCB
Guk3LB914+ULdjCO5MEU+vw=
=vTWR
-----END PGP SIGNATURE-----
--==-=-=--


--===============2133654510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2133654510==--
