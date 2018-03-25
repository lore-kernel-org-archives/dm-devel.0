From: Yael Chemla <yael.chemla@foss.arm.com>
Subject: [PATCH 1/2] md: dm-verity: aggregate crypto API calls
Date: Sun, 25 Mar 2018 19:41:29 +0100
Message-ID: <1522003290-27243-1-git-send-email-yael.chemla@foss.arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, ofir.drang@gmail.com, Yael Chemla <yael.chemla@arm.com>
Cc: Yael Chemla <yael.chemla@foss.arm.com>
List-Id: dm-devel.ids

 Current implementation makes multiple crypto API calls per block
 implementation makes multiple crypto API calls per single block, 
 forcing underlying crypto tfm implementation to "stop & go",
 leading to under utilization of HW engines.
 To fix it unify calls to crypto init/update/final into a digest call
 with a single sg which contains multiple buffers.
 This is also needed as an enabler for the next patch in the series.

 
Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
---
 drivers/md/dm-verity-target.c | 220 ++++++++++++++++++++++++------------------
 1 file changed, 127 insertions(+), 93 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index aedb822..a281b83 100644
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
@@ -92,82 +100,68 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
 	return block >> (level * v->hash_per_block_bits);
 }
 
-static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
-				const u8 *data, size_t len,
-				struct crypto_wait *wait)
-{
-	struct scatterlist sg;
-
-	sg_init_one(&sg, data, len);
-	ahash_request_set_crypt(req, &sg, NULL, len);
-
-	return crypto_wait_req(crypto_ahash_update(req), wait);
-}
-
 /*
- * Wrapper for crypto_ahash_init, which handles verity salting.
+ * verity_is_salt_required - check if according to verity version and
+ * verity salt's size if there's a need to insert a salt.
+ * note: salt goes last for 0th version and first for all others
+ * @where - START_SG - before buffer / END_SG - after buffer
  */
-static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
-				struct crypto_wait *wait)
+static inline bool verity_is_salt_required(struct dm_verity *v,
+		enum salt_location where)
 {
-	int r;
+	/* No salt, no problem */
+	if (likely(!v->salt_size))
+		return false;
 
-	ahash_request_set_tfm(req, v->tfm);
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
-					CRYPTO_TFM_REQ_MAY_BACKLOG,
-					crypto_req_done, (void *)wait);
-	crypto_init_wait(wait);
-
-	r = crypto_wait_req(crypto_ahash_init(req), wait);
-
-	if (unlikely(r < 0)) {
-		DMERR("crypto_ahash_init failed: %d", r);
-		return r;
-	}
-
-	if (likely(v->salt_size && (v->version >= 1)))
-		r = verity_hash_update(v, req, v->salt, v->salt_size, wait);
-
-	return r;
+	if (likely(v->version))
+		return (where == START_SG);
+	else
+		return (where == END_SG);
 }
 
-static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
-			     u8 *digest, struct crypto_wait *wait)
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
-		r = verity_hash_update(v, req, v->salt, v->salt_size, wait);
-
-		if (r < 0) {
-			DMERR("verity_hash_final failed updating salt: %d", r);
-			goto out;
-		}
-	}
-
-	ahash_request_set_crypt(req, NULL, digest, 0);
-	r = crypto_wait_req(crypto_ahash_final(req), wait);
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
+	struct scatterlist sg[SG_FIXED_ITEMS];
 	struct crypto_wait wait;
 
-	r = verity_hash_init(v, req, &wait);
-	if (unlikely(r < 0))
-		goto out;
+	sg_init_table(sg, SG_FIXED_ITEMS);
+	ahash_request_set_tfm(req, v->tfm);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
+					CRYPTO_TFM_REQ_MAY_BACKLOG,
+					crypto_req_done, (void *)&wait);
+	if (verity_is_salt_required(v, START_SG))
+		verity_add_salt(v, sg, &indx, &total_len);
 
