From: Christoph Hellwig <hch@lst.de>
Subject: clean up is partition checks
Date: Thu,  3 Sep 2020 07:40:55 +0200
Message-ID: <20200903054104.228829-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

this series add a new helepr to check if a struct block_device represents
a parition, and removes most direct access to ->bd_contained from
drivers.

Diffstat:
 Documentation/userspace-api/ioctl/hdio.rst |   24 ++++++++++++------------
 block/blk-lib.c                            |    2 +-
 block/genhd.c                              |    2 +-
 block/ioctl.c                              |    4 ++--
 block/scsi_ioctl.c                         |    2 +-
 drivers/block/drbd/drbd_main.c             |    2 --
 drivers/block/drbd/drbd_receiver.c         |    2 +-
 drivers/block/drbd/drbd_worker.c           |    2 +-
 drivers/ide/ide-ioctls.c                   |    4 ++--
 drivers/md/dm-table.c                      |    2 +-
 drivers/md/md.c                            |    9 ++++-----
 drivers/md/md.h                            |    2 +-
 drivers/mmc/core/block.c                   |    2 +-
 drivers/s390/block/dasd_ioctl.c            |    8 ++++----
 drivers/target/target_core_iblock.c        |    5 ++---
 fs/nfsd/blocklayout.c                      |    4 ++--
 include/linux/blkdev.h                     |    9 +++++++--
 kernel/trace/blktrace.c                    |    2 +-
 lib/vsprintf.c                             |    4 ++--
 19 files changed, 46 insertions(+), 45 deletions(-)
