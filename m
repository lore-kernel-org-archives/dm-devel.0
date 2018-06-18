From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 RESEND] x86: optimize memcpy_flushcache
Date: Mon, 18 Jun 2018 09:23:07 -0400
Message-ID: <20180618132306.GA25431@redhat.com>
References: <20180519052503.325953342@debian.vm>
	<20180519052631.730455475@debian.vm>
	<CAPcyv4jpY0x7kZtT+afAKnHKy8Uy1AC_N_QM7RrELSj_0iNrRw@mail.gmail.com>
	<20180524182013.GA59755@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180524182013.GA59755@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>, X86 ML <x86@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2] x86: optimize memcpy_flushcache

In the context of constant short length stores to persistent memory,
memcpy_flushcache suffers from a 2% performance degradation compared to
explicitly using the "movnti" instruction.

Optimize 4, 8, and 16 byte memcpy_flushcache calls to explicitly use the
movnti instruction with inline assembler.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 arch/x86/include/asm/string_64.h | 28 +++++++++++++++++++++++++++-
 arch/x86/lib/usercopy_64.c       |  4 ++--
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 533f74c300c2..aaba83478cdc 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -147,7 +147,33 @@ memcpy_mcsafe(void *dst, const void *src, size_t cnt)
 
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
-void memcpy_flushcache(void *dst, const void *src, size_t cnt);
+void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
+static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+{
+	if (__builtin_constant_p(cnt)) {
+		switch (cnt) {
+		case 4:
+			asm volatile("movntil %1, %0"
+				     : "=m" (*(u32 *)dst)
+				     : "r" (*(u32 *)src));
+			return;
+		case 8:
+			asm volatile("movntiq %1, %0"
+				     : "=m" (*(u64 *)dst)
+				     : "r" (*(u64 *)src));
+			return;
+		case 16:
+			asm volatile("movntiq %1, %0"
+				     : "=m" (*(u64 *)dst)
+				     : "r" (*(u64 *)src));
+			asm volatile("movntiq %1, %0"
+				     : "=m" (*(u64 *)(dst + 8))
+				     : "r" (*(u64 *)(src + 8)));
+			return;
+		}
+	}
+	__memcpy_flushcache(dst, src, cnt);
+}
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 75d3776123cc..26f515aa3529 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -133,7 +133,7 @@ long __copy_user_flushcache(void *dst, const void __user *src, unsigned size)
 	return rc;
 }
 
-void memcpy_flushcache(void *_dst, const void *_src, size_t size)
+void __memcpy_flushcache(void *_dst, const void *_src, size_t size)
 {
 	unsigned long dest = (unsigned long) _dst;
 	unsigned long source = (unsigned long) _src;
@@ -196,7 +196,7 @@ void memcpy_flushcache(void *_dst, const void *_src, size_t size)
 		clean_cache_range((void *) dest, size);
 	}
 }
-EXPORT_SYMBOL_GPL(memcpy_flushcache);
+EXPORT_SYMBOL_GPL(__memcpy_flushcache);
 
 void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
 		size_t len)
-- 
2.15.0
