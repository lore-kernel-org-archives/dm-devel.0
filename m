From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/14] Block cleanups (for bcache)
Date: Wed, 23 May 2012 17:02:37 -0700
Message-ID: <1337817771-25038-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

This is version 2 of this patch series - nothing major, documented a few things
and incorporated various review feedback. Please let me know if there's
anything I missed.

Couple related things in this patch series. This is mostly stuff I did for
bcache, polished/expanded up a bit:

 * Bio pool freeing. This moves freeing of bios allocated from bio pools into
   generic code.

 * Kill bi_destructor. That was Tejun's idea, but it turned out to be easier
   than I expected.

 * Improved bio splitting. This was originally part of bcache, but I pulled it
   out and replaced the existing bio splitting code with it.

 * Closures - this is from bcache. I didn't really need to use it for the next
   patch, but IMO it makes the code a bit more elegant.

 * Make generic_make_request() handle arbitrary size bios. I think this is
   going to enable a lot of cleanups in the future.

   The idea here isn't for generic_make_request() to be doing the splitting in
   practice long term, it's more just an intermediate stage. If this goes in, I
   think a lot of driver code - certainly a lot of virtual block drivers -
   could easily be made to handle arbitrary sized bios, and splitting will only
   happen when a bio is being redirected to two different devices or something
   like that. But this should enable a lot of cleanups without having to change
   every block driver first.

Kent Overstreet (14):
  block: Generalized bio pool freeing
  dm: kill dm_rq_bio_destructor
  block: Add bio_clone_bioset()
  block: Add bio_clone_kmalloc()
  block: Only clone bio vecs that are in use
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Add an explicit bio flag for bios that own their bvec
  block: Rename bio_split() -> bio_pair_split()
  block: Rework bio splitting
  Closures
  Make generic_make_request handle arbitrarily large bios
  Gut bio_add_page()

 Documentation/block/biodoc.txt      |    5 -
 block/blk-core.c                    |  126 ++++++-
 drivers/block/drbd/drbd_req.c       |   18 +-
 drivers/block/osdblk.c              |    3 +-
 drivers/block/pktcdvd.c             |  121 +++----
 drivers/block/rbd.c                 |   12 +-
 drivers/md/dm-crypt.c               |    9 -
 drivers/md/dm-io.c                  |   11 -
 drivers/md/dm.c                     |   58 +---
 drivers/md/linear.c                 |    6 +-
 drivers/md/md.c                     |   44 +--
 drivers/md/raid0.c                  |    8 +-
 drivers/md/raid10.c                 |   23 +-
 drivers/target/target_core_iblock.c |    9 -
 fs/bio-integrity.c                  |   44 ---
 fs/bio.c                            |  417 ++++++++++++------------
 fs/exofs/ore.c                      |    5 +-
 include/linux/bio.h                 |   42 +--
 include/linux/blk_types.h           |    9 +-
 include/linux/blkdev.h              |    3 +
 include/linux/closure.h             |  614 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |    8 +
 lib/Makefile                        |    2 +-
 lib/closure.c                       |  363 +++++++++++++++++++++
 24 files changed, 1433 insertions(+), 527 deletions(-)
 create mode 100644 include/linux/closure.h
 create mode 100644 lib/closure.c

-- 
1.7.9.3.327.g2980b
