From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 12/12] block, libnvdimm,
 nvme: provide a built-in blk_integrity nop profile
Date: Thu, 15 Oct 2015 16:00:45 -0400
Message-ID: <20151015200045.20721.42806.stgit@dwillia2-desk3.jf.intel.com>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: axboe@fb.com, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Matthew Wilcox <willy@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

The libnvidmm-btt and nvme drivers use blk_integrity to reserve space
for per-sector metadata, but sometimes without protection checksums.
This property is generically useful, so teach the block core to
internally specify a nop profile if one is not provided at registration
time.

Cc: Keith Busch <keith.busch@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
[hch: kill the local nvme nop profile as well]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-integrity.c   |   13 ++++++++++++-
 drivers/nvdimm/core.c   |   12 +-----------
 drivers/nvme/host/pci.c |   18 +-----------------
 3 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index dc4dea7b8a93..506cc16c1a92 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -384,6 +384,17 @@ static struct kobj_type integrity_ktype = {
 	.sysfs_ops	= &integrity_ops,
 };
 
+static int blk_integrity_nop_fn(struct blk_integrity_iter *iter)
+{
+	return 0;
+}
+
+static struct blk_integrity_profile nop_profile = {
+	.name = "nop",
+	.generate_fn = blk_integrity_nop_fn,
+	.verify_fn = blk_integrity_nop_fn,
+};
+
 /**
  * blk_integrity_register - Register a request_queue as being integrity-capable
  * @disk:	struct request_queue pointer to make integrity-aware
@@ -402,7 +413,7 @@ void blk_integrity_register(struct request_queue *q, struct blk_integrity *templ
 	bi->flags = BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE |
 		template->flags;
 	bi->interval_exp = ilog2(queue_logical_block_size(q));
-	bi->profile = template->profile;
+	bi->profile = template->profile ? template->profile : &nop_profile;
 	bi->tuple_size = template->tuple_size;
 	bi->tag_size = template->tag_size;
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index eeedd58bbcad..2ed3c934256f 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -392,24 +392,14 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 EXPORT_SYMBOL_GPL(nvdimm_bus_unregister);
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
-static int nd_pi_nop_generate_verify(struct blk_integrity_iter *iter)
-{
-	return 0;
-}
-
 int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
 {
 	struct blk_integrity bi;
-	static struct blk_integrity_profile profile = {
-		.name = "ND-PI-NOP",
-		.generate_fn = nd_pi_nop_generate_verify,
-		.verify_fn = nd_pi_nop_generate_verify,
-	};
 
 	if (meta_size == 0)
 		return 0;
 
-	bi.profile = &profile;
+	bi.profile = NULL;
 	bi.tuple_size = meta_size;
 	bi.tag_size = meta_size;
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e4a0cc7fb421..532b6a491fca 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -550,22 +550,6 @@ static void nvme_dif_remap(struct request *req,
 	kunmap_atomic(pmap);
 }
 
-static int nvme_noop_verify(struct blk_integrity_iter *iter)
-{
-	return 0;
-}
-
-static int nvme_noop_generate(struct blk_integrity_iter *iter)
-{
-	return 0;
-}
-
-struct blk_integrity_profile nvme_meta_noop = {
-	.name			= "NVME_META_NOOP",
-	.generate_fn		= nvme_noop_generate,
-	.verify_fn		= nvme_noop_verify,
-};
-
 static void nvme_init_integrity(struct nvme_ns *ns)
 {
 	struct blk_integrity integrity;
@@ -579,7 +563,7 @@ static void nvme_init_integrity(struct nvme_ns *ns)
 		integrity.profile = &t10_pi_type1_crc;
 		break;
 	default:
-		integrity.profile = &nvme_meta_noop;
+		integrity.profile = NULL;
 		break;
 	}
 	integrity.tuple_size = ns->ms;

