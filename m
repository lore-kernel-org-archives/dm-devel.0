From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] 3.6 device-mapper fixes
Date: Thu, 27 Sep 2012 03:19:09 +0100
Message-ID: <20120927021909.GF24740@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, David Jeffery <djeffery@redhat.com>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.6-fixes
 
to get the following device-mapper fixes.

----------------------------------------------------------------
A few fixes for problems discovered during the 3.6 cycle.

Of particular note, are fixes to the thin target's discard support,
which I hope is finally working correctly; and fixes for multipath
ioctls and device limits when there are no paths.

----------------------------------------------------------------
Mike Snitzer (6):
      dm thin: do not set discard_zeroes_data
      dm mpath: only retry ioctl when no paths if queue_if_no_path set
      dm: handle requests beyond end of device instead of using BUG_ON
      dm: retain table limits when swapping to new table with no devices
      dm thin: tidy discard support
      dm thin: fix discard support for data devices

Mikulas Patocka (1):
      dm verity: fix overflow check

Milan Broz (1):
      dm table: clear add_random unless all devices have it set

 drivers/md/dm-mpath.c  |   11 ++--
 drivers/md/dm-table.c  |   61 ++++++++++++++++++++--
 drivers/md/dm-thin.c   |  135 +++++++++++++++++++++++++++++++-----------------
 drivers/md/dm-verity.c |    8 +--
 drivers/md/dm.c        |   71 ++++++++++++++++++-------
 drivers/md/dm.h        |    1 +
 6 files changed, 209 insertions(+), 78 deletions(-)
