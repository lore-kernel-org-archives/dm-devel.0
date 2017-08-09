From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 1/9] QUEUE_FLAG_NOWAIT to indicate device supports nowait
Date: Wed, 9 Aug 2017 06:44:55 -0500
Message-ID: <51cdf08c-c8a4-6bbd-3342-7cdb2b510668@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
 <20170726235806.12148-2-rgoldwyn@suse.de>
 <20170808203246.sdjnpzixxz5brjaf@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170808203246.sdjnpzixxz5brjaf@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-block@vger.kernel.org, hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids



On 08/08/2017 03:32 PM, Shaohua Li wrote:
> On Wed, Jul 26, 2017 at 06:57:58PM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Nowait is a feature of direct AIO, where users can request
>> to return immediately if the I/O is going to block. This translates
>> to REQ_NOWAIT in bio.bi_opf flags. While request based devices
>> don't wait, stacked devices such as md/dm will.
>>
>> In order to explicitly mark stacked devices as supported, we
>> set the QUEUE_FLAG_NOWAIT in the queue_flags and return -EAGAIN
>> whenever the device would block.
> 
> probably you should route this patch to Jens first, DM/MD are different trees.

Yes, I have sent it to linux-block as well, and he has commented as well.


>  
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>  block/blk-core.c       | 3 ++-
>>  include/linux/blkdev.h | 2 ++
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 970b9c9638c5..1c9a981d88e5 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2025,7 +2025,8 @@ generic_make_request_checks(struct bio *bio)
>>  	 * if queue is not a request based queue.
>>  	 */
>>  
>> -	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q))
>> +	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q) &&
>> +	    !blk_queue_supports_nowait(q))
>>  		goto not_supported;
>>  
>>  	part = bio->bi_bdev->bd_part;
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 25f6a0cb27d3..fae021ebec1b 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -633,6 +633,7 @@ struct request_queue {
>>  #define QUEUE_FLAG_REGISTERED  29	/* queue has been registered to a disk */
>>  #define QUEUE_FLAG_SCSI_PASSTHROUGH 30	/* queue supports SCSI commands */
>>  #define QUEUE_FLAG_QUIESCED    31	/* queue has been quiesced */
>> +#define QUEUE_FLAG_NOWAIT      32	/* stack device driver supports REQ_NOWAIT */
>>  
>>  #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>>  				 (1 << QUEUE_FLAG_STACKABLE)	|	\
>> @@ -732,6 +733,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
>>  #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
>>  #define blk_queue_scsi_passthrough(q)	\
>>  	test_bit(QUEUE_FLAG_SCSI_PASSTHROUGH, &(q)->queue_flags)
>> +#define blk_queue_supports_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
> 
> Should this bit consider under layer disks? For example, one raid array disk
> doesn't support NOWAIT, shouldn't we disable NOWAIT for the array?

Yes, it should. I will add a check before setting the flag. Thanks.
Request-based devices don't wait. So, they would not have this flag set.
It is only the bio-based, with the  make_request_fn hook which need this.

>  
> I have another generic question. If a bio is splitted into 2 bios, one bio
> doesn't need to wait but the other need to wait. We will return -EAGAIN for the
> second bio, so the whole bio will return -EAGAIN, but the first bio is already
> dispatched to disk. Is this correct behavior?
> 

No, from a multi-device point of view, this is inconsistent. I have
tried the request bio returns -EAGAIN before the split, but I shall
check again. Where do you see this happening?

-- 
Goldwyn
