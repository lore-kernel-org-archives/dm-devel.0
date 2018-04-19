From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm bufio: fix buffer alignment
Date: Thu, 19 Apr 2018 08:33:00 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804190829150.22847@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The patch 6b5e718cc138 ("dm bufio: relax alignment constraint on slab
cache") relaxed alignment on dm-bufio cache, however it may break dm-crypt
or dm-integrity.

dm-crypt and dm-integrity require that the size of bio vector entries
(bv_len) is aligned on its sector size. bv_offset doesn't have to be
aligned, but bv_len must be. XFS sends unaligned bios, but they do not
cross page boundary, so the requirement for aligned bv_len is met.

The patch 6b5e718cc138 made dm-bufio send unaligned bios that cross page
boundary, this could break dm-crypt and dm-integrity.

This patch reinstates the alignment. Note that misaligned entries only
happen when we use slab/slub debugging. Without debugging, the entries are
always aligned.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 6b5e718cc138 ("dm bufio: relax alignment constraint on slab cache")

---
 drivers/md/dm-bufio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-04-17 19:59:49.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2018-04-19 14:31:10.000000000 +0200
@@ -1681,8 +1681,9 @@ struct dm_bufio_client *dm_bufio_client_
 
 	if (block_size <= KMALLOC_MAX_SIZE &&
 	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
-		snprintf(slab_name, sizeof slab_name, "dm_bufio_cache-%u", c->block_size);
-		c->slab_cache = kmem_cache_create(slab_name, c->block_size, ARCH_KMALLOC_MINALIGN,
+		unsigned align = min(1U << __ffs(block_size), (unsigned)PAGE_SIZE);
+		snprintf(slab_name, sizeof slab_name, "dm_bufio_cache-%u", block_size);
+		c->slab_cache = kmem_cache_create(slab_name, block_size, align,
 						  SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
 			r = -ENOMEM;
