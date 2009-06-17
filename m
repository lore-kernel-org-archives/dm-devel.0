From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm log: fix create_log_context() to use
	proper logical_block_size
Date: Wed, 17 Jun 2009 12:34:44 -0400
Message-ID: <1245256484-5468-1-git-send-email-snitzer@redhat.com>
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
 drivers/md/dm-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-log.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log.c
+++ linux-2.6/drivers/md/dm-log.c
@@ -414,7 +414,7 @@ static int create_log_context(struct dm_
 		 */
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size,
-				       ti->limits.logical_block_size);
+				       bdev_logical_block_size(lc->header_location.bdev));
 
 		if (buf_size > i_size_read(dev->bdev->bd_inode)) {
 			DMWARN("log device %s too small: need %llu bytes",
