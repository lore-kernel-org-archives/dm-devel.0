From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH 1/3] block: inherit the zoned characteristics in
 blk_stack_limits
Date: Mon, 20 Jul 2020 06:45:24 +0000
Message-ID: <SN4PR0401MB35983F8986A949FCEB79A3829B7B0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200720061251.652457-1-hch@lst.de>
 <20200720061251.652457-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 20/07/2020 08:13, Christoph Hellwig wrote:=0A=
>  /*=0A=
>   * Zoned block device models (zoned limit).=0A=
> + *=0A=
> + * Note: This needs to be ordered from the least to the most severe=0A=
> + * restrictions for the inheritance in blk_stack_limits() to work.=0A=
>   */=0A=
>  enum blk_zoned_model {=0A=
> -	BLK_ZONED_NONE,	/* Regular block device */=0A=
> -	BLK_ZONED_HA,	/* Host-aware zoned block device */=0A=
> -	BLK_ZONED_HM,	/* Host-managed zoned block device */=0A=
> +	BLK_ZONED_NONE =3D 0,	/* Regular block device */=0A=
=0A=
The initialization to 0 for the first value is not needed.=0A=
=0A=
Apart from that,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
