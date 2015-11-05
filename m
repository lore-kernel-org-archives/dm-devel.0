From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 4/4] dm verity: ignore zero blocks
Date: Thu,  5 Nov 2015 02:02:34 +0000
Message-ID: <1446688954-29589-5-git-send-email-samitolvanen@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

Add ignore_zero_blocks option, which returns zeros for blocks matching a
zero hash without validating the content.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 Documentation/device-mapper/verity.txt |  5 ++
 drivers/md/dm-verity.c                 | 88 ++++++++++++++++++++++++++++++----
 2 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
index 3628d28..1b103b0 100644
--- a/Documentation/device-mapper/verity.txt
+++ b/Documentation/device-mapper/verity.txt
@@ -79,6 +79,11 @@ restart_on_corruption
     not compatible with ignore_corruption and requires user space support to
     avoid restart loops.
 
+ignore_zero_blocks
+    Do not verify blocks that are expected to contain zeros and always return
+    zeros instead. This may be useful if the partition contains unused blocks
+    that are not guaranteed to contain zeros.
+
 use_fec_from_device
     Use forward error correction (FEC) to recover from corruption if hash
     verification fails. Use encoding data from the specified device. This
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 61dec39..485d59e 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -38,6 +38,7 @@
 
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
+#define DM_VERITY_OPT_IGN_ZEROS		"ignore_zero_blocks"
 
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
@@ -45,7 +46,7 @@
 #define DM_VERITY_OPT_FEC_ROOTS		"fec_roots"
 
 #define DM_VERITY_OPTS_FEC		8
-#define DM_VERITY_OPTS_MAX		(1 + DM_VERITY_OPTS_FEC)
+#define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
@@ -74,6 +75,7 @@ struct dm_verity {
 	struct crypto_shash *tfm;
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
+	u8 *zero_digest;	/* digest for a zero block */
 	unsigned salt_size;
 	sector_t data_start;	/* data offset in 512-byte sectors */
 	sector_t hash_start;	/* hash start in blocks */
@@ -422,9 +424,9 @@ release_ret_r:
  * of the hash tree if necessary.
  */
 static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
-				 sector_t block, u8 *digest)
+				 sector_t block, u8 *digest, bool *is_zero)
 {
-	int r, i;
+	int r = 0, i;
 
 	if (likely(v->levels)) {
 		/*
@@ -436,7 +438,7 @@ static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 		 */
 		r = verity_verify_level(v, io, block, 0, true, digest);
 		if (likely(r <= 0))
-			return r;
+			goto out;
 	}
 
 	memcpy(digest, v->root_digest, v->digest_size);
@@ -444,10 +446,16 @@ static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 	for (i = v->levels - 1; i >= 0; i--) {
 		r = verity_verify_level(v, io, block, i, false, digest);
 		if (unlikely(r))
-			return r;
+			goto out;
 	}
 
-	return 0;
+out:
+	if (!r && v->zero_digest)
+		*is_zero = !memcmp(v->zero_digest, digest, v->digest_size);
+	else
+		*is_zero = false;
+
+	return r;
 }
 
 /*
@@ -496,11 +504,19 @@ static int verity_bv_hash_update(struct dm_verity *v, struct dm_verity_io *io,
 	return verity_hash_update(v, io_hash_desc(v, io), data, len);
 }
 
+static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
+			  u8 *data, size_t len)
+{
+	memset(data, 0, len);
+	return 0;
+}
+
 /*
  * Verify one "dm_verity_io" structure.
  */
 static int verity_verify_io(struct dm_verity_io *io)
 {
+	bool is_zero;
 	struct dm_verity *v = io->v;
 	struct bvec_iter start;
 	unsigned b;
@@ -510,10 +526,23 @@ static int verity_verify_io(struct dm_verity_io *io)
 		struct shash_desc *desc = io_hash_desc(v, io);
 
 		r = verity_hash_for_block(v, io, io->block + b,
-					  io_want_digest(v, io));
+					  io_want_digest(v, io), &is_zero);
 		if (unlikely(r < 0))
 			return r;
 
