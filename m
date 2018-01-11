From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v4 0/4] block/dm: allow DM to defer blk_register_queue() until ready
Date: Thu, 11 Jan 2018 15:14:13 -0500
Message-ID: <20180111201417.2042-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

I think this set is now ready for you to pick up for 4.16.

Hannes, I ran with your review feedback and think the result is
cleaner (avoids frivolously using another QUEUE_FLAG).

Ming, I didn't add your Reviewed-by to "block: allow gendisk's
request_queue registration to be deferred" because it changed enough,
albeit for the better, that it is best for you to review again.

Thanks,
Mike

Mike Snitzer (4):
  block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
  block: use queue_lock when clearing QUEUE_FLAG_REGISTERED in blk_unregister_queue
  block: allow gendisk's request_queue registration to be deferred
  dm: fix awkward and incomplete request_queue initialization

 block/blk-sysfs.c     | 12 ++++++++----
 block/genhd.c         | 23 +++++++++++++++++++----
 drivers/md/dm-core.h  |  2 --
 drivers/md/dm-rq.c    | 11 -----------
 drivers/md/dm.c       | 41 ++++++++++++++++++++++-------------------
 include/linux/genhd.h |  5 +++++
 6 files changed, 54 insertions(+), 40 deletions(-)

-- 
2.15.0
