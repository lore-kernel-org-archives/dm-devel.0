From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 04/20] dm-crypt: use encryption threads
Date: Tue, 21 Aug 2012 11:09:15 +0200
Message-ID: <a13670b8a04158de91417e8c0b86d824618625b6.1345477953.git.mbroz@redhat.com>
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

Use encryption threads, one per CPU, to improve dm-crypt parallelization.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |  228 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 176 insertions(+), 52 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 144c337..cb0e26f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/crypto.h>
 #include <linux/workqueue.h>
+#include <linux/kthread.h>
 #include <linux/backing-dev.h>
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
@@ -30,6 +31,9 @@
 
 #define DM_MSG_PREFIX "crypt"
 
+#define DMREQ_PULL_BATCH			16
+#define DMREQ_PUSH_BATCH			16
+
 /*
  * context holding the current state of a multi-part conversion
  */
@@ -42,7 +46,6 @@ struct convert_context {
 	unsigned int idx_out;
 	sector_t cc_sector;
 	atomic_t cc_pending;
-	struct ablkcipher_request *req;
 };
 
 /*
@@ -62,10 +65,12 @@ struct dm_crypt_io {
 };
 
 struct dm_crypt_request {
+	struct list_head list;
 	struct convert_context *ctx;
 	struct scatterlist sg_in;
 	struct scatterlist sg_out;
 	sector_t iv_sector;
+	struct completion *busy_wait;
 };
 
 struct crypt_config;
@@ -121,6 +126,12 @@ struct crypt_config {
 
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
+	unsigned crypt_threads_size;
+	struct task_struct **crypt_threads;
+
+	wait_queue_head_t crypt_thread_wait;
+	spinlock_t crypt_thread_spinlock;
+	struct list_head crypt_thread_list;
 
 	char *cipher;
 	char *cipher_string;
@@ -656,9 +667,80 @@ static u8 *iv_of_dmreq(struct crypt_config *cc,
 		crypto_ablkcipher_alignmask(any_tfm(cc)) + 1);
 }
 
+static void kcryptd_async_done(struct crypto_async_request *async_req,
+			       int error);
+
+static int dmcrypt_thread(void *data)
+{
+	struct crypt_config *cc = data;
+	while (1) {
+		struct dm_crypt_request *dmreqs[DMREQ_PULL_BATCH];
+		unsigned n_dmreqs;
+		unsigned i;
+
+		DECLARE_WAITQUEUE(wait, current);
+
+		spin_lock(&cc->crypt_thread_spinlock);
+
+		if (!list_empty(&cc->crypt_thread_list))
+			goto pop_from_list;
+
+		__set_current_state(TASK_INTERRUPTIBLE);
+		add_wait_queue(&cc->crypt_thread_wait, &wait);
+
+		spin_unlock(&cc->crypt_thread_spinlock);
+
+		if (unlikely(kthread_should_stop())) {
+			set_task_state(current, TASK_RUNNING);
+			remove_wait_queue(&cc->crypt_thread_wait, &wait);
+			break;
+		}
+
+		schedule();
+
+		set_task_state(current, TASK_RUNNING);
+		remove_wait_queue(&cc->crypt_thread_wait, &wait);
+		continue;
+
+pop_from_list:
+		n_dmreqs = 0;
+		do {
+			struct dm_crypt_request *dmreq = container_of(
+						cc->crypt_thread_list.next,
+						struct dm_crypt_request, list);
+			list_del(&dmreq->list);
+			dmreqs[n_dmreqs++] = dmreq;
+		} while (n_dmreqs < DMREQ_PULL_BATCH &&
+			 !list_empty(&cc->crypt_thread_list));
+		spin_unlock(&cc->crypt_thread_spinlock);
+
+		i = 0;
+		do {
+			struct dm_crypt_request *dmreq = dmreqs[i];
+			struct ablkcipher_request *req = req_of_dmreq(cc, dmreq);
+			int r;
+			DECLARE_COMPLETION(busy_wait);
+			dmreq->busy_wait = &busy_wait;
+			if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
+				r = crypto_ablkcipher_encrypt(req);
+			else
+				r = crypto_ablkcipher_decrypt(req);
+			if (unlikely(r == -EBUSY)) {
+				wait_for_completion(&busy_wait);
+			} else if (likely(r != -EINPROGRESS)) {
+				struct crypto_async_request as_rq;
+				as_rq.data = dmreq;
+				kcryptd_async_done(&as_rq, r);
+			}
+		} while (++i < n_dmreqs);
+	}
+	return 0;
+}
+
 static int crypt_convert_block(struct crypt_config *cc,
 			       struct convert_context *ctx,
-			       struct ablkcipher_request *req)
+			       struct ablkcipher_request *req,
+			       struct list_head *batch)
 {
 	struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
 	struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
@@ -700,32 +782,34 @@ static int crypt_convert_block(struct crypt_config *cc,
 	ablkcipher_request_set_crypt(req, &dmreq->sg_in, &dmreq->sg_out,
 				     1 << SECTOR_SHIFT, iv);
 
-	if (bio_data_dir(ctx->bio_in) == WRITE)
-		r = crypto_ablkcipher_encrypt(req);
-	else
-		r = crypto_ablkcipher_decrypt(req);
-
-	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
-		r = cc->iv_gen_ops->post(cc, iv, dmreq);
-
-	return r;
+	list_add_tail(&dmreq->list, batch);
+ 
+	return 0;
 }
 
-static void kcryptd_async_done(struct crypto_async_request *async_req,
-			       int error);
-
-static void crypt_alloc_req(struct crypt_config *cc,
-			    struct convert_context *ctx)
+static struct ablkcipher_request *crypt_alloc_req(struct crypt_config *cc,
+			    struct convert_context *ctx, gfp_t gfp_mask)
 {
 	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
+	struct ablkcipher_request *req = mempool_alloc(cc->req_pool, gfp_mask);
+	if (!req)
+		return NULL;
 
-	if (!ctx->req)
-		ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
-
-	ablkcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
-	ablkcipher_request_set_callback(ctx->req,
+	ablkcipher_request_set_tfm(req, cc->tfms[key_index]);
+	ablkcipher_request_set_callback(req,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-	    kcryptd_async_done, dmreq_of_req(cc, ctx->req));
+	    kcryptd_async_done, dmreq_of_req(cc, req));
+
+	return req;
+}
+
+static void crypt_flush_batch(struct crypt_config *cc, struct list_head *batch)
+{
+	spin_lock(&cc->crypt_thread_spinlock);
+	list_splice_tail(batch, &cc->crypt_thread_list);
+	spin_unlock(&cc->crypt_thread_spinlock);
+	wake_up_all(&cc->crypt_thread_wait);
+	INIT_LIST_HEAD(batch);
 }
 
 /*
@@ -735,42 +819,46 @@ static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
 	int r;
+	LIST_HEAD(batch);
+	unsigned batch_count = 0;
 
 	atomic_set(&ctx->cc_pending, 1);
 
 	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 
-		crypt_alloc_req(cc, ctx);
+		struct ablkcipher_request *req = crypt_alloc_req(cc, ctx, GFP_NOWAIT);
+		if (!req) {
+			/*
+			 * We must flush our request queue before we attempt
+			 * non-failing GFP_NOIO allocation.
+			 */
+			batch_count = 0;
+			crypt_flush_batch(cc, &batch);
+			req = crypt_alloc_req(cc, ctx, GFP_NOIO);
+		}
 
 		atomic_inc(&ctx->cc_pending);
 
