From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v3 2/7] pmem: Enable pmem_do_write() to deal with arbitrary ranges
Date: Fri,  7 Feb 2020 15:26:47 -0500
Message-ID: <20200207202652.1439-3-vgoyal@redhat.com>
References: <20200207202652.1439-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200207202652.1439-1-vgoyal@redhat.com>
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
 drivers/nvdimm/pmem.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 9ad07cb8c9fc..281fe04d25fd 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -154,15 +154,23 @@ static blk_status_t pmem_do_read(struct pmem_device=
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
+		if (unlikely(is_bad_pmem(&pmem->bb, sector_start,
+					 nr_sectors << SECTOR_SHIFT)))
+			bad_pmem =3D true;
+	}
=20
 	/*
 	 * Note that we write the data both before and after
@@ -181,7 +189,13 @@ static blk_status_t pmem_do_write(struct pmem_device=
 *pmem,
 	flush_dcache_page(page);
 	write_pmem(pmem_addr, page, page_off, len);
 	if (unlikely(bad_pmem)) {
-		rc =3D pmem_clear_poison(pmem, pmem_off, len);
+		/*
+		 * Pass sector aligned offset and length. That seems
+		 * to work as of now. Other finer grained alignment
+		 * cases can be addressed later if need be.
+		 */
+		rc =3D pmem_clear_poison(pmem, ALIGN(pmem_real_off, SECTOR_SIZE),
+				       nr_sectors << SECTOR_SHIFT);
 		write_pmem(pmem_addr, page, page_off, len);
 	}
=20
@@ -195,7 +209,7 @@ static blk_status_t pmem_do_bvec(struct pmem_device *=
pmem, struct page *page,
 	if (!op_is_write(op))
 		return pmem_do_read(pmem, page, off, sector, len);
=20
-	return pmem_do_write(pmem, page, off, sector, len);
+	return pmem_do_write(pmem, page, off, sector << SECTOR_SHIFT, len);
 }
=20
 static blk_qc_t pmem_make_request(struct request_queue *q, struct bio *b=
io)
--=20
2.20.1
