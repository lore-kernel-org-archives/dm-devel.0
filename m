From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] block: Improve io_opt limit stacking
Date: Thu, 14 May 2020 15:58:19 +0900
Message-ID: <20200514065819.1113949-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When devices with different physical sector sizes are stacked, the
largest value is used as the stacked device physical sector size. For
the optimal IO size, the lowest common multiple (lcm) of the underlying
devices is used for the stacked device. In this scenario, if only one of
the underlying device reports an optimal IO size, that value is used as
is for the stacked device but that value may not be a multiple of the
stacked device physical sector size. In this case, blk_stack_limits()
returns an error resulting in warnings being printed on device mapper
startup (observed with dm-zoned dual drive setup combining a 512B
sector SSD with a 4K sector HDD).

To fix this, rather than returning an error, the optimal IO size limit
for the stacked device can be adjusted to the lowest common multiple
(lcm) of the stacked physical sector size and optimal IO size, resulting
in a value that is a multiple of the physical sector size while still
being an optimal size for the underlying devices.

This patch is complementary to the patch "nvme: Fix io_opt limit
setting" which prevents the nvme driver from reporting an optimal IO
size equal to a namespace sector size for a device that does not report
an optimal IO size.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-settings.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9a2c23cd9700..9a2b017ff681 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -561,11 +561,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* Optimal I/O a multiple of the physical block size? */
-	if (t->io_opt & (t->physical_block_size - 1)) {
-		t->io_opt = 0;
-		t->misaligned = 1;
-		ret = -1;
-	}
+	if (t->io_opt & (t->physical_block_size - 1))
+		t->io_opt = lcm(t->io_opt, t->physical_block_size);
 
 	t->raid_partial_stripes_expensive =
 		max(t->raid_partial_stripes_expensive,
-- 
2.25.4
