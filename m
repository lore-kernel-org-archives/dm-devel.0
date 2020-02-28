From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 5/6] dax: Use new dax zero page method for zeroing a page
Date: Fri, 28 Feb 2020 11:34:55 -0500
Message-ID: <20200228163456.1587-6-vgoyal@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200228163456.1587-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: vgoyal@redhat.com, david@fromorbit.com, jmoyer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Use new dax native zero page method for zeroing page if I/O is page
aligned. Otherwise fall back to direct_access() + memcpy().

This gets rid of one of the depenendency on block device in dax path.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c | 53 +++++++++++++++++++++++------------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 35da144375a0..98ba3756163a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1038,47 +1038,40 @@ static vm_fault_t dax_load_hole(struct xa_state *=
xas,
 	return ret;
 }
=20
-static bool dax_range_is_aligned(struct block_device *bdev,
-				 unsigned int offset, unsigned int length)
-{
-	unsigned short sector_size =3D bdev_logical_block_size(bdev);
-
-	if (!IS_ALIGNED(offset, sector_size))
-		return false;
-	if (!IS_ALIGNED(length, sector_size))
-		return false;
-
-	return true;
-}
-
 int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
 		unsigned int offset, unsigned int size)
 {
-	if (dax_range_is_aligned(bdev, offset, size)) {
-		sector_t start_sector =3D sector + (offset >> 9);
+	pgoff_t pgoff;
+	long rc, id;
+	void *kaddr;
+	bool page_aligned =3D false;
=20
-		return blkdev_issue_zeroout(bdev, start_sector,
-				size >> 9, GFP_NOFS, 0);
-	} else {
-		pgoff_t pgoff;
-		long rc, id;
-		void *kaddr;
=20
-		rc =3D bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
-		if (rc)
-			return rc;
+	if (IS_ALIGNED(sector << SECTOR_SHIFT, PAGE_SIZE) &&
+	    IS_ALIGNED(size, PAGE_SIZE))
+		page_aligned =3D true;
+
+	rc =3D bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
+	if (rc)
+		return rc;
=20
-		id =3D dax_read_lock();
+	id =3D dax_read_lock();
+
+	if (page_aligned)
+		rc =3D dax_zero_page_range(dax_dev, pgoff, size >> PAGE_SHIFT);
+	else
 		rc =3D dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
-		if (rc < 0) {
-			dax_read_unlock(id);
-			return rc;
-		}
+	if (rc < 0) {
+		dax_read_unlock(id);
+		return rc;
+	}
+
+	if (!page_aligned) {
 		memset(kaddr + offset, 0, size);
 		dax_flush(dax_dev, kaddr + offset, size);
-		dax_read_unlock(id);
 	}
+	dax_read_unlock(id);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
--=20
2.20.1
