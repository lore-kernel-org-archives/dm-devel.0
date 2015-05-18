From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3 01/11] block: make generic_make_request handle arbitrarily sized bios
Date: Mon, 18 May 2015 12:52:03 -0400
Message-ID: <x49twv9kevg.fsf@segfault.boston.devel.redhat.com>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
	<1430980461-5235-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430980461-5235-2-git-send-email-mlin@kernel.org> (Ming Lin's
	message of "Wed, 6 May 2015 23:34:11 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

Ming Lin <mlin@kernel.org> writes:

> diff --git a/block/blk-core.c b/block/blk-core.c
> index fd154b9..909f317 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -617,6 +617,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>  	if (q->id < 0)
>  		goto fail_q;
>  
> +	q->bio_split = bioset_create(4, 0);
> +	if (!q->bio_split)
> +		goto fail_id;
> +

Arbitrary numbers should be documented.

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
> +	granularity = max(q->limits.discard_granularity >> 9, 1U);
> +
> +	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> +	max_discard_sectors -= max_discard_sectors % granularity;
> +
> +	if (unlikely(!max_discard_sectors)) {
> +		/* XXX: warn */
> +		return NULL;
> +	}
> +
> +	if (bio_sectors(bio) <= max_discard_sectors)
> +		return NULL;
> +
> +	split_sectors = max_discard_sectors;
> +
> +	/*
> +	 * If the next starting sector would be misaligned, stop the discard at
> +	 * the previous aligned sector.
> +	 */
> +	alignment = (q->limits.discard_alignment >> 9) % granularity;
> +
> +	tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
> +	tmp = sector_div(tmp, granularity);
> +
> +	if (split_sectors > tmp)
> +		split_sectors -= tmp;
> +
> +	return bio_split(bio, split_sectors, GFP_NOIO, bs);

Much of this function is cut-n-paste from blk-lib.c.  Is there any way
to factor it out?

> +static struct bio *blk_bio_segment_split(struct request_queue *q,
> +					 struct bio *bio,
> +					 struct bio_set *bs)
> +{

Funny name for a function that also merges segments.  ;-)  I admit I am
at a loss for coming up with a better name that won't overflow 80
columns.

Other than that, this looks sane.

Cheers,
Jeff
