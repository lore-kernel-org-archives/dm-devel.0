From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v5 0/4] block/dm: allow DM to defer blk_register_queue() until ready
Date: Fri, 12 Jan 2018 10:06:02 -0500
Message-ID: <20180112150606.6037-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, David Jeffery <djeffery@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

I'm submitting this v5 with more feeling now ;)

I've distilled the changes down to be quite minimal.  Hopefully this
will help you and others review.

I've also done a dry-run of applying 4.16 block changes and then
merging dm-4.16; no merge conflicts:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=block-4.16
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-4.16
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=block-4.16_dm-4.16

And all tests very well for me.

Please consider for 4.16, thanks!

Mike

Mike Snitzer (4):
  block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
  block: properly protect the 'queue' kobj in blk_unregister_queue
  block: allow gendisk's request_queue registration to be deferred
  dm: fix incomplete request_queue initialization

 block/blk-sysfs.c     | 18 +++++++++++++++---
 block/genhd.c         | 23 +++++++++++++++++++----
 drivers/md/dm-rq.c    |  9 ---------
 drivers/md/dm.c       | 11 ++++++++++-
 include/linux/genhd.h |  5 +++++
 5 files changed, 49 insertions(+), 17 deletions(-)

-- 
2.15.0
