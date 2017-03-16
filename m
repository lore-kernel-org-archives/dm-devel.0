From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 7/7] dm-crypt: optionally support larger
	encryption sector size
Date: Thu, 16 Mar 2017 15:39:44 +0100
Message-ID: <20170316143944.19843-8-gmazyland@gmail.com>
References: <20170316143944.19843-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170316143944.19843-1-gmazyland@gmail.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

This patch adds optional "sector_size"  parameter that specifies encryption
sector size (atomic unit of block device encryption).

Parameter can be in range 512 - 4096 bytes and must be power of two.
For compatibility reasons, the maximal IO must fit into the page limit,
so the limit is set to minimal page size possible (4096 bytes).

NOTE: this device cannot be handled yet with cryptsetup directly
if this parameter is set.

IV for sector is calculated from the 512 bytes sector offset
until the iv_large_sectors option is used.

Test script using dmsetup:

  DEV="/dev/sdb"
  DEV_SIZE=$(blockdev --getsz $DEV)
  KEY="9c1185a5c5e9fc54612808977ee8f548b2258d31ddadef707ba62c166051b9e3cd0294c27515f2bccee924e8823ca6e124b8fc3167ed478bca702babe4e130ac"
  BLOCK_SIZE=4096

  dmsetup create test_crypt --table "0 $DEV_SIZE crypt aes-xts-plain64 $KEY 0 $DEV 0 1 sector_size:$BLOCK_SIZE"
  #dmsetup table --showkeys test_crypt

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/device-mapper/dm-crypt.txt |  14 +++++
 drivers/md/dm-crypt.c                    | 105 ++++++++++++++++++++++++-------
 2 files changed, 96 insertions(+), 23 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 8140b71f3c54..3b3e1de21c9c 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -122,6 +122,20 @@ integrity:<bytes>:<type>
     integrity for the encrypted device. The additional space is then
     used for storing authentication tag (and persistent IV if needed).
 
+sector_size:<bytes>
+    Use <bytes> as the encryption unit instead of 512 bytes sectors.
+    This option can be in range 512 - 4096 bytes and must be power of two.
+    Virtual device will announce this size as a minimal IO and logical sector.
+
+iv_large_sectors
+   IV generators will use sector number counted in <sector_size> units
+   instead of default 512 bytes sectors.
+
+   For example, if <sector_size> is 4096 bytes, plain64 IV for the second
+   sector will be 8 (without flag) and 1 if iv_large_sectors is present.
+   The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
+   if this flag is specified.
+
 Example scripts
 ===============
 LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 270adba14717..83fa03a2e60b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -129,6 +129,7 @@ enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
 
 enum cipher_flags {
 	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */
+	CRYPT_IV_LARGE_SECTORS,		/* Calculate IV from sector_size, not 512B sectors */
 };
 
 /*
@@ -171,6 +172,7 @@ struct crypt_config {
 	} iv_gen_private;
 	sector_t iv_offset;
 	unsigned int iv_size;
+	unsigned int sector_size;
 
 	/* ESSIV: struct crypto_cipher *essiv_tfm */
 	void *iv_private;
