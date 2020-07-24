From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fix for 5.8-rc7
Date: Fri, 24 Jul 2020 13:47:38 -0400
Message-ID: <20200724174738.GA84895@lobo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit 6958c1c640af8c3f40fa8a2eee3b5b905d95b677:

  dm: use noio when sending kobject event (2020-07-08 12:50:51 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.8/dm-fixes-3

for you to fetch changes up to 5df96f2b9f58a5d2dc1f30fe7de75e197f2c25f2:

  dm integrity: fix integrity recalculation that is improperly skipped (2020-07-23 14:39:37 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- Stable fix for DM integrity target's integrity recalculation that
  gets skipped when resuming a device. This is a fix for a previous
  stable@ fix.

----------------------------------------------------------------
Mikulas Patocka (1):
      dm integrity: fix integrity recalculation that is improperly skipped

 drivers/md/dm-integrity.c     |  4 ++--
 drivers/md/dm.c               | 17 +++++++++++++++++
 include/linux/device-mapper.h |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)