-		r = crypt_convert_block(cc, ctx, ctx->req);
-
-		switch (r) {
-		/* async */
-		case -EBUSY:
-			/* fall through*/
-		case -EINPROGRESS:
-			ctx->req = NULL;
-			ctx->cc_sector++;
-			continue;
-
-		/* sync */
-		case 0:
+		r = crypt_convert_block(cc, ctx, req, &batch);
+		if (unlikely(r < 0)) {
 			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector++;
-			cond_resched();
-			continue;
+			goto flush_ret;
+		}
 
-		/* error */
-		default:
-			atomic_dec(&ctx->cc_pending);
-			return r;
+		ctx->sector++;
+
+		if (unlikely(++batch_count >= DMREQ_PUSH_BATCH)) {
+			batch_count = 0;
+			crypt_flush_batch(cc, &batch);
 		}
 	}
+	r = 0;
 
-	return 0;
+flush_ret:
+	crypt_flush_batch(cc, &batch);
+
+	return r;
 }
 
 static void dm_crypt_bio_destructor(struct bio *bio)
@@ -860,7 +948,6 @@ static struct dm_crypt_io *crypt_io_alloc(struct crypt_config *cc,
 	io->sector = sector;
 	io->error = 0;
 	io->base_io = NULL;
-	io->ctx.req = NULL;
 	atomic_set(&io->io_pending, 0);
 
 	return io;
@@ -886,8 +973,6 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
-	if (io->ctx.req)
-		mempool_free(io->ctx.req, cc->req_pool);
 	mempool_free(io, cc->io_pool);
 
 	if (likely(!base_io))
@@ -1163,6 +1248,7 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	struct crypt_config *cc = io->cc;
 
 	if (error == -EINPROGRESS) {
+		complete(dmreq->busy_wait);
 		return;
 	}
 
@@ -1338,6 +1424,15 @@ static void crypt_dtr(struct dm_target *ti)
 	if (!cc)
 		return;
 
+	if (cc->crypt_threads) {
+		int i;
+		for (i = 0; i < cc->crypt_threads_size; i++) {
+			if (cc->crypt_threads[i])
+				kthread_stop(cc->crypt_threads[i]);
+		}
+		kfree(cc->crypt_threads);
+	}
+
 	if (cc->io_queue)
 		destroy_workqueue(cc->io_queue);
 	if (cc->crypt_queue)
@@ -1529,7 +1624,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct crypt_config *cc;
 	unsigned int key_size, opt_params;
 	unsigned long long tmpll;
-	int ret;
+	int i, ret;
 	struct dm_arg_set as;
 	const char *opt_string;
 	char dummy;
@@ -1643,15 +1738,44 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	cc->crypt_queue = alloc_workqueue("kcryptd",
 					  WQ_NON_REENTRANT|
-					  WQ_CPU_INTENSIVE|
-					  WQ_MEM_RECLAIM|
-					  WQ_UNBOUND,
-					  num_online_cpus());
+					  WQ_MEM_RECLAIM,
+					  1);
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
 	}
 
