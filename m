From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm log: fix create_log_context() to use proper
	logical_block_size
Date: Wed, 17 Jun 2009 12:21:52 -0400
Message-ID: <1245255712-5320-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

create_log_context() must use the logical_block_size from the log disk
rather than the target's logical_block_size.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-log.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log.c
+++ linux-2.6/drivers/md/dm-log.c
@@ -404,17 +404,19 @@ static int create_log_context(struct dm_
 		}
 		lc->disk_header = NULL;
 	} else {
+		struct request_queue *q;
 		lc->log_dev = dev;
 		lc->log_dev_failed = 0;
 		lc->header_location.bdev = lc->log_dev->bdev;
 		lc->header_location.sector = 0;
+		q = bdev_get_queue(lc->header_location.bdev);
 
 		/*
 		 * Buffer holds both header and bitset.
 		 */
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size,
-				       ti->limits.logical_block_size);
+				       q->limits.logical_block_size);
 
 		if (buf_size > i_size_read(dev->bdev->bd_inode)) {
 			DMWARN("log device %s too small: need %llu bytes",
