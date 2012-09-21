From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 22/26] block: Add bio_alloc_pages()
Date: Thu, 20 Sep 2012 17:47:11 -0700
Message-ID: <20120921004711.GZ7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-23-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-23-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:33PM -0700, Kent Overstreet wrote:
> +	bio_for_each_segment_all(bv, bio, i) {
> +		bv->bv_page = alloc_page(gfp_mask);
> +		if (!bv->bv_page) {
> +			while (bv-- != bio->bi_io_vec)
> +				__free_page(bv->bv_page);

I don't know.  I feel stupid.  I think it's because the loop variable
changes between loop condition test and actual body of loop.  How
about the following?  It is pointing to the member of the same array
so I think it's not even violating pointer comparison rules.

	while (--bv >= bio->bi_io_vec)
		__free_page(bv->bv_page);

-- 
tejun
