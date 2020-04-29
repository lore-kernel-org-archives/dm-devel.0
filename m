From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-writecache: improve performance on
 Optane-based persistent memory
Date: Wed, 29 Apr 2020 21:49:59 +0200
Message-ID: <3af73377-592b-ba25-c562-636f20125d62@redhat.com>
References: <alpine.LRH.2.02.2004291225140.3914@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2004291225140.3914@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 4/29/20 6:30 PM, Mikulas Patocka wrote:
> Hi
>
> This is the clflushopt patch for the next merge window.
>
> Mikulas
>
>
> From: Mikulas Patocka <mpatocka@redhat.com>
>
> When testing the dm-writecache target on a real Optane-based persistent
> memory, it turned out that explicit cache flushing using the clflushopt
> instruction performs better than non-temporal stores for block sizes 1k,
> 2k and 4k.
>
> This patch adds a new function memcpy_flushcache_optimized that tests if
> clflushopt is present - and if it is, we use it instead of
> memcpy_flushcache.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>   drivers/md/dm-writecache.c |   29 ++++++++++++++++++++++++++++-
>   1 file changed, 28 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/md/dm-writecache.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-writecache.c	2020-04-29 18:09:53.599999000 +0200
> +++ linux-2.6/drivers/md/dm-writecache.c	2020-04-29 18:22:36.139999000 +0200
> @@ -1137,6 +1137,33 @@ static int writecache_message(struct dm_
>   	return r;
>   }
>   
> +static void memcpy_flushcache_optimized(void *dest, void *source, size_t size)
> +{
> +	/*
> +	 * clufhsopt performs better with block size 1024, 2048, 4096
> +	 * non-temporal stores perform better with block size 512
> +	 *
> +	 * block size   512             1024            2048            4096
> +	 * movnti       496 MB/s        642 MB/s        725 MB/s        744 MB/s
> +	 * clflushopt   373 MB/s        688 MB/s        1.1 GB/s        1.2 GB/s
> +	 */
> +#ifdef CONFIG_X86
> +	if (static_cpu_has(X86_FEATURE_CLFLUSHOPT) &&
> +	    likely(boot_cpu_data.x86_clflush_size == 64) &&
> +	    likely(size >= 768)) {
> +		do {
> +			memcpy((void *)dest, (void *)source, 64);
> +			clflushopt((void *)dest);
> +			dest += 64;
> +			source += 64;
> +			size -= 64;
> +		} while (size >= 64);
> +		return;


Aren't memory barriers needed for ordering before and after the loop?

Heinz


> +	}
> +#endif
> +	memcpy_flushcache(dest, source, size);
> +}
> +
>   static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data)
>   {
>   	void *buf;
> @@ -1162,7 +1189,7 @@ static void bio_copy_block(struct dm_wri
>   			}
>   		} else {
>   			flush_dcache_page(bio_page(bio));
> -			memcpy_flushcache(data, buf, size);
> +			memcpy_flushcache_optimized(data, buf, size);
>   		}
>   
>   		bvec_kunmap_irq(buf, &flags);
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
