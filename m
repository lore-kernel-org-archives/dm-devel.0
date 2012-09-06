From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v9 0/9] Block cleanups
Date: Thu,  6 Sep 2012 14:32:47 -0700
Message-ID: <1346967179-28596-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Since v8: Just a few minor comment/patch descriptions changes

Kent Overstreet (9):
  block: Generalized bio pool freeing
  block: Ues bi_pool for bio_integrity_alloc()
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Add bio_reset()
  block: Kill bi_destructor
  block: Consolidate bio_alloc_bioset(), bio_kmalloc()
  block: Add bio_clone_bioset(), bio_clone_kmalloc()

 Documentation/block/biodoc.txt      |   5 -
 block/blk-core.c                    |  10 +-
 drivers/block/drbd/drbd_main.c      |  13 +--
 drivers/block/osdblk.c              |   3 +-
 drivers/block/pktcdvd.c             |  52 ++-------
 drivers/md/dm-crypt.c               |  16 +--
 drivers/md/dm-io.c                  |  11 --
 drivers/md/dm.c                     |  72 ++++--------
 drivers/md/md.c                     |  44 +-------
 drivers/target/target_core_iblock.c |   9 --
 fs/bio-integrity.c                  |  44 +++-----
 fs/bio.c                            | 220 +++++++++++++++++-------------------
 fs/exofs/ore.c                      |   5 +-
 include/linux/bio.h                 |  44 +++++---
 include/linux/blk_types.h           |  27 +++--
 15 files changed, 207 insertions(+), 368 deletions(-)

-- 
1.7.12
