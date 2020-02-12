From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 6/6] dax: Remove bdev_dax_pgoff() helper
Date: Wed, 12 Feb 2020 12:07:33 -0500
Message-ID: <20200212170733.8092-7-vgoyal@redhat.com>
References: <20200212170733.8092-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200212170733.8092-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

Now there don't seem to be anyuser of bdev_dax_pgoff(). All users have be=
en
moved to dax_pgoff(). So remove this helper.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/dax/super.c | 13 -------------
 include/linux/dax.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ee35ecc61545..371e391e6b1e 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -43,19 +43,6 @@ EXPORT_SYMBOL_GPL(dax_read_unlock);
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
=20
-int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t si=
ze,
-		pgoff_t *pgoff)
-{
-	phys_addr_t phys_off =3D (get_start_sect(bdev) + sector) * 512;
-
-	if (pgoff)
-		*pgoff =3D PHYS_PFN(phys_off);
-	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
-		return -EINVAL;
-	return 0;
-}
-EXPORT_SYMBOL(bdev_dax_pgoff);
-
 int dax_pgoff(sector_t dax_offset, sector_t sector, size_t size, pgoff_t=
 *pgoff)
 {
 	phys_addr_t phys_off =3D (dax_offset + sector) * 512;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5101a4b5c1f9..84ed0e993190 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -110,7 +110,6 @@ static inline bool daxdev_mapping_supported(struct vm=
_area_struct *vma,
 #endif
=20
 struct writeback_control;
-int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgo=
ff);
 int dax_pgoff(sector_t dax_offset, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
 bool __bdev_dax_supported(struct block_device *bdev, int blocksize);
--=20
2.20.1
