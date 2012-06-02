From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper updates for 3.5
Date: Sat, 2 Jun 2012 23:22:54 +0100
Message-ID: <20120602222254.GI20415@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: dm-devel.ids

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.5-changes
 
to get the following device-mapper updates for 3.5.
 
Thanks,
Alasdair

----------------------------------------------------------------
Improve multipath's retrying mechanism in some defined circumstances
and provide a simple reserve/release mechanism for userspace tools to
access thin provisioning metadata while the pool is in use.

----------------------------------------------------------------
Joe Thornber (1):
      dm thin: provide userspace access to pool metadata

Mike Christie (1):
      dm mpath: delay retry of bypassed pg

Mike Snitzer (2):
      dm mpath: reduce size of struct multipath
      dm thin: use slab mempools

Mikulas Patocka (1):
      dm mpath: allow ioctls to trigger pg init

 Documentation/device-mapper/thin-provisioning.txt |   11 ++
 drivers/md/dm-mpath.c                             |   47 +++--
 drivers/md/dm-thin-metadata.c                     |  136 +++++++++++++-
 drivers/md/dm-thin-metadata.h                     |   13 +-
 drivers/md/dm-thin.c                              |  203 ++++++++++++++-------
 5 files changed, 320 insertions(+), 90 deletions(-)
