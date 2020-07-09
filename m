From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull] device mapper fixes for 5.8-rc5
Date: Thu, 9 Jul 2020 15:43:30 -0400
Message-ID: <20200709194329.GA14653@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>, Michal Suchanek <msuchanek@suse.de>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, Wei Yongjun <weiyongjun1@huawei.com>
List-Id: dm-devel.ids

Hi Linus,

The following changes since commit dcb7fd82c75ee2d6e6f9d8cc71c52519ed52e258:

  Linux 5.8-rc4 (2020-07-05 16:20:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.8/dm-fixes-2

for you to fetch changes up to 6958c1c640af8c3f40fa8a2eee3b5b905d95b677:

  dm: use noio when sending kobject event (2020-07-08 12:50:51 -0400)

Please pull, thanks!
Mike

----------------------------------------------------------------
- A request-based DM fix to not use a waitqueue to wait for blk-mq IO
  completion because doing so is racey.

- A couple more DM zoned target fixes to address issues introduced
  during the 5.8 cycle.

- A DM core fix to use proper interface to cleanup DM's static flush
  bio.

- A DM core fix to prevent mm recursion during memory allocation
  needed by dm_kobject_uevent.

----------------------------------------------------------------
Christoph Hellwig (1):
      dm: use bio_uninit instead of bio_disassociate_blkg

Damien Le Moal (1):
      dm zoned: Fix zone reclaim trigger

Michal Suchanek (1):
      dm writecache: reject asynchronous pmem devices

Mikulas Patocka (1):
      dm: use noio when sending kobject event

Ming Lei (1):
      dm: do not use waitqueue for request-based DM

Wei Yongjun (1):
      dm zoned: fix unused but set variable warnings

 drivers/md/dm-rq.c             |  4 --
 drivers/md/dm-writecache.c     |  6 +++
 drivers/md/dm-zoned-metadata.c |  9 ++++-
 drivers/md/dm-zoned-reclaim.c  |  7 ++--
 drivers/md/dm-zoned-target.c   | 10 +----
 drivers/md/dm.c                | 84 ++++++++++++++++++++++++++----------------
 6 files changed, 71 insertions(+), 49 deletions(-)