+		if (is_zero) {
+			/*
+			 * If we expect a zero block, don't validate, just
+			 * return zeros.
+			 */
+			r = verity_for_bv_block(v, io, &io->iter,
+						verity_bv_zero);
+			if (unlikely(r < 0))
+				return r;
+
+			continue;
+		}
+
 		r = verity_hash_init(v, desc);
 		if (unlikely(r < 0))
 			return r;
@@ -674,6 +703,7 @@ static int verity_fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 static int verity_fec_read_buf(struct dm_verity *v, struct dm_verity_io *io,
 			       u64 rsb, u64 target, int *neras)
 {
+	bool is_zero;
 	int i, j, target_index = -1;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
@@ -713,9 +743,13 @@ static int verity_fec_read_buf(struct dm_verity *v, struct dm_verity_io *io,
 		}
 
 		if (block < v->data_blocks &&
-		    verity_hash_for_block(v, io, block, want_digest) == 0) {
-			if (neras && *neras <= v->fec_roots &&
-			    verity_fec_is_erasure(v, io, want_digest, bbuf))
+		    verity_hash_for_block(v, io, block, want_digest,
+					  &is_zero) == 0) {
+			if (is_zero)
+				memset(bbuf, 0, 1 << v->data_dev_block_bits);
+			else if (neras && *neras <= v->fec_roots &&
+				 verity_fec_is_erasure(v, io, want_digest,
+						       bbuf))
 				io->erasures[(*neras)++] = i;
 		}
 
@@ -1066,6 +1100,8 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 				DMEMIT("%02x", v->salt[x]);
 		if (v->mode != DM_VERITY_MODE_EIO)
 			args++;
+		if (v->zero_digest)
+			args++;
 		if (v->fec_dev)
 			args += DM_VERITY_OPTS_FEC;
 		if (!args)
@@ -1084,6 +1120,8 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 				BUG();
 			}
 		}
+		if (v->zero_digest)
+			DMEMIT(" " DM_VERITY_OPT_IGN_ZEROS);
 		if (v->fec_dev)
 			DMEMIT(" " DM_VERITY_OPT_FEC_DEV " %s "
 			       DM_VERITY_OPT_FEC_BLOCKS " %llu "
@@ -1148,6 +1186,7 @@ static void verity_dtr(struct dm_target *ti)
 
 	kfree(v->salt);
 	kfree(v->root_digest);
+	kfree(v->zero_digest);
 
 	if (v->tfm)
 		crypto_free_shash(v->tfm);
@@ -1164,6 +1203,29 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v);
 }
 
+static int verity_alloc_zero_digest(struct dm_verity *v)
+{
+	int r;
+	u8 desc[v->shash_descsize];
+	u8 *zero_data;
+
+	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
+
+	if (!v->zero_digest)
+		return -ENOMEM;
+
+	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
+
+	if (!zero_data)
+		return -ENOMEM; /* verity_dtr will free zero_digest */
+
+	r = verity_hash(v, (struct shash_desc *)desc, zero_data,
+			1 << v->data_dev_block_bits, v->zero_digest);
+
+	kfree(zero_data);
+	return r;
+}
+
 static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 				 const char *opt_string)
 {
@@ -1178,6 +1240,12 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 	} else if (!strcasecmp(opt_string, DM_VERITY_OPT_RESTART)) {
 		v->mode = DM_VERITY_MODE_RESTART;
 		return 0;
+	} else if (!strcasecmp(opt_string, DM_VERITY_OPT_IGN_ZEROS)) {
+		r = verity_alloc_zero_digest(v);
+		if (r)
+			v->ti->error = "Cannot allocate zero digest";
+
+		return r;
 	}
 
 	/* Remaining arguments require a value */
-- 
2.6.0.rc2.230.g3dd15c0
