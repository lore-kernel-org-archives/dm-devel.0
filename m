From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/5] blk-mq & dm: fix IO hang and deal with one performance issue
Date: Mon, 22 Jan 2018 11:35:45 +0800
Message-ID: <20180122033550.27855-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi Jens,

This 1st patch introduces BLK_STS_DEV_RESOURCE for dealing with IO hang
when non-device resource is run out of and queue is idle, and this
approach is suggested by you.

The 2nd and 3rd patches cleans dm-rq a bit and prepares for applying
blk_get_request_notify().

The 4th patch introduces blk_get_request_notify(), still suggested by
you.

The last patch applies blk_get_request_notify() and avoids one
DM specific performance issue which is introduced by the 1st patch.

These 5 patches are against both dm(dm-4.16) and block tree(for-4.16/block).

Ming Lei (5):
  blk-mq: introduce BLK_STS_DEV_RESOURCE
  dm-rq: handle dispatch exception in dm_dispatch_clone_request()
  dm-rq: return BLK_STS_* from map_request()
  blk-mq: introduce blk_get_request_notify
  dm-mpath: use blk_mq_alloc_request_notify for allocating blk-mq req

 block/blk-core.c             |  1 +
 block/blk-mq-tag.c           | 27 +++++++++++++++++++++-
 block/blk-mq.c               | 43 +++++++++++++++++++++++++++++------
 block/blk-mq.h               |  1 +
 drivers/block/null_blk.c     |  2 +-
 drivers/block/virtio_blk.c   |  2 +-
 drivers/block/xen-blkfront.c |  2 +-
 drivers/md/dm-mpath.c        | 50 ++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-rq.c           | 53 +++++++++++++++++++++++++++-----------------
 drivers/md/dm.c              |  1 +
 drivers/scsi/scsi_lib.c      |  6 ++---
 include/linux/blk-mq.h       |  5 +++++
 include/linux/blk_types.h    |  7 ++++++
 13 files changed, 165 insertions(+), 35 deletions(-)

-- 
2.9.5
