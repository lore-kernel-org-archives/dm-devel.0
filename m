From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 07/10] block: use sectors_to_npage() and PAGE_SECTORS
 to clean up code
Date: Thu, 14 May 2020 21:19:16 -0700
Message-ID: <20200515041916.GE16070@bombadil.infradead.org>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
 <20200507075100.1779-8-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200507075100.1779-8-thunder.leizhen@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, May 07, 2020 at 03:50:57PM +0800, Zhen Lei wrote:
> +++ b/block/blk-settings.c
> @@ -150,7 +150,7 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
>  	unsigned int max_sectors;
>  
>  	if ((max_hw_sectors << 9) < PAGE_SIZE) {
> -		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
> +		max_hw_sectors = PAGE_SECTORS;

Surely this should be:

	if (max_hw_sectors < PAGE_SECTORS) {
		max_hw_sectors = PAGE_SECTORS;

... no?

> -	page = read_mapping_page(mapping,
> -			(pgoff_t)(n >> (PAGE_SHIFT - 9)), NULL);
> +	page = read_mapping_page(mapping, (pgoff_t)sectors_to_npage(n), NULL);

... again, get the type right, and you won't need the cast.
