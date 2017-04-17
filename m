From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [resend PATCH v2 18/33] x86, dax,
 pmem: remove indirection around memcpy_from_pmem()
Date: Mon, 17 Apr 2017 12:10:27 -0700
Message-ID: <149245622727.10206.9207175325089032123.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

memcpy_from_pmem() maps directly to memcpy_mcsafe(). The wrapper
serves no real benefit aside from affording a more generic function name
than the x86-specific 'mcsafe'. However this would not be the first time
that x86 terminology leaked into the global namespace. For lack of
better name, just use memcpy_mcsafe() directly.

This conversion also catches a place where we should have been using
plain memcpy, acpi_nfit_blk_single_io().

Cc: <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/pmem.h      |    5 -----
 arch/x86/include/asm/string_64.h |    1 +
 drivers/acpi/nfit/core.c         |    3 +--
 drivers/nvdimm/claim.c           |    2 +-
 drivers/nvdimm/pmem.c            |    2 +-
 include/linux/pmem.h             |   23 -----------------------
 include/linux/string.h           |    8 ++++++++
 7 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 529bb4a6487a..d5a22bac9988 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -44,11 +44,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 		BUG();
 }
 
-static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
-{
-	return memcpy_mcsafe(dst, src, n);
-}
-
 /**
  * arch_wb_cache_pmem - write back a cache range with CLWB
  * @vaddr:	virtual start address
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index a164862d77e3..733bae07fb29 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -79,6 +79,7 @@ int strcmp(const char *cs, const char *ct);
 #define memset(s, c, n) __memset(s, c, n)
 #endif
 
+#define __HAVE_ARCH_MEMCPY_MCSAFE 1
 __must_check int memcpy_mcsafe_unrolled(void *dst, const void *src, size_t cnt);
 DECLARE_STATIC_KEY_FALSE(mcsafe_key);
 
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index c8ea9d698cd0..d0c07b2344e4 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1783,8 +1783,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 				mmio_flush_range((void __force *)
 					mmio->addr.aperture + offset, c);
 
-			memcpy_from_pmem(iobuf + copied,
-					mmio->addr.aperture + offset, c);
+			memcpy(iobuf + copied, mmio->addr.aperture + offset, c);
 		}
 
 		copied += c;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index ca6d572c48fc..3a35e8028b9c 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -239,7 +239,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	if (rw == READ) {
 		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
 			return -EIO;
-		return memcpy_from_pmem(buf, nsio->addr + offset, size);
+		return memcpy_mcsafe(buf, nsio->addr + offset, size);
 	}
 
 	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 85b85633d674..3b3dab73d741 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -89,7 +89,7 @@ static int read_pmem(struct page *page, unsigned int off,
 	int rc;
 	void *mem = kmap_atomic(page);
 
-	rc = memcpy_from_pmem(mem + off, pmem_addr, len);
+	rc = memcpy_mcsafe(mem + off, pmem_addr, len);
 	kunmap_atomic(mem);
 	if (rc)
 		return -EIO;
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index e856c2cb0fe8..71ecf3d46aac 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -31,12 +31,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 	BUG();
 }
 
-static inline int arch_memcpy_from_pmem(void *dst, const void *src, size_t n)
-{
-	BUG();
-	return -EFAULT;
-}
-
 static inline size_t arch_copy_from_iter_pmem(void *addr, size_t bytes,
 		struct iov_iter *i)
 {
@@ -65,23 +59,6 @@ static inline bool arch_has_pmem_api(void)
 	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API);
 }
 
-/*
- * memcpy_from_pmem - read from persistent memory with error handling
- * @dst: destination buffer
- * @src: source buffer
- * @size: transfer length
- *
- * Returns 0 on success negative error code on failure.
- */
-static inline int memcpy_from_pmem(void *dst, void const *src, size_t size)
-{
-	if (arch_has_pmem_api())
-		return arch_memcpy_from_pmem(dst, src, size);
-	else
-		memcpy(dst, src, size);
-	return 0;
-}
-
 /**
  * memcpy_to_pmem - copy data to persistent memory
  * @dst: destination buffer for the copy
diff --git a/include/linux/string.h b/include/linux/string.h
index 26b6f6a66f83..9d6f189157e2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -114,6 +114,14 @@ extern int memcmp(const void *,const void *,__kernel_size_t);
 #ifndef __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
+#ifndef __HAVE_ARCH_MEMCPY_MCSAFE
+static inline __must_check int memcpy_mcsafe(void *dst, const void *src,
+		size_t cnt)
+{
+	memcpy(dst, src, cnt);
+	return 0;
+}
+#endif
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *s, char old, char new);
