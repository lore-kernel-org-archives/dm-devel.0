From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Date: Mon, 30 Aug 2010 15:59:14 +0200
Message-ID: <4C7BB932.1070405__17609.4671166085$1283196689$gmane$org@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20100830192436.GJ9195@redhat.com>
Resent-To: dm-devel@redhat.com
In-Reply-To: <20100830132836.GB5283@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: k-ueda@ct.jp.nec.com, jaxboe@fusionio.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, j-nomura@ce.jp.nec.com, hch@lst.de
List-Id: dm-devel.ids

Hello,

On 08/30/2010 03:28 PM, Mike Snitzer wrote:
>> +	clone->cmd = rq->cmd;
>> +	clone->cmd_len = rq->cmd_len;
>> +	clone->sense = rq->sense;
>> +	clone->buffer = rq->buffer;
>>  	clone->end_io = end_clone_request;
>>  	clone->end_io_data = tio;
> 
> blk_rq_prep_clone() of a REQ_FLUSH request will result in a
> rq_data_dir(clone) of read.

Hmmm... why?  blk_rq_prep_clone() copies all REQ_* flags in
REQ_CLONE_MASK and REQ_WRITE is definitely there.  I'll check.

> I still had the following:
> 
>         if (rq->cmd_flags & REQ_FLUSH) {
>                 blk_rq_init(NULL, clone);
>                 clone->cmd_type = REQ_TYPE_FS;
>                 /* without this the clone has a rq_data_dir of 0 */
>                 clone->cmd_flags |= WRITE_FLUSH;
>         } else {
>                 r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
>                                       dm_rq_bio_constructor, tio);
>                 ...
> 
> Request-based DM's REQ_FLUSH still works without this special casing but
> I figured I'd raise this to ask: what is the proper rq_data_dir() is for
> a REQ_FLUSH?

Technically block layer doesn't care one way or the other but WRITE
definitely.  Maybe it would be a good idea to enforce that from block
layer.

>> @@ -1709,15 +1621,12 @@ static void dm_request_fn(struct request_queue *q)
>>  		if (!rq)
>>  			goto plug_and_out;
>>  
>> -		if (unlikely(dm_rq_is_flush_request(rq))) {
>> -			BUG_ON(md->flush_request);
>> -			md->flush_request = rq;
>> -			blk_start_request(rq);
>> -			queue_work(md->wq, &md->barrier_work);
>> -			goto out;
>> -		}
>> +		/* always use block 0 to find the target for flushes for now */
>> +		pos = 0;
>> +		if (!(rq->cmd_flags & REQ_FLUSH))
>> +			pos = blk_rq_pos(rq);
>>  
>> -		ti = dm_table_find_target(map, blk_rq_pos(rq));
>> +		ti = dm_table_find_target(map, pos);
> 
> I added the following here: BUG_ON(!dm_target_is_valid(ti));

I'll add it.

>>  		if (ti->type->busy && ti->type->busy(ti))
>>  			goto plug_and_out;
> 
> I also needed to avoid the ->busy call for REQ_FLUSH:
> 
>                 if (!(rq->cmd_flags & REQ_FLUSH)) {
>                         ti = dm_table_find_target(map, blk_rq_pos(rq));
>                         BUG_ON(!dm_target_is_valid(ti));
>                         if (ti->type->busy && ti->type->busy(ti))
>                                 goto plug_and_out;
>                 } else {
>                         /* rq-based only ever has one target! leverage this for FLUSH */
>                         ti = dm_table_get_target(map, 0);
>                 }
> 
> If I allowed ->busy to be called for REQ_FLUSH it would result in a
> deadlock.  I haven't identified where/why yet.

Ah... that's probably from "if (!elv_queue_empty(q))" check below,
flushes are on a separate queue but I forgot to update
elv_queue_empty() to check the flush queue.  elv_queue_empty() can
return %true spuriously in which case the queue won't be plugged and
restarted later leading to queue hang.  I'll fix elv_queue_empty().

Thanks.

-- 
tejun
