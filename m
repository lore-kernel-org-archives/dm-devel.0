From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes to include in 3.14
Date: Fri, 14 Mar 2014 11:46:36 -0400
Message-ID: <20140314154635.GA23793@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

The following changes since commit cebc2de44d3bce53e46476e774126c298ca2c8a9:

  dm space map metadata: fix refcount decrement below 0 which caused corruption (2014-03-07 12:02:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.14-fixes-4

for you to fetch changes up to e893fba90c09f9b57fb97daae204ea9cc2c52fa5:

  dm cache: fix access beyond end of origin device (2014-03-12 13:52:00 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Two small fixes for the DM cache target:
- fix corruption with >2TB fast device due to truncation bug
- fix access beyond end of origin device due to a partial block

----------------------------------------------------------------
Heinz Mauelshagen (2):
      dm cache: fix truncation bug when copying a block to/from >2TB fast device
      dm cache: fix access beyond end of origin device

 drivers/md/dm-cache-target.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)
