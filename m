From: Christoph Hellwig <hch@lst.de>
Subject: bdi cleanups v2
Date: Wed, 22 Jul 2020 08:25:38 +0200
Message-ID: <20200722062552.212200-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

this series contains a bunch of different BDI cleanups.  The biggest item
is to isolate block drivers from the BDI in preparation of changing the
lifetime of the block device BDI in a follow up series.


Changes since v1:
 - rebased to the for-5.9/block-merge branch
 - explicitly set the readahead to 0 for ubifs, vboxsf and mtd
 - split the zram block_device operations
 - let rw_page users fall back to bios in swap_readpage


Diffstat:
 block/blk-core.c              |    2 
 block/blk-integrity.c         |    4 
 block/blk-mq-debugfs.c        |    1 
 block/blk-settings.c          |    5 
 block/blk-sysfs.c             |  282 ++++++++++--------------------------------
 block/genhd.c                 |   13 +
 drivers/block/aoe/aoeblk.c    |    2 
 drivers/block/brd.c           |    1 
 drivers/block/drbd/drbd_nl.c  |   18 --
 drivers/block/drbd/drbd_req.c |    4 
 drivers/block/rbd.c           |    2 
 drivers/block/zram/zram_drv.c |   19 +-
 drivers/md/bcache/super.c     |    4 
 drivers/md/dm-table.c         |    9 -
 drivers/md/raid0.c            |   16 --
 drivers/md/raid10.c           |   46 ++----
 drivers/md/raid5.c            |   31 +---
 drivers/mmc/core/queue.c      |    3 
 drivers/mtd/mtdcore.c         |    1 
 drivers/nvdimm/btt.c          |    2 
 drivers/nvdimm/pmem.c         |    1 
 drivers/nvme/host/core.c      |    3 
 drivers/nvme/host/multipath.c |   10 -
 drivers/scsi/iscsi_tcp.c      |    4 
 fs/9p/vfs_file.c              |    2 
 fs/9p/vfs_super.c             |    4 
 fs/afs/super.c                |    1 
 fs/btrfs/disk-io.c            |    2 
 fs/fs-writeback.c             |    7 -
 fs/fuse/inode.c               |    4 
 fs/namei.c                    |    4 
 fs/nfs/super.c                |    9 -
 fs/super.c                    |    2 
 fs/ubifs/super.c              |    1 
 fs/vboxsf/super.c             |    1 
 include/linux/backing-dev.h   |   78 +----------
 include/linux/blkdev.h        |    3 
 include/linux/drbd.h          |    1 
 include/linux/fs.h            |    2 
 mm/backing-dev.c              |   12 -
 mm/filemap.c                  |    4 
 mm/memcontrol.c               |    2 
 mm/memory-failure.c           |    2 
 mm/migrate.c                  |    2 
 mm/mmap.c                     |    2 
 mm/page-writeback.c           |   18 +-
 mm/page_io.c                  |   18 +-
 mm/swapfile.c                 |    4 
 48 files changed, 204 insertions(+), 464 deletions(-)
