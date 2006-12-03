From: "Rik Snel" <rsnel@cube.dyndns.org>
Subject: [PATCH] dm-crypt: add support for very wide (>512 bytes)
	block modes
Date: Sun,  3 Dec 2006 13:48:22 +0100
Message-ID: <11651501173889-git-send-email-rsnel@cube.dyndns.org>
References: <11651501031841-git-send-email-rsnel@cube.dyndns.org>
	<11651501113230-git-send-email-rsnel@cube.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11651501113230-git-send-email-rsnel@cube.dyndns.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: herbert@gondor.apana.org.au
List-Id: dm-devel.ids

From: Rik Snel <rsnel@cube.dyndns.org>

By default dm-crypt sends and receives chunks of 512 bytes to and from
the crypto layer. For implementing deniable harddisk encryption it is
useful to make these chunks larger; i.e. equal to the filesystem block
size. If a wide block cipher mode (like ABL) is used, then a single bit
modification of the filesystem block will result in a total change of the
corresponding cipher block.

This patch adds an optional argument to dm-crypt, the 'extra sector size
shift'.  The blocksize for communicating with the crypto layer will be
512<<'extra sector size shift'. The resulting size may not be larger
than PAGE_SIZE. Care is taken to also enlarge the hardsector_size as needed.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 drivers/md/dm-crypt.c |   50 ++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a88dc95..28a9729 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -95,6 +95,7 @@ struct crypt_config {
 	struct crypto_blkcipher *tfm;
 	unsigned long flags;
 	unsigned int key_size;
+	int extra_shift;
 	u8 key[0];
 };
 
@@ -257,7 +258,8 @@ static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 static int crypt_iv_bewbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 {
 	memset(iv, 0, cc->iv_size - sizeof(u32));
-	*((u32*)iv + 3) = cpu_to_be32((sector & 0xffffffff) + 1);
+	*((u32*)iv + 3) =
+		cpu_to_be32((sector >> cc->extra_shift & 0xffffffff) + 1);
 
 	return 0;
 }
@@ -344,12 +346,12 @@ static int crypt_convert(struct crypt_config *cc,
 		struct scatterlist sg_in = {
 			.page = bv_in->bv_page,
 			.offset = bv_in->bv_offset + ctx->offset_in,
-			.length = 1 << SECTOR_SHIFT
+			.length = (1 << SECTOR_SHIFT) << cc->extra_shift
 		};
 		struct scatterlist sg_out = {
 			.page = bv_out->bv_page,
 			.offset = bv_out->bv_offset + ctx->offset_out,
-			.length = 1 << SECTOR_SHIFT
+			.length = (1 << SECTOR_SHIFT) << cc->extra_shift
 		};
 
 		ctx->offset_in += sg_in.length;
@@ -760,7 +762,7 @@ static int crypt_wipe_key(struct crypt_config *cc)
 
 /*
  * Construct an encryption mapping:
- * <cipher> <key> <iv_offset> <dev_path> <start>
+ * <cipher> <key> <iv_offset> <dev_path> <start> [<extra_shift>]
  */
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
@@ -774,11 +776,16 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	unsigned int key_size;
 	unsigned long long tmpll;
 
-	if (argc != 5) {
+	if (argc < 5) {
 		ti->error = "Not enough arguments";
 		return -EINVAL;
 	}
 
+	if (argc > 6) {
+		ti->error = "Too many arguments";
+		return -EINVAL;
+	}
+
 	tmp = argv[0];
 	cipher = strsep(&tmp, "-");
 	chainmode = strsep(&tmp, "-");
@@ -903,12 +910,42 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	cc->start = tmpll;
 
+	if (argc > 5) {
+		if (sscanf(argv[5], "%llu", &tmpll) != 1) {
+			ti->error = "Invalid extra sector size shift";
+			goto bad5;
+		}
+		if (tmpll < 1) {
+			ti->error = "Invalid extra sector size shift, "
+				"must be positive";
+			goto bad5;
+		}
+		if (tmpll > PAGE_SHIFT - SECTOR_SHIFT) {
+			ti->error = "Invalid extra sector size shift, "
+				"must be <= PAGE_SHIFT - SECTOR_SHIFT";
+			goto bad5;
+		}
+		cc->extra_shift = tmpll;
+	 } else cc->extra_shift = 0;
+
 	if (dm_get_device(ti, argv[3], cc->start, ti->len,
 	                  dm_table_get_mode(ti->table), &cc->dev)) {
 		ti->error = "Device lookup failed";
 		goto bad5;
 	}
 
+	if (cc->extra_shift) {
+		/* update hardsector_size */
+		if (ti->limits.hardsect_size%(1 << SECTOR_SHIFT)) {
+			ti->error = "Weird sector size, too small or "
+				"not a power of 2";
+			goto bad5;
+		}
+		while (ti->limits.hardsect_size <
+				(1 << SECTOR_SHIFT) << cc->extra_shift)
+			ti->limits.hardsect_size <<= 1;
+	}
+
 	if (ivmode && cc->iv_gen_ops) {
 		if (ivopts)
 			*(ivopts - 1) = ':';
@@ -1010,6 +1047,9 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
+		if (cc->extra_shift)
+			DMEMIT(" %llu", (unsigned long long)cc->extra_shift);
+
 		break;
 	}
 	return 0;
-- 
1.4.4.1
