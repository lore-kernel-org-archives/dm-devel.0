From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 00/12] Block cleanups
Date: Mon,  6 Aug 2012 15:08:29 -0700
Message-ID: <1344290921-25154-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

Various cleanups for the generic block layer - the patches should be pretty
self explanatory.

CHANGES SINCE LAST VERSION:

Review feedback - should all be noted in the patch descriptions. Fixed
retarded rebase conflicts. Added some acked-bys.

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
 drivers/block/pktcdvd.c             |   73 +++-------
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
 fs/bio.c                            |  259 +++++++++++++++++++++++------------
 fs/exofs/ore.c                      |    5 +-
 include/linux/bio.h                 |   37 ++---
 include/linux/blk_types.h           |   12 ++-
 20 files changed, 256 insertions(+), 401 deletions(-)

-- 
1.7.7.3
