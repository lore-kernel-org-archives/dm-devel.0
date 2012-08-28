From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v7 0/9] Block cleanups, deadlock fix
Date: Tue, 28 Aug 2012 10:37:27 -0700
Message-ID: <1346175456-1572-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, vgoyal@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com
List-Id: dm-devel.ids

Since v6:

 * Rebased onto Linus master
 * Split off the bio splitting patches
 * Various review feedback

Kent Overstreet (9):
  block: Generalized bio pool freeing
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Consolidate bio_alloc_bioset(), bio_kmalloc()
  block: Add bio_clone_bioset(), bio_clone_kmalloc()
  block: Reorder struct bio_set
  block: Avoid deadlocks with bio allocation by stacking drivers

 Documentation/block/biodoc.txt      |   5 -
 block/blk-core.c                    |  10 +-
 drivers/block/drbd/drbd_main.c      |  13 +-
 drivers/block/osdblk.c              |   3 +-
 drivers/block/pktcdvd.c             |  52 ++------
 drivers/md/dm-crypt.c               |   9 --
 drivers/md/dm-io.c                  |  11 --
 drivers/md/dm.c                     |  68 +++-------
 drivers/md/md.c                     |  44 +------
 drivers/target/target_core_iblock.c |   9 --
 fs/bio.c                            | 243 ++++++++++++++++++++----------------
 fs/exofs/ore.c                      |   5 +-
 include/linux/bio.h                 | 111 ++++++++++------
 include/linux/blk_types.h           |  23 +++-
 14 files changed, 260 insertions(+), 346 deletions(-)

-- 
1.7.12
