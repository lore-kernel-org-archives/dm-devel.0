From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 01/11] block: blktrace framework cleanup
Date: Wed, 1 Jul 2020 04:32:11 +0000
Message-ID: <BYAPR04MB496556D53F75E6E2751799BE866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
 <20200629234314.10509-2-chaitanya.kulkarni@wdc.com>
 <20200630051001.GA27033@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

On 6/29/20 10:10 PM, Christoph Hellwig wrote:=0A=
> On Mon, Jun 29, 2020 at 04:43:04PM -0700, Chaitanya Kulkarni wrote:=0A=
>> This patch removes the extra variables from the trace events and=0A=
>> overall kernel blktrace framework. The removed members can easily be=0A=
>> extracted from the remaining argument which reduces the code=0A=
>> significantly and allows us to optimize the several tracepoints like=0A=
>> the next patch in the series.=0A=
> The subject sounds a litle strange, I'd rather say:=0A=
> =0A=
> "block: remove superflous arguments from tracepoints"=0A=
> =0A=
> The actual changes look good to me.=0A=
Okay, will change that.=0A=
> =0A=
>> +		trace_block_rq_insert(rq);=0A=
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
> But now that you remove more than the q argument in some spots you=0A=
> might remove the op one here as well.  Or limit the first patch to=0A=
> just the queue argument..=0A=
> =0A=
> =0A=
=0A=
Yeah thats is where I had difficulty, and when I tried to do it in one=0A=
patch it got complicated to review. I'll keep the first patch for the=0A=
q only and patch(s) for rest arguments as needed it easy to review that=0A=
way.=0A=
=0A=
