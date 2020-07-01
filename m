From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH 02/11] block: rename block_bio_merge class to block_bio
Date: Wed, 1 Jul 2020 04:33:37 +0000
Message-ID: <BYAPR04MB4965637C75F740A3FD144470866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
 <20200629234314.10509-3-chaitanya.kulkarni@wdc.com>
 <20200630051042.GB27033@lst.de>
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
> On Mon, Jun 29, 2020 at 04:43:05PM -0700, Chaitanya Kulkarni wrote:=0A=
>> There are identical TRACE_EVENTS presents which can now take an=0A=
>> advantage of the block_bio_merge trace event class.=0A=
>>=0A=
>> This is a prep patch which renames block_bio_merge to block_bio so=0A=
>> that the next patches in this series will be able to resue it.=0A=
> The changes look good, but I'd merged it with the patches adding=0A=
> actual new users (which also look good to me).=0A=
> =0A=
Okay, will merge it.=0A=
