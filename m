From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 1/6] pmem: Add functions for reading/writing page to/from pmem
Date: Fri, 28 Feb 2020 11:34:51 -0500
Message-ID: <20200228163456.1587-2-vgoyal@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200228163456.1587-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: vgoyal@redhat.com, david@fromorbit.com, jmoyer@redhat.com, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

This splits pmem_do_bvec() into pmem_do_read() and pmem_do_write().
pmem_do_write() will be used by pmem zero_page_range() as well. Hence
sharing the same code.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/nvdimm/pmem.c | 86 +++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4eae441f86c9..075b11682192 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -136,9 +136,25 @@ static blk_status_t read_pmem(struct page *page, uns=
igned int off,
 	return BLK_STS_OK;
 }
=20
-static blk_status_t pmem_do_bvec(struct pmem_device *pmem, struct page *=
page,
-			unsigned int len, unsigned int off, unsigned int op,
-			sector_t sector)
+static blk_status_t pmem_do_read(struct pmem_device *pmem,
+			struct page *page, unsigned int page_off,
+			sector_t sector, unsigned int len)
+{
+	blk_status_t rc;
+	phys_addr_t pmem_off =3D sector * 512 + pmem->data_offset;
+	void *pmem_addr =3D pmem->virt_addr + pmem_off;
+
+	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
+		return BLK_STS_IOERR;
+
+	rc =3D read_pmem(page, page_off, pmem_addr, len);
+	flush_dcache_page(page);
+	return rc;
+}
+
+static blk_status_t pmem_do_write(struct pmem_device *pmem,
+			struct page *page, unsigned int page_off,
+			sector_t sector, unsigned int len)
 {
 	blk_status_t rc =3D BLK_STS_OK;
 	bool bad_pmem =3D false;
@@ -148,34 +164,25 @@ static blk_status_t pmem_do_bvec(struct pmem_device=
 *pmem, struct page *page,
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
 		bad_pmem =3D true;
=20
-	if (!op_is_write(op)) {
-		if (unlikely(bad_pmem))
-			rc =3D BLK_STS_IOERR;
-		else {
-			rc =3D read_pmem(page, off, pmem_addr, len);
-			flush_dcache_page(page);
-		}
-	} else {
-		/*
-		 * Note that we write the data both before and after
-		 * clearing poison.  The write before clear poison
-		 * handles situations where the latest written data is
-		 * preserved and the clear poison operation simply marks
-		 * the address range as valid without changing the data.
-		 * In this case application software can assume that an
-		 * interrupted write will either return the new good
-		 * data or an error.
-		 *
-		 * However, if pmem_clear_poison() leaves the data in an
-		 * indeterminate state we need to perform the write
-		 * after clear poison.
-		 */
-		flush_dcache_page(page);
-		write_pmem(pmem_addr, page, off, len);
-		if (unlikely(bad_pmem)) {
-			rc =3D pmem_clear_poison(pmem, pmem_off, len);
-			write_pmem(pmem_addr, page, off, len);
-		}
+	/*
+	 * Note that we write the data both before and after
+	 * clearing poison.  The write before clear poison
+	 * handles situations where the latest written data is
+	 * preserved and the clear poison operation simply marks
+	 * the address range as valid without changing the data.
+	 * In this case application software can assume that an
+	 * interrupted write will either return the new good
+	 * data or an error.
+	 *
+	 * However, if pmem_clear_poison() leaves the data in an
+	 * indeterminate state we need to perform the write
+	 * after clear poison.
+	 */
+	flush_dcache_page(page);
+	write_pmem(pmem_addr, page, page_off, len);
+	if (unlikely(bad_pmem)) {
+		rc =3D pmem_clear_poison(pmem, pmem_off, len);
+		write_pmem(pmem_addr, page, page_off, len);
 	}
=20
 	return rc;
@@ -197,8 +204,12 @@ static blk_qc_t pmem_make_request(struct request_que=
ue *q, struct bio *bio)
=20
 	do_acct =3D nd_iostat_start(bio, &start);
 	bio_for_each_segment(bvec, bio, iter) {
-		rc =3D pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len,
-				bvec.bv_offset, bio_op(bio), iter.bi_sector);
+		if (op_is_write(bio_op(bio)))
+			rc =3D pmem_do_write(pmem, bvec.bv_page, bvec.bv_offset,
+				iter.bi_sector, bvec.bv_len);
+		else
+			rc =3D pmem_do_read(pmem, bvec.bv_page, bvec.bv_offset,
+				iter.bi_sector, bvec.bv_len);
 		if (rc) {
 			bio->bi_status =3D rc;
 			break;
@@ -223,9 +234,12 @@ static int pmem_rw_page(struct block_device *bdev, s=
ector_t sector,
 	struct pmem_device *pmem =3D bdev->bd_queue->queuedata;
 	blk_status_t rc;
=20
-	rc =3D pmem_do_bvec(pmem, page, hpage_nr_pages(page) * PAGE_SIZE,
-			  0, op, sector);
-
+	if (op_is_write(op))
+		rc =3D pmem_do_write(pmem, page, 0, sector,
+				   hpage_nr_pages(page) * PAGE_SIZE);
+	else
+		rc =3D pmem_do_read(pmem, page, 0, sector,
+				   hpage_nr_pages(page) * PAGE_SIZE);
 	/*
 	 * The ->rw_page interface is subtle and tricky.  The core
 	 * retries on any error, so we can only invoke page_endio() in
--=20
2.20.1
