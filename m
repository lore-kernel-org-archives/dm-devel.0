From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 5.9
Date: Fri, 7 Aug 2020 12:03:27 -0400
Message-ID: <20200807160327.GA977@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Ignat Korchagin <ignat@cloudflare.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, John Dorminy <jdorminy@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 11ba468877bb23f28956a35e896356252d63c983:

  Linux 5.8-rc5 (2020-07-12 16:34:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.9/dm-changes

for you to fetch changes up to a9cb9f4148ef6bb8fabbdaa85c42b2171fbd5a0d:

  dm: don't call report zones for more than the user requested (2020-08-04 16:31:12 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- DM multipath locking fixes around m->flags tests and improvements to
  bio-based code so that it follows patterns established by
  request-based code.

- Request-based DM core improvement to eliminate unnecessary call to
  blk_mq_queue_stopped().

- Add "panic_on_corruption" error handling mode to DM verity target.

- DM bufio fix to to perform buffer cleanup from a workqueue rather
  than wait for IO in reclaim context from shrinker.

- DM crypt improvement to optionally avoid async processing via
  workqueues for reads and/or writes -- via "no_read_workqueue" and
  "no_write_workqueue" features.  This more direct IO processing
  improves latency and throughput with faster storage.  Avoiding
  workqueue IO submission for writes (DM_CRYPT_NO_WRITE_WORKQUEUE) is
  a requirement for adding zoned block device support to DM crypt.

- Add zoned block device support to DM crypt.  Makes use of
  DM_CRYPT_NO_WRITE_WORKQUEUE and a new optional feature
  (DM_CRYPT_WRITE_INLINE) that allows write completion to wait for
  encryption to complete.  This allows write ordering to be preserved,
  which is needed for zoned block devices.

- Fix DM ebs target's check for REQ_OP_FLUSH.

- Fix DM core's report zones support to not report more zones than
  were requested.

- A few small compiler warning fixes.

- DM dust improvements to return output directly to the user rather
  than require they scrape the system log for output.

----------------------------------------------------------------
Damien Le Moal (5):
      dm crypt: Enable zoned block device support
      dm verity: Fix compilation warning
      dm raid: Remove empty if statement
      dm ioctl: Fix compilation warning
      dm init: Set file local variable static

Ignat Korchagin (1):
      dm crypt: add flags to optionally bypass kcryptd workqueues

JeongHyeon Lee (1):
      dm verity: add "panic_on_corruption" error handling mode

Johannes Thumshirn (1):
      dm: don't call report zones for more than the user requested

John Dorminy (1):
      dm ebs: Fix incorrect checking for REQ_OP_FLUSH

Mike Snitzer (7):
      dm mpath: changes from initial m->flags locking audit
      dm mpath: take m->lock spinlock when testing QUEUE_IF_NO_PATH
      dm mpath: push locking down to must_push_back_rq()
      dm mpath: factor out multipath_queue_bio
      dm mpath: rework __map_bio()
      dm mpath: rename current_pgpath to pgpath in multipath_prepare_ioctl
      dm mpath: use double checked locking in fast path

Mikulas Patocka (1):
      dm bufio: do buffer cleanup from a workqueue

Ming Lei (1):
      dm rq: don't call blk_mq_queue_stopped() in dm_stop_queue()

yangerkun (2):
      dm dust: report some message results directly back to user
      dm dust: add interface to list all badblocks

 .../admin-guide/device-mapper/dm-dust.rst          |  32 ++++-
 Documentation/admin-guide/device-mapper/verity.rst |   4 +
 drivers/md/dm-bufio.c                              |  60 ++++++---
 drivers/md/dm-crypt.c                              | 129 ++++++++++++++++--
 drivers/md/dm-dust.c                               |  58 ++++++--
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-init.c                               |   2 +-
 drivers/md/dm-ioctl.c                              |   2 +-
 drivers/md/dm-mpath.c                              | 146 ++++++++++++++-------
 drivers/md/dm-raid.c                               |   2 -
 drivers/md/dm-rq.c                                 |   3 -
 drivers/md/dm-verity-target.c                      |  13 +-
 drivers/md/dm-verity-verify-sig.h                  |  14 +-
 drivers/md/dm-verity.h                             |   3 +-
 drivers/md/dm.c                                    |   3 +-
 15 files changed, 355 insertions(+), 118 deletions(-)
