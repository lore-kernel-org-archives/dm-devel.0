From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm zoned: remove duplicated nr_rnd_zones increasement
Date: Mon, 23 Mar 2020 02:34:17 +0000
Message-ID: <CO2PR04MB2343196CAA8DAC40192E0A1AE7F00@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200322092912.23148-1-bob.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
List-Id: dm-devel.ids

On 2020/03/22 18:30, Bob Liu wrote:=0A=
> zmd->nr_rnd_zones was increased twice by mistake.=0A=
> The other place:=0A=
> 1131                 zmd->nr_useable_zones++;=0A=
> 1132                 if (dmz_is_rnd(zone)) {=0A=
> 1133                         zmd->nr_rnd_zones++;=0A=
> 					^^^=0A=
> =0A=
> Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
=0A=
Good catch ! But you need to add a Fixes tag and CC stable.=0A=
=0A=
    Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target=
")=0A=
    Cc: stable@vger.kernel.org=0A=
=0A=
Other than that, looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
> ---=0A=
>  drivers/md/dm-zoned-metadata.c | 1 -=0A=
>  1 file changed, 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadat=
a.c=0A=
> index 516c7b6..369de15 100644=0A=
> --- a/drivers/md/dm-zoned-metadata.c=0A=
> +++ b/drivers/md/dm-zoned-metadata.c=0A=
> @@ -1109,7 +1109,6 @@ static int dmz_init_zone(struct blk_zone *blkz, uns=
igned int idx, void *data)=0A=
>  	switch (blkz->type) {=0A=
>  	case BLK_ZONE_TYPE_CONVENTIONAL:=0A=
>  		set_bit(DMZ_RND, &zone->flags);=0A=
> -		zmd->nr_rnd_zones++;=0A=
>  		break;=0A=
>  	case BLK_ZONE_TYPE_SEQWRITE_REQ:=0A=
>  	case BLK_ZONE_TYPE_SEQWRITE_PREF:=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
