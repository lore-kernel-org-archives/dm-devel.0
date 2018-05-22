From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/4] dm-writecache
Date: Mon, 21 May 2018 23:37:36 -0700
Message-ID: <20180522063736.GA8054@infradead.org>
References: <20180519052503.325953342@debian.vm>
	<20180519052634.307321960@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180519052634.307321960@debian.vm>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Dan Williams <dan.j.williams@intel.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, May 19, 2018 at 07:25:06AM +0200, Mikulas Patocka wrote:
> The dm-writecache target.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

You'll need to actually describe your new code in the changelog.

> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/md/dm-writecache.c	2018-05-17 02:46:44.000000000 +0200
> @@ -0,0 +1,2414 @@
> +/*
> + * Copyright (C) 2018 Red Hat. All rights reserved.
> + *
> + * This file is released under the GPL.
> + */

New code needs a SPDX header.

> +/*
> + * On X86, non-temporal stores are more efficient than cache flushing.
> + * On ARM64, cache flushing is more efficient.
> + */
> +#if defined(CONFIG_X86_64)
> +#define EAGER_DATA_FLUSH
> +#define NT_STORE(dest, src)				\
> +do {							\
> +	typeof(src) val = (src);			\
> +	memcpy_flushcache(&(dest), &val, sizeof(src));	\
> +} while (0)
> +#else
> +#define NT_STORE(dest, src)	WRITE_ONCE(dest, src)
> +#endif

No per-arch hacks in the driver please, this needs a proper Kconfig
symbol provided from the architectures.

> +struct wc_entry {
> +	struct rb_node rb_node;
> +	struct list_head lru;
> +	unsigned short wc_list_contiguous;
> +	bool write_in_progress
> +#if BITS_PER_LONG == 64
> +		:1
> +#endif
> +	;
> +	unsigned long index
> +#if BITS_PER_LONG == 64
> +		:47
> +#endif

Hacks like this shouldn't normally exist, but if you absolutely
need them you need to explain why in a comment.

Haven't had time to do a full review due to my backlog, I'll try to
find some time later today or tomorrow.
