From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/6] fs/dax.c: Start using dax_pgoff() instead of bdev_dax_pgoff()
Date: Wed, 12 Feb 2020 12:07:30 -0500
Message-ID: <20200212170733.8092-4-vgoyal@redhat.com>
References: <20200212170733.8092-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200212170733.8092-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

Replace usage of bdev_dax_pgoff() with dax_pgoff() in fs/dax.c

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/dax.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 35da144375a0..921042a81538 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -680,7 +680,7 @@ int dax_invalidate_mapping_entry_sync(struct address_=
space *mapping,
 	return __dax_invalidate_entry(mapping, index, false);
 }
=20
-static int copy_user_dax(struct block_device *bdev, struct dax_device *d=
ax_dev,
+static int copy_user_dax(struct dax_device *dax_dev, sector_t dax_offset=
,
 		sector_t sector, size_t size, struct page *to,
 		unsigned long vaddr)
 {
@@ -689,7 +689,7 @@ static int copy_user_dax(struct block_device *bdev, s=
truct dax_device *dax_dev,
 	long rc;
 	int id;
=20
-	rc =3D bdev_dax_pgoff(bdev, sector, size, &pgoff);
+	rc =3D dax_pgoff(dax_offset, sector, size, &pgoff);
 	if (rc)
 		return rc;
=20
@@ -990,7 +990,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t =
pos, size_t size,
 	int id, rc;
 	long length;
=20
-	rc =3D bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
+	rc =3D dax_pgoff(iomap->dax_offset, sector, size, &pgoff);
 	if (rc)
 		return rc;
 	id =3D dax_read_lock();
@@ -1065,7 +1065,7 @@ int __dax_zero_page_range(struct block_device *bdev=
,
 		long rc, id;
 		void *kaddr;
=20
-		rc =3D bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
+		rc =3D dax_pgoff(get_start_sect(bdev), sector, PAGE_SIZE, &pgoff);
 		if (rc)
 			return rc;
=20
@@ -1087,7 +1087,6 @@ static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *da=
ta,
 		struct iomap *iomap, struct iomap *srcmap)
 {
-	struct block_device *bdev =3D iomap->bdev;
 	struct dax_device *dax_dev =3D iomap->dax_dev;
 	struct iov_iter *iter =3D data;
 	loff_t end =3D pos + length, done =3D 0;
@@ -1132,7 +1131,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, lo=
ff_t length, void *data,
 			break;
 		}
=20
-		ret =3D bdev_dax_pgoff(bdev, sector, size, &pgoff);
+		ret =3D dax_pgoff(iomap->dax_offset, sector, size, &pgoff);
 		if (ret)
 			break;
=20
@@ -1312,7 +1311,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fau=
lt *vmf, pfn_t *pfnp,
 			clear_user_highpage(vmf->cow_page, vaddr);
 			break;
 		case IOMAP_MAPPED:
-			error =3D copy_user_dax(iomap.bdev, iomap.dax_dev,
+			error =3D copy_user_dax(iomap.dax_dev, iomap.dax_offset,
 					sector, PAGE_SIZE, vmf->cow_page, vaddr);
 			break;
 		default:
--=20
2.20.1
