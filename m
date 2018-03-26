From: mpatocka@redhat.com
Subject: [patch 2/8] dm-bufio: get rid of slab cache name
	allocations
Date: Mon, 26 Mar 2018 20:29:41 +0200
Message-ID: <20180326183053.714786438@debian.vm>
References: <20180326182939.169591126@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-bufio-remove-name-allocations.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com, msnitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-bufio keeps the array dm_bufio_cache_names that holds names of the slab
caches.

Since the commit db265eca7700 ("mm/sl[aou]b: Move duping of slab name to
slab_common.c"), the kernel automatically duplicates the slab cache name
when creating the slab cache, so we no longer have to keep the name
allocated.

This patch removes the code that allocates the slab names and keeps them
around.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-03-13 16:41:15.637954000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2018-03-14 11:49:06.199999000 +0100
@@ -173,7 +173,6 @@ struct dm_buffer {
 /*----------------------------------------------------------------*/
 
 static struct kmem_cache *dm_bufio_caches[PAGE_SHIFT - SECTOR_SHIFT];
-static char *dm_bufio_cache_names[PAGE_SHIFT - SECTOR_SHIFT];
 
 static inline int dm_bufio_cache_index(struct dm_bufio_client *c)
 {
@@ -185,7 +184,6 @@ static inline int dm_bufio_cache_index(s
 }
 
 #define DM_BUFIO_CACHE(c)	(dm_bufio_caches[dm_bufio_cache_index(c)])
-#define DM_BUFIO_CACHE_NAME(c)	(dm_bufio_cache_names[dm_bufio_cache_index(c)])
 
 #define dm_bufio_in_request()	(!!current->bio_list)
 
@@ -1703,19 +1701,10 @@ struct dm_bufio_client *dm_bufio_client_
 
 	mutex_lock(&dm_bufio_clients_lock);
 	if (c->blocks_per_page_bits) {
-		if (!DM_BUFIO_CACHE_NAME(c)) {
-			DM_BUFIO_CACHE_NAME(c) = kasprintf(GFP_KERNEL, "dm_bufio_cache-%u", c->block_size);
-			if (!DM_BUFIO_CACHE_NAME(c)) {
-				r = -ENOMEM;
-				mutex_unlock(&dm_bufio_clients_lock);
-				goto bad;
-			}
-		}
-
 		if (!DM_BUFIO_CACHE(c)) {
-			DM_BUFIO_CACHE(c) = kmem_cache_create(DM_BUFIO_CACHE_NAME(c),
-							      c->block_size,
-							      c->block_size, 0, NULL);
+			char name[26];
+			snprintf(name, sizeof name, "dm_bufio_cache-%u", c->block_size);
+			DM_BUFIO_CACHE(c) = kmem_cache_create(name, c->block_size, c->block_size, 0, NULL);
 			if (!DM_BUFIO_CACHE(c)) {
 				r = -ENOMEM;
 				mutex_unlock(&dm_bufio_clients_lock);
@@ -1908,7 +1897,6 @@ static int __init dm_bufio_init(void)
 	dm_bufio_current_allocated = 0;
 
 	memset(&dm_bufio_caches, 0, sizeof dm_bufio_caches);
-	memset(&dm_bufio_cache_names, 0, sizeof dm_bufio_cache_names);
 
 	mem = (__u64)mult_frac(totalram_pages - totalhigh_pages,
 			       DM_BUFIO_MEMORY_PERCENT, 100) << PAGE_SHIFT;
@@ -1952,9 +1940,6 @@ static void __exit dm_bufio_exit(void)
 	for (i = 0; i < ARRAY_SIZE(dm_bufio_caches); i++)
 		kmem_cache_destroy(dm_bufio_caches[i]);
 
-	for (i = 0; i < ARRAY_SIZE(dm_bufio_cache_names); i++)
-		kfree(dm_bufio_cache_names[i]);
-
 	if (dm_bufio_client_count) {
 		DMCRIT("%s: dm_bufio_client_count leaked: %d",
 			__func__, dm_bufio_client_count);
