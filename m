From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 10/11] block: use block_bio class for getrq and sleeprq
Date: Wed, 1 Jul 2020 21:06:43 +0000
Message-ID: <BYAPR04MB496556D7288B9EE3180DA3B6866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
 <20200629234314.10509-11-chaitanya.kulkarni@wdc.com>
 <20200630051332.GG27033@lst.de>
 <BYAPR04MB4965E849D99120B59011CEF5866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <20200701061858.GB28483@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

On 6/30/20 11:19 PM, Christoph Hellwig wrote:=0A=
> On Wed, Jul 01, 2020 at 04:45:03AM +0000, Chaitanya Kulkarni wrote:=0A=
>> On 6/29/20 10:13 PM, Christoph Hellwig wrote:=0A=
>>> On Mon, Jun 29, 2020 at 04:43:13PM -0700, Chaitanya Kulkarni wrote:=0A=
>>>> The only difference in block_get_rq and block_bio was the last param=
=0A=
>>>> passed  __entry->nr_sector & bio->bi_iter.bi_size respectively. Since=
=0A=
>>>> that is not the case anymore replace block_get_rq class with block_bio=
=0A=
>>>> for block_getrq and block_sleeprq events, also adjust the code to hand=
le=0A=
>>>> null bio case in block_bio.=0A=
>>> To me it seems like keeping the NULL bio case separate actually is a=0A=
>>> little simpler..=0A=
>>>=0A=
>>>=0A=
>> Keeping it separate will have an extra event class and related=0A=
>> event(s) for only handling null bio case.=0A=
>>=0A=
>> Also the block_get_rq class uses 4 comparisons with ?:.=0A=
>> This patch reduces it to only one comparison in fast path.=0A=
>>=0A=
>> With above explanation does it make sense to get rid of the=0A=
>> blk_get_rq ?=0A=
> Without this we don't need the request_queue argument to the bio=0A=
> class, as we can derive it from the bio, and don't have any=0A=
> conditionals at all.  I'd rather keep the special case with a=0A=
> queue and an optional bio separate.=0A=
> =0A=
=0A=
Okay.=0A=
