From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/26] block: Add bio_end()
Date: Thu, 20 Sep 2012 16:32:25 -0700
Message-ID: <20120920233225.GK7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-6-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-6-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:16PM -0700, Kent Overstreet wrote:
> Just a little convenience macro - main reason to add it now is preparing
> for immutable bio vecs, it'll reduce the size of the patch that puts
> bi_sector/bi_size/bi_idx into a struct bvec_iter.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 6763cdf..92bff0e 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -67,6 +67,7 @@
>  #define bio_offset(bio)		bio_iovec((bio))->bv_offset
>  #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
>  #define bio_sectors(bio)	((bio)->bi_size >> 9)
> +#define bio_end(bio)		((bio)->bi_sector + bio_sectors(bio))

Maybe bio_end_sector() is a better name?  bio_end() looks a bit too
close to bio_endio().

Thanks.

-- 
tejun
