From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm-devel] [PATCH] dm zoned: Avoid 64-bit division error in
 dmz_fixup_devices
Date: Thu, 14 May 2020 06:25:02 +0000
Message-ID: <BY5PR04MB690080527BC91E2DC9EDF0BBE7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200513084521.461116-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 2020/05/14 14:07, Nathan Chancellor wrote:=0A=
> When building arm32 allyesconfig:=0A=
> =0A=
> ld.lld: error: undefined symbol: __aeabi_uldivmod=0A=
>>>> referenced by dm-zoned-target.c=0A=
>>>>               md/dm-zoned-target.o:(dmz_ctr) in archive drivers/built-=
in.a=0A=
> =0A=
> dmz_fixup_devices uses DIV_ROUND_UP with variables of type sector_t. As=
=0A=
> such, it should be using DIV_ROUND_UP_SECTOR_T, which handles this=0A=
> automatically.=0A=
> =0A=
> Fixes: 70978208ec91 ("dm zoned: metadata version 2")=0A=
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>=0A=
> ---=0A=
>  drivers/md/dm-zoned-target.c | 5 +++--=0A=
>  1 file changed, 3 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c=
=0A=
> index ea43f6892ced..9c4fd4b04878 100644=0A=
> --- a/drivers/md/dm-zoned-target.c=0A=
> +++ b/drivers/md/dm-zoned-target.c=0A=
> @@ -803,8 +803,9 @@ static int dmz_fixup_devices(struct dm_target *ti)=0A=
>  =0A=
>  	if (reg_dev) {=0A=
>  		reg_dev->zone_nr_sectors =3D zoned_dev->zone_nr_sectors;=0A=
> -		reg_dev->nr_zones =3D DIV_ROUND_UP(reg_dev->capacity,=0A=
> -						 reg_dev->zone_nr_sectors);=0A=
> +		reg_dev->nr_zones =3D=0A=
> +			DIV_ROUND_UP_SECTOR_T(reg_dev->capacity,=0A=
> +					      reg_dev->zone_nr_sectors);>  		zoned_dev->zone_offset =3D reg=
_dev->nr_zones;=0A=
>  	}=0A=
>  	return 0;=0A=
> =0A=
> base-commit: e098d7762d602be640c53565ceca342f81e55ad2=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
