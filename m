From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm-writecache
Date: Tue, 13 Feb 2018 17:00:32 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1802131648030.31130@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA9_cmcRe8KXO+jWy8knqg4EMCgBYF1JAdgR=A2qHkVES+i9ZA@mail.gmail.com>
	<alpine.LRH.2.02.1711272238130.9280@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4jTuSLDiO1TZhCrJGxMWiWK-KNXKPf-DZH1xDeXVAaUgQ@mail.gmail.com>
	<alpine.LRH.2.02.1712050003070.13380@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4i=XfG-pQYHKLKvwP_SeMxc+PaWOJYSGQ0rsbJ=9GC6iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPcyv4i=XfG-pQYHKLKvwP_SeMxc+PaWOJYSGQ0rsbJ=9GC6iQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids



On Fri, 8 Dec 2017, Dan Williams wrote:

> > > > when we write to
> > > > persistent memory using cached write instructions and use dax_flush
> > > > afterwards to flush cache for the affected range, the performance is about
> > > > 350MB/s. It is practically unusable - worse than low-end SSDs.
> > > >
> > > > On the other hand, the movnti instruction can sustain performance of one
> > > > 8-byte write per clock cycle. We don't have to flush cache afterwards, the
> > > > only thing that must be done is to flush the write-combining buffer with
> > > > the sfence instruction. Movnti has much better throughput than dax_flush.
> > >
> > > What about memcpy_flushcache?
> >
> > but
> >
> > - using memcpy_flushcache is overkill if we need just one or two 8-byte
> > writes to the metadata area. Why not use movnti directly?
> >
> 
> The driver performs so many 8-byte moves that the cost of the
> memcpy_flushcache() function call significantly eats into your
> performance?

I've measured it on Skylake i7-6700 - and the dm-writecache driver has 2% 
lower throughput when it uses memcpy_flushcache() to update it metadata 
instead of explicitly coded "movnti" instructions.

I've created this patch - it doesn't change API in any way, but it 
optimizes memcpy_flushcache for 4, 8 and 16-byte writes (that is what my 
driver mostly uses). With this patch, I can remove the explicit "asm" 
statements from my driver. Would you consider commiting this patch to the 
kernel?

Mikulas




x86: optimize memcpy_flushcache

I use memcpy_flushcache in my persistent memory driver for metadata
updates and it turns out that the overhead of memcpy_flushcache causes 2%
performance degradation compared to "movnti" instruction explicitly coded
using inline assembler.

This patch recognizes memcpy_flushcache calls with constant short length
and turns them into inline assembler - so that I don't have to use inline
assembler in the driver.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/x86/include/asm/string_64.h |   20 +++++++++++++++++++-
 arch/x86/lib/usercopy_64.c       |    6 +++---
 2 files changed, 22 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/include/asm/string_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/string_64.h	2018-01-31 11:06:19.953577699 -0500
+++ linux-2.6/arch/x86/include/asm/string_64.h	2018-02-13 12:31:06.506810497 -0500
@@ -147,7 +147,25 @@ memcpy_mcsafe(void *dst, const void *src
 
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
--- linux-2.6.orig/arch/x86/lib/usercopy_64.c	2018-01-31 11:06:19.988577678 -0500
+++ linux-2.6/arch/x86/lib/usercopy_64.c	2018-02-13 11:56:40.249154414 -0500
@@ -133,7 +133,7 @@ long __copy_user_flushcache(void *dst, c
 	return rc;
 }
 
-void memcpy_flushcache(void *_dst, const void *_src, size_t size)
+void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 {
 	unsigned long dest = (unsigned long) _dst;
 	unsigned long source = (unsigned long) _src;
@@ -196,14 +196,14 @@ void memcpy_flushcache(void *_dst, const
 		clean_cache_range((void *) dest, size);
 	}
 }
-EXPORT_SYMBOL_GPL(memcpy_flushcache);
+EXPORT_SYMBOL_GPL(__memcpy_flushcache);
 
 void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
 		size_t len)
 {
 	char *from = kmap_atomic(page);
 
-	memcpy_flushcache(to, from + offset, len);
+	__memcpy_flushcache(to, from + offset, len);
 	kunmap_atomic(from);
 }
 #endif
