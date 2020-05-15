From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Subject: Re: [PATCH v2 06/10] mm/swap: use npage_to_sectors() and PAGE_SECTORS
 to clean up code
Date: Fri, 15 May 2020 14:28:53 +0800
Message-ID: <766da107-bc67-ff99-a8c8-87f8f98c7cf6@huawei.com>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
 <20200507075100.1779-7-thunder.leizhen@huawei.com>
 <20200515040647.GC16070@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200515040647.GC16070@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids



On 2020/5/15 12:06, Matthew Wilcox wrote:
> On Thu, May 07, 2020 at 03:50:56PM +0800, Zhen Lei wrote:
>> @@ -266,7 +266,7 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
>>  
>>  static sector_t swap_page_sector(struct page *page)
>>  {
>> -	return (sector_t)__page_file_index(page) << (PAGE_SHIFT - 9);
>> +	return npage_to_sectors((sector_t)__page_file_index(page));
> 
> If you make npage_to_sectors() a proper function instead of a macro,
> you can do the casting inside the function instead of in the callers
> (which is prone to bugs).

Oh, yes. __page_file_index(page) maybe called many times in marco, althouth currently
it is not. So that, not all are suitable for page_to_sector(). And for this example,
still need to use "<< PAGE_SECTORS_SHIFT".

> 
> Also, this is a great example of why page_to_sector() was a better name
> than npage_to_sectors().  This function doesn't return a count of sectors,
> it returns a sector number within the swap device.
OK, so I will change to page_to_sector()/sector_to_page().

> 
> 
> .
> 
