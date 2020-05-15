From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Subject: Re: [PATCH v2 00/10] clean up SECTOR related macros and sectors/pages
 conversions
Date: Fri, 15 May 2020 10:05:02 +0800
Message-ID: <34fa4c00-9860-ca09-da4d-c5b20aad81b7@huawei.com>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200507075100.1779-1-thunder.leizhen@huawei.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Hi, all:
   It seems no one take care about these patches. But I think patch 1 is need. And
the main discussion points of others is whether we should add
sectors_to_npage()/npage_to_sectors() or keep PAGE_SECTORS_SHIFT. And which marco
name do we prefer: PAGE_SECTORS vs SECTORS_PER_PAGE, PAGE_SECTORS_SHIFT vs
SECTORS_PER_PAGE_SHIFT.

Hi, Jens Axboe, Coly Li, Kent Overstreet,Alasdair Kergon. Mike Snitzer:
   Can you take a look at patch 1?

On 2020/5/7 15:50, Zhen Lei wrote:
> v1 --> v2:
> As Matthew Wilcox's suggestion, add sectors_to_npage()/npage_to_sectors()
> helpers to eliminate SECTORS_PER_PAGE_SHIFT, because it's quite hard to read.
> In further, I also eliminated PAGE_SECTORS_SHIFT.
> 
> I tried to eliminate all magic number "9" and "512", but it's too many, maybe
> no one want to review it, so I gave up. In the process of searching, I found
> the existing macro PAGE_SECTORS, it's equivalent to SECTORS_PER_PAGE. Because
> PAGE_SECTORS was defined in include/linux/device-mapper.h, and SECTORS_PER_PAGE
> was defined in drivers/block/zram/zram_drv.h, so I discarded SECTORS_PER_PAGE,
> althrough I prefer it so much.
> 
> v1:
> When I studied the code of mm/swap, I found "1 << (PAGE_SHIFT - 9)" appears
> many times. So I try to clean up it.
> 
> 1. Replace "1 << (PAGE_SHIFT - 9)" or similar with SECTORS_PER_PAGE
> 2. Replace "PAGE_SHIFT - 9" with SECTORS_PER_PAGE_SHIFT
> 3. Replace "9" with SECTOR_SHIFT
> 4. Replace "512" with SECTOR_SIZE
> 
> Zhen Lei (10):
>   block: move PAGE_SECTORS definition into <linux/blkdev.h>
>   zram: abolish macro SECTORS_PER_PAGE
>   block: add sectors_to_npage()/npage_to_sectors() helpers
>   zram: abolish macro SECTORS_PER_PAGE_SHIFT
>   block: abolish macro PAGE_SECTORS_SHIFT
>   mm/swap: use npage_to_sectors() and PAGE_SECTORS to clean up code
>   block: use sectors_to_npage() and PAGE_SECTORS to clean up code
>   md: use sectors_to_npage() and npage_to_sectors() to clean up code
>   md: use existing definition RESYNC_SECTORS
>   md: use PAGE_SECTORS to clean up code
> 
>  block/blk-settings.c          |  6 +++---
>  block/partitions/core.c       |  5 ++---
>  drivers/block/brd.c           |  7 ++-----
>  drivers/block/null_blk_main.c | 10 ++++------
>  drivers/block/zram/zram_drv.c |  8 ++++----
>  drivers/block/zram/zram_drv.h |  2 --
>  drivers/md/bcache/util.h      |  2 --
>  drivers/md/dm-kcopyd.c        |  2 +-
>  drivers/md/dm-table.c         |  2 +-
>  drivers/md/md-bitmap.c        | 16 ++++++++--------
>  drivers/md/md.c               |  6 +++---
>  drivers/md/raid1.c            | 10 +++++-----
>  drivers/md/raid10.c           | 28 ++++++++++++++--------------
>  drivers/md/raid5-cache.c      | 11 +++++------
>  drivers/md/raid5.c            |  4 ++--
>  include/linux/blkdev.h        |  7 +++++--
>  include/linux/device-mapper.h |  1 -
>  mm/page_io.c                  |  4 ++--
>  mm/swapfile.c                 | 12 ++++++------
>  19 files changed, 67 insertions(+), 76 deletions(-)
> 
