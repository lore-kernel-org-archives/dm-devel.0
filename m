From: NeilBrown <neilb@suse.de>
Subject: [PATCH 00/24] dm-raid456 support using md/raid5.c, now with dirty-log
Date: Tue, 01 Jun 2010 19:56:18 +1000
Message-ID: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Nearly two months ago I posted my first serious attempt and making
md/raid5.c work as a dm target.  I met with cautious approval I think,
but as it didn't interact with dirty-logs yet it wasn't really read
for prime time.

It has taken longer than I hoped, but here is version 2, now with
dirty-log integration.
I have done a modest amount of testing, watching the bits in the log
getting cleared and set just as you would expect, and watching the
resync complete instantly when the dirty-log shows that all regions
are clean.

There is not even a hint of cluster support yet, but that shouldn't be
necessary for initial submission to mainline.

A significant difference to Heinz' dm-raid45 is that I only honour the
table options that lvm actually sets.  The extra ones don't really fit
with md/raid5 and I don't think they need to be table options.  If any
are needed they might work OK as messages (???).

There are a number of changes to core-dm in here including:
  - support for targets to be unplugged when the device is
  - support for targets to report congestion beyond the congestion
    of component devices
  - support for the dirty-log to cover and extent different from the
    size of the target (For raid5 it must be the size of the
    components).
I have tried to fit these to the general style of dm as best as I can.

There is certainly room for more testing and review, but I would like
to see this entering -next soon with a view to seeing it merged in the
next merge window.

Is this reasonable?  Achievable?

Comments?

These patches can all be found on the "md-dm-raid45" branch of
   git://neil.brown.name/md/
or at http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/md-dm-raid45


Thanks,
NeilBrown


---

NeilBrown (24):
      md: reduce dependence on sysfs.
      md/raid5: factor out code for changing size of stripe cache.
      md/raid5: ensure we create a unique name for kmem_cache when mddev has no gendisk
      md: be more careful setting MD_CHANGE_CLEAN
      md: split out md_rdev_init
      md: export various start/stop interfaces
      md/dm: create dm-raid456 module using md/raid5
      dm-raid456: add support for raising events to userspace.
      raid5: Don't set read-ahead when there is no queue
      dm-raid456: add congestion checking.
      md/raid5: add simple plugging infrastructure.
      md/plug: optionally use plugger to unplug an array during resync/recovery.
      dm-raid456: support unplug
      dm-raid456: add support for setting IO hints.
      dm-raid456: add suspend/resume method
      dm-raid456: add message handler.
      md/bitmap: white space clean up and similar.
      md/bitmap: reduce dependence on sysfs.
      md/bitmap: clean up plugging calls.
      md/bitmap: optimise scanning of empty bitmaps.
      dm-dirty-log: allow log size to be different from target size.
      md/bitmap: prepare for storing write-intent-bitmap via dm-dirty-log.
      md/bitmap:  separate out loading a bitmap from initialising the structures.
      dm-raid456: switch to use dm_dirty_log for tracking dirty regions.


 drivers/md/Kconfig                 |    8 +
 drivers/md/Makefile                |    1 
 drivers/md/bitmap.c                |  508 +++++++++++++++++---------------
 drivers/md/bitmap.h                |    6 
 drivers/md/dm-log-userspace-base.c |   11 -
 drivers/md/dm-log.c                |   18 +
 drivers/md/dm-raid1.c              |    4 
 drivers/md/dm-raid456.c            |  576 ++++++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c              |   19 +
 drivers/md/md.c                    |  234 +++++++++------
 drivers/md/md.h                    |   51 +++
 drivers/md/raid5.c                 |  169 ++++++-----
 drivers/md/raid5.h                 |    8 -
 include/linux/device-mapper.h      |   13 +
 include/linux/dm-dirty-log.h       |    3 
 15 files changed, 1235 insertions(+), 394 deletions(-)
 create mode 100644 drivers/md/dm-raid456.c

-- 

