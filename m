From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 0/8] dm-raid (raid456) target
Date: Mon, 20 Dec 2010 21:37:37 -0500
Message-ID: <1292899065-31943-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jbrassow@redhat.com, neilb@suse.de
Cc: agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

I reviewed all patches and adjusted patch headers in preparation for
inclusion in Alasdair's tree (upstream target being v2.6.38).  The 2
md/bitmap changes can obviously go through Neil's MD tree if that is
preferred.

- added Copyright to the top of dm-raid.c
- fixed drivers/md/Kconfig so that DM_RAID will select MD_RAID456
- removed unused 'conf' variable in raid_status()
- few misc style and whitespace changes

Neil,
Hopefully you're comfortable with the authorship of most of these
patches still being attributed to you (despite Jon's changes to your
original patches).

Please advise, thanks!
Mike

Jonathan Brassow (2):
  md/bitmap: revert dm-dirty-log preparation
  md/raid5: use sysfs_notify_dirent_safe to avoid NULL pointer

NeilBrown (6):
  md/bitmap: use DIV_ROUND_UP in bitmap_init_from_disk
  dm raid: skeleton raid456 target support
  dm: introduce target callbacks and congestion fn
  dm: unplug callback
  dm raid: add iterate_devices and io_hints functions
  dm raid: add suspend and resume functions

 drivers/md/Kconfig            |   23 ++
 drivers/md/Makefile           |    1 +
 drivers/md/bitmap.c           |  139 +++------
 drivers/md/bitmap.h           |    5 -
 drivers/md/dm-raid.c          |  664 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-table.c         |   19 ++
 drivers/md/md.h               |    5 -
 drivers/md/raid5.c            |    2 +-
 include/linux/device-mapper.h |   13 +
 9 files changed, 766 insertions(+), 105 deletions(-)
 create mode 100644 drivers/md/dm-raid.c

-- 
1.7.2.3

