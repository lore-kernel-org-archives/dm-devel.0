From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/7] dm-crypt: avoid deadlock in mempools
Date: Fri, 13 Feb 2015 08:24:41 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502130823540.6449@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch fixes a theoretical deadlock introduced in the previous patch.

The function crypt_alloc_buffer may be called concurrently. If we allocate
from the mempool concurrently, there is a possibility of deadlock.
For example, if we have mempool of 256 pages, two processes, each wanting 256,
pages allocate from the mempool concurrently, it may deadlock in a situation
where both processes have allocated 128 pages and the mempool is exhausted.

In order to avoid this scenarios, we allocate the pages under a mutex.

In order to not degrade performance with excessive locking, we try
non-blocking allocations without a mutex first and if it fails, we fallback
to a blocking allocation with a mutex.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

Index: linux-3.18-rc1/drivers/md/dm-crypt.c
===================================================================
--- linux-3.18-rc1.orig/drivers/md/dm-crypt.c	2014-10-21 00:49:31.000000000 +0200
+++ linux-3.18-rc1/drivers/md/dm-crypt.c	2014-10-21 00:49:34.000000000 +0200
@@ -124,6 +124,7 @@ struct crypt_config {
 	mempool_t *req_pool;
 	mempool_t *page_pool;
 	struct bio_set *bs;
+	struct mutex bio_alloc_lock;
 
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
@@ -949,27 +950,51 @@ static void crypt_free_buffer_pages(stru
 /*
  * Generate a new unfragmented bio with the given size
  * This should never violate the device limitations
+ *
+ * This function may be called concurrently. If we allocate from the mempool
+ * concurrently, there is a possibility of deadlock. For example, if we have
+ * mempool of 256 pages, two processes, each wanting 256, pages allocate from
+ * the mempool concurrently, it may deadlock in a situation where both processes
+ * have allocated 128 pages and the mempool is exhausted.
+ *
+ * In order to avoid this scenarios, we allocate the pages under a mutex.
+ *
+ * In order to not degrade performance with excessive locking, we try
+ * non-blocking allocations without a mutex first and if it fails, we fallback
+ * to a blocking allocation with a mutex.
  */
 static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
-	unsigned i, len;
+	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
+	unsigned i, len, remaining_size;
 	struct page *page;
 	struct bio_vec *bvec;
 
+retry:
+	if (unlikely(gfp_mask & __GFP_WAIT))
+		mutex_lock(&cc->bio_alloc_lock);
+
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
 	if (!clone)
-		return NULL;
+		goto return_clone;
 
 	clone_init(io, clone);
 
+	remaining_size = size;
+
 	for (i = 0; i < nr_iovecs; i++) {
 		page = mempool_alloc(cc->page_pool, gfp_mask);
+		if (!page) {
+			crypt_free_buffer_pages(cc, clone);
+			bio_put(clone);
+			gfp_mask |= __GFP_WAIT;
+			goto retry;
+		}
 
-		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
+		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
 
 		bvec = &clone->bi_io_vec[clone->bi_vcnt++];
 		bvec->bv_page = page;
@@ -978,9 +1003,13 @@ static struct bio *crypt_alloc_buffer(st
 
 		clone->bi_iter.bi_size += len;
 
-		size -= len;
+		remaining_size -= len;
 	}
 
+return_clone:
+	if (unlikely(gfp_mask & __GFP_WAIT))
+		mutex_unlock(&cc->bio_alloc_lock);
+
 	return clone;
 }
 
@@ -1679,6 +1708,8 @@ static int crypt_ctr(struct dm_target *t
 		goto bad;
 	}
 
+	mutex_init(&cc->bio_alloc_lock);
+
 	ret = -EINVAL;
 	if (sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid iv_offset sector";
