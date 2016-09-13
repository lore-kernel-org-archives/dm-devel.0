From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.9 0/3] allow delayed requeue of blk-mq requests
Date: Tue, 13 Sep 2016 12:01:32 -0400
Message-ID: <1473782495-44128-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

I'd like to see these changes included during the 4.9 merge.  The
blk-mq change is a straight-forward switch from work_struct to
delayed_work and the addition of the blk_mq_delay_kick_requeue_list()
interface.  Jens, can you pick up this blk-mq changes (patch 1)?

These changes offer reduced CPU utilization during DM multipath's all
path down case (when 'queue_if_no_path' is enabled).  Please see each
patch's header for more details.

Mike Snitzer (3):
  blk-mq: introduce blk_mq_delay_kick_requeue_list()
  dm rq: add DM_MAPIO_DELAY_REQUEUE to delay requeue of blk-mq requests
  dm mpath: delay the requeue of blk-mq requests while all paths down

 block/blk-mq.c                | 15 +++++++++++----
 drivers/md/dm-mpath.c         | 15 +++++++++------
 drivers/md/dm-rq.c            | 35 ++++++++++++++++++++---------------
 include/linux/blk-mq.h        |  1 +
 include/linux/blkdev.h        |  2 +-
 include/linux/device-mapper.h |  1 +
 6 files changed, 43 insertions(+), 26 deletions(-)

-- 
2.7.4 (Apple Git-66)

