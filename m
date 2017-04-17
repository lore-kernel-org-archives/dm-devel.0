From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [resend PATCH v2 20/33] dm: add ->copy_from_iter() dax operation
 support
Date: Mon, 17 Apr 2017 12:10:38 -0700
Message-ID: <149245623835.10206.17481761679193180574.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

Allow device-mapper to route copy_from_iter operations to the
per-target implementation. In order for the device stacking to work we
need a dax_dev and a pgoff relative to that device. This gives each
layer of the stack the information it needs to look up the operation
pointer for the next level.

This conceptually allows for an array of mixed device drivers with
varying copy_from_iter implementations.

Cc: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/dax/super.c           |   13 +++++++++++++
 drivers/md/dm-linear.c        |   15 +++++++++++++++
 drivers/md/dm-stripe.c        |   20 ++++++++++++++++++++
 drivers/md/dm.c               |   26 ++++++++++++++++++++++++++
 include/linux/dax.h           |    2 ++
 include/linux/device-mapper.h |    3 +++
 6 files changed, 79 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 23ce3ab49f10..73f0da8e5d27 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -17,6 +17,7 @@
 #include <linux/cdev.h>
 #include <linux/hash.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
 
@@ -104,6 +105,18 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 }
 EXPORT_SYMBOL_GPL(dax_direct_access);
 
+size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t bytes, struct iov_iter *i)
+{
+	if (!dax_alive(dax_dev))
+		return 0;
+
+	if (!dax_dev->ops->copy_from_iter)
+		return copy_from_iter(addr, bytes, i);
+	return dax_dev->ops->copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+EXPORT_SYMBOL_GPL(dax_copy_from_iter);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index c5a52f4dae81..5fe44a0ddfab 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -158,6 +158,20 @@ static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
+static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	struct linear_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = linear_map_sector(ti, sector);
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 3, 0},
@@ -169,6 +183,7 @@ static struct target_type linear_target = {
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
 	.direct_access = linear_dax_direct_access,
+	.dax_copy_from_iter = linear_dax_copy_from_iter,
 };
 
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index cb4b1e9e16ab..4f45d23249b2 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -330,6 +330,25 @@ static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
 }
 
+static size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+	struct stripe_c *sc = ti->private;
+	struct dax_device *dax_dev;
+	struct block_device *bdev;
+	uint32_t stripe;
+
+	stripe_map_sector(sc, sector, &stripe, &dev_sector);
+	dev_sector += sc->stripe[stripe].physical_start;
+	dax_dev = sc->stripe[stripe].dev->dax_dev;
+	bdev = sc->stripe[stripe].dev->bdev;
+
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+
 /*
  * Stripe status:
  *
@@ -448,6 +467,7 @@ static struct target_type stripe_target = {
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
 	.direct_access = stripe_dax_direct_access,
+	.dax_copy_from_iter = stripe_dax_copy_from_iter,
 };
 
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 79d5f5fd823e..8c8579efcba2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,6 +19,7 @@
 #include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
+#include <linux/uio.h>
 #include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
@@ -957,6 +958,30 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
+static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	struct mapped_device *md = dax_get_private(dax_dev);
+	sector_t sector = pgoff * PAGE_SECTORS;
+	struct dm_target *ti;
+	long ret = 0;
+	int srcu_idx;
+
+	ti = dm_dax_get_live_target(md, sector, &srcu_idx);
+
+	if (!ti)
+		goto out;
+	if (!ti->type->dax_copy_from_iter) {
+		ret = copy_from_iter(addr, bytes, i);
+		goto out;
+	}
+	ret = ti->type->dax_copy_from_iter(ti, pgoff, addr, bytes, i);
+ out:
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -2818,6 +2843,7 @@ static const struct block_device_operations dm_blk_dops = {
 
 static const struct dax_operations dm_dax_ops = {
 	.direct_access = dm_dax_direct_access,
+	.copy_from_iter = dm_dax_copy_from_iter,
 };
 
 /*
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 156f067d4db5..cd8561bb21f3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -32,6 +32,8 @@ void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);
+size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
+		size_t bytes, struct iov_iter *i);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index df830d167892..e18e4277d09d 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -130,6 +130,8 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
  */
 typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
+typedef size_t (*dm_dax_copy_from_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i);
 #define PAGE_SECTORS (PAGE_SIZE / 512)
 
 void dm_error(const char *message);
@@ -179,6 +181,7 @@ struct target_type {
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
 	dm_dax_direct_access_fn direct_access;
+	dm_dax_copy_from_iter_fn dax_copy_from_iter;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
