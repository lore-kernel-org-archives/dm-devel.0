From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 07/11] block: get rid of blk_trace_request_get_cgid()
Date: Wed, 1 Jul 2020 21:06:03 +0000
Message-ID: <BYAPR04MB4965A856D067354A9CCF4861866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
 <20200629234314.10509-8-chaitanya.kulkarni@wdc.com>
 <20200630051202.GD27033@lst.de>
 <BYAPR04MB49653ABB3E50A7D034BE8C68866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <20200701061640.GA28483@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

On 6/30/20 11:16 PM, Christoph Hellwig wrote:=0A=
> On Wed, Jul 01, 2020 at 04:38:06AM +0000, Chaitanya Kulkarni wrote:=0A=
>> On 6/29/20 10:12 PM, Christoph Hellwig wrote:=0A=
>>> On Mon, Jun 29, 2020 at 04:43:10PM -0700, Chaitanya Kulkarni wrote:=0A=
>>>> Now that we have done cleanup we can safely get rid of the=0A=
>>>> blk_trace_request_get_cgid() and replace it with=0A=
>>>> blk_trace_bio_get_cgid().=0A=
>>> To me the helper actually looks useful compared to open coding the=0A=
>>> check in a bunch of callers.=0A=
>>>=0A=
>> The helper adds an additional function call which can be avoided easily=
=0A=
>> since blk_trace_bio_get_cgid() is written nicely, that also maintains=0A=
>> the readability of the code.=0A=
>>=0A=
>> Unless the cost of the function call doesn't matter and readability is=
=0A=
>> not lost can we please not use helper ?=0A=
> I think readability is lost.  I'd much rather drop the q argument=0A=
> from blk_trace_request_get_cgid and keep the helper, as it pretty=0A=
> clearly documents what is done.=0A=
> =0A=
Okay I'll add to V2.=0A=
