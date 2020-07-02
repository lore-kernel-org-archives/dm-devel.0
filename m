From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 17/20] block: rename generic_make_request to
 submit_bio_noacct
Date: Thu, 2 Jul 2020 22:51:29 +0800
Message-ID: <d8e792a2-1333-6852-6334-a681953f0bdc@suse.de>
References: <20200701085947.3354405-1-hch@lst.de>
 <20200701085947.3354405-18-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20200701085947.3354405-18-hch@lst.de>
Content-Language: en-US
Sender: linux-m68k-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On 2020/7/1 16:59, Christoph Hellwig wrote:
> generic_make_request has always been very confusingly misnamed, so rename
> it to submit_bio_noacct to make it clear that it is submit_bio minus
> accounting and a few checks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I will miss generic_make_request(). Anyway, if it is decided, for bcache
part,

Acked-by: Coly Li <colyli@suse.de>

> ---
>  Documentation/block/biodoc.rst                |  2 +-
>  .../fault-injection/fault-injection.rst       |  2 +-
>  Documentation/trace/ftrace.rst                |  4 +--
>  block/bio.c                                   | 14 ++++----
>  block/blk-core.c                              | 32 +++++++++----------
>  block/blk-crypto-fallback.c                   |  2 +-
>  block/blk-crypto.c                            |  2 +-
>  block/blk-merge.c                             |  2 +-
>  block/blk-throttle.c                          |  4 +--
>  block/bounce.c                                |  2 +-
>  drivers/block/drbd/drbd_int.h                 |  6 ++--
>  drivers/block/drbd/drbd_main.c                |  2 +-
>  drivers/block/drbd/drbd_receiver.c            |  2 +-
>  drivers/block/drbd/drbd_req.c                 |  2 +-
>  drivers/block/drbd/drbd_worker.c              |  2 +-
>  drivers/block/pktcdvd.c                       |  2 +-
>  drivers/lightnvm/pblk-read.c                  |  2 +-
>  drivers/md/bcache/bcache.h                    |  2 +-
>  drivers/md/bcache/btree.c                     |  2 +-
>  drivers/md/bcache/request.c                   |  7 ++--
>  drivers/md/dm-cache-target.c                  |  6 ++--
>  drivers/md/dm-clone-target.c                  | 10 +++---
>  drivers/md/dm-crypt.c                         |  6 ++--
>  drivers/md/dm-delay.c                         |  2 +-
>  drivers/md/dm-era-target.c                    |  2 +-
>  drivers/md/dm-integrity.c                     |  4 +--
>  drivers/md/dm-mpath.c                         |  2 +-
>  drivers/md/dm-raid1.c                         |  2 +-
>  drivers/md/dm-snap-persistent.c               |  2 +-
>  drivers/md/dm-snap.c                          |  6 ++--
>  drivers/md/dm-thin.c                          |  4 +--
>  drivers/md/dm-verity-target.c                 |  2 +-
>  drivers/md/dm-writecache.c                    |  2 +-
>  drivers/md/dm-zoned-target.c                  |  2 +-
>  drivers/md/dm.c                               | 10 +++---
>  drivers/md/md-faulty.c                        |  4 +--
>  drivers/md/md-linear.c                        |  4 +--
>  drivers/md/md-multipath.c                     |  4 +--
>  drivers/md/raid0.c                            |  8 ++---
>  drivers/md/raid1.c                            | 14 ++++----
>  drivers/md/raid10.c                           | 28 ++++++++--------
>  drivers/md/raid5.c                            | 10 +++---
>  drivers/nvme/host/multipath.c                 |  2 +-
>  include/linux/blkdev.h                        |  2 +-
>  44 files changed, 115 insertions(+), 118 deletions(-)
> 

[snipped]

> diff --git a/drivers/lightnvm/pblk-read.c b/drivers/lightnvm/pblk-read.c
> index 140927ebf41e9a..c28537a489bc10 100644
> --- a/drivers/lightnvm/pblk-read.c
> +++ b/drivers/lightnvm/pblk-read.c
> @@ -320,7 +320,7 @@ void pblk_submit_read(struct pblk *pblk, struct bio *bio)
>  		split_bio = bio_split(bio, nr_secs * NR_PHY_IN_LOG, GFP_KERNEL,
>  					&pblk_bio_set);
>  		bio_chain(split_bio, bio);
> -		generic_make_request(bio);
> +		submit_bio_noacct(bio);
>  
>  		/* New bio contains first N sectors of the previous one, so
>  		 * we can continue to use existing rqd, but we need to shrink
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 221e0191b6870f..3c708e8b5e2d34 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -929,7 +929,7 @@ static inline void closure_bio_submit(struct cache_set *c,
>  		bio_endio(bio);
>  		return;
>  	}
> -	generic_make_request(bio);
> +	submit_bio_noacct(bio);
>  }
>  
>  /*
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 6548a601edf0e4..d5c51e33204679 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -959,7 +959,7 @@ static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
>   * bch_btree_node_get - find a btree node in the cache and lock it, reading it
>   * in from disk if necessary.
>   *
> - * If IO is necessary and running under generic_make_request, returns -EAGAIN.
> + * If IO is necessary and running under submit_bio_noacct, returns -EAGAIN.
>   *
>   * The btree node will have either a read or a write lock held, depending on
>   * level and op->lock.
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index fc5702b10074d6..dd012ebface012 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1115,7 +1115,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
>  	    !blk_queue_discard(bdev_get_queue(dc->bdev)))
>  		bio->bi_end_io(bio);
>  	else
> -		generic_make_request(bio);
> +		submit_bio_noacct(bio);
>  }
>  
>  static void quit_max_writeback_rate(struct cache_set *c,
> @@ -1197,7 +1197,7 @@ blk_qc_t cached_dev_submit_bio(struct bio *bio)
>  		if (!bio->bi_iter.bi_size) {
>  			/*
>  			 * can't call bch_journal_meta from under
> -			 * generic_make_request
> +			 * submit_bio_noacct
>  			 */
>  			continue_at_nobarrier(&s->cl,
>  					      cached_dev_nodata,
> @@ -1311,8 +1311,7 @@ blk_qc_t flash_dev_submit_bio(struct bio *bio)
>  
>  	if (!bio->bi_iter.bi_size) {
>  		/*
> -		 * can't call bch_journal_meta from under
> -		 * generic_make_request
> +		 * can't call bch_journal_meta from under submit_bio_noacct
>  		 */
>  		continue_at_nobarrier(&s->cl,
>  				      flash_dev_nodata,
>
