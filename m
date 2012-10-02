From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Date: Tue, 2 Oct 2012 11:37:37 -0400
Message-ID: <20121002153736.GA3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1348526106-17074-3-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:

[..]
>  /**
>   * bio_integrity_alloc - Allocate integrity payload and attach it to bio
>   * @bio:	bio to attach integrity metadata to
> @@ -84,37 +47,39 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
>  						  unsigned int nr_vecs)
>  {
>  	struct bio_integrity_payload *bip;
> -	unsigned int idx = vecs_to_idx(nr_vecs);
>  	struct bio_set *bs = bio->bi_pool;
> +	unsigned long idx = BIO_POOL_NONE;
> +	unsigned inline_vecs;
> +
> +	if (!bs) {
> +		bip = kmalloc(sizeof(struct bio_integrity_payload) +
> +			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
> +		inline_vecs = nr_vecs;
> +	} else {
> +		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
> +		inline_vecs = BIP_INLINE_VECS;
> +	}
>  
> -	if (!bs)
> -		bs = fs_bio_set;

Ok, this is change of behavior. Previously we will fall back to fs_bio_set
and now you do kmalloc. This change looks to be independent of bip_vec
pointer. Can you please break it out in a separate patch and also explain
that how does this change help.

Thanks
Vivek
