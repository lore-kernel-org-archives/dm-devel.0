From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv2 3/5] block: Provide blk_status_t decoding for path errors
Date: Tue,  9 Jan 2018 12:04:16 -0700
Message-ID: <20180109190418.7123-4-keith.busch@intel.com>
References: <20180109190418.7123-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180109190418.7123-1-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

This patch provides a common decoder for block status path related errors
that may be retried so various entities wishing to consult this do not
have to duplicate this decision.

Acked-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 include/linux/blk_types.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a1e628e032da..2d973ac54b09 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,6 +39,34 @@ typedef u8 __bitwise blk_status_t;
 
 #define BLK_STS_AGAIN		((__force blk_status_t)12)
 
+/**
+ * blk_path_error - returns true if error may be path related
+ * @error: status the request was completed with
+ *
+ * Description:
+ *     This classifies block error status into non-retryable errors and ones
+ *     that may be successful if retried on a failover path.
+ *
+ * Return:
+ *     %false - retrying failover path will not help
+ *     %true  - may succeed if retried
+ */
+static inline bool blk_path_error(blk_status_t error)
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
