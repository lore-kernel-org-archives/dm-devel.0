From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 10/20] dm-crypt: don't allocate pages for a
	partial request.
Date: Tue, 21 Aug 2012 11:09:21 +0200
Message-ID: <ebb2446b0b24d56e92938ec2e649192c4e757ee4.1345477953.git.mbroz@redhat.com>
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

This patch changes crypt_alloc_buffer so that it always allocates pages for
a full request.

This change enables further simplification and removing of one refcounts
in the next patches.

Note: the next patch is needed to fix a theoretical deadlock

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |  134 ++++++++++---------------------------------------
 1 file changed, 26 insertions(+), 108 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d6306f1..7f277ef 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -63,7 +63,6 @@ struct dm_crypt_io {
 	atomic_t io_pending;
 	int error;
 	sector_t sector;
-	struct dm_crypt_io *base_io;
 };
 
 struct dm_crypt_request {
@@ -173,7 +172,6 @@ struct crypt_config {
 };
 
 #define MIN_IOS        16
-#define MIN_POOL_PAGES 32
 
 static struct kmem_cache *_crypt_io_pool;
 
@@ -873,14 +871,13 @@ static void dm_crypt_bio_destructor(struct bio *bio)
 	bio_free(bio, cc->bs);
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
@@ -894,37 +891,22 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size,
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
 			mempool_free(page, cc->page_pool);
-			break;
+			crypt_free_buffer_pages(cc, clone);
+			bio_put(clone);
+			return NULL;
 		}
 
 		size -= len;
 	}
 
-	if (!clone->bi_size) {
-		bio_put(clone);
-		return NULL;
-	}
-
 	return clone;
 }
 
@@ -951,7 +933,6 @@ static struct dm_crypt_io *crypt_io_alloc(struct crypt_config *cc,
 	io->base_bio = bio;
 	io->sector = sector;
 	io->error = 0;
-	io->base_io = NULL;
 	atomic_set(&io->io_pending, 0);
 
 	return io;
@@ -965,13 +946,11 @@ static void crypt_inc_pending(struct dm_crypt_io *io)
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
@@ -979,13 +958,7 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 
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
@@ -1121,9 +1094,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
-	struct dm_crypt_io *new_io;
 	int crypt_finished;
-	unsigned out_of_pages = 0;
 	unsigned remaining = io->base_bio->bi_size;
 	sector_t sector = io->sector;
 	int r;
@@ -1134,81 +1105,28 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
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
-		io->ctx.idx_out = 0;
-
-		remaining -= clone->bi_size;
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
-
-			io->sector = sector;
-		}
-
-		/*
-		 * Out of memory -> run queues
-		 * But don't wait if split was due to the io size restriction
-		 */
-		if (unlikely(out_of_pages))
-			congestion_wait(BLK_RW_ASYNC, HZ/100);
+	clone = crypt_alloc_buffer(io, remaining);
+	if (unlikely(!clone)) {
+		io->error = -ENOMEM;
+		goto dec;
+	}
 
-		/*
-		 * With async crypto it is unsafe to share the crypto context
-		 * between fragments, so switch to a new dm_crypt_io structure.
-		 */
-		if (unlikely(!crypt_finished && remaining)) {
-			new_io = crypt_io_alloc(io->cc, io->base_bio,
-						sector);
-			crypt_inc_pending(new_io);
-			crypt_convert_init(cc, &new_io->ctx, NULL,
-					   io->base_bio, sector);
-			new_io->ctx.idx_in = io->ctx.idx_in;
-			new_io->ctx.offset_in = io->ctx.offset_in;
+	io->ctx.bio_out = clone;
+	io->ctx.idx_out = 0;
 
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
+	remaining -= clone->bi_size;
+	sector += bio_sectors(clone);
 
-			io = new_io;
-		}
-	}
+	crypt_inc_pending(io);
+	r = crypt_convert(cc, &io->ctx);
+	if (r)
+		io->error = -EIO;
+	crypt_finished = atomic_dec_and_test(&io->ctx.cc_pending);
 
+	/* Encryption was already finished, submit io now */
+	if (crypt_finished)
+		kcryptd_crypt_write_io_submit(io, 0);
+dec:
 	crypt_dec_pending(io);
 }
 
@@ -1671,7 +1589,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
+	cc->page_pool = mempool_create_page_pool(BIO_MAX_PAGES, 0);
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
 		goto bad;
-- 
1.7.10.4
