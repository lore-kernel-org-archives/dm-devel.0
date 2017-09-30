From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/5] dm-rq: improve sequential I/O performance
Date: Sat, 30 Sep 2017 19:46:47 +0800
Message-ID: <20170930114652.32441-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi,

This 1st one patch removes one log message which can be triggered
very easily.

The 2nd patch removes the workaround of blk_mq_delay_run_hw_queue()
in case of requeue, this way isn't necessary, and more worse, it
makes BLK_MQ_S_SCHED_RESTART not working, and degarde I/O performance.

The 3rd patch return DM_MAPIO_REQUEUE to dm-rq if underlying request
allocation fails, then we can return BLK_STS_RESOURCE from dm-rq
to blk-mq, so that blk-mq can hold the requests to be dequeued.

The 4th patch is a pre-patch for the 5th one, becasue even though
underlying request allocation succeeds, its queue may be
busy and we can get this feedback from blk_insert_cloned_request()
now. This patch trys to cache the allocated request so that
it may be reused in next dispatch to underlying queue.

The 5th patch improves sequential I/O performance by returning
STS_RESOURCE if underlying queue is busy.

In the commit log of the 5th patch, I/O IOPS data is provided and
we can see sequential I/O performance is improved a lot with this
patchset.

This patchset depends on the following two patchset:

[1] [PATCH V5 0/7] blk-mq-sched: improve sequential I/O performance(part 1)
    
	https://marc.info/?l=linux-block&m=150676854821077&w=2
    
[2] [PATCH V5 0/8] blk-mq: improve bio merge for none scheduler
    
	https://marc.info/?l=linux-block&m=150677085521416&w=2

Any comments are welcome! 

Thanks,
Ming

Ming Lei (5):
  dm-mpath: remove annoying message of 'blk_get_request() returned -11'
  dm-mpath: don't call blk_mq_delay_run_hw_queue() in case of
    BLK_STS_RESOURCE
  dm-mpath: return DM_MAPIO_REQUEUE in case of rq allocation failure
  dm-mpath: cache ti->clone during requeue
  dm-rq: improve I/O merge by dealing with underlying STS_RESOURCE

 block/blk-mq.c        | 17 +---------------
 drivers/md/dm-mpath.c | 51 ++++++++++++++++++++++++++++++++++------------
 drivers/md/dm-rq.c    | 56 +++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 80 insertions(+), 44 deletions(-)

-- 
2.9.5
