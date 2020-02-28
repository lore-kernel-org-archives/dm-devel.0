From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 3/6] s390,dcssblk,dax: Add dax zero_page_range operation to dcssblk driver
Date: Fri, 28 Feb 2020 11:34:53 -0500
Message-ID: <20200228163456.1587-4-vgoyal@redhat.com>
References: <20200228163456.1587-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200228163456.1587-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: vgoyal@redhat.com, david@fromorbit.com, jmoyer@redhat.com, dm-devel@redhat.com, linux-s390@vger.kernel.org, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-Id: dm-devel.ids

Add dax operation zero_page_range for dcssblk driver.

CC: linux-s390@vger.kernel.org
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/s390/block/dcssblk.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 63502ca537eb..ab3e2898816c 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -57,11 +57,26 @@ static size_t dcssblk_dax_copy_to_iter(struct dax_dev=
ice *dax_dev,
 	return copy_to_iter(addr, bytes, i);
 }
=20
+static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev,
+				       pgoff_t pgoff, size_t nr_pages)
+{
+	long rc;
+	void *kaddr;
+
+	rc =3D dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
+	if (rc < 0)
+		return rc;
+	memset(kaddr, 0, nr_pages << PAGE_SHIFT);
+	dax_flush(dax_dev, kaddr, nr_pages << PAGE_SHIFT);
+	return 0;
+}
+
 static const struct dax_operations dcssblk_dax_ops =3D {
 	.direct_access =3D dcssblk_dax_direct_access,
 	.dax_supported =3D generic_fsdax_supported,
 	.copy_from_iter =3D dcssblk_dax_copy_from_iter,
 	.copy_to_iter =3D dcssblk_dax_copy_to_iter,
+	.zero_page_range =3D dcssblk_dax_zero_page_range,
 };
=20
 struct dcssblk_dev_info {
--=20
2.20.1
