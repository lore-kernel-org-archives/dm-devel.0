From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v3 00/16] Block cleanups
Date: Fri, 25 May 2012 13:25:23 -0700
Message-ID: <1337977539-16977-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk, yehuda@hq.newdream.net, Kent Overstreet <koverstreet@google.com>, mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com, tj@kernel.org, sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: dm-devel.ids

Incorporated various review feedback, and I reordered/reworked the patches to
make them more coherent.

This also has the latest version of the closure code, incorporating review
feedback from Joe and Tejun. I may rewrite the bio splitting stuff to not
depend on it so it can go in sooner (Tejun is not a fan of closures), but IMO
the patch is better for using them.

First 5 patches: Kill bi_destructor

Next 3 patches: Better bio splitting

Next 3 patches: Rework bio cloning to not clone entire bio vec

Tejun also pointed out that with the bio splitting improvements we ought to be
able to get rid of merge_bvec_fn, so I started on that. Those patches are
definitely a WIP, though.

For most of the md code, it looks like things will almost just work - they
already had bio_pair_split() calls to handle single page bios that crossed bvec
boundries, but bio_pair_split() now splits arbitrary bios so things should just work.

(I just thought of one problem - previously, in practice you'd never need to
split a bio more than once, but that's no longer true - so the
bio_pair_split() calls do need to be stuck in a loop, and the as is the
patches aren't correct.)

For raid5 though I couldn't find any splitting in the existing code - it looks
like it's depending on merge_bvec_fn to make sure bios never need to be split.
Adding bio splitting looks to be not quite trivial - Neil, any thoughts?

For dm, it was already splitting multi page bios when necessary, it looked like
its merge_bvec_fn was mostly for propagating device limits - which my
generic_make_request() patch handles. Any dm folks want to take a look?

There are only 4 merge_bvec_fns left in my kernel:

drivers/md/raid5.c - raid5_mergeable_bvec()
drivers/block/drbd/drbd_req.c - drbd_merge_bvec()
drivers/block/pktcdvd.c - pkt_merge_bvec()
drivers/block/rbd.c - rbd_merge_bvec()

I haven't looked at the last three, but if the maintainers want to help out a
bit it should be pretty easy to get rid of merge_bvec_fn entirely.

Kent Overstreet (16):
  block: Generalized bio pool freeing
  dm: Use bioset's front_pad for dm_rq_clone_bio_info
  block: Add bio_reset()
  pktcdvd: Switch to bio_kmalloc()
  block: Kill bi_destructor
  block: Add an explicit bio flag for bios that own their bvec
  block: Rename bio_split() -> bio_pair_split()
  block: Rework bio splitting
  block: Add bio_clone_kmalloc()
  block: Add bio_clone_bioset()
  block: Only clone bio vecs that are in use
  Closures
  Make generic_make_request handle arbitrarily large bios
  Gut bio_add_page()
  md: Kill merge_bvec_fn()s
  dm: Kill merge_bvec_fn()

 Documentation/block/biodoc.txt      |    5 -
 block/blk-core.c                    |  126 ++++++-
 drivers/block/drbd/drbd_req.c       |   18 +-
 drivers/block/osdblk.c              |    3 +-
 drivers/block/pktcdvd.c             |  121 +++----
 drivers/block/rbd.c                 |    8 +-
 drivers/md/dm-crypt.c               |    9 -
 drivers/md/dm-io.c                  |   11 -
 drivers/md/dm.c                     |  118 +------
 drivers/md/linear.c                 |   52 +--
 drivers/md/md.c                     |   44 +--
 drivers/md/raid0.c                  |   70 +---
 drivers/md/raid1.c                  |   34 --
 drivers/md/raid10.c                 |  100 +-----
 drivers/target/target_core_iblock.c |    9 -
 fs/bio-integrity.c                  |   44 ---
 fs/bio.c                            |  437 ++++++++++++-----------
 fs/exofs/ore.c                      |    5 +-
 include/linux/bio.h                 |   43 ++-
 include/linux/blk_types.h           |    9 +-
 include/linux/blkdev.h              |    3 +
 include/linux/closure.h             |  658 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |    8 +
 lib/Makefile                        |    2 +-
 lib/closure.c                       |  344 ++++++++++++++++++
 25 files changed, 1482 insertions(+), 799 deletions(-)
 create mode 100644 include/linux/closure.h
 create mode 100644 lib/closure.c

-- 
1.7.9.3.327.g2980b
