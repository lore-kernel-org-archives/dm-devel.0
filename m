From: Christoph Hellwig <hch@lst.de>
Subject: remove dead bdi congestion leftovers
Date: Wed,  1 Jul 2020 11:06:18 +0200
Message-ID: <20200701090622.3354860-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

we have a lot of bdi congestion related code that is left around without
any use.  This series removes it in preparation of sorting out the bdi
lifetime rules properly.

Diffstat:
 block/blk-cgroup.c               |   19 ----
 drivers/block/drbd/drbd_main.c   |   59 --------------
 drivers/block/drbd/drbd_proc.c   |    1 
 drivers/md/bcache/request.c      |   43 ----------
 drivers/md/bcache/super.c        |    1 
 drivers/md/dm-cache-target.c     |   19 ----
 drivers/md/dm-clone-target.c     |   15 ---
 drivers/md/dm-era-target.c       |   15 ---
 drivers/md/dm-raid.c             |   12 --
 drivers/md/dm-table.c            |   37 ---------
 drivers/md/dm-thin.c             |   16 ---
 drivers/md/dm.c                  |   33 --------
 drivers/md/dm.h                  |    1 
 drivers/md/md-linear.c           |   24 -----
 drivers/md/md-multipath.c        |   23 -----
 drivers/md/md.c                  |   23 -----
 drivers/md/md.h                  |    4 
 drivers/md/raid0.c               |   16 ---
 drivers/md/raid1.c               |   31 -------
 drivers/md/raid10.c              |   26 ------
 drivers/md/raid5.c               |   25 ------
 fs/btrfs/disk-io.c               |   23 -----
 include/linux/backing-dev-defs.h |   43 ----------
 include/linux/backing-dev.h      |   22 -----
 include/linux/blk-cgroup.h       |    6 -
 include/linux/device-mapper.h    |   11 --
 mm/backing-dev.c                 |  157 +++------------------------------------
 27 files changed, 20 insertions(+), 685 deletions(-)
