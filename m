From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/7] mm/vmalloc: export __vmalloc_node_flags
Date: Fri, 3 Jul 2015 16:58:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507031658120.28837@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Export the function __vmalloc_node_flags.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-4.1/include/linux/vmalloc.h
===================================================================
--- linux-4.1.orig/include/linux/vmalloc.h	2015-07-02 19:19:43.000000000 +0200
+++ linux-4.1/include/linux/vmalloc.h	2015-07-02 19:20:59.000000000 +0200
@@ -75,6 +75,7 @@ extern void *vmalloc_exec(unsigned long 
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
 extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
+void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
 extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
 			pgprot_t prot, unsigned long vm_flags, int node,
Index: linux-4.1/mm/vmalloc.c
===================================================================
--- linux-4.1.orig/mm/vmalloc.c	2015-07-02 19:19:13.000000000 +0200
+++ linux-4.1/mm/vmalloc.c	2015-07-02 19:21:00.000000000 +0200
@@ -1722,12 +1722,12 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
-static inline void *__vmalloc_node_flags(unsigned long size,
-					int node, gfp_t flags)
+void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags)
 {
 	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
 					node, __builtin_return_address(0));
 }
+EXPORT_SYMBOL(__vmalloc_node_flags);
 
 /**
  *	vmalloc  -  allocate virtually contiguous memory
