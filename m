From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH 2/2] dm: don't try to split REQ_OP_ZONE_APPEND bios
Date: Fri, 19 Jun 2020 07:54:27 +0000
Message-ID: <CY4PR04MB37514CDC42E7F545244D66C6E7980@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
 <20200619065905.22228-3-johannes.thumshirn@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-Id: dm-devel.ids

On 2020/06/19 15:59, Johannes Thumshirn wrote:=0A=
> REQ_OP_ZONE_APPEND bios cannot be split so return EIO if we can't fit it=
=0A=
> into one IO.=0A=
> =0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/md/dm.c | 3 +++=0A=
>  1 file changed, 3 insertions(+)=0A=
> =0A=
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c=0A=
> index 058c34abe9d1..c720a7e3269a 100644=0A=
> --- a/drivers/md/dm.c=0A=
> +++ b/drivers/md/dm.c=0A=
> @@ -1609,6 +1609,9 @@ static int __split_and_process_non_flush(struct clo=
ne_info *ci)=0A=
>  =0A=
>  	len =3D min_t(sector_t, max_io_len(ci->sector, ti), ci->sector_count);=
=0A=
>  =0A=
> +	if (bio_op(ci->bio) =3D=3D REQ_OP_ZONE_APPEND && len < ci->sector_count=
)=0A=
> +		return -EIO;=0A=
> +=0A=
>  	r =3D __clone_and_map_data_bio(ci, ti, ci->sector, &len);=0A=
>  	if (r < 0)=0A=
>  		return r;=0A=
> =0A=
=0A=
I think this is OK. The stacked max_zone_append_sectors limit should have=
=0A=
prevented that to happen  in the first place I think, but better safe than =
sorry.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
