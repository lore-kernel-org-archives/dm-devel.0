From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v4 5/7] dm,dax: Add dax zero_page_range operation
Date: Mon, 17 Feb 2020 13:16:51 -0500
Message-ID: <20200217181653.4706-6-vgoyal@redhat.com>
References: <20200217181653.4706-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200217181653.4706-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com
List-Id: dm-devel.ids

This patch adds support for dax zero_page_range operation to dm targets.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/md/dm-linear.c        | 21 +++++++++++++++++++++
 drivers/md/dm-log-writes.c    | 19 +++++++++++++++++++
 drivers/md/dm-stripe.c        | 26 ++++++++++++++++++++++++++
 drivers/md/dm.c               | 31 +++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  3 +++
 5 files changed, 100 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 8d07fdf63a47..03f99e6ad372 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -201,10 +201,30 @@ static size_t linear_dax_copy_to_iter(struct dm_tar=
get *ti, pgoff_t pgoff,
 	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
=20
+static int linear_dax_zero_page_range(struct dm_target *ti, u64 offset,
+				      size_t len)
+{
+	int ret;
+	struct linear_c *lc =3D ti->private;
+	struct block_device *bdev =3D lc->dev->bdev;
+	struct dax_device *dax_dev =3D lc->dev->dax_dev;
+	pgoff_t pgoff =3D offset >> PAGE_SHIFT;
+	unsigned page_offset =3D offset_in_page(offset);
+	sector_t dev_sector, sector =3D pgoff * PAGE_SECTORS;
+
+	dev_sector =3D linear_map_sector(ti, sector);
+	ret =3D bdev_dax_pgoff(bdev, dev_sector, ALIGN(len, PAGE_SIZE), &pgoff)=
;
+	if (ret)
+		return ret;
+	return dax_zero_page_range(dax_dev, (pgoff << PAGE_SHIFT) + page_offset=
,
+				   len);
+}
+
 #else
 #define linear_dax_direct_access NULL
 #define linear_dax_copy_from_iter NULL
 #define linear_dax_copy_to_iter NULL
+#define linear_dax_zero_page_range NULL
 #endif
=20
 static struct target_type linear_target =3D {
@@ -226,6 +246,7 @@ static struct target_type linear_target =3D {
 	.direct_access =3D linear_dax_direct_access,
 	.dax_copy_from_iter =3D linear_dax_copy_from_iter,
 	.dax_copy_to_iter =3D linear_dax_copy_to_iter,
+	.dax_zero_page_range =3D linear_dax_zero_page_range,
 };
=20
 int __init dm_linear_init(void)
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 99721c76225d..f36ee223cb60 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -994,10 +994,28 @@ static size_t log_writes_dax_copy_to_iter(struct dm=
_target *ti,
 	return dax_copy_to_iter(lc->dev->dax_dev, pgoff, addr, bytes, i);
 }
=20
+static int log_writes_dax_zero_page_range(struct dm_target *ti, u64 offs=
et,
+					  size_t len)
+{
+	int ret;
+	struct log_writes_c *lc =3D ti->private;
+	pgoff_t pgoff =3D offset >> PAGE_SHIFT;
+	unsigned page_offset =3D offset_in_page(offset);
+	sector_t sector =3D pgoff * PAGE_SECTORS;
+
+	ret =3D bdev_dax_pgoff(lc->dev->bdev, sector, ALIGN(len, PAGE_SIZE),
+			     &pgoff);
+	if (ret)
+		return ret;
+	return dax_zero_page_range(lc->dev->dax_dev,
+				   (pgoff << PAGE_SHIFT) + page_offset, len);
+}
+
 #else
 #define log_writes_dax_direct_access NULL
 #define log_writes_dax_copy_from_iter NULL
 #define log_writes_dax_copy_to_iter NULL
+#define log_writes_dax_zero_page_range NULL
 #endif
=20
 static struct target_type log_writes_target =3D {
@@ -1016,6 +1034,7 @@ static struct target_type log_writes_target =3D {
 	.direct_access =3D log_writes_dax_direct_access,
 	.dax_copy_from_iter =3D log_writes_dax_copy_from_iter,
 	.dax_copy_to_iter =3D log_writes_dax_copy_to_iter,
+	.dax_zero_page_range =3D log_writes_dax_zero_page_range,
 };
=20
 static int __init dm_log_writes_init(void)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 63bbcc20f49a..f5e17284c615 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -360,10 +360,35 @@ static size_t stripe_dax_copy_to_iter(struct dm_tar=
get *ti, pgoff_t pgoff,
 	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
=20
+static int stripe_dax_zero_page_range(struct dm_target *ti, u64 offset,
+				      size_t len)
+{
+	int ret;
+	pgoff_t pgoff =3D offset >> PAGE_SHIFT;
+	unsigned page_offset =3D offset_in_page(offset);
+	sector_t dev_sector, sector =3D pgoff * PAGE_SECTORS;
+	struct stripe_c *sc =3D ti->private;
+	struct dax_device *dax_dev;
+	struct block_device *bdev;
+	uint32_t stripe;
+
+	stripe_map_sector(sc, sector, &stripe, &dev_sector);
+	dev_sector +=3D sc->stripe[stripe].physical_start;
+	dax_dev =3D sc->stripe[stripe].dev->dax_dev;
+	bdev =3D sc->stripe[stripe].dev->bdev;
+
+	ret =3D bdev_dax_pgoff(bdev, dev_sector, ALIGN(len, PAGE_SIZE), &pgoff)=
;
+	if (ret)
+		return ret;
+	return dax_zero_page_range(dax_dev, (pgoff << PAGE_SHIFT) + page_offset=
,
+				   len);
+}
+
 #else
 #define stripe_dax_direct_access NULL
 #define stripe_dax_copy_from_iter NULL
 #define stripe_dax_copy_to_iter NULL
+#define stripe_dax_zero_page_range NULL
 #endif
=20
 /*
@@ -486,6 +511,7 @@ static struct target_type stripe_target =3D {
 	.direct_access =3D stripe_dax_direct_access,
 	.dax_copy_from_iter =3D stripe_dax_copy_from_iter,
 	.dax_copy_to_iter =3D stripe_dax_copy_to_iter,
+	.dax_zero_page_range =3D stripe_dax_zero_page_range,
 };
=20
 int __init dm_stripe_init(void)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b89f07ee2eff..c87cabdf7f18 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1198,6 +1198,36 @@ static size_t dm_dax_copy_to_iter(struct dax_devic=
e *dax_dev, pgoff_t pgoff,
 	return ret;
 }
=20
+static int dm_dax_zero_page_range(struct dax_device *dax_dev, u64 offset=
,
+				  size_t len)
+{
+	struct mapped_device *md =3D dax_get_private(dax_dev);
+	pgoff_t pgoff =3D offset >> PAGE_SHIFT;
+	sector_t sector =3D pgoff * PAGE_SECTORS;
+	struct dm_target *ti;
+	int ret =3D -EIO;
+	int srcu_idx;
+
+	ti =3D dm_dax_get_live_target(md, sector, &srcu_idx);
+
+	if (!ti)
+		goto out;
+	if (WARN_ON(!ti->type->dax_zero_page_range)) {
+		/*
+		 * ->zero_page_range() is mandatory dax operation. If we are
+		 *  here, something is wrong.
+		 */
+		dm_put_live_table(md, srcu_idx);
+		goto out;
+	}
+	ret =3D ti->type->dax_zero_page_range(ti, offset, len);
+
+ out:
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  I=
t is
  * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
@@ -3199,6 +3229,7 @@ static const struct dax_operations dm_dax_ops =3D {
 	.dax_supported =3D dm_dax_supported,
 	.copy_from_iter =3D dm_dax_copy_from_iter,
 	.copy_to_iter =3D dm_dax_copy_to_iter,
+	.zero_page_range =3D dm_dax_zero_page_range,
 };
=20
 /*
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.=
h
index 475668c69dbc..b4ef5b07be74 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -141,6 +141,8 @@ typedef long (*dm_dax_direct_access_fn) (struct dm_ta=
rget *ti, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
 typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgof=
f,
 		void *addr, size_t bytes, struct iov_iter *i);
+typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, u64 offse=
t,
+		size_t len);
 #define PAGE_SECTORS (PAGE_SIZE / 512)
=20
 void dm_error(const char *message);
@@ -195,6 +197,7 @@ struct target_type {
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_copy_iter_fn dax_copy_from_iter;
 	dm_dax_copy_iter_fn dax_copy_to_iter;
+	dm_dax_zero_page_range_fn dax_zero_page_range;
=20
 	/* For internal device-mapper use. */
 	struct list_head list;
--=20
2.20.1
