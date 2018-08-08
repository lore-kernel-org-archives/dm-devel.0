From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v3 RESEND] x86: optimize memcpy_flushcache
Date: Wed, 8 Aug 2018 17:22:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1808081720460.24747@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm> <20180519052631.730455475@debian.vm> <CAPcyv4jpY0x7kZtT+afAKnHKy8Uy1AC_N_QM7RrELSj_0iNrRw@mail.gmail.com> <20180524182013.GA59755@redhat.com> <20180618132306.GA25431@redhat.com> <20180621143140.GA14095@gmail.com>
 <alpine.LRH.2.02.1806211224470.19940@file01.intranet.prod.int.rdu2.redhat.com> <20180622013049.GA12505@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180622013049.GA12505@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, device-mapper development <dm-devel@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Fri, 22 Jun 2018, Ingo Molnar wrote:

> 
> * Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Thu, 21 Jun 2018, Ingo Molnar wrote:
> > 
> > > 
> > > * Mike Snitzer <snitzer@redhat.com> wrote:
> > > 
> > > > From: Mikulas Patocka <mpatocka@redhat.com>
> > > > Subject: [PATCH v2] x86: optimize memcpy_flushcache
> > > > 
> > > > In the context of constant short length stores to persistent memory,
> > > > memcpy_flushcache suffers from a 2% performance degradation compared to
> > > > explicitly using the "movnti" instruction.
> > > > 
> > > > Optimize 4, 8, and 16 byte memcpy_flushcache calls to explicitly use the
> > > > movnti instruction with inline assembler.
> > > 
> > > Linus requested asm optimizations to include actual benchmarks, so it would be 
> > > nice to describe how this was tested, on what hardware, and what the before/after 
> > > numbers are.
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > 
> > It was tested on 4-core skylake machine with persistent memory being 
> > emulated using the memmap kernel option. The dm-writecache target used the 
> > emulated persistent memory as a cache and sata SSD as a backing device. 
> > The patch results in 2% improved throughput when writing data using dd.
> > 
> > I don't have access to the machine anymore.
> 
> I think this information is enough, but do we know how well memmap emulation 
> represents true persistent memory speed and cache management characteristics?
> It might be representative - but I don't know for sure, nor probably most
> readers of the changelog.
> 
> So could you please put all this into an updated changelog, and also add a short 
> description that outlines exactly which codepaths end up using this method in a 
> typical persistent memory setup? All filesystem ops - or only reads, etc?
> 
> Thanks,
> 
> 	Ingo

Here I resend it:


From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] x86: optimize memcpy_flushcache

I use memcpy_flushcache in my persistent memory driver for metadata
updates, there are many 8-byte and 16-byte updates and it turns out that
the overhead of memcpy_flushcache causes 2% performance degradation
compared to "movnti" instruction explicitly coded using inline assembler.

The tests were done on a Skylake processor with persistent memory emulated
using the "memmap" kernel parameter. dd was used to copy data to the
dm-writecache target.

This patch recognizes memcpy_flushcache calls with constant short length
and turns them into inline assembler - so that I don't have to use inline
assembler in the driver.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/x86/include/asm/string_64.h |   20 +++++++++++++++++++-
 arch/x86/lib/usercopy_64.c       |    4 ++--
 2 files changed, 21 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/string_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/string_64.h
+++ linux-2.6/arch/x86/include/asm/string_64.h
@@ -149,7 +149,25 @@ memcpy_mcsafe(void *dst, const void *src
 
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
-void memcpy_flushcache(void *dst, const void *src, size_t cnt);
+void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
+static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+{
+	if (__builtin_constant_p(cnt)) {
+		switch (cnt) {
+			case 4:
+				asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
+				return;
+			case 8:
+				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
+				return;
+			case 16:
+				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
+				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
+				return;
+		}
+	}
+	__memcpy_flushcache(dst, src, cnt);
+}
 #endif
 
 #endif /* __KERNEL__ */
Index: linux-2.6/arch/x86/lib/usercopy_64.c
===================================================================
--- linux-2.6.orig/arch/x86/lib/usercopy_64.c
+++ linux-2.6/arch/x86/lib/usercopy_64.c
@@ -153,7 +153,7 @@ long __copy_user_flushcache(void *dst, c
 	return rc;
 }
 
-void memcpy_flushcache(void *_dst, const void *_src, size_t size)
+void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 {
 	unsigned long dest = (unsigned long) _dst;
 	unsigned long source = (unsigned long) _src;
@@ -216,7 +216,7 @@ void memcpy_flushcache(void *_dst, const
 		clean_cache_range((void *) dest, size);
 	}
 }
-EXPORT_SYMBOL_GPL(memcpy_flushcache);
+EXPORT_SYMBOL_GPL(__memcpy_flushcache);
 
 void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
 		size_t len)
