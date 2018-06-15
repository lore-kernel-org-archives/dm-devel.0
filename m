From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v2 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and
 bitmap_free()
Date: Sat, 16 Jun 2018 01:23:46 +0300
Message-ID: <20180615222346.GC371@yury-thinkpad>
References: <20180615132017.23889-1-andriy.shevchenko@linux.intel.com>
 <20180615132017.23889-4-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615132017.23889-4-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com
List-Id: dm-devel.ids

Hi Andy,

On Fri, Jun 15, 2018 at 04:20:15PM +0300, Andy Shevchenko wrote:
> A lot of code become ugly because of open coding allocations for bitmaps.
> 
> Introduce three helpers to allow users be more clear of intention
> and keep their code neat.

I like the idea. But in following patches you switch to new API only
couple of drivers. I think, it worth to switch more, especially core
users to make new API visible for developers. Brief grepping for
candidates showse only 17 suspected places:
yury:linux$ git grep BITS_TO_LONGS | grep alloc | grep -v drivers | grep -v arch
kernel/events/uprobes.c:1188:	area->bitmap = kzalloc(BITS_TO_LONGS(UINSNS_PER_PAGE) * sizeof(long), GFP_KERNEL);
kernel/sysctl.c:3004:		tmp_bitmap = kzalloc(BITS_TO_LONGS(bitmap_len) * sizeof(unsigned long),
lib/genalloc.c:188:				BITS_TO_LONGS(nbits) * sizeof(long);
lib/test_printf.c:378:	unsigned long *bits = kcalloc(BITS_TO_LONGS(nbits), sizeof(long), GFP_KERNEL);
mm/percpu.c:1109:	chunk->alloc_map = memblock_virt_alloc(BITS_TO_LONGS(region_bits) *
mm/percpu.c:1111:	chunk->bound_map = memblock_virt_alloc(BITS_TO_LONGS(region_bits + 1) *
mm/percpu.c:1170:	chunk->alloc_map = pcpu_mem_zalloc(BITS_TO_LONGS(region_bits) *
mm/percpu.c:1175:	chunk->bound_map = pcpu_mem_zalloc(BITS_TO_LONGS(region_bits + 1) *
mm/slub.c:3668:	unsigned long *map = kzalloc(BITS_TO_LONGS(page->objects) *
mm/slub.c:4435:	unsigned long *map = kmalloc(BITS_TO_LONGS(oo_objects(s->max)) *
mm/slub.c:4596:	unsigned long *map = kmalloc(BITS_TO_LONGS(oo_objects(s->max)) *
mm/swapfile.c:3219:		frontswap_map = kvzalloc(BITS_TO_LONGS(maxpages) * sizeof(long),
net/bridge/br_if.c:328:	inuse = kcalloc(BITS_TO_LONGS(BR_MAX_PORTS), sizeof(unsigned long),
net/bridge/br_vlan.c:836:	changed = kcalloc(BITS_TO_LONGS(BR_MAX_PORTS), sizeof(unsigned long),
net/mac80211/mesh_plink.c:465:	aid_map = kcalloc(BITS_TO_LONGS(IEEE80211_MAX_AID + 1),
net/sched/cls_u32.c:737:	unsigned long *bitmap = kzalloc(BITS_TO_LONGS(NR_U32_NODE) * sizeof(unsigned long),
tools/include/linux/bitmap.h:105:	return calloc(1, BITS_TO_LONGS(nbits) * sizeof(unsigned long));

Yury

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  include/linux/bitmap.h |  8 ++++++++
>  lib/bitmap.c           | 19 +++++++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 1ee46f492267..acf5e8df3504 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -104,6 +104,14 @@
>   * contain all bit positions from 0 to 'bits' - 1.
>   */
> 
> +/*
> + * Allocation and deallocation of bitmap.
> + * Provided in lib/bitmap.c to avoid circular dependency.
> + */
> +extern unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags);
> +extern unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags);
> +extern void bitmap_free(const unsigned long *bitmap);
> +
>  /*
>   * lib/bitmap.c provides these functions:
>   */
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 33e95cd359a2..09acf2fd6a35 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -13,6 +13,7 @@
>  #include <linux/bitops.h>
>  #include <linux/bug.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/uaccess.h>
> 
> @@ -1125,6 +1126,24 @@ void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int n
>  EXPORT_SYMBOL(bitmap_copy_le);
>  #endif
> 
> +unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
> +{
> +       return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long), flags);
> +}
> +EXPORT_SYMBOL(bitmap_alloc);
> +
> +unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
> +{
> +       return bitmap_alloc(nbits, flags | __GFP_ZERO);
> +}
> +EXPORT_SYMBOL(bitmap_zalloc);
> +
> +void bitmap_free(const unsigned long *bitmap)
> +{
> +       kfree(bitmap);
> +}
> +EXPORT_SYMBOL(bitmap_free);
> +
>  #if BITS_PER_LONG == 64
>  /**
>   * bitmap_from_arr32 - copy the contents of u32 array of bits to bitmap
> --
> 2.17.1
