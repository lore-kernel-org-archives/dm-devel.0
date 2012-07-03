From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] device-mapper fixes for 3.5
Date: Tue, 3 Jul 2012 14:53:10 +0100
Message-ID: <20120703135310.GT20415@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.5-fixes

to get the following device-mapper fixes for 3.5.
 
Thanks,
Alasdair
 
----------------------------------------------------------------
Four minor thin provisioning fixes and correct and update dm-verity
documentation.

----------------------------------------------------------------
Joe Thornber (1):
      dm thin: commit metadata before creating metadata snapshot

Mike Snitzer (3):
      dm persistent data: fix shadow_info_leak on dm_tm_destroy
      dm persistent data: handle space map checker creation failure
      dm persistent data: fix allocation failure in space map checker init

Milan Broz (1):
      dm: verity fix documentation

 Documentation/device-mapper/verity.txt             |  131 +++++++-------------
 drivers/md/dm-thin.c                               |    7 ++
 drivers/md/persistent-data/dm-space-map-checker.c  |   54 ++++----
 drivers/md/persistent-data/dm-space-map-disk.c     |   11 +-
 .../md/persistent-data/dm-transaction-manager.c    |   11 +-
 5 files changed, 103 insertions(+), 111 deletions(-)
