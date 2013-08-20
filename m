From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device-mapper fix for 3.11
Date: Tue, 20 Aug 2013 16:15:45 -0400
Message-ID: <20130820201018.GA5192@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org, agk@redhat.com
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm tags/dm-3.11-fixes

for you to fetch changes up to b936bf8b785f0fbe083d203049e4da1c56ec788f:

  dm cache: avoid conflicting remove_mapping() in mq policy (2013-08-16 15:56:51 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
A patch to fix dm-cache-policy-mq's remove_mapping() conflict with sparc32.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      dm cache: avoid conflicting remove_mapping() in mq policy

 drivers/md/dm-cache-policy-mq.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)
