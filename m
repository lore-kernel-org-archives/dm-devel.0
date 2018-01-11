From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v3 0/3] block/dm: allow DM to defer blk_register_queue() until ready
Date: Wed, 10 Jan 2018 21:12:53 -0500
Message-ID: <20180111021256.37490-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

I eliminated my implementation that set disk->queue = NULL before
calling add_disk().  As we discussed it left way too much potential
for NULL pointer crashes and I agree it was too fragile.

This v3's approach is much simpler.  It adjusts block core so that
blk_register_queue() can be deferred (so add_disk()'s call is avoided
if QUEUE_FLAG_DEFER_REG is set, and a driver must then call it once it
has completed initializing its request_queue).

PATCH 1 is just an unrelated fix.  Christoph agreed with it in reply
to my v2 submission (but he didn't provide a Reviewed-by).  Anyway,
I've revised the header to have it make more sense.

If these changes look reasonable I'd prefer that you pick them all up
for 4.16 (last DM patch included because it'll save me an awkward
dm-4.16 rebase, etc).

Thanks!
Mike

Mike Snitzer (3):
  block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
  block: allow gendisk's request_queue registration to be deferred
  dm: fix awkward and incomplete request_queue initialization

 block/blk-sysfs.c      |  4 ++++
 block/genhd.c          |  7 +++++--
 drivers/md/dm-core.h   |  2 --
 drivers/md/dm-rq.c     | 11 -----------
 drivers/md/dm.c        | 44 ++++++++++++++++++++++++++------------------
 include/linux/blkdev.h |  1 +
 6 files changed, 36 insertions(+), 33 deletions(-)

-- 
2.15.0
