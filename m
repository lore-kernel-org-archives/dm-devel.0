From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] lib/memweight.c: open codes bitmap_weight()
Date: Sat, 24 Aug 2019 23:11:58 -0700
Message-ID: <20190825061158.GC28002@bombadil.infradead.org>
References: <20190821074200.2203-1-efremov@ispras.ru>
 <20190824100102.1167-1-efremov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190824100102.1167-1-efremov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Efremov <efremov@ispras.ru>
Cc: akpm@linux-foundation.org, Akinobu Mita <akinobu.mita@gmail.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, Erdem Tumurov <erdemus@gmail.com>, Vladimir Shelekhov <vshel@iis.nsk.su>
List-Id: dm-devel.ids

On Sat, Aug 24, 2019 at 01:01:02PM +0300, Denis Efremov wrote:
> This patch open codes the bitmap_weight() call. The direct
> invocation of hweight_long() allows to remove the BUG_ON and
> excessive "longs to bits, bits to longs" conversion.

Honestly, that's not the problem with this function.  Take a look
at https://danluu.com/assembly-intrinsics/ for a _benchmarked_
set of problems with popcnt.

> BUG_ON was required to check that bitmap_weight() will return
> a correct value, i.e. the computed weight will fit the int type
> of the return value.

What?  No.  Look at the _arguments_ of bitmap_weight():

static __always_inline int bitmap_weight(const unsigned long *src, unsigned int nbits)

> With this patch memweight() controls the
> computation directly with size_t type everywhere. Thus, the BUG_ON
> becomes unnecessary.

Why are you bothering?  How are you allocating half a gigabyte of memory?
Why are you calling memweight() on half a gigabyte of memory?

>  	if (longs) {
> -		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
> -		ret += bitmap_weight((unsigned long *)bitmap,
> -				longs * BITS_PER_LONG);
> +		const unsigned long *bitmap_long =
> +			(const unsigned long *)bitmap;
> +
>  		bytes -= longs * sizeof(long);
> -		bitmap += longs * sizeof(long);
> +		for (; longs > 0; longs--, bitmap_long++)
> +			ret += hweight_long(*bitmap_long);
> +		bitmap = (const unsigned char *)bitmap_long;
>  	}

If you really must change anything, I'd rather see this turned into a
loop:

	while (longs) {
		unsigned int nbits;

		if (longs >= INT_MAX / BITS_PER_LONG)
			nbits = INT_MAX + 1;
		else
			nbits = longs * BITS_PER_LONG;

		ret += bitmap_weight((unsigned long *)bitmap, sz);
		bytes -= nbits / 8;
		bitmap += nbits / 8;
		longs -= nbits / BITS_PER_LONG;
	}

then we only have to use Dan Luu's optimisation in bitmap_weight()
and not in memweight() as well.

Also, why does the trailer do this:

        for (; bytes > 0; bytes--, bitmap++)
                ret += hweight8(*bitmap);

instead of calling hweight_long on *bitmap & mask?
