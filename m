From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: lower bio-based reservation
Date: Thu, 18 Aug 2011 17:57:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108181757120.7668@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

When we talked about those reservations, I realized that unusually high 
reservations (256 entries) are done even for bio-based processing.

This patch lowers it to use just 16 entries for bio-based processing. It 
shouldn't deadlock, I am not aware of any theoretical deadlock in 
bio-based dm.

Request-based memory consumption cannot be easily reduced, it uses 
GFP_ATOMIC to allocate all entries at once, and if it fails, request is 
pushed back to the block layer. Thus it needs reservations to process at 
least one complete request.

Mikulas

---

dm: lower bio-based reservation

Bio-based device mapper processing doesn't need large pools (in fact, just
one entry would be sufficient), so this patch lowers the number of reserved
entries for bio-base operation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

Index: linux-3.0-fast/drivers/md/dm.c
===================================================================
--- linux-3.0-fast.orig/drivers/md/dm.c	2011-08-18 21:13:33.000000000 +0200
+++ linux-3.0-fast/drivers/md/dm.c	2011-08-18 21:14:41.000000000 +0200
@@ -197,7 +197,8 @@ struct dm_md_mempools {
 	struct bio_set *bs;
 };
 
-#define MIN_IOS 256
+#define RESERVED_BIO_BASED_IOS		16
+#define RESERVED_REQUEST_BASED_IOS	256
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_tio_cache;
 static struct kmem_cache *_rq_tio_cache;
@@ -2686,20 +2687,21 @@ EXPORT_SYMBOL_GPL(dm_noflush_suspending)
 struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
 {
 	struct dm_md_mempools *pools = kmalloc(sizeof(*pools), GFP_KERNEL);
-	unsigned int pool_size = (type == DM_TYPE_BIO_BASED) ? 16 : MIN_IOS;
+	unsigned int pool_size = (type == DM_TYPE_BIO_BASED) ?
+			RESERVED_BIO_BASED_IOS : RESERVED_REQUEST_BASED_IOS;
 
 	if (!pools)
 		return NULL;
 
 	pools->io_pool = (type == DM_TYPE_BIO_BASED) ?
-			 mempool_create_slab_pool(MIN_IOS, _io_cache) :
-			 mempool_create_slab_pool(MIN_IOS, _rq_bio_info_cache);
+			 mempool_create_slab_pool(pool_size, _io_cache) :
+			 mempool_create_slab_pool(pool_size, _rq_bio_info_cache);
 	if (!pools->io_pool)
 		goto free_pools_and_out;
 
 	pools->tio_pool = (type == DM_TYPE_BIO_BASED) ?
-			  mempool_create_slab_pool(MIN_IOS, _tio_cache) :
-			  mempool_create_slab_pool(MIN_IOS, _rq_tio_cache);
+			  mempool_create_slab_pool(pool_size, _tio_cache) :
+			  mempool_create_slab_pool(pool_size, _rq_tio_cache);
 	if (!pools->tio_pool)
 		goto free_io_pool_and_out;
 
