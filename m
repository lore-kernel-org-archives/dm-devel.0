From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v2 0/3] block: some genhd changes
Date: Tue,  9 Jan 2018 21:41:01 -0500
Message-ID: <20180110024104.34885-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

Please consider PATCH 1 and 2 for 4.16 inclusion.  I've included PATCH
3 to show the DM changes needed in order to make use of these block
changes.

v2: added some del_gendisk() code movement to be symmetric with the
    device_add_disk() related code movement (suggested by Bart).  Also
    fixed a missing !GENHD_FL_HIDDEN check before the "bdi" symlink
    creation.

Thanks!
Mike

Mike Snitzer (3):
  block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
  block: cope with gendisk's 'queue' being added later
  dm: fix awkward request_queue initialization

 block/blk-sysfs.c     | 23 +++++++++++++++++-
 block/genhd.c         | 38 +++++++----------------------
 drivers/md/dm-core.h  |  2 --
 drivers/md/dm-ioctl.c |  7 ++----
 drivers/md/dm-rq.c    | 13 +---------
 drivers/md/dm-table.c |  2 +-
 drivers/md/dm.c       | 66 +++++++++++++++++++++++++++++++--------------------
 7 files changed, 75 insertions(+), 76 deletions(-)

-- 
2.15.0
