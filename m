From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH] dm-mpath: Work with blk multi-queue drivers
Date: Wed, 24 Sep 2014 11:20:01 -0600 (MDT)
Message-ID: <alpine.LRH.2.03.1409241020540.4696@AMR>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
	<20140924145215.GA26398@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140924145215.GA26398@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, 24 Sep 2014, Christoph Hellwig wrote:
>> index bf930f4..4c5952b 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>
> Can you split the block core changes into separate patches in a
> series?

Sounds good, will do. I'll have to follow your later suggestion to move
the blk_rq_init() to the caller early in the series so no part of the
patch set breaks anything.

>> @@ -2031,6 +2031,11 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>>  	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
>>  		return -EIO;
>>
>> +	if (q->mq_ops) {
>> +		blk_mq_insert_request(rq, false, true, true);
>> +		return 0;
>> +	}
>
> In the case of a torn down queue this one will complete the request,
> while the !mq case will return an error.  Does the upper level code
> handle that difference fine?

I wasn't entirely sure about all the error handling. After re-examining,
I think there is a problem, but maybe a little different than what
you're suggesting: if the queue is torn down, blk_get_request() for the
clone returns NULL and the original request will be orphaned, so that's
no good. Need to somehow distinguish between a torn down queue vs. no
request available and requeue/fail as appropriate.

Both mq and !mq appear to work correctly if the queue happens to get
taken down after the request is obtained but before it is submitted,
but I'll synthesize this error to be sure.

>>  	unsigned long flags;
>>  	struct pgpath *pgpath;
>>  	struct block_device *bdev;
>> @@ -410,9 +411,11 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
>>  		goto out_unlock;
>>
>>  	bdev = pgpath->path.dev->bdev;
>> -	clone->q = bdev_get_queue(bdev);
>> -	clone->rq_disk = bdev->bd_disk;
>> -	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
>> +	*clone = blk_get_request(bdev_get_queue(bdev), rq_data_dir(rq),
>> +							GFP_KERNEL);
>
> I suspect this should be GFP_NOWAIT so that we can push the request back
> up the stack if none are available.

Aha, nice catch. I'd have hit the BUG_ON() in dm_request_fn() the way
I wrote this since irq's could have been re-enabled if a request wasn't
immediately available.

Thanks for the feedback!
