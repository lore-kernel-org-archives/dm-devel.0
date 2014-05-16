From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 3.15-rc6
Date: Fri, 16 May 2014 10:51:15 -0400
Message-ID: <20140516145115.GA29451@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.15-fixes-2

for you to fetch changes up to 4cdd2ad78098244c1bc9ec4374ea1c225fd1cd6f:

  dm mpath: fix lock order inconsistency in multipath_ioctl (2014-05-14 16:12:17 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
A dm-crypt fix for a cpu hotplug crash that switches from using per-cpu
data to a mempool allocation (which offers allocation with cpu locality,
and there is no inter-cpu communication on slab allocation).

A couple dm-thinp stable fixes to address "out-of-data-space" issues.

A dm-multipath fix for a LOCKDEP warning introduced in 3.15-rc1.

----------------------------------------------------------------
Joe Thornber (2):
      dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode
      dm thin: add timeout to stop out-of-data-space mode holding IO forever

Mike Snitzer (1):
      dm mpath: fix lock order inconsistency in multipath_ioctl

Mikulas Patocka (1):
      dm crypt: fix cpu hotplug crash by removing per-cpu structure

 drivers/md/dm-crypt.c | 61 ++++++++++-----------------------------------------
 drivers/md/dm-mpath.c |  2 +-
 drivers/md/dm-thin.c  | 23 ++++++++++++++++++-
 3 files changed, 35 insertions(+), 51 deletions(-)
