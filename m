From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fix an integer overflow in __blkdev_sectors_to_bio_pages
Date: Mon, 11 Sep 2017 09:47:12 -0600
Message-ID: <a64af29c-e247-6381-fcd9-23720a3a86fa@kernel.dk>
References: <CAGnHSEngW1Ugf66V5henR9fMEev0xcJnKVY9MjJb19gy3CkgNA@mail.gmail.com>
 <20170809133833.GA25681@lst.de>
 <alpine.LRH.2.02.1708132245190.18210@file01.intranet.prod.int.rdu2.redhat.com>
 <1502683489.903.1.camel@wdc.com>
 <alpine.LRH.2.02.1708141926170.24994@file01.intranet.prod.int.rdu2.redhat.com>
 <20170911145833.GB15556@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170911145833.GB15556@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "tom.ty89@gmail.com" <tom.ty89@gmail.com>, "gmazyland@gmail.com" <gmazyland@gmail.com>
List-Id: dm-devel.ids

On 09/11/2017 08:58 AM, Mike Snitzer wrote:
> On Mon, Aug 14 2017 at  8:01pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>>
>>
>> On Mon, 14 Aug 2017, Damien Le Moal wrote:
>>
>>> On Sun, 2017-08-13 at 22:47 -0400, Mikulas Patocka wrote:
>>>>
>>>> On Wed, 9 Aug 2017, hch@lst.de wrote:
>>>>
>>>>> Does commit 615d22a51c04856efe62af6e1d5b450aaf5cc2c0
>>>>> "block: Fix __blkdev_issue_zeroout loop" fix the issue for you?
>>>>>
>>>>> --
>>>>> dm-devel mailing list
>>>>> dm-devel@redhat.com
>>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>>>
>>>> I think that patch is incorrect. sector_t may be a 32-bit type and 
>>>> nr_sects << 9 may overflow.
>>>>
>>>> static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
>>>> {
>>>>        sector_t bytes = (nr_sects << 9) + PAGE_SIZE - 1;
>>>>
>>>>        return min(bytes >> PAGE_SHIFT, (sector_t)BIO_MAX_PAGES);
>>>> }
>>>>
>>>> Mikulas
>>>
>>> Mikulas,
>>>
>>> Does the follwing patch fix the problem ?
>>>
>>> From 947b3cf41e759b2b23f684e215e651d0c8037f88 Mon Sep 17 00:00:00 2001
>>> From: Damien Le Moal <damien.lemoal@wdc.com>
>>> Date: Mon, 14 Aug 2017 13:01:16 +0900
>>> Subject: [PATCH] block: Fix __blkdev_sectors_to_bio_pages()
>>>
>>> On 32bit systems where sector_t is a 32bits type, the calculation of
>>> bytes may overflow. Use the u64 type for the local calculation to avoid
>>> overflows.
>>>
>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>>> ---
>>>  block/blk-lib.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>>> index 3fe0aec90597..ccf22dba21f0 100644
>>> --- a/block/blk-lib.c
>>> +++ b/block/blk-lib.c
>>> @@ -269,9 +269,9 @@ static int __blkdev_issue_write_zeroes(struct block_device
>>> *bdev,
>>>   */
>>>  static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
>>>  {
>>> -	sector_t bytes = (nr_sects << 9) + PAGE_SIZE - 1;
>>> +	u64 bytes = ((u64)nr_sects << 9) + PAGE_SIZE - 1;
>>>  
>>> -	return min(bytes >> PAGE_SHIFT, (sector_t)BIO_MAX_PAGES);
>>> +	return min(bytes >> PAGE_SHIFT, (u64)BIO_MAX_PAGES);
>>>  }
>>>  
>>
>> It's OK, but it is not needed to use 64-bit arithmetic here if all we need 
>> is to shift the value right. Here I submit a simplified patch, using the 
>> macro DIV_ROUND_UP_SECTOR_T (the macro gets optimized to just an addition 
>> and right shift).
>>
>>
>>
>> From: Mikulas Patocka <mpatocka@redhat.com>
>>
>> Fix possible integer overflow in __blkdev_sectors_to_bio_pages if sector_t 
>> is 32-bit.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> Fixes: 615d22a51c04 ("block: Fix __blkdev_issue_zeroout loop")
>>
>> ---
>>  block/blk-lib.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/block/blk-lib.c
>> ===================================================================
>> --- linux-2.6.orig/block/blk-lib.c
>> +++ linux-2.6/block/blk-lib.c
>> @@ -269,9 +269,9 @@ static int __blkdev_issue_write_zeroes(s
>>   */
>>  static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
>>  {
>> -	sector_t bytes = (nr_sects << 9) + PAGE_SIZE - 1;
>> +	sector_t pages = DIV_ROUND_UP_SECTOR_T(nr_sects, PAGE_SIZE / 512);
>>  
>> -	return min(bytes >> PAGE_SHIFT, (sector_t)BIO_MAX_PAGES);
>> +	return min(pages, (sector_t)BIO_MAX_PAGES);
>>  }
>>  
>>  /**
>>
> 
> Jens can you pick this up?

Yep added, thanks.

-- 
Jens Axboe
