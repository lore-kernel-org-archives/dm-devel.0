From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH RFC] block: blktrace framework cleanup
Date: Wed, 24 Jun 2020 22:45:02 +0000
Message-ID: <BYAPR04MB49653212CE32249C65C0A7F486950@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200624032752.4177-1-chaitanya.kulkarni@wdc.com>
 <20200624064820.GA17964@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "kbusch@kernel.org" <kbusch@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "mingo@redhat.com" <mingo@redhat.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>
List-Id: dm-devel.ids

On 6/23/20 11:48 PM, Christoph Hellwig wrote:=0A=
> =0A=
> =0A=
> On Tue, Jun 23, 2020 at 08:27:52PM -0700, Chaitanya Kulkarni wrote:=0A=
>> There are many places where trace API accepts the struct request_queue*=
=0A=
>> parameter which can be derived from other function parameters.=0A=
>>=0A=
>> This patch removes the struct request queue parameter from the=0A=
>> blktrace framework and adjusts the tracepoints definition and usage=0A=
>> along with the tracing API itself.=0A=
> =0A=
> Good idea, and I had a half-ready patch for this already as well.=0A=
> =0A=
Well, I sent out the reply to your suggestion didn't get any response so =
=0A=
I decided to send a patch, if you want we can merge it I'll keep you as =0A=
an author for the right reasons.=0A=
> One issue, and two extra requests below:=0A=
> =0A=
> =0A=
>>   	if (bio->bi_disk && bio_flagged(bio, BIO_TRACE_COMPLETION)) {=0A=
>> -		trace_block_bio_complete(bio->bi_disk->queue, bio);=0A=
>> +		trace_block_bio_complete(bio);=0A=
> =0A=
> This one can also be called for a different queue than=0A=
> bio->bi_disk->queue, so for this one particular tracepoint we'll need=0A=
> to keep the request_queue argument.=0A=
> =0A=
Yes, we should.=0A=
>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c=0A=
>> index fdcc2c1dd178..a3cade16ef80 100644=0A=
>> --- a/block/blk-mq-sched.c=0A=
>> +++ b/block/blk-mq-sched.c=0A=
>> @@ -409,7 +409,7 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_try_insert_merge);=0A=
>>   =0A=
>>   void blk_mq_sched_request_inserted(struct request *rq)=0A=
>>   {=0A=
>> -	trace_block_rq_insert(rq->q, rq);=0A=
>> +	trace_block_rq_insert(rq);=0A=
>>   }=0A=
>>   EXPORT_SYMBOL_GPL(blk_mq_sched_request_inserted);=0A=
> =0A=
> As a follow on patch we should also remove this function.=0A=
> =0A=
Okay will make it is a 2nd patch.=0A=
>>   	}=0A=
>>   =0A=
>>   	spin_lock(&ctx->lock);=0A=
>> @@ -2111,7 +2111,7 @@ blk_qc_t blk_mq_make_request(struct request_queue =
*q, struct bio *bio)=0A=
>>   		goto queue_exit;=0A=
>>   	}=0A=
>>   =0A=
>> -	trace_block_getrq(q, bio, bio->bi_opf);=0A=
>> +	trace_block_getrq(bio, bio->bi_opf);=0A=
> =0A=
> The second argument can be removed as well.  Maybe as another patch.=0A=
Okay I'll make it in a 3rd patch.=0A=
> =0A=
=0A=
