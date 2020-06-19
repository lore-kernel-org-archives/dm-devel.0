From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/2] dm: update original bio sector on Zone Append
Date: Fri, 19 Jun 2020 07:52:22 +0000
Message-ID: <CY4PR04MB37511B64E85A60344AB2473AE7980@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
 <20200619065905.22228-2-johannes.thumshirn@wdc.com>
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
> Naohiro reported that issuing zone-append bios to a zoned block device=0A=
> underneath a dm-linear device does not work as expected.=0A=
> =0A=
> This because we forgot to reverse-map the sector the device wrote to the=
=0A=
> original bio.=0A=
> =0A=
> For zone-append bios, get the offset in the zone of the written sector=0A=
> from the clone bio and add that to the original bio's sector position.=0A=
> =0A=
> Reported-by: Naohiro Aota <Naohiro.Aota@wdc.com>=0A=
> Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")=0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/md/dm.c | 13 +++++++++++++=0A=
>  1 file changed, 13 insertions(+)=0A=
> =0A=
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c=0A=
> index 109e81f33edb..058c34abe9d1 100644=0A=
> --- a/drivers/md/dm.c=0A=
> +++ b/drivers/md/dm.c=0A=
> @@ -1009,6 +1009,7 @@ static void clone_endio(struct bio *bio)=0A=
>  	struct dm_io *io =3D tio->io;=0A=
>  	struct mapped_device *md =3D tio->io->md;=0A=
>  	dm_endio_fn endio =3D tio->ti->type->end_io;=0A=
> +	struct bio *orig_bio =3D io->orig_bio;=0A=
>  =0A=
>  	if (unlikely(error =3D=3D BLK_STS_TARGET) && md->type !=3D DM_TYPE_NVME=
_BIO_BASED) {=0A=
>  		if (bio_op(bio) =3D=3D REQ_OP_DISCARD &&=0A=
> @@ -1022,6 +1023,18 @@ static void clone_endio(struct bio *bio)=0A=
>  			disable_write_zeroes(md);=0A=
>  	}=0A=
>  =0A=
> +	/*=0A=
> +	 * for zone-append bios get offset in zone of the written sector and ad=
d=0A=
> +	 * that to the original bio sector pos.=0A=
> +	 */=0A=
> +	if (bio_op(orig_bio) =3D=3D REQ_OP_ZONE_APPEND) {=0A=
> +		sector_t written_sector =3D bio->bi_iter.bi_sector;=0A=
> +		struct request_queue *q =3D orig_bio->bi_disk->queue;=0A=
> +		u64 mask =3D (u64)blk_queue_zone_sectors(q) - 1;=0A=
> +=0A=
> +		orig_bio->bi_iter.bi_sector +=3D written_sector & mask;=0A=
> +	}=0A=
> +=0A=
>  	if (endio) {=0A=
>  		int r =3D endio(tio->ti, bio, &error);=0A=
>  		switch (r) {=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
