From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 15/20] dm-crypt: remove io_pending field
Date: Tue, 21 Aug 2012 11:09:26 +0200
Message-ID: <c39b74069a87cbbf3942ad6604b879d06be20d6b.1345477953.git.mbroz@redhat.com>
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

Remove io_pending field. Since we changed the code so that it allocates
all pages for one request, we no longer need it. There is always just one
pending request, so we may remove the pending counter.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6f18838..9740774 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -53,7 +53,6 @@ struct dm_crypt_io {
 	sector_t cc_sector;
 	atomic_t cc_pending;
 
-	atomic_t io_pending;
 	int error;
 	sector_t sector;
 };
@@ -808,7 +807,7 @@ static void crypt_flush_batch(struct crypt_config *cc, struct list_head *batch)
 	INIT_LIST_HEAD(batch);
 }
 
-static void crypt_dec_pending(struct dm_crypt_io *io);
+static void crypt_end_io(struct dm_crypt_io *io);
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async);
 
 static void crypt_dec_cc_pending(struct dm_crypt_io *io)
@@ -817,7 +816,7 @@ static void crypt_dec_cc_pending(struct dm_crypt_io *io)
 		return;
 
 	if (bio_data_dir(io->base_bio) == READ)
-		crypt_dec_pending(io);
+		crypt_end_io(io);
 	else
 		kcryptd_crypt_write_io_submit(io, 1);
 }
@@ -968,29 +967,20 @@ static struct dm_crypt_io *crypt_io_alloc(struct crypt_config *cc,
 	io->base_bio = bio;
 	io->sector = sector;
 	io->error = 0;
-	atomic_set(&io->io_pending, 0);
 
 	return io;
 }
 
-static void crypt_inc_pending(struct dm_crypt_io *io)
-{
-	atomic_inc(&io->io_pending);
-}
-
 /*
  * One of the bios was finished. Check for completion of
  * the whole request and correctly clean up the buffer.
  */
-static void crypt_dec_pending(struct dm_crypt_io *io)
+static void crypt_end_io(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *base_bio = io->base_bio;
 	int error = io->error;
 
-	if (!atomic_dec_and_test(&io->io_pending))
-		return;
-
 	mempool_free(io, cc->io_pool);
 
 	bio_endio(base_bio, error);
@@ -1038,7 +1028,7 @@ static void crypt_endio(struct bio *clone, int error)
 	if (unlikely(error))
 		io->error = error;
 
-	crypt_dec_pending(io);
+	crypt_end_io(io);
 }
 
 static void clone_init(struct dm_crypt_io *io, struct bio *clone)
@@ -1067,8 +1057,6 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	if (!clone)
 		return 1;
 
-	crypt_inc_pending(io);
-
 	clone_init(io, clone);
 	clone->bi_idx = 0;
 	clone->bi_vcnt = bio_segments(base_bio);
@@ -1110,7 +1098,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
 		bio_put(clone);
-		crypt_dec_pending(io);
+		crypt_end_io(io);
 		return;
 	}
 
@@ -1132,16 +1120,13 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	unsigned remaining = io->base_bio->bi_size;
 	sector_t sector = io->sector;
 
-	/*
-	 * Prevent io from disappearing until this function completes.
-	 */
-	crypt_inc_pending(io);
 	crypt_convert_init(cc, io, NULL, io->base_bio, sector);
 
 	clone = crypt_alloc_buffer(io, remaining);
 	if (unlikely(!clone)) {
 		io->error = -ENOMEM;
-		goto dec;
+		crypt_end_io(io);
+		return;
 	}
 
 	io->bio_out = clone;
@@ -1150,23 +1135,17 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	remaining -= clone->bi_size;
 	sector += bio_sectors(clone);
 
-	crypt_inc_pending(io);
 	crypt_convert(cc, io);
-dec:
-	crypt_dec_pending(io);
 }
 
 static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 
-	crypt_inc_pending(io);
-
 	crypt_convert_init(cc, io, io->base_bio, io->base_bio,
 			   io->sector);
 
 	crypt_convert(cc, io);
-	crypt_dec_pending(io);
 }
 
 static void kcryptd_async_done(struct crypto_async_request *async_req,
-- 
1.7.10.4
