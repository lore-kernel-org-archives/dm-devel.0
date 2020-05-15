From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 06/10] mm/swap: use npage_to_sectors() and
 PAGE_SECTORS to clean up code
Date: Thu, 14 May 2020 21:06:47 -0700
Message-ID: <20200515040647.GC16070@bombadil.infradead.org>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
 <20200507075100.1779-7-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200507075100.1779-7-thunder.leizhen@huawei.com>
Sender: linux-block-owner@vger.kernel.org
To: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, May 07, 2020 at 03:50:56PM +0800, Zhen Lei wrote:
> @@ -266,7 +266,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>  
>  static sector_t swap_page_sector(struct page *page)
>  {
> -	return (sector_t)__page_file_index(page) << (PAGE_SHIFT - 9);
> +	return npage_to_sectors((sector_t)__page_file_index(page));

If you make npage_to_sectors() a proper function instead of a macro,
you can do the casting inside the function instead of in the callers
(which is prone to bugs).

Also, this is a great example of why page_to_sector() was a better name
than npage_to_sectors().  This function doesn't return a count of sectors,
it returns a sector number within the swap device.
