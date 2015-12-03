From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH v2 2/2] dm verity: ignore zero blocks
Date: Thu,  3 Dec 2015 14:26:31 +0000
Message-ID: <1449152791-33586-3-git-send-email-samitolvanen@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <1449152791-33586-1-git-send-email-samitolvanen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449152791-33586-1-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

Add ignore_zero_blocks option, which returns zeros for blocks matching a
zero hash without validating the content.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 Documentation/device-mapper/verity.txt |  5 ++
 drivers/md/dm-verity-fec.c             |  8 +++-
 drivers/md/dm-verity-target.c          | 84 ++++++++++++++++++++++++++++++----
 drivers/md/dm-verity.h                 |  3 +-
 4 files changed, 90 insertions(+), 10 deletions(-)

diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
index 1058f36..4d3bbda 100644
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
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index c3a2531..599334f 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -210,6 +210,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 u64 rsb, u64 target, unsigned block_offset,
 			 int *neras)
 {
+	bool is_zero;
 	int i, j, target_index = -1;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
@@ -270,7 +271,12 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 		/* locate erasures if the block is on the data device */
 		if (bufio == v->fec->data_bufio &&
-		    verity_hash_for_block(v, io, block, want_digest) == 0) {
+		    verity_hash_for_block(v, io, block, want_digest,
+					  &is_zero) == 0) {
+			/* skip known zero blocks entirely */
+			if (is_zero)
+				continue;
+
 			/*
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index ca5857b..a2bb3bc 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -31,8 +31,9 @@
 
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
+#define DM_VERITY_OPT_IGN_ZEROS		"ignore_zero_blocks"
 
-#define DM_VERITY_OPTS_MAX		(1 + DM_VERITY_OPTS_FEC)
+#define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
@@ -309,10 +310,9 @@ release_ret_r:
  * of the hash tree if necessary.
  */
 int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
-			  sector_t block, u8 *digest)
+			  sector_t block, u8 *digest, bool *is_zero)
 {
-	int i;
-	int r;
+	int r = 0, i;
 
 	if (likely(v->levels)) {
 		/*
@@ -324,7 +324,7 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 		 */
 		r = verity_verify_level(v, io, block, 0, true, digest);
 		if (likely(r <= 0))
-			return r;
+			goto out;
 	}
 
 	memcpy(digest, v->root_digest, v->digest_size);
@@ -332,10 +332,16 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
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
@@ -383,11 +389,19 @@ static int verity_bv_hash_update(struct dm_verity *v, struct dm_verity_io *io,
 	return verity_hash_update(v, verity_io_hash_desc(v, io), data, len);
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
@@ -397,10 +411,24 @@ static int verity_verify_io(struct dm_verity_io *io)
 		struct shash_desc *desc = verity_io_hash_desc(v, io);
 
 		r = verity_hash_for_block(v, io, io->block + b,
-					  verity_io_want_digest(v, io));
+					  verity_io_want_digest(v, io),
+					  &is_zero);
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
@@ -607,6 +635,8 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 			args++;
 		if (verity_fec_is_enabled(v))
 			args += DM_VERITY_OPTS_FEC;
+		if (v->zero_digest)
+			args++;
 		if (!args)
 			return;
 		DMEMIT(" %u", args);
@@ -623,6 +653,8 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 				BUG();
 			}
 		}
+		if (v->zero_digest)
+			DMEMIT(" " DM_VERITY_OPT_IGN_ZEROS);
 		sz = verity_fec_status_table(v, sz, result, maxlen);
 		break;
 	}
@@ -674,6 +706,7 @@ static void verity_dtr(struct dm_target *ti)
 
 	kfree(v->salt);
 	kfree(v->root_digest);
+	kfree(v->zero_digest);
 
 	if (v->tfm)
 		crypto_free_shash(v->tfm);
@@ -691,6 +724,37 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v);
 }
 
+static int verity_alloc_zero_digest(struct dm_verity *v)
+{
+	int r = -ENOMEM;
+	struct shash_desc *desc;
+	u8 *zero_data;
+
+	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
+
+	if (!v->zero_digest)
+		return r;
+
+	desc = kmalloc(v->shash_descsize, GFP_KERNEL);
+
+	if (!desc)
+		return r; /* verity_dtr will free zero_digest */
+
+	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
+
+	if (!zero_data)
+		goto out;
+
+	r = verity_hash(v, desc, zero_data, 1 << v->data_dev_block_bits,
+			v->zero_digest);
+
+out:
+	kfree(desc);
+	kfree(zero_data);
+
+	return r;
+}
+
 static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
 {
 	int r;
@@ -720,6 +784,10 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART)) {
 			v->mode = DM_VERITY_MODE_RESTART;
 			continue;
+		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_IGN_ZEROS)) {
+			r = verity_alloc_zero_digest(v);
+			if (r)
+				ti->error = "Cannot allocate zero digest";
 		} else {
 			r = verity_fec_parse_opt_args(as, v, &argc, arg_name);
 		}
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 8e85372..fb419f4 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -40,6 +40,7 @@ struct dm_verity {
 	struct crypto_shash *tfm;
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
+	u8 *zero_digest;	/* digest for a zero block */
 	unsigned salt_size;
 	sector_t data_start;	/* data offset in 512-byte sectors */
 	sector_t hash_start;	/* hash start in blocks */
@@ -123,6 +124,6 @@ extern int verity_hash(struct dm_verity *v, struct shash_desc *desc,
 		       const u8 *data, size_t len, u8 *digest);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
-				 sector_t block, u8 *digest);
+				 sector_t block, u8 *digest, bool *is_zero);
 
 #endif /* DM_VERITY_H */
-- 
2.6.0.rc2.230.g3dd15c0
