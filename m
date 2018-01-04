From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 1/5] nvme: Add more command status translation
Date: Thu,  4 Jan 2018 15:46:19 -0700
Message-ID: <20180104224623.8944-2-keith.busch@intel.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180104224623.8944-1-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

This adds more NVMe status code translations to blk_status_t values,
and captures all the current status codes NVMe multipath uses.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/nvme/host/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2a69d735efbc..f1cf1f6c5b28 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -156,14 +156,20 @@ static blk_status_t nvme_error_status(struct request *req)
 	case NVME_SC_SUCCESS:
 		return BLK_STS_OK;
 	case NVME_SC_CAP_EXCEEDED:
+	case NVME_SC_LBA_RANGE:
 		return BLK_STS_NOSPC;
+	case NVME_SC_BAD_ATTRIBUTES:
 	case NVME_SC_ONCS_NOT_SUPPORTED:
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
 		return BLK_STS_NOTSUPP;
 	case NVME_SC_WRITE_FAULT:
 	case NVME_SC_READ_ERROR:
 	case NVME_SC_UNWRITTEN_BLOCK:
 	case NVME_SC_ACCESS_DENIED:
 	case NVME_SC_READ_ONLY:
+	case NVME_SC_COMPARE_FAILED:
 		return BLK_STS_MEDIUM;
 	case NVME_SC_GUARD_CHECK:
 	case NVME_SC_APPTAG_CHECK:
-- 
2.13.6
