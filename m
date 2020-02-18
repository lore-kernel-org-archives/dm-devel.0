From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v5 3/8] pmem: Enable pmem_do_write() to deal with arbitrary ranges
Date: Tue, 18 Feb 2020 16:48:36 -0500
Message-ID: <20200218214841.10076-4-vgoyal@redhat.com>
References: <20200218214841.10076-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200218214841.10076-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Currently pmem_do_write() is written with assumption that all I/O is
sector aligned. Soon I want to use this function in zero_page_range()
where range passed in does not have to be sector aligned.

Modify this function to be able to deal with an arbitrary range. Which
is specified by pmem_off and len.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/nvdimm/pmem.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index e72959203253..3c46e9e6d04c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -168,15 +168,23 @@ static blk_status_t pmem_do_read(struct pmem_device=
 *pmem,
=20
 static blk_status_t pmem_do_write(struct pmem_device *pmem,
 			struct page *page, unsigned int page_off,
-			sector_t sector, unsigned int len)
+			u64 pmem_off, unsigned int len)
 {
 	blk_status_t rc =3D BLK_STS_OK;
 	bool bad_pmem =3D false;
-	phys_addr_t pmem_off =3D sector * 512 + pmem->data_offset;
-	void *pmem_addr =3D pmem->virt_addr + pmem_off;
-
-	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
-		bad_pmem =3D true;
+	phys_addr_t pmem_real_off =3D pmem_off + pmem->data_offset;
+	void *pmem_addr =3D pmem->virt_addr + pmem_real_off;
+	sector_t sector_start, sector_end;
+	unsigned nr_sectors;
+
+	sector_start =3D DIV_ROUND_UP(pmem_off, SECTOR_SIZE);
+	sector_end =3D (pmem_off + len) >> SECTOR_SHIFT;
+	if (sector_end > sector_start) {
+		nr_sectors =3D sector_end - sector_start;
+		if (is_bad_pmem(&pmem->bb, sector_start,
+				nr_sectors << SECTOR_SHIFT))
+			bad_pmem =3D true;
+	}
=20
 	/*
 	 * Note that we write the data both before and after
@@ -195,7 +203,7 @@ static blk_status_t pmem_do_write(struct pmem_device =
*pmem,
 	flush_dcache_page(page);
 	write_pmem(pmem_addr, page, page_off, len);
 	if (unlikely(bad_pmem)) {
-		rc =3D pmem_clear_poison(pmem, pmem_off, len);
+		rc =3D pmem_clear_poison(pmem, pmem_real_off, len);
 		write_pmem(pmem_addr, page, page_off, len);
 	}
=20
@@ -220,7 +228,7 @@ static blk_qc_t pmem_make_request(struct request_queu=
e *q, struct bio *bio)
 	bio_for_each_segment(bvec, bio, iter) {
 		if (op_is_write(bio_op(bio)))
 			rc =3D pmem_do_write(pmem, bvec.bv_page, bvec.bv_offset,
-				iter.bi_sector, bvec.bv_len);
+				iter.bi_sector << SECTOR_SHIFT, bvec.bv_len);
 		else
 			rc =3D pmem_do_read(pmem, bvec.bv_page, bvec.bv_offset,
 				iter.bi_sector, bvec.bv_len);
@@ -249,7 +257,7 @@ static int pmem_rw_page(struct block_device *bdev, se=
ctor_t sector,
 	blk_status_t rc;
=20
 	if (op_is_write(op))
-		rc =3D pmem_do_write(pmem, page, 0, sector,
+		rc =3D pmem_do_write(pmem, page, 0, sector << SECTOR_SHIFT,
 				   hpage_nr_pages(page) * PAGE_SIZE);
 	else
 		rc =3D pmem_do_read(pmem, page, 0, sector,
--=20
2.20.1