-	r = verity_hash_update(v, req, data, len, &wait);
-	if (unlikely(r < 0))
-		goto out;
+	sg_set_buf(&sg[indx], data, len);
+	indx++;
+	total_len += len;
+	if (verity_is_salt_required(v, END_SG))
+		verity_add_salt(v, sg, &indx, &total_len);
 
-	r = verity_hash_final(v, req, digest, &wait);
+	ahash_request_set_crypt(req, sg, digest, len + v->salt_size);
+	crypto_init_wait(&wait);
 
-out:
+	r = crypto_wait_req(crypto_ahash_digest(req), &wait);
+
+	if (unlikely(r < 0)) {
+		DMERR("crypto_ahash_digest failed: %d", r);
+		return r;
+	}
 	return r;
 }
 
@@ -347,44 +341,54 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 /*
  * Calculates the digest for the given bio
  */
-int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
-			struct bvec_iter *iter, struct crypto_wait *wait)
+void verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
+			struct bvec_iter *iter, struct scatterlist *sg,
+			unsigned int *nents, unsigned int *total_len)
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
 			len = todo;
-		/*
-		 * Operating on a single page at a time looks suboptimal
-		 * until you consider the typical block size is 4,096B.
-		 * Going through this loops twice should be very rare.
-		 */
-		sg_set_page(&sg, bv.bv_page, len, bv.bv_offset);
-		ahash_request_set_crypt(req, &sg, NULL, len);
-		r = crypto_wait_req(crypto_ahash_update(req), wait);
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
+}
 
-	return 0;
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
 }
 
 /*
@@ -442,16 +446,30 @@ static int verity_verify_io(struct dm_verity_io *io)
 	struct bvec_iter start;
 	unsigned b;
 	struct crypto_wait wait;
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
@@ -461,25 +479,37 @@ static int verity_verify_io(struct dm_verity_io *io)
 			r = verity_for_bv_block(v, io, &io->iter,
 						verity_bv_zero);
 			if (unlikely(r < 0))
-				return r;
+				goto err_memfree;
 
 			continue;
 		}
 
-		r = verity_hash_init(v, req, &wait);
-		if (unlikely(r < 0))
-			return r;
+		ahash_request_set_tfm(req, v->tfm);
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
+					CRYPTO_TFM_REQ_MAY_BACKLOG,
+					crypto_req_done, (void *)&wait);
+		nents = 0;
+		total_len = 0;
+		if (verity_is_salt_required(v, START_SG))
+			verity_add_salt(v, sg, &nents, &total_len);
 
 		start = io->iter;
-		r = verity_for_io_block(v, io, &io->iter, &wait);
-		if (unlikely(r < 0))
-			return r;
+		verity_for_io_block(v, io, &io->iter, sg, &nents, &total_len);
+		if (verity_is_salt_required(v, END_SG))
+			verity_add_salt(v, sg, &nents, &total_len);
+		/*
+		 * need to mark end of chain, since we might have allocated
+		 * more than we actually use
+		 */
+		sg_mark_end(&sg[nents-1]);
+		ahash_request_set_crypt(req, sg, verity_io_real_digest(v, io),
+				total_len);
+		crypto_init_wait(&wait);
+		r = crypto_wait_req(crypto_ahash_digest(req), &wait);
 
-		r = verity_hash_final(v, req, verity_io_real_digest(v, io),
-					&wait);
 		if (unlikely(r < 0))
-			return r;
-
+			goto err_memfree;
+		kfree(sg);
 		if (likely(memcmp(verity_io_real_digest(v, io),
 				  verity_io_want_digest(v, io), v->digest_size) == 0))
 			continue;
@@ -492,6 +522,10 @@ static int verity_verify_io(struct dm_verity_io *io)
 	}
 
 	return 0;
+
+err_memfree:
+	kfree(sg);
+	return r;
 }
 
 /*
-- 
2.7.4
