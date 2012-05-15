From: Tejun Heo <tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bcache v13 02/16] Bio pool freeing
Date: Tue, 15 May 2012 09:24:00 -0700
Message-ID: <20120515162400.GB17216@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:08:34PM -0400, Kent Overstreet wrote:
> When you allocate a bio from a bio pool, to free it you have to know
> where it came from; this adds a flag which, if set, means bi_destructor
> is the pointer to the pool and bio_put() can do the right thing.
> 
> This is used in bcache, so we can cleanly use per device bio pools.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> @@ -417,7 +418,11 @@ void bio_put(struct bio *bio)
>  	 */
>  	if (atomic_dec_and_test(&bio->bi_cnt)) {
>  		bio->bi_next = NULL;
> -		bio->bi_destructor(bio);
> +
> +		if (bio_flagged(bio, BIO_HAS_POOL))
> +			bio_free(bio, (void *) bio->bi_destructor);
> +		else
> +			bio->bi_destructor(bio);

Ummm... this is way too cryptic.  Please just add another field to
bio.

Thanks.

-- 
tejun
