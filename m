From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/6] dax: Define a helper dax_pgoff() which takes in dax_offset as argument
Date: Wed, 12 Feb 2020 12:07:28 -0500
Message-ID: <20200212170733.8092-2-vgoyal@redhat.com>
References: <20200212170733.8092-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200212170733.8092-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

Create a new helper dax_pgoff() which will replace bdev_dax_pgoff(). Diff=
erence
between two is that dax_pgoff() takes in "sector_t dax_offset" as an argu=
ment
instead of "struct block_device".

dax_offset specifies any offset into dax device which should be added to
sector while calculating pgoff.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/dax/super.c | 12 ++++++++++++
 include/linux/dax.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0aa4b6bc5101..e9daa30e4250 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -56,6 +56,18 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t=
 sector, size_t size,
 }
 EXPORT_SYMBOL(bdev_dax_pgoff);
=20
+int dax_pgoff(sector_t dax_offset, sector_t sector, size_t size, pgoff_t=
 *pgoff)
+{
+	phys_addr_t phys_off =3D (dax_offset + sector) * 512;
+
+	if (pgoff)
+		*pgoff =3D PHYS_PFN(phys_off);
+	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL(dax_pgoff);
+
 #if IS_ENABLED(CONFIG_FS_DAX)
 struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 328c2dbb4409..5101a4b5c1f9 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -111,6 +111,7 @@ static inline bool daxdev_mapping_supported(struct vm=
_area_struct *vma,
=20
 struct writeback_control;
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgo=
ff);
+int dax_pgoff(sector_t dax_offset, sector_t, size_t, pgoff_t *pgoff);
 #if IS_ENABLED(CONFIG_FS_DAX)
 bool __bdev_dax_supported(struct block_device *bdev, int blocksize);
 static inline bool bdev_dax_supported(struct block_device *bdev, int blo=
cksize)
--=20
2.20.1
