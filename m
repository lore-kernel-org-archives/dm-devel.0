From: NeilBrown <neilb@suse.com>
Subject: [PATCH 0/5] Updates following recent generic_make_request
 improvement
Date: Fri, 10 Mar 2017 17:00:46 +1100
Message-ID: <148912539296.4002.219258660543808741.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

This is a rebase of the series I sent earlier, based on the
very latest from Linus, which included my first patch.

The first fixes a problem that patch introduced, and so should go to
Linux promptly.
The others are more general improvements and can go in the normal
course of events.

It is possible that the changes to btrfs and xfs can just be dropped
as a subsequent patch will be needed to revert them anyway.  They are
there only to be able to say that "blk: make the bioset
rescue_workqueue optional." doesn't change any functionality at all.

Thanks,
NeilBrown

---

NeilBrown (5):
      blk: Ensure users for current->bio_list can see the full list.
      blk: remove bio_set arg from blk_queue_split()
      blk: make the bioset rescue_workqueue optional.
      blk: use non-rescuing bioset for q->bio_split.
      block_dev: make blkdev_dio_pool a non-rescuing bioset


 block/bio.c                         |   40 +++++++++++++++++++++++++++++------
 block/blk-core.c                    |   32 +++++++++++++++++-----------
 block/blk-merge.c                   |    7 +++---
 block/blk-mq.c                      |    4 ++--
 drivers/block/drbd/drbd_main.c      |    2 +-
 drivers/block/drbd/drbd_req.c       |    2 +-
 drivers/block/pktcdvd.c             |    2 +-
 drivers/block/ps3vram.c             |    2 +-
 drivers/block/rsxx/dev.c            |    2 +-
 drivers/block/umem.c                |    2 +-
 drivers/block/zram/zram_drv.c       |    2 +-
 drivers/lightnvm/rrpc.c             |    2 +-
 drivers/md/bcache/super.c           |    4 ++--
 drivers/md/dm-crypt.c               |    2 +-
 drivers/md/dm-io.c                  |    2 +-
 drivers/md/dm.c                     |   32 ++++++++++++++++------------
 drivers/md/md.c                     |    4 ++--
 drivers/md/raid10.c                 |    3 ++-
 drivers/md/raid5-cache.c            |    2 +-
 drivers/s390/block/dcssblk.c        |    2 +-
 drivers/s390/block/xpram.c          |    2 +-
 drivers/target/target_core_iblock.c |    2 +-
 fs/btrfs/extent_io.c                |    4 ++--
 fs/xfs/xfs_super.c                  |    2 +-
 include/linux/bio.h                 |    2 ++
 include/linux/blkdev.h              |    3 +--
 26 files changed, 101 insertions(+), 64 deletions(-)

--
Signature
