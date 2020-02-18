From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v5 7/8] dax,iomap: Start using dax native zero_page_range()
Date: Tue, 18 Feb 2020 16:48:40 -0500
Message-ID: <20200218214841.10076-8-vgoyal@redhat.com>
References: <20200218214841.10076-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200218214841.10076-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Get rid of calling block device interface for zeroing in iomap dax
zeroing path and use dax native zeroing interface instead.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c | 45 +++++++++------------------------------------
 1 file changed, 9 insertions(+), 36 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 35da144375a0..f8ae0a9984fa 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1038,48 +1038,21 @@ static vm_fault_t dax_load_hole(struct xa_state *=
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
-
-		return blkdev_issue_zeroout(bdev, start_sector,
-				size >> 9, GFP_NOFS, 0);
-	} else {
-		pgoff_t pgoff;
-		long rc, id;
-		void *kaddr;
+	pgoff_t pgoff;
+	long rc, id;
=20
-		rc =3D bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
-		if (rc)
-			return rc;
+	rc =3D bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
+	if (rc)
+		return rc;
=20
-		id =3D dax_read_lock();
-		rc =3D dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
-		if (rc < 0) {
-			dax_read_unlock(id);
-			return rc;
-		}
-		memset(kaddr + offset, 0, size);
-		dax_flush(dax_dev, kaddr + offset, size);
-		dax_read_unlock(id);
-	}
-	return 0;
+	id =3D dax_read_lock();
+	rc =3D dax_zero_page_range(dax_dev, (pgoff << PAGE_SHIFT) + offset, siz=
e);
+	dax_read_unlock(id);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
=20
--=20
2.20.1
