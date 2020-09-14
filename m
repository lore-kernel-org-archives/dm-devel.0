From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] block: allow 'chunk_sectors' to be non-power-of-2
Date: Mon, 14 Sep 2020 00:55:43 +0000
Message-ID: <CY4PR04MB37516E15A40D808D4810D26BE7230@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
 <20200911215338.44805-4-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>
Cc: Vijayendra Suman <vijayendra.suman@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On 2020/09/12 6:53, Mike Snitzer wrote:=0A=
> It is possible for a block device to use a non power-of-2 for chunk=0A=
> size which results in a full-stripe size that is also a non=0A=
> power-of-2.=0A=
> =0A=
> Update blk_queue_chunk_sectors() and blk_max_size_offset() to=0A=
> accommodate drivers that need a non power-of-2 chunk_sectors.=0A=
> =0A=
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>=0A=
> ---=0A=
>  block/blk-settings.c   | 10 ++++------=0A=
>  include/linux/blkdev.h | 12 +++++++++---=0A=
>  2 files changed, 13 insertions(+), 9 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index b09642d5f15e..e40a162cc946 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -172,15 +172,13 @@ EXPORT_SYMBOL(blk_queue_max_hw_sectors);=0A=
>   *=0A=
>   * Description:=0A=
>   *    If a driver doesn't want IOs to cross a given chunk size, it can s=
et=0A=
> - *    this limit and prevent merging across chunks. Note that the chunk =
size=0A=
> - *    must currently be a power-of-2 in sectors. Also note that the bloc=
k=0A=
> - *    layer must accept a page worth of data at any offset. So if the=0A=
> - *    crossing of chunks is a hard limitation in the driver, it must sti=
ll be=0A=
> - *    prepared to split single page bios.=0A=
> + *    this limit and prevent merging across chunks. Note that the block =
layer=0A=
> + *    must accept a page worth of data at any offset. So if the crossing=
 of=0A=
> + *    chunks is a hard limitation in the driver, it must still be prepar=
ed=0A=
> + *    to split single page bios.=0A=
>   **/=0A=
>  void blk_queue_chunk_sectors(struct request_queue *q, unsigned int chunk=
_sectors)=0A=
>  {=0A=
> -	BUG_ON(!is_power_of_2(chunk_sectors));=0A=
>  	q->limits.chunk_sectors =3D chunk_sectors;=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_queue_chunk_sectors);=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 453a3d735d66..e72bcce22143 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -1059,11 +1059,17 @@ static inline unsigned int blk_queue_get_max_sect=
ors(struct request_queue *q,=0A=
>  static inline unsigned int blk_max_size_offset(struct request_queue *q,=
=0A=
>  					       sector_t offset)=0A=
>  {=0A=
> -	if (!q->limits.chunk_sectors)=0A=
> +	unsigned int chunk_sectors =3D q->limits.chunk_sectors;=0A=
> +=0A=
> +	if (!chunk_sectors)=0A=
>  		return q->limits.max_sectors;=0A=
>  =0A=
> -	return min(q->limits.max_sectors, (unsigned int)(q->limits.chunk_sector=
s -=0A=
> -			(offset & (q->limits.chunk_sectors - 1))));=0A=
> +	if (is_power_of_2(chunk_sectors))=0A=
> +		chunk_sectors -=3D (offset & (chunk_sectors - 1));=0A=
=0A=
I do not think you need the outer parenthesis here.=0A=
=0A=
> +	else=0A=
> +		chunk_sectors -=3D sector_div(offset, chunk_sectors);=0A=
> +=0A=
> +	return min(q->limits.max_sectors, chunk_sectors);=0A=
>  }=0A=
>  =0A=
>  static inline unsigned int blk_rq_get_max_sectors(struct request *rq,=0A=
> =0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
