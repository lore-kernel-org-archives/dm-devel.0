From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] block: Fix incorrect reporting of partition
	alignment
Date: Wed, 23 Dec 2009 15:31:29 -0500
Message-ID: <1261600290-29627-2-git-send-email-martin.petersen@oracle.com>
References: <20091223171351.GA17896@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091223171351.GA17896@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

queue_sector_alignment_offset returned the wrong value which caused
partitions to report an incorrect alignment_offset. Since offset
calculation is needed several places it has been split into a separate
helper function.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 784a919..59b832b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1116,11 +1116,18 @@ static inline int queue_alignment_offset(struct request_queue *q)
 	return q->limits.alignment_offset;
 }
 
+static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t offset)
+{
+	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
+
+	offset &= granularity - 1;
+	return (granularity + lim->alignment_offset - offset) & (granularity - 1);
+}
+
 static inline int queue_sector_alignment_offset(struct request_queue *q,
 						sector_t sector)
 {
-	return ((sector << 9) - q->limits.alignment_offset)
-		& (q->limits.io_min - 1);
+	return queue_limit_alignment_offset(&q->limits, sector << 9);
 }
 
 static inline int bdev_alignment_offset(struct block_device *bdev)
-- 
1.6.0.6
