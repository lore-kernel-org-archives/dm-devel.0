From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] x86: introduce memcpy_flushcache_clflushopt
Date: Fri, 17 Apr 2020 10:57:59 -0700
Message-ID: <CAPcyv4jjJ_SZuAjdhdQKGWh6qiP1O4kFyzP9BcBgbb2oanc=yQ@mail.gmail.com>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4goJ2jbXNVZbMUKtRUominhuMhuTKrMh=fnhrfvC4jyjw@mail.gmail.com>
 <alpine.LRH.2.02.2004081439080.13932@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4grNHvyYEc4W6PkymhEJvLb17tXbC3JZdqvtFxmMZ8DCQ@mail.gmail.com>
 <alpine.LRH.2.02.2004090612320.27517@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2004160411460.7833@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gpe8u=zNrRhvd9ioVNGbOJfRUXzFZuV--be6Hbj0xXtQ@mail.gmail.com> <alpine.LRH.2.02.2004170831530.16047@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2004170831530.16047@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 17, 2020 at 5:47 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Thu, 16 Apr 2020, Dan Williams wrote:
>
> > On Thu, Apr 16, 2020 at 1:24 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
> > >
> > >
> > >
> > > On Thu, 9 Apr 2020, Mikulas Patocka wrote:
> > >
> > > > With dm-writecache on emulated pmem (with the memmap argument), we get
> > > >
> > > > With the original kernel:
> > > > 8508 - 11378
> > > > real    0m4.960s
> > > > user    0m0.638s
> > > > sys     0m4.312s
> > > >
> > > > With dm-writecache hacked to use cached writes + clflushopt:
> > > > 8505 - 11378
> > > > real    0m4.151s
> > > > user    0m0.560s
> > > > sys     0m3.582s
> > >
> > > I did some multithreaded tests:
> > > http://people.redhat.com/~mpatocka/testcases/pmem/microbenchmarks/pmem-multithreaded.txt
> > >
> > > And it turns out that for singlethreaded access, write+clwb performs
> > > better, while for multithreaded access, non-temporal stores perform
> > > better.
> > >
> > > 1       sequential write-nt 8 bytes             1.3 GB/s
> > > 2       sequential write-nt 8 bytes             2.5 GB/s
> > > 3       sequential write-nt 8 bytes             2.8 GB/s
> > > 4       sequential write-nt 8 bytes             2.8 GB/s
> > > 5       sequential write-nt 8 bytes             2.5 GB/s
> > >
> > > 1       sequential write 8 bytes + clwb         1.6 GB/s
> > > 2       sequential write 8 bytes + clwb         2.4 GB/s
> > > 3       sequential write 8 bytes + clwb         1.7 GB/s
> > > 4       sequential write 8 bytes + clwb         1.2 GB/s
> > > 5       sequential write 8 bytes + clwb         0.8 GB/s
> > >
> > > For one thread, we can see that write-nt 8 bytes has 1.3 GB/s and write
> > > 8+clwb has 1.6 GB/s, but for multiple threads, write-nt has better
> > > throughput.
> > >
> > > The dm-writecache target is singlethreaded (all the copying is done while
> > > holding the writecache lock), so it benefits from clwb.
> > >
> > > Should memcpy_flushcache be changed to write+clwb? Or are there some
> > > multithreaded users of memcpy_flushcache that would be hurt by this
> > > change?
> >
> > Maybe this is asking for a specific memcpy_flushcache_inatomic()
> > implementation for your use case, but leave nt-writes for the general
> > case?
>
> Yes - I have created this patch that adds a new function
> memcpy_flushcache_clflushopt and makes dm-writecache use it.
>
> Mikulas
>
>
>
> From: Mikulas Patocka <mpatocka@redhat.com>
>
> Implement the function memcpy_flushcache_clflushopt which flushes cache
> just like memcpy_flushcache - except that it uses cached writes and
> explicit cache flushing instead of non-temporal stores.
>
> Explicit cache flushing performs better in some cases (i.e. the
> dm-writecache target with block size greater than 512), non-temporal
> stores perform better in other cases (mostly multithreaded workloads) - so
> we provide these two functions and the user should select which one is
> faster for his particular workload.
>
> dm-writecache througput (on real Optane-based persistent memory):
> block size      512             1024            2048            4096
> movnti          496 MB/s        642 MB/s        725 MB/s        744 MB/s
> clflushopt      373 MB/s        688 MB/s        1.1 GB/s        1.2 GB/s
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  arch/x86/include/asm/string_64.h |   10 ++++++++++
>  arch/x86/lib/usercopy_64.c       |   32 ++++++++++++++++++++++++++++++++
>  drivers/md/dm-writecache.c       |    5 ++++-
>  include/linux/string.h           |    6 ++++++
>  4 files changed, 52 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/arch/x86/include/asm/string_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/string_64.h     2020-04-17 14:06:35.139999000 +0200
> +++ linux-2.6/arch/x86/include/asm/string_64.h  2020-04-17 14:06:35.129999000 +0200
> @@ -114,6 +114,14 @@ memcpy_mcsafe(void *dst, const void *src
>         return 0;
>  }
>
> +/*
> + * In some cases (mostly single-threaded workload), clflushopt is faster
> + * than non-temporal stores. In other situations, non-temporal stores are
> + * faster. So, we provide two functions:
> + *     memcpy_flushcache using non-temporal stores
> + *     memcpy_flushcache_clflushopt using clflushopt
> + * The caller should test which one is faster for the particular workload.
> + */
>  #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>  #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
>  void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
> @@ -135,6 +143,8 @@ static __always_inline void memcpy_flush
>         }
>         __memcpy_flushcache(dst, src, cnt);
>  }
> +#define __HAVE_ARCH_MEMCPY_FLUSHCACHE_CLFLUSHOPT 1
> +void memcpy_flushcache_clflushopt(void *dst, const void *src, size_t cnt);

