From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] dm-zoned: Use GFP_NOIO in I/O path
Date: Tue, 25 Jul 2017 08:56:29 +0900
Message-ID: <bbbf7fd7-c7f5-7e82-955e-101976f80c8e@wdc.com>
References: <20170724074437.24008-1-damien.lemoal@wdc.com>
	<alpine.LRH.2.02.1707240941470.23985@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1707240941470.23985@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Mikulas,

On 7/24/17 22:45, Mikulas Patocka wrote:
> 
> 
> On Mon, 24 Jul 2017, Damien Le Moal wrote:
> 
>> Use GFP_NOIO for memory allocations in the I/O path. Other memory
>> allocations in the initialization path can keep using GFP_KERNEL.
> 
> Good patch. BTW. that GFP_NOFS should also be changed to GFP_NOIO.
> 
> GFP_NOFS prevents allocator recursion to the filesystem.
> GFP_NOIO prevents allocator recursion to the filesystem and I/O stack.
> 
> With GFP_NOFS, it is still theoretically possible that the allocation 
> recurses into the I/O layer (for example when swapping to a block device).

Ah, yes indeed. I will post a v2. Thank you for the review.

Best regards.

-- 
Damien Le Moal,
Western Digital
