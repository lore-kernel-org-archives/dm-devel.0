From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: properly stack underlying max_segment_size to DM device
Date: Fri, 18 Oct 2013 10:23:26 -0400
Message-ID: <1382106206-4459-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, l.flis@cyfronet.pl
List-Id: dm-devel.ids

Without this patch all DM devices will default to BLK_MAX_SEGMENT_SIZE
(65536) even if the underlying device(s) have a larger value -- this is
due to blk_stack_limits() using min_not_zero() when stacking the
max_segment_size limit.

# cat /sys/block/sda/queue/max_segment_size
1073741824

# cat /sys/block/dm-0/queue/max_segment_size
before patch:
65536

after patch:
1073741824

Reported-by: Lukasz Flis <l.flis@cyfronet.pl>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # v3.3+
---
 block/blk-settings.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c50ecf0..29f28bb 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -143,6 +143,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	/* Inherit limits from component devices */
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
+	lim->max_segment_size = UINT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
 	lim->max_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
-- 
1.7.4.4
