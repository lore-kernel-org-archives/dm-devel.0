From: Pavel Machek <pavel@ucw.cz>
Subject: Re: v4.9, 4.4-final: 28 bioset threads on small notebook, 36 threads
 on cellphone
Date: Tue, 7 Feb 2017 21:39:11 +0100
Message-ID: <20170207203911.GA16980@amd>
References: <20151211104937.GA23165@amd>
 <20151211140841.GA22873@redhat.com>
 <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
 <20170206125309.GA29395@amd>
 <20170207014724.74tb37jj7u66lww3@moria.home.lan>
 <20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170207024906.4oswyuvxfnqkvbhr@moria.home.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, axboe@fb.com, hch@lst.de, neilb@suse.de, martin.petersen@oracle.com, dpark@posteo.net, ming.l@ssi.samsung.com, dm-devel@redhat.com, ming.lei@canonical.com, agk@redhat.com, jkosina@suse.cz, geoff@infradead.org, jim@jtan.com, pjk1939@linux.vnet.ibm.com, minchan@kernel.org, ngupta@vflare.org, oleg.drokin@intel.com, andreas.dilger@intel.com
List-Id: dm-devel.ids


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-02-06 17:49:06, Kent Overstreet wrote:
> On Mon, Feb 06, 2017 at 04:47:24PM -0900, Kent Overstreet wrote:
> > On Mon, Feb 06, 2017 at 01:53:09PM +0100, Pavel Machek wrote:
> > > Still there on v4.9, 36 threads on nokia n900 cellphone.
> > >=20
> > > So.. what needs to be done there?
>=20
> > But, I just got an idea for how to handle this that might be halfway sa=
ne, maybe
> > I'll try and come up with a patch...
>=20
> Ok, here's such a patch, only lightly tested:

I guess it would be nice for me to test it... but what it is against?
I tried after v4.10-rc5 and linux-next, but got rejects in both cases.

Thanks,
								Pavel

