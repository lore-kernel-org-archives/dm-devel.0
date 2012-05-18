From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH 03/13] block: Add bio_clone_bioset()
Date: Fri, 18 May 2012 12:11:30 -0400
Message-ID: <20120518161130.GG25708@redhat.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 17, 2012 at 10:59:50PM -0400, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:

[..]
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a5a524e..47605e7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -178,23 +178,7 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
>  	if (!mddev || !mddev->bio_set)
>  		return bio_clone(bio, gfp_mask);
>  
> -	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, mddev->bio_set);
> -	if (!b)
> -		return NULL;
> -
> -	__bio_clone(b, bio);
> -	if (bio_integrity(bio)) {
> -		int ret;
> -
> -		ret = bio_integrity_clone(b, bio, gfp_mask, mddev->bio_set);
> -
> -		if (ret < 0) {
> -			bio_put(b);
> -			return NULL;
> -		}
> -	}
> -
> -	return b;
> +	return bio_clone_bioset(gfp_mask, bio_segments(bio), mddev->bio_set);

Are we passing wrong arguments to bio_clone_bioset()?

Thanks
Vivek
