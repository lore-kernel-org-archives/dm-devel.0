From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 4/6] dax, dm/md: Use dax_pgoff() instead of bdev_dax_pgoff()
Date: Wed, 12 Feb 2020 12:07:31 -0500
Message-ID: <20200212170733.8092-5-vgoyal@redhat.com>
References: <20200212170733.8092-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200212170733.8092-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

Replace usage of bdev_dax_pgoff() with dax_pgoff().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/md/dm-linear.c     | 9 ++++++---
 drivers/md/dm-log-writes.c | 9 ++++++---
 drivers/md/dm-stripe.c     | 8 +++++---
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 8d07fdf63a47..05f654044185 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -167,7 +167,8 @@ static long linear_dax_direct_access(struct dm_target=
 *ti, pgoff_t pgoff,
 	sector_t dev_sector, sector =3D pgoff * PAGE_SECTORS;
=20
 	dev_sector =3D linear_map_sector(ti, sector);
-	ret =3D bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
+	ret =3D dax_pgoff(get_start_sect(bdev), dev_sector, nr_pages * PAGE_SIZ=
E,
+			&pgoff);
 	if (ret)
 		return ret;
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
@@ -182,7 +183,8 @@ static size_t linear_dax_copy_from_iter(struct dm_tar=
get *ti, pgoff_t pgoff,
 	sector_t dev_sector, sector =3D pgoff * PAGE_SECTORS;
=20
 	dev_sector =3D linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+	if (dax_pgoff(get_start_sect(bdev), dev_sector, ALIGN(bytes, PAGE_SIZE)=
,
+		      &pgoff))
 		return 0;
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
@@ -196,7 +198,8 @@ static size_t linear_dax_copy_to_iter(struct dm_targe=
t *ti, pgoff_t pgoff,
 	sector_t dev_sector, sector =3D pgoff * PAGE_SECTORS;
=20
 	dev_sector =3D linear_map_sector(ti, sector);
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+	if (dax_pgoff(get_start_sect(bdev), dev_sector, ALIGN(bytes, PAGE_SIZE)=
,
+		      &pgoff))
 		return 0;
 	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 99721c76225d..204fbceeb97e 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -952,7 +952,8 @@ static long log_writes_dax_direct_access(struct dm_ta=
rget *ti, pgoff_t pgoff,
 	sector_t sector =3D pgoff * PAGE_SECTORS;
 	int ret;
=20
-	ret =3D bdev_dax_pgoff(lc->dev->bdev, sector, nr_pages * PAGE_SIZE, &pg=
off);
+	ret =3D dax_pgoff(get_start_sect(lc->dev->bdev), sector,
+			nr_pages * PAGE_SIZE, &pgoff);
 	if (ret)
 		return ret;
 	return dax_direct_access(lc->dev->dax_dev, pgoff, nr_pages, kaddr, pfn)=
;
@@ -966,7 +967,8 @@ static size_t log_writes_dax_copy_from_iter(struct dm=
_target *ti,
 	sector_t sector =3D pgoff * PAGE_SECTORS;
 	int err;
=20
-	if (bdev_dax_pgoff(lc->dev->bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgo=
ff))
+	if (dax_pgoff(get_start_sect(lc->dev->bdev), sector,
+		      ALIGN(bytes, PAGE_SIZE), &pgoff))
 		return 0;
=20
 	/* Don't bother doing anything if logging has been disabled */
@@ -989,7 +991,8 @@ static size_t log_writes_dax_copy_to_iter(struct dm_t=
arget *ti,
 	struct log_writes_c *lc =3D ti->private;
 	sector_t sector =3D pgoff * PAGE_SECTORS;
=20
-	if (bdev_dax_pgoff(lc->dev->bdev, sector, ALIGN(bytes, PAGE_SIZE), &pgo=
ff))
+	if (dax_pgoff(get_start_sect(lc->dev->bdev), sector,
+		      ALIGN(bytes, PAGE_SIZE), &pgoff))
 		return 0;
 	return dax_copy_to_iter(lc->dev->dax_dev, pgoff, addr, bytes, i);
 }
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 63bbcc20f49a..337cdc6e0951 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -316,7 +316,8 @@ static long stripe_dax_direct_access(struct dm_target=
 *ti, pgoff_t pgoff,
 	dax_dev =3D sc->stripe[stripe].dev->dax_dev;
 	bdev =3D sc->stripe[stripe].dev->bdev;
=20
-	ret =3D bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
+	ret =3D dax_pgoff(get_start_sect(bdev), dev_sector, nr_pages * PAGE_SIZ=
E,
+			&pgoff);
 	if (ret)
 		return ret;
 	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
@@ -336,7 +337,7 @@ static size_t stripe_dax_copy_from_iter(struct dm_tar=
get *ti, pgoff_t pgoff,
 	dax_dev =3D sc->stripe[stripe].dev->dax_dev;
 	bdev =3D sc->stripe[stripe].dev->bdev;
=20
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+	if (dax_pgoff(get_start_sect(bdev), dev_sector, ALIGN(bytes, PAGE_SIZE)=
,		      &pgoff))
 		return 0;
 	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
 }
@@ -355,7 +356,8 @@ static size_t stripe_dax_copy_to_iter(struct dm_targe=
t *ti, pgoff_t pgoff,
 	dax_dev =3D sc->stripe[stripe].dev->dax_dev;
 	bdev =3D sc->stripe[stripe].dev->bdev;
=20
-	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+	if (dax_pgoff(get_start_sect(bdev), dev_sector, ALIGN(bytes, PAGE_SIZE)=
,
+		      &pgoff))
 		return 0;
 	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
 }
--=20
2.20.1
