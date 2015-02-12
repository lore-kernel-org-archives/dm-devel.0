From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper changes for 3.20
Date: Thu, 12 Feb 2015 17:01:45 -0500
Message-ID: <20150212220145.GA27455@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Asaf Vertz <asaf.vertz@tandemg.com>, Dan Carpenter <dan.carpenter@oracle.com>, Johannes Thumshirn <morbidrsa@gmail.com>, Junxiao Bi <junxiao.bi@oracle.com>, Keith Busch <keith.busch@intel.com>, Loic Pefferkorn <loic@loicp.eu>, Manuel =?iso-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>, Markus Elfring <elfring@users.sourceforge.net>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
List-Id: dm-devel.ids

Hi Linus,

These changes build on linux-block.git's for-3.20/core branch.

The following changes since commit db507b3ffd9b7a1c87e732ac6e2c3a5d0bab=
b15a:

  dm: fix multipath regression due to initializing wrong request (2015-=
02-09 10:46:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.=
git tags/dm-3.20-changes

for you to fetch changes up to a4afe76b2b922e6197944d7be0be7a18b53175ae=
:

  dm: inherit QUEUE_FLAG_SG_GAPS flags from underlying queues (2015-02-=
11 10:25:46 -0500)

----------------------------------------------------------------
- Most significant change this cycle is request-based DM now supports
  stacking ontop of blk-mq devices.  This blk-mq support changes the
  model request-based DM uses for cloning a request to relying on
  calling blk_get_request() directly from the underlying blk-mq device.
  Early consumer of this code is Intel's emerging NVMe hardware; thanks
  to Keith Busch for working on, and pushing for, these changes.

- A few other small fixes and cleanups across other DM targets.

----------------------------------------------------------------
Asaf Vertz (1):
      dm bufio: fix time comparison to use time_after_eq()

Dan Carpenter (1):
      dm raid: fix a couple integer overflows

Johannes Thumshirn (1):
      dm mpath: simplify failure path of dm_multipath_init()

Junxiao Bi (1):
      dm ioctl: fix stale comment above dm_get_inactive_table()

Keith Busch (3):
      dm: submit stacked requests in irq enabled context
      dm: prepare for allocating blk-mq clone requests in target
      dm: inherit QUEUE_FLAG_SG_GAPS flags from underlying queues

Loic Pefferkorn (1):
      dm crypt: update url in CONFIG_DM_CRYPT help text

Manuel Sch=F6lling (1):
      dm: use time_in_range() and time_after()

Markus Elfring (1):
      dm snapshot: remove unnecessary NULL checks before vfree() calls

Mike Snitzer (4):
      dm: remove exports for request-based interfaces without external =
callers
      dm: split request structure out from dm_rq_target_io structure
      dm: allocate requests in target when stacking on blk-mq devices
      dm table: train hybrid target type detection to select blk-mq if =
appropriate

Rickard Strandqvist (1):
      dm thin metadata: remove unused dm_pool_get_data_block_size()

 drivers/md/Kconfig                 |   5 +-
 drivers/md/dm-bufio.c              |   3 +-
 drivers/md/dm-cache-target.c       |   5 +-
 drivers/md/dm-ioctl.c              |   4 +-
 drivers/md/dm-log-userspace-base.c |   5 +-
 drivers/md/dm-mpath.c              |  87 +++++++---
 drivers/md/dm-raid.c               |  16 +-
 drivers/md/dm-snap-persistent.c    |  14 +-
 drivers/md/dm-table.c              |  72 ++++++--
 drivers/md/dm-target.c             |  15 +-
 drivers/md/dm-thin-metadata.c      |   9 -
 drivers/md/dm-thin-metadata.h      |   2 -
 drivers/md/dm-thin.c               |   5 +-
 drivers/md/dm.c                    | 347 +++++++++++++++++++++++++----=
--------
 drivers/md/dm.h                    |  11 +-
 include/linux/device-mapper.h      |  10 +-
 include/uapi/linux/dm-ioctl.h      |   4 +-
 17 files changed, 416 insertions(+), 198 deletions(-)
