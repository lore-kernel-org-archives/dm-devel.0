From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] 3.7 device-mapper changes
Date: Fri, 12 Oct 2012 23:52:36 +0100
Message-ID: <20121012225236.GA32617@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bill Pemberton <wfp5p@viridian.itc.virginia.edu>, linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Kent Overstreet <koverstreet@google.com>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, Jens Axboe <axboe@kernel.dk>, tj@kernel.org, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.7-changes
 
to get the following device-mapper changes for 3.7.

Thanks,
Alasdair

----------------------------------------------------------------
Remove the power-of-2 block size constraint on discards in dm thin
provisioning and factor the bio_prison code out into a separate
module (for sharing with the forthcoming cache target).

Use struct bio's front_pad to eliminate the use of one separate mempool
by bio-based devices.

A few other tiny clean-ups.

----------------------------------------------------------------
Mike Snitzer (3):
      dm thin: support discard with non power of two block size
      dm thin: prepare to separate bio_prison code
      dm thin: move bio_prison code to separate module

Mikulas Patocka (2):
      dm: use ACCESS_ONCE for sysfs values
      dm: store dm_target_io in bio front_pad

Wei Yongjun (3):
      dm mpath: fix check for null mpio in end_io fn
      dm bufio: use list_move
      dm persistent data: convert to use le32_add_cpu

 drivers/md/Kconfig                               |    8 +
 drivers/md/Makefile                              |    1 +
 drivers/md/dm-bio-prison.c                       |  415 +++++++++++++++++
 drivers/md/dm-bio-prison.h                       |   72 +++
 drivers/md/dm-bufio.c                            |   13 +-
 drivers/md/dm-mpath.c                            |    3 +-
 drivers/md/dm-thin.c                             |  521 ++++------------------
 drivers/md/dm-verity.c                           |    2 +-
 drivers/md/dm.c                                  |  108 ++---
 drivers/md/persistent-data/dm-space-map-common.c |    4 +-
 10 files changed, 636 insertions(+), 511 deletions(-)
 create mode 100644 drivers/md/dm-bio-prison.c
 create mode 100644 drivers/md/dm-bio-prison.h
