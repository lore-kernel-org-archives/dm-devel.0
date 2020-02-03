From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/5] s390,dax: Add dax zero_page_range operation to dcssblk driver
Date: Mon,  3 Feb 2020 15:00:26 -0500
Message-ID: <20200203200029.4592-3-vgoyal@redhat.com>
References: <20200203200029.4592-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200203200029.4592-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org
Cc: vgoyal@redhat.com, vishal.l.verma@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Add dax operation zero_page_range. This just calls generic helper
generic_dax_zero_page_range().

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/s390/block/dcssblk.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 63502ca537eb..f6709200bcd0 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -62,6 +62,7 @@ static const struct dax_operations dcssblk_dax_ops =3D =
{
 	.dax_supported =3D generic_fsdax_supported,
 	.copy_from_iter =3D dcssblk_dax_copy_from_iter,
 	.copy_to_iter =3D dcssblk_dax_copy_to_iter,
+	.zero_page_range =3D dcssblk_dax_zero_page_range,
 };
=20
 struct dcssblk_dev_info {
@@ -941,6 +942,12 @@ dcssblk_dax_direct_access(struct dax_device *dax_dev=
, pgoff_t pgoff,
 	return __dcssblk_direct_access(dev_info, pgoff, nr_pages, kaddr, pfn);
 }
=20
+static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev,pgoff_=
t pgoff,
+				       unsigned offset, size_t len)
+{
+	return generic_dax_zero_page_range(dax_dev, pgoff, offset, len);
+}
+
 static void
 dcssblk_check_params(void)
 {
--=20
2.18.1
