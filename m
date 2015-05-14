From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 00/14] block, dm: first batch of changes for 4.2
Date: Thu, 14 May 2015 17:04:58 -0400
Message-ID: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Here is the start of the DM changes I've queued for 4.2 (via
linux-dm.git's for-next branch).

I'm posting them to the lists mainly to get feedback on the block
changes (first 4 patches) and to publish Joe's dm-thinp discard
improvements which depend on the new blkdev_issue_discard_async
interface.

Jens, if all looks OK please pick up the first 4 block patches.  The
"block: remove management of bi_remaining when restoring original
bi_end_io" has been tested in terms of DM.  I haven't tested btrfs,
bcache, etc.

All review/feedback is welcome.  Thanks!
Mike

Christoph Hellwig (1):
  block, dm: don't copy bios for request clones

Joe Thornber (5):
  block: factor out blkdev_issue_discard_async
  dm btree: add dm_btree_remove_leaves()
  dm thin metadata: add dm_thin_find_mapped_range()
  dm thin metadata: add dm_thin_remove_range()
  dm thin: range discard support

Mike Snitzer (8):
  block: remove management of bi_remaining when restoring original bi_end_io
  block: remove export for blk_queue_bio
  dm: do not allocate any mempools for blk-mq request-based DM
  dm: rename methods that requeue requests
  dm: factor out a common cleanup_mapped_device()
  dm thin: cleanup overwrite's endio restore to be centralized
  dm thin: cleanup schedule_zero() to read more logically
  dm thin metadata: remove in-core 'read_only' flag

 block/bio-integrity.c                         |   4 +-
 block/bio.c                                   |  20 --
 block/blk-core.c                              |  99 +-----
 block/blk-lib.c                               |  57 ++-
 drivers/md/bcache/io.c                        |   2 +-
 drivers/md/dm-cache-target.c                  |   6 -
 drivers/md/dm-raid1.c                         |   2 -
 drivers/md/dm-snap.c                          |   1 -
 drivers/md/dm-table.c                         |  29 +-
 drivers/md/dm-thin-metadata.c                 | 117 +++++-
 drivers/md/dm-thin-metadata.h                 |  11 +
 drivers/md/dm-thin.c                          | 493 +++++++++++++++++---------
 drivers/md/dm-verity.c                        |   2 +-
 drivers/md/dm.c                               | 314 +++++++---------
 drivers/md/dm.h                               |   5 +-
 drivers/md/persistent-data/dm-block-manager.c |   6 +
 drivers/md/persistent-data/dm-block-manager.h |   1 +
 drivers/md/persistent-data/dm-btree-remove.c  | 127 +++++++
 drivers/md/persistent-data/dm-btree.h         |   9 +
 fs/btrfs/disk-io.c                            |   2 +-
 fs/btrfs/volumes.c                            |  16 +-
 fs/btrfs/volumes.h                            |   2 -
 include/linux/bio.h                           |   1 -
 include/linux/blk_types.h                     |   3 +
 include/linux/blkdev.h                        |  11 +-
 25 files changed, 806 insertions(+), 534 deletions(-)

-- 
2.3.2 (Apple Git-55)
