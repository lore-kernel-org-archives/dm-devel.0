From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 06/10] mm/swap: use npage_to_sectors() and
 PAGE_SECTORS to clean up code
Date: Thu, 14 May 2020 21:14:56 -0700
Message-ID: <20200515041456.GD16070@bombadil.infradead.org>
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
> +++ b/mm/page_io.c
> @@ -38,7 +38,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
>  
>  		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
>  		bio_set_dev(bio, bdev);
> -		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
> +		bio->bi_iter.bi_sector *= PAGE_SECTORS;
>  		bio->bi_end_io = end_io;

This just doesn't look right.  Why is map_swap_page() returning a sector_t
which isn't actually a sector_t?
