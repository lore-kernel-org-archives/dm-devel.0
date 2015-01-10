From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls [was: Re: [PATCH v3
 0/8] dm: add request-based blk-mq support]
Date: Fri, 09 Jan 2015 18:59:21 -0700
Message-ID: <54B08779.2080705@kernel.dk>
References: <54AC0A39.90801@kernel.dk> <54AD0B63.3010505@acm.org>
	<alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com>
	<54B042FE.2000205@kernel.dk> <54B043FC.8000902@kernel.dk>
	<20150109214015.GA1032@redhat.com> <54B04E94.3010403@kernel.dk>
	<20150109222543.GA1190@redhat.com> <54B071DC.9000307@kernel.dk>
	<20150110014811.GA2384@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150110014811.GA2384@redhat.com>
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
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/09/2015 06:48 PM, Mike Snitzer wrote:
> On Fri, Jan 09 2015 at  7:27pm -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
>
>> I sent out the half-done v3, unfortunately. Can you try this? Both the
>> cases with substantial nr_free are at the end of an index.
>
> I initially thought it was fixed since I didn't see any failures on boot
> (which I normally do see 3-4).  I then ran the kernel "make install" to
> this virtio-blk root device and also didn't see any failures on the the
> first run.  But the 2nd run triggered these:
>
> [   83.711724] __bt_get: values before for loop: last_tag=55, index=1
> [   83.713395] __bt_get: values after  for loop: last_tag=32, index=1
> [   83.714464] bt_get: __bt_get() returned -1
> [   83.715183] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
> [   83.716297] nr_free=128, nr_reserved=0
> [   83.716940] active_queues=0
>
> [   88.716241] __bt_get: values before for loop: last_tag=15, index=0
> [   88.717890] __bt_get: values after  for loop: last_tag=0, index=0
> [   88.718956] bt_get: __bt_get() returned -1
> [   88.719682] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
> [   88.720866] nr_free=128, nr_reserved=0
> [   88.721536] active_queues=0
>
> A third "make install" resulted in:
>
> [  543.711782] __bt_get: values before for loop: last_tag=114, index=3
> [  543.713411] __bt_get: values after  for loop: last_tag=96, index=3
> [  543.714495] bt_get: __bt_get() returned -1
> [  543.715222] queue_num=0, nr_tags=128, reserved_tags=0, bits_per_word=5
> [  543.716351] nr_free=128, nr_reserved=0
> [  543.717016] active_queues=0
>
> (things definitely do seem better, e.g. less frequent failure and no
> longer see the last_tag=127 case)

So if we end up freeing in batches, it's not totally unlikely that the 
case could hit where all were busy, and they got freed in between. Does 
seem a bit peculiar, though. The dump above, is that for the first 
failure case of invoking __bt_get()? I don't see the:

_still_ returned -1

which would seem to back up the theory, though. So I think this might 
actually be good, even if you hit that case.

Bart, could you try the patch (the -v4) and your DM hang and see if it 
solves it for you?

>
>> If this one doesn't solve it, I'll reproduce it myself to save the
>> ping-pong effort :-)
>
> I don't mind testing it since it is really quick.  But OK.

OK, then we can stick to that. Let me know if you hit the case of it 
both the initial -1 and the following -1, since that would indicate it's 
not fixed.


-- 
Jens Axboe
