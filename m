From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 3.16-rc5
Date: Fri, 11 Jul 2014 09:52:00 -0400
Message-ID: <20140711135200.GA15970@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bart Van Assche <bvanassche@acm.org>, Jana Saout <jana@saout.de>, Minfei Huang <huangminfei@ucloud.cn>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:

  Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.16-fixes

for you to fetch changes up to 7a7a3b45fed9a144dbf766ee842a4c5d0632b81d:

  dm mpath: fix IO hang due to logic bug in multipath_busy (2014-07-10 16:44:15 -0400)

All fixes are marked for stable.

Please pull, thanks.
Mike

----------------------------------------------------------------
. Fix DM multipath IO hang regression from 3.15 due to logic bug in
  multipath_busy.  This impacted cable-pull testing and also the ability
  to boot with IPR SCSI on a POWER8 box.

. Fix possible deadlock with deferred device removal by using a new
  dedicated workqueue rather than using the system workqueue.

. Fix NULL pointer crash due to race condition in dm-io's wake up code
  for sync_io by using a completion.

. Update dm-crypt and dm-zero author name following legal name change;
  this is important to Jana so I didn't see any reason to hold it back.

----------------------------------------------------------------
Jana Saout (1):
      dm crypt, dm zero: update author name following legal name change

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Jun'ichi Nomura (1):
      dm mpath: fix IO hang due to logic bug in multipath_busy

Mikulas Patocka (1):
      dm: allocate a special workqueue for deferred device removal

 drivers/md/dm-crypt.c |  4 ++--
 drivers/md/dm-io.c    | 22 ++++++++--------------
 drivers/md/dm-mpath.c |  5 +++--
 drivers/md/dm-zero.c  |  4 ++--
 drivers/md/dm.c       | 15 +++++++++++++--
 5 files changed, 28 insertions(+), 22 deletions(-)
