From: Olaf Kirch <olaf.kirch@oracle.com>
Subject: [PATCH 3/3] Get rid of first_clone in dm-crypt
Date: Tue, 20 Mar 2007 20:55:08 +0100
Message-ID: <200703202055.09519.olaf.kirch@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Get rid of first_clone in dm-crypt

This gets rid of first_clone, which is not really needed.  Apparently,
cloned bios used to share their bvec some time way in the past - this is
no longer the case. Contrarily, this even hurts us if we try to create
a clone off first_clone after it has completed, and crypt_endio has
destroyed its bvec.

Signed-off-by: olaf.kirch@oracle.com
---
 drivers/md/dm-crypt.c |   32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

Index: linux-2.6.20/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.20.orig/drivers/md/dm-crypt.c
+++ linux-2.6.20/drivers/md/dm-crypt.c
@@ -33,7 +33,6 @@
 struct crypt_io {
 	struct dm_target *target;
 	struct bio *base_bio;
-	struct bio *first_clone;
 	struct work_struct work;
 	atomic_t pending;
 	int error;
@@ -381,8 +380,7 @@ static int crypt_convert(struct crypt_co
  * May return a smaller bio when running out of pages
  */
 static struct bio *
-crypt_alloc_buffer(struct crypt_io *io, unsigned int size,
-                   struct bio *base_bio, unsigned int *bio_vec_idx)
+crypt_alloc_buffer(struct crypt_io *io, unsigned int size, unsigned int 
*bio_vec_idx)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *clone;
@@ -390,12 +388,7 @@ crypt_alloc_buffer(struct crypt_io *io, 
 	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
 	unsigned int i;
 
-	if (base_bio) {
-		clone = bio_alloc_bioset(GFP_NOIO, base_bio->bi_max_vecs, cc->bs);
-		__bio_clone(clone, base_bio);
-	} else
-		clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
-
+	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
 	if (!clone)
 		return NULL;
 
@@ -498,9 +491,6 @@ static void dec_pending(struct crypt_io 
 	if (!atomic_dec_and_test(&io->pending))
 		return;
 
-	if (io->first_clone)
-		bio_put(io->first_clone);
-
 	bio_endio(io->base_bio, io->base_bio->bi_size, io->error);
 
 	mempool_free(io, cc->io_pool);
@@ -618,8 +608,7 @@ static void process_write(struct crypt_i
 	 * so repeat the whole process until all the data can be handled.
 	 */
 	while (remaining) {
-		clone = crypt_alloc_buffer(io, base_bio->bi_size,
-					   io->first_clone, &bvec_idx);
+		clone = crypt_alloc_buffer(io, base_bio->bi_size, &bvec_idx);
 		if (unlikely(!clone)) {
 			dec_pending(io, -ENOMEM);
 			return;
@@ -635,21 +624,11 @@ static void process_write(struct crypt_i
 		}
 
 		clone->bi_sector = cc->start + sector;
-
-		if (!io->first_clone) {
-			/*
-			 * hold a reference to the first clone, because it
-			 * holds the bio_vec array and that can't be freed
-			 * before all other clones are released
-			 */
-			bio_get(clone);
-			io->first_clone = clone;
-		}
-
 		remaining -= clone->bi_size;
 		sector += bio_sectors(clone);
 
-		/* prevent bio_put of first_clone */
+		/* Grab another reference to the io struct
+		 * before we kick off the request */
 		if (remaining)
 			atomic_inc(&io->pending);
 
@@ -962,7 +941,6 @@ static int crypt_map(struct dm_target *t
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
-	io->first_clone = NULL;
 	io->error = io->post_process = 0;
 	atomic_set(&io->pending, 0);
 	kcryptd_queue_io(io);

-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
