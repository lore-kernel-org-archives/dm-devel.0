From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 00/13] Block cleanups
Date: Wed, 22 Aug 2012 10:03:57 -0700
Message-ID: <1345655050-28199-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org
List-Id: dm-devel.ids

Buncha changes in this version.

I came up with a new, much better solution to the "bio allocation from
bio sets under generic_make_request()" problem. Previously, I was
working around this in all of my code that allocated bios; it'd mask out
GFP_WAIT if current->bio_list != NULL, then punt to workqueue if the
allocation failed - so as to avoid the deadlock from allocating multiple
bios from the same bio set.

This approach worked, but it required it to be explicitly handled in any
stacking driver that might split a bio an arbitrary number of times -
less than ideal.

My new patch inverts this - when we go to allocate a bio and we're
blocking another bio from being submitted, we punt the bio(s) that are
being blocked off to a workqueue to be submitted. This means we only
have to handle it in one place, in bio_alloc_bioset() - stack block
drivers no longer have to do anything special (I got to delete some code
from bcache, and dm wasn't handling this at all before).

Other big change - I consolidated bio allocation. Now bio_alloc(),
bio_kmalloc(), bio_clone(), and bio_clone_kmalloc() are all one line
wrappers.

Incorporated a bunch of review feedback, most of which I hopefully
remembered to note in the patch descriptions this time.

Kent Overstreet (13):
  block: Generalized bio pool freeing
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Consolidate bio_alloc_bioset(), bio_kmalloc()
  block: Avoid deadlocks with bio allocation by stacking drivers
  block: Add an explicit bio flag for bios that own their bvec
  block: Rename bio_split() -> bio_pair_split()
  block: Introduce new bio_split()
  block: Rework bio_pair_split()
  block: Add bio_clone_bioset(), bio_clone_kmalloc()
  block: Only clone bio vecs that are in use

 Documentation/block/biodoc.txt      |   5 -
 block/blk-core.c                    |  10 +-
 drivers/block/drbd/drbd_main.c      |  13 +-
 drivers/block/drbd/drbd_req.c       |  18 +-
 drivers/block/osdblk.c              |   3 +-
 drivers/block/pktcdvd.c             |  73 ++-----
 drivers/block/rbd.c                 |   8 +-
 drivers/md/dm-crypt.c               |   9 -
 drivers/md/dm-io.c                  |  11 -
 drivers/md/dm.c                     |  68 ++----
 drivers/md/linear.c                 |   6 +-
 drivers/md/md.c                     |  44 +---
 drivers/md/raid0.c                  |   8 +-
 drivers/md/raid10.c                 |  23 +-
 drivers/target/target_core_iblock.c |   9 -
 fs/bio-integrity.c                  |  45 ----
 fs/bio.c                            | 419 +++++++++++++++++++++++-------------
 fs/exofs/ore.c                      |   5 +-
 include/linux/bio.h                 | 155 +++++++------
 include/linux/blk_types.h           |  16 +-
 20 files changed, 434 insertions(+), 514 deletions(-)

-- 
1.7.12
