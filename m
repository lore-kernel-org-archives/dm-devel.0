From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/5] dm-rq: improve sequential I/O performance
Date: Mon, 27 Nov 2017 13:07:16 +0800
Message-ID: <20171127050721.5884-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi Guys,

The 1st patch removes the workaround of blk_mq_delay_run_hw_queue() in
case of requeue, this way isn't necessary, and more worse, it makes
BLK_MQ_S_SCHED_RESTART not working, and degarde I/O performance.

The 2nd patch return DM_MAPIO_REQUEUE to dm-rq if underlying request
allocation fails, then we can return BLK_STS_RESOURCE from dm-rq to
blk-mq, so that blk-mq can hold the requests to be dequeued.

The other 3 paches changes the blk-mq part of blk_insert_cloned_request(),
in which we switch to blk_mq_try_issue_directly(), so that both dm-rq
and blk-mq can get the dispatch result of underlying queue, and with
this information, blk-mq can handle IO merge much better, then
sequential I/O performance is improved much. In my dm-mpath over
virtio-scsi test, this improvement can be 3X ~ 5X.

V2:
	- drop 'dm-mpath: cache ti->clone during requeue', which is a bit
	too complicated, and not see obvious performance improvement.
	- make change on blk-mq part cleaner

Ming Lei (5):
  dm-mpath: don't call blk_mq_delay_run_hw_queue() in case of
    BLK_STS_RESOURCE
  dm-mpath: return DM_MAPIO_REQUEUE in case of rq allocation failure
  blk-mq: move actual issue into one helper
  blk-mq: return dispatch result to caller in blk_mq_try_issue_directly
  blk-mq: issue request directly for blk_insert_cloned_request

 block/blk-core.c      |  3 +-
 block/blk-mq.c        | 88 +++++++++++++++++++++++++++++++++++++++------------
 block/blk-mq.h        |  3 ++
 drivers/md/dm-mpath.c | 18 ++++++++---
 drivers/md/dm-rq.c    | 20 +++++++++---
 5 files changed, 102 insertions(+), 30 deletions(-)

-- 
2.9.5
