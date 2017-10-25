From: yaeceh01 <yael.chemla@foss.arm.com>
Subject: [PATCH] md: dm-verity: aggregate crypto API calls
Date: Wed, 25 Oct 2017 09:26:19 +0100
Message-ID: <1508919979-23641-1-git-send-email-yael.chemla@foss.arm.com>
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
Cc: Yael Chemla <yael.chemla@foss.arm.com>
List-Id: dm-devel.ids

From: Yael Chemla <yael.chemla@foss.arm.com>

Current implementation makes multiple crypto API calls for a single
block, forcing underlying crypto tfm implementation to "stop & go",
leading to under utilization of CPU (e.g. SIMD state saves) or HW
engines. To fix it unify calls to crypto init/update/final into a digest
call with a single sg which contains multiple buffers.

This also opens the way later on to parallelizing the work on different
blocks.

Tested on physical Arm 32 and x86_64 and virtual ARM 64.

Performance numbers were not changed.

Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
---
 drivers/md/dm-verity-target.c | 226 +++++++++++++++++++++++++-----------------
 1 file changed, 137 insertions(+), 89 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bda3caca23ca..c8758443ef64 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -35,10 +35,18 @@
 
 #define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC)
 
+/* only two elements in static scatter list: salt and data */
+#define SG_FIXED_ITEMS	2
+
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
 
+enum salt_location {
+	START_SG,
+	END_SG
+};
+
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
@@ -133,80 +141,67 @@ static inline int verity_complete_op(struct verity_result *res, int ret)
 	return ret;
 }
 
-static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
-				const u8 *data, size_t len,
-				struct verity_result *res)
-{
-	struct scatterlist sg;
-
-	sg_init_one(&sg, data, len);
-	ahash_request_set_crypt(req, &sg, NULL, len);
-
-	return verity_complete_op(res, crypto_ahash_update(req));
-}
-
 /*
- * Wrapper for crypto_ahash_init, which handles verity salting.
+ * verity_is_salt_required - check if according to verity version and
+ * verity salt's size there's a need to insert a salt.
+ * note: verity's version indicates where the salt should be added.
+ * (before or after buffer)
+ * @where - START_SG - before buffer / END_SG - after buffer
  */
-static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
-				struct verity_result *res)
+static inline bool verity_is_salt_required(struct dm_verity *v,
+		enum salt_location where)
 {
-	int r;
-
-	ahash_request_set_tfm(req, v->tfm);
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
-					CRYPTO_TFM_REQ_MAY_BACKLOG,
-					verity_op_done, (void *)res);
-	init_completion(&res->completion);
-
-	r = verity_complete_op(res, crypto_ahash_init(req));
-
-	if (unlikely(r < 0)) {
-		DMERR("crypto_ahash_init failed: %d", r);
-		return r;
+	if (likely(v->salt_size) &&
+	    ((where == START_SG && likely(v->version >= 1)) ||
+	    (where == END_SG && unlikely(!v->version)))) {
+		return true;
 	}
-
-	if (likely(v->salt_size && (v->version >= 1)))
-		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
-
-	return r;
+	return false;
 }
 
