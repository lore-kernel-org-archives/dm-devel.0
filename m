From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] slab_common: fix the check for duplicate slab names
Date: Tue, 4 Mar 2014 17:13:47 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1403041711300.29476@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Lameter <cl@linux.com>
Cc: Jonathan Brassow <jbrassow@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com
List-Id: dm-devel.ids

The patch 3e374919b314f20e2a04f641ebc1093d758f66a4 is supposed to fix the
problem where kmem_cache_create incorrectly reports duplicate cache name
and fails. The problem is described in the header of that patch.

However, the patch doesn't really fix the problem because of these
reasons:

* the logic to test for debugging is reversed. It was intended to perform
  the check only if slub debugging is enabled (which implies that caches
  with the same parameters are not merged). Therefore, there should be
  #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_DEBUG_ON)
  The current code has the condition reversed and performs the test if
  debugging is disabled.

* slub debugging may be enabled or disabled based on kernel command line,
  CONFIG_SLUB_DEBUG_ON is just the default settings. Therefore the test
  based on definition of CONFIG_SLUB_DEBUG_ON is unreliable.

This patch fixes the problem by removing the test
"!defined(CONFIG_SLUB_DEBUG_ON)". Therefore, duplicate names are never
checked if the SLUB allocator is used.

Note to stable kernel maintainers: when backporint this patch, please
backport also the patch 3e374919b314f20e2a04f641ebc1093d758f66a4.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 3.6+

---
 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.14-rc5/mm/slab_common.c
===================================================================
--- linux-3.14-rc5.orig/mm/slab_common.c	2014-03-04 22:47:02.000000000 +0100
+++ linux-3.14-rc5/mm/slab_common.c	2014-03-04 22:47:08.000000000 +0100
@@ -56,7 +56,7 @@ static int kmem_cache_sanity_check(struc
 			continue;
 		}
 
-#if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
+#if !defined(CONFIG_SLUB)
 		/*
 		 * For simplicity, we won't check this in the list of memcg
 		 * caches. We have control over memcg naming, and if there

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
