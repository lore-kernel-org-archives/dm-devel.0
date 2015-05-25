From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Mon, 25 May 2015 15:46:24 +1000
Message-ID: <20150525154624.40e6322e@notabene.brown>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.wOHtu9IYPiOBUbvwNroTvN"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432318723-18829-2-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

--Sig_/.wOHtu9IYPiOBUbvwNroTvN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2015 11:18:33 -0700 Ming Lin <mlin@kernel.org> wrote:

> From: Kent Overstreet <kent.overstreet@gmail.com>
>=20
> The way the block layer is currently written, it goes to great lengths
> to avoid having to split bios; upper layer code (such as bio_add_page())
> checks what the underlying device can handle and tries to always create
> bios that don't need to be split.
>=20
> But this approach becomes unwieldy and eventually breaks down with
> stacked devices and devices with dynamic limits, and it adds a lot of
> complexity. If the block layer could split bios as needed, we could
> eliminate a lot of complexity elsewhere - particularly in stacked
> drivers. Code that creates bios can then create whatever size bios are
> convenient, and more importantly stacked drivers don't have to deal with
> both their own bio size limitations and the limitations of the
> (potentially multiple) devices underneath them.  In the future this will
> let us delete merge_bvec_fn and a bunch of other code.
>=20
> We do this by adding calls to blk_queue_split() to the various
> make_request functions that need it - a few can already handle arbitrary
> size bios. Note that we add the call _after_ any call to
> blk_queue_bounce(); this means that blk_queue_split() and
> blk_recalc_rq_segments() don't need to be concerned with bouncing
> affecting segment merging.
>=20
> Some make_request_fn() callbacks were simple enough to audit and verify
> they don't need blk_queue_split() calls. The skipped ones are:
>=20
>  * nfhd_make_request (arch/m68k/emu/nfblock.c)
>  * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
>  * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
>  * brd_make_request (ramdisk - drivers/block/brd.c)
>  * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
>  * loop_make_request
>  * null_queue_bio
>  * bcache's make_request fns
>=20
> Some others are almost certainly safe to remove now, but will be left
> for future patches.
>=20
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
> Cc: drbd-user@lists.linbit.com
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Jim Paris <jim@jtan.com>
> Cc: Joshua Morris <josh.h.morris@us.ibm.com>
> Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Oleg Drokin <oleg.drokin@intel.com>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> [dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
> Signed-off-by: Dongsu Park <dpark@posteo.net>
> Signed-off-by: Ming Lin <mlin@kernel.org>


Acked-by: NeilBrown <neilb@suse.de>

For the 'md/md.c' bits.

Thanks,
NeilBrown


> ---
>  block/blk-core.c                            |  19 ++--
>  block/blk-merge.c                           | 159 ++++++++++++++++++++++=
++++--
>  block/blk-mq.c                              |   4 +
>  drivers/block/drbd/drbd_req.c               |   2 +
>  drivers/block/pktcdvd.c                     |   6 +-
>  drivers/block/ps3vram.c                     |   2 +
>  drivers/block/rsxx/dev.c                    |   2 +
>  drivers/block/umem.c                        |   2 +
>  drivers/block/zram/zram_drv.c               |   2 +
>  drivers/md/dm.c                             |   2 +
>  drivers/md/md.c                             |   2 +
>  drivers/s390/block/dcssblk.c                |   2 +
>  drivers/s390/block/xpram.c                  |   2 +
>  drivers/staging/lustre/lustre/llite/lloop.c |   2 +
>  include/linux/blkdev.h                      |   3 +
>  15 files changed, 189 insertions(+), 22 deletions(-)
>=20
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7871603..fbbb337 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -619,6 +619,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp=
_mask, int node_id)
>  	if (q->id < 0)
>  		goto fail_q;
> =20
> +	q->bio_split =3D bioset_create(BIO_POOL_SIZE, 0);
> +	if (!q->bio_split)
> +		goto fail_id;
> +
>  	q->backing_dev_info.ra_pages =3D
>  			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
>  	q->backing_dev_info.state =3D 0;
> @@ -628,7 +632,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_=
mask, int node_id)
> =20
>  	err =3D bdi_init(&q->backing_dev_info);
>  	if (err)
> -		goto fail_id;
> +		goto fail_split;
> =20
>  	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
>  		    laptop_mode_timer_fn, (unsigned long) q);
> @@ -670,6 +674,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_=
mask, int node_id)
> =20
>  fail_bdi:
>  	bdi_destroy(&q->backing_dev_info);
> +fail_split:
> +	bioset_free(q->bio_split);
>  fail_id:
>  	ida_simple_remove(&blk_queue_ida, q->id);
>  fail_q:
> @@ -1586,6 +1592,8 @@ void blk_queue_bio(struct request_queue *q, struct =
bio *bio)
>  	struct request *req;
>  	unsigned int request_count =3D 0;
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	/*
>  	 * low level driver can indicate that it wants pages above a
>  	 * certain limit bounced to low memory (ie for highmem, or even
> @@ -1809,15 +1817,6 @@ generic_make_request_checks(struct bio *bio)
>  		goto end_io;
>  	}
> =20
> -	if (likely(bio_is_rw(bio) &&
> -		   nr_sectors > queue_max_hw_sectors(q))) {
> -		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
> -		       bdevname(bio->bi_bdev, b),
> -		       bio_sectors(bio),
> -		       queue_max_hw_sectors(q));
> -		goto end_io;
> -	}
> -
>  	part =3D bio->bi_bdev->bd_part;
>  	if (should_fail_request(part, bio->bi_iter.bi_size) ||
>  	    should_fail_request(&part_to_disk(part)->part0,
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index fd3fee8..dc14255 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -9,12 +9,158 @@
> =20
>  #include "blk.h"
> =20
> +static struct bio *blk_bio_discard_split(struct request_queue *q,
> +					 struct bio *bio,
> +					 struct bio_set *bs)
> +{
> +	unsigned int max_discard_sectors, granularity;
> +	int alignment;
> +	sector_t tmp;
> +	unsigned split_sectors;
> +
> +	/* Zero-sector (unknown) and one-sector granularities are the same.  */
> +	granularity =3D max(q->limits.discard_granularity >> 9, 1U);
> +
> +	max_discard_sectors =3D min(q->limits.max_discard_sectors, UINT_MAX >> =
9);
> +	max_discard_sectors -=3D max_discard_sectors % granularity;
> +
> +	if (unlikely(!max_discard_sectors)) {
> +		/* XXX: warn */
> +		return NULL;
> +	}
> +
> +	if (bio_sectors(bio) <=3D max_discard_sectors)
> +		return NULL;
> +
> +	split_sectors =3D max_discard_sectors;
> +
> +	/*
> +	 * If the next starting sector would be misaligned, stop the discard at
> +	 * the previous aligned sector.
> +	 */
> +	alignment =3D (q->limits.discard_alignment >> 9) % granularity;
> +
> +	tmp =3D bio->bi_iter.bi_sector + split_sectors - alignment;
> +	tmp =3D sector_div(tmp, granularity);
> +
> +	if (split_sectors > tmp)
> +		split_sectors -=3D tmp;
> +
> +	return bio_split(bio, split_sectors, GFP_NOIO, bs);
> +}
> +
> +static struct bio *blk_bio_write_same_split(struct request_queue *q,
> +					    struct bio *bio,
> +					    struct bio_set *bs)
> +{
> +	if (!q->limits.max_write_same_sectors)
> +		return NULL;
> +
> +	if (bio_sectors(bio) <=3D q->limits.max_write_same_sectors)
> +		return NULL;
> +
> +	return bio_split(bio, q->limits.max_write_same_sectors, GFP_NOIO, bs);
> +}
> +
> +static struct bio *blk_bio_segment_split(struct request_queue *q,
> +					 struct bio *bio,
> +					 struct bio_set *bs)
> +{
> +	struct bio *split;
> +	struct bio_vec bv, bvprv;
> +	struct bvec_iter iter;
> +	unsigned seg_size =3D 0, nsegs =3D 0;
> +	int prev =3D 0;
> +
> +	struct bvec_merge_data bvm =3D {
> +		.bi_bdev	=3D bio->bi_bdev,
> +		.bi_sector	=3D bio->bi_iter.bi_sector,
> +		.bi_size	=3D 0,
> +		.bi_rw		=3D bio->bi_rw,
> +	};
> +
> +	bio_for_each_segment(bv, bio, iter) {
> +		if (q->merge_bvec_fn &&
> +		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
> +			goto split;
> +
> +		bvm.bi_size +=3D bv.bv_len;
> +
> +		if (bvm.bi_size >> 9 > queue_max_sectors(q))
> +			goto split;
> +
> +		/*
> +		 * If the queue doesn't support SG gaps and adding this
> +		 * offset would create a gap, disallow it.
> +		 */
> +		if (q->queue_flags & (1 << QUEUE_FLAG_SG_GAPS) &&
> +		    prev && bvec_gap_to_prev(&bvprv, bv.bv_offset))
> +			goto split;
> +
> +		if (prev && blk_queue_cluster(q)) {
> +			if (seg_size + bv.bv_len > queue_max_segment_size(q))
> +				goto new_segment;
> +			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
> +				goto new_segment;
> +			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
> +				goto new_segment;
> +
> +			seg_size +=3D bv.bv_len;
> +			bvprv =3D bv;
> +			prev =3D 1;
> +			continue;
> +		}
> +new_segment:
> +		if (nsegs =3D=3D queue_max_segments(q))
> +			goto split;
> +
> +		nsegs++;
> +		bvprv =3D bv;
> +		prev =3D 1;
> +		seg_size =3D bv.bv_len;
> +	}
> +
> +	return NULL;
> +split:
> +	split =3D bio_clone_bioset(bio, GFP_NOIO, bs);
> +
> +	split->bi_iter.bi_size -=3D iter.bi_size;
> +	bio->bi_iter =3D iter;
> +
> +	if (bio_integrity(bio)) {
> +		bio_integrity_advance(bio, split->bi_iter.bi_size);
> +		bio_integrity_trim(split, 0, bio_sectors(split));
> +	}
> +
> +	return split;
> +}
> +
> +void blk_queue_split(struct request_queue *q, struct bio **bio,
> +		     struct bio_set *bs)
> +{
> +	struct bio *split;
> +
> +	if ((*bio)->bi_rw & REQ_DISCARD)
> +		split =3D blk_bio_discard_split(q, *bio, bs);
> +	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
> +		split =3D blk_bio_write_same_split(q, *bio, bs);
> +	else
> +		split =3D blk_bio_segment_split(q, *bio, q->bio_split);
> +
> +	if (split) {
> +		bio_chain(split, *bio);
> +		generic_make_request(*bio);
> +		*bio =3D split;
> +	}
> +}
> +EXPORT_SYMBOL(blk_queue_split);
> +
>  static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  					     struct bio *bio,
>  					     bool no_sg_merge)
>  {
>  	struct bio_vec bv, bvprv =3D { NULL };
> -	int cluster, high, highprv =3D 1;
> +	int cluster, prev =3D 0;
>  	unsigned int seg_size, nr_phys_segs;
>  	struct bio *fbio, *bbio;
>  	struct bvec_iter iter;
> @@ -36,7 +182,6 @@ static unsigned int __blk_recalc_rq_segments(struct re=
quest_queue *q,
>  	cluster =3D blk_queue_cluster(q);
>  	seg_size =3D 0;
>  	nr_phys_segs =3D 0;
> -	high =3D 0;
>  	for_each_bio(bio) {
>  		bio_for_each_segment(bv, bio, iter) {
>  			/*
> @@ -46,13 +191,7 @@ static unsigned int __blk_recalc_rq_segments(struct r=
equest_queue *q,
>  			if (no_sg_merge)
>  				goto new_segment;
> =20
> -			/*
> -			 * the trick here is making sure that a high page is
> -			 * never considered part of another segment, since
> -			 * that might change with the bounce page.
> -			 */
> -			high =3D page_to_pfn(bv.bv_page) > queue_bounce_pfn(q);
> -			if (!high && !highprv && cluster) {
> +			if (prev && cluster) {
>  				if (seg_size + bv.bv_len
>  				    > queue_max_segment_size(q))
>  					goto new_segment;
> @@ -72,8 +211,8 @@ new_segment:
> =20
>  			nr_phys_segs++;
>  			bvprv =3D bv;
> +			prev =3D 1;
>  			seg_size =3D bv.bv_len;
> -			highprv =3D high;
>  		}
>  		bbio =3D bio;
>  	}
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index e68b71b..e7fae76 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1256,6 +1256,8 @@ static void blk_mq_make_request(struct request_queu=
e *q, struct bio *bio)
>  		return;
>  	}
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	rq =3D blk_mq_map_request(q, bio, &data);
>  	if (unlikely(!rq))
>  		return;
> @@ -1339,6 +1341,8 @@ static void blk_sq_make_request(struct request_queu=
e *q, struct bio *bio)
>  		return;
>  	}
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if (use_plug && !blk_queue_nomerges(q) &&
>  	    blk_attempt_plug_merge(q, bio, &request_count))
>  		return;
> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index 3907202..a6265bc 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -1497,6 +1497,8 @@ void drbd_make_request(struct request_queue *q, str=
uct bio *bio)
>  	struct drbd_device *device =3D (struct drbd_device *) q->queuedata;
>  	unsigned long start_jif;
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	start_jif =3D jiffies;
> =20
>  	/*
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 09e628da..ea10bd9 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2446,6 +2446,10 @@ static void pkt_make_request(struct request_queue =
*q, struct bio *bio)
>  	char b[BDEVNAME_SIZE];
>  	struct bio *split;
> =20
> +	blk_queue_bounce(q, &bio);
> +
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	pd =3D q->queuedata;
>  	if (!pd) {
>  		pr_err("%s incorrect request queue\n",
> @@ -2476,8 +2480,6 @@ static void pkt_make_request(struct request_queue *=
q, struct bio *bio)
>  		goto end_io;
>  	}
> =20
> -	blk_queue_bounce(q, &bio);
> -
>  	do {
>  		sector_t zone =3D get_zone(bio->bi_iter.bi_sector, pd);
>  		sector_t last_zone =3D get_zone(bio_end_sector(bio) - 1, pd);
> diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> index ef45cfb..e32e799 100644
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -605,6 +605,8 @@ static void ps3vram_make_request(struct request_queue=
 *q, struct bio *bio)
> =20
>  	dev_dbg(&dev->core, "%s\n", __func__);
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	spin_lock_irq(&priv->lock);
>  	busy =3D !bio_list_empty(&priv->list);
>  	bio_list_add(&priv->list, bio);
> diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
> index ac8c62c..50ef199 100644
> --- a/drivers/block/rsxx/dev.c
> +++ b/drivers/block/rsxx/dev.c
> @@ -148,6 +148,8 @@ static void rsxx_make_request(struct request_queue *q=
, struct bio *bio)
>  	struct rsxx_bio_meta *bio_meta;
>  	int st =3D -EINVAL;
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	might_sleep();
> =20
>  	if (!card)
> diff --git a/drivers/block/umem.c b/drivers/block/umem.c
> index 4cf81b5..13d577c 100644
> --- a/drivers/block/umem.c
> +++ b/drivers/block/umem.c
> @@ -531,6 +531,8 @@ static void mm_make_request(struct request_queue *q, =
struct bio *bio)
>  		 (unsigned long long)bio->bi_iter.bi_sector,
>  		 bio->bi_iter.bi_size);
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	spin_lock_irq(&card->lock);
>  	*card->biotail =3D bio;
>  	bio->bi_next =3D NULL;
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 8dcbced..36a004e 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -981,6 +981,8 @@ static void zram_make_request(struct request_queue *q=
ueue, struct bio *bio)
>  	if (unlikely(!zram_meta_get(zram)))
>  		goto error;
> =20
> +	blk_queue_split(queue, &bio, queue->bio_split);
> +
>  	if (!valid_io_request(zram, bio->bi_iter.bi_sector,
>  					bio->bi_iter.bi_size)) {
>  		atomic64_inc(&zram->stats.invalid_io);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index a930b72..34f6063 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1784,6 +1784,8 @@ static void dm_make_request(struct request_queue *q=
, struct bio *bio)
> =20
>  	map =3D dm_get_live_table(md, &srcu_idx);
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	generic_start_io_acct(rw, bio_sectors(bio), &dm_disk(md)->part0);
> =20
>  	/* if we're suspended, we have to queue this io for later */
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 593a024..046b3c9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -257,6 +257,8 @@ static void md_make_request(struct request_queue *q, =
struct bio *bio)
>  	unsigned int sectors;
>  	int cpu;
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL
>  	    || !mddev->ready) {
>  		bio_io_error(bio);
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index da21281..267ca3a 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -826,6 +826,8 @@ dcssblk_make_request(struct request_queue *q, struct =
bio *bio)
>  	unsigned long source_addr;
>  	unsigned long bytes_done;
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	bytes_done =3D 0;
>  	dev_info =3D bio->bi_bdev->bd_disk->private_data;
>  	if (dev_info =3D=3D NULL)
> diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
> index 7d4e939..1305ed3 100644
> --- a/drivers/s390/block/xpram.c
> +++ b/drivers/s390/block/xpram.c
> @@ -190,6 +190,8 @@ static void xpram_make_request(struct request_queue *=
q, struct bio *bio)
>  	unsigned long page_addr;
>  	unsigned long bytes;
> =20
> +	blk_queue_split(q, &bio, q->bio_split);
> +
>  	if ((bio->bi_iter.bi_sector & 7) !=3D 0 ||
>  	    (bio->bi_iter.bi_size & 4095) !=3D 0)
>  		/* Request is not page-aligned. */
> diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/stagin=
g/lustre/lustre/llite/lloop.c
> index 413a840..a8645a9 100644
> --- a/drivers/staging/lustre/lustre/llite/lloop.c
> +++ b/drivers/staging/lustre/lustre/llite/lloop.c
> @@ -340,6 +340,8 @@ static void loop_make_request(struct request_queue *q=
, struct bio *old_bio)
>  	int rw =3D bio_rw(old_bio);
>  	int inactive;
> =20
> +	blk_queue_split(q, &old_bio, q->bio_split);
> +
>  	if (!lo)
>  		goto err;
> =20
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 7f9a516..93b81a2 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -488,6 +488,7 @@ struct request_queue {
> =20
>  	struct blk_mq_tag_set	*tag_set;
>  	struct list_head	tag_set_list;
> +	struct bio_set		*bio_split;
>  };
> =20
>  #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
> @@ -812,6 +813,8 @@ extern void blk_rq_unprep_clone(struct request *rq);
>  extern int blk_insert_cloned_request(struct request_queue *q,
>  				     struct request *rq);
>  extern void blk_delay_queue(struct request_queue *, unsigned long);
> +extern void blk_queue_split(struct request_queue *, struct bio **,
> +			    struct bio_set *);
>  extern void blk_recount_segments(struct request_queue *, struct bio *);
>  extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
>  extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,


--Sig_/.wOHtu9IYPiOBUbvwNroTvN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWK3MDnsnt1WYoG5AQKS5Q/+JaXoAkuokzgPpo6+yI5T+pYw5rExtOzo
XpenwDTxvAzrrGCTV8roXL+px8JSqy0kxweull0iTH6Y8HbexVLoFYDW+u6/CguO
k8Tc883G47nRb1emNbUaDW/eKR0vtDQbJyYkmpL/quuIoaqlFFE6QdaAHznAtrPo
hnPp0gIjUk/Oj0OOKs687swJD4u1LciVt/xT9NuEA4d0Qdeqe97cLk/WHYu6sHf8
l8e9WiIvDfAVJnqoF3aU2g2ms3esePz3238+IRGKEYfNtVIxX+1CrRiIeCiso6bD
KMCxfA7VLD9lIG0IYW9lQdeyokTIkIuGK8hpeCa3I+6XNXrHrbJHDRKfwpeTeAJv
qS6kkvinDcQjyJgmEPdhnKbtRYvsIbhdkQP+NNoXU6jeFYr/iw4EwuWbAFLLQsYC
UiY6HFumEnxkTRYd/hceYKjY9q6zJ4gCaerfCLcm7YLMn4Fmfu33x7JB3o3V1Qyg
EHgWuqbwpeWL6jaJ3JzCCflItD1NylV/t+xBV9+l2c7TpalGS3XcppTX/X/ANqnv
4IjN19Jd3/QGrR2/2N6erqBRChfza1hrzEEiorcPn18RaH2W4AM7SzhDZtp4ExTX
w/piW7f+hg89RJC3K+dAvYL/ADYg6Nv3lAsAod//YcTKU3Qoor/4siawIFeGLVUC
CGJxM6cf1Bo=
=qHA2
-----END PGP SIGNATURE-----

--Sig_/.wOHtu9IYPiOBUbvwNroTvN--