> -- >8 --
> Subject: [PATCH] block: Make rescuer threads per request_queue, not per b=
ioset
>=20
> Note: this patch is very lightly tested.
>=20
> Also, trigger rescuing whenever with bios on current->bio_list, instead
> of only when we block in bio_alloc_bioset(). This is more correct, and
> should result in fewer rescuer threads.
>=20
> XXX: The current->bio_list plugging needs to be unified with the
> blk_plug mechanism.
>=20
> TODO: If we change normal request_queue drivers to handle arbitrary size
> bios by processing requests incrementally, instead of splitting bios,
> then we can get rid of rescuer threads from those devices.
> ---
>  block/bio.c            | 107 ++++---------------------------------------=
------
>  block/blk-core.c       |  58 ++++++++++++++++++++++++---
>  block/blk-sysfs.c      |   2 +
>  include/linux/bio.h    |  16 ++++----
>  include/linux/blkdev.h |  10 +++++
>  include/linux/sched.h  |   2 +-
>  kernel/sched/core.c    |   4 ++
>  7 files changed, 83 insertions(+), 116 deletions(-)
>=20
> diff --git a/block/bio.c b/block/bio.c
> index f3b5786202..9ad54a9b12 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -336,54 +336,6 @@ void bio_chain(struct bio *bio, struct bio *parent)
>  }
>  EXPORT_SYMBOL(bio_chain);
> =20
> -static void bio_alloc_rescue(struct work_struct *work)
> -{
> -	struct bio_set *bs =3D container_of(work, struct bio_set, rescue_work);
> -	struct bio *bio;
> -
> -	while (1) {
> -		spin_lock(&bs->rescue_lock);
> -		bio =3D bio_list_pop(&bs->rescue_list);
> -		spin_unlock(&bs->rescue_lock);
> -
> -		if (!bio)
> -			break;
> -
> -		generic_make_request(bio);
> -	}
> -}
> -
> -static void punt_bios_to_rescuer(struct bio_set *bs)
> -{
> -	struct bio_list punt, nopunt;
> -	struct bio *bio;
> -
> -	/*
> -	 * In order to guarantee forward progress we must punt only bios that
> -	 * were allocated from this bio_set; otherwise, if there was a bio on
> -	 * there for a stacking driver higher up in the stack, processing it
> -	 * could require allocating bios from this bio_set, and doing that from
> -	 * our own rescuer would be bad.
> -	 *
> -	 * Since bio lists are singly linked, pop them all instead of trying to
> -	 * remove from the middle of the list:
> -	 */
> -
> -	bio_list_init(&punt);
> -	bio_list_init(&nopunt);
> -
> -	while ((bio =3D bio_list_pop(current->bio_list)))
> -		bio_list_add(bio->bi_pool =3D=3D bs ? &punt : &nopunt, bio);
> -
> -	*current->bio_list =3D nopunt;
> -
> -	spin_lock(&bs->rescue_lock);
> -	bio_list_merge(&bs->rescue_list, &punt);
> -	spin_unlock(&bs->rescue_lock);
> -
> -	queue_work(bs->rescue_workqueue, &bs->rescue_work);
> -}
> -
>  /**
>   * bio_alloc_bioset - allocate a bio for I/O
>   * @gfp_mask:   the GFP_ mask given to the slab allocator
> @@ -421,54 +373,27 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
>   */
>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_s=
et *bs)
>  {
> -	gfp_t saved_gfp =3D gfp_mask;
>  	unsigned front_pad;
>  	unsigned inline_vecs;
>  	struct bio_vec *bvl =3D NULL;
>  	struct bio *bio;
>  	void *p;
> =20
> -	if (!bs) {
> -		if (nr_iovecs > UIO_MAXIOV)
> -			return NULL;
> +	WARN(current->bio_list &&
> +	     !current->bio_list->q->rescue_workqueue,
> +	     "allocating bio beneath generic_make_request() without rescuer");
> =20
> +	if (nr_iovecs > UIO_MAXIOV)
> +		return NULL;
> +
> +	if (!bs) {
>  		p =3D kmalloc(sizeof(struct bio) +
>  			    nr_iovecs * sizeof(struct bio_vec),
>  			    gfp_mask);
>  		front_pad =3D 0;
>  		inline_vecs =3D nr_iovecs;
>  	} else {
> -		/*
> -		 * generic_make_request() converts recursion to iteration; this
> -		 * means if we're running beneath it, any bios we allocate and
> -		 * submit will not be submitted (and thus freed) until after we
> -		 * return.
> -		 *
> -		 * This exposes us to a potential deadlock if we allocate
> -		 * multiple bios from the same bio_set() while running
> -		 * underneath generic_make_request(). If we were to allocate
> -		 * multiple bios (say a stacking block driver that was splitting
> -		 * bios), we would deadlock if we exhausted the mempool's
> -		 * reserve.
> -		 *
> -		 * We solve this, and guarantee forward progress, with a rescuer
> -		 * workqueue per bio_set. If we go to allocate and there are
> -		 * bios on current->bio_list, we first try the allocation
> -		 * without __GFP_DIRECT_RECLAIM; if that fails, we punt those
> -		 * bios we would be blocking to the rescuer workqueue before
> -		 * we retry with the original gfp_flags.
> -		 */
> -
> -		if (current->bio_list && !bio_list_empty(current->bio_list))
> -			gfp_mask &=3D ~__GFP_DIRECT_RECLAIM;
> -
>  		p =3D mempool_alloc(&bs->bio_pool, gfp_mask);
> -		if (!p && gfp_mask !=3D saved_gfp) {
> -			punt_bios_to_rescuer(bs);
> -			gfp_mask =3D saved_gfp;
> -			p =3D mempool_alloc(&bs->bio_pool, gfp_mask);
> -		}
> -
>  		front_pad =3D bs->front_pad;
>  		inline_vecs =3D BIO_INLINE_VECS;
>  	}
> @@ -483,12 +408,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_=
iovecs, struct bio_set *bs)
>  		unsigned long idx =3D 0;
> =20
>  		bvl =3D bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
> -		if (!bvl && gfp_mask !=3D saved_gfp) {
> -			punt_bios_to_rescuer(bs);
> -			gfp_mask =3D saved_gfp;
> -			bvl =3D bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
> -		}
> -
>  		if (unlikely(!bvl))
>  			goto err_free;
> =20
> @@ -1938,10 +1857,6 @@ int biovec_init_pool(mempool_t *pool, int pool_ent=
ries)
> =20
>  void bioset_exit(struct bio_set *bs)
>  {
> -	if (bs->rescue_workqueue)
> -		destroy_workqueue(bs->rescue_workqueue);
> -	bs->rescue_workqueue =3D NULL;
> -
>  	mempool_exit(&bs->bio_pool);
>  	mempool_exit(&bs->bvec_pool);
> =20
> @@ -1968,10 +1883,6 @@ static int __bioset_init(struct bio_set *bs,
> =20
>  	bs->front_pad =3D front_pad;
> =20
> -	spin_lock_init(&bs->rescue_lock);
> -	bio_list_init(&bs->rescue_list);
> -	INIT_WORK(&bs->rescue_work, bio_alloc_rescue);
> -
>  	bs->bio_slab =3D bio_find_or_create_slab(front_pad + back_pad);
>  	if (!bs->bio_slab)
>  		return -ENOMEM;
> @@ -1983,10 +1894,6 @@ static int __bioset_init(struct bio_set *bs,
>  	    biovec_init_pool(&bs->bvec_pool, pool_size))
>  		goto bad;
> =20
> -	bs->rescue_workqueue =3D alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
> -	if (!bs->rescue_workqueue)
> -		goto bad;
> -
>  	return 0;
>  bad:
>  	bioset_exit(bs);
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7e3cfa9c88..f716164cb3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -48,6 +48,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(block_unplug);
> =20
>  DEFINE_IDA(blk_queue_ida);
> =20
> +static void bio_rescue_work(struct work_struct *);
> +
>  /*
>   * For the allocated request tables
>   */
> @@ -759,11 +761,21 @@ struct request_queue *blk_alloc_queue_node(gfp_t gf=
p_mask, int node_id)
>  				PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
>  		goto fail_bdi;
> =20
> -	if (blkcg_init_queue(q))
> +	spin_lock_init(&q->rescue_lock);
> +	bio_list_init(&q->rescue_list);
> +	INIT_WORK(&q->rescue_work, bio_rescue_work);
> +
> +	q->rescue_workqueue =3D alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
> +	if (!q->rescue_workqueue)
>  		goto fail_ref;
> =20
> +	if (blkcg_init_queue(q))
> +		goto fail_rescue;
> +
>  	return q;
> =20
> +fail_rescue:
> +	destroy_workqueue(q->rescue_workqueue);
>  fail_ref:
>  	percpu_ref_exit(&q->q_usage_counter);
>  fail_bdi:
> @@ -1994,7 +2006,7 @@ generic_make_request_checks(struct bio *bio)
>   */
>  blk_qc_t generic_make_request(struct bio *bio)
>  {
> -	struct bio_list bio_list_on_stack;
> +	struct bio_plug_list bio_list_on_stack;
>  	blk_qc_t ret =3D BLK_QC_T_NONE;
> =20
>  	if (!generic_make_request_checks(bio))
> @@ -2011,7 +2023,9 @@ blk_qc_t generic_make_request(struct bio *bio)
>  	 * should be added at the tail
>  	 */
>  	if (current->bio_list) {
> -		bio_list_add(current->bio_list, bio);
> +		WARN(!current->bio_list->q->rescue_workqueue,
> +		     "submitting bio beneath generic_make_request() without rescuer");
> +		bio_list_add(&current->bio_list->bios, bio);
>  		goto out;
>  	}
> =20
> @@ -2030,19 +2044,23 @@ blk_qc_t generic_make_request(struct bio *bio)
>  	 * bio_list, and call into ->make_request() again.
>  	 */
>  	BUG_ON(bio->bi_next);
> -	bio_list_init(&bio_list_on_stack);
> +	bio_list_init(&bio_list_on_stack.bios);
>  	current->bio_list =3D &bio_list_on_stack;
> +
>  	do {
>  		struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
> =20
> +		current->bio_list->q =3D q;
> +
>  		if (likely(blk_queue_enter(q, false) =3D=3D 0)) {
>  			ret =3D q->make_request_fn(q, bio);
> =20
>  			blk_queue_exit(q);
> =20
> -			bio =3D bio_list_pop(current->bio_list);
> +			bio =3D bio_list_pop(&current->bio_list->bios);
>  		} else {
> -			struct bio *bio_next =3D bio_list_pop(current->bio_list);
> +			struct bio *bio_next =3D
> +				bio_list_pop(&current->bio_list->bios);
> =20
>  			bio_io_error(bio);
>  			bio =3D bio_next;
> @@ -2055,6 +2073,34 @@ blk_qc_t generic_make_request(struct bio *bio)
>  }
>  EXPORT_SYMBOL(generic_make_request);
> =20
> +static void bio_rescue_work(struct work_struct *work)
> +{
> +	struct request_queue *q =3D
> +		container_of(work, struct request_queue, rescue_work);
> +	struct bio *bio;
> +
> +	while (1) {
> +		spin_lock(&q->rescue_lock);
> +		bio =3D bio_list_pop(&q->rescue_list);
> +		spin_unlock(&q->rescue_lock);
> +
> +		if (!bio)
> +			break;
> +
> +		generic_make_request(bio);
> +	}
> +}
> +
> +void blk_punt_blocked_bios(struct bio_plug_list *list)
> +{
> +	spin_lock(&list->q->rescue_lock);
> +	bio_list_merge(&list->q->rescue_list, &list->bios);
> +	bio_list_init(&list->bios);
> +	spin_unlock(&list->q->rescue_lock);
> +
> +	queue_work(list->q->rescue_workqueue, &list->q->rescue_work);
> +}
> +
>  /**
>   * submit_bio - submit a bio to the block device layer for I/O
>   * @bio: The &struct bio which describes the I/O
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 7f27a18cc4..77529238d1 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -660,6 +660,8 @@ static void blk_release_queue(struct kobject *kobj)
> =20
>  	blk_trace_shutdown(q);
> =20
> +	if (q->rescue_workqueue)
> +		destroy_workqueue(q->rescue_workqueue);
>  	if (q->bio_split)
>  		bioset_free(q->bio_split);
> =20
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 1ffe8e37ae..87eeec7eda 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -658,6 +658,13 @@ static inline struct bio *bio_list_get(struct bio_li=
st *bl)
>  	return bio;
>  }
> =20
> +struct bio_plug_list {
> +	struct bio_list		bios;
> +	struct request_queue	*q;
> +};
> +
> +void blk_punt_blocked_bios(struct bio_plug_list *);
> +
>  /*
>   * Increment chain count for the bio. Make sure the CHAIN flag update
>   * is visible before the raised count.
> @@ -687,15 +694,6 @@ struct bio_set {
>  	mempool_t bio_integrity_pool;
>  	mempool_t bvec_integrity_pool;
>  #endif
> -
> -	/*
> -	 * Deadlock avoidance for stacking block drivers: see comments in
> -	 * bio_alloc_bioset() for details
> -	 */
> -	spinlock_t		rescue_lock;
> -	struct bio_list		rescue_list;
> -	struct work_struct	rescue_work;
> -	struct workqueue_struct	*rescue_workqueue;
>  };
> =20
>  struct biovec_slab {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index c47c358ba0..f64b886c65 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -476,6 +476,16 @@ struct request_queue {
>  	struct bio_set		*bio_split;
> =20
>  	bool			mq_sysfs_init_done;
> +
> +	/*
> +	 * Deadlock avoidance, to deal with the plugging in
> +	 * generic_make_request() that converts recursion to iteration to avoid
> +	 * stack overflow:
> +	 */
> +	spinlock_t		rescue_lock;
> +	struct bio_list		rescue_list;
> +	struct work_struct	rescue_work;
> +	struct workqueue_struct	*rescue_workqueue;
>  };
> =20
>  #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2865d10a28..59df7a1030 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1762,7 +1762,7 @@ struct task_struct {
>  	void *journal_info;
> =20
>  /* stacked block device info */
> -	struct bio_list *bio_list;
> +	struct bio_plug_list *bio_list;
> =20
>  #ifdef CONFIG_BLOCK
>  /* stack plugging */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index bd39d698cb..23b6290ba1 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3439,6 +3439,10 @@ static inline void sched_submit_work(struct task_s=
truct *tsk)
>  {
>  	if (!tsk->state || tsk_is_pi_blocked(tsk))
>  		return;
> +
> +	if (tsk->bio_list && !bio_list_empty(&tsk->bio_list->bios))
> +		blk_punt_blocked_bios(tsk->bio_list);
> +
>  	/*
>  	 * If we are going to sleep and we have plugged IO queued,
>  	 * make sure to submit it to avoid deadlocks.

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliaMG8ACgkQMOfwapXb+vJXJwCgrq0CdlTxAwZ4spd+CGnfSbHz
FccAnA9oKgXsgekZpm+YyUn78kYfMyx4
=thIU
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