@@ -524,6 +526,11 @@ static int crypt_iv_lmk_ctr(struct crypt_config *cc, struct dm_target *ti,
 {
 	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
 
+	if (cc->sector_size != (1 << SECTOR_SHIFT)) {
+		ti->error = "Unsupported sector size for LMK";
+		return -EINVAL;
+	}
+
 	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(lmk->hash_tfm)) {
 		ti->error = "Error initializing LMK hash";
@@ -677,6 +684,11 @@ static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 
+	if (cc->sector_size != (1 << SECTOR_SHIFT)) {
+		ti->error = "Unsupported sector size for TCW";
+		return -EINVAL;
+	}
+
 	if (cc->key_size <= (cc->iv_size + TCW_WHITENING_SIZE)) {
 		ti->error = "Wrong key size for TCW";
 		return -EINVAL;
@@ -1037,15 +1049,20 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	struct bio_vec bv_in = bio_iter_iovec(ctx->bio_in, ctx->iter_in);
 	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
 	struct dm_crypt_request *dmreq;
-	unsigned int data_len = 1 << SECTOR_SHIFT;
 	u8 *iv, *org_iv, *tag_iv, *tag;
 	uint64_t *sector;
 	int r = 0;
 
 	BUG_ON(cc->integrity_iv_size && cc->integrity_iv_size != cc->iv_size);
 
+	/* Reject unexpected unaligned bio. */
+	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
+		return -EIO;
+
 	dmreq = dmreq_of_req(cc, req);
 	dmreq->iv_sector = ctx->cc_sector;
+	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
+		sector_div(dmreq->iv_sector, cc->sector_size >> SECTOR_SHIFT);
 	dmreq->ctx = ctx;
 
 	*org_tag_of_dmreq(cc, dmreq) = tag_offset;
@@ -1066,13 +1083,13 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	sg_init_table(dmreq->sg_in, 4);
 	sg_set_buf(&dmreq->sg_in[0], sector, sizeof(uint64_t));
 	sg_set_buf(&dmreq->sg_in[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_in[2], bv_in.bv_page, data_len, bv_in.bv_offset);
+	sg_set_page(&dmreq->sg_in[2], bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
 	sg_set_buf(&dmreq->sg_in[3], tag, cc->integrity_tag_size);
 
 	sg_init_table(dmreq->sg_out, 4);
 	sg_set_buf(&dmreq->sg_out[0], sector, sizeof(uint64_t));
 	sg_set_buf(&dmreq->sg_out[1], org_iv, cc->iv_size);
-	sg_set_page(&dmreq->sg_out[2], bv_out.bv_page, data_len, bv_out.bv_offset);
+	sg_set_page(&dmreq->sg_out[2], bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
 	sg_set_buf(&dmreq->sg_out[3], tag, cc->integrity_tag_size);
 
 	if (cc->iv_gen_ops) {
@@ -1094,14 +1111,14 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	aead_request_set_ad(req, sizeof(uint64_t) + cc->iv_size);
 	if (bio_data_dir(ctx->bio_in) == WRITE) {
 		aead_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
-				       data_len, iv);
+				       cc->sector_size, iv);
 		r = crypto_aead_encrypt(req);
 		if (cc->integrity_tag_size + cc->integrity_iv_size != cc->on_disk_tag_size)
 			memset(tag + cc->integrity_tag_size + cc->integrity_iv_size, 0,
 			       cc->on_disk_tag_size - (cc->integrity_tag_size + cc->integrity_iv_size));
 	} else {
 		aead_request_set_crypt(req, dmreq->sg_in, dmreq->sg_out,
-				       data_len + cc->integrity_tag_size, iv);
+				       cc->sector_size + cc->integrity_tag_size, iv);
 		r = crypto_aead_decrypt(req);
 	}
 
@@ -1112,8 +1129,8 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
 
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, data_len);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, data_len);
+	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
+	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
 
 	return r;
 }
@@ -1127,13 +1144,18 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	struct bio_vec bv_out = bio_iter_iovec(ctx->bio_out, ctx->iter_out);
 	struct scatterlist *sg_in, *sg_out;
 	struct dm_crypt_request *dmreq;
-	unsigned int data_len = 1 << SECTOR_SHIFT;
 	u8 *iv, *org_iv, *tag_iv;
 	uint64_t *sector;
 	int r = 0;
 
+	/* Reject unexpected unaligned bio. */
+	if (unlikely(bv_in.bv_offset & (cc->sector_size - 1)))
+		return -EIO;
+
 	dmreq = dmreq_of_req(cc, req);
 	dmreq->iv_sector = ctx->cc_sector;
+	if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
+		sector_div(dmreq->iv_sector, cc->sector_size >> SECTOR_SHIFT);
 	dmreq->ctx = ctx;
 
 	*org_tag_of_dmreq(cc, dmreq) = tag_offset;
@@ -1150,10 +1172,10 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	sg_out = &dmreq->sg_out[0];
 
 	sg_init_table(sg_in, 1);
-	sg_set_page(sg_in, bv_in.bv_page, data_len, bv_in.bv_offset);
+	sg_set_page(sg_in, bv_in.bv_page, cc->sector_size, bv_in.bv_offset);
 
 	sg_init_table(sg_out, 1);
-	sg_set_page(sg_out, bv_out.bv_page, data_len, bv_out.bv_offset);
+	sg_set_page(sg_out, bv_out.bv_page, cc->sector_size, bv_out.bv_offset);
 
 	if (cc->iv_gen_ops) {
 		/* For READs use IV stored in integrity metadata */
@@ -1171,7 +1193,7 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 		memcpy(iv, org_iv, cc->iv_size);
 	}
 
-	skcipher_request_set_crypt(req, sg_in, sg_out, data_len, iv);
+	skcipher_request_set_crypt(req, sg_in, sg_out, cc->sector_size, iv);
 
 	if (bio_data_dir(ctx->bio_in) == WRITE)
 		r = crypto_skcipher_encrypt(req);
@@ -1181,8 +1203,8 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
 
-	bio_advance_iter(ctx->bio_in, &ctx->iter_in, data_len);
-	bio_advance_iter(ctx->bio_out, &ctx->iter_out, data_len);
+	bio_advance_iter(ctx->bio_in, &ctx->iter_in, cc->sector_size);
+	bio_advance_iter(ctx->bio_out, &ctx->iter_out, cc->sector_size);
 
 	return r;
 }
