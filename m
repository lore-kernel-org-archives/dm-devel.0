From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 4.8
Date: Tue, 26 Jul 2016 12:53:42 -0400
Message-ID: <20160726165342.GA32375@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Sami Tolvanen <samitolvanen@google.com>, Tahsin Erdogan <tahsin@google.com>, Toshi Kani <toshi.kani@hpe.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Linus,

As noted in my tag message, these DM changes for 4.8 build ontop of
Jens' block 'for-4.8/core' branch.

When pulling these DM change you will encounter a merge conflict with Jens'
'for-4.8/drivers' branch.  Like Stephen Rothwell before me, I've resolved
this merge conflict and published a reference resolution; please see the
branch named 'dm-4.8-block-drivers-merge' on my linux-dm.git tree.

Also, there are conflicts once merged with the nvdimm tree, please see:
https://lkml.org/lkml/2016/7/22/41

The following changes since commit 72ef799b3f14f4cb4c56ba3af6e6bdcbae6df368:

  block: do not merge requests without consulting with io scheduler (2016-07-20 21:35:12 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-4.8-changes

for you to fetch changes up to b5ab4a9ba5574430870391e93b125ada31217c4c:

  dm: allow bio-based table to be upgraded to bio-based with DAX support (2016-07-20 23:49:52 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- initially based on Jens' 'for-4.8/core' (given all the flag churn) and
  later merged with 'for-4.8/core' to pickup the QUEUE_FLAG_DAX commits
  that DM depends on to provide its DAX support

- clean up the bio-based vs request-based DM core code by moving the
  request-based DM core code out to dm-rq.[hc]

- reinstate bio-based support in the DM multipath target (done with the
  idea that fast storage like NVMe over Fabrics could benefit) -- while
  preserving support for request_fn and blk-mq request-based DM mpath

- SCSI and DM multipath persistent reservation fixes that were
  coordinated with Martin Petersen.

- the DM raid target saw the most extensive change this cycle; it now
  provides reshape and takeover support (by layering ontop of the
  corresponding MD capabilities)

- DAX support for DM core and the linear, stripe and error targets

- A DM thin-provisioning block discard vs allocation race fix that
  addresses potential for corruption

- A stable fix for DM verity-fec's block calculation during decode

- A few cleanups and fixes to DM core and various targets

----------------------------------------------------------------
Arnd Bergmann (1):
      dm raid: don't use 'const' in function return

Bart Van Assche (2):
      dm crypt: Fix sparse complaints
      dm ioctl: Simplify parameter buffer management code

Christoph Hellwig (2):
      sd: don't use the ALL_TG_PT bit for reservations
      dm: call PR reserve/unreserve on each underlying device

Heinz Mauelshagen (44):
      dm raid: rename variable 'ret' to 'r' to conform to other dm code
      dm raid: use dm_arg_set API in constructor
      dm raid: cleanup / provide infrastructure
      dm raid: check constructor arguments for invalid raid level/argument combinations
      dm raid: more use of flag testing wrappers
      dm raid: use rt_is_raid*() in all appropriate checks
      dm raid: introduce extended superblock and new raid types to support takeover/reshaping
      dm raid: add new reshaping/raid10 format table line options to parameter parser
      dm raid: enhance super_sync() to support new superblock members
      dm raid: add raid level takeover support
      dm raid: enhance status interface and fixup takeover/raid0
      dm raid: inverse check for flags from invalid to valid flags
      dm raid: add prerequisite functions and definitions for reshaping
      dm raid: add reshaping support to the target
      dm raid: update Documentation about reshaping/takeover/additonal RAID types
      dm raid: support to change bitmap region size
      dm raid: fix failed takeover/reshapes by keeping raid set frozen
      dm raid: avoid superfluous memory barriers on static metadata
      dm raid: prohibit to pass in both sync and nosync ctr flags
      dm raid: the sync_page_io() metadata_op argument is bool
      dm raid: reject too many write_mostly devices
      dm raid: more restricting data_offset value checks
      dm raid: remove bogus comment and fix comment typos
      dm raid: enhance comments in takeover checks
      dm raid: make rs_set_capacity to work on shrinking reshape
      dm raid: fix rs_set_capacity on growing reshape
      dm raid: clarify and fix recovery
      dm raid: prohibit 'nosync' on new raid6 and reject resize during reshape
      dm raid: fix raid10 device size error on out-of-place reshape
      dm raid: add comments and fix typos
      dm raid: fix new superblock/bitmap creation on disk addition
      dm raid: also reject size change during recovery
      dm raid: fix typo in write_mostly flag
      dm raid: fix ctr memory leaks on error paths
      dm raid: fix rebuild and catch bogus sync/resync flags
      dm raid: fix rs_is_recovering() to allow for lvextend
      dm raid: allow resize during recovery
      dm raid: enhance reshape check and factor out reshape setup
      dm raid: support delta_disks for raid1, fix table output
      dm raid: use rs->raid_disks to avoid memory leaks on free
      dm raid: use rdev_for_each in status
      dm raid: change logical functions to actually return bool
      dm raid: address checkpatch.pl complaints
      dm raid: fix random optimal_io_size for raid0

Joe Thornber (2):
      dm btree: fix a bug in dm_btree_find_next_single()
      dm thin: fix a race condition between discarding and provisioning a block

Mike Snitzer (16):
      dm: move request-based code out to dm-rq.[hc]
      dm mpath: reinstate bio-based support
      dm mpath: remove bio-based bloat from struct dm_mpath_io
      dm mpath: add optional "queue_mode" feature
      dm raid: tabify appropriate whitespace
      dm raid: remove ti_error_* wrappers
      dm raid: bump to v1.9.0 and make the extended SB feature flag reflect it
      dm raid: rename _argname_by_flag to dm_raid_arg_name_by_flag
      dm raid: add missing "dm-raid0" module alias
      dm raid: rename _in_range to __within_range
      dm raid: remove all the bitops wrappers
      dm raid: rename functions that alloc and free struct raid_set
      dm raid: various code cleanups
      dm rq: check kthread_run return for .request_fn request-based DM
      Merge remote-tracking branch 'jens/for-4.8/core' into dm-4.8
      dm error: add DAX support

Sami Tolvanen (1):
      dm verity fec: fix block calculation

Tahsin Erdogan (1):
      dm: fix second blk_delay_queue() parameter to be in msec units not jiffies

Toshi Kani (5):
      dm: add infrastructure for DAX support
      dm linear: add DAX support
      dm stripe: add DAX support
      dm snap: add fake origin_direct_access
      dm: allow bio-based table to be upgraded to bio-based with DAX support

 Documentation/device-mapper/dm-raid.txt |   58 +-
 drivers/md/Makefile                     |    3 +-
 drivers/md/dm-builtin.c                 |    2 +-
 drivers/md/dm-core.h                    |  149 ++
 drivers/md/dm-crypt.c                   |    4 +-
 drivers/md/dm-io.c                      |    2 +-
 drivers/md/dm-ioctl.c                   |   31 +-
 drivers/md/dm-kcopyd.c                  |    2 +-
 drivers/md/dm-linear.c                  |   21 +-
 drivers/md/dm-mpath.c                   |  354 +++-
 drivers/md/dm-raid.c                    | 3073 +++++++++++++++++++++++++------
 drivers/md/dm-rq.c                      |  970 ++++++++++
 drivers/md/dm-rq.h                      |   64 +
 drivers/md/dm-snap.c                    |    8 +
 drivers/md/dm-stats.c                   |    2 +-
 drivers/md/dm-stripe.c                  |   26 +-
 drivers/md/dm-sysfs.c                   |    3 +-
 drivers/md/dm-table.c                   |  114 +-
 drivers/md/dm-target.c                  |   11 +-
 drivers/md/dm-thin-metadata.c           |   30 +
 drivers/md/dm-thin-metadata.h           |    3 +
 drivers/md/dm-thin.c                    |  102 +-
 drivers/md/dm-verity-fec.c              |    4 +-
 drivers/md/dm.c                         | 1499 +++------------
 drivers/md/dm.h                         |   36 +-
 drivers/md/persistent-data/dm-btree.c   |    9 +-
 drivers/scsi/sd.c                       |    3 +-
 include/linux/device-mapper.h           |   26 +
 include/uapi/linux/dm-ioctl.h           |    4 +-
 29 files changed, 4638 insertions(+), 1975 deletions(-)
 create mode 100644 drivers/md/dm-core.h
 create mode 100644 drivers/md/dm-rq.c
 create mode 100644 drivers/md/dm-rq.h
