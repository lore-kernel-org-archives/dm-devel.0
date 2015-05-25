From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4 08/11] block: kill merge_bvec_fn() completely
Date: Mon, 25 May 2015 15:49:23 +1000
Message-ID: <20150525154923.210f875a@notabene.brown>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-9-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rX5O2L7Boki6JJuYf/HxdXj"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432318723-18829-9-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--Sig_/rX5O2L7Boki6JJuYf/HxdXj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2015 11:18:40 -0700 Ming Lin <mlin@kernel.org> wrote:

> From: Kent Overstreet <kent.overstreet@gmail.com>
>=20
> As generic_make_request() is now able to handle arbitrarily sized bios,
> it's no longer necessary for each individual block driver to define its
> own ->merge_bvec_fn() callback. Remove every invocation completely.
>=20
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
> Cc: drbd-user@lists.linbit.com
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Yehuda Sadeh <yehuda@inktank.com>
> Cc: Sage Weil <sage@inktank.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: ceph-devel@vger.kernel.org
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> [dpark: also remove ->merge_bvec_fn() in dm-thin as well as
>  dm-era-target, and resolve merge conflicts]
> Signed-off-by: Dongsu Park <dpark@posteo.net>
> Signed-off-by: Ming Lin <mlin@kernel.org>

Acked-by: NeilBrown <neilb@suse.de> (for the 'md' bits)

Very happy to see this happening!

Thanks,
NeilBrown