+	for (i = 0; i < NR_CPUS; i++)
+		if (cpu_online(i))
+			cc->crypt_threads_size = i + 1;
+
+	init_waitqueue_head(&cc->crypt_thread_wait);
+	spin_lock_init(&cc->crypt_thread_spinlock);
+	INIT_LIST_HEAD(&cc->crypt_thread_list);
+
+	cc->crypt_threads = kzalloc(cc->crypt_threads_size *
+				    sizeof(struct task_struct *), GFP_KERNEL);
+	if (!cc->crypt_threads) {
+		ti->error = "Couldn't allocate crypt threads";
+		goto bad;
+	}
+
+	for (i = 0; i < cc->crypt_threads_size; i++) {
+		if (cpu_online(i)) {
+			cc->crypt_threads[i] = kthread_create_on_node(
+				dmcrypt_thread, cc, cpu_to_node(i),
+				"dmcryptd/%d", i);
+			if (IS_ERR(cc->crypt_threads[i])) {
+				ret = PTR_ERR(cc->crypt_threads[i]);
+				cc->crypt_threads[i] = NULL;
+				ti->error = "Couldn't spawn thread";
+				goto bad;
+			}
+			kthread_bind(cc->crypt_threads[i], i);
+			wake_up_process(cc->crypt_threads[i]);
+		}
+	}
+
 	ti->num_flush_requests = 1;
 	ti->discard_zeroes_data_unsupported = true;
 
-- 
1.7.10.4
