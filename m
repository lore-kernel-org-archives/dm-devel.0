From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v5 4/8] dax, pmem: Add a dax operation zero_page_range
Date: Tue, 18 Feb 2020 16:48:37 -0500
Message-ID: <20200218214841.10076-5-vgoyal@redhat.com>
References: <20200218214841.10076-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200218214841.10076-1-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com
Cc: dm-devel@redhat.com, vishal.l.verma@intel.com, vgoyal@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Add a dax operation zero_page_range, to zero a range of memory. This will
also clear any poison in the range being zeroed.

As of now, zeroing of up to one page is allowed in a single call. There
are no callers which are trying to zero more than a page in a single call=
.
Once we grow the callers which zero more than a page in single call, we
can add that support. Primary reason for not doing that yet is that this
will add little complexity in dm implementation where a range might be
spanning multiple underlying targets and one will have to split the range
into multiple sub ranges and call zero_page_range() on individual targets=
.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/dax/super.c   | 19 +++++++++++++++++++
 drivers/nvdimm/pmem.c | 10 ++++++++++
 include/linux/dax.h   |  3 +++
 3 files changed, 32 insertions(+)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0aa4b6bc5101..c912808bc886 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -344,6 +344,25 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, =
pgoff_t pgoff, void *addr,
 }
 EXPORT_SYMBOL_GPL(dax_copy_to_iter);
=20
+int dax_zero_page_range(struct dax_device *dax_dev, u64 offset, size_t l=
en)
+{
+	if (!dax_alive(dax_dev))
+		return -ENXIO;
+
+	if (!dax_dev->ops->zero_page_range)
+		return -EOPNOTSUPP;
+	/*
+	 * There are no callers that want to zero across a page boundary as of
+	 * now. Once users are there, this check can be removed after the
+	 * device mapper code has been updated to split ranges across targets.
+	 */
+	if (offset_in_page(offset) + len > PAGE_SIZE)
+		return -EIO;
+
+	return dax_dev->ops->zero_page_range(dax_dev, offset, len);
+}
+EXPORT_SYMBOL_GPL(dax_zero_page_range);
+
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 void arch_wb_cache_pmem(void *addr, size_t size);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3c46e9e6d04c..e17f9f56d6fe 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -304,6 +304,15 @@ static const struct block_device_operations pmem_fop=
s =3D {
 	.revalidate_disk =3D	nvdimm_revalidate_disk,
 };
=20
+static int pmem_dax_zero_page_range(struct dax_device *dax_dev, u64 offs=
et,
+				    size_t len)
+{
+	struct pmem_device *pmem =3D dax_get_private(dax_dev);
+
+	return blk_status_to_errno(pmem_do_write(pmem, ZERO_PAGE(0), 0, offset,
+				   len));
+}
+
 static long pmem_dax_direct_access(struct dax_device *dax_dev,
 		pgoff_t pgoff, long nr_pages, void **kaddr, pfn_t *pfn)
 {
@@ -335,6 +344,7 @@ static const struct dax_operations pmem_dax_ops =3D {
 	.dax_supported =3D generic_fsdax_supported,
 	.copy_from_iter =3D pmem_copy_from_iter,
 	.copy_to_iter =3D pmem_copy_to_iter,
+	.zero_page_range =3D pmem_dax_zero_page_range,
 };
=20
 static const struct attribute_group *pmem_attribute_groups[] =3D {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 328c2dbb4409..93a663c26d6a 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -34,6 +34,8 @@ struct dax_operations {
 	/* copy_to_iter: required operation for fs-dax direct-i/o */
 	size_t (*copy_to_iter)(struct dax_device *, pgoff_t, void *, size_t,
 			struct iov_iter *);
+	/* zero_page_range: required operation. Zero range with-in a page  */
+	int (*zero_page_range)(struct dax_device *, u64, size_t);
 };
=20
 extern struct attribute_group dax_attribute_group;
@@ -199,6 +201,7 @@ size_t dax_copy_from_iter(struct dax_device *dax_dev,=
 pgoff_t pgoff, void *addr,
 		size_t bytes, struct iov_iter *i);
 size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void =
*addr,
 		size_t bytes, struct iov_iter *i);
+int dax_zero_page_range(struct dax_device *dax_dev, u64 offset, size_t l=
en);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
=20
 ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
--=20
2.20.1
