From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Wed, 07 Jan 2015 09:24:12 -0700
Message-ID: <54AD5DAC.7020303@kernel.dk>
References: <20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
	<20150105213557.GA5030@redhat.com> <54ABAB80.70006@acm.org>
	<20150106160553.GB10224@redhat.com> <54AC0A39.90801@kernel.dk>
	<54AD0B63.3010505@acm.org> <54AD517E.40002@kernel.dk>
	<20150107161504.GA16911@redhat.com>
	<20150107162203.GB16911@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150107162203.GB16911@redhat.com>
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

On 01/07/2015 09:22 AM, Mike Snitzer wrote:
> On Wed, Jan 07 2015 at 11:15am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Wed, Jan 07 2015 at 10:32am -0500,
>> Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> You forgot dm-1, that's what mkfs is sleeping on. But given that
>>> sdc/sdd look idle, it still looks like a case of dm-1 not
>>> appropriately running the queues after insertion.
>>
>> DM never directly runs the queues of the underlying SCSI devices
>> (e.g. sdc, sdd).
>>
>> request-based DM runs the DM device's queue on completion of a clone
>> request:
>>
>> dm_end_request -> rq_completed -> blk_run_queue_async
>>
>> Which ultimately does seem to be the wrong way around (like you say:
>> queue should run after insertion).
>
> Hmm, for q->mq_ops blk_insert_cloned_request() should already be running
> the queue.
>
> blk_insert_cloned_request is calling blk_mq_insert_request(rq, false, true, true);
>
> Third arg being @run_queue which results in blk_mq_run_hw_queue() being
> called.

OK, that should be fine then. In that case, it's probably a missing 
queue run in some other condition... Which does make more sense, since 
"most" of the runs Bart did looked fine, it's just a slow one every now 
and then.

-- 
Jens Axboe