This naming promotes an x86ism and it does not help the caller
understand why 'flushcache_clflushopt' is preferred over 'flushcache'.
The goal of naming it _inatomic() was specifically for the observation
that your driver coordinates atomic access and does not benefit from
the cache friendliness that non-temporal stores afford. That said
_inatomic() is arguably not a good choice either because that refers
to whether the copy is prepared to take a fault or not. What about
_exclusive() or _single()? Anything but _clflushopt() that conveys no
contextual information.

Other than quibbling with the name, and one more comment below, this
looks ok to me.

>  #endif
>
>  #endif /* __KERNEL__ */
> Index: linux-2.6/include/linux/string.h
> ===================================================================
> --- linux-2.6.orig/include/linux/string.h       2020-04-17 14:06:35.139999000 +0200
> +++ linux-2.6/include/linux/string.h    2020-04-17 14:06:35.129999000 +0200
> @@ -175,6 +175,12 @@ static inline void memcpy_flushcache(voi
>         memcpy(dst, src, cnt);
>  }
>  #endif
> +#ifndef __HAVE_ARCH_MEMCPY_FLUSHCACHE_CLFLUSHOPT
> +static inline void memcpy_flushcache_clflushopt(void *dst, const void *src, size_t cnt)
> +{
> +       memcpy_flushcache(dst, src, cnt);
> +}
> +#endif
>  void *memchr_inv(const void *s, int c, size_t n);
>  char *strreplace(char *s, char old, char new);
>
> Index: linux-2.6/arch/x86/lib/usercopy_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/usercopy_64.c   2020-04-17 14:06:35.139999000 +0200
> +++ linux-2.6/arch/x86/lib/usercopy_64.c        2020-04-17 14:25:18.569999000 +0200
> @@ -199,6 +199,38 @@ void __memcpy_flushcache(void *_dst, con
>  }
>  EXPORT_SYMBOL_GPL(__memcpy_flushcache);
>
> +void memcpy_flushcache_clflushopt(void *_dst, const void *_src, size_t size)
> +{
> +       unsigned long dest = (unsigned long) _dst;
> +       unsigned long source = (unsigned long) _src;
> +
> +       if (static_cpu_has(X86_FEATURE_CLFLUSHOPT) && likely(boot_cpu_data.x86_clflush_size == 64)) {
> +               if (unlikely(!IS_ALIGNED(dest, 64))) {
> +                       size_t len = min_t(size_t, size, ALIGN(dest, 64) - dest);
> +
> +                       memcpy((void *) dest, (void *) source, len);
> +                       clflushopt((void *)dest);
> +                       dest += len;
> +                       source += len;
> +                       size -= len;
> +               }
> +               while (size >= 64) {
> +                       memcpy((void *)dest, (void *)source, 64);
> +                       clflushopt((void *)dest);
> +                       dest += 64;
> +                       source += 64;
> +                       size -= 64;
> +               }
> +               if (unlikely(size != 0)) {
> +                       memcpy((void *)dest, (void *)source, size);
> +                       clflushopt((void *)dest);
> +               }
> +               return;
> +       }
> +       memcpy_flushcache((void *)dest, (void *)source, size);
> +}
> +EXPORT_SYMBOL_GPL(memcpy_flushcache_clflushopt);
> +
>  void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
>                 size_t len)
>  {
> Index: linux-2.6/drivers/md/dm-writecache.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-writecache.c   2020-04-17 14:06:35.139999000 +0200
> +++ linux-2.6/drivers/md/dm-writecache.c        2020-04-17 14:06:35.129999000 +0200
> @@ -1166,7 +1166,10 @@ static void bio_copy_block(struct dm_wri
>                         }
>                 } else {
>                         flush_dcache_page(bio_page(bio));
> -                       memcpy_flushcache(data, buf, size);
> +                       if (likely(size > 512))

This needs some reference to how this magic number is chosen and how a
future developer might determine whether the value needs to be
adjusted.

Will also need to remember to come back and re-evaluate this once
memcpy_flushcache() is enabled to use movdir64b which might invalidate
the performance advantage you are currently seeing with
cache-allocating-writes plus flushing.

> +                               memcpy_flushcache_clflushopt(data, buf, size);
> +                       else
> +                               memcpy_flushcache(data, buf, size);
>                 }
>
>                 bvec_kunmap_irq(buf, &flags);
>