@@ -1268,6 +1290,7 @@ static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
 	unsigned int tag_offset = 0;
+	unsigned int sector_step = cc->sector_size / (1 << SECTOR_SHIFT);
 	int r;
 
 	atomic_set(&ctx->cc_pending, 1);
@@ -1275,7 +1298,6 @@ static int crypt_convert(struct crypt_config *cc,
 	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
 
 		crypt_alloc_req(cc, ctx);
-
 		atomic_inc(&ctx->cc_pending);
 
 		if (crypt_integrity_aead(cc))
@@ -1298,16 +1320,16 @@ static int crypt_convert(struct crypt_config *cc,
 		 */
 		case -EINPROGRESS:
 			ctx->r.req = NULL;
-			ctx->cc_sector++;
-			tag_offset++;
+			ctx->cc_sector += sector_step;
+			tag_offset += sector_step;
 			continue;
 		/*
 		 * The request was already processed (synchronously).
 		 */
 		case 0:
 			atomic_dec(&ctx->cc_pending);
-			ctx->cc_sector++;
-			tag_offset++;
+			ctx->cc_sector += sector_step;
+			tag_offset += sector_step;
 			cond_resched();
 			continue;
 		/*
@@ -2499,10 +2521,11 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 	struct crypt_config *cc = ti->private;
 	struct dm_arg_set as;
 	static struct dm_arg _args[] = {
-		{0, 3, "Invalid number of feature args"},
+		{0, 6, "Invalid number of feature args"},
 	};
 	unsigned int opt_params, val;
 	const char *opt_string, *sval;
+	char dummy;
 	int ret;
 
 	/* Optional parameters */
@@ -2545,7 +2568,16 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 			cc->cipher_auth = kstrdup(sval, GFP_KERNEL);
 			if (!cc->cipher_auth)
 				return -ENOMEM;
-		}  else {
+		} else if (sscanf(opt_string, "sector_size:%u%c", &cc->sector_size, &dummy) == 1) {
+			if (cc->sector_size < (1 << SECTOR_SHIFT) ||
+			    cc->sector_size > 4096 ||
+			    (1 << ilog2(cc->sector_size) != cc->sector_size)) {
+				ti->error = "Invalid feature value for sector_size";
+				return -EINVAL;
+			}
+		} else if (!strcasecmp(opt_string, "iv_large_sectors"))
+			set_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
+		else {
 			ti->error = "Invalid feature arguments";
 			return -EINVAL;
 		}
@@ -2585,6 +2617,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -ENOMEM;
 	}
 	cc->key_size = key_size;
