From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 16/25] dm crypt: use per device
	singlethread workqueues
Date: Fri, 12 Oct 2007 18:20:13 +0100
Message-ID: <20071012172013.GB24157@agk.fab.redhat.com>
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Use a separate single-threaded workqueue for each crypt device
instead of one global workqueue.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 13:15:31.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 13:18:16.000000000 +0100
@@ -80,6 +80,7 @@ struct crypt_config {
 	mempool_t *page_pool;
 	struct bio_set *bs;
 
+	struct workqueue_struct *queue;
 	/*
 	 * crypto related data
 	 */
@@ -501,13 +502,14 @@ static void dec_pending(struct dm_crypt_
  * Needed because it would be very unwise to do decryption in an
  * interrupt context.
  */
-static struct workqueue_struct *_kcryptd_workqueue;
 static void kcryptd_do_work(struct work_struct *work);
 
 static void kcryptd_queue_io(struct dm_crypt_io *io)
 {
+	struct crypt_config *cc = io->target->private;
+
 	INIT_WORK(&io->work, kcryptd_do_work);
-	queue_work(_kcryptd_workqueue, &io->work);
+	queue_work(cc->queue, &io->work);
 }
 
 static void crypt_endio(struct bio *clone, int error)
@@ -889,9 +891,17 @@ static int crypt_ctr(struct dm_target *t
 	} else
 		cc->iv_mode = NULL;
 
+	cc->queue = create_singlethread_workqueue("kcryptd");
+	if (!cc->queue) {
+		ti->error = "Couldn't create kcryptd queue";
+		goto bad_queue;
+	}
+
 	ti->private = cc;
 	return 0;
 
+bad_queue:
+	kfree(cc->iv_mode);
 bad_iv_mode:
 	dm_put_device(ti, cc->dev);
 bad5:
@@ -916,7 +926,7 @@ static void crypt_dtr(struct dm_target *
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
-	flush_workqueue(_kcryptd_workqueue);
+	destroy_workqueue(cc->queue);
 
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
@@ -1061,25 +1071,12 @@ static int __init dm_crypt_init(void)
 	if (!_crypt_io_pool)
 		return -ENOMEM;
 
-	_kcryptd_workqueue = create_workqueue("kcryptd");
-	if (!_kcryptd_workqueue) {
-		r = -ENOMEM;
-		DMERR("couldn't create kcryptd");
-		goto bad1;
-	}
-
 	r = dm_register_target(&crypt_target);
 	if (r < 0) {
 		DMERR("register failed %d", r);
-		goto bad2;
+		kmem_cache_destroy(_crypt_io_pool);
 	}
 
-	return 0;
-
-bad2:
-	destroy_workqueue(_kcryptd_workqueue);
-bad1:
-	kmem_cache_destroy(_crypt_io_pool);
 	return r;
 }
 
@@ -1090,7 +1087,6 @@ static void __exit dm_crypt_exit(void)
 	if (r < 0)
 		DMERR("unregister failed %d", r);
 
-	destroy_workqueue(_kcryptd_workqueue);
 	kmem_cache_destroy(_crypt_io_pool);
 }
 
