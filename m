From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Subject: Re: [PATCH 1/4] block: Move SECTORS_PER_PAGE and
 SECTORS_PER_PAGE_SHIFT definitions into <linux/blkdev.h>
Date: Wed, 6 May 2020 12:06:12 +0800
Message-ID: <8ec2a734-d23a-83ef-fe06-6b2895a2d392@huawei.com>
References: <20200505115543.1660-1-thunder.leizhen@huawei.com>
 <20200505115543.1660-2-thunder.leizhen@huawei.com>
 <20200505121043.GG16070@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200505121043.GG16070@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids



On 2020/5/5 20:10, Matthew Wilcox wrote:
> On Tue, May 05, 2020 at 07:55:40PM +0800, Zhen Lei wrote:
>> +#ifndef SECTORS_PER_PAGE_SHIFT
>> +#define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
>> +#endif
>> +#ifndef SECTORS_PER_PAGE
>> +#define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
>>  #endif
> 
> I find SECTORS_PER_PAGE_SHIFT quite hard to read.  I had a quick skim
> of your other patches, and it seems to me that we could replace
> '<< SECTORS_PER_PAGE_SHIFT' with '* SECTORS_PER_PAGE' and it would be
> more readable in every case.

OK, I will delete SECTORS_PER_PAGE_SHIFT, and replace the shift with {*|/} SECTORS_PER_PAGE if it's
not suitable to be replaced by sectors_to_page()/page_to_sectors().

> 
> .
> 
