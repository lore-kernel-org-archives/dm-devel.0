From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Subject: Re: [PATCH v2 07/10] block: use sectors_to_npage() and PAGE_SECTORS
 to clean up code
Date: Fri, 15 May 2020 14:52:26 +0800
Message-ID: <d3e9bebf-1fea-1497-6dd2-9354f9ca0d4b@huawei.com>
References: <20200507075100.1779-1-thunder.leizhen@huawei.com>
 <20200507075100.1779-8-thunder.leizhen@huawei.com>
 <20200515041916.GE16070@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200515041916.GE16070@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids



On 2020/5/15 12:19, Matthew Wilcox wrote:
> On Thu, May 07, 2020 at 03:50:57PM +0800, Zhen Lei wrote:
>> +++ b/block/blk-settings.c
>> @@ -150,7 +150,7 @@ void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_hw_secto
>>  	unsigned int max_sectors;
>>  
>>  	if ((max_hw_sectors << 9) < PAGE_SIZE) {
>> -		max_hw_sectors = 1 << (PAGE_SHIFT - 9);
>> +		max_hw_sectors = PAGE_SECTORS;
> 
> Surely this should be:
> 
> 	if (max_hw_sectors < PAGE_SECTORS) {
> 		max_hw_sectors = PAGE_SECTORS;
> 
> ... no?

I've noticed this place before. "(max_hw_sectors << 9) < PAGE_SIZE" can also make sure
that max_hw_sectors is not too large, that means (max_hw_sectors << 9) may overflow.

> 
>> -	page = read_mapping_page(mapping,
>> -			(pgoff_t)(n >> (PAGE_SHIFT - 9)), NULL);
>> +	page = read_mapping_page(mapping, (pgoff_t)sectors_to_npage(n), NULL);
> 
> ... again, get the type right, and you won't need the cast.
OK, I'll consider it.

> 
> 
> .
> 