-static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
-			     u8 *digest, struct verity_result *res)
+/*
+ * verity_add_salt - add verity's salt into a scatterlist
+ * @nents - number of elements already inserted into sg
+ * @total_len - total number of items in scatterlist array
+ */
+static void verity_add_salt(struct dm_verity *v, struct scatterlist *sg,
+	unsigned int *nents, unsigned int *total_len)
 {
-	int r;
-
-	if (unlikely(v->salt_size && (!v->version))) {
-		r = verity_hash_update(v, req, v->salt, v->salt_size, res);
-
-		if (r < 0) {
-			DMERR("verity_hash_final failed updating salt: %d", r);
-			goto out;
-		}
-	}
-
-	ahash_request_set_crypt(req, NULL, digest, 0);
-	r = verity_complete_op(res, crypto_ahash_final(req));
-out:
-	return r;
+	sg_set_buf(&sg[*nents], v->salt, v->salt_size);
+	(*nents)++;
+	(*total_len) += v->salt_size;
 }
 
 int verity_hash(struct dm_verity *v, struct ahash_request *req,
 		const u8 *data, size_t len, u8 *digest)
 {
-	int r;
+	int r, total_len = 0, indx = 0;
 	struct verity_result res;
+	struct scatterlist sg[SG_FIXED_ITEMS];
 
-	r = verity_hash_init(v, req, &res);
-	if (unlikely(r < 0))
-		goto out;
+	sg_init_table(sg, SG_FIXED_ITEMS);
+	ahash_request_set_tfm(req, v->tfm);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
+					CRYPTO_TFM_REQ_MAY_BACKLOG,
+					verity_op_done, (void *)&res);
+	if (verity_is_salt_required(v, START_SG) == true)
+		verity_add_salt(v, sg, &indx, &total_len);
 
-	r = verity_hash_update(v, req, data, len, &res);
-	if (unlikely(r < 0))
-		goto out;
+	sg_set_buf(&sg[indx], data, len);
+	indx++;
+	total_len += len;
+	if (verity_is_salt_required(v, END_SG) == true)
+		verity_add_salt(v, sg, &indx, &total_len);
+
+	ahash_request_set_crypt(req, sg, digest, len+v->salt_size);
+	init_completion(&res.completion);
 
-	r = verity_hash_final(v, req, digest, &res);
+	r = verity_complete_op(&res, crypto_ahash_digest(req));
+
+	if (unlikely(r < 0)) {
+		DMERR("ahash_request_set_crypt failed: %d", r);
+		goto out;
+	}
 
 out:
 	return r;
@@ -389,20 +384,17 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
  * Calculates the digest for the given bio
  */
 int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
-			struct bvec_iter *iter, struct verity_result *res)
+		struct bvec_iter *iter, struct verity_result *res,
+		struct scatterlist *sg, unsigned int *nents,
+		unsigned int *total_len)
 {
 	unsigned int todo = 1 << v->data_dev_block_bits;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
-	struct scatterlist sg;
-	struct ahash_request *req = verity_io_hash_req(v, io);
 
 	do {
-		int r;
 		unsigned int len;
 		struct bio_vec bv = bio_iter_iovec(bio, *iter);
 
-		sg_init_table(&sg, 1);
-
 		len = bv.bv_len;
 
 		if (likely(len >= todo))
@@ -412,22 +404,43 @@ int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
 		 * until you consider the typical block size is 4,096B.
 		 * Going through this loops twice should be very rare.
 		 */
-		sg_set_page(&sg, bv.bv_page, len, bv.bv_offset);
-		ahash_request_set_crypt(req, &sg, NULL, len);
-		r = verity_complete_op(res, crypto_ahash_update(req));
-
-		if (unlikely(r < 0)) {
-			DMERR("verity_for_io_block crypto op failed: %d", r);
-			return r;
-		}
+		sg_set_page(&sg[*nents], bv.bv_page, len, bv.bv_offset);
 
 		bio_advance_iter(bio, iter, len);
 		todo -= len;
+		(*nents)++;
+		(*total_len) += len;
 	} while (todo);
 
 	return 0;
 }
 
