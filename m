From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/9] dm-crypt patches
Date: Sun, 6 Apr 2014 21:01:38 -0400
Message-ID: <20140407010138.GA29720@redhat.com>
References: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1404051359500.8509@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 05 2014 at  2:04pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I fixed the bug that Ondrej found (it happened only under memory pressure, 
> that's why I couldn't reproduce it), here I'm resending the dm-crypt 
> patches.

I already staged your original patchset in linux-dm.git's 'for-next'
branch (linux-next).  So your re-post of these patches threw away patch
header edits, my Signed-off-by;s and also my cleanu-up of the rb-tree
code in patch 9.

Anyway, I folded the following fix from your new patch series into patch
5 (I saw no reason why 'remaining_size' couldn't be applied in patch 5
rather than patch 6).  All rebased patches are now staged in linux-next
(Ondrej please test, if we can verify performance I'm still open to
sending to Linus for 3.15, but must be by Thursday at the latest with no
further changes to this code):

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index c74c779..bbc1043 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -979,8 +979,9 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
-	unsigned i, len;
+	unsigned i, len, remaining_size;
 	struct page *page;
+	struct bio_vec *bvec;
 
 retry:
 	if (unlikely(gfp_mask & __GFP_WAIT))
@@ -992,6 +993,8 @@ retry:
 
 	clone_init(io, clone);
 
+	remaining_size = size;
+
 	for (i = 0; i < nr_iovecs; i++) {
 		page = mempool_alloc(cc->page_pool, gfp_mask);
 		if (!page) {
@@ -1001,18 +1004,16 @@ retry:
 			goto retry;
 		}
 
-		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
+		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
 
-		if (!bio_add_page(clone, page, len, 0)) {
-			DMERR("bio_add_page failed for page %d: the underlying device has stricter limits than dm-crypt target", i);
-			mempool_free(page, cc->page_pool);
-			crypt_free_buffer_pages(cc, clone);
-			bio_put(clone);
-			clone = NULL;
-			goto return_clone;
-		}
+		bvec = &clone->bi_io_vec[clone->bi_vcnt++];
+		bvec->bv_page = page;
+		bvec->bv_len = len;
+		bvec->bv_offset = 0;
+
+		clone->bi_iter.bi_size += len;
 
-		size -= len;
+		remaining_size -= len;
 	}
 
 return_clone:


Also note, I also folded this into patch 6 (BUG_ON conveys intent that
mempool_alloc should _never_ fail once __GFP_WAIT is set in
gfp_mask.. if it did we'd deadlock trying to re-acquire the mutex,
rather than BUG_ON but...):

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 56784ed..53cbfdf 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -967,10 +967,10 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
  * the mempool concurrently, it may deadlock in a situation where both processes
  * have allocated 128 pages and the mempool is exhausted.
  *
- * In order to avoid this scenarios, we allocate the pages under a mutex.
+ * In order to avoid this scenario we allocate the pages under a mutex.
  *
  * In order to not degrade performance with excessive locking, we try
- * non-blocking allocations without a mutex first and if it fails, we fallback
+ * non-blocking allocation without a mutex first and if it fails, we fallback
  * to a blocking allocation with a mutex.
  */
 static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
@@ -998,6 +998,7 @@ retry:
 	for (i = 0; i < nr_iovecs; i++) {
 		page = mempool_alloc(cc->page_pool, gfp_mask);
 		if (!page) {
+			BUG_ON(gfp_mask & __GFP_WAIT);
 			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
 			gfp_mask |= __GFP_WAIT;
