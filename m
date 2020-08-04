From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm: don't call report zones for more than the user
 requested
Date: Tue, 4 Aug 2020 10:17:14 +0000
Message-ID: <CY4PR04MB3751EB538B7F29FBDBB4EBA4E74A0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200804092501.7938-1-johannes.thumshirn@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-Id: dm-devel.ids

On 2020/08/04 18:25, Johannes Thumshirn wrote:=0A=
> Don't call report zones for more zones than the user actually requested,=
=0A=
> otherwise this can lead to out-of-bounds accesses in the callback=0A=
> functions.=0A=
> =0A=
> Such a situation can happen if the target's ->report_zones() callback=0A=
> function returns 0 because we've reached the end of the target and then=
=0A=
> restart the report zones on the second target.=0A=
> =0A=
> We're again calling into ->report_zones() and ultimately into the user=0A=
> supplied callback function but when we're not subtracting the number of=
=0A=
> zones already processed this may lead to out-of-bounds accesses in the=0A=
> user callbacks.=0A=
> =0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/md/dm.c | 3 ++-=0A=
>  1 file changed, 2 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c=0A=
> index 5b9de2f71bb0..88b391ff9bea 100644=0A=
> --- a/drivers/md/dm.c=0A=
> +++ b/drivers/md/dm.c=0A=
> @@ -504,7 +504,8 @@ static int dm_blk_report_zones(struct gendisk *disk, =
sector_t sector,=0A=
>  		}=0A=
>  =0A=
>  		args.tgt =3D tgt;=0A=
> -		ret =3D tgt->type->report_zones(tgt, &args, nr_zones);=0A=
> +		ret =3D tgt->type->report_zones(tgt, &args,=0A=
> +					      nr_zones - args.zone_idx);=0A=
>  		if (ret < 0)=0A=
>  			goto out;=0A=
>  	} while (args.zone_idx < nr_zones &&=0A=
> =0A=
=0A=
Looks good. I think this needs a Cc: stable.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
