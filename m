From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 4/5] nvme/multipath: Use blk_path_error
Date: Tue,  9 Jan 2018 12:04:17 -0700
Message-ID: <20180109190418.7123-5-keith.busch@intel.com>
References: <20180109190418.7123-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180109190418.7123-1-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

Uses common code for determining if an error should be retried on
alternate path.

Acked-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/nvme/host/multipath.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ae9abb600c0f..3b211d9e58b8 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -37,19 +37,7 @@ bool nvme_req_needs_failover(struct request *req, blk_status_t error)
 {
 	if (!(req->cmd_flags & REQ_NVME_MPATH))
 		return false;
-
-	switch (error) {
-	case BLK_STS_NOTSUPP:
-	case BLK_STS_NOSPC:
-	case BLK_STS_TARGET:
-	case BLK_STS_NEXUS:
-	case BLK_STS_MEDIUM:
-	case BLK_STS_PROTECTION:
-		return false;
-	}
-
-	/* Everything else could be a path failure, so should be retried */
-	return true;
+	return blk_path_error(error);
 }
 
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
-- 
2.13.6
