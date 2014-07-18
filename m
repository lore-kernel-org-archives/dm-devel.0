From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm thin: set {minimum,
	optimal}_io_size to pool's data block size
Date: Fri, 18 Jul 2014 17:59:43 -0400
Message-ID: <1405720783-7904-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Before if the block layer's limit stacking didn't establish an
optimal_io_size that was compatible with the dm-thin-pool's data block
size of the we'd set optimal_io_size to the data block size and
minimum_io_size to 0 (which the block layer adjusts to be
physical_block_size).

Update pool_io_hints() to set both minimum_io_size and optimal_io_size
to the pool's data block size.  This fixes an issue reported where
mkfs.xfs would create more XFS Allocation Groups on thinp volumes than
on a normal linear LV of comparable size, see:
https://bugzilla.redhat.com/show_bug.cgi?id=1003227

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index fc9c848..c92e1b9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3112,7 +3112,7 @@ static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 */
 	if (io_opt_sectors < pool->sectors_per_block ||
 	    do_div(io_opt_sectors, pool->sectors_per_block)) {
-		blk_limits_io_min(limits, 0);
+		blk_limits_io_min(limits, pool->sectors_per_block << SECTOR_SHIFT);
 		blk_limits_io_opt(limits, pool->sectors_per_block << SECTOR_SHIFT);
 	}
 
-- 
1.7.4.4
