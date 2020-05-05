From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/4] mm/swap: use SECTORS_PER_PAGE_SHIFT to clean up code
Date: Tue, 5 May 2020 10:25:20 -0700
Message-ID: <20200505172520.GI16070@bombadil.infradead.org>
References: <20200505115543.1660-1-thunder.leizhen@huawei.com>
 <20200505115543.1660-3-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200505115543.1660-3-thunder.leizhen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, May 05, 2020 at 07:55:41PM +0800, Zhen Lei wrote:
> +++ b/mm/swapfile.c
> @@ -177,8 +177,8 @@ static int discard_swap(struct swap_info_struct *si)
>  
>  	/* Do not discard the swap header page! */
>  	se = first_se(si);
> -	start_block = (se->start_block + 1) << (PAGE_SHIFT - 9);
> -	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
> +	start_block = (se->start_block + 1) << SECTORS_PER_PAGE_SHIFT;
> +	nr_blocks = ((sector_t)se->nr_pages - 1) << SECTORS_PER_PAGE_SHIFT;

Thinking about this some more, wouldn't this look better?

	start_block = page_sectors(se->start_block + 1);
	nr_block = page_sectors(se->nr_pages - 1);
