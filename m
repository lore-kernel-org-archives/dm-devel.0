From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [dm-devel] should blk-mq halt requeue processing while queue is
 frozen?
Date: Tue, 13 Sep 2016 10:01:40 +0200
Message-ID: <7c034c5b-db1b-e0c7-2824-81672c6683f9@acm.org>
References: <20160901211718.GA12894@redhat.com>
 <20160901221823.GA13209@redhat.com>
 <f276cf3d-cad3-3e61-2903-754970f90445@sandisk.com>
 <20160901222654.GA13292@redhat.com>
 <938609b9-3a55-0ed3-ffeb-de27e1c1e864@sandisk.com>
 <20160901234754.GA13653@redhat.com>
 <6af010f8-0a8f-cf0e-d819-3b8e1c20b56e@sandisk.com>
 <20160902151213.GA17508@redhat.com> <20160902161059.GB17508@redhat.com>
 <aa663595-4890-adb1-a2b4-422b0b65b097@sandisk.com>
 <20160907164114.GA17578@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160907164114.GA17578@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, hch@lst.de
List-Id: dm-devel.ids

On 09/07/2016 06:41 PM, Mike Snitzer wrote:
> On Fri, Sep 02 2016 at  6:42pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>> +/**
>> + * blk_mq_quiesce_queue - wait until all pending queue_rq calls have finished
>> + *
>> + * Prevent that new I/O requests are queued and wait until all pending
>> + * queue_rq() calls have finished.
>> + */
>> +void blk_mq_quiesce_queue(struct request_queue *q)
>> +{
>> +	spin_lock_irq(q->queue_lock);
>> +	WARN_ON_ONCE(blk_queue_quiescing(q));
>> +	queue_flag_set(QUEUE_FLAG_QUIESCING, q);
>> +	spin_unlock_irq(q->queue_lock);
>> +
>> +	atomic_inc_return(&q->mq_freeze_depth);
>> +	blk_mq_run_hw_queues(q, false);
>> +	synchronize_rcu();
>
> Why the synchronize_rcu()?

Hello Mike,

Adding read_lock() + read_unlock() in __blk_mq_run_hw_queue() and 
synchronize_rcu() in blk_mq_quiesce_queue() is the lowest overhead 
mechanism I know of to make the latter function wait until the former 
has finished.

> Also, you're effectively open-coding blk_mq_freeze_queue_start() minus
> the q->q_usage_counter mgmt.  Why not add a flag to conditionally manage
> q->q_usage_counter to blk_mq_freeze_queue_start()?

I will consider this.

> But I'm concerned about blk_mq_{quiesce,resume}_queue vs
> blk_mq_{freeze,unfreeze}_queue -- e.g. if "freeze" is nested after
> "queue" (but before "resume") it would still need the q->q_usage_counter
> management.  Your patch as-is would break the blk-mq freeze interface.

Agreed. blk_mq_{quiesce,resume}_queue() has to manipulate 
q_usage_counter in the same way as blk_mq_{freeze,unfreeze}_queue(). 
Once I am back in the office I will rework this patch and send it to Jens.

Bart.
