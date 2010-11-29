From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm crypt: use IO thread for reads only if
	mempool is exhausted
Date: Mon, 29 Nov 2010 23:53:07 +0100
Message-ID: <1291071187-6231-3-git-send-email-mbroz@redhat.com>
References: <1291071187-6231-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1291071187-6231-1-git-send-email-mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

If there is enough memory, code can directly submit bio
instead queing this operation in separate thread.

Try to alloc bio clone with GFP_NOWAIT and only if it
fails use separate queue (map function cannot block here).

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   37 +++++++++++++++++++++++--------------
 1 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b4dac68..98a7ad0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -785,26 +785,30 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
-static void kcryptd_io_read(struct dm_crypt_io *io)
+static void kcryptd_unplug(struct crypt_config *cc)
+{
+	blk_unplug(bdev_get_queue(cc->dev->bdev));
+}
+
+static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 {
 	struct crypt_config *cc = io->target->private;
 	struct bio *base_bio = io->base_bio;
 	struct bio *clone;
 
-	crypt_inc_pending(io);
-
 	/*
 	 * The block layer might modify the bvec array, so always
 	 * copy the required bvecs because we need the original
 	 * one in order to decrypt the whole bio data *afterwards*.
 	 */
-	clone = bio_alloc_bioset(GFP_NOIO, bio_segments(base_bio), cc->bs);
-	if (unlikely(!clone)) {
-		io->error = -ENOMEM;
-		crypt_dec_pending(io);
-		return;
+	clone = bio_alloc_bioset(gfp, bio_segments(base_bio), cc->bs);
+	if (!clone) {
+		kcryptd_unplug(cc);
+		return 1;
 	}
 
+	crypt_inc_pending(io);
+
 	clone_init(io, clone);
 	clone->bi_idx = 0;
 	clone->bi_vcnt = bio_segments(base_bio);
@@ -814,6 +818,7 @@ static void kcryptd_io_read(struct dm_crypt_io *io)
 	       sizeof(struct bio_vec) * clone->bi_vcnt);
 
 	generic_make_request(clone);
+	return 0;
 }
 
 static void kcryptd_io_write(struct dm_crypt_io *io)
@@ -826,9 +831,12 @@ static void kcryptd_io(struct work_struct *work)
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 
-	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_io_read(io);
-	else
+	if (bio_data_dir(io->base_bio) == READ) {
+		crypt_inc_pending(io);
+		if (kcryptd_io_read(io, GFP_NOIO))
+			io->error = -ENOMEM;
+		crypt_dec_pending(io);
+	} else
 		kcryptd_io_write(io);
 }
 
@@ -1446,9 +1454,10 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 
 	io = crypt_io_alloc(ti, bio, dm_target_offset(ti, bio->bi_sector));
 
-	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_queue_io(io);
-	else
+	if (bio_data_dir(io->base_bio) == READ) {
+		if (kcryptd_io_read(io, GFP_NOWAIT))
+			kcryptd_queue_io(io);
+	} else
 		kcryptd_queue_crypt(io);
 
 	return DM_MAPIO_SUBMITTED;
-- 
1.7.2.3
