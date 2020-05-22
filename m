From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] block: Improve io_opt limit stacking
Date: Fri, 22 May 2020 07:27:11 +0000
Message-ID: <BY5PR04MB6900144BD2729172EBF5DF2EE7B40@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200514065819.1113949-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Keith Busch <kbusch@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/05/14 15:58, Damien Le Moal wrote:=0A=
> When devices with different physical sector sizes are stacked, the=0A=
> largest value is used as the stacked device physical sector size. For=0A=
> the optimal IO size, the lowest common multiple (lcm) of the underlying=
=0A=
> devices is used for the stacked device. In this scenario, if only one of=
=0A=
> the underlying device reports an optimal IO size, that value is used as=
=0A=
> is for the stacked device but that value may not be a multiple of the=0A=
> stacked device physical sector size. In this case, blk_stack_limits()=0A=
> returns an error resulting in warnings being printed on device mapper=0A=
> startup (observed with dm-zoned dual drive setup combining a 512B=0A=
> sector SSD with a 4K sector HDD).=0A=
> =0A=
> To fix this, rather than returning an error, the optimal IO size limit=0A=
> for the stacked device can be adjusted to the lowest common multiple=0A=
> (lcm) of the stacked physical sector size and optimal IO size, resulting=
=0A=
> in a value that is a multiple of the physical sector size while still=0A=
> being an optimal size for the underlying devices.=0A=
> =0A=
> This patch is complementary to the patch "nvme: Fix io_opt limit=0A=
> setting" which prevents the nvme driver from reporting an optimal IO=0A=
> size equal to a namespace sector size for a device that does not report=
=0A=
> an optimal IO size.=0A=
> =0A=
> Suggested-by: Keith Busch <kbusch@kernel.org>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> ---=0A=
>  block/blk-settings.c | 7 ++-----=0A=
>  1 file changed, 2 insertions(+), 5 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index 9a2c23cd9700..9a2b017ff681 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -561,11 +561,8 @@ int blk_stack_limits(struct queue_limits *t, struct =
queue_limits *b,=0A=
>  	}=0A=
>  =0A=
>  	/* Optimal I/O a multiple of the physical block size? */=0A=
> -	if (t->io_opt & (t->physical_block_size - 1)) {=0A=
> -		t->io_opt =3D 0;=0A=
> -		t->misaligned =3D 1;=0A=
> -		ret =3D -1;=0A=
> -	}=0A=
> +	if (t->io_opt & (t->physical_block_size - 1))=0A=
> +		t->io_opt =3D lcm(t->io_opt, t->physical_block_size);=0A=
>  =0A=
>  	t->raid_partial_stripes_expensive =3D=0A=
>  		max(t->raid_partial_stripes_expensive,=0A=
> =0A=
=0A=
Jens,=0A=
=0A=
Any comment on this patch ?=0A=
Note: the patch the patch "nvme: Fix io_opt limit setting" is already queue=
d for=0A=
5.8.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
