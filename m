From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: optimize memcpy_flushcache
Date: Mon, 18 Jun 2018 09:38:19 -0700
Message-ID: <CAPcyv4i_xqo1AgF7znUYi+Eo_obTBYA5vMv7=Q0VP755Kmm9bg@mail.gmail.com>
References: <alpine.LRH.2.02.1806180846300.22626@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1806180846300.22626-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Jun 18, 2018 at 5:50 AM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Mike
>
> Could you please push this patch to the kernel 4.18-rc? Dan Williams said
> that he will submit it, but he forgot about it.

...to be clear I acked it and asked Ingo to take it. Will need a
resubmit for 4.19.

Ingo, see below for a patch to pick up into -tip when you have a chance.

>
> Without this patch, dm-writecache is suffering 2% penalty because of
> memcpy_flushcache overhead.
>
> Mikulas
>
>
>
> From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> I use memcpy_flushcache in my persistent memory driver for metadata
> updates and it turns out that the overhead of memcpy_flushcache causes 2%
> performance degradation compared to "movnti" instruction explicitly coded
> using inline assembler.
>
> This patch recognizes memcpy_flushcache calls with constant short length
> and turns them into inline assembler - so that I don't have to use inline
> assembler in the driver.
>
> Signed-off-by: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> ---
>  arch/x86/include/asm/string_64.h |   20 +++++++++++++++++++-
>  arch/x86/lib/usercopy_64.c       |    4 ++--
>  2 files changed, 21 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/arch/x86/include/asm/string_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/string_64.h
> +++ linux-2.6/arch/x86/include/asm/string_64.h
> @@ -149,7 +149,25 @@ memcpy_mcsafe(void *dst, const void *src
>
>  #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
>  #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
> -void memcpy_flushcache(void *dst, const void *src, size_t cnt);
> +void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
> +static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
> +{
> +       if (__builtin_constant_p(cnt)) {
> +               switch (cnt) {
> +                       case 4:
> +                               asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
> +                               return;
> +                       case 8:
> +                               asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
> +                               return;
> +                       case 16:
> +                               asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
> +                               asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
> +                               return;
> +               }
> +       }
> +       __memcpy_flushcache(dst, src, cnt);
> +}
>  #endif
>
>  #endif /* __KERNEL__ */
> Index: linux-2.6/arch/x86/lib/usercopy_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/usercopy_64.c
> +++ linux-2.6/arch/x86/lib/usercopy_64.c
> @@ -153,7 +153,7 @@ long __copy_user_flushcache(void *dst, c
>         return rc;
>  }
>
> -void memcpy_flushcache(void *_dst, const void *_src, size_t size)
> +void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
>  {
>         unsigned long dest = (unsigned long) _dst;
>         unsigned long source = (unsigned long) _src;
> @@ -216,7 +216,7 @@ void memcpy_flushcache(void *_dst, const
>                 clean_cache_range((void *) dest, size);
>         }
>  }
> -EXPORT_SYMBOL_GPL(memcpy_flushcache);
> +EXPORT_SYMBOL_GPL(__memcpy_flushcache);
>
>  void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
>                 size_t len)
