From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.9 v2 0/6] [PATCH for-4.9 v2 0/3] allow delayed requeue of blk-mq requests
Date: Wed, 14 Sep 2016 12:29:30 -0400
Message-ID: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

I'd like to see these changes included during the 4.9 merge.  The
blk-mq change is a straight-forward switch from work_struct to
delayed_work and the addition of the blk_mq_delay_kick_requeue_list()
interface.

Jens, please pick up the first patch and I'll rebase linux-dm.git
ontop of your 4.9 branch.  Hannes, please re-review/ack as you like.


These changes offer reduced CPU utilization during DM multipath's all
path down case (when 'queue_if_no_path' is enabled).  Please see each
patch's header for more details.

v2: fixed 'msecs' variable name to be 'delay' in blk-mq, use
    msecs_to_jiffies() in dm-rq call to blk-mq, also made
    DM-mpath kick the queue if/when a path is reinstated

Mike Snitzer (6):
  blk-mq: introduce blk_mq_delay_kick_requeue_list()
  dm rq: add DM_MAPIO_DELAY_REQUEUE to delay requeue of blk-mq requests
  dm rq: reduce arguments passed to map_request() and
    dm_requeue_original_request()
  dm rq: introduce dm_mq_kick_requeue_list()
  dm mpath: use dm_mq_kick_requeue_list()
  dm mpath: delay the requeue of blk-mq requests while all paths down

 block/blk-mq.c                | 15 ++++++++---
 drivers/md/dm-mpath.c         | 29 ++++++++++++---------
 drivers/md/dm-rq.c            | 59 ++++++++++++++++++++++++++-----------------
 drivers/md/dm-rq.h            |  2 ++
 include/linux/blk-mq.h        |  1 +
 include/linux/blkdev.h        |  2 +-
 include/linux/device-mapper.h |  1 +
 7 files changed, 69 insertions(+), 40 deletions(-)

-- 
2.7.4 (Apple Git-66)

