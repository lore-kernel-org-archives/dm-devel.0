From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 15/26] block: Add bio_copy_data()
Date: Thu, 20 Sep 2012 17:06:32 -0700
Message-ID: <20120921000632.GS7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-16-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-16-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Mon, Sep 10, 2012 at 05:22:26PM -0700, Kent Overstreet wrote:
> +void bio_copy_data(struct bio *dst, struct bio *src)
> +{
...
> +		src_p = kmap_atomic(src_bv->bv_page);
> +		dst_p = kmap_atomic(dst_bv->bv_page);
> +
> +		memcpy(dst_p + dst_bv->bv_offset,
> +		       src_p + src_bv->bv_offset,
> +		       bytes);
> +
> +		kunmap_atomic(dst_p);
> +		kunmap_atomic(src_p);

Wrap these in preempt_disable/enable() to allow the function to be
called from any context?

Thanks.

-- 
tejun
