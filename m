From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 0/6] dm: fix then improve bio splitting
Date: Mon, 21 Sep 2020 22:32:45 -0400
Message-ID: <20200922023251.47712-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Patches 1 and 2 are queued for me to send to Linus later this week.

Patches 3 and 4 are block core and should get picked up for 5.10.
Jens, please pick them up. I revised the header for patch 4 to give
better context for use-case where non power-of-2 chunk_sectors
occurs. Patch 4 enables DM to switch to using blk_max_size_offset() in
Patch 6.

Patches 5 and 6 just show how DM will be enhanced for 5.10 once
patches 3 and 4 land in the block tree.

Mike Snitzer (6):
  dm: fix bio splitting and its bio completion order for regular IO
  dm: fix comment in dm_process_bio()
  block: use lcm_not_zero() when stacking chunk_sectors
  block: allow 'chunk_sectors' to be non-power-of-2
  dm table: stack 'chunk_sectors' limit to account for target-specific splitting
  dm: change max_io_len() to use blk_max_size_offset()

 block/blk-settings.c   | 22 ++++++++++++----------
 drivers/md/dm-table.c  |  5 +++++
 drivers/md/dm.c        | 47 +++++++++++++----------------------------------
 include/linux/blkdev.h | 12 +++++++++---
 4 files changed, 39 insertions(+), 47 deletions(-)

-- 
2.15.0
