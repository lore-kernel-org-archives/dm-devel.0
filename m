From: antlists <antlists@youngman.org.uk>
Subject: Re: [PATCH 0/4] eliminate SECTOR related magic numbers and duplicated
 conversions
Date: Tue, 5 May 2020 18:32:36 +0100
Message-ID: <ea522f15-991d-6f67-ba8b-9cb4954a1064@youngman.org.uk>
References: <20200505115543.1660-1-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200505115543.1660-1-thunder.leizhen@huawei.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Zhen Lei <thunder.leizhen@huawei.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel <dm-devel@redhat.com>, Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 05/05/2020 12:55, Zhen Lei wrote:
> When I studied the code of mm/swap, I found "1 << (PAGE_SHIFT - 9)" appears
> many times. So I try to clean up it.
> 
> 1. Replace "1 << (PAGE_SHIFT - 9)" or similar with SECTORS_PER_PAGE
> 2. Replace "PAGE_SHIFT - 9" with SECTORS_PER_PAGE_SHIFT
> 3. Replace "9" with SECTOR_SHIFT
> 4. Replace "512" with SECTOR_SIZE

Naive question - what is happening about 4096-byte sectors? Do we need 
to forward-plan?

Cheers,
Wol
