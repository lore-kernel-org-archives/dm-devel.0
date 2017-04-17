From: Dan Williams <dan.j.williams@intel.com>
Subject: [resend PATCH v2 19/33] dax,
 pmem: introduce 'copy_from_iter' dax operation
Date: Mon, 17 Apr 2017 12:10:32 -0700
Message-ID: <149245623288.10206.11548740991639475206.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-nvdimm@ml01.01.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

The direct-I/O write path for a pmem device must ensure that data is
flushed to a power-fail safe zone when the operation is complete.
However, other dax capable block devices, like brd, do not have this
requirement.  Introduce a 'copy_from_iter' dax operation so that pmem
can inject cache management without imposing this overhead on other dax
capable block_device drivers.

This is also a first step of moving all architecture-specific
pmem-operations to the pmem driver.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h   |    3 +++
 2 files changed, 46 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3b3dab73d741..e501df4ab4b4 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -220,6 +220,48 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
 }
 
+static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
+		void *addr, size_t bytes, struct iov_iter *i)
+{
+	size_t len;
+
+	/* TODO: skip the write-back by always using non-temporal stores */
+	len = copy_from_iter_nocache(addr, bytes, i);
+
+	/*
+	 * In the iovec case on x86_64 copy_from_iter_nocache() uses
+	 * non-temporal stores for the bulk of the transfer, but we need
+	 * to manually flush if the transfer is unaligned. A cached
+	 * memory copy is used when destination or size is not naturally
+	 * aligned. That is:
+	 *   - Require 8-byte alignment when size is 8 bytes or larger.
+	 *   - Require 4-byte alignment when size is 4 bytes.
+	 *
+	 * In the non-iovec case the entire destination needs to be
+	 * flushed.
+	 */
+	if (iter_is_iovec(i)) {
+		unsigned long flushed, dest = (unsigned long) addr;
+
+		if (bytes < 8) {
+			if (!IS_ALIGNED(dest, 4) || (bytes != 4))
+				wb_cache_pmem(addr, 1);
+		} else {
+			if (!IS_ALIGNED(dest, 8)) {
+				dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
+				wb_cache_pmem(addr, 1);
+			}
+
+			flushed = dest - (unsigned long) addr;
+			if (bytes > flushed && !IS_ALIGNED(bytes - flushed, 8))
+				wb_cache_pmem(addr + bytes - 1, 1);
+		}
+	} else
+		wb_cache_pmem(addr, bytes);
+
+	return len;
+}
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
@@ -236,6 +278,7 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 
 static const struct dax_operations pmem_dax_ops = {
 	.direct_access = pmem_dax_direct_access,
+	.copy_from_iter = pmem_copy_from_iter,
 };
 
 static void pmem_release_queue(void *q)
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d3158e74a59e..156f067d4db5 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -16,6 +16,9 @@ struct dax_operations {
 	 */
 	long (*direct_access)(struct dax_device *, pgoff_t, long,
 			void **, pfn_t *);
+	/* copy_from_iter: dax-driver override for default copy_from_iter */
+	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
+			struct iov_iter *);
 };
 
 int dax_read_lock(void);