+/* calculate how many buffers required to accomudate bio_vec starting
+ * from iter
+ */
+unsigned int verity_calc_buffs_for_bv(struct dm_verity *v,
+	struct dm_verity_io *io, struct bvec_iter iter)
+{
+	unsigned int todo = 1 << v->data_dev_block_bits;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
+	unsigned int buff_count = 0;
+
+	do {
+		unsigned int len;
+		struct bio_vec bv = bio_iter_iovec(bio, iter);
+
+		len = bv.bv_len;
+		if (likely(len >= todo))
+			len = todo;
+
+		bio_advance_iter(bio, &iter, len);
+		todo -= len;
+		buff_count++;
+	} while (todo);
+
+	return buff_count;
+}
+
 /*
  * Calls function process for 1 << v->data_dev_block_bits bytes in the bio_vec
  * starting from iter.
@@ -483,16 +496,30 @@ static int verity_verify_io(struct dm_verity_io *io)
 	struct bvec_iter start;
 	unsigned b;
 	struct verity_result res;
+	struct scatterlist *sg;
+	int r;
 
 	for (b = 0; b < io->n_blocks; b++) {
-		int r;
+		unsigned int nents;
+		unsigned int total_len = 0;
+		unsigned int num_of_buffs = 0;
 		struct ahash_request *req = verity_io_hash_req(v, io);
 
+		/* an extra one for the salt buffer */
+		num_of_buffs = verity_calc_buffs_for_bv(v, io, io->iter) + 1;
+		WARN_ON(num_of_buffs < 1);
+
+		sg = kmalloc_array(num_of_buffs, sizeof(struct scatterlist),
+				     GFP_KERNEL);
+		if (!sg)
+			return -ENOMEM;
+		sg_init_table(sg, num_of_buffs);
+
 		r = verity_hash_for_block(v, io, io->block + b,
 					  verity_io_want_digest(v, io),
 					  &is_zero);
 		if (unlikely(r < 0))
-			return r;
+			goto err_memfree;
 
 		if (is_zero) {
 			/*
@@ -502,37 +529,58 @@ static int verity_verify_io(struct dm_verity_io *io)
 			r = verity_for_bv_block(v, io, &io->iter,
 						verity_bv_zero);
 			if (unlikely(r < 0))
-				return r;
+				goto err_memfree;
 
 			continue;
 		}
 
-		r = verity_hash_init(v, req, &res);
-		if (unlikely(r < 0))
-			return r;
+		ahash_request_set_tfm(req, v->tfm);
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
+						CRYPTO_TFM_REQ_MAY_BACKLOG,
+						verity_op_done, (void *)&res);
 
-		start = io->iter;
-		r = verity_for_io_block(v, io, &io->iter, &res);
-		if (unlikely(r < 0))
-			return r;
+		nents = 0;
+		total_len = 0;
+		if (verity_is_salt_required(v, START_SG) == true)
+			verity_add_salt(v, sg, &nents, &total_len);
 
-		r = verity_hash_final(v, req, verity_io_real_digest(v, io),
-					&res);
-		if (unlikely(r < 0))
-			return r;
+		start = io->iter;
+		verity_for_io_block(v, io, &io->iter, &res, sg, &nents,
+				&total_len);
+		if (verity_is_salt_required(v, END_SG) == true)
+			verity_add_salt(v, sg, &nents, &total_len);
+		/*
+		 * need to mark end of chain, since we might have allocated
+		 * more than we actually use
+		 */
+		sg_mark_end(&sg[nents-1]);
 
+		ahash_request_set_crypt(req, sg, verity_io_real_digest(v, io),
+				total_len);
+		init_completion(&res.completion);
+		r = verity_complete_op(&res, crypto_ahash_digest(req));
+		kfree(sg);
+		if (unlikely(r < 0)) {
+			DMERR("crypto_ahash_digest failed: %d", r);
+			goto err_memfree;
+		}
 		if (likely(memcmp(verity_io_real_digest(v, io),
-				  verity_io_want_digest(v, io), v->digest_size) == 0))
+		    verity_io_want_digest(v, io), v->digest_size) == 0))
 			continue;
 		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
 					   io->block + b, NULL, &start) == 0)
 			continue;
 		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-					   io->block + b))
-			return -EIO;
+					   io->block + b)) {
+			goto err_memfree;
+		}
 	}
 
 	return 0;
+
+err_memfree:
+	kfree(sg);
+	return r;
 }
 
 /*
-- 
2.11.0
