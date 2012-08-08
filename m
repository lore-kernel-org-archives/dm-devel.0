From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Date: Wed, 8 Aug 2012 15:58:39 -0700
Message-ID: <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1344290921-25154-9-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Mon, Aug 06, 2012 at 03:08:37PM -0700, Kent Overstreet wrote:
>  /**
> + * bio_split - split a bio
> + * @bio:	bio to split
> + * @sectors:	number of sectors to split from the front of @bio
> + * @gfp:	gfp mask
> + * @bs:		bio set to allocate from
> + *
> + * Allocates and returns a new bio which represents @sectors from the start of
> + * @bio, and updates @bio to represent the remaining sectors.
> + *
> + * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
> + * unchanged.

Umm.... I don't know.  This is rather confusing.  The function may
return new or old bios?  What's the rationale behind it?  Return
ERR_PTR(-EINVAL) instead?

> + *
> + * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
> + * bvec boundry; it is the caller's responsibility to ensure that @bio is not
> + * freed before the split.

This is somewhat error-prone.  Given how splits are used now, this
might not be a big issue but it isn't difficult to imagine how this
could go subtly wrong.  More on this.

> + *
> + * BIG FAT WARNING:
> + *
> + * If you're calling this from under generic_make_request() (i.e.
> + * current->bio_list != NULL), you should mask out __GFP_WAIT and punt to
> + * workqueue if the allocation fails. Otherwise, your code will probably
> + * deadlock.

If the condition is detectable, WARN_ON_ONCE() please.

> + * You can't allocate more than once from the same bio pool without submitting
> + * the previous allocations (so they'll eventually complete and deallocate
> + * themselves), but if you're under generic_make_request() those previous
> + * allocations won't submit until you return . And if you have to split bios,
                                               ^
					       extra space
> + * you should expect that some bios will require multiple splits.
> + */
> +struct bio *bio_split(struct bio *bio, int sectors,
> +		      gfp_t gfp, struct bio_set *bs)
> +{
> +	unsigned idx, vcnt = 0, nbytes = sectors << 9;
> +	struct bio_vec *bv;
> +	struct bio *ret = NULL;
> +
> +	BUG_ON(sectors <= 0);
> +
> +	if (sectors >= bio_sectors(bio))
> +		return bio;
> +
> +	trace_block_split(bdev_get_queue(bio->bi_bdev), bio,
> +			  bio->bi_sector + sectors);
> +
> +	bio_for_each_segment(bv, bio, idx) {
> +		vcnt = idx - bio->bi_idx;
> +
> +		if (!nbytes) {
> +			ret = bio_alloc_bioset(gfp, 0, bs);
> +			if (!ret)
> +				return NULL;
> +
> +			ret->bi_io_vec = bio_iovec(bio);
> +			ret->bi_flags |= 1 << BIO_CLONED;
> +			break;
> +		} else if (nbytes < bv->bv_len) {
> +			ret = bio_alloc_bioset(gfp, ++vcnt, bs);
> +			if (!ret)
> +				return NULL;
> +
> +			memcpy(ret->bi_io_vec, bio_iovec(bio),
> +			       sizeof(struct bio_vec) * vcnt);
> +
> +			ret->bi_io_vec[vcnt - 1].bv_len = nbytes;
> +			bv->bv_offset	+= nbytes;
> +			bv->bv_len	-= nbytes;
> +			break;
> +		}

Ummm... ISTR reviewing this code and getting confused by bio_alloc
inside bio_for_each_segment() loop and commenting something about
that.  Yeah, this one.

  http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/15790/focus=370

So, I actually have reviewed this but didn't get any response and
majority of the issues I raised aren't addressed and you sent the
patch to me again?  What the hell, Kent?

> +
> +		nbytes -= bv->bv_len;
> +	}
> +
> +	ret->bi_bdev	= bio->bi_bdev;
> +	ret->bi_sector	= bio->bi_sector;
> +	ret->bi_size	= sectors << 9;
> +	ret->bi_rw	= bio->bi_rw;
> +	ret->bi_vcnt	= vcnt;
> +	ret->bi_max_vecs = vcnt;
> +	ret->bi_end_io	= bio->bi_end_io;

Is this safe?  Why isn't this chaining completion of split bio to the
original one?

Thanks.

-- 
tejun
