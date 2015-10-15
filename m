From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 08/12] nvme: suspend i/o during runtime
 blk_integrity_unregister
Date: Thu, 15 Oct 2015 16:00:23 -0400
Message-ID: <20151015200023.20721.84329.stgit@dwillia2-desk3.jf.intel.com>
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

Synchronize pending i/o against a change in the integrity profile to
avoid the possibility of spurious integrity errors.

Cc: Matthew Wilcox <willy@linux.intel.com>
Acked-by: Keith Busch <keith.busch@intel.com>
[keith: also protect dynamic integrity registration]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 65190e51aa47..5578de67f406 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2033,6 +2033,7 @@ static int nvme_revalidate_disk(struct gendisk *disk)
 	pi_type = ns->ms == sizeof(struct t10_pi_tuple) ?
 					id->dps & NVME_NS_DPS_PI_MASK : 0;
 
+	blk_mq_freeze_queue(disk->queue);
 	if (blk_get_integrity(disk) && (ns->pi_type != pi_type ||
 				ns->ms != old_ms ||
 				bs != queue_logical_block_size(disk->queue) ||
@@ -2052,6 +2053,7 @@ static int nvme_revalidate_disk(struct gendisk *disk)
 
 	if (dev->oncs & NVME_CTRL_ONCS_DSM)
 		nvme_config_discard(ns);
+	blk_mq_unfreeze_queue(disk->queue);
 
 	kfree(id);
 	return 0;

