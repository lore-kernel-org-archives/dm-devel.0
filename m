From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm thin: add proper support for a non power
	of 2 discard_granularity
Date: Fri,  4 Jan 2013 22:22:54 -0500
Message-ID: <1357356174-20661-2-git-send-email-snitzer@redhat.com>
References: <1357356174-20661-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357356174-20661-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Simplify how the thin target establishes discard_granularity now that
the block layer does support a non power of 2 discard_granularity (via
8dd2cb7e880d2f77fba53b523c99133ad5054cfd "block: discard granularity
might not be power of 2" and 59771079c18c44e39106f0f30054025acafadb41
"blk: avoid divide-by-zero with zero discard granularity").

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index abc2c78..8c3d64f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2433,15 +2433,8 @@ static void set_discard_limits(struct pool_c *pt, struct queue_limits *limits)
 	if (pt->adjusted_pf.discard_passdown) {
 		data_limits = &bdev_get_queue(pt->data_dev->bdev)->limits;
 		limits->discard_granularity = data_limits->discard_granularity;
-	} else if (block_size_is_power_of_two(pool))
+	} else
 		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
-	else
-		/*
-		 * Use largest power of 2 that is a factor of sectors_per_block
-		 * but at least DATA_DEV_BLOCK_SIZE_MIN_SECTORS.
-		 */
-		limits->discard_granularity = max(1 << (ffs(pool->sectors_per_block) - 1),
-						  DATA_DEV_BLOCK_SIZE_MIN_SECTORS) << SECTOR_SHIFT;
 }
 
 static void pool_io_hints(struct dm_target *ti, struct queue_limits *limits)
-- 
1.7.4.4
