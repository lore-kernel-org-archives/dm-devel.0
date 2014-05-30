From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 3.15 final
Date: Thu, 29 May 2014 20:57:15 -0400
Message-ID: <20140530005715.GA9179@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 4cdd2ad78098244c1bc9ec4374ea1c225fd1cd6f:

  dm mpath: fix lock order inconsistency in multipath_ioctl (2014-05-14 16:12:17 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.15-fixes-3

for you to fetch changes up to 63d832c30142cdceb478b1cac7d943d83b95b2dc:

  dm mpath: really fix lockdep warning (2014-05-27 10:46:01 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
A dm-cache stable fix to split discards on cache block boundaries
because dm-cache cannot yet handle discards that span cache blocks.

Really fix a dm-mpath LOCKDEP warning that was introduced in -rc1.

Add a 'no_space_timeout' control to dm-thinp to restore the ability to
queue IO indefinitely when no data space is available.  This fixes a
change in behavior that was introduced in -rc6 where the timeout
couldn't be disabled.

----------------------------------------------------------------
Hannes Reinecke (1):
      dm mpath: really fix lockdep warning

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Mike Snitzer (1):
      dm thin: add 'no_space_timeout' dm-thin-pool module param

 Documentation/device-mapper/thin-provisioning.txt |  5 ++++-
 drivers/md/dm-cache-target.c                      |  2 ++
 drivers/md/dm-mpath.c                             | 14 ++++++++------
 drivers/md/dm-thin.c                              | 12 +++++++++---
 4 files changed, 23 insertions(+), 10 deletions(-)
