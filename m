From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] dm-verity: use per request data
Date: Mon, 22 Oct 2012 21:02:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210222101580.9956@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210222059170.9956@file.rdu.redhat.com>
	<Pine.LNX.4.64.1210222101360.9956@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1210222101360.9956@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-verity: use per request data

Remove io_mempool and use per_request_data instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

Index: linux-3.6.2-fast/drivers/md/dm-verity.c
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm-verity.c	2012-10-17 00:24:00.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm-verity.c	2012-10-17 00:30:58.000000000 +0200
@@ -55,7 +55,6 @@ struct dm_verity {
 	unsigned shash_descsize;/* the size of temporary space for crypto */
 	int hash_failed;	/* set to 1 if hash of any block failed */
 
-	mempool_t *io_mempool;	/* mempool of struct dm_verity_io */
 	mempool_t *vec_mempool;	/* mempool of bio vector */
 
 	struct workqueue_struct *verify_wq;
@@ -66,7 +65,6 @@ struct dm_verity {
 
 struct dm_verity_io {
 	struct dm_verity *v;
-	struct bio *bio;
 
 	/* original values of bio->bi_end_io and bio->bi_private */
 	bio_end_io_t *orig_bi_end_io;
@@ -389,8 +387,8 @@ test_block_hash:
  */
 static void verity_finish_io(struct dm_verity_io *io, int error)
 {
-	struct bio *bio = io->bio;
 	struct dm_verity *v = io->v;
+	struct bio *bio = dm_per_request_data_get_bio(io, v->ti->per_request_data);
 
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_private = io->orig_bi_private;
@@ -398,8 +396,6 @@ static void verity_finish_io(struct dm_v
 	if (io->io_vec != io->io_vec_inline)
 		mempool_free(io->io_vec, v->vec_mempool);
 
-	mempool_free(io, v->io_mempool);
-
 	bio_endio(bio, error);
 }
 
@@ -486,9 +482,8 @@ static int verity_map(struct dm_target *
 	if (bio_data_dir(bio) == WRITE)
 		return -EIO;
 
-	io = mempool_alloc(v->io_mempool, GFP_NOIO);
+	io = dm_bio_get_per_request_data(bio, ti->per_request_data);
 	io->v = v;
-	io->bio = bio;
 	io->orig_bi_end_io = bio->bi_end_io;
 	io->orig_bi_private = bio->bi_private;
 	io->block = bio->bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
@@ -610,9 +605,6 @@ static void verity_dtr(struct dm_target 
 	if (v->vec_mempool)
 		mempool_destroy(v->vec_mempool);
 
-	if (v->io_mempool)
-		mempool_destroy(v->io_mempool);
-
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
@@ -841,13 +833,7 @@ static int verity_ctr(struct dm_target *
 		goto bad;
 	}
 
-	v->io_mempool = mempool_create_kmalloc_pool(DM_VERITY_MEMPOOL_SIZE,
-	  sizeof(struct dm_verity_io) + v->shash_descsize + v->digest_size * 2);
-	if (!v->io_mempool) {
-		ti->error = "Cannot allocate io mempool";
-		r = -ENOMEM;
-		goto bad;
-	}
+	ti->per_request_data = sizeof(struct dm_verity_io) + v->shash_descsize + v->digest_size * 2;
 
 	v->vec_mempool = mempool_create_kmalloc_pool(DM_VERITY_MEMPOOL_SIZE,
 					BIO_MAX_PAGES * sizeof(struct bio_vec));
