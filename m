From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: allow max_discard_segments to be stacked
Date: Fri, 20 Jul 2018 14:57:38 -0400
Message-ID: <20180720185738.11646-1-snitzer@redhat.com>
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
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

Set max_discard_segments to USHRT_MAX in blk_set_stacking_limits() so
that blk_stack_limits() can stack up this limit for stacked devices.

before:

$ cat /sys/block/nvme0n1/queue/max_discard_segments
256
$ cat /sys/block/dm-0/queue/max_discard_segments
1

after:

$ cat /sys/block/nvme0n1/queue/max_discard_segments
256
$ cat /sys/block/dm-0/queue/max_discard_segments
256

Fixes: 1e739730c5b9e ("block: optionally merge discontiguous discard bios into a single request")
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d1de71124656..24fff4a3d08a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -128,7 +128,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 
 	/* Inherit limits from component devices */
 	lim->max_segments = USHRT_MAX;
-	lim->max_discard_segments = 1;
+	lim->max_discard_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
 	lim->max_segment_size = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
-- 
2.18.0
