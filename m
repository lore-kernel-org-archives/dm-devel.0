From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v3 7/7] dax,iomap: Add helper dax_iomap_zero() to zero a range
Date: Fri,  7 Feb 2020 15:26:52 -0500
Message-ID: <20200207202652.1439-8-vgoyal@redhat.com>
References: <20200207202652.1439-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200207202652.1439-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Add a helper dax_ioamp_zero() to zero a range. This patch basically
merges __dax_zero_page_range() and iomap_dax_zero().

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c               | 12 ++++++------
 fs/iomap/buffered-io.c |  9 +--------
 include/linux/dax.h    | 17 +++--------------
 3 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6757e12b86b2..f6c4788ba764 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1044,23 +1044,23 @@ static vm_fault_t dax_load_hole(struct xa_state *=
xas,
 	return ret;
 }
=20
-int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int size)
+int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
+		   struct iomap *iomap)
 {
 	pgoff_t pgoff;
 	long rc, id;
+	sector_t sector =3D iomap_sector(iomap, pos & PAGE_MASK);
=20
-	rc =3D bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
+	rc =3D bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
 	if (rc)
 		return rc;
=20
 	id =3D dax_read_lock();
-	rc =3D dax_zero_page_range(dax_dev, (pgoff << PAGE_SHIFT) + offset, siz=
e);
+	rc =3D dax_zero_page_range(iomap->dax_dev, (pgoff << PAGE_SHIFT) + offs=
et,
+				 size);
 	dax_read_unlock(id);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(__dax_zero_page_range);
=20
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *da=
ta,
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 828444e14d09..5a5d784a110e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -974,13 +974,6 @@ static int iomap_zero(struct inode *inode, loff_t po=
s, unsigned offset,
 	return iomap_write_end(inode, pos, bytes, bytes, page, iomap, srcmap);
 }
=20
-static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
-		struct iomap *iomap)
-{
-	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
-			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
-}
-
 static loff_t
 iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 		void *data, struct iomap *iomap, struct iomap *srcmap)
@@ -1000,7 +993,7 @@ iomap_zero_range_actor(struct inode *inode, loff_t p=
os, loff_t count,
 		bytes =3D min_t(loff_t, PAGE_SIZE - offset, count);
=20
 		if (IS_DAX(inode))
-			status =3D iomap_dax_zero(pos, offset, bytes, iomap);
+			status =3D dax_iomap_zero(pos, offset, bytes, iomap);
 		else
 			status =3D iomap_zero(inode, pos, offset, bytes, iomap,
 					srcmap);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a555f0aeb7bd..31d0e6fc3023 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -13,6 +13,7 @@
 typedef unsigned long dax_entry_t;
=20
 struct iomap_ops;
+struct iomap;
 struct dax_device;
 struct dax_operations {
 	/*
@@ -223,20 +224,8 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vm=
f,
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t inde=
x);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
-
-#ifdef CONFIG_FS_DAX
-int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int length);
-#else
-static inline int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int length)
-{
-	return -ENXIO;
-}
-#endif
-
+int dax_iomap_zero(loff_t pos, unsigned offset, unsigned size,
+			struct iomap *iomap);
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
--=20
2.20.1
