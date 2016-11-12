From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/12] block: bio: pass bvec table to bio_init()
Date: Sat, 12 Nov 2016 09:59:43 -0800
Message-ID: <20161112175943.GA4814@infradead.org>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
 <1478865957-25252-2-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478865957-25252-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jikos@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Eric
List-Id: dm-devel.ids

On Fri, Nov 11, 2016 at 08:05:29PM +0800, Ming Lei wrote:
> Some drivers often use external bvec table, so introduce
> this helper for this case. It is always safe to access the
> bio->bi_io_vec in this way for this case.
> 
> After converting to this usage, it will becomes a bit easier
> to evaluate the remaining direct access to bio->bi_io_vec,
> so it can help to prepare for the following multipage bvec
> support.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  block/bio.c                   |  8 ++++++--
>  drivers/block/floppy.c        |  3 +--
>  drivers/md/bcache/io.c        |  4 +---
>  drivers/md/bcache/journal.c   |  4 +---
>  drivers/md/bcache/movinggc.c  |  6 ++----
>  drivers/md/bcache/request.c   |  2 +-
>  drivers/md/bcache/super.c     | 12 +++---------
>  drivers/md/bcache/writeback.c |  5 ++---
>  drivers/md/dm-bufio.c         |  4 +---
>  drivers/md/dm.c               |  2 +-
>  drivers/md/multipath.c        |  2 +-
>  drivers/md/raid5-cache.c      |  2 +-
>  drivers/md/raid5.c            |  9 ++-------
>  drivers/nvme/target/io-cmd.c  |  4 +---
>  fs/logfs/dev_bdev.c           |  4 +---
>  include/linux/bio.h           |  3 ++-
>  16 files changed, 27 insertions(+), 47 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 2cf6ebabc68c..de257ced69b1 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -270,11 +270,15 @@ static void bio_free(struct bio *bio)
>  	}
>  }
>  
> -void bio_init(struct bio *bio)
> +void bio_init(struct bio *bio, struct bio_vec *table,
> +	      unsigned short max_vecs)
>  {
>  	memset(bio, 0, sizeof(*bio));
>  	atomic_set(&bio->__bi_remaining, 1);
>  	atomic_set(&bio->__bi_cnt, 1);
> +
> +	bio->bi_io_vec = table;
> +	bio->bi_max_vecs = max_vecs;
>  }
>  EXPORT_SYMBOL(bio_init);
>  
> @@ -480,7 +484,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		return NULL;
>  
>  	bio = p + front_pad;
> -	bio_init(bio);
> +	bio_init(bio, NULL, 0);
>  
>  	if (nr_iovecs > inline_vecs) {
>  		unsigned long idx = 0;
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index e3d8e4ced4a2..6a3ff2b2e3ae 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -3806,8 +3806,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
>  
>  	cbdata.drive = drive;
>  
> -	bio_init(&bio);
> -	bio.bi_io_vec = &bio_vec;
> +	bio_init(&bio, &bio_vec, 1);
>  	bio_vec.bv_page = page;
>  	bio_vec.bv_len = size;
>  	bio_vec.bv_offset = 0;
> diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> index e97b0acf7b8d..db45a88c0ce9 100644
> --- a/drivers/md/bcache/io.c
> +++ b/drivers/md/bcache/io.c
> @@ -24,9 +24,7 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
>  	struct bbio *b = mempool_alloc(c->bio_meta, GFP_NOIO);
>  	struct bio *bio = &b->bio;
>  
> -	bio_init(bio);
> -	bio->bi_max_vecs	 = bucket_pages(c);
> -	bio->bi_io_vec		 = bio->bi_inline_vecs;
> +	bio_init(bio, bio->bi_inline_vecs, bucket_pages(c));
>  
>  	return bio;
>  }
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 6925023e12d4..1198e53d5670 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -448,13 +448,11 @@ static void do_journal_discard(struct cache *ca)
>  
>  		atomic_set(&ja->discard_in_flight, DISCARD_IN_FLIGHT);
>  
> -		bio_init(bio);
> +		bio_init(bio, bio->bi_inline_vecs, 1);
>  		bio_set_op_attrs(bio, REQ_OP_DISCARD, 0);
>  		bio->bi_iter.bi_sector	= bucket_to_sector(ca->set,
>  						ca->sb.d[ja->discard_idx]);
>  		bio->bi_bdev		= ca->bdev;
> -		bio->bi_max_vecs	= 1;
> -		bio->bi_io_vec		= bio->bi_inline_vecs;
>  		bio->bi_iter.bi_size	= bucket_bytes(ca);
>  		bio->bi_end_io		= journal_discard_endio;
>  
> diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
> index 5c4bddecfaf0..13b8a907006d 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -77,15 +77,13 @@ static void moving_init(struct moving_io *io)
>  {
>  	struct bio *bio = &io->bio.bio;
>  
> -	bio_init(bio);
> +	bio_init(bio, bio->bi_inline_vecs,
> +		 DIV_ROUND_UP(KEY_SIZE(&io->w->key), PAGE_SECTORS));
>  	bio_get(bio);
>  	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
>  
>  	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
> -	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&io->w->key),
> -					       PAGE_SECTORS);
>  	bio->bi_private		= &io->cl;
> -	bio->bi_io_vec		= bio->bi_inline_vecs;
>  	bch_bio_map(bio, NULL);
>  }
>  
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 0d99b5f4b3e6..f49c5417527d 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -623,7 +623,7 @@ static void do_bio_hook(struct search *s, struct bio *orig_bio)
>  {
>  	struct bio *bio = &s->bio.bio;
>  
> -	bio_init(bio);
> +	bio_init(bio, NULL, 0);
>  	__bio_clone_fast(bio, orig_bio);

We have this pattern multiple times, and it almost screams for a helper.
But I think we're better off letting your patch go in as-is and sort
that out later instead of delaying it.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
