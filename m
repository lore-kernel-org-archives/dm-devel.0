From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: [RFC PATCH 1/2] dm crypt: Allow unaligned bio buffer
	lengths for skcipher devices
Date: Wed, 16 Sep 2020 18:40:05 +0000
Message-ID: <1600281606-1446-2-git-send-email-sudhakar.panneerselvam@oracle.com>
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

crypt_convert_block_skcipher() rejects the I/O if the buffer length is
not a multiple of its sector size. This assumption holds true as long
as the originator of the I/Os are within Linux. But, in a QEMU
environment, with windows as guests that uses vhost-scsi interface, it
was observed that block layer could receive bio requests whose individual
buffer lengths may not be aligned at the sector size all the time. This
results in windows guest failing to boot or failing to format the block
devices that are backed by dm-crypt.

Not all low level block drivers require that the dma alignment to be a
multiple of 512 bytes. Some of the LLDs that has much relaxed constraint
on the buffer alignment are iSCSI, NVMe, SBP, MegaRaid, qla2xxx. Hence,
assuming the buffer lengths to be aligned to its sector size and based
on that rejecting the I/Os doesn't appear to be correct.

crypt_map() already ensures that the I/Os are always a multiple of its
sector size, hence, by the time the I/O reaches
crypt_convert_block_skcipher() and finds the data associated with the
sector is not fully in the same bio vector means that it could just be
that the sector data is scattered across two bio vectors. Hence, this
patch removes the buffer length check and adds the code that prepares
the sg list appropriately in case sector data is split between two bio
vectors.

With this change, windows was successfully be able to boot from a block
device that is backed by dm-crypt device in a QEMU environment.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/md/dm-crypt.c | 50 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 380386c36921..9c26ad08732f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1275,6 +1275,23 @@ static void *iv_tag_from_dmreq(struct crypt_config *cc,
 	return tag_from_dmreq(cc, dmreq) + cc->integrity_tag_size;
 }
 
+static int build_split_sg(struct scatterlist *sg, struct bio_vec *bvec,
+			  struct bio *bio, struct bvec_iter *iter,
+			  unsigned short int sector_size)
+{
+	int bytes_first_page;
+
+	bytes_first_page = bvec->bv_len;
+	sg_set_page(sg, bvec->bv_page, bvec->bv_len, bvec->bv_offset);
+	bio_advance_iter(bio, iter, bvec->bv_len);
+	*bvec = bio_iter_iovec(bio, *iter);
+	sg++;
+	sg_set_page(sg, bvec->bv_page, sector_size - bytes_first_page,
+		    bvec->bv_offset);
+
+	return bytes_first_page;
+}
+
 static int crypt_convert_block_aead(struct crypt_config *cc,
 				     struct convert_context *ctx,
 				     struct aead_request *req,
@@ -1379,15 +1396,12 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
 	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
 	struct scatterlist *sg_in, *sg_out;
+	int src_split = 0, dst_split = 0;
 	struct dm_crypt_request *dmreq;
 	u8 *iv, *org_iv, *tag_iv;
 	__le64 *sector;
 	int r = 0;
 
-	/* Reject unexpected unaligned bio. */
-	if (unlikely(bv_in.bv_len & (cc->sector_size - 1)))
-		return -EIO;
-
 	dmreq = dmreq_of_req(cc, req);
 	dmreq->iv_sector = ctx->cc_sector;
 	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
@@ -1407,11 +1421,25 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	sg_in  = &dmreq->sg_in[0];
 	sg_out = &dmreq->sg_out[0];
 
-	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
+	if (unlikely(bv_in.bv_len < cc->sector_size)) {
+		sg_init_table(sg_in, 2);
+		src_split = build_split_sg(sg_in, &bv_in, ctx->bio_in,
+					   &ctx->iter_in, cc->sector_size);
+	} else {
+		sg_init_table(sg_in, 1);
+		sg_set_page(sg_in, bv_in.bv_page, cc->sector_size,
+			    bv_in.bv_offset);
+	}
 
-	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
+	if (unlikely(bv_out.bv_len < cc->sector_size)) {
+		sg_init_table(sg_out, 2);
+		dst_split = build_split_sg(sg_out, &bv_out, ctx->bio_out,
+					   &ctx->iter_out, cc->sector_size);
+	} else {
+		sg_init_table(sg_out, 1);
+		sg_set_page(sg_out, bv_out.bv_page, cc->sector_size,
+			    bv_out.bv_offset);
+	}
 
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1442,8 +1470,10 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
 
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
+	bio_advance_iter(ctx->bio_in, &ctx->iter_in,
+			 cc->sector_size - src_split);
+	bio_advance_iter(ctx->bio_out, &ctx->iter_out,
+			 cc->sector_size - dst_split);
 
 	return r;
 }
-- 
1.8.3.1
