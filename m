From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 0/1] block: fix blk_queue_split() resource exhaustion
Date: Fri,  8 Jul 2016 17:04:02 +0200
Message-ID: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

Result of RFC previously discussed here:
https://lkml.org/lkml/2016/6/22/172
[RFC] block: fix blk_queue_split() resource exhaustion

Rebased to linux-block/for-4.8/core as of today.
Would also need to go to Stable 4.3 and later.

Lars Ellenberg (1):
  block: fix blk_queue_split() resource exhaustion

 block/bio.c               | 27 +++++++++++++++++--------
 block/blk-core.c          | 50 +++++++++++++++++++++++++----------------------
 block/blk-merge.c         |  5 ++++-
 drivers/md/bcache/btree.c | 12 ++++++------
 drivers/md/dm-bufio.c     |  2 +-
 drivers/md/md.h           |  7 +++++++
 drivers/md/raid1.c        |  5 ++---
 drivers/md/raid10.c       |  5 ++---
 include/linux/bio.h       | 18 +++++++++++++++++
 include/linux/sched.h     |  4 ++--
 10 files changed, 88 insertions(+), 47 deletions(-)

-- 
1.9.1

