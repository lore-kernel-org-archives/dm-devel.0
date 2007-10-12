From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 17/25] dm crypt: add post processing queue
Date: Fri, 12 Oct 2007 18:20:41 +0100
Message-ID: <20071012172041.GC24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Add post-processing queue (per crypt device) for read operations.

Current implementation uses only one queue for all operations
and this can lead to starvation caused by many requests waiting
for memory allocation. But the needed memory-releasing operation
is queued after these requests (in the same queue).

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-crypt.c |   67 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 51 insertions(+), 16 deletions(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 13:18:16.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 14:52:45.000000000 +0100
@@ -36,7 +36,6 @@ struct dm_crypt_io {
 	struct work_struct work;
 	atomic_t pending;
 	int error;
-	int post_process;
 };
 
 /*
@@ -80,7 +79,8 @@ struct crypt_config {
 	mempool_t *page_pool;
 	struct bio_set *bs;
 
-	struct workqueue_struct *queue;
+	struct workqueue_struct *io_queue;
+	struct workqueue_struct *crypt_queue;
 	/*
 	 * crypto related data
 	 */
@@ -497,19 +497,36 @@ static void dec_pending(struct dm_crypt_
 }
 
 /*
- * kcryptd:
+ * kcryptd/kcryptd_io:
  *
  * Needed because it would be very unwise to do decryption in an
  * interrupt context.
+ *
+ * kcryptd performs the actual encryption or decryption.
+ *
+ * kcryptd_io performs the IO submission.
+ *
+ * They must be separated as otherwise the final stages could be
+ * starved by new requests which can block in the first stages due
+ * to memory allocation.
  */
 static void kcryptd_do_work(struct work_struct *work);
+static void kcryptd_do_crypt(struct work_struct *work);
 
 static void kcryptd_queue_io(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->target->private;
 
 	INIT_WORK(&io->work, kcryptd_do_work);
-	queue_work(cc->queue, &io->work);
+	queue_work(cc->io_queue, &io->work);
+}
+
+static void kcryptd_queue_crypt(struct dm_crypt_io *io)
+{
+	struct crypt_config *cc = io->target->private;
+
+	INIT_WORK(&io->work, kcryptd_do_crypt);
+	queue_work(cc->crypt_queue, &io->work);
 }
 
 static void crypt_endio(struct bio *clone, int error)
@@ -532,8 +549,7 @@ static void crypt_endio(struct bio *clon
 	}
 
 	bio_put(clone);
-	io->post_process = 1;
-	kcryptd_queue_io(io);
+	kcryptd_queue_crypt(io);
 	return;
 
 out:
@@ -655,10 +671,16 @@ static void kcryptd_do_work(struct work_
 {
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 
-	if (io->post_process)
-		process_read_endio(io);
-	else if (bio_data_dir(io->base_bio) == READ)
+	if (bio_data_dir(io->base_bio) == READ)
 		process_read(io);
+}
+
+static void kcryptd_do_crypt(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+
+	if (bio_data_dir(io->base_bio) == READ)
+		process_read_endio(io);
 	else
 		process_write(io);
 }
@@ -891,16 +913,24 @@ static int crypt_ctr(struct dm_target *t
 	} else
 		cc->iv_mode = NULL;
 
-	cc->queue = create_singlethread_workqueue("kcryptd");
-	if (!cc->queue) {
+	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
+	if (!cc->io_queue) {
+		ti->error = "Couldn't create kcryptd io queue";
+		goto bad_io_queue;
+	}
+
+	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
+	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
-		goto bad_queue;
+		goto bad_crypt_queue;
 	}
 
 	ti->private = cc;
 	return 0;
 
-bad_queue:
+bad_crypt_queue:
+	destroy_workqueue(cc->io_queue);
+bad_io_queue:
 	kfree(cc->iv_mode);
 bad_iv_mode:
 	dm_put_device(ti, cc->dev);
@@ -926,7 +956,8 @@ static void crypt_dtr(struct dm_target *
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
-	destroy_workqueue(cc->queue);
+	destroy_workqueue(cc->io_queue);
+	destroy_workqueue(cc->crypt_queue);
 
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
@@ -952,9 +983,13 @@ static int crypt_map(struct dm_target *t
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
-	io->error = io->post_process = 0;
+	io->error = 0;
 	atomic_set(&io->pending, 0);
-	kcryptd_queue_io(io);
+
+	if (bio_data_dir(io->base_bio) == READ)
+		kcryptd_queue_io(io);
+	else
+		kcryptd_queue_crypt(io);
 
 	return DM_MAPIO_SUBMITTED;
 }
