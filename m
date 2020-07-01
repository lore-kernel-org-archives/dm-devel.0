From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 05/11] block: get rid of the trace rq insert wrapper
Date: Wed, 1 Jul 2020 04:34:07 +0000
Message-ID: <BYAPR04MB496592F9BE389ED9E39DFE21866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
 <20200629234314.10509-6-chaitanya.kulkarni@wdc.com>
 <20200630051116.GC27033@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

On 6/29/20 10:11 PM, Christoph Hellwig wrote:=0A=
> On Mon, Jun 29, 2020 at 04:43:08PM -0700, Chaitanya Kulkarni wrote:=0A=
>> Get rid of the wrapper for trace_block_rq_insert() and call the function=
=0A=
>> directly.=0A=
> I'd mention blk_mq_sched_request_inserted instead of the tracepoint=0A=
> in the subject and commit message.  Otherwise this looks fine.=0A=
> =0A=
Okay, will change the message.=0A=
