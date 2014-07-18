From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 3.16-rc6
Date: Thu, 17 Jul 2014 23:03:58 -0400
Message-ID: <20140718030358.GA22198@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 7a7a3b45fed9a144dbf766ee842a4c5d0632b81d:

  dm mpath: fix IO hang due to logic bug in multipath_busy (2014-07-10 16:44:15 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.16-fixes-2

for you to fetch changes up to 048e5a07f282c57815b3901d4a68a77fa131ce0a:

  dm cache metadata: do not allow the data block size to change (2014-07-15 14:07:50 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Fix the dm-thinp and dm-cache targets to disallow changing the data
device's block size.

----------------------------------------------------------------
Mike Snitzer (2):
      dm thin metadata: do not allow the data block size to change
      dm cache metadata: do not allow the data block size to change

 drivers/md/dm-cache-metadata.c | 9 +++++++++
 drivers/md/dm-thin-metadata.c  | 9 +++++++++
 2 files changed, 18 insertions(+)