+	cc->sector_size = (1 << SECTOR_SHIFT);
 
 	ti->private = cc;
 
@@ -2657,7 +2690,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	mutex_init(&cc->bio_alloc_lock);
 
 	ret = -EINVAL;
-	if (sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) {
+	if ((sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) ||
+	    (tmpll & ((cc->sector_size >> SECTOR_SHIFT) - 1))) {
 		ti->error = "Invalid iv_offset sector";
 		goto bad;
 	}
@@ -2758,6 +2792,16 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	    (bio_data_dir(bio) == WRITE || cc->on_disk_tag_size))
 		dm_accept_partial_bio(bio, ((BIO_MAX_PAGES << PAGE_SHIFT) >> SECTOR_SHIFT));
 
+	/*
+	 * Ensure that bio is a multiple of internal sector encryption size
+	 * and is aligned to this size as defined in IO hints.
+	 */
+	if (unlikely((bio->bi_iter.bi_sector & ((cc->sector_size >> SECTOR_SHIFT) - 1)) != 0))
+		return -EIO;
+
+	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
+		return -EIO;
+
 	io = dm_per_bio_data(bio, cc->per_bio_data_size);
 	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
 
@@ -2765,12 +2809,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 		unsigned tag_len = cc->on_disk_tag_size * bio_sectors(bio);
 
 		if (unlikely(tag_len > KMALLOC_MAX_SIZE) ||
-		    unlikely(!(io->integrity_metadata = kmalloc(tag_len,
+		    unlikely(!(io->integrity_metadata = kzalloc(tag_len,
 				GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN)))) {
 			if (bio_sectors(bio) > cc->tag_pool_max_sectors)
 				dm_accept_partial_bio(bio, cc->tag_pool_max_sectors);
 			io->integrity_metadata = mempool_alloc(cc->tag_pool, GFP_NOIO);
 			io->integrity_metadata_from_pool = true;
+			memset(io->integrity_metadata, 0, cc->tag_pool_max_sectors * (1 << SECTOR_SHIFT));
 		}
 	}
 
@@ -2818,6 +2863,8 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 		num_feature_args += !!ti->num_discard_bios;
 		num_feature_args += test_bit(DM_CRYPT_SAME_CPU, &cc->flags);
 		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
+		num_feature_args += (cc->sector_size != (1 << SECTOR_SHIFT)) ? 1 : 0;
+		num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
 		if (cc->on_disk_tag_size)
 			num_feature_args++;
 		if (num_feature_args) {
@@ -2830,6 +2877,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 				DMEMIT(" submit_from_crypt_cpus");
 			if (cc->on_disk_tag_size)
 				DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);
+			if (cc->sector_size != (1 << SECTOR_SHIFT))
+				DMEMIT(" sector_size:%d", cc->sector_size);
+			if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
+				DMEMIT(" iv_large_sectors");
 		}
 
 		break;
@@ -2919,6 +2970,8 @@ static int crypt_iterate_devices(struct dm_target *ti,
 
 static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 {
+	struct crypt_config *cc = ti->private;
+
 	/*
 	 * Unfortunate constraint that is required to avoid the potential
 	 * for exceeding underlying device's max_segments limits -- due to
@@ -2926,11 +2979,17 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	 * bio that are not as physically contiguous as the original bio.
 	 */
 	limits->max_segment_size = PAGE_SIZE;
+
+	if (cc->sector_size != (1 << SECTOR_SHIFT)) {
+		limits->logical_block_size = cc->sector_size;
+		limits->physical_block_size = cc->sector_size;
+		blk_limits_io_min(limits, cc->sector_size);
+	}
 }
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 16, 0},
+	.version = {1, 17, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
2.11.0
