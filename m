From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/9] dm crypt: use per-bio data
Date: Fri, 28 Mar 2014 16:11:10 -0400
Message-ID: <1396037476-26595-4-git-send-email-snitzer@redhat.com>
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

Change dm-crypt so that it uses auxiliary data allocated with the bio.

Dm-crypt requires two allocations per request - struct dm_crypt_io and
struct ablkcipher_request (with other data appended to it).  It
previously only used mempool allocations.

Some requests may require more dm_crypt_ios and ablkcipher_requests,
however most requests need just one of each of these two structures to
complete.

This patch changes it so that the first dm_crypt_io and ablkcipher_request
are allocated with the bio (using target per_bio_data_size option).  If
the request needs additional values, they are allocated from the mempool.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 53b2132..2221d12 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -59,7 +59,7 @@ struct dm_crypt_io {
 	int error;
 	sector_t sector;
 	struct dm_crypt_io *base_io;
-};
+} CRYPTO_MINALIGN_ATTR;
 
 struct dm_crypt_request {
 	struct convert_context *ctx;
@@ -162,6 +162,8 @@ struct crypt_config {
 	 */
 	unsigned int dmreq_start;
 
+	unsigned int per_bio_data_size;
+
 	unsigned long flags;
 	unsigned int key_size;
 	unsigned int key_parts;      /* independent parts in key buffer */
@@ -895,6 +897,14 @@ static void crypt_alloc_req(struct crypt_config *cc,
 	    kcryptd_async_done, dmreq_of_req(cc, ctx->req));
 }
 
+static void crypt_free_req(struct crypt_config *cc,
+			   struct ablkcipher_request *req, struct bio *base_bio)
+{
+	struct dm_crypt_io *io = dm_per_bio_data(base_bio, cc->per_bio_data_size);
+	if ((struct ablkcipher_request *)(io + 1) != req)
+		mempool_free(req, cc->req_pool);
+}
+
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
@@ -1008,12 +1018,9 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 	}
 }
 
-static struct dm_crypt_io *crypt_io_alloc(struct crypt_config *cc,
-					  struct bio *bio, sector_t sector)
+static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
+			  struct bio *bio, sector_t sector)
 {
-	struct dm_crypt_io *io;
-
-	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->cc = cc;
 	io->base_bio = bio;
 	io->sector = sector;
@@ -1021,8 +1028,6 @@ static struct dm_crypt_io *crypt_io_alloc(struct crypt_config *cc,
 	io->base_io = NULL;
 	io->ctx.req = NULL;
 	atomic_set(&io->io_pending, 0);
-
-	return io;
 }
 
 static void crypt_inc_pending(struct dm_crypt_io *io)
@@ -1046,8 +1051,9 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 		return;
 
 	if (io->ctx.req)
-		mempool_free(io->ctx.req, cc->req_pool);
-	mempool_free(io, cc->io_pool);
+		crypt_free_req(cc, io->ctx.req, base_bio);
+	if (io != dm_per_bio_data(base_bio, cc->per_bio_data_size))
+		mempool_free(io, cc->io_pool);
 
 	if (likely(!base_io))
 		bio_endio(base_bio, error);
@@ -1255,8 +1261,8 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		 * between fragments, so switch to a new dm_crypt_io structure.
 		 */
 		if (unlikely(!crypt_finished && remaining)) {
-			new_io = crypt_io_alloc(io->cc, io->base_bio,
-						sector);
+			new_io = mempool_alloc(cc->io_pool, GFP_NOIO);
+			crypt_io_init(new_io, io->cc, io->base_bio, sector);
 			crypt_inc_pending(new_io);
 			crypt_convert_init(cc, &new_io->ctx, NULL,
 					   io->base_bio, sector);
@@ -1325,7 +1331,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	if (error < 0)
 		io->error = -EIO;
 
-	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
+	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
 	if (!atomic_dec_and_test(&ctx->cc_pending))
 		return;
@@ -1728,6 +1734,10 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	cc->per_bio_data_size = ti->per_bio_data_size =
+				sizeof(struct dm_crypt_io) + cc->dmreq_start +
+				sizeof(struct dm_crypt_request) + cc->iv_size;
+
 	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
@@ -1824,7 +1834,9 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_REMAPPED;
 	}
 
-	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
+	io = dm_per_bio_data(bio, cc->per_bio_data_size);
+	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
+	io->ctx.req = (struct ablkcipher_request *)(io + 1);
 
 	if (bio_data_dir(io->base_bio) == READ) {
 		if (kcryptd_io_read(io, GFP_NOWAIT))
-- 
1.8.1.4
