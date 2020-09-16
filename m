From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: [RFC PATCH 2/2] dm crypt: Handle unaligned bio buffer
	lengths for lmk and tcw
Date: Wed, 16 Sep 2020 18:40:06 +0000
Message-ID: <1600281606-1446-3-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: shirley.ma@oracle.com, ssudhakarp@gmail.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

Us sg_miter_* apis to process unaligned buffer lengths while handling
bio buffers for lmk and tcw IV generation algorithms.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/md/dm-crypt.c | 104 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 36 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9c26ad08732f..c40ada41d8ef 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -471,11 +471,13 @@ static int crypt_iv_lmk_wipe(struct crypt_config *cc)
 
 static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq,
-			    u8 *data)
+			    struct scatterlist *sg)
 {
 	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
 	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
+	struct sg_mapping_iter miter;
 	struct md5_state md5state;
+	size_t len = 16 * 31;
 	__le32 buf[4];
 	int i, r;
 
@@ -492,7 +494,19 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 	}
 
 	/* Sector is always 512B, block size 16, add data of blocks 1-31 */
-	r = crypto_shash_update(desc, data + 16, 16 * 31);
+	sg_miter_start(&miter, sg, sg_nents(sg),
+		       SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	sg_miter_skip(&miter, 16);
+	while (sg_miter_next(&miter) && len > 0) {
+		size_t hash_len = min_t(size_t, miter.length, len);
+
+		r = crypto_shash_update(desc, miter.addr, hash_len);
+		if (r)
+			break;
+		len -= hash_len;
+	}
+	sg_miter_stop(&miter);
+
 	if (r)
 		return r;
 
@@ -520,15 +534,11 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
-	struct scatterlist *sg;
-	u8 *src;
 	int r = 0;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE) {
-		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_lmk_one(cc, iv, dmreq, src + sg->offset);
-		kunmap_atomic(src);
+		r = crypt_iv_lmk_one(cc, iv, dmreq,
+				     crypt_get_sg_data(cc, dmreq->sg_in));
 	} else
 		memset(iv, 0, cc->iv_size);
 
@@ -538,22 +548,32 @@ static int crypt_iv_lmk_gen(struct crypt_config *cc, u8 *iv,
 static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 			     struct dm_crypt_request *dmreq)
 {
+	struct sg_mapping_iter miter;
 	struct scatterlist *sg;
-	u8 *dst;
-	int r;
+	int r, offset = 0;
+	size_t len;
 
 	if (bio_data_dir(dmreq->ctx->bio_in) == WRITE)
 		return 0;
 
 	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_lmk_one(cc, iv, dmreq, dst + sg->offset);
+	r = crypt_iv_lmk_one(cc, iv, dmreq, sg);
+	if (r)
+		return r;
 
 	/* Tweak the first block of plaintext sector */
-	if (!r)
-		crypto_xor(dst + sg->offset, iv, cc->iv_size);
+	len = cc->iv_size;
+	sg_miter_start(&miter, sg, sg_nents(sg),
+		       SG_MITER_ATOMIC | SG_MITER_TO_SG);
+	while (sg_miter_next(&miter) && len > 0) {
+		size_t xor_len = min_t(size_t, miter.length, len);
+
+		crypto_xor(miter.addr, iv + offset, xor_len);
+		len -= xor_len;
+		offset += xor_len;
+	}
+	sg_miter_stop(&miter);
 
-	kunmap_atomic(dst);
 	return r;
 }
 
@@ -627,12 +647,14 @@ static int crypt_iv_tcw_wipe(struct crypt_config *cc)
 
 static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 				  struct dm_crypt_request *dmreq,
-				  u8 *data)
+				  struct scatterlist *sg)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 	__le64 sector = cpu_to_le64(dmreq->iv_sector);
+	struct sg_mapping_iter miter;
 	u8 buf[TCW_WHITENING_SIZE];
 	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
+	size_t remain, sgoffset = 0;
 	int i, r;
 
 	/* xor whitening with sector number */
@@ -656,8 +678,31 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	crypto_xor(&buf[4], &buf[8], 4);
 
 	/* apply whitening (8 bytes) to whole sector */
-	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
-		crypto_xor(data + i * 8, buf, 8);
+	sg_miter_start(&miter, sg, sg_nents(sg),
+		       SG_MITER_ATOMIC | SG_MITER_TO_SG);
+	sg_miter_next(&miter);
+	remain = miter.length;
+	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++) {
+		size_t len = 8, offset = 0;
+
+		while (len > 0) {
+			size_t xor_len = min_t(size_t, remain, len);
+
+			crypto_xor(miter.addr + sgoffset, buf + offset,
+				   xor_len);
+			len -= xor_len;
+			remain -= xor_len;
+			offset += xor_len;
+			sgoffset += xor_len;
+			if (remain == 0) {
+				sg_miter_next(&miter);
+				sgoffset = 0;
+				remain = miter.length;
+			}
+		}
+	}
+	sg_miter_stop(&miter);
+
 out:
 	memzero_explicit(buf, sizeof(buf));
 	return r;
@@ -666,19 +711,14 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
-	struct scatterlist *sg;
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 	__le64 sector = cpu_to_le64(dmreq->iv_sector);
-	u8 *src;
 	int r = 0;
 
 	/* Remove whitening from ciphertext */
-	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
-		sg = crypt_get_sg_data(cc, dmreq->sg_in);
-		src = kmap_atomic(sg_page(sg));
-		r = crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
-		kunmap_atomic(src);
-	}
+	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
+		r = crypt_iv_tcw_whitening(cc, dmreq,
+					   crypt_get_sg_data(cc, dmreq->sg_in));
 
 	/* Calculate IV */
 	crypto_xor_cpy(iv, tcw->iv_seed, (u8 *)&sector, 8);
@@ -692,20 +732,12 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 			     struct dm_crypt_request *dmreq)
 {
-	struct scatterlist *sg;
-	u8 *dst;
-	int r;
-
 	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
 		return 0;
 
 	/* Apply whitening on ciphertext */
-	sg = crypt_get_sg_data(cc, dmreq->sg_out);
-	dst = kmap_atomic(sg_page(sg));
-	r = crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
-	kunmap_atomic(dst);
-
-	return r;
+	return crypt_iv_tcw_whitening(cc, dmreq,
+				      crypt_get_sg_data(cc, dmreq->sg_out));
 }
 
 static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
-- 
1.8.3.1
