From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 00/12] Block cleanups
Date: Tue, 24 Jul 2012 13:11:17 -0700
Message-ID: <1343160689-12378-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

CHANGES SINCE LAST VERSION:

Split off the "make generic_make_request() handle arbitrary size bios" - this
patch series now just kills bi_destructor and reworks bio splitting.

Split out the "rework bio splitting" patch based on Boaz's feedback - now I've
got one patch that introduces the new bio_split() and another that rewrites
bio_pair_split(), which makes the patches much more readable.

Going to try and finish off the rest of the patches that get rid of
merge_bvec_fn, but that'll be a separate patch series.

Kent Overstreet (12):
  block: Generalized bio pool freeing
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Add an explicit bio flag for bios that own their bvec
  block: Rename bio_split() -> bio_pair_split()
  block: Introduce new bio_split()
  block: Rework bio_pair_split()
  block: Add bio_clone_kmalloc()
  block: Add bio_clone_bioset()
  block: Only clone bio vecs that are in use

 Documentation/block/biodoc.txt      |    5 -
 block/blk-core.c                    |   10 +-
 drivers/block/drbd/drbd_main.c      |   13 +--
 drivers/block/drbd/drbd_req.c       |   18 +--
 drivers/block/osdblk.c              |    3 +-
 drivers/block/pktcdvd.c             |  121 ++++++-----------
 drivers/block/rbd.c                 |    8 +-
 drivers/md/dm-crypt.c               |    9 --
 drivers/md/dm-io.c                  |   11 --
 drivers/md/dm.c                     |   60 ++-------
 drivers/md/linear.c                 |    6 +-
 drivers/md/md.c                     |   44 +------
 drivers/md/raid0.c                  |    8 +-
 drivers/md/raid10.c                 |   23 +---
 drivers/target/target_core_iblock.c |    9 --
 fs/bio-integrity.c                  |   44 ------
 fs/bio.c                            |  264 ++++++++++++++++++++++++-----------
 fs/exofs/ore.c                      |    5 +-
 include/linux/bio.h                 |   37 ++---
 include/linux/blk_types.h           |    9 +-
 20 files changed, 281 insertions(+), 426 deletions(-)

-- 
1.7.7.3
