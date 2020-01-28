From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH v4 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and bitmap_free()
Date: Tue, 28 Jan 2020 17:08:27 +0530
Message-ID: <CA+G9fYs3GPid5fcHEWp2i9NKR1hQGc5h0zKaUK5xr1RGJ83xLg@mail.gmail.com>
References: <20180630201750.2588-1-andriy.shevchenko@linux.intel.com> <20180630201750.2588-4-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <20180630201750.2588-4-andriy.shevchenko@linux.intel.com>
Sender: linux-input-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yury Norov <ynorov@caviumnetworks.com>, open list <linux-kernel@vger.kernel.org>, mika.westerberg@linux.intel.com, Joe Perches <joe@perches.com>, linux- stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
List-Id: dm-devel.ids

On Sun, 1 Jul 2018 at 01:49, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> A lot of code become ugly because of open coding allocations for bitmaps.
>
> Introduce three helpers to allow users be more clear of intention
> and keep their code neat.
>
> Note, due to multiple circular dependencies we may not provide
> the helpers as inliners. For now we keep them exported and, perhaps,
> at some point in the future we will sort out header inclusion and
> inheritance.
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

stable-rc 4.14 build failed due to these build error,

lib/bitmap.c: In function 'bitmap_from_u32array':
lib/bitmap.c:1133:1: warning: ISO C90 forbids mixed declarations and
code [-Wdeclaration-after-statement]
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
 ^~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1138:15: error: non-static declaration of 'bitmap_alloc'
follows static declaration
 EXPORT_SYMBOL(bitmap_alloc);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1138:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_alloc);
 ^~~~~~~~~~~~~
lib/bitmap.c:1133:16: note: previous definition of 'bitmap_alloc' was here
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
                ^~~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1144:15: error: non-static declaration of 'bitmap_zalloc'
follows static declaration
 EXPORT_SYMBOL(bitmap_zalloc);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1144:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_zalloc);
 ^~~~~~~~~~~~~
lib/bitmap.c:1140:16: note: previous definition of 'bitmap_zalloc' was here
 unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
                ^~~~~~~~~~~~~
In file included from
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-corei7-64/kernel-source/lib/bitmap.c:8:0:
lib/bitmap.c:1150:15: error: non-static declaration of 'bitmap_free'
follows static declaration
 EXPORT_SYMBOL(bitmap_free);
               ^
include/linux/export.h:65:21: note: in definition of macro '___EXPORT_SYMBOL'
  extern typeof(sym) sym;      \
                     ^~~
lib/bitmap.c:1150:1: note: in expansion of macro 'EXPORT_SYMBOL'
 EXPORT_SYMBOL(bitmap_free);
 ^~~~~~~~~~~~~
lib/bitmap.c:1146:6: note: previous definition of 'bitmap_free' was here
 void bitmap_free(const unsigned long *bitmap)
      ^~~~~~~~~~~
  CC      drivers/char/random.o
scripts/Makefile.build:326: recipe for target 'lib/bitmap.o' failed
make[3]: *** [lib/bitmap.o] Error 1
Makefile:1052: recipe for target 'lib' failed
make[2]: *** [lib] Error 2
