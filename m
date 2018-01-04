From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 3/5] block: Provide blk_status_t decoding for retryable errors
Date: Thu,  4 Jan 2018 15:46:21 -0700
Message-ID: <20180104224623.8944-4-keith.busch@intel.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180104224623.8944-1-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

This patch provides a common decoder for block status that may be retried
so various entities wishing to consult this do not have to duplicate
this decision.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 include/linux/blk_types.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a1e628e032da..b6a8723b493c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,6 +39,22 @@ typedef u8 __bitwise blk_status_t;
 
 #define BLK_STS_AGAIN		((__force blk_status_t)12)
 
+static inline bool blk_retryable(blk_status_t error)
+{
+	switch (error) {
+	case BLK_STS_NOTSUPP:
+	case BLK_STS_NOSPC:
+	case BLK_STS_TARGET:
+	case BLK_STS_NEXUS:
+	case BLK_STS_MEDIUM:
+	case BLK_STS_PROTECTION:
+		return false;
+	}
+
+	/* Anything else could be a path failure, so should be retried */
+	return true;
+}
+
 struct blk_issue_stat {
 	u64 stat;
 };
-- 
2.13.6
