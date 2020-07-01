From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 09/11] block: remove unsed param in blk_fill_rwbs()
Date: Wed, 1 Jul 2020 04:38:31 +0000
Message-ID: <BYAPR04MB49651D1104ED9F0BA2F3F912866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
 <20200629234314.10509-10-chaitanya.kulkarni@wdc.com>
 <20200630051247.GF27033@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

On 6/29/20 10:12 PM, Christoph Hellwig wrote:=0A=
>> +extern void blk_fill_rwbs(char *rwbs, unsigned int op);=0A=
> You might want to drop the extern while you're at it.=0A=
> =0A=
=0A=
Good point.=0A=
