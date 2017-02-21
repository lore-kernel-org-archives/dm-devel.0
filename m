From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.11
Date: Tue, 21 Feb 2017 14:26:05 -0500
Message-ID: <20170221192604.GA95281@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Bhumika Goyal <bhumirks@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 7a308bb3016f57e5be11a677d15b821536419d36:

  Linux 4.10-rc5 (2017-01-22 12:54:15 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-4.11-changes

for you to fetch changes up to d67a5f4b5947aba4bfe9a80a2b86079c215ca755:

  dm: flush queued bios when process blocks to avoid deadlock (2017-02-17 00:54:10 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Fix dm-raid transient device failure processing and other smaller
  tweaks.

- Add journal support to the DM raid target to close the 'write hole' on
  raid 4/5/6.

- Fix dm-cache corruption, due to rounding bug, when cache exceeds 2TB.

- Add 'metadata2' feature to dm-cache to separate the dirty bitset out
  from other cache metadata.  This improves speed of shutting down
  a large cache device (which implies writing out dirty bits).

- Fix a memory leak during dm-stats data structure destruction.

- Fix a DM multipath round-robin path selector performance regression
  that was caused by less precise balancing across all paths.

- Lastly, introduce a DM core fix for a long-standing DM snapshot
  deadlock that is rooted in the complexity of the device stack used in
  conjunction with block core maintaining bios on current->bio_list to
  manage recursion in generic_make_request().  A more comprehensive fix
  to block core (and its hook in the cpu scheduler) would be wonderful
  but this DM-specific fix is pragmatic considering how difficult it has
  been to make progress on a generic fix.

----------------------------------------------------------------
Bhumika Goyal (1):
      dm space map metadata: constify dm_space_map structures

Heinz Mauelshagen (5):
      dm raid: fix transient device failure processing
      dm raid: be prepared to accept arbitrary '- -' tuples
      dm raid: add raid4/5/6 journaling support
      dm raid: use read_disk_sb() throughout
      dm raid: use mddev rather than rdev->mddev

Joe Thornber (10):
      dm cache: fix corruption seen when using cache > 2TB
      dm block manager: add unlikely() annotations on dm_bufio error paths
      dm space map common: memcpy the disk root to ensure it's arch aligned
      dm btree: use GFP_NOFS in dm_btree_del()
      dm bitset: introduce cursor api
      dm cache metadata: use bitset cursor api to load discard bitset
      dm cache metadata: add "metadata2" feature
      dm bitset: add dm_bitset_new()
      dm cache metadata: use dm_bitset_new() to create the dirty bitset in format 2
      dm persistent data: add cursor skip functions to the cursor APIs

Mike Snitzer (4):
      dm raid: cleanup awkward branching in raid_message() option processing
      dm cache metadata: name the cache block that couldn't be loaded
      dm cache metadata: use cursor api in blocks_are_clean_separate_dirty()
      dm round robin: revert "use percpu 'repeat_count' and 'current_path'"

Mikulas Patocka (2):
      dm stats: fix a leaked s->histogram_boundaries array
      dm: flush queued bios when process blocks to avoid deadlock

 Documentation/device-mapper/cache.txt              |   4 +
 Documentation/device-mapper/dm-raid.txt            |  17 +
 drivers/md/dm-cache-metadata.c                     | 353 +++++++++++++++++----
 drivers/md/dm-cache-metadata.h                     |  11 +-
 drivers/md/dm-cache-target.c                       |  44 +--
 drivers/md/dm-raid.c                               | 296 ++++++++++++-----
 drivers/md/dm-round-robin.c                        |  67 +---
 drivers/md/dm-stats.c                              |   1 +
 drivers/md/dm.c                                    |  55 ++++
 drivers/md/persistent-data/dm-array.c              |  21 ++
 drivers/md/persistent-data/dm-array.h              |   1 +
 drivers/md/persistent-data/dm-bitset.c             | 146 +++++++++
 drivers/md/persistent-data/dm-bitset.h             |  39 +++
 drivers/md/persistent-data/dm-block-manager.c      |   8 +-
 drivers/md/persistent-data/dm-btree.c              |  18 +-
 drivers/md/persistent-data/dm-btree.h              |   1 +
 drivers/md/persistent-data/dm-space-map-common.c   |  16 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   4 +-
 18 files changed, 875 insertions(+), 227 deletions(-)
