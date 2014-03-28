From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/9] dm crypt: don't allocate pages for a partial
	request
Date: Fri, 28 Mar 2014 16:11:12 -0400
Message-ID: <1396037476-26595-6-git-send-email-snitzer@redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
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

From: Mikulas Patocka <mpatocka@redhat.com>

Change crypt_alloc_buffer so that it only ever allocates pages for a
full request.

This change enables further simplification and removing of one refcounts
in the next patches.

Note: the next commit ("dm-crypt: avoid deadlock in mempools") is needed
to fix a theoretical deadlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 133 ++++++++++----------------------------------------
 1 file changed, 27 insertions(+), 106 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a57b02a..fe92764 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -58,7 +58,6 @@ struct dm_crypt_io {
 	atomic_t io_pending;
 	int error;
 	sector_t sector;
-	struct dm_crypt_io *base_io;
 } CRYPTO_MINALIGN_ATTR;
 
 struct dm_crypt_request {
@@ -172,7 +171,6 @@ struct crypt_config {
 };
 
 #define MIN_IOS        16
-#define MIN_POOL_PAGES 32
 
 static struct kmem_cache *_crypt_io_pool;
 
@@ -951,14 +949,13 @@ static int crypt_convert(struct crypt_config *cc,
 	return 0;
 }
 
+static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
+
 /*
  * Generate a new unfragmented bio with the given size
  * This should never violate the device limitations
- * May return a smaller bio when running out of pages, indicated by
- * *out_of_pages set to 1.
  */
-static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size,
-				      unsigned *out_of_pages)
+static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
@@ -972,37 +969,23 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size,
 		return NULL;
 
 	clone_init(io, clone);
-	*out_of_pages = 0;
 
 	for (i = 0; i < nr_iovecs; i++) {
 		page = mempool_alloc(cc->page_pool, gfp_mask);
-		if (!page) {
-			*out_of_pages = 1;
-			break;
-		}
-
-		/*
-		 * If additional pages cannot be allocated without waiting,
-		 * return a partially-allocated bio.  The caller will then try
-		 * to allocate more bios while submitting this partial bio.
-		 */
-		gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
 
 		if (!bio_add_page(clone, page, len, 0)) {
+			DMERR("bio_add_page failed for page %d: the underlying device has stricter limits than dm-crypt target", i);
 			mempool_free(page, cc->page_pool);
-			break;
+			crypt_free_buffer_pages(cc, clone);
+			bio_put(clone);
+			return NULL;
 		}
 
 		size -= len;
 	}
 
-	if (!clone->bi_iter.bi_size) {
-		bio_put(clone);
-		return NULL;
-	}
-
 	return clone;
 }
 
@@ -1025,7 +1008,6 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->base_bio = bio;
 	io->sector = sector;
 	io->error = 0;
-	io->base_io = NULL;
 	io->ctx.req = NULL;
 	atomic_set(&io->io_pending, 0);
 }
@@ -1038,13 +1020,11 @@ static void crypt_inc_pending(struct dm_crypt_io *io)
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
- * If base_io is set, wait for the last fragment to complete.
  */
 static void crypt_dec_pending(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
-	struct dm_crypt_io *base_io = io->base_io;
 	int error = io->error;
 
 	if (!atomic_dec_and_test(&io->io_pending))
@@ -1055,13 +1035,7 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	if (io != dm_per_bio_data(base_bio, cc->per_bio_data_size))
 		mempool_free(io, cc->io_pool);
 
-	if (likely(!base_io))
-		bio_endio(base_bio, error);
-	else {
-		if (error && !base_io->error)
-			base_io->error = error;
-		crypt_dec_pending(base_io);
-	}
+	bio_endio(base_bio, error);
 }
 
 /*
@@ -1197,10 +1171,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
-	struct dm_crypt_io *new_io;
 	int crypt_finished;
-	unsigned out_of_pages = 0;
-	unsigned remaining = io->base_bio->bi_iter.bi_size;
 	sector_t sector = io->sector;
 	int r;
 
@@ -1210,80 +1181,30 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	crypt_inc_pending(io);
 	crypt_convert_init(cc, &io->ctx, NULL, io->base_bio, sector);
 
-	/*
-	 * The allocated buffers can be smaller than the whole bio,
-	 * so repeat the whole process until all the data can be handled.
-	 */
-	while (remaining) {
-		clone = crypt_alloc_buffer(io, remaining, &out_of_pages);
-		if (unlikely(!clone)) {
-			io->error = -ENOMEM;
-			break;
-		}
-
-		io->ctx.bio_out = clone;
-		io->ctx.iter_out = clone->bi_iter;
-
-		remaining -= clone->bi_iter.bi_size;
-		sector += bio_sectors(clone);
-
-		crypt_inc_pending(io);
-
-		r = crypt_convert(cc, &io->ctx);
-		if (r < 0)
-			io->error = -EIO;
-
-		crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
-
-		/* Encryption was already finished, submit io now */
-		if (crypt_finished) {
-			kcryptd_crypt_write_io_submit(io, 0);
-
-			/*
-			 * If there was an error, do not try next fragments.
-			 * For async, error is processed in async handler.
-			 */
-			if (unlikely(r < 0))
-				break;
+	clone = crypt_alloc_buffer(io, io->base_bio->bi_iter.bi_size);
+	if (unlikely(!clone)) {
+		io->error = -EIO;
+		goto dec;
+	}
 
-			io->sector = sector;
-		}
+	io->ctx.bio_out = clone;
+	io->ctx.iter_out = clone->bi_iter;
 
-		/*
-		 * Out of memory -> run queues
-		 * But don't wait if split was due to the io size restriction
-		 */
-		if (unlikely(out_of_pages))
-			congestion_wait(BLK_RW_ASYNC, HZ/100);
+	sector += bio_sectors(clone);
 
-		/*
-		 * With async crypto it is unsafe to share the crypto context
-		 * between fragments, so switch to a new dm_crypt_io structure.
-		 */
-		if (unlikely(!crypt_finished && remaining)) {
-			new_io = mempool_alloc(cc->io_pool, GFP_NOIO);
-			crypt_io_init(new_io, io->cc, io->base_bio, sector);
-			crypt_inc_pending(new_io);
-			crypt_convert_init(cc, &new_io->ctx, NULL,
-					   io->base_bio, sector);
-			new_io->ctx.iter_in = io->ctx.iter_in;
-
-			/*
-			 * Fragments after the first use the base_io
-			 * pending count.
-			 */
-			if (!io->base_io)
-				new_io->base_io = io;
-			else {
-				new_io->base_io = io->base_io;
-				crypt_inc_pending(io->base_io);
-				crypt_dec_pending(io);
-			}
+	crypt_inc_pending(io);
+	r = crypt_convert(cc, &io->ctx);
+	if (r)
+		io->error = -EIO;
+	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
 
-			io = new_io;
-		}
+	/* Encryption was already finished, submit io now */
+	if (crypt_finished) {
+		kcryptd_crypt_write_io_submit(io, 0);
+		io->sector = sector;
 	}
 
+dec:
 	crypt_dec_pending(io);
 }
 
@@ -1738,7 +1659,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 				sizeof(struct dm_crypt_io) + cc->dmreq_start +
 				sizeof(struct dm_crypt_request) + cc->iv_size;
 
-	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
+	cc->page_pool = mempool_create_page_pool(BIO_MAX_PAGES, 0);
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
 		goto bad;
-- 
1.8.1.4
