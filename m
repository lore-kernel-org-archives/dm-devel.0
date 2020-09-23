From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/2] block/dm: add REQ_NOWAIT support for bio-based
Date: Wed, 23 Sep 2020 16:06:50 -0400
Message-ID: <20200923200652.11082-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi,

I got guilted into this by this Twitter exchange:
https://twitter.com/axboe/status/1308778488011337728

Started with this patchset from June and revised it:
https://patchwork.kernel.org/project/dm-devel/list/?series=297693
(dropped MD patch while doing so_.

Tested these changes with this test Jens provided:

[mikes-test-job]
filename=/dev/dm-0
rw=randread
buffered=1
ioengine=io_uring
iodepth=16
norandommap

Jens, please feel free to pickup both patches, I don't have any
conflicting DM changes for 5.10.

Thanks,
Mike

Konstantin Khlebnikov (1):
  dm: add support for REQ_NOWAIT and enable it for linear target

Mike Snitzer (1):
  block: add QUEUE_FLAG_NOWAIT

 block/blk-core.c              |  4 ++--
 drivers/md/dm-linear.c        |  5 +++--
 drivers/md/dm-table.c         | 32 ++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  4 +++-
 include/linux/blkdev.h        |  7 +++++--
 include/linux/device-mapper.h |  6 ++++++
 6 files changed, 51 insertions(+), 7 deletions(-)

-- 
2.15.0