> ---
>  block/blk-merge.c              |  17 +-----
>  block/blk-settings.c           |  22 --------
>  drivers/block/drbd/drbd_int.h  |   1 -
>  drivers/block/drbd/drbd_main.c |   1 -
>  drivers/block/drbd/drbd_req.c  |  35 ------------
>  drivers/block/pktcdvd.c        |  21 -------
>  drivers/block/rbd.c            |  47 ----------------
>  drivers/md/dm-cache-target.c   |  21 -------
>  drivers/md/dm-crypt.c          |  16 ------
>  drivers/md/dm-era-target.c     |  15 -----
>  drivers/md/dm-flakey.c         |  16 ------
>  drivers/md/dm-linear.c         |  16 ------
>  drivers/md/dm-log-writes.c     |  16 ------
>  drivers/md/dm-snap.c           |  15 -----
>  drivers/md/dm-stripe.c         |  21 -------
>  drivers/md/dm-table.c          |   8 ---
>  drivers/md/dm-thin.c           |  31 -----------
>  drivers/md/dm-verity.c         |  16 ------
>  drivers/md/dm.c                | 120 +----------------------------------=
-----
>  drivers/md/dm.h                |   2 -
>  drivers/md/linear.c            |  43 ---------------
>  drivers/md/md.c                |  26 ---------
>  drivers/md/md.h                |  12 ----
>  drivers/md/multipath.c         |  21 -------
>  drivers/md/raid0.c             |  56 -------------------
>  drivers/md/raid0.h             |   2 -
>  drivers/md/raid1.c             |  58 +-------------------
>  drivers/md/raid10.c            | 121 +----------------------------------=
------
>  drivers/md/raid5.c             |  32 -----------
>  include/linux/blkdev.h         |  10 ----
>  include/linux/device-mapper.h  |   4 --
>  31 files changed, 9 insertions(+), 833 deletions(-)
>=20
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index dc14255..25cafb8 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -69,24 +69,13 @@ static struct bio *blk_bio_segment_split(struct reque=
st_queue *q,
>  	struct bio *split;
>  	struct bio_vec bv, bvprv;
>  	struct bvec_iter iter;
> -	unsigned seg_size =3D 0, nsegs =3D 0;
> +	unsigned seg_size =3D 0, nsegs =3D 0, sectors =3D 0;
>  	int prev =3D 0;
> =20
> -	struct bvec_merge_data bvm =3D {
> -		.bi_bdev	=3D bio->bi_bdev,
> -		.bi_sector	=3D bio->bi_iter.bi_sector,
> -		.bi_size	=3D 0,
> -		.bi_rw		=3D bio->bi_rw,
> -	};
> -
>  	bio_for_each_segment(bv, bio, iter) {
> -		if (q->merge_bvec_fn &&
> -		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
> -			goto split;
> -
> -		bvm.bi_size +=3D bv.bv_len;
> +		sectors +=3D bv.bv_len >> 9;
> =20
> -		if (bvm.bi_size >> 9 > queue_max_sectors(q))
> +		if (sectors > queue_max_sectors(q))
>  			goto split;
> =20
>  		/*
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 12600bf..e90d477 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -53,28 +53,6 @@ void blk_queue_unprep_rq(struct request_queue *q, unpr=
ep_rq_fn *ufn)
>  }
>  EXPORT_SYMBOL(blk_queue_unprep_rq);
> =20
> -/**
> - * blk_queue_merge_bvec - set a merge_bvec function for queue
> - * @q:		queue
> - * @mbfn:	merge_bvec_fn
> - *
> - * Usually queues have static limitations on the max sectors or segments=
 that
> - * we can put in a request. Stacking drivers may have some settings that
> - * are dynamic, and thus we have to query the queue whether it is ok to
> - * add a new bio_vec to a bio at a given offset or not. If the block dev=
ice
> - * has such limitations, it needs to register a merge_bvec_fn to control
> - * the size of bio's sent to it. Note that a block device *must* allow a
> - * single page to be added to an empty bio. The block device driver may =
want
> - * to use the bio_split() function to deal with these bio's. By default
> - * no merge_bvec_fn is defined for a queue, and only the fixed limits are
> - * honored.
> - */
> -void blk_queue_merge_bvec(struct request_queue *q, merge_bvec_fn *mbfn)
> -{
> -	q->merge_bvec_fn =3D mbfn;
> -}
> -EXPORT_SYMBOL(blk_queue_merge_bvec);
> -
>  void blk_queue_softirq_done(struct request_queue *q, softirq_done_fn *fn)
>  {
>  	q->softirq_done_fn =3D fn;
> diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
> index b905e98..63ce2b0 100644
> --- a/drivers/block/drbd/drbd_int.h
> +++ b/drivers/block/drbd/drbd_int.h
> @@ -1449,7 +1449,6 @@ extern void do_submit(struct work_struct *ws);
>  extern void __drbd_make_request(struct drbd_device *, struct bio *, unsi=
gned long);
>  extern void drbd_make_request(struct request_queue *q, struct bio *bio);
>  extern int drbd_read_remote(struct drbd_device *device, struct drbd_requ=
est *req);
> -extern int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_da=
ta *bvm, struct bio_vec *bvec);
>  extern int is_valid_ar_handle(struct drbd_request *, sector_t);
> =20
> =20
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_mai=
n.c
> index 81fde9e..771e68c 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -2774,7 +2774,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_c=
onfig_context *adm_ctx, unsig
>  	   This triggers a max_bio_size message upon first attach or connect */
>  	blk_queue_max_hw_sectors(q, DRBD_MAX_BIO_SIZE_SAFE >> 8);
>  	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
> -	blk_queue_merge_bvec(q, drbd_merge_bvec);
>  	q->queue_lock =3D &resource->req_lock;
> =20
>  	device->md_io.page =3D alloc_page(GFP_KERNEL);
> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index a6265bc..7523f00 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -1510,41 +1510,6 @@ void drbd_make_request(struct request_queue *q, st=
ruct bio *bio)
>  	__drbd_make_request(device, bio, start_jif);
>  }
> =20
> -/* This is called by bio_add_page().
> - *
> - * q->max_hw_sectors and other global limits are already enforced there.
> - *
> - * We need to call down to our lower level device,
> - * in case it has special restrictions.
> - *
> - * We also may need to enforce configured max-bio-bvecs limits.
> - *
> - * As long as the BIO is empty we have to allow at least one bvec,
> - * regardless of size and offset, so no need to ask lower levels.
> - */
> -int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm=
, struct bio_vec *bvec)
> -{
> -	struct drbd_device *device =3D (struct drbd_device *) q->queuedata;
> -	unsigned int bio_size =3D bvm->bi_size;
> -	int limit =3D DRBD_MAX_BIO_SIZE;
> -	int backing_limit;
> -
> -	if (bio_size && get_ldev(device)) {
> -		unsigned int max_hw_sectors =3D queue_max_hw_sectors(q);
> -		struct request_queue * const b =3D
> -			device->ldev->backing_bdev->bd_disk->queue;
> -		if (b->merge_bvec_fn) {
> -			bvm->bi_bdev =3D device->ldev->backing_bdev;
> -			backing_limit =3D b->merge_bvec_fn(b, bvm, bvec);
> -			limit =3D min(limit, backing_limit);
> -		}
> -		put_ldev(device);
> -		if ((limit >> 9) > max_hw_sectors)
> -			limit =3D max_hw_sectors << 9;
> -	}
> -	return limit;
> -}
> -
>  void request_timer_fn(unsigned long data)
>  {
>  	struct drbd_device *device =3D (struct drbd_device *) data;
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index ea10bd9..85eac23 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2505,26 +2505,6 @@ end_io:
> =20
> =20
> =20
> -static int pkt_merge_bvec(struct request_queue *q, struct bvec_merge_dat=
a *bmd,
> -			  struct bio_vec *bvec)
> -{
> -	struct pktcdvd_device *pd =3D q->queuedata;
> -	sector_t zone =3D get_zone(bmd->bi_sector, pd);
> -	int used =3D ((bmd->bi_sector - zone) << 9) + bmd->bi_size;
> -	int remaining =3D (pd->settings.size << 9) - used;
> -	int remaining2;
> -
> -	/*
> -	 * A bio <=3D PAGE_SIZE must be allowed. If it crosses a packet
> -	 * boundary, pkt_make_request() will split the bio.
> -	 */
> -	remaining2 =3D PAGE_SIZE - bmd->bi_size;
> -	remaining =3D max(remaining, remaining2);
> -
> -	BUG_ON(remaining < 0);
> -	return remaining;
> -}
> -
>  static void pkt_init_queue(struct pktcdvd_device *pd)
>  {
>  	struct request_queue *q =3D pd->disk->queue;
> @@ -2532,7 +2512,6 @@ static void pkt_init_queue(struct pktcdvd_device *p=
d)
>  	blk_queue_make_request(q, pkt_make_request);
>  	blk_queue_logical_block_size(q, CD_FRAMESIZE);
>  	blk_queue_max_hw_sectors(q, PACKET_MAX_SECTORS);
> -	blk_queue_merge_bvec(q, pkt_merge_bvec);
>  	q->queuedata =3D pd;
>  }
> =20
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index ec6c5c6..f50edb3 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -3440,52 +3440,6 @@ static int rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	return BLK_MQ_RQ_QUEUE_OK;
>  }
> =20
> -/*
> - * a queue callback. Makes sure that we don't create a bio that spans ac=
ross
> - * multiple osd objects. One exception would be with a single page bios,
> - * which we handle later at bio_chain_clone_range()
> - */
> -static int rbd_merge_bvec(struct request_queue *q, struct bvec_merge_dat=
a *bmd,
> -			  struct bio_vec *bvec)
> -{
> -	struct rbd_device *rbd_dev =3D q->queuedata;
> -	sector_t sector_offset;
> -	sector_t sectors_per_obj;
> -	sector_t obj_sector_offset;
> -	int ret;
> -
> -	/*
> -	 * Find how far into its rbd object the partition-relative
> -	 * bio start sector is to offset relative to the enclosing
> -	 * device.
> -	 */
> -	sector_offset =3D get_start_sect(bmd->bi_bdev) + bmd->bi_sector;
> -	sectors_per_obj =3D 1 << (rbd_dev->header.obj_order - SECTOR_SHIFT);
> -	obj_sector_offset =3D sector_offset & (sectors_per_obj - 1);
> -
> -	/*
> -	 * Compute the number of bytes from that offset to the end
> -	 * of the object.  Account for what's already used by the bio.
> -	 */
> -	ret =3D (int) (sectors_per_obj - obj_sector_offset) << SECTOR_SHIFT;
> -	if (ret > bmd->bi_size)
> -		ret -=3D bmd->bi_size;
> -	else
> -		ret =3D 0;
> -
> -	/*
> -	 * Don't send back more than was asked for.  And if the bio
> -	 * was empty, let the whole thing through because:  "Note
> -	 * that a block device *must* allow a single page to be
> -	 * added to an empty bio."
> -	 */
> -	rbd_assert(bvec->bv_len <=3D PAGE_SIZE);
> -	if (ret > (int) bvec->bv_len || !bmd->bi_size)
> -		ret =3D (int) bvec->bv_len;
> -
> -	return ret;
> -}
> -
>  static void rbd_free_disk(struct rbd_device *rbd_dev)
>  {
>  	struct gendisk *disk =3D rbd_dev->disk;
> @@ -3784,7 +3738,6 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
>  	q->limits.max_discard_sectors =3D segment_size / SECTOR_SIZE;
>  	q->limits.discard_zeroes_data =3D 1;
> =20
> -	blk_queue_merge_bvec(q, rbd_merge_bvec);
>  	disk->queue =3D q;
> =20
>  	q->queuedata =3D rbd_dev;
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 7755af3..2e47e35 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -3289,26 +3289,6 @@ static int cache_iterate_devices(struct dm_target =
*ti,
>  	return r;
>  }
> =20
> -/*
> - * We assume I/O is going to the origin (which is the volume
> - * more likely to have restrictions e.g. by being striped).
> - * (Looking up the exact location of the data would be expensive
> - * and could always be out of date by the time the bio is submitted.)
> - */
> -static int cache_bvec_merge(struct dm_target *ti,
> -			    struct bvec_merge_data *bvm,
> -			    struct bio_vec *biovec, int max_size)
> -{
> -	struct cache *cache =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(cache->origin_dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D cache->origin_dev->bdev;
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static void set_discard_limits(struct cache *cache, struct queue_limits =
*limits)
>  {
>  	/*
> @@ -3352,7 +3332,6 @@ static struct target_type cache_target =3D {
>  	.status =3D cache_status,
>  	.message =3D cache_message,
>  	.iterate_devices =3D cache_iterate_devices,
> -	.merge =3D cache_bvec_merge,
>  	.io_hints =3D cache_io_hints,
>  };
> =20
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 5503e43..d13f330 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2017,21 +2017,6 @@ error:
>  	return -EINVAL;
>  }
> =20
> -static int crypt_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> -		       struct bio_vec *biovec, int max_size)
> -{
> -	struct crypt_config *cc =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(cc->dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D cc->dev->bdev;
> -	bvm->bi_sector =3D cc->start + dm_target_offset(ti, bvm->bi_sector);
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static int crypt_iterate_devices(struct dm_target *ti,
>  				 iterate_devices_callout_fn fn, void *data)
>  {
> @@ -2052,7 +2037,6 @@ static struct target_type crypt_target =3D {
>  	.preresume =3D crypt_preresume,
>  	.resume =3D crypt_resume,
>  	.message =3D crypt_message,
> -	.merge  =3D crypt_merge,
>  	.iterate_devices =3D crypt_iterate_devices,
>  };
> =20
> diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> index ad913cd..0119ebf 100644
> --- a/drivers/md/dm-era-target.c
> +++ b/drivers/md/dm-era-target.c
> @@ -1673,20 +1673,6 @@ static int era_iterate_devices(struct dm_target *t=
i,
>  	return fn(ti, era->origin_dev, 0, get_dev_size(era->origin_dev), data);
>  }
> =20
> -static int era_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> -		     struct bio_vec *biovec, int max_size)
> -{
> -	struct era *era =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(era->origin_dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D era->origin_dev->bdev;
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static void era_io_hints(struct dm_target *ti, struct queue_limits *limi=
ts)
>  {
>  	struct era *era =3D ti->private;
> @@ -1717,7 +1703,6 @@ static struct target_type era_target =3D {
>  	.status =3D era_status,
>  	.message =3D era_message,
>  	.iterate_devices =3D era_iterate_devices,
> -	.merge =3D era_merge,
>  	.io_hints =3D era_io_hints
>  };
> =20
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index b257e46..d955b3e 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -387,21 +387,6 @@ static int flakey_ioctl(struct dm_target *ti, unsign=
ed int cmd, unsigned long ar
>  	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
>  }
> =20
> -static int flakey_merge(struct dm_target *ti, struct bvec_merge_data *bv=
m,
> -			struct bio_vec *biovec, int max_size)
> -{
> -	struct flakey_c *fc =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(fc->dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D fc->dev->bdev;
> -	bvm->bi_sector =3D flakey_map_sector(ti, bvm->bi_sector);
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static int flakey_iterate_devices(struct dm_target *ti, iterate_devices_=
callout_fn fn, void *data)
>  {
>  	struct flakey_c *fc =3D ti->private;
> @@ -419,7 +404,6 @@ static struct target_type flakey_target =3D {
>  	.end_io =3D flakey_end_io,
>  	.status =3D flakey_status,
>  	.ioctl	=3D flakey_ioctl,
> -	.merge	=3D flakey_merge,
>  	.iterate_devices =3D flakey_iterate_devices,
>  };
> =20
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 53e848c..7dd5fc8 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -130,21 +130,6 @@ static int linear_ioctl(struct dm_target *ti, unsign=
ed int cmd,
>  	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
>  }
> =20
> -static int linear_merge(struct dm_target *ti, struct bvec_merge_data *bv=
m,
> -			struct bio_vec *biovec, int max_size)
> -{
> -	struct linear_c *lc =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(lc->dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D lc->dev->bdev;
> -	bvm->bi_sector =3D linear_map_sector(ti, bvm->bi_sector);
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static int linear_iterate_devices(struct dm_target *ti,
>  				  iterate_devices_callout_fn fn, void *data)
>  {
> @@ -162,7 +147,6 @@ static struct target_type linear_target =3D {
>  	.map    =3D linear_map,
>  	.status =3D linear_status,
>  	.ioctl  =3D linear_ioctl,
> -	.merge  =3D linear_merge,
>  	.iterate_devices =3D linear_iterate_devices,
>  };
> =20
> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
> index 93e0844..4325808 100644
> --- a/drivers/md/dm-log-writes.c
> +++ b/drivers/md/dm-log-writes.c
> @@ -728,21 +728,6 @@ static int log_writes_ioctl(struct dm_target *ti, un=
signed int cmd,
>  	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
>  }
> =20
> -static int log_writes_merge(struct dm_target *ti, struct bvec_merge_data=
 *bvm,
> -			    struct bio_vec *biovec, int max_size)
> -{
> -	struct log_writes_c *lc =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(lc->dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D lc->dev->bdev;
> -	bvm->bi_sector =3D dm_target_offset(ti, bvm->bi_sector);
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static int log_writes_iterate_devices(struct dm_target *ti,
>  				      iterate_devices_callout_fn fn,
>  				      void *data)
> @@ -796,7 +781,6 @@ static struct target_type log_writes_target =3D {
>  	.end_io =3D normal_end_io,
>  	.status =3D log_writes_status,
>  	.ioctl	=3D log_writes_ioctl,
> -	.merge	=3D log_writes_merge,
>  	.message =3D log_writes_message,
>  	.iterate_devices =3D log_writes_iterate_devices,
>  	.io_hints =3D log_writes_io_hints,
> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> index f83a0f3..274cbec 100644
> --- a/drivers/md/dm-snap.c
> +++ b/drivers/md/dm-snap.c
> @@ -2331,20 +2331,6 @@ static void origin_status(struct dm_target *ti, st=
atus_type_t type,
>  	}
>  }
> =20
> -static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bv=
m,
> -			struct bio_vec *biovec, int max_size)
> -{
> -	struct dm_origin *o =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(o->dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D o->dev->bdev;
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static int origin_iterate_devices(struct dm_target *ti,
>  				  iterate_devices_callout_fn fn, void *data)
>  {
> @@ -2363,7 +2349,6 @@ static struct target_type origin_target =3D {
>  	.resume  =3D origin_resume,
>  	.postsuspend =3D origin_postsuspend,
>  	.status  =3D origin_status,
> -	.merge	 =3D origin_merge,
>  	.iterate_devices =3D origin_iterate_devices,
>  };
> =20
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index f8b37d4..09bb2fe 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -412,26 +412,6 @@ static void stripe_io_hints(struct dm_target *ti,
>  	blk_limits_io_opt(limits, chunk_size * sc->stripes);
>  }
> =20
> -static int stripe_merge(struct dm_target *ti, struct bvec_merge_data *bv=
m,
> -			struct bio_vec *biovec, int max_size)
> -{
> -	struct stripe_c *sc =3D ti->private;
> -	sector_t bvm_sector =3D bvm->bi_sector;
> -	uint32_t stripe;
> -	struct request_queue *q;
> -
> -	stripe_map_sector(sc, bvm_sector, &stripe, &bvm_sector);
> -
> -	q =3D bdev_get_queue(sc->stripe[stripe].dev->bdev);
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D sc->stripe[stripe].dev->bdev;
> -	bvm->bi_sector =3D sc->stripe[stripe].physical_start + bvm_sector;
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static struct target_type stripe_target =3D {
>  	.name   =3D "striped",
>  	.version =3D {1, 5, 1},
> @@ -443,7 +423,6 @@ static struct target_type stripe_target =3D {
>  	.status =3D stripe_status,
>  	.iterate_devices =3D stripe_iterate_devices,
>  	.io_hints =3D stripe_io_hints,
> -	.merge  =3D stripe_merge,
>  };
> =20
>  int __init dm_stripe_init(void)
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index d9b00b8..19c9b01 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -440,14 +440,6 @@ static int dm_set_device_limits(struct dm_target *ti=
, struct dm_dev *dev,
>  		       q->limits.alignment_offset,
>  		       (unsigned long long) start << SECTOR_SHIFT);
> =20
> -	/*
> -	 * Check if merge fn is supported.
> -	 * If not we'll force DM to use PAGE_SIZE or
> -	 * smaller I/O, just to be safe.
> -	 */
> -	if (dm_queue_merge_is_compulsory(q) && !ti->type->merge)
> -		blk_limits_max_hw_sectors(limits,
> -					  (unsigned int) (PAGE_SIZE >> 9));
>  	return 0;
>  }
> =20
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index 921aafd..03552fe 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -3562,20 +3562,6 @@ static int pool_iterate_devices(struct dm_target *=
ti,
>  	return fn(ti, pt->data_dev, 0, ti->len, data);
>  }
> =20
> -static int pool_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> -		      struct bio_vec *biovec, int max_size)
> -{
> -	struct pool_c *pt =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(pt->data_dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D pt->data_dev->bdev;
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static void set_discard_limits(struct pool_c *pt, struct queue_limits *l=
imits)
>  {
>  	struct pool *pool =3D pt->pool;
> @@ -3667,7 +3653,6 @@ static struct target_type pool_target =3D {
>  	.resume =3D pool_resume,
>  	.message =3D pool_message,
>  	.status =3D pool_status,
> -	.merge =3D pool_merge,
>  	.iterate_devices =3D pool_iterate_devices,
>  	.io_hints =3D pool_io_hints,
>  };
> @@ -3992,21 +3977,6 @@ err:
>  	DMEMIT("Error");
>  }
> =20
> -static int thin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> -		      struct bio_vec *biovec, int max_size)
> -{
> -	struct thin_c *tc =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(tc->pool_dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D tc->pool_dev->bdev;
> -	bvm->bi_sector =3D dm_target_offset(ti, bvm->bi_sector);
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static int thin_iterate_devices(struct dm_target *ti,
>  				iterate_devices_callout_fn fn, void *data)
>  {
> @@ -4041,7 +4011,6 @@ static struct target_type thin_target =3D {
>  	.presuspend =3D thin_presuspend,
>  	.postsuspend =3D thin_postsuspend,
>  	.status =3D thin_status,
> -	.merge =3D thin_merge,
>  	.iterate_devices =3D thin_iterate_devices,
>  };
> =20
> diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
> index 66616db..3b85460 100644
> --- a/drivers/md/dm-verity.c
> +++ b/drivers/md/dm-verity.c
> @@ -648,21 +648,6 @@ static int verity_ioctl(struct dm_target *ti, unsign=
ed cmd,
>  				     cmd, arg);
>  }
> =20
> -static int verity_merge(struct dm_target *ti, struct bvec_merge_data *bv=
m,
> -			struct bio_vec *biovec, int max_size)
> -{
> -	struct dm_verity *v =3D ti->private;
> -	struct request_queue *q =3D bdev_get_queue(v->data_dev->bdev);
> -
> -	if (!q->merge_bvec_fn)
> -		return max_size;
> -
> -	bvm->bi_bdev =3D v->data_dev->bdev;
> -	bvm->bi_sector =3D verity_map_sector(v, bvm->bi_sector);
> -
> -	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> -}
> -
>  static int verity_iterate_devices(struct dm_target *ti,
>  				  iterate_devices_callout_fn fn, void *data)
>  {
> @@ -995,7 +980,6 @@ static struct target_type verity_target =3D {
>  	.map		=3D verity_map,
>  	.status		=3D verity_status,
>  	.ioctl		=3D verity_ioctl,
> -	.merge		=3D verity_merge,
>  	.iterate_devices =3D verity_iterate_devices,
>  	.io_hints	=3D verity_io_hints,
>  };
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 34f6063..f732a7a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -121,9 +121,8 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
>  #define DMF_FREEING 3
>  #define DMF_DELETING 4
>  #define DMF_NOFLUSH_SUSPENDING 5
> -#define DMF_MERGE_IS_OPTIONAL 6
> -#define DMF_DEFERRED_REMOVE 7
> -#define DMF_SUSPENDED_INTERNALLY 8
> +#define DMF_DEFERRED_REMOVE 6
> +#define DMF_SUSPENDED_INTERNALLY 7
> =20
>  /*
>   * A dummy definition to make RCU happy.
> @@ -1717,60 +1716,6 @@ static void __split_and_process_bio(struct mapped_=
device *md,
>   * CRUD END
>   *---------------------------------------------------------------*/
> =20
> -static int dm_merge_bvec(struct request_queue *q,
> -			 struct bvec_merge_data *bvm,
> -			 struct bio_vec *biovec)
> -{
> -	struct mapped_device *md =3D q->queuedata;
> -	struct dm_table *map =3D dm_get_live_table_fast(md);
> -	struct dm_target *ti;
> -	sector_t max_sectors;
> -	int max_size =3D 0;
> -
> -	if (unlikely(!map))
> -		goto out;
> -
> -	ti =3D dm_table_find_target(map, bvm->bi_sector);
> -	if (!dm_target_is_valid(ti))
> -		goto out;
> -
> -	/*
> -	 * Find maximum amount of I/O that won't need splitting
> -	 */
> -	max_sectors =3D min(max_io_len(bvm->bi_sector, ti),
> -			  (sector_t) queue_max_sectors(q));
> -	max_size =3D (max_sectors << SECTOR_SHIFT) - bvm->bi_size;
> -	if (unlikely(max_size < 0)) /* this shouldn't _ever_ happen */
> -		max_size =3D 0;
> -
> -	/*
> -	 * merge_bvec_fn() returns number of bytes
> -	 * it can accept at this offset
> -	 * max is precomputed maximal io size
> -	 */
> -	if (max_size && ti->type->merge)
> -		max_size =3D ti->type->merge(ti, bvm, biovec, max_size);
> -	/*
> -	 * If the target doesn't support merge method and some of the devices
> -	 * provided their merge_bvec method (we know this by looking for the
> -	 * max_hw_sectors that dm_set_device_limits may set), then we can't
> -	 * allow bios with multiple vector entries.  So always set max_size
> -	 * to 0, and the code below allows just one page.
> -	 */
> -	else if (queue_max_hw_sectors(q) <=3D PAGE_SIZE >> 9)
> -		max_size =3D 0;
> -
> -out:
> -	dm_put_live_table_fast(md);
> -	/*
> -	 * Always allow an entire first page
> -	 */
> -	if (max_size <=3D biovec->bv_len && !(bvm->bi_size >> SECTOR_SHIFT))
> -		max_size =3D biovec->bv_len;
> -
> -	return max_size;
> -}
> -
>  /*
>   * The request function that just remaps the bio built up by
>   * dm_merge_bvec.
> @@ -2477,59 +2422,6 @@ static void __set_size(struct mapped_device *md, s=
ector_t size)
>  }
> =20
>  /*
> - * Return 1 if the queue has a compulsory merge_bvec_fn function.
> - *
> - * If this function returns 0, then the device is either a non-dm
> - * device without a merge_bvec_fn, or it is a dm device that is
> - * able to split any bios it receives that are too big.
> - */
> -int dm_queue_merge_is_compulsory(struct request_queue *q)
> -{
> -	struct mapped_device *dev_md;
> -
> -	if (!q->merge_bvec_fn)
> -		return 0;
> -
> -	if (q->make_request_fn =3D=3D dm_make_request) {
> -		dev_md =3D q->queuedata;
> -		if (test_bit(DMF_MERGE_IS_OPTIONAL, &dev_md->flags))
> -			return 0;
> -	}
> -
> -	return 1;
> -}
> -
> -static int dm_device_merge_is_compulsory(struct dm_target *ti,
> -					 struct dm_dev *dev, sector_t start,
> -					 sector_t len, void *data)
> -{
> -	struct block_device *bdev =3D dev->bdev;
> -	struct request_queue *q =3D bdev_get_queue(bdev);
> -
> -	return dm_queue_merge_is_compulsory(q);
> -}
> -
> -/*
> - * Return 1 if it is acceptable to ignore merge_bvec_fn based
> - * on the properties of the underlying devices.
> - */
> -static int dm_table_merge_is_optional(struct dm_table *table)
> -{
> -	unsigned i =3D 0;
> -	struct dm_target *ti;
> -
> -	while (i < dm_table_get_num_targets(table)) {
> -		ti =3D dm_table_get_target(table, i++);
> -
> -		if (ti->type->iterate_devices &&
> -		    ti->type->iterate_devices(ti, dm_device_merge_is_compulsory, NULL))
> -			return 0;
> -	}
> -
> -	return 1;
> -}
> -
> -/*
>   * Returns old map, which caller must destroy.
>   */
>  static struct dm_table *__bind(struct mapped_device *md, struct dm_table=
 *t,
> @@ -2538,7 +2430,6 @@ static struct dm_table *__bind(struct mapped_device=
 *md, struct dm_table *t,
>  	struct dm_table *old_map;
>  	struct request_queue *q =3D md->queue;
>  	sector_t size;
> -	int merge_is_optional;
> =20
>  	size =3D dm_table_get_size(t);
> =20
> @@ -2564,17 +2455,11 @@ static struct dm_table *__bind(struct mapped_devi=
ce *md, struct dm_table *t,
> =20
>  	__bind_mempools(md, t);
> =20
> -	merge_is_optional =3D dm_table_merge_is_optional(t);
> -
>  	old_map =3D rcu_dereference_protected(md->map, lockdep_is_held(&md->sus=
pend_lock));
>  	rcu_assign_pointer(md->map, t);
>  	md->immutable_target_type =3D dm_table_get_immutable_target_type(t);
> =20
>  	dm_table_set_restrictions(t, q, limits);
> -	if (merge_is_optional)
> -		set_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
> -	else
> -		clear_bit(DMF_MERGE_IS_OPTIONAL, &md->flags);
>  	if (old_map)
>  		dm_sync_table(md);
> =20
> @@ -2852,7 +2737,6 @@ int dm_setup_md_queue(struct mapped_device *md)
>  	case DM_TYPE_BIO_BASED:
>  		dm_init_old_md_queue(md);
>  		blk_queue_make_request(md->queue, dm_make_request);
> -		blk_queue_merge_bvec(md->queue, dm_merge_bvec);
>  		break;
>  	}
> =20
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 6123c2b..7d61cca 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -77,8 +77,6 @@ bool dm_table_mq_request_based(struct dm_table *t);
>  void dm_table_free_md_mempools(struct dm_table *t);
>  struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
> =20
> -int dm_queue_merge_is_compulsory(struct request_queue *q);
> -
>  void dm_lock_md_type(struct mapped_device *md);
>  void dm_unlock_md_type(struct mapped_device *md);
>  void dm_set_md_type(struct mapped_device *md, unsigned type);
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index fa7d577..8721ef9 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -52,48 +52,6 @@ static inline struct dev_info *which_dev(struct mddev =
*mddev, sector_t sector)
>  	return conf->disks + lo;
>  }
> =20
> -/**
> - *	linear_mergeable_bvec -- tell bio layer if two requests can be merged
> - *	@q: request queue
> - *	@bvm: properties of new bio
> - *	@biovec: the request that could be merged to it.
> - *
> - *	Return amount of bytes we can take at this offset
> - */
> -static int linear_mergeable_bvec(struct mddev *mddev,
> -				 struct bvec_merge_data *bvm,
> -				 struct bio_vec *biovec)
> -{
> -	struct dev_info *dev0;
> -	unsigned long maxsectors, bio_sectors =3D bvm->bi_size >> 9;
> -	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);
> -	int maxbytes =3D biovec->bv_len;
> -	struct request_queue *subq;
> -
> -	dev0 =3D which_dev(mddev, sector);
> -	maxsectors =3D dev0->end_sector - sector;
> -	subq =3D bdev_get_queue(dev0->rdev->bdev);
> -	if (subq->merge_bvec_fn) {
> -		bvm->bi_bdev =3D dev0->rdev->bdev;
> -		bvm->bi_sector -=3D dev0->end_sector - dev0->rdev->sectors;
> -		maxbytes =3D min(maxbytes, subq->merge_bvec_fn(subq, bvm,
> -							     biovec));
> -	}
> -
> -	if (maxsectors < bio_sectors)
> -		maxsectors =3D 0;
> -	else
> -		maxsectors -=3D bio_sectors;
> -
> -	if (maxsectors <=3D (PAGE_SIZE >> 9 ) && bio_sectors =3D=3D 0)
> -		return maxbytes;
> -
> -	if (maxsectors > (maxbytes >> 9))
> -		return maxbytes;
> -	else
> -		return maxsectors << 9;
> -}
> -
>  static int linear_congested(struct mddev *mddev, int bits)
>  {
>  	struct linear_conf *conf;
> @@ -338,7 +296,6 @@ static struct md_personality linear_personality =3D
>  	.size		=3D linear_size,
>  	.quiesce	=3D linear_quiesce,
>  	.congested	=3D linear_congested,
> -	.mergeable_bvec	=3D linear_mergeable_bvec,
>  };
> =20
>  static int __init linear_init (void)
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 046b3c9..f101981 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -352,29 +352,6 @@ static int md_congested(void *data, int bits)
>  	return mddev_congested(mddev, bits);
>  }
> =20
> -static int md_mergeable_bvec(struct request_queue *q,
> -			     struct bvec_merge_data *bvm,
> -			     struct bio_vec *biovec)
> -{
> -	struct mddev *mddev =3D q->queuedata;
> -	int ret;
> -	rcu_read_lock();
> -	if (mddev->suspended) {
> -		/* Must always allow one vec */
> -		if (bvm->bi_size =3D=3D 0)
> -			ret =3D biovec->bv_len;
> -		else
> -			ret =3D 0;
> -	} else {
> -		struct md_personality *pers =3D mddev->pers;
> -		if (pers && pers->mergeable_bvec)
> -			ret =3D pers->mergeable_bvec(mddev, bvm, biovec);
> -		else
> -			ret =3D biovec->bv_len;
> -	}
> -	rcu_read_unlock();
> -	return ret;
> -}
>  /*
>   * Generic flush handling for md
>   */
> @@ -5165,7 +5142,6 @@ int md_run(struct mddev *mddev)
>  	if (mddev->queue) {
>  		mddev->queue->backing_dev_info.congested_data =3D mddev;
>  		mddev->queue->backing_dev_info.congested_fn =3D md_congested;
> -		blk_queue_merge_bvec(mddev->queue, md_mergeable_bvec);
>  	}
>  	if (pers->sync_request) {
>  		if (mddev->kobj.sd &&
> @@ -5293,7 +5269,6 @@ static void md_clean(struct mddev *mddev)
>  	mddev->changed =3D 0;
>  	mddev->degraded =3D 0;
>  	mddev->safemode =3D 0;
> -	mddev->merge_check_needed =3D 0;
>  	mddev->bitmap_info.offset =3D 0;
>  	mddev->bitmap_info.default_offset =3D 0;
>  	mddev->bitmap_info.default_space =3D 0;
> @@ -5489,7 +5464,6 @@ static int do_md_stop(struct mddev *mddev, int mode,
> =20
>  		__md_stop_writes(mddev);
>  		__md_stop(mddev);
> -		mddev->queue->merge_bvec_fn =3D NULL;
>  		mddev->queue->backing_dev_info.congested_fn =3D NULL;
> =20
>  		/* tell userspace to handle 'inactive' */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 4046a6c..cf7141a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -133,10 +133,6 @@ enum flag_bits {
>  	Bitmap_sync,		/* ..actually, not quite In_sync.  Need a
>  				 * bitmap-based recovery to get fully in sync
>  				 */
> -	Unmerged,		/* device is being added to array and should
> -				 * be considerred for bvec_merge_fn but not
> -				 * yet for actual IO
> -				 */
>  	WriteMostly,		/* Avoid reading if at all possible */
>  	AutoDetected,		/* added by auto-detect */
>  	Blocked,		/* An error occurred but has not yet
> @@ -373,10 +369,6 @@ struct mddev {
>  	int				degraded;	/* whether md should consider
>  							 * adding a spare
>  							 */
> -	int				merge_check_needed; /* at least one
> -							     * member device
> -							     * has a
> -							     * merge_bvec_fn */
> =20
>  	atomic_t			recovery_active; /* blocks scheduled, but not written */
>  	wait_queue_head_t		recovery_wait;
> @@ -531,10 +523,6 @@ struct md_personality
>  	/* congested implements bdi.congested_fn().
>  	 * Will not be called while array is 'suspended' */
>  	int (*congested)(struct mddev *mddev, int bits);
> -	/* mergeable_bvec is use to implement ->merge_bvec_fn */
> -	int (*mergeable_bvec)(struct mddev *mddev,
> -			      struct bvec_merge_data *bvm,
> -			      struct bio_vec *biovec);
>  };
> =20
>  struct md_sysfs_entry {
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index ac3ede2..7ee27fb 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -257,18 +257,6 @@ static int multipath_add_disk(struct mddev *mddev, s=
truct md_rdev *rdev)
>  			disk_stack_limits(mddev->gendisk, rdev->bdev,
>  					  rdev->data_offset << 9);
> =20
> -		/* as we don't honour merge_bvec_fn, we must never risk
> -		 * violating it, so limit ->max_segments to one, lying
> -		 * within a single page.
> -		 * (Note: it is very unlikely that a device with
> -		 * merge_bvec_fn will be involved in multipath.)
> -		 */
> -			if (q->merge_bvec_fn) {
> -				blk_queue_max_segments(mddev->queue, 1);
> -				blk_queue_segment_boundary(mddev->queue,
> -							   PAGE_CACHE_SIZE - 1);
> -			}
> -
>  			spin_lock_irq(&conf->device_lock);
>  			mddev->degraded--;
>  			rdev->raid_disk =3D path;
> @@ -432,15 +420,6 @@ static int multipath_run (struct mddev *mddev)
>  		disk_stack_limits(mddev->gendisk, rdev->bdev,
>  				  rdev->data_offset << 9);
> =20
> -		/* as we don't honour merge_bvec_fn, we must never risk
> -		 * violating it, not that we ever expect a device with
> -		 * a merge_bvec_fn to be involved in multipath */
> -		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
> -			blk_queue_max_segments(mddev->queue, 1);
> -			blk_queue_segment_boundary(mddev->queue,
> -						   PAGE_CACHE_SIZE - 1);
> -		}
> -
>  		if (!test_bit(Faulty, &rdev->flags))
>  			working_disks++;
>  	}
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 6a68ef5..1440bd4 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -192,9 +192,6 @@ static int create_strip_zones(struct mddev *mddev, st=
ruct r0conf **private_conf)
>  			disk_stack_limits(mddev->gendisk, rdev1->bdev,
>  					  rdev1->data_offset << 9);
> =20
> -		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn)
> -			conf->has_merge_bvec =3D 1;
> -
>  		if (!smallest || (rdev1->sectors < smallest->sectors))
>  			smallest =3D rdev1;
>  		cnt++;
> @@ -351,58 +348,6 @@ static struct md_rdev *map_sector(struct mddev *mdde=
v, struct strip_zone *zone,
>  			     + sector_div(sector, zone->nb_dev)];
>  }
> =20
> -/**
> - *	raid0_mergeable_bvec -- tell bio layer if two requests can be merged
> - *	@mddev: the md device
> - *	@bvm: properties of new bio
> - *	@biovec: the request that could be merged to it.
> - *
> - *	Return amount of bytes we can accept at this offset
> - */
> -static int raid0_mergeable_bvec(struct mddev *mddev,
> -				struct bvec_merge_data *bvm,
> -				struct bio_vec *biovec)
> -{
> -	struct r0conf *conf =3D mddev->private;
> -	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);
> -	sector_t sector_offset =3D sector;
> -	int max;
> -	unsigned int chunk_sectors =3D mddev->chunk_sectors;
> -	unsigned int bio_sectors =3D bvm->bi_size >> 9;
> -	struct strip_zone *zone;
> -	struct md_rdev *rdev;
> -	struct request_queue *subq;
> -
> -	if (is_power_of_2(chunk_sectors))
> -		max =3D  (chunk_sectors - ((sector & (chunk_sectors-1))
> -						+ bio_sectors)) << 9;
> -	else
> -		max =3D  (chunk_sectors - (sector_div(sector, chunk_sectors)
> -						+ bio_sectors)) << 9;
> -	if (max < 0)
> -		max =3D 0; /* bio_add cannot handle a negative return */
> -	if (max <=3D biovec->bv_len && bio_sectors =3D=3D 0)
> -		return biovec->bv_len;
> -	if (max < biovec->bv_len)
> -		/* too small already, no need to check further */
> -		return max;
> -	if (!conf->has_merge_bvec)
> -		return max;
> -
> -	/* May need to check subordinate device */
> -	sector =3D sector_offset;
> -	zone =3D find_zone(mddev->private, &sector_offset);
> -	rdev =3D map_sector(mddev, zone, sector, &sector_offset);
> -	subq =3D bdev_get_queue(rdev->bdev);
> -	if (subq->merge_bvec_fn) {
> -		bvm->bi_bdev =3D rdev->bdev;
> -		bvm->bi_sector =3D sector_offset + zone->dev_start +
> -			rdev->data_offset;
> -		return min(max, subq->merge_bvec_fn(subq, bvm, biovec));
> -	} else
> -		return max;
> -}
> -
>  static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int ra=
id_disks)
>  {
>  	sector_t array_sectors =3D 0;
> @@ -725,7 +670,6 @@ static struct md_personality raid0_personality=3D
>  	.takeover	=3D raid0_takeover,
>  	.quiesce	=3D raid0_quiesce,
>  	.congested	=3D raid0_congested,
> -	.mergeable_bvec	=3D raid0_mergeable_bvec,
>  };
> =20
>  static int __init raid0_init (void)
> diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
> index 05539d9..7127a62 100644
> --- a/drivers/md/raid0.h
> +++ b/drivers/md/raid0.h
> @@ -12,8 +12,6 @@ struct r0conf {
>  	struct md_rdev		**devlist; /* lists of rdevs, pointed to
>  					    * by strip_zone->dev */
>  	int			nr_strip_zones;
> -	int			has_merge_bvec;	/* at least one member has
> -						 * a merge_bvec_fn */
>  };
> =20
>  #endif
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9157a29..478878f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -557,7 +557,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>  		rdev =3D rcu_dereference(conf->mirrors[disk].rdev);
>  		if (r1_bio->bios[disk] =3D=3D IO_BLOCKED
>  		    || rdev =3D=3D NULL
> -		    || test_bit(Unmerged, &rdev->flags)
>  		    || test_bit(Faulty, &rdev->flags))
>  			continue;
>  		if (!test_bit(In_sync, &rdev->flags) &&
> @@ -708,38 +707,6 @@ static int read_balance(struct r1conf *conf, struct =
r1bio *r1_bio, int *max_sect
>  	return best_disk;
>  }
> =20
> -static int raid1_mergeable_bvec(struct mddev *mddev,
> -				struct bvec_merge_data *bvm,
> -				struct bio_vec *biovec)
> -{
> -	struct r1conf *conf =3D mddev->private;
> -	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);
> -	int max =3D biovec->bv_len;
> -
> -	if (mddev->merge_check_needed) {
> -		int disk;
> -		rcu_read_lock();
> -		for (disk =3D 0; disk < conf->raid_disks * 2; disk++) {
> -			struct md_rdev *rdev =3D rcu_dereference(
> -				conf->mirrors[disk].rdev);
> -			if (rdev && !test_bit(Faulty, &rdev->flags)) {
> -				struct request_queue *q =3D
> -					bdev_get_queue(rdev->bdev);
> -				if (q->merge_bvec_fn) {
> -					bvm->bi_sector =3D sector +
> -						rdev->data_offset;
> -					bvm->bi_bdev =3D rdev->bdev;
> -					max =3D min(max, q->merge_bvec_fn(
> -							  q, bvm, biovec));
> -				}
> -			}
> -		}
> -		rcu_read_unlock();
> -	}
> -	return max;
> -
> -}
> -
>  static int raid1_congested(struct mddev *mddev, int bits)
>  {
>  	struct r1conf *conf =3D mddev->private;
> @@ -1268,8 +1235,7 @@ read_again:
>  			break;
>  		}
>  		r1_bio->bios[i] =3D NULL;
> -		if (!rdev || test_bit(Faulty, &rdev->flags)
> -		    || test_bit(Unmerged, &rdev->flags)) {
> +		if (!rdev || test_bit(Faulty, &rdev->flags)) {
>  			if (i < conf->raid_disks)
>  				set_bit(R1BIO_Degraded, &r1_bio->state);
>  			continue;
> @@ -1614,7 +1580,6 @@ static int raid1_add_disk(struct mddev *mddev, stru=
ct md_rdev *rdev)
>  	struct raid1_info *p;
>  	int first =3D 0;
>  	int last =3D conf->raid_disks - 1;
> -	struct request_queue *q =3D bdev_get_queue(rdev->bdev);
> =20
>  	if (mddev->recovery_disabled =3D=3D conf->recovery_disabled)
>  		return -EBUSY;
> @@ -1622,11 +1587,6 @@ static int raid1_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	if (rdev->raid_disk >=3D 0)
>  		first =3D last =3D rdev->raid_disk;
> =20
> -	if (q->merge_bvec_fn) {
> -		set_bit(Unmerged, &rdev->flags);
> -		mddev->merge_check_needed =3D 1;
> -	}
> -
>  	for (mirror =3D first; mirror <=3D last; mirror++) {
>  		p =3D conf->mirrors+mirror;
>  		if (!p->rdev) {
> @@ -1658,19 +1618,6 @@ static int raid1_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  			break;
>  		}
>  	}
> -	if (err =3D=3D 0 && test_bit(Unmerged, &rdev->flags)) {
> -		/* Some requests might not have seen this new
> -		 * merge_bvec_fn.  We must wait for them to complete
> -		 * before merging the device fully.
> -		 * First we make sure any code which has tested
> -		 * our function has submitted the request, then
> -		 * we wait for all outstanding requests to complete.
> -		 */
> -		synchronize_sched();
> -		freeze_array(conf, 0);
> -		unfreeze_array(conf);
> -		clear_bit(Unmerged, &rdev->flags);
> -	}
>  	md_integrity_add_rdev(rdev, mddev);
>  	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> @@ -2807,8 +2754,6 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>  			goto abort;
>  		disk->rdev =3D rdev;
>  		q =3D bdev_get_queue(rdev->bdev);
> -		if (q->merge_bvec_fn)
> -			mddev->merge_check_needed =3D 1;
> =20
>  		disk->head_position =3D 0;
>  		disk->seq_start =3D MaxSector;
> @@ -3173,7 +3118,6 @@ static struct md_personality raid1_personality =3D
>  	.quiesce	=3D raid1_quiesce,
>  	.takeover	=3D raid1_takeover,
>  	.congested	=3D raid1_congested,
> -	.mergeable_bvec	=3D raid1_mergeable_bvec,
>  };
> =20
>  static int __init raid_init(void)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e793ab6..a46c402 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -672,93 +672,6 @@ static sector_t raid10_find_virt(struct r10conf *con=
f, sector_t sector, int dev)
>  	return (vchunk << geo->chunk_shift) + offset;
>  }
> =20
> -/**
> - *	raid10_mergeable_bvec -- tell bio layer if a two requests can be merg=
ed
> - *	@mddev: the md device
> - *	@bvm: properties of new bio
> - *	@biovec: the request that could be merged to it.
> - *
> - *	Return amount of bytes we can accept at this offset
> - *	This requires checking for end-of-chunk if near_copies !=3D raid_disk=
s,
> - *	and for subordinate merge_bvec_fns if merge_check_needed.
> - */
> -static int raid10_mergeable_bvec(struct mddev *mddev,
> -				 struct bvec_merge_data *bvm,
> -				 struct bio_vec *biovec)
> -{
> -	struct r10conf *conf =3D mddev->private;
> -	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);
> -	int max;
> -	unsigned int chunk_sectors;
> -	unsigned int bio_sectors =3D bvm->bi_size >> 9;
> -	struct geom *geo =3D &conf->geo;
> -
> -	chunk_sectors =3D (conf->geo.chunk_mask & conf->prev.chunk_mask) + 1;
> -	if (conf->reshape_progress !=3D MaxSector &&
> -	    ((sector >=3D conf->reshape_progress) !=3D
> -	     conf->mddev->reshape_backwards))
> -		geo =3D &conf->prev;
> -
> -	if (geo->near_copies < geo->raid_disks) {
> -		max =3D (chunk_sectors - ((sector & (chunk_sectors - 1))
> -					+ bio_sectors)) << 9;
> -		if (max < 0)
> -			/* bio_add cannot handle a negative return */
> -			max =3D 0;
> -		if (max <=3D biovec->bv_len && bio_sectors =3D=3D 0)
> -			return biovec->bv_len;
> -	} else
> -		max =3D biovec->bv_len;
> -
> -	if (mddev->merge_check_needed) {
> -		struct {
> -			struct r10bio r10_bio;
> -			struct r10dev devs[conf->copies];
> -		} on_stack;
> -		struct r10bio *r10_bio =3D &on_stack.r10_bio;
> -		int s;
> -		if (conf->reshape_progress !=3D MaxSector) {
> -			/* Cannot give any guidance during reshape */
> -			if (max <=3D biovec->bv_len && bio_sectors =3D=3D 0)
> -				return biovec->bv_len;
> -			return 0;
> -		}
> -		r10_bio->sector =3D sector;
> -		raid10_find_phys(conf, r10_bio);
> -		rcu_read_lock();
> -		for (s =3D 0; s < conf->copies; s++) {
> -			int disk =3D r10_bio->devs[s].devnum;
> -			struct md_rdev *rdev =3D rcu_dereference(
> -				conf->mirrors[disk].rdev);
> -			if (rdev && !test_bit(Faulty, &rdev->flags)) {
> -				struct request_queue *q =3D
> -					bdev_get_queue(rdev->bdev);
> -				if (q->merge_bvec_fn) {
> -					bvm->bi_sector =3D r10_bio->devs[s].addr
> -						+ rdev->data_offset;
> -					bvm->bi_bdev =3D rdev->bdev;
> -					max =3D min(max, q->merge_bvec_fn(
> -							  q, bvm, biovec));
> -				}
> -			}
> -			rdev =3D rcu_dereference(conf->mirrors[disk].replacement);
> -			if (rdev && !test_bit(Faulty, &rdev->flags)) {
> -				struct request_queue *q =3D
> -					bdev_get_queue(rdev->bdev);
> -				if (q->merge_bvec_fn) {
> -					bvm->bi_sector =3D r10_bio->devs[s].addr
> -						+ rdev->data_offset;
> -					bvm->bi_bdev =3D rdev->bdev;
> -					max =3D min(max, q->merge_bvec_fn(
> -							  q, bvm, biovec));
> -				}
> -			}
> -		}
> -		rcu_read_unlock();
> -	}
> -	return max;
> -}
> -
>  /*
>   * This routine returns the disk from which the requested read should
>   * be done. There is a per-array 'next expected sequential IO' sector
> @@ -821,12 +734,10 @@ retry:
>  		disk =3D r10_bio->devs[slot].devnum;
>  		rdev =3D rcu_dereference(conf->mirrors[disk].replacement);
>  		if (rdev =3D=3D NULL || test_bit(Faulty, &rdev->flags) ||
> -		    test_bit(Unmerged, &rdev->flags) ||
>  		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
>  			rdev =3D rcu_dereference(conf->mirrors[disk].rdev);
>  		if (rdev =3D=3D NULL ||
> -		    test_bit(Faulty, &rdev->flags) ||
> -		    test_bit(Unmerged, &rdev->flags))
> +		    test_bit(Faulty, &rdev->flags))
>  			continue;
>  		if (!test_bit(In_sync, &rdev->flags) &&
>  		    r10_bio->devs[slot].addr + sectors > rdev->recovery_offset)
> @@ -1326,11 +1237,9 @@ retry_write:
>  			blocked_rdev =3D rrdev;
>  			break;
>  		}
> -		if (rdev && (test_bit(Faulty, &rdev->flags)
> -			     || test_bit(Unmerged, &rdev->flags)))
> +		if (rdev && (test_bit(Faulty, &rdev->flags)))
>  			rdev =3D NULL;
> -		if (rrdev && (test_bit(Faulty, &rrdev->flags)
> -			      || test_bit(Unmerged, &rrdev->flags)))
> +		if (rrdev && (test_bit(Faulty, &rrdev->flags)))
>  			rrdev =3D NULL;
> =20
>  		r10_bio->devs[i].bio =3D NULL;
> @@ -1777,7 +1686,6 @@ static int raid10_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	int mirror;
>  	int first =3D 0;
>  	int last =3D conf->geo.raid_disks - 1;
> -	struct request_queue *q =3D bdev_get_queue(rdev->bdev);
> =20
>  	if (mddev->recovery_cp < MaxSector)
>  		/* only hot-add to in-sync arrays, as recovery is
> @@ -1790,11 +1698,6 @@ static int raid10_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  	if (rdev->raid_disk >=3D 0)
>  		first =3D last =3D rdev->raid_disk;
> =20
> -	if (q->merge_bvec_fn) {
> -		set_bit(Unmerged, &rdev->flags);
> -		mddev->merge_check_needed =3D 1;
> -	}
> -
>  	if (rdev->saved_raid_disk >=3D first &&
>  	    conf->mirrors[rdev->saved_raid_disk].rdev =3D=3D NULL)
>  		mirror =3D rdev->saved_raid_disk;
> @@ -1833,19 +1736,6 @@ static int raid10_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
>  		rcu_assign_pointer(p->rdev, rdev);
>  		break;
>  	}
> -	if (err =3D=3D 0 && test_bit(Unmerged, &rdev->flags)) {
> -		/* Some requests might not have seen this new
> -		 * merge_bvec_fn.  We must wait for them to complete
> -		 * before merging the device fully.
> -		 * First we make sure any code which has tested
> -		 * our function has submitted the request, then
> -		 * we wait for all outstanding requests to complete.
> -		 */
> -		synchronize_sched();
> -		freeze_array(conf, 0);
> -		unfreeze_array(conf);
> -		clear_bit(Unmerged, &rdev->flags);
> -	}
>  	md_integrity_add_rdev(rdev, mddev);
>  	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
> @@ -2404,7 +2294,6 @@ static void fix_read_error(struct r10conf *conf, st=
ruct mddev *mddev, struct r10
>  			d =3D r10_bio->devs[sl].devnum;
>  			rdev =3D rcu_dereference(conf->mirrors[d].rdev);
>  			if (rdev &&
> -			    !test_bit(Unmerged, &rdev->flags) &&
>  			    test_bit(In_sync, &rdev->flags) &&
>  			    is_badblock(rdev, r10_bio->devs[sl].addr + sect, s,
>  					&first_bad, &bad_sectors) =3D=3D 0) {
> @@ -2458,7 +2347,6 @@ static void fix_read_error(struct r10conf *conf, st=
ruct mddev *mddev, struct r10
>  			d =3D r10_bio->devs[sl].devnum;
>  			rdev =3D rcu_dereference(conf->mirrors[d].rdev);
>  			if (!rdev ||
> -			    test_bit(Unmerged, &rdev->flags) ||
>  			    !test_bit(In_sync, &rdev->flags))
>  				continue;
> =20
> @@ -3652,8 +3540,6 @@ static int run(struct mddev *mddev)
>  			disk->rdev =3D rdev;
>  		}
>  		q =3D bdev_get_queue(rdev->bdev);
> -		if (q->merge_bvec_fn)
> -			mddev->merge_check_needed =3D 1;
>  		diff =3D (rdev->new_data_offset - rdev->data_offset);
>  		if (!mddev->reshape_backwards)
>  			diff =3D -diff;
> @@ -4706,7 +4592,6 @@ static struct md_personality raid10_personality =3D
>  	.start_reshape	=3D raid10_start_reshape,
>  	.finish_reshape	=3D raid10_finish_reshape,
>  	.congested	=3D raid10_congested,
> -	.mergeable_bvec	=3D raid10_mergeable_bvec,
>  };
> =20
>  static int __init raid_init(void)
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b6c6ace..18d2b23 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4625,35 +4625,6 @@ static int raid5_congested(struct mddev *mddev, in=
t bits)
>  	return 0;
>  }
> =20
> -/* We want read requests to align with chunks where possible,
> - * but write requests don't need to.
> - */
> -static int raid5_mergeable_bvec(struct mddev *mddev,
> -				struct bvec_merge_data *bvm,
> -				struct bio_vec *biovec)
> -{
> -	sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);
> -	int max;
> -	unsigned int chunk_sectors =3D mddev->chunk_sectors;
> -	unsigned int bio_sectors =3D bvm->bi_size >> 9;
> -
> -	/*
> -	 * always allow writes to be mergeable, read as well if array
> -	 * is degraded as we'll go through stripe cache anyway.
> -	 */
> -	if ((bvm->bi_rw & 1) =3D=3D WRITE || mddev->degraded)
> -		return biovec->bv_len;
> -
> -	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
> -		chunk_sectors =3D mddev->new_chunk_sectors;
> -	max =3D  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors=
)) << 9;
> -	if (max < 0) max =3D 0;
> -	if (max <=3D biovec->bv_len && bio_sectors =3D=3D 0)
> -		return biovec->bv_len;
> -	else
> -		return max;
> -}
> -
>  static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
>  {
>  	sector_t sector =3D bio->bi_iter.bi_sector + get_start_sect(bio->bi_bde=
v);
> @@ -7722,7 +7693,6 @@ static struct md_personality raid6_personality =3D
>  	.quiesce	=3D raid5_quiesce,
>  	.takeover	=3D raid6_takeover,
>  	.congested	=3D raid5_congested,
> -	.mergeable_bvec	=3D raid5_mergeable_bvec,
>  };
>  static struct md_personality raid5_personality =3D
>  {
> @@ -7746,7 +7716,6 @@ static struct md_personality raid5_personality =3D
>  	.quiesce	=3D raid5_quiesce,
>  	.takeover	=3D raid5_takeover,
>  	.congested	=3D raid5_congested,
> -	.mergeable_bvec	=3D raid5_mergeable_bvec,
>  };
> =20
>  static struct md_personality raid4_personality =3D
> @@ -7771,7 +7740,6 @@ static struct md_personality raid4_personality =3D
>  	.quiesce	=3D raid5_quiesce,
>  	.takeover	=3D raid4_takeover,
>  	.congested	=3D raid5_congested,
> -	.mergeable_bvec	=3D raid5_mergeable_bvec,
>  };
> =20
>  static int __init raid5_init(void)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 93b81a2..6927b76 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -239,14 +239,6 @@ typedef int (prep_rq_fn) (struct request_queue *, st=
ruct request *);
>  typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
> =20
>  struct bio_vec;
> -struct bvec_merge_data {
> -	struct block_device *bi_bdev;
> -	sector_t bi_sector;
> -	unsigned bi_size;
> -	unsigned long bi_rw;
> -};
> -typedef int (merge_bvec_fn) (struct request_queue *, struct bvec_merge_d=
ata *,
> -			     struct bio_vec *);
>  typedef void (softirq_done_fn)(struct request *);
>  typedef int (dma_drain_needed_fn)(struct request *);
>  typedef int (lld_busy_fn) (struct request_queue *q);
> @@ -331,7 +323,6 @@ struct request_queue {
>  	make_request_fn		*make_request_fn;
>  	prep_rq_fn		*prep_rq_fn;
>  	unprep_rq_fn		*unprep_rq_fn;
> -	merge_bvec_fn		*merge_bvec_fn;
>  	softirq_done_fn		*softirq_done_fn;
>  	rq_timed_out_fn		*rq_timed_out_fn;
>  	dma_drain_needed_fn	*dma_drain_needed;
> @@ -1041,7 +1032,6 @@ extern void blk_queue_lld_busy(struct request_queue=
 *q, lld_busy_fn *fn);
>  extern void blk_queue_segment_boundary(struct request_queue *, unsigned =
long);
>  extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
>  extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *uf=
n);
> -extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *=
);
>  extern void blk_queue_dma_alignment(struct request_queue *, int);
>  extern void blk_queue_update_dma_alignment(struct request_queue *, int);
>  extern void blk_queue_softirq_done(struct request_queue *, softirq_done_=
fn *);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 51cc1de..76d23fa 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -82,9 +82,6 @@ typedef int (*dm_message_fn) (struct dm_target *ti, uns=
igned argc, char **argv);
>  typedef int (*dm_ioctl_fn) (struct dm_target *ti, unsigned int cmd,
>  			    unsigned long arg);
> =20
> -typedef int (*dm_merge_fn) (struct dm_target *ti, struct bvec_merge_data=
 *bvm,
> -			    struct bio_vec *biovec, int max_size);
> -
>  /*
>   * These iteration functions are typically used to check (and combine)
>   * properties of underlying devices.
> @@ -160,7 +157,6 @@ struct target_type {
>  	dm_status_fn status;
>  	dm_message_fn message;
>  	dm_ioctl_fn ioctl;
> -	dm_merge_fn merge;
>  	dm_busy_fn busy;
>  	dm_iterate_devices_fn iterate_devices;
>  	dm_io_hints_fn io_hints;


--Sig_/rX5O2L7Boki6JJuYf/HxdXj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWK34znsnt1WYoG5AQKYsA/+LxngQOAEN7DlCRifVHz5KeOqkbIp6J6S
MQt2atTQcZdR7veDruOEDX2rXDfUmeN9b9R2wyDPnSetS8dCh9HxSprH4DtrJ0Ks
BSVCs92X9rWtL0D+DeDZWA7d1syfp5FkJ5Zn8K25FkJQWmQRKODEzwQWc0xKzKY6
ZRwChCY9iuYC0vpMhmGt78lBxW/GkA7P8M2iEuI7+Ig7s4cc/0y1udZNyE8HCruw
NwuDwhnTtj+aR/b4SkYCsq9rSDE3FxYD9r8WYUy0bUv8XWc3kFeJKkNRRw1d/kf5
lMjaFKtip7ho/Y6A2BkYJXnkno8Gwq1ksuTwH9421IrvFdFCgVneurQleErELVO2
Se+CAJr4la47y4NLB+YNCcRvttN37EP1ysszupcgLWgfHbQnPqRCkV3h4cZY7/vH
facJqnvuBe21qZ9gB+0hwdeGic8EJExfMmpnczpsQv3bzxt7RCJ9jT7ee1jBSpxV
7jnGxW4ui4/fuRkixJQgbPQHYArwRQl5pkeFdNUXCL3dAHjlioYlbMY115A0kyO8
PwAxJS+ru/8fPxRIhfiPFpvth5IZ42+YG8Rn4O4c8ej/4UhFl3T+62P2QYZMCJQp
BOheIbnb0GAgBSm/Bt9fHAifkrkEtYOtJ/HWKysjIoyMn2L6TlymfFS4X4qh+Gzm
i3hw+pC6C4A=
=cu9L
-----END PGP SIGNATURE-----

--Sig_/rX5O2L7Boki6JJuYf/HxdXj--
