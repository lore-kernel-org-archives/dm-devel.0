From: Alasdair G Kergon <agk@redhat.com>
Subject: [git pull] Further device-mapper fixes for 3.5
Date: Fri, 20 Jul 2012 15:28:21 +0100
Message-ID: <20120720142821.GC20415@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Please pull from:
 
  git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm tags/dm-3.5-fixes-2

to get the following further device-mapper fixes for 3.5.
 
Thanks,
Alasdair
  
----------------------------------------------------------------
Three fixes for device-mapper discard processing:
  - avoid a crash in dm-raid1 when discards coincide with mirror recovery;
  - avoid discarding shared data that's still needed in dm-thin;
  - don't guarantee that discarded blocks will be wiped in dm-raid1.

----------------------------------------------------------------
Mikulas Patocka (3):
      dm raid1: fix crash with mirror recovery and discard
      dm thin: do not send discards to shared blocks
      dm raid1: set discard_zeroes_data_unsupported

 drivers/md/dm-raid1.c       |    3 ++-
 drivers/md/dm-region-hash.c |    5 ++++-
 drivers/md/dm-thin.c        |    6 +++++-
 3 files changed, 11 insertions(+), 3 deletions(-)
