From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept arbitrary offset and len
Date: Tue, 18 Feb 2020 16:48:35 -0500
Message-ID: <20200218214841.10076-3-vgoyal@redhat.com>
References: <20200218214841.10076-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200218214841.10076-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Currently pmem_clear_poison() expects offset and len to be sector aligned=
.
Atleast that seems to be the assumption with which code has been written.
It is called only from pmem_do_bvec() which is called only from pmem_rw_p=
age()
and pmem_make_request() which will only passe sector aligned offset and l=
en.

Soon we want use this function from dax_zero_page_range() code path which
can try to zero arbitrary range of memory with-in a page. So update this
function to assume that offset and length can be arbitrary and do the
necessary alignments as needed.

nvdimm_clear_poison() seems to assume offset and len to be aligned to
clear_err_unit boundary. But this is currently internal detail and is
not exported for others to use. So for now, continue to align offset and
length to SECTOR_SIZE boundary. Improving it further and to align it
to clear_err_unit boundary is a TODO item for future.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/nvdimm/pmem.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 075b11682192..e72959203253 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -74,14 +74,28 @@ static blk_status_t pmem_clear_poison(struct pmem_dev=
ice *pmem,
 	sector_t sector;
 	long cleared;
 	blk_status_t rc =3D BLK_STS_OK;
+	phys_addr_t start_aligned, end_aligned;
+	unsigned int len_aligned;
=20
-	sector =3D (offset - pmem->data_offset) / 512;
+	/*
+	 * Callers can pass arbitrary offset and len. But nvdimm_clear_poison()
+	 * expects memory offset and length to meet certain alignment
+	 * restrction (clear_err_unit). Currently nvdimm does not export
+	 * required alignment. So align offset and length to sector boundary
+	 * before passing it to nvdimm_clear_poison().
+	 */
+	start_aligned =3D ALIGN(offset, SECTOR_SIZE);
+	end_aligned =3D ALIGN_DOWN((offset + len), SECTOR_SIZE) - 1;
+	len_aligned =3D end_aligned - start_aligned + 1;
+
+	sector =3D (start_aligned - pmem->data_offset) / 512;
=20
-	cleared =3D nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
-	if (cleared < len)
+	cleared =3D nvdimm_clear_poison(dev, pmem->phys_addr + start_aligned,
+				      len_aligned);
+	if (cleared < len_aligned)
 		rc =3D BLK_STS_IOERR;
 	if (cleared > 0 && cleared / 512) {
-		hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
+		hwpoison_clear(pmem, pmem->phys_addr + start_aligned, cleared);
 		cleared /=3D 512;
 		dev_dbg(dev, "%#llx clear %ld sector%s\n",
 				(unsigned long long) sector, cleared,
--=20
2.20.1
