From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Wed, 07 Jan 2015 10:35:30 -0700
Message-ID: <54AD6E62.6040104@kernel.dk>
References: <54A6DB1D.4030201@acm.org> <20150105213557.GA5030@redhat.com>
	<54ABAB80.70006@acm.org> <20150106160553.GB10224@redhat.com>
	<54AC0A39.90801@kernel.dk> <54AD0B63.3010505@acm.org>
	<54AD517E.40002@kernel.dk> <20150107161504.GA16911@redhat.com>
	<20150107162203.GB16911@redhat.com> <54AD5DAC.7020303@kernel.dk>
	<20150107171857.GA21062@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150107171857.GA21062@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/07/2015 10:18 AM, Mike Snitzer wrote:
> On Wed, Jan 07 2015 at 11:24am -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
>
>> On 01/07/2015 09:22 AM, Mike Snitzer wrote:
>>> On Wed, Jan 07 2015 at 11:15am -0500,
>>> Mike Snitzer <snitzer@redhat.com> wrote:
>>>
>>>> On Wed, Jan 07 2015 at 10:32am -0500,
>>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>> You forgot dm-1, that's what mkfs is sleeping on. But given that
>>>>> sdc/sdd look idle, it still looks like a case of dm-1 not
>>>>> appropriately running the queues after insertion.
>>>>
>>>> DM never directly runs the queues of the underlying SCSI devices
>>>> (e.g. sdc, sdd).
>>>>
>>>> request-based DM runs the DM device's queue on completion of a clone
>>>> request:
>>>>
>>>> dm_end_request -> rq_completed -> blk_run_queue_async
>>>>
>>>> Which ultimately does seem to be the wrong way around (like you say:
>>>> queue should run after insertion).
>>>
>>> Hmm, for q->mq_ops blk_insert_cloned_request() should already be running
>>> the queue.
>>>
>>> blk_insert_cloned_request is calling blk_mq_insert_request(rq, false, true, true);
>>>
>>> Third arg being @run_queue which results in blk_mq_run_hw_queue() being
>>> called.
>>
>> OK, that should be fine then. In that case, it's probably a missing
>> queue run in some other condition... Which does make more sense,
>> since "most" of the runs Bart did looked fine, it's just a slow one
>> every now and then.
>
> The one case that looks suspect (missing queue run) is if/when the
> multipath target's mapping function returns DM_MAPIO_REQUEUE.  It only
> returns this if memory allocation failed (e.g. blk_get_request returns
> ENOMEM).  Not seeing why DM core wouldn't want to re-run the DM device's
> queue in this case given it just called blk_requeue_request().  But that
> seems like something I need to revisit and not the ultimate problem.
>
> Looking closer, why not have blk_run_queue() (and blk_run_queue_async)
> call blk_mq_start_stopped_hw_queues() if q->mq_ops?  As is
> scsi_run_queue() open-codes it.
>
> Actually, that is likely the ultimate problem: blk_run_queue* aren't
> trained for q->mq_ops.  As such DM would need to open code a call to
> blk_mq_start_stopped_hw_queues.

It's not completely parallel how SCSI uses it. blk_run_queue(), for 
legacy request_fn, does not start stopped queues. For the mq path, 
scsi-mq decided to do that. So if we embed 
blk_mq_start_stopped_hw_queues() in blk_run_queue*(), then we'd have 
different behavior between mq and non-mq. We could have 
blk_start_queue() do the right thing, but that would require different 
contexts between mq and non-mq, as non-mq requires that to be called 
with the queue lock held and ints disabled.

-- 
Jens Axboe
