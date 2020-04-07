From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] memcpy_flushcache: use cache flusing for larger lengths
Date: Tue, 7 Apr 2020 11:01:33 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

[ resending this to x86 maintainers ]

Hi

I tested performance of various methods how to write to optane-based 
persistent memory, and found out that non-temporal stores achieve 
throughput 1.3 GB/s. 8 cached stores immediatelly followed by clflushopt 
or clwb achieve throughput 1.6 GB/s.

memcpy_flushcache uses non-temporal stores, I modified it to use cached 
stores + clflushopt and it improved performance of the dm-writecache 
target significantly:

dm-writecache throughput:
(dd if=/dev/zero of=/dev/mapper/wc bs=64k oflag=direct)
writecache block size   512             1024            2048            4096
movnti                  496 MB/s        642 MB/s        725 MB/s        744 MB/s
clflushopt              373 MB/s        688 MB/s        1.1 GB/s        1.2 GB/s

For block size 512, movnti works better, for larger block sizes, 
clflushopt is better.

I was also testing the novafs filesystem, it is not upstream, but it 
benefitted from similar change in __memcpy_flushcache and 
__copy_user_nocache:
write throughput on big files - movnti: 662 MB/s, clwb: 1323 MB/s
write throughput on small files - movnti: 621 MB/s, clwb: 1013 MB/s


I submit this patch for __memcpy_flushcache that improves dm-writecache 
performance.

Other ideas - should we introduce memcpy_to_pmem instead of modifying 
memcpy_flushcache and move this logic there? Or should I modify the 
dm-writecache target directly to use clflushopt with no change to the 
architecture-specific code?

Mikulas




From: Mikulas Patocka <mpatocka@redhat.com>

I tested dm-writecache performance on a machine with Optane nvdimm and it
turned out that for larger writes, cached stores + cache flushing perform
better than non-temporal stores. This is the throughput of dm-writecache
measured with this command:
dd if=/dev/zero of=/dev/mapper/wc bs=64 oflag=direct

block size	512		1024		2048		4096
movnti		496 MB/s	642 MB/s	725 MB/s	744 MB/s
clflushopt	373 MB/s	688 MB/s	1.1 GB/s	1.2 GB/s

We can see that for smaller block, movnti performs better, but for larger
blocks, clflushopt has better performance.

This patch changes the function __memcpy_flushcache accordingly, so that
with size >= 768 it performs cached stores and cache flushing. Note that
we must not use the new branch if the CPU doesn't have clflushopt - in
that case, the kernel would use inefficient "clflush" instruction that has
very bad performance.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/x86/lib/usercopy_64.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux-2.6/arch/x86/lib/usercopy_64.c
===================================================================
--- linux-2.6.orig/arch/x86/lib/usercopy_64.c	2020-03-24 15:15:36.644945091 -0400
+++ linux-2.6/arch/x86/lib/usercopy_64.c	2020-03-30 07:17:51.450290007 -0400
@@ -152,6 +152,42 @@ void __memcpy_flushcache(void *_dst, con
 			return;
 	}
 
+	if (static_cpu_has(X86_FEATURE_CLFLUSHOPT) && size >= 768 && likely(boot_cpu_data.x86_clflush_size == 64)) {
+		while (!IS_ALIGNED(dest, 64)) {
+			asm("movq    (%0), %%r8\n"
+			    "movnti  %%r8,   (%1)\n"
+			    :: "r" (source), "r" (dest)
+			    : "memory", "r8");
+			dest += 8;
+			source += 8;
+			size -= 8;
+		}
+		do {
+			asm("movq    (%0), %%r8\n"
+			    "movq   8(%0), %%r9\n"
+			    "movq  16(%0), %%r10\n"
+			    "movq  24(%0), %%r11\n"
+			    "movq    %%r8,   (%1)\n"
+			    "movq    %%r9,  8(%1)\n"
+			    "movq   %%r10, 16(%1)\n"
+			    "movq   %%r11, 24(%1)\n"
+			    "movq  32(%0), %%r8\n"
+			    "movq  40(%0), %%r9\n"
+			    "movq  48(%0), %%r10\n"
+			    "movq  56(%0), %%r11\n"
+			    "movq    %%r8, 32(%1)\n"
+			    "movq    %%r9, 40(%1)\n"
+			    "movq   %%r10, 48(%1)\n"
+			    "movq   %%r11, 56(%1)\n"
+			    :: "r" (source), "r" (dest)
+			    : "memory", "r8", "r9", "r10", "r11");
+			clflushopt((void *)dest);
+			dest += 64;
+			source += 64;
+			size -= 64;
+		} while (size >= 64);
+	}
+
 	/* 4x8 movnti loop */
 	while (size >= 32) {
 		asm("movq    (%0), %%r8\n"
