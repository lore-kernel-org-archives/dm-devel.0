From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 08/11] block: kill merge_bvec_fn() completely
Date: Mon, 25 May 2015 16:04:13 +0200
Message-ID: <20150525140413.GA26065@lst.de>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org> <1432318723-18829-9-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432318723-18829-9-git-send-email-mlin@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alex Elder <elder@linaro.org>
List-Id: dm-devel.ids

On Fri, May 22, 2015 at 11:18:40AM -0700, Ming Lin wrote:
> From: Kent Overstreet <kent.overstreet@gmail.com>
> 
> As generic_make_request() is now able to handle arbitrarily sized bios,
> it's no longer necessary for each individual block driver to define its
> own ->merge_bvec_fn() callback. Remove every invocation completely.

It might be good to replace patch 1 and this one by a patch per driver
to remove the merge_bvec_fn instance and add the blk_queue_split call
for all those drivers that actually had a ->merge_bvec_fn.  As some
of them were non-trivial attention from the maintainers would be helpful,
and a patch per driver might help with that.

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
> -int drbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm, struct bio_vec *bvec)


This just checks the lower device, so it looks obviously fine.

> -static int pkt_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
> -			  struct bio_vec *bvec)
> -{
> -	struct pktcdvd_device *pd = q->queuedata;
> -	sector_t zone = get_zone(bmd->bi_sector, pd);
> -	int used = ((bmd->bi_sector - zone) << 9) + bmd->bi_size;
> -	int remaining = (pd->settings.size << 9) - used;
> -	int remaining2;
> -
> -	/*
> -	 * A bio <= PAGE_SIZE must be allowed. If it crosses a packet
> -	 * boundary, pkt_make_request() will split the bio.
> -	 */
> -	remaining2 = PAGE_SIZE - bmd->bi_size;
> -	remaining = max(remaining, remaining2);
> -
> -	BUG_ON(remaining < 0);
> -	return remaining;
> -}

As mentioned in the comment pkt_make_request will split the bio so pkt
looks fine.

> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index ec6c5c6..f50edb3 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -3440,52 +3440,6 @@ static int rbd_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	return BLK_MQ_RQ_QUEUE_OK;
>  }
>  
> -/*
> - * a queue callback. Makes sure that we don't create a bio that spans across
> - * multiple osd objects. One exception would be with a single page bios,
> - * which we handle later at bio_chain_clone_range()
> - */
> -static int rbd_merge_bvec(struct request_queue *q, struct bvec_merge_data *bmd,
> -			  struct bio_vec *bvec)

It seems rbd handles requests spanning objects just fine, so I don't
really understand why rbd_merge_bvec even exists.  Getting some form
of ACK from the ceph folks would be useful.

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

DM seems to have the most complex merge functions of all drivers, so
I'd really love to see an ACK from Mike.

