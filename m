From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v6 0/3] blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback
Date: Wed, 17 Jan 2018 11:25:55 -0500
Message-ID: <20180117162558.28553-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

Think this finally takes care of it! ;)

Thanks,
Mike

Mike Snitzer (2):
  blk-mq: factor out a few helpers from __blk_mq_try_issue_directly
  blk-mq-sched: remove unused 'can_block' arg from blk_mq_sched_insert_request

Ming Lei (1):
  blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback

 block/blk-core.c     |   3 +-
 block/blk-exec.c     |   2 +-
 block/blk-mq-sched.c |   2 +-
 block/blk-mq-sched.h |   2 +-
 block/blk-mq.c       | 106 ++++++++++++++++++++++++++++++++++++---------------
 block/blk-mq.h       |   3 ++
 drivers/md/dm-rq.c   |  19 +++++++--
 7 files changed, 98 insertions(+), 39 deletions(-)

-- 
2.15.0
