From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Subject: Re: [PATCH v2 06/10] mm/swap: use npage_to_sectors() and PAGE_SECTORS
 to clean up code
Date: Fri, 15 May 2020 14:42:44 +0800
Message-ID: <85ea7c5e-9879-8aa4-c0f4-c60f107d63e3@huawei.com>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
 <20200507075100.1779-7-thunder.leizhen@huawei.com>
 <20200515041456.GD16070@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200515041456.GD16070@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids



On 2020/5/15 12:14, Matthew Wilcox wrote:
> On Thu, May 07, 2020 at 03:50:56PM +0800, Zhen Lei wrote:
>> +++ b/mm/page_io.c
>> @@ -38,7 +38,7 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
>>  
>>  		bio->bi_iter.bi_sector = map_swap_page(page, &bdev);
>>  		bio_set_dev(bio, bdev);
>> -		bio->bi_iter.bi_sector <<= PAGE_SHIFT - 9;
>> +		bio->bi_iter.bi_sector *= PAGE_SECTORS;
>>  		bio->bi_end_io = end_io;
> 
> This just doesn't look right.  Why is map_swap_page() returning a sector_t
> which isn't actually a sector_t?

I try to understand map_swap_page(). Here maybe a bug. Otherwise, it would be
better to add a temporary variable to cache the return value of map_swap_page(page, &bdev).

> 
> 
> .
> 
