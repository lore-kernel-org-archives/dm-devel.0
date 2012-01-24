From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: add missing error handling
Date: Mon, 23 Jan 2012 21:32:20 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1201232131240.17493@hs20-bc2-1.build.redhat.com>
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
To: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

dm-crypt: add missing error handling

There were cases where error code would be used only if we finish processing
the last sector. If there were other encryption operations in flight, error
would be ignored and bio would be returned with success as if no error
happened.

This bug is present in kcryptd_crypt_write_convert, kcryptd_crypt_read_convert
and kcryptd_async_done.

This patch fixes it, setting io->error to -EIO always when an error happens.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

Index: linux-3.2-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-3.2-fast.orig/drivers/md/dm-crypt.c	2012-01-24 03:14:11.000000000 +0100
+++ linux-3.2-fast/drivers/md/dm-crypt.c	2012-01-24 03:20:41.000000000 +0100
@@ -1045,16 +1045,14 @@ static void kcryptd_queue_io(struct dm_c
 	queue_work(cc->io_queue, &io->work);
 }
 
-static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
-					  int error, int async)
+static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 {
 	struct bio *clone = io->ctx.bio_out;
 	struct crypt_config *cc = io->target->private;
 
-	if (unlikely(error < 0)) {
+	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
 		bio_put(clone);
-		io->error = -EIO;
 		crypt_dec_pending(io);
 		return;
 	}
@@ -1106,11 +1104,13 @@ static void kcryptd_crypt_write_convert(
 
 		crypt_inc_pending(io);
 		r = crypt_convert(cc, &io->ctx);
+		if (r < 0)
+			io->error = -EIO;
 		crypt_finished = atomic_dec_and_test(&io->ctx.pending);
 
 		/* Encryption was already finished, submit io now */
 		if (crypt_finished) {
-			kcryptd_crypt_write_io_submit(io, r, 0);
+			kcryptd_crypt_write_io_submit(io, 0);
 
 			/*
 			 * If there was an error, do not try next fragments.
@@ -1161,11 +1161,8 @@ static void kcryptd_crypt_write_convert(
 	crypt_dec_pending(io);
 }
 
-static void kcryptd_crypt_read_done(struct dm_crypt_io *io, int error)
+static void kcryptd_crypt_read_done(struct dm_crypt_io *io)
 {
-	if (unlikely(error < 0))
-		io->error = -EIO;
-
 	crypt_dec_pending(io);
 }
 
@@ -1181,8 +1178,11 @@ static void kcryptd_crypt_read_convert(s
 
 	r = crypt_convert(cc, &io->ctx);
 
+	if (r < 0)
+		io->error = -EIO;
+
 	if (atomic_dec_and_test(&io->ctx.pending))
-		kcryptd_crypt_read_done(io, r);
+		kcryptd_crypt_read_done(io);
 
 	crypt_dec_pending(io);
 }
@@ -1203,15 +1203,18 @@ static void kcryptd_async_done(struct cr
 	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
 
+	if (error < 0)
+		io->error = -EIO;
+
 	mempool_free(req_of_dmreq(cc, dmreq), cc->req_pool);
 
 	if (!atomic_dec_and_test(&ctx->pending))
 		return;
 
 	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_crypt_read_done(io, error);
+		kcryptd_crypt_read_done(io);
 	else
-		kcryptd_crypt_write_io_submit(io, error, 1);
+		kcryptd_crypt_write_io_submit(io, 1);
 }
 
 static void kcryptd_crypt(struct work_struct *work)
