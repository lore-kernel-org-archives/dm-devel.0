From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 0/4] eliminate SECTOR related magic numbers and duplicated conversions
Date: Tue, 5 May 2020 19:55:39 +0800
Message-ID: <20200505115543.1660-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
List-Id: dm-devel.ids

When I studied the code of mm/swap, I found "1 << (PAGE_SHIFT - 9)" appears
many times. So I try to clean up it.

1. Replace "1 << (PAGE_SHIFT - 9)" or similar with SECTORS_PER_PAGE
2. Replace "PAGE_SHIFT - 9" with SECTORS_PER_PAGE_SHIFT
3. Replace "9" with SECTOR_SHIFT
4. Replace "512" with SECTOR_SIZE

No functional change.

Zhen Lei (4):
  block: Move SECTORS_PER_PAGE and SECTORS_PER_PAGE_SHIFT definitions
    into <linux/blkdev.h>
  mm/swap: use SECTORS_PER_PAGE_SHIFT to clean up code
  block: use SECTORS_PER_PAGE_SHIFT and SECTORS_PER_PAGE to clean up
    code
  mtd: eliminate SECTOR related magic numbers

 block/blk-settings.c          |  8 ++++----
 block/partitions/core.c       |  4 ++--
 drivers/block/zram/zram_drv.h |  2 --
 drivers/md/dm-table.c         |  2 +-
 drivers/md/raid1.c            |  4 ++--
 drivers/md/raid10.c           | 10 +++++-----
 drivers/md/raid5-cache.c      | 10 +++++-----
 include/linux/blkdev.h        | 10 ++++++++--
 mm/page_io.c                  |  4 ++--
 mm/swapfile.c                 | 12 ++++++------
 10 files changed, 35 insertions(+), 31 deletions(-)

-- 
2.26.0.106.g9fadedd
