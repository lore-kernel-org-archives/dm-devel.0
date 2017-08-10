From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/9] QUEUE_FLAG_NOWAIT to indicate device supports nowait
Date: Thu, 10 Aug 2017 11:17:08 -0600
Message-ID: <2fca00c1-2057-cac5-1b18-a10b1b6f22a0@kernel.dk>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
 <20170726235806.12148-2-rgoldwyn@suse.de>
 <20170808203246.sdjnpzixxz5brjaf@kernel.org>
 <10dbe9f0-e2a0-456f-b271-7cf0312aa1d5@kernel.dk>
 <284fb7b3-9265-229f-4c66-bd043b94ec9f@kernel.dk>
 <f8d2c0e3-e81f-55e7-2645-4598af34b367@suse.de>
 <0714ec15-9dad-f7a3-4f09-e7624f109de6@kernel.dk>
 <a395c6fc-3aea-53e5-6cf6-c2a01acd70b1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <a395c6fc-3aea-53e5-6cf6-c2a01acd70b1@suse.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Shaohua Li <shli@kernel.org>
Cc: linux-block@vger.kernel.org, hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

On 08/10/2017 11:15 AM, Goldwyn Rodrigues wrote:
> 
> 
> On 08/10/2017 09:14 AM, Jens Axboe wrote:
>> On 08/10/2017 05:38 AM, Goldwyn Rodrigues wrote:
>>>
>>>
>>> On 08/09/2017 09:18 PM, Jens Axboe wrote:
>>>> On 08/08/2017 02:36 PM, Jens Axboe wrote:
>>>>> On 08/08/2017 02:32 PM, Shaohua Li wrote:
>>>>>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>>>>>>> index 25f6a0cb27d3..fae021ebec1b 100644
>>>>>>> --- a/include/linux/blkdev.h
>>>>>>> +++ b/include/linux/blkdev.h
>>>>>>> @@ -633,6 +633,7 @@ struct request_queue {
>>>>>>>  #define QUEUE_FLAG_REGISTERED  29	/* queue has been registered to a disk */
>>>>>>>  #define QUEUE_FLAG_SCSI_PASSTHROUGH 30	/* queue supports SCSI commands */
>>>>>>>  #define QUEUE_FLAG_QUIESCED    31	/* queue has been quiesced */
>>>>>>> +#define QUEUE_FLAG_NOWAIT      32	/* stack device driver supports REQ_NOWAIT */
>>>>>
>>>>> Does this work on 32-bit, where sizeof(unsigned long) == 32?
>>>>
>>>> I didn't get an answer to this one.
>>>>
>>>
>>> Oh, I assumed the question is rhetorical.
>>> No, it will not work on 32-bit. I was planning to change the field
>>> queue_flags to u64. Is that okay?
>>
>> No, besides that would not work with set/test_bit() and friends. Grab
>> a free bit instead.
>>
> 
> Which bit is free? I don't see any gaps in QUEUE_FLAG_*, and I am not
> sure if any one is unused.

Bit 0 is free in mainline, and I just looked, and two other bits are
gone as well:

http://git.kernel.dk/cgit/linux-block/commit/?h=for-4.14/block&id=e743eb1ecd5564b5ae0a4a76c1566f748a358839

-- 
Jens Axboe
