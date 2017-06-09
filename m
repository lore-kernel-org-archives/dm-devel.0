From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 09/14] x86, libnvdimm,
 pmem: move arch_invalidate_pmem() to libnvdimm
Date: Fri, 09 Jun 2017 13:24:35 -0700
Message-ID: <149703987543.20620.15705330305343743783.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149703982465.20620.14881139332926778446.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
List-Id: dm-devel.ids

Kill this globally defined wrapper and move to libnvdimm so that we can
ultimately remove include/linux/pmem.h.

Cc: <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/nvdimm/claim.c |    3 ++-
 drivers/nvdimm/pmem.c  |    2 +-
 drivers/nvdimm/pmem.h  |    3 +++
 include/linux/pmem.h   |   19 -------------------
 4 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index b8b9c8ca7862..d2e16c0401df 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -14,6 +14,7 @@
 #include <linux/sizes.h>
 #include <linux/pmem.h>
 #include "nd-core.h"
+#include "pmem.h"
 #include "pfn.h"
 #include "btt.h"
 #include "nd.h"
@@ -272,7 +273,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 				cleared /= 512;
 				badblocks_clear(&nsio->bb, sector, cleared);
 			}
-			invalidate_pmem(nsio->addr + offset, size);
+			arch_invalidate_pmem(nsio->addr + offset, size);
 		} else
 			rc = -EIO;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 3b87702d46bb..68737bc68a07 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -71,7 +71,7 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		badblocks_clear(&pmem->bb, sector, cleared);
 	}
 
-	invalidate_pmem(pmem->virt_addr + offset, len);
+	arch_invalidate_pmem(pmem->virt_addr + offset, len);
 
 	return rc;
 }
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 9137ec80b85f..d579c7095a45 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -10,6 +10,9 @@
 static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
 }
+static inline void arch_invalidate_pmem(void *addr, size_t size)
+{
+}
 #endif
 
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 33ae761f010a..559c00848583 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -30,11 +30,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 {
 	BUG();
 }
-
-static inline void arch_invalidate_pmem(void *addr, size_t size)
-{
-	BUG();
-}
 #endif
 
 static inline bool arch_has_pmem_api(void)
@@ -61,18 +56,4 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
 	else
 		memcpy(dst, src, n);
 }
-
-/**
- * invalidate_pmem - flush a pmem range from the cache hierarchy
- * @addr:	virtual start address
- * @size:	bytes to invalidate (internally aligned to cache line size)
- *
- * For platforms that support clearing poison this flushes any poisoned
- * ranges out of the cache
- */
-static inline void invalidate_pmem(void *addr, size_t size)
-{
-	if (arch_has_pmem_api())
-		arch_invalidate_pmem(addr, size);
-}
 #endif /* __PMEM_H__ */
