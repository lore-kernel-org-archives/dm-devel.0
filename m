From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.3
Date: Wed, 2 Sep 2015 13:39:36 -0400
Message-ID: <20150902173935.GA2231@redhat.com>
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
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 34dd051741572859bc1fef525c5ddbc127158b52:

  dm cache policy smq: move 'dm-cache-default' module alias to SMQ (2015-08-12 11:27:29 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.3-changes

for you to fetch changes up to f6faec30406fdec5bfb388faa4afd9b6bb39c366:

  dm: disable slab merging for all DM slabs (2015-09-02 08:53:47 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- a couple small cleanups in dm-cache, dm-verity, persistent-data's
  dm-btree, and DM core.

- a 4.1-stable fix for dm-cache that fixes the leaking of deferred bio
  prison cells

- a 4.2-stable fix that adds feature reporting for the dm-stats features
  added in 4.2

- improve DM-snapshot to not invalidate the on-disk snapshot if snapshot
  device write overflow occurs; but a write overflow triggered through
  the origin device will still invalidate the snapshot.

- optimize DM-thinp's async discard submission a bit now that late bio
  splitting has been included in block core.

- switch DM-cache's SMQ policy lock from using a mutex to a spinlock;
  improves performance on very low latency devices (eg. NVMe SSD).

- document DM RAID 4/5/6's discard support

- last but not least: add SLAB_NO_MERGE flag to mm/slab_common and
  disable slab merging for all of DM's slabs (XFS will also use
  SLAB_NO_MERGE once merged).

----------------------------------------------------------------
Heinz Mauelshagen (1):
      dm raid: document RAID 4/5/6 discard support

Joe Thornber (4):
      dm cache policy smq: change the mutex to a spinlock
      dm cache: move wake_waker() from free_migrations() to where it is needed
      dm cache: fix leaking of deferred bio prison cells
      dm cache: fix use after freeing migrations

Mike Snitzer (4):
      dm thin: optimize async discard submission
      dm cache: small cleanups related to deferred prison cell cleanup
      mm/slab_common: add SLAB_NO_MERGE flag for use when creating slabs
      dm: disable slab merging for all DM slabs

Mikulas Patocka (3):
      dm: test return value for DM_MAPIO_SUBMITTED
      dm snapshot: don't invalidate on-disk image on snapshot write overflow
      dm stats: report precise_timestamps and histogram in @stats_list output

Sami Tolvanen (1):
      dm verity: remove unused mempool

Vivek Goyal (3):
      dm btree: remove unused "dm_block_t root" parameter in btree_split_sibling()
      dm btree remove: remove unused function get_nr_entries()
      dm: do not override error code returned from dm_get_device()

viresh kumar (1):
      dm: remove unlikely() before IS_ERR()

 Documentation/device-mapper/dm-raid.txt       |  31 ++++++++
 Documentation/device-mapper/statistics.txt    |   4 +
 drivers/md/dm-bio-prison.c                    |   2 +-
 drivers/md/dm-bufio.c                         |   2 +-
 drivers/md/dm-cache-policy-mq.c               |   2 +-
 drivers/md/dm-cache-policy-smq.c              | 110 +++++++++-----------------
 drivers/md/dm-cache-target.c                  |  42 +++++-----
 drivers/md/dm-crypt.c                         |   4 +-
 drivers/md/dm-delay.c                         |  16 ++--
 drivers/md/dm-flakey.c                        |   6 +-
 drivers/md/dm-io.c                            |   3 +-
 drivers/md/dm-kcopyd.c                        |   4 +-
 drivers/md/dm-linear.c                        |   7 +-
 drivers/md/dm-log-userspace-base.c            |   2 +-
 drivers/md/dm-log-writes.c                    |  11 ++-
 drivers/md/dm-mpath.c                         |   3 +-
 drivers/md/dm-raid1.c                         |   8 +-
 drivers/md/dm-snap-persistent.c               |   2 +-
 drivers/md/dm-snap.c                          |  24 ++++--
 drivers/md/dm-stats.c                         |  14 +++-
 drivers/md/dm-stripe.c                        |   8 +-
 drivers/md/dm-thin.c                          |  91 ++++-----------------
 drivers/md/dm-uevent.c                        |   2 +-
 drivers/md/dm-verity.c                        |  17 +---
 drivers/md/dm.c                               |  10 +--
 drivers/md/persistent-data/dm-block-manager.c |   8 +-
 drivers/md/persistent-data/dm-btree-remove.c  |  22 ------
 drivers/md/persistent-data/dm-btree.c         |   6 +-
 include/linux/slab.h                          |   2 +
 include/uapi/linux/dm-ioctl.h                 |   4 +-
 mm/slab.h                                     |   2 +-
 mm/slab_common.c                              |   2 +-
 32 files changed, 212 insertions(+), 259 deletions(-)
