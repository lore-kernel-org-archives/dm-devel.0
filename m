From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 11/20] dm-crypt: avoid deadlock in mempools
Date: Tue, 21 Aug 2012 11:09:22 +0200
Message-ID: <d8cb081039c69d67a77ddb094ba69232420c2727.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

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
 drivers/md/dm-crypt.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7f277ef..36bc19c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -124,6 +124,7 @@ struct crypt_config {
 	mempool_t *req_pool;
 	mempool_t *page_pool;
 	struct bio_set *bs;
+	struct mutex bio_alloc_lock;
 
 	struct workqueue_struct *io_queue;
 	unsigned crypt_threads_size;
@@ -876,24 +877,46 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
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
+	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
 	unsigned i, len;
 	struct page *page;
 
+retry:
+	if (unlikely(gfp_mask & __GFP_WAIT))
+		mutex_lock(&cc->bio_alloc_lock);
+
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
 	if (!clone)
-		return NULL;
+		goto return_clone;
 
 	clone_init(io, clone);
 
 	for (i = 0; i < nr_iovecs; i++) {
 		page = mempool_alloc(cc->page_pool, gfp_mask);
+		if (!page) {
+			crypt_free_buffer_pages(cc, clone);
+			bio_put(clone);
+			gfp_mask |= __GFP_WAIT;
+			goto retry;
+		}
 
 		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
 
@@ -901,12 +924,17 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 			mempool_free(page, cc->page_pool);
 			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
-			return NULL;
+			clone = NULL;
+			goto return_clone;
 		}
 
 		size -= len;
 	}
 
+return_clone:
+	if (unlikely(gfp_mask & __GFP_WAIT))
+		mutex_unlock(&cc->bio_alloc_lock);
+
 	return clone;
 }
 
@@ -1601,6 +1629,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	mutex_init(&cc->bio_alloc_lock);
+
 	ret = -EINVAL;
 	if (sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid iv_offset sector";
-- 
1.7.10.4
