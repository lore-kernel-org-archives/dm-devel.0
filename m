From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH 0/2] block: cope with gendisk's 'queue' being added later
Date: Tue,  9 Jan 2018 17:10:37 -0500
Message-ID: <20180109221039.33282-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

Please consider PATCH 1/2 for 4.16 inclusion.  I've included PATCH 2/2
to show the DM changes needed in order to make use of the block
changes.

I think, all things considered, this moves DM's interface with block
core in a better direction for the long-term but I obviously welcome
any critical feedback.

Thanks!
Mike

Mike Snitzer (2):
  block: cope with gendisk's 'queue' being added later
  dm: fix awkward request_queue initialization

 block/blk-sysfs.c     | 12 ++++++++++
 block/genhd.c         | 28 +++++++---------------
 drivers/md/dm-core.h  |  2 --
 drivers/md/dm-ioctl.c |  7 ++----
 drivers/md/dm-rq.c    | 13 +---------
 drivers/md/dm-table.c |  2 +-
 drivers/md/dm.c       | 66 +++++++++++++++++++++++++++++++--------------------
 7 files changed, 64 insertions(+), 66 deletions(-)

-- 
2.15.0
