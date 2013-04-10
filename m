From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Date: Wed, 10 Apr 2013 16:50:09 -0700
Message-ID: <20130410235009.GI17641@mtj.dyndns.org>
References: <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com>
 <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>
List-Id: dm-devel.ids

On Wed, Apr 10, 2013 at 07:42:59PM -0400, Mikulas Patocka wrote:
>  /*
> + * bio_clone_context copies cgroup context from the original bio to the new bio.
> + * It is used by bio midlayer drivers that create new bio based on an original
> + * bio and forward it to the lower layer.
> + *
> + * No reference counts are incremented - it is assumed that the lifestime of the
> + * new bio is shorter than the lifetime of the original bio. If the new bio can
> + * outlive the old bio, the caller must increment the reference counts.
> + *
> + * Before freeing the new bio, the caller must clear the context with
> + * bio_clear_context function. If bio_clear_context were not called, the
> + * reference counts would be decremented on both new and original bio, resulting
> + * in crash due to reference count underflow.
> + */
> +static inline void bio_clone_context(struct bio *orig, struct bio *new)
> +{
> +#ifdef CONFIG_BLK_CGROUP
> +	new->bi_ioc = orig->bi_ioc;
> +	new->bi_css = orig->bi_css;

Hmmm... Let's not do this.  Sure, you'd be saving several instructions
but the gain is unlikely to be significant given that those cachelines
are likely to be hot anyway.  Also, please name it
bio_copy_association().

Thanks.

-- 
tejun
