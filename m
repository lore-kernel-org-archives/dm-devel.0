From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.2
Date: Thu, 25 Jun 2015 10:53:42 -0400
Message-ID: <20150625145341.GA8584@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis Henriques <luis.henriques@canonical.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Pekka Enberg <penberg@kernel.org>, dm-devel@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>, Lidong Zhong <lzhong@suse.com>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

I've built the DM changes for 4.2 ontop of the block tree (hence the
jens/for-4.2/core merge).

The following changes since commit 183f7802e73e26206558864d1b67e64382257277:

  Merge remote-tracking branch 'jens/for-4.2/core' into dm-4.2 (2015-05-29 14:17:16 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.2-changes

for you to fetch changes up to e262f34741522e0d821642e5449c6eeb512723fc:

  dm stats: add support for request-based DM devices (2015-06-17 12:40:41 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- DM core cleanups
  - blk-mq request-based DM no longer uses any mempools now that partial
    completions are no longer handled as part of cloned requests

- DM raid cleanups and support for MD raid0

- DM cache core advances and a new stochastic-multi-queue (smq) cache
  replacement policy
  - smq is the new default dm-cache policy

- DM thinp cleanups and much more efficient large discard support

- DM statistics support for request-based DM and nanosecond resolution
  timestamps

- Fixes to DM stripe, DM log-writes, DM raid1 and DM crypt

----------------------------------------------------------------
Geert Uytterhoeven (1):
      dm log writes: use ULL suffix for 64-bit constants

Heinz Mauelshagen (3):
      dm raid: fixup documentation for discard support
      dm raid: a few cleanups
      dm raid: add support for the MD RAID0 personality

Joe Thornber (18):
      dm cache: fix race when issuing a POLICY_REPLACE operation
      dm cache: add io_tracker
      dm cache: track IO to the origin device using io_tracker
      dm cache: pass a new 'critical' flag to the policies when requesting writeback work
      dm cache: pull out some bitset utility functions for reuse
      dm bio prison: add dm_cell_promote_or_release()
      dm cache: defer whole cells
      dm cache: boost promotion of blocks that will be overwritten
      dm cache: add stochastic-multi-queue (smq) policy
      dm cache: wake the worker thread every time we free a migration object
      dm cache: add fail io mode and needs_check flag
      dm cache: age and write back cache entries even without active IO
      dm btree: add dm_btree_remove_leaves()
      dm thin metadata: add dm_thin_find_mapped_range()
      dm thin metadata: add dm_thin_remove_range()
      dm thin: range discard support
      dm thin metadata: fix a race when entering fail mode
      dm space map metadata: fix occasional leak of a metadata block on resize

Lidong Zhong (1):
      dm raid1: keep issuing IO after leg failure

Luis Henriques (1):
      dm stripe: drop useless exit point from dm_stripe_init()

Mike Snitzer (9):
      dm: do not allocate any mempools for blk-mq request-based DM
      dm: cleanup methods that requeue requests
      dm: factor out a common cleanup_mapped_device()
      dm thin: cleanup overwrite's endio restore to be centralized
      dm thin: cleanup schedule_zero() to read more logically
      dm thin metadata: remove in-core 'read_only' flag
      dm cache: prefix all DMERR and DMINFO messages with cache device name
      dm thin: fail messages with EOPNOTSUPP when pool cannot handle messages
      dm cache: switch the "default" cache replacement policy from mq to smq

Mikulas Patocka (4):
      dm stats: fix divide by zero if 'number_of_areas' arg is zero
      dm stats: support precise timestamps
      dm stats: collect and report histogram of IO latencies
      dm stats: add support for request-based DM devices

Milan Broz (1):
      dm crypt: add comments to better describe crypto processing logic

Pekka Enberg (1):
      dm stats: Use kvfree() in dm_kvfree()

 Documentation/device-mapper/cache-policies.txt     |   67 +-
 Documentation/device-mapper/cache.txt              |    9 +-
 Documentation/device-mapper/dm-raid.txt            |    2 +
 Documentation/device-mapper/statistics.txt         |   41 +-
 drivers/md/Kconfig                                 |   12 +
 drivers/md/Makefile                                |    2 +
 drivers/md/dm-bio-prison.c                         |   26 +
 drivers/md/dm-bio-prison.h                         |   13 +
 drivers/md/dm-cache-metadata.c                     |  133 +-
 drivers/md/dm-cache-metadata.h                     |   10 +
 drivers/md/dm-cache-policy-cleaner.c               |    6 +-
 drivers/md/dm-cache-policy-internal.h              |   52 +-
 drivers/md/dm-cache-policy-mq.c                    |   93 +-
 drivers/md/dm-cache-policy-smq.c                   | 1791 ++++++++++++++++++++
 drivers/md/dm-cache-policy.h                       |   30 +-
 drivers/md/dm-cache-target.c                       |  832 +++++++--
 drivers/md/dm-crypt.c                              |   30 +-
 drivers/md/dm-log-writes.c                         |    4 +-
 drivers/md/dm-raid.c                               |  225 +--
 drivers/md/dm-raid1.c                              |   75 +-
 drivers/md/dm-stats.c                              |  341 +++-
 drivers/md/dm-stats.h                              |    4 +-
 drivers/md/dm-stripe.c                             |    4 +-
 drivers/md/dm-table.c                              |    4 +-
 drivers/md/dm-thin-metadata.c                      |  124 +-
 drivers/md/dm-thin-metadata.h                      |   11 +
 drivers/md/dm-thin.c                               |  612 +++++--
 drivers/md/dm.c                                    |  190 ++-
 drivers/md/persistent-data/dm-block-manager.c      |    6 +
 drivers/md/persistent-data/dm-block-manager.h      |    1 +
 drivers/md/persistent-data/dm-btree-remove.c       |  127 ++
 drivers/md/persistent-data/dm-btree.h              |    9 +
 drivers/md/persistent-data/dm-space-map-metadata.c |   50 +-
 33 files changed, 4213 insertions(+), 723 deletions(-)
 create mode 100644 drivers/md/dm-cache-policy-smq.c
