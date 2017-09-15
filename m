From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/5] dm-mpath: improve I/O schedule
Date: Sat, 16 Sep 2017 00:44:51 +0800
Message-ID: <20170915164456.9803-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi,

We depend on I/O scheduler in dm-mpath layer, and underlying
I/O scheduler is bypassed basically.

I/O scheduler depends on queue busy condition to
trigger I/O merge, unfortunatley inside dm-mpath,
the underlying queue busy feedback is not accurate
enough, and we just allocate one request and dispatcch
it out to underlying queue, no matter if that queue
is busy or not. Then I/O merge is hard to trigger.

This patchset sets underlying queue's nr_request as
the queue's queue depth, so that queue busy is figured
out by checking if request is allocated successfully.

From test result on mq-deadline, sequential I/O performance
is improved a lot, see test result in patch 5's commit log.

Any comments are welcome!

Thanks,
Ming

Ming Lei (5):
  block: don't call blk_mq_delay_run_hw_queue() in case of
    BLK_STS_RESOURCE
  dm-mpath: return DM_MAPIO_REQUEUE in case of rq allocation failure
  dm-mpath: remove annoying message of 'blk_get_request() returned -11'
  block: export blk_update_nr_requests
  dm-mpath: improve I/O schedule

 block/blk-core.c        |  4 +++-
 block/blk-sysfs.c       |  5 +----
 block/blk.h             |  2 --
 drivers/md/dm-mpath.c   | 30 +++++++++++++++++++++++++++---
 drivers/md/dm-rq.c      |  1 -
 drivers/nvme/host/fc.c  |  3 ---
 drivers/scsi/scsi_lib.c |  4 ----
 include/linux/blkdev.h  |  1 +
 8 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.9.5
