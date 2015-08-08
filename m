From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Sat, 08 Aug 2015 10:52:24 +0200
Message-ID: <55C5C348.1070307@suse.de>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org>	<20150731192337.GA8907@redhat.com>	<CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>	<20150731213831.GA16464@redhat.com> <1438412290.26596.14.camel@hasee>	<20150801163356.GA21478@redhat.com> <1438581502.26596.24.camel@hasee>	<20150804113626.GA12682@lst.de> <1438754604.29731.31.camel@hasee>	<20150807073001.GA17485@lst.de> <1438990806.24452.8.camel@ssi>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438990806.24452.8.camel@ssi>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Neil@redhat.com, Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@canonical.com>, Al@redhat.com, Alasdair Kergon <agk@redhat.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Ming Lin <ming.l@ssi.samsung.com>, Oleg Drokin <oleg.drokin@intel.com>, Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Andreas Dilger <andreas.dilger@intel.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, Dongsu Park <dpark@posteo.net>, drbd-user@lists.linbit.com
List-Id: dm-devel.ids

On 08/08/2015 01:40 AM, Ming Lin wrote:
>=20
> On Fri, 2015-08-07 at 09:30 +0200, Christoph Hellwig wrote:
>> I'm for solution 3:
>>
>>  - keep blk_bio_{discard,write_same}_split, but ensure we never buil=
t
>>    a > 4GB bio in blkdev_issue_{discard,write_same}.
>=20
> This has problem as I mentioned in solution 1.
> We need to also make sure max discard size is of proper granularity.
> See below example.
>=20
>       4G: 8388608 sectors
> UINT_MAX: 8388607 sectors
>=20
> dm-thinp block size =3D default discard granularity =3D 128 sectors
>=20
> blkdev_issue_discard(sector=3D0, nr_sectors=3D8388608)
>=20
> 1. Only ensure bi_size not overflow
>=20
> It doesn't work.
>=20
> [start_sector, end_sector]
> [0, 8388607]
>     [0, 8388606], then dm-thinp splits it to 2 bios
>         [0, 8388479]
>         [8388480, 8388606] ---> this has problem in process_discard_b=
io(),
>                                 because the discard size(7 sectors) c=
overs less than a block(128 sectors)
>     [8388607, 8388607] ---> same problem=20
>=20
> 2. Ensure bi_size not overflow and max discard size is of proper gran=
ularity
>=20
> It works.
>=20
> [start_sector, end_sector]
> [0, 8388607]
>     [0, 8388479]
>     [8388480, 8388607]
>=20
>=20
> So how about below patch?
>=20
> commit 1ca2ad977255efb3c339f4ca16fb798ed5ec54f7
> Author: Ming Lin <ming.l@ssi.samsung.com>
> Date:   Fri Aug 7 15:07:07 2015 -0700
>=20
>     block: remove split code in blkdev_issue_{discard,write_same}
>    =20
>     The split code in blkdev_issue_{discard,write_same} can go away
>     now that any driver that cares does the split. We have to make
>     sure bio size doesn't overflow.
>    =20
>     For discard, we ensure max_discard_sectors is of the proper
>     granularity. So if discard size > 4G, blkdev_issue_discard() alwa=
ys
>     send multiple granularity requests to lower level, except that th=
e
>     last one may be not multiple granularity.
>    =20
>     Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>
> ---
>  block/blk-lib.c | 37 +++++++++----------------------------
>  1 file changed, 9 insertions(+), 28 deletions(-)
>=20
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 7688ee3..e178a07 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -44,7 +44,6 @@ int blkdev_issue_discard(struct block_device *bdev,=
 sector_t sector,
>  	struct request_queue *q =3D bdev_get_queue(bdev);
>  	int type =3D REQ_WRITE | REQ_DISCARD;
>  	unsigned int max_discard_sectors, granularity;
> -	int alignment;
>  	struct bio_batch bb;
>  	struct bio *bio;
>  	int ret =3D 0;
> @@ -58,18 +57,15 @@ int blkdev_issue_discard(struct block_device *bde=
v, sector_t sector,
> =20
>  	/* Zero-sector (unknown) and one-sector granularities are the same.=
  */
>  	granularity =3D max(q->limits.discard_granularity >> 9, 1U);
> -	alignment =3D (bdev_discard_alignment(bdev) >> 9) % granularity;
> =20
>  	/*
> -	 * Ensure that max_discard_sectors is of the proper
> -	 * granularity, so that requests stay aligned after a split.
> -	 */
> -	max_discard_sectors =3D min(q->limits.max_discard_sectors, UINT_MAX=
 >> 9);
> +	 * Ensure that max_discard_sectors doesn't overflow bi_size and is =
of
> +	 * the proper granularity. So if discard size > 4G, blkdev_issue_di=
scard()
> +	 * always split and send multiple granularity requests to lower lev=
el,
> +	 * except that the last one may be not multiple granularity.
> +         */
> +	max_discard_sectors =3D UINT_MAX >> 9;
>  	max_discard_sectors -=3D max_discard_sectors % granularity;
> -	if (unlikely(!max_discard_sectors)) {
> -		/* Avoid infinite loop below. Being cautious never hurts. */
> -		return -EOPNOTSUPP;
> -	}
> =20
>  	if (flags & BLKDEV_DISCARD_SECURE) {
>  		if (!blk_queue_secdiscard(q))
> @@ -84,7 +80,7 @@ int blkdev_issue_discard(struct block_device *bdev,=
 sector_t sector,
>  	blk_start_plug(&plug);
>  	while (nr_sects) {
>  		unsigned int req_sects;
> -		sector_t end_sect, tmp;
> +		sector_t end_sect;
> =20
>  		bio =3D bio_alloc(gfp_mask, 1);
>  		if (!bio) {
> @@ -93,20 +89,7 @@ int blkdev_issue_discard(struct block_device *bdev=
, sector_t sector,
>  		}
> =20
>  		req_sects =3D min_t(sector_t, nr_sects, max_discard_sectors);
> -
> -		/*
> -		 * If splitting a request, and the next starting sector would be
> -		 * misaligned, stop the discard at the previous aligned sector.
> -		 */
>  		end_sect =3D sector + req_sects;
> -		tmp =3D end_sect;
> -		if (req_sects < nr_sects &&
> -		    sector_div(tmp, granularity) !=3D alignment) {
> -			end_sect =3D end_sect - alignment;
> -			sector_div(end_sect, granularity);
> -			end_sect =3D end_sect * granularity + alignment;
> -			req_sects =3D end_sect - sector;
> -		}
> =20
>  		bio->bi_iter.bi_sector =3D sector;
>  		bio->bi_end_io =3D bio_batch_end_io;
> @@ -166,10 +149,8 @@ int blkdev_issue_write_same(struct block_device =
*bdev, sector_t sector,
>  	if (!q)
>  		return -ENXIO;
> =20
> -	max_write_same_sectors =3D q->limits.max_write_same_sectors;
> -
> -	if (max_write_same_sectors =3D=3D 0)
> -		return -EOPNOTSUPP;
> +	/* Ensure that max_write_same_sectors doesn't overflow bi_size */
> +	max_write_same_sectors =3D UINT_MAX >> 9;
> =20
>  	atomic_set(&bb.done, 1);
>  	bb.flags =3D 1 << BIO_UPTODATE;
>=20
Wouldn't it be easier to move both max_write_same_sectors and
max_discard sectors to 64 bit (ie to type sector_t) and be done with th=
e
overflow?
Seems to me this is far too much coding around self-imposed restriction=
s...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
