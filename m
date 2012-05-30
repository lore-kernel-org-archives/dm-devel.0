From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Date: Wed, 30 May 2012 16:47:08 +0900
Message-ID: <20120530074708.GA32121@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

A couple more comments from this round of reading.

On Wed, May 09, 2012 at 11:10:48PM -0400, Kent Overstreet wrote:
> +#define btree_prio		USHRT_MAX
> +#define initial_prio		32768

Why are these in lower case?

> +#define PTR_BUCKET(c, k, n)						\
> +	(PTR_CACHE(c, k, n)->buckets + PTR_BUCKET_NR(c, k, n))

PTR_BUCKET(c, k, n)

Awesome.  I don't know what type it takes or what each single
character argument stands for.

> +static inline bool cached_dev_get(struct cached_dev *d)
> +{
> +	if (!atomic_inc_not_zero(&d->count))
> +		return false;
> +
> +	smp_mb__after_atomic_inc();

What is this mb() paired with?  Whenever using a mb, please specify
what the mb is paired with.

> +	return true;
> +}

Thanks.

-- 
tejun
