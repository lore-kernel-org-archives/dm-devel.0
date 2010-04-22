From: San Mehat <san@google.com>
Subject: [PATCH] md: dm-crypt: Add option to re-use a new global
	work-queue.
Date: Thu, 22 Apr 2010 10:48:58 -0700
Message-ID: <1271958538-11193-1-git-send-email-san@google.com>
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
To: dm-devel@redhat.com
Cc: San Mehat <san@google.com>, Brian Swetland <swetland@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christophe Saout <christophe@saout.de>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Typically, dm-crypt instances each have their own set of kcrypt/kcrypt_io
work-queues. This patch adds an option which will create one set of
work-queues on init, and re-uses them for all dm-crypt target instances.

Cc: Milan Broz <mbroz@redhat.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christophe Saout <christophe@saout.de>
Signed-off-by: San Mehat <san@google.com>
---
 drivers/md/Kconfig    |   10 ++++++++++
 drivers/md/dm-crypt.c |   42 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2158377..8d82dfc 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -244,6 +244,16 @@ config DM_CRYPT
 
 	  If unsure, say N.
 
+config DM_CRYPT_GLOBAL_WORKQUEUES
+	boolean "Use global instead of per-device work-queues"
+	depends on DM_CRYPT
+	---help---
+	  Normally 2 kernel work-queue threads are created for every
+	  dm-crypt target. This option creates only 1 set of work-queues
+	  on init, and re-uses them.
+
+	  If unsure, say N.
+
 config DM_SNAPSHOT
        tristate "Snapshot target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 959d6d1..875ad9a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -104,8 +104,10 @@ struct crypt_config {
 	mempool_t *page_pool;
 	struct bio_set *bs;
 
+#ifndef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
+#endif
 
 	/*
 	 * crypto related data
@@ -148,6 +150,10 @@ struct crypt_config {
 #define MIN_BIO_PAGES  8
 
 static struct kmem_cache *_crypt_io_pool;
+#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
+static struct workqueue_struct *_io_queue;
+static struct workqueue_struct *_crypt_queue;
+#endif
 
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
@@ -730,7 +736,11 @@ static void kcryptd_queue_io(struct dm_crypt_io *io)
 	struct crypt_config *cc = io->target->private;
 
 	INIT_WORK(&io->work, kcryptd_io);
+#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
+	queue_work(_io_queue, &io->work);
+#else
 	queue_work(cc->io_queue, &io->work);
+#endif
 }
 
 static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
@@ -914,7 +924,11 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 	struct crypt_config *cc = io->target->private;
 
 	INIT_WORK(&io->work, kcryptd_crypt);
+#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
+	queue_work(_crypt_queue, &io->work);
+#else
 	queue_work(cc->crypt_queue, &io->work);
+#endif
 }
 
 /*
@@ -1165,6 +1179,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	} else
 		cc->iv_mode = NULL;
 
+#ifndef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
 	cc->io_queue = create_singlethread_workqueue("kcryptd_io");
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
@@ -1174,15 +1189,15 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	cc->crypt_queue = create_singlethread_workqueue("kcryptd");
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
-		goto bad_crypt_queue;
+		destroy_workqueue(cc->io_queue);
+		goto bad_io_queue;
 	}
+#endif
 
 	ti->num_flush_requests = 1;
 	ti->private = cc;
 	return 0;
 
-bad_crypt_queue:
-	destroy_workqueue(cc->io_queue);
 bad_io_queue:
 	kfree(cc->iv_mode);
 bad_ivmode_string:
@@ -1210,8 +1225,10 @@ static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
+#ifndef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
 	destroy_workqueue(cc->io_queue);
 	destroy_workqueue(cc->crypt_queue);
+#endif
 
 	if (cc->req)
 		mempool_free(cc->req, cc->req_pool);
@@ -1399,6 +1416,21 @@ static int __init dm_crypt_init(void)
 {
 	int r;
 
+#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
+	_io_queue = create_singlethread_workqueue("kcryptd_io");
+	if (!_io_queue) {
+		DMERR("couldn't create kcryptd io queue");
+		return -ENOMEM;
+	}
+
+	_crypt_queue = create_singlethread_workqueue("kcryptd");
+	if (!_crypt_queue) {
+		DMERR("couldn't create kcryptd queue");
+		destroy_workqueue(_io_queue);
+		return -ENOMEM;
+	}
+#endif
+
 	_crypt_io_pool = KMEM_CACHE(dm_crypt_io, 0);
 	if (!_crypt_io_pool)
 		return -ENOMEM;
@@ -1416,6 +1448,10 @@ static void __exit dm_crypt_exit(void)
 {
 	dm_unregister_target(&crypt_target);
 	kmem_cache_destroy(_crypt_io_pool);
+#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
+	destroy_workqueue(_io_queue);
+	destroy_workqueue(_crypt_queue);
+#endif
 }
 
 module_init(dm_crypt_init);
-- 
1.7.0.1
