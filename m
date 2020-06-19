From: Ignat Korchagin <ignat@cloudflare.com>
Subject: [RFC PATCH 1/1] Add DM_CRYPT_FORCE_INLINE flag to dm-crypt target
Date: Fri, 19 Jun 2020 17:41:32 +0100
Message-ID: <20200619164132.1648-2-ignat@cloudflare.com>
References: <20200619164132.1648-1-ignat@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200619164132.1648-1-ignat@cloudflare.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de, linux-kernel@vger.kernel.org
Cc: Ignat Korchagin <ignat@cloudflare.com>, kernel-team@cloudflare.com
List-Id: dm-devel.ids

Sometimes extra thread offloading imposed by dm-crypt hurts IO latency. This is
especially visible on busy systems with many processes/threads. Moreover, most
Crypto API implementaions are async, that is they offload crypto operations on
their own, so this dm-crypt offloading is excessive.

This adds a new flag, which directs dm-crypt not to offload crypto operations
and process everything inline. For cases, where crypto operations cannot happen
inline (hard interrupt context, for example the read path of the NVME driver),
we offload the work to a tasklet rather than a workqueue.

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 55 +++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 000ddfab5ba0..5a9bac4fdffb 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -69,6 +69,7 @@ struct dm_crypt_io {
 	u8 *integrity_metadata;
 	bool integrity_metadata_from_pool;
 	struct work_struct work;
+	struct tasklet_struct tasklet;
 
 	struct convert_context ctx;
 
@@ -127,7 +128,7 @@ struct iv_elephant_private {
  * and encrypts / decrypts at the same time.
  */
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
-	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
+	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD, DM_CRYPT_FORCE_INLINE = (sizeof(unsigned long) * 8 - 1) };
 
 enum cipher_flags {
 	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */
@@ -1458,13 +1459,18 @@ static void crypt_alloc_req_skcipher(struct crypt_config *cc,
 
 	skcipher_request_set_tfm(ctx->r.req, cc->cipher_tfm.tfms[key_index]);
 
-	/*
-	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
-	 * requests if driver request queue is full.
-	 */
-	skcipher_request_set_callback(ctx->r.req,
-	    CRYPTO_TFM_REQ_MAY_BACKLOG,
-	    kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
+	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))
+		/* make sure we zero important fields of the request */
+		skcipher_request_set_callback(ctx->r.req,
+	        0, NULL, NULL);
+	else
+		/*
+		 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
+		 * requests if driver request queue is full.
+		 */
+		skcipher_request_set_callback(ctx->r.req,
+	        CRYPTO_TFM_REQ_MAY_BACKLOG,
+	        kcryptd_async_done, dmreq_of_req(cc, ctx->r.req));
 }
 
 static void crypt_alloc_req_aead(struct crypt_config *cc,
@@ -1566,7 +1572,8 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 			atomic_dec(&ctx->cc_pending);
 			ctx->cc_sector += sector_step;
 			tag_offset++;
-			cond_resched();
+			if (!test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))
+				cond_resched();
 			continue;
 		/*
 		 * There was a data integrity error.
@@ -1892,6 +1899,11 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
+	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags)) {
+		generic_make_request(clone);
+		return;
+	}
+
 	if (likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) {
 		generic_make_request(clone);
 		return;
@@ -2031,12 +2043,26 @@ static void kcryptd_crypt(struct work_struct *work)
 		kcryptd_crypt_write_convert(io);
 }
 
+static void kcryptd_crypt_tasklet(unsigned long work)
+{
+	kcryptd_crypt((struct work_struct *)work);
+}
+
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 
-	INIT_WORK(&io->work, kcryptd_crypt);
-	queue_work(cc->crypt_queue, &io->work);
+	if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags)) {
+		if (in_irq()) {
+			/* Crypto API will fail hard in hard IRQ context */
+			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
+			tasklet_schedule(&io->tasklet);
+		} else
+			kcryptd_crypt(&io->work);
+	} else {
+		INIT_WORK(&io->work, kcryptd_crypt);
+		queue_work(cc->crypt_queue, &io->work);
+	}
 }
 
 static void crypt_free_tfms_aead(struct crypt_config *cc)
@@ -2838,7 +2864,7 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 	struct crypt_config *cc = ti->private;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 6, "Invalid number of feature args"},
+		{0, 7, "Invalid number of feature args"},
 	};
 	unsigned int opt_params, val;
 	const char *opt_string, *sval;
@@ -2868,6 +2894,8 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 
 		else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))
 			set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
+		else if (!strcasecmp(opt_string, "force_inline"))
+			set_bit(DM_CRYPT_FORCE_INLINE, &cc->flags);
 		else if (sscanf(opt_string, "integrity:%u:", &val) == 1) {
 			if (val == 0 || val > MAX_TAG_SIZE) {
 				ti->error = "Invalid integrity arguments";
@@ -3196,6 +3224,7 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 		num_feature_args += !!ti->num_discard_bios;
 		num_feature_args += test_bit(DM_CRYPT_SAME_CPU, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
+		num_feature_args += test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags);
 		num_feature_args += cc->sector_size != (1 << SECTOR_SHIFT);
 		num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
 		if (cc->on_disk_tag_size)
@@ -3208,6 +3237,8 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 				DMEMIT(" same_cpu_crypt");
 			if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))
 				DMEMIT(" submit_from_crypt_cpus");
+			if (test_bit(DM_CRYPT_FORCE_INLINE, &cc->flags))
+				DMEMIT(" force_inline");
 			if (cc->on_disk_tag_size)
 				DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);
 			if (cc->sector_size != (1 << SECTOR_SHIFT))
-- 
2.20.1
