From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 3.19
Date: Mon, 22 Dec 2014 13:41:04 -0500
Message-ID: <20141222184104.GA8054@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, zhendong chen <alex.chen@huawei.com>, Marc Dionne <marc.c.dionne@gmail.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 9b8ec916df67ba31614796037caf606b763e2e79:

  Merge branch 'for-linus' of git://git.kernel.dk/linux-block (2014-12-15 17:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.19-fixes

for you to fetch changes up to 5164bece1673cdf04782f8ed3fba70743700f5da:

  dm: fix missed error code if .end_io isn't implemented by target_type (2014-12-17 12:31:13 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
3 stable fixes and 1 fix for a regression introduced during 3.19 merge:

- Fix inability to discard used space when the thin-pool target is in
  out-of-data-space mode and also transition the thin-pool back to write
  mode once free space is made available.

- Fix DM core bio-based end_io bug that prevented proper post-processing
  of the error code returned from the block layer.

- Fix crash in DM thin-pool due to thin device being added to the pool's
  active_thins list before properly initializing the thin device's
  refcount.

----------------------------------------------------------------
Joe Thornber (2):
      dm thin: fix inability to discard blocks when in out-of-data-space mode
      dm thin: fix missing out-of-data-space to write mode transition if blocks are released

Marc Dionne (1):
      dm thin: fix crash by initializing thin device's refcount and completion earlier

zhendong chen (1):
      dm: fix missed error code if .end_io isn't implemented by target_type

 drivers/md/dm-thin.c | 29 +++++++++++++++++++++++------
 drivers/md/dm.c      |  2 +-
 2 files changed, 24 insertions(+), 7 deletions(-)
