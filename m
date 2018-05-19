From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 1/4] x86: optimize memcpy_flushcache
Date: Sat, 19 May 2018 07:25:04 +0200
Message-ID: <20180519052631.730455475@debian.vm>
References: <20180519052503.325953342@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=memcpy_flushcache-optimization.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

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
 arch/x86/lib/usercopy_64.c       |    4 ++--
 2 files changed, 21 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/string_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/string_64.h	2018-05-18 21:21:15.000000000 +0200
+++ linux-2.6/arch/x86/include/asm/string_64.h	2018-05-18 21:21:15.000000000 +0200
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
--- linux-2.6.orig/arch/x86/lib/usercopy_64.c	2018-05-18 21:21:15.000000000 +0200
+++ linux-2.6/arch/x86/lib/usercopy_64.c	2018-05-18 22:09:49.000000000 +0200
@@ -133,7 +133,7 @@ long __copy_user_flushcache(void *dst, c
 	return rc;
 }
 
-void memcpy_flushcache(void *_dst, const void *_src, size_t size)
+void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 {
 	unsigned long dest = (unsigned long) _dst;
 	unsigned long source = (unsigned long) _src;
@@ -196,7 +196,7 @@ void memcpy_flushcache(void *_dst, const
 		clean_cache_range((void *) dest, size);
 	}
 }
-EXPORT_SYMBOL_GPL(memcpy_flushcache);
+EXPORT_SYMBOL_GPL(__memcpy_flushcache);
 
 void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
 		size_t len)
