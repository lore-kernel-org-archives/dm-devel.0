From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/4] block: Move SECTORS_PER_PAGE and
 SECTORS_PER_PAGE_SHIFT definitions into <linux/blkdev.h>
Date: Tue, 5 May 2020 05:10:43 -0700
Message-ID: <20200505121043.GG16070@bombadil.infradead.org>
References: <20200505115543.1660-1-thunder.leizhen@huawei.com>
 <20200505115543.1660-2-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200505115543.1660-2-thunder.leizhen@huawei.com>
Sender: linux-block-owner@vger.kernel.org
To: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, May 05, 2020 at 07:55:40PM +0800, Zhen Lei wrote:
> +#ifndef SECTORS_PER_PAGE_SHIFT
> +#define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
> +#endif
> +#ifndef SECTORS_PER_PAGE
> +#define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
>  #endif

I find SECTORS_PER_PAGE_SHIFT quite hard to read.  I had a quick skim
of your other patches, and it seems to me that we could replace
'<< SECTORS_PER_PAGE_SHIFT' with '* SECTORS_PER_PAGE' and it would be
more readable in every case.
