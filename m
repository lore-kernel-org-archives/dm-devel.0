From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: a fix and two cleanups around blk_stack_limits
Date: Mon, 20 Jul 2020 08:13:25 +0000
Message-ID: <CY4PR04MB3751242EF7AE2172A719F201E77B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200720061251.652457-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/07/20 15:13, Christoph Hellwig wrote:=0A=
> Hi Jens,=0A=
> =0A=
> this series ensures that the zoned device limitations are properly=0A=
> inherited in blk_stack_limits, and then cleanups up two rather=0A=
> pointless wrappers around it.=0A=
> =0A=
=0A=
Tested with dm-linear, dm-crypt and dm-zoned multi device setup (from dm-5.=
9=0A=
tree). No problems detected.=0A=
=0A=
Tested-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
