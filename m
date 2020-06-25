From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 0/6] Overhaul memalloc_no*
Date: Thu, 25 Jun 2020 12:31:16 +0100
Message-ID: <20200625113122.7540-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

I want a memalloc_nowait like we have memalloc_noio and memalloc_nofs
for an upcoming patch series, and Jens also wants it for non-blocking
io_uring.  It turns out we already have dm-bufio which could benefit
from memalloc_nowait, so it may as well go into the tree now.

The biggest problem is that we're basically out of PF_ flags, so we need
to find somewhere else to store the PF_MEMALLOC_NOWAIT flag.  It turns
out the PF_ flags are really supposed to be used for flags which are
accessed from other tasks, and the MEMALLOC flags are only going to
be used by this task.  So shuffling everything around frees up some PF
flags and generally makes the world a better place.

Patch series also available from
http://git.infradead.org/users/willy/linux.git/shortlog/refs/heads/memalloc

Matthew Wilcox (Oracle) (6):
  mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
  mm: Add become_kswapd and restore_kswapd
  xfs: Convert to memalloc_nofs_save
  mm: Replace PF_MEMALLOC_NOFS with memalloc_nofs
  mm: Replace PF_MEMALLOC_NOIO with memalloc_nocma
  mm: Add memalloc_nowait

 drivers/block/loop.c           |  3 +-
 drivers/md/dm-bufio.c          | 30 ++++--------
 drivers/md/dm-zoned-metadata.c |  5 +-
 fs/iomap/buffered-io.c         |  2 +-
 fs/xfs/kmem.c                  |  2 +-
 fs/xfs/libxfs/xfs_btree.c      | 14 +++---
 fs/xfs/xfs_aops.c              |  4 +-
 fs/xfs/xfs_buf.c               |  2 +-
 fs/xfs/xfs_linux.h             |  6 ---
 fs/xfs/xfs_trans.c             | 14 +++---
 fs/xfs/xfs_trans.h             |  2 +-
 include/linux/sched.h          |  7 +--
 include/linux/sched/mm.h       | 84 ++++++++++++++++++++++++++--------
 kernel/sys.c                   |  8 ++--
 mm/vmscan.c                    | 16 +------
 15 files changed, 105 insertions(+), 94 deletions(-)

-- 
2.27.0
