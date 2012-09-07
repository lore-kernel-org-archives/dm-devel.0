From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] Prep work for immutable bio vecs
Date: Fri,  7 Sep 2012 15:59:11 -0700
Message-ID: <1347058760-30794-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

Random assortment of refactoring and trivial cleanups.

Immutable bio vecs and efficient bio splitting require auditing and removing
pretty much all bi_idx uses, among other things.

The reason is that with immutable bio vecs we can't use the bvec array
directly; if we have a partially completed bvec, that'll be indicated with a
field in struct bvec_iter (which gets embedded in struct bio) - bi_bvec_done.

bio_for_each_segments() will handle this transparently, so code needs to be
converted to use it or some other generic accessor.

Also, bio splitting means that when a driver gets a bio, bi_idx and
bi_bvec_done may both be nonzero. Again, just need to use generic accessors.

Kent Overstreet (9):
  block: Convert integrity to bvec_alloc_bs(), and a bugfix
  block: Add bio_advance()
  block: Refactor blk_update_request()
  md: Convert md_trim_bio() to use bio_advance()
  block: Add bio_end()
  block: Use bio_sectors() more consistently
  block: Don't use bi_idx in bio_split() or require it to be 0
  block: Remove bi_idx references
  block: Remove some unnecessary bi_vcnt usage

 block/blk-core.c                         |  86 ++++-----------------
 block/cfq-iosched.c                      |   7 +-
 block/deadline-iosched.c                 |   2 +-
 drivers/block/aoe/aoeblk.c               |   2 +-
 drivers/block/aoe/aoecmd.c               |   2 +-
 drivers/block/brd.c                      |   3 +-
 drivers/block/drbd/drbd_req.c            |   8 +-
 drivers/block/floppy.c                   |   1 -
 drivers/block/pktcdvd.c                  |   8 +-
 drivers/block/ps3vram.c                  |   2 +-
 drivers/md/dm-raid1.c                    |   2 +-
 drivers/md/dm-stripe.c                   |   2 +-
 drivers/md/dm-verity.c                   |   4 +-
 drivers/md/faulty.c                      |   6 +-
 drivers/md/linear.c                      |   3 +-
 drivers/md/md.c                          |  19 ++---
 drivers/md/raid0.c                       |   9 +--
 drivers/md/raid1.c                       |  21 +++--
 drivers/md/raid10.c                      |  28 +++----
 drivers/md/raid5.c                       |  22 +++---
 drivers/message/fusion/mptsas.c          |   6 +-
 drivers/s390/block/dcssblk.c             |   3 +-
 drivers/scsi/libsas/sas_expander.c       |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  10 +--
 fs/bio-integrity.c                       | 128 ++++++++++---------------------
 fs/bio.c                                 |  48 +++++++++++-
 fs/btrfs/extent_io.c                     |   3 +-
 fs/buffer.c                              |   1 -
 fs/gfs2/lops.c                           |   2 +-
 fs/jfs/jfs_logmgr.c                      |   2 -
 fs/logfs/dev_bdev.c                      |   5 --
 include/linux/bio.h                      |   8 +-
 include/trace/events/block.h             |  10 +--
 mm/page_io.c                             |   1 -
 34 files changed, 192 insertions(+), 278 deletions(-)

-- 
1.7.12
