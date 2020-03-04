From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.6-rc5
Date: Wed, 4 Mar 2020 10:02:57 -0500
Message-ID: <20200304150257.GA19885@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Hou Tao <houtao1@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 47ace7e012b9f7ad71d43ac9063d335ea3d6820b:

  dm: fix potential for q->make_request_fn NULL pointer (2020-01-27 14:52:36 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.6/dm-fixes

for you to fetch changes up to 636be4241bdd88fec273b38723e44bad4e1c4fae:

  dm: bump version of core and various targets (2020-03-03 11:10:21 -0500)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Fix request-based DM's congestion_fn and actually wire it up to the
  bdi.

- Extend dm-bio-record to track additional struct bio members needed
  by DM integrity target.

- Fix DM core to properly advertise that a device is suspended during
  unload (between the presuspend and postsuspend hooks).  This change
  is a prereq for related DM integrity and DM writecache fixes.  It
  elevates DM integrity's 'suspending' state tracking to DM core.

- Four stable fixes for DM integrity target.

- Fix crash in DM cache target due to incorrect work item cancelling.

- Fix DM thin metadata lockdep warning that was introduced during 5.6
  merge window.

- Fix DM zoned target's chunk work refcounting that regressed during
  recent conversion to refcount_t.

- Bump the minor version for DM core and all target versions that have
  seen interface changes or important fixes during the 5.6 cycle.

----------------------------------------------------------------
Hou Tao (1):
      dm: fix congested_fn for request-based device

Mike Snitzer (3):
      dm bio record: save/restore bi_end_io and bi_integrity
      dm integrity: use dm_bio_record and dm_bio_restore
      dm: bump version of core and various targets

Mikulas Patocka (6):
      dm integrity: fix recalculation when moving from journal mode to bitmap mode
      dm integrity: fix a deadlock due to offloading to an incorrect workqueue
      dm integrity: fix invalid table returned due to argument count mismatch
      dm cache: fix a crash due to incorrect work item cancelling
      dm: report suspended device during destroy
      dm writecache: verify watermark during resume

Shin'ichiro Kawasaki (1):
      dm zoned: Fix reference counter initial value of chunk works

Theodore Ts'o (1):
      dm thin metadata: fix lockdep complaint

 drivers/md/dm-bio-record.h    | 15 ++++++++
 drivers/md/dm-cache-target.c  |  6 ++--
 drivers/md/dm-integrity.c     | 84 ++++++++++++++++++++++---------------------
 drivers/md/dm-mpath.c         |  2 +-
 drivers/md/dm-thin-metadata.c |  2 +-
 drivers/md/dm-verity-target.c |  2 +-
 drivers/md/dm-writecache.c    | 16 ++++++---
 drivers/md/dm-zoned-target.c  | 10 +++---
 drivers/md/dm.c               | 22 ++++++------
 include/uapi/linux/dm-ioctl.h |  4 +--
 10 files changed, 94 insertions(+), 69 deletions(-)
