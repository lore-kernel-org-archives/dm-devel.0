From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 3/4] dm verity: add support for forward error correction
Date: Thu,  5 Nov 2015 02:02:33 +0000
Message-ID: <1446688954-29589-4-git-send-email-samitolvanen@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

Add support for correcting corrupted blocks using Reed-Solomon.

This code uses RS(255, N) interleaved across data and hash
blocks. Each error-correcting block covers N bytes evenly
distributed across the combined total data, so that each byte is a
maximum distance away from the others. This makes it possible to
recover from several consecutive corrupted blocks with relatively
small space overhead.

In addition, using verity hashes to locate erasures nearly doubles
the effectiveness of error correction. Being able to detect
corrupted blocks also improves performance, because only corrupted
blocks need to corrected.

For a 2 GiB partition, RS(255, 253) (two parity bytes for each
253-byte block) can correct up to 16 MiB of consecutive corrupted
blocks if erasures can be located, and 8 MiB if they cannot, with
16 MiB space overhead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 Documentation/device-mapper/verity.txt |  29 ++
 drivers/md/dm-verity.c                 | 689 ++++++++++++++++++++++++++++++---
 2 files changed, 673 insertions(+), 45 deletions(-)

diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
index e15bc1a..3628d28 100644
--- a/Documentation/device-mapper/verity.txt
+++ b/Documentation/device-mapper/verity.txt
@@ -79,6 +79,35 @@ restart_on_corruption
     not compatible with ignore_corruption and requires user space support to
     avoid restart loops.
 
+use_fec_from_device
+    Use forward error correction (FEC) to recover from corruption if hash
+    verification fails. Use encoding data from the specified device. This
+    may be the same device where data and hash blocks reside, in which case
+    fec_start must be outside data and hash areas.
+
+    If the encoding data covers additional metadata, it must be accessible
+    on the hash device after the hash blocks.
+
+    Note: block sizes for data and hash devices must match.
+
+    A command line tool for generating encoding data is available from the
+    Android Open Source Project:
+    https://android.googlesource.com/platform/system/extras/+/master/verity/fec/
+
+fec_roots
+    Number of generator roots. This equals to the number of parity bytes in
+    the encoding data. For example, in RS(M, N) encoding, the number of roots
+    is M-N.
+
+fec_blocks
+    The number of encoding data blocks on the FEC device. The block size for
+    the FEC device is <data_block_size>.
+
+fec_start
+    This is the offset, in <data_block_size> blocks, from the start of the
+    FEC device to the beginning of the encoding data.
+
+
 Theory of operation
 ===================
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index da76f77..61dec39 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2015 Google, Inc.
  *
  * Author: Mikulas Patocka <mpatocka@redhat.com>
  *
@@ -19,6 +20,8 @@
 #include <linux/module.h>
 #include <linux/device-mapper.h>
 #include <linux/reboot.h>
+#include <linux/rslib.h>
+#include <linux/vmalloc.h>
 #include <crypto/hash.h>
 
 #define DM_MSG_PREFIX			"verity"
@@ -31,10 +34,18 @@
 #define DM_VERITY_MAX_LEVELS		63
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
+#define DM_VERITY_FEC_RSM		255
+
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
 
-#define DM_VERITY_OPTS_MAX		1
+#define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
+#define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
+#define DM_VERITY_OPT_FEC_START		"fec_start"
+#define DM_VERITY_OPT_FEC_ROOTS		"fec_roots"
+
+#define DM_VERITY_OPTS_FEC		8
+#define DM_VERITY_OPTS_MAX		(1 + DM_VERITY_OPTS_FEC)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
@@ -54,8 +65,11 @@ enum verity_block_type {
 struct dm_verity {
 	struct dm_dev *data_dev;
 	struct dm_dev *hash_dev;
+	struct dm_dev *fec_dev;
 	struct dm_target *ti;
-	struct dm_bufio_client *bufio;
+	struct dm_bufio_client *data_bufio;
+	struct dm_bufio_client *hash_bufio;
+	struct dm_bufio_client *fec_bufio;
 	char *alg_name;
 	struct crypto_shash *tfm;
 	u8 *root_digest;	/* digest of the root block */
@@ -65,11 +79,17 @@ struct dm_verity {
 	sector_t hash_start;	/* hash start in blocks */
 	sector_t data_blocks;	/* the number of data blocks */
 	sector_t hash_blocks;	/* the number of hash blocks */
+	sector_t fec_start;	/* FEC data start in blocks */
+	sector_t fec_blocks;	/* number of blocks covered by FEC */
+	sector_t fec_rounds;	/* number of FEC rounds */
+	sector_t fec_hash_blocks;		/* blocks after hash_start */
 	unsigned char data_dev_block_bits;	/* log2(data blocksize) */
 	unsigned char hash_dev_block_bits;	/* log2(hash blocksize) */
 	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
 	unsigned char levels;	/* the number of tree levels */
 	unsigned char version;
+	unsigned char fec_roots;/* number of parity bytes, M-N of RS(M, N) */
+	unsigned char fec_rsn;	/* N of RS(M, N) */
 	unsigned digest_size;	/* digest size for the current hash algorithm */
 	unsigned shash_descsize;/* the size of temporary space for crypto */
 	int hash_failed;	/* set to 1 if hash of any block failed */
@@ -96,6 +116,11 @@ struct dm_verity_io {
 
 	struct work_struct work;
 
+	struct rs_control *rs;
+	int *erasures;
+	size_t fec_pos;
+	u8 *fec_buf;
+
 	/*
 	 * Three variably-size fields follow this struct:
 	 *
@@ -148,7 +173,7 @@ struct buffer_aux {
 /*
  * Initialize struct buffer_aux for a freshly created buffer.
  */
-static void dm_bufio_alloc_callback(struct dm_buffer *buf)
+static void dm_hash_bufio_alloc_callback(struct dm_buffer *buf)
 {
 	struct buffer_aux *aux = dm_bufio_get_aux_data(buf);
 
@@ -322,6 +347,10 @@ out:
 	return 1;
 }
 
+static int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
+			     enum verity_block_type type, sector_t block,
+			     u8 *dest, struct bvec_iter *iter);
+
 /*
  * Verify hash of a metadata block pertaining to the specified data block
  * ("block" argument) at a specified level ("level" argument).
@@ -346,7 +375,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
-	data = dm_bufio_read(v->bufio, hash_block, &buf);
+	data = dm_bufio_read(v->hash_bufio, hash_block, &buf);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
@@ -367,6 +396,10 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (likely(memcmp(io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
+		else if (verity_fec_decode(v, io,
+					   DM_VERITY_BLOCK_TYPE_METADATA,
+					   hash_block, data, NULL) == 0)
+			aux->hash_verified = 1;
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block)) {
@@ -391,8 +424,7 @@ release_ret_r:
 static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest)
 {
-	int i;
-	int r;
+	int r, i;
 
 	if (likely(v->levels)) {
 		/*
@@ -419,18 +451,62 @@ static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 }
 
 /*
+ * Calls function f for 1 << v->data_dev_block_bits bytes in io->io_vec
+ * starting from (vector, offset). Assumes io->io_vec has enough data to
+ * process.
+ */
+static int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
+			       struct bvec_iter *iter,
+			       int (*process)(struct dm_verity *v,
+					      struct dm_verity_io *io,
+					      u8 *data, size_t len))
+{
+	unsigned todo = 1 << v->data_dev_block_bits;
+	struct bio *bio = dm_bio_from_per_bio_data(io,
+						   v->ti->per_bio_data_size);
+
+	do {
+		int r;
+		u8 *page;
+		unsigned len;
+		struct bio_vec bv = bio_iter_iovec(bio, *iter);
+
+		page = kmap_atomic(bv.bv_page);
+		len = bv.bv_len;
+
+		if (likely(len >= todo))
+			len = todo;
+
+		r = process(v, io, page + bv.bv_offset, len);
+		kunmap_atomic(page);
+
+		if (r < 0)
+			return r;
+
+		bio_advance_iter(bio, iter, len);
+		todo -= len;
+	} while (todo);
+
+	return 0;
+}
+
+static int verity_bv_hash_update(struct dm_verity *v, struct dm_verity_io *io,
+				 u8 *data, size_t len)
+{
+	return verity_hash_update(v, io_hash_desc(v, io), data, len);
+}
+
+/*
  * Verify one "dm_verity_io" structure.
  */
 static int verity_verify_io(struct dm_verity_io *io)
 {
 	struct dm_verity *v = io->v;
-	struct bio *bio = dm_bio_from_per_bio_data(io,
-						   v->ti->per_bio_data_size);
+	struct bvec_iter start;
 	unsigned b;
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
-		unsigned todo;
 		struct shash_desc *desc = io_hash_desc(v, io);
 
 		r = verity_hash_for_block(v, io, io->block + b,
@@ -442,36 +518,24 @@ static int verity_verify_io(struct dm_verity_io *io)
 		if (unlikely(r < 0))
 			return r;
 
-		todo = 1 << v->data_dev_block_bits;
-		do {
-			u8 *page;
-			unsigned len;
-			struct bio_vec bv = bio_iter_iovec(bio, io->iter);
-
-			page = kmap_atomic(bv.bv_page);
-			len = bv.bv_len;
-			if (likely(len >= todo))
-				len = todo;
-			r = verity_hash_update(v, desc,  page + bv.bv_offset,
-					       len);
-			kunmap_atomic(page);
-
-			if (unlikely(r < 0))
-				return r;
-
-			bio_advance_iter(bio, &io->iter, len);
-			todo -= len;
-		} while (todo);
+		start = io->iter;
+		r = verity_for_bv_block(v, io, &io->iter,
+					verity_bv_hash_update);
+		if (unlikely(r < 0))
+			return r;
 
 		r = verity_hash_final(v, desc, io_real_digest(v, io));
 		if (unlikely(r < 0))
 			return r;
 
 		if (likely(memcmp(io_real_digest(v, io),
-				io_want_digest(v, io), v->digest_size) == 0))
+				  io_want_digest(v, io), v->digest_size) == 0))
+			continue;
+		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
+					   io->block + b, NULL, &start) == 0)
 			continue;
 		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-				io->block + b))
+					   io->block + b))
 			return -EIO;
 	}
 
@@ -479,6 +543,345 @@ static int verity_verify_io(struct dm_verity_io *io)
 }
 
 /*
+ * Returns an interleaved offset for a byte in RS block.
+ */
+static inline u64 verity_fec_interleave(struct dm_verity *v, u64 offset)
+{
+	u32 mod;
+
+	mod = do_div(offset, v->fec_rsn);
+	return offset + mod * (v->fec_rounds << v->data_dev_block_bits);
+}
+
+/*
+ * Decode a block using Reed-Solomon.
+ */
+static int verity_fec_decode_rs8(struct dm_verity *v,
+				 struct dm_verity_io *io, u8 *data, u8 *fec,
+				 int neras)
+{
+	int i;
+	uint16_t par[v->fec_roots];
+
+	for (i = 0; i < v->fec_roots; i++)
+		par[i] = fec[i];
+
+	return decode_rs8(io->rs, data, par, v->fec_rsn, NULL, neras,
+			  io->erasures, 0, NULL);
+}
+
+/*
+ * Read error-correcting codes for the requested RS block. Returns a pointer
+ * to the data block. Caller is responsible for releasing buf.
+ */
+static u8 *verity_fec_read_par(struct dm_verity *v, u64 rsb, int index,
+			       unsigned *offset, struct dm_buffer **buf)
+{
+	u64 block;
+	u8 *res;
+
+	block = (index + rsb) * v->fec_roots >> v->data_dev_block_bits;
+
+	*offset = (unsigned)((block << v->data_dev_block_bits) -
+			     (index + rsb) * v->fec_roots);
+
+	res = dm_bufio_read(v->fec_bufio, v->fec_start + block, buf);
+
+	if (unlikely(IS_ERR(res))) {
+		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+		      v->data_dev->name, (unsigned long long)rsb,
+		      (unsigned long long)(v->fec_start + block),
+		      PTR_ERR(res));
+		*buf = NULL;
+		return NULL;
+	}
+
+	return res;
+}
+
+/*
+ * Decode 1 << v->data_dev_block_bits FEC blocks from io->fec_buf and copy the
+ * corrected 'index' block to the beginning of the buffer.
+ */
+static int verity_fec_decode_buf(struct dm_verity *v, struct dm_verity_io *io,
+				 u64 rsb, int index, int neras)
+{
+	int r = -1, corrected = 0, i, res;
+	struct dm_buffer *buf;
+	unsigned offset;
+	u8 *par;
+
+	par = verity_fec_read_par(v, rsb, 0, &offset, &buf);
+	if (unlikely(!par))
+		return r;
+
+	for (i = 0; i < 1 << v->data_dev_block_bits; i++) {
+		if (offset >= 1 << v->data_dev_block_bits) {
+			dm_bufio_release(buf);
+
+			par = verity_fec_read_par(v, rsb, i, &offset, &buf);
+			if (unlikely(!par))
+				return r;
+		}
+
+		res = verity_fec_decode_rs8(v, io,
+				&io->fec_buf[i * v->fec_rsn], &par[offset],
+				neras);
+
+		if (res < 0)
+			goto out;
+
+		corrected += res;
+		offset += v->fec_roots;
+
+		/* copy corrected block to the beginning of fec_buf */
+		io->fec_buf[i] = io->fec_buf[i * v->fec_rsn + index];
+	}
+
+	r = corrected;
+
+out:
+	dm_bufio_release(buf);
+
+	if (r < 0 && neras)
+		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
+			    v->data_dev->name, (unsigned long long)rsb, r);
+	else if (r > 0)
+		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
+			     v->data_dev->name, (unsigned long long)rsb, r);
+
+	return r;
+}
+
+/*
+ * Locate data block erasures using verity hashes.
+ */
+static int verity_fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
+				 u8 *want_digest, u8 *data)
+{
+	if (unlikely(verity_hash(v, io_hash_desc(v, io),
+				 data, 1 << v->data_dev_block_bits,
+				 io_real_digest(v, io))))
+		return 0;
+
+	return memcmp(io_real_digest(v, io), want_digest, v->digest_size) != 0;
+}
+
+/*
+ * Read 1 << v->data_dev_block_bits interleaved FEC blocks into io->fec_buf
+ * and check for erasure locations if neras is non-NULL.
+ */
+static int verity_fec_read_buf(struct dm_verity *v, struct dm_verity_io *io,
+			       u64 rsb, u64 target, int *neras)
+{
+	int i, j, target_index = -1;
+	struct dm_buffer *buf;
+	struct dm_bufio_client *bufio;
+	u64 block, ileaved;
+	u8 *bbuf;
+	u8 want_digest[v->digest_size];
+
+	if (neras)
+		*neras = 0;
+
+	for (i = 0; i < v->fec_rsn; i++) {
+		ileaved = verity_fec_interleave(v, rsb * v->fec_rsn + i);
+
+		if (ileaved == target)
+			target_index = i;
+
+		block = ileaved >> v->data_dev_block_bits;
+		bufio = v->data_bufio;
+
+		if (block >= v->data_blocks) {
+			block -= v->data_blocks;
+
+			if (unlikely(block >= v->fec_hash_blocks))
+				continue;
+
+			block += v->hash_start;
+			bufio = v->hash_bufio;
+		}
+
+		bbuf = dm_bufio_read(bufio, block, &buf);
+
+		if (unlikely(IS_ERR(bbuf))) {
+			DMERR("%s: FEC %llu: read failed (block %llu): %ld",
+			      v->data_dev->name, (unsigned long long)rsb,
+			      (unsigned long long)block, PTR_ERR(bbuf));
+			return -1;
+		}
+
+		if (block < v->data_blocks &&
+		    verity_hash_for_block(v, io, block, want_digest) == 0) {
+			if (neras && *neras <= v->fec_roots &&
+			    verity_fec_is_erasure(v, io, want_digest, bbuf))
+				io->erasures[(*neras)++] = i;
+		}
+
+		for (j = 0; j < 1 << v->data_dev_block_bits; j++)
+			io->fec_buf[j * v->fec_rsn + i] = bbuf[j];
+
+		dm_bufio_release(buf);
+	}
+
+	return target_index;
+}
+
+/*
+ * Initialize Reed-Solomon and FEC buffers, and allocate them if needed.
+ */
+static int verity_fec_alloc_buffers(struct dm_verity *v,
+				    struct dm_verity_io *io)
+{
+	size_t bufsize;
+
+	if (!io->rs) {
+		io->rs = init_rs(8, 0x11d, 0, 1, v->fec_roots);
+
+		if (unlikely(!io->rs)) {
+			DMERR("init_rs failed");
+			return -ENOMEM;
+		}
+	}
+
+	bufsize = v->fec_rsn << v->data_dev_block_bits;
+
+	if (!io->fec_buf) {
+		io->fec_buf = vzalloc(bufsize);
+
+		if (unlikely(!io->fec_buf)) {
+			DMERR("vzalloc failed (%zu bytes)", bufsize);
+			return -ENOMEM;
+		}
+	} else
+		memset(io->fec_buf, 0, bufsize);
+
+	bufsize = v->fec_rsn * sizeof(int);
+
+	if (!io->erasures) {
+		io->erasures = kzalloc(bufsize, GFP_KERNEL);
+
+		if (unlikely(!io->erasures)) {
+			DMERR("kmalloc failed (%zu bytes)", bufsize);
+			return -ENOMEM;
+		}
+	} else
+		memset(io->erasures, 0, bufsize);
+
+	return 0;
+}
+
+/*
+ * Decode an interleaved RS block. If use_erasures is non-zero, uses hashes to
+ * locate erasures. If returns zero, the corrected block is in the beginning of
+ * io->fec_buf.
+ */
+static int verity_fec_decode_rsb(struct dm_verity *v,
+				 struct dm_verity_io *io, u64 rsb,
+				 u64 offset, int use_erasures)
+{
+	int r, neras = 0;
+
+	r = verity_fec_alloc_buffers(v, io);
+	if (unlikely(r < 0))
+		return -1;
+
+	r = verity_fec_read_buf(v, io, rsb, offset,
+				use_erasures ? &neras : NULL);
+	if (unlikely(r < 0))
+		return r;
+
+	r = verity_fec_decode_buf(v, io, rsb, r, neras);
+	if (r < 0)
+		return r;
+
+	r = verity_hash(v, io_hash_desc(v, io), io->fec_buf,
+			1 << v->data_dev_block_bits, io_real_digest(v, io));
+	if (unlikely(r < 0))
+		return r;
+
+	if (memcmp(io_real_digest(v, io), io_want_digest(v, io),
+			v->digest_size)) {
+		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
+			    v->data_dev->name, (unsigned long long)rsb, neras);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int verity_fec_bv_copy(struct dm_verity *v, struct dm_verity_io *io,
+			      u8 *data, size_t len)
+{
+	BUG_ON(io->fec_pos + len > 1 << v->data_dev_block_bits);
+	memcpy(data, &io->fec_buf[io->fec_pos], len);
+	io->fec_pos += len;
+	return 0;
+}
+
+/*
+ * Correct errors in a block. Copies corrected block to dest if non-NULL,
+ * otherwise to io->bio_vec starting from provided vector and offset.
+ */
+static int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
+			     enum verity_block_type type, sector_t block,
+			     u8 *dest, struct bvec_iter *iter)
+{
+	int r = -1;
+	u64 offset, res, rsb;
+
+	if (!v->fec_bufio)
+		return -1;
+
+	if (type == DM_VERITY_BLOCK_TYPE_METADATA)
+		block += v->data_blocks;
+
+	/*
+	 * For RS(M, N), the continuous FEC data is divided into blocks of N
+	 * bytes. Since block size may not be divisible by N, the last block
+	 * is zero padded when decoding.
+	 *
+	 * Each byte of the block is covered by a different RS(255, N) code,
+	 * and each code is interleaved over N blocks to make it less likely
+	 * that bursty corruption will leave us in unrecoverable state.
+	 */
+
+	offset = block << v->data_dev_block_bits;
+
+	res = offset;
+	do_div(res, v->fec_rounds << v->data_dev_block_bits);
+
+	/*
+	 * The base RS block we can feed to the interleaver to find out all
+	 * blocks required for decoding.
+	 */
+	rsb = offset - res * (v->fec_rounds << v->data_dev_block_bits);
+
+	/*
+	 * Locating erasures is slow, so attempt to recover the block without
+	 * them first. Do a second attempt with erasures if the corruption is
+	 * bad enough.
+	 */
+	r = verity_fec_decode_rsb(v, io, rsb, offset, 0);
+	if (r < 0)
+		r = verity_fec_decode_rsb(v, io, rsb, offset, 1);
+
+	if (r < 0)
+		return r;
+
+	if (dest)
+		memcpy(dest, io->fec_buf, 1 << v->hash_dev_block_bits);
+	else if (iter) {
+		io->fec_pos = 0;
+		r = verity_for_bv_block(v, io, iter, verity_fec_bv_copy);
+	}
+
+	return r;
+}
+
+
+/*
  * End one "io" structure with a given error.
  */
 static void verity_finish_io(struct dm_verity_io *io, int error)
@@ -490,6 +893,14 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
 	bio->bi_private = io->orig_bi_private;
 	bio->bi_error = error;
 
+	if (io->rs)
+		free_rs(io->rs);
+
+	if (io->fec_buf)
+		vfree(io->fec_buf);
+
+	kfree(io->erasures);
+
 	bio_endio(bio);
 }
 
@@ -546,7 +957,7 @@ static void verity_prefetch_io(struct work_struct *work)
 				hash_block_end = v->hash_blocks - 1;
 		}
 no_prefetch_cluster:
-		dm_bufio_prefetch(v->bufio, hash_block_start,
+		dm_bufio_prefetch(v->hash_bufio, hash_block_start,
 				  hash_block_end - hash_block_start + 1);
 	}
 
@@ -608,6 +1019,10 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	bio->bi_private = io;
 	io->iter = bio->bi_iter;
 
+	io->rs = NULL;
+	io->erasures = NULL;
+	io->fec_buf = NULL;
+
 	verity_submit_prefetch(v, io);
 
 	generic_make_request(bio);
@@ -622,6 +1037,7 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct dm_verity *v = ti->private;
+	unsigned args = 0;
 	unsigned sz = 0;
 	unsigned x;
 
@@ -648,8 +1064,15 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 		else
 			for (x = 0; x < v->salt_size; x++)
 				DMEMIT("%02x", v->salt[x]);
+		if (v->mode != DM_VERITY_MODE_EIO)
+			args++;
+		if (v->fec_dev)
+			args += DM_VERITY_OPTS_FEC;
+		if (!args)
+			return;
+		DMEMIT(" %u", args);
 		if (v->mode != DM_VERITY_MODE_EIO) {
-			DMEMIT(" 1 ");
+			DMEMIT(" ");
 			switch (v->mode) {
 			case DM_VERITY_MODE_LOGGING:
 				DMEMIT(DM_VERITY_OPT_LOGGING);
@@ -661,6 +1084,15 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 				BUG();
 			}
 		}
+		if (v->fec_dev)
+			DMEMIT(" " DM_VERITY_OPT_FEC_DEV " %s "
+			       DM_VERITY_OPT_FEC_BLOCKS " %llu "
+			       DM_VERITY_OPT_FEC_START " %llu "
+			       DM_VERITY_OPT_FEC_ROOTS " %d",
+			       v->fec_dev->name,
+			       (unsigned long long)v->fec_blocks,
+			       (unsigned long long)v->fec_start,
+			       v->fec_roots);
 		break;
 	}
 }
@@ -707,8 +1139,12 @@ static void verity_dtr(struct dm_target *ti)
 	if (v->verify_wq)
 		destroy_workqueue(v->verify_wq);
 
-	if (v->bufio)
-		dm_bufio_client_destroy(v->bufio);
+	if (v->data_bufio)
+		dm_bufio_client_destroy(v->data_bufio);
+	if (v->hash_bufio)
+		dm_bufio_client_destroy(v->hash_bufio);
+	if (v->fec_bufio)
+		dm_bufio_client_destroy(v->fec_bufio);
 
 	kfree(v->salt);
 	kfree(v->root_digest);
@@ -718,11 +1154,12 @@ static void verity_dtr(struct dm_target *ti)
 
 	kfree(v->alg_name);
 
-	if (v->hash_dev)
-		dm_put_device(ti, v->hash_dev);
-
 	if (v->data_dev)
 		dm_put_device(ti, v->data_dev);
+	if (v->hash_dev)
+		dm_put_device(ti, v->hash_dev);
+	if (v->fec_dev)
+		dm_put_device(ti, v->fec_dev);
 
 	kfree(v);
 }
@@ -730,6 +1167,11 @@ static void verity_dtr(struct dm_target *ti)
 static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 				 const char *opt_string)
 {
+	int r;
+	unsigned long long num_ll;
+	unsigned char num_c;
+	char dummy;
+
 	if (!strcasecmp(opt_string, DM_VERITY_OPT_LOGGING)) {
 		v->mode = DM_VERITY_MODE_LOGGING;
 		return 0;
@@ -738,6 +1180,53 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		return 0;
 	}
 
+	/* Remaining arguments require a value */
+	if (!as->argc)
+		goto bad;
+
+	if (!strcasecmp(opt_string, DM_VERITY_OPT_FEC_DEV)) {
+		r = dm_get_device(v->ti, dm_shift_arg(as), FMODE_READ,
+					  &v->fec_dev);
+		if (r) {
+			v->ti->error = "FEC device lookup failed";
+			return r;
+		}
+
+		return 1;
+	} else if (!strcasecmp(opt_string, DM_VERITY_OPT_FEC_BLOCKS)) {
+		if (sscanf(dm_shift_arg(as), "%llu%c", &num_ll, &dummy) != 1 ||
+		    (sector_t)(num_ll <<
+				(v->data_dev_block_bits - SECTOR_SHIFT))
+		    >> (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll) {
+			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
+			return -EINVAL;
+		}
+
+		v->fec_blocks = num_ll;
+		return 1;
+	} else if (!strcasecmp(opt_string, DM_VERITY_OPT_FEC_START)) {
+		if (sscanf(dm_shift_arg(as), "%llu%c", &num_ll, &dummy) != 1 ||
+		    (sector_t)(num_ll <<
+				(v->data_dev_block_bits - SECTOR_SHIFT))
+		    >> (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll) {
+			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_START;
+			return -EINVAL;
+		}
+
+		v->fec_start = num_ll;
+		return 1;
+	} else if (!strcasecmp(opt_string, DM_VERITY_OPT_FEC_ROOTS)) {
+		if (sscanf(dm_shift_arg(as), "%hhu%c", &num_c, &dummy) != 1 ||
+		    !num_c || num_c >= DM_VERITY_FEC_RSM) {
+			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
+			return -EINVAL;
+		}
+
+		v->fec_roots = num_c;
+		return 1;
+	}
+
+bad:
 	v->ti->error = "Invalid feature arguments";
 	return -EINVAL;
 }
@@ -968,17 +1457,17 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 	v->hash_blocks = hash_position;
 
-	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
+	v->hash_bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
-		dm_bufio_alloc_callback, NULL);
-	if (IS_ERR(v->bufio)) {
-		ti->error = "Cannot initialize dm-bufio";
-		r = PTR_ERR(v->bufio);
-		v->bufio = NULL;
+		dm_hash_bufio_alloc_callback, NULL);
+	if (IS_ERR(v->hash_bufio)) {
+		ti->error = "Cannot initialize dm-bufio for hash device";
+		r = PTR_ERR(v->hash_bufio);
+		v->hash_bufio = NULL;
 		goto bad;
 	}
 
-	if (dm_bufio_get_device_size(v->bufio) < v->hash_blocks) {
+	if (dm_bufio_get_device_size(v->hash_bufio) < v->hash_blocks) {
 		ti->error = "Hash device is too small";
 		r = -E2BIG;
 		goto bad;
@@ -994,6 +1483,115 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
+	if (v->fec_dev) {
+		/*
+		 * FEC is computed over data blocks, hash blocks, and possible
+		 * metadata. In other words, FEC covers total of fec_blocks
+		 * blocks consisting of the following:
+		 *
+		 *  data blocks | hash blocks | metadata (optional)
+		 *
+		 * We allow metadata after hash blocks to support a use case
+		 * where all data is stored on the same device and FEC covers
+		 * the entire area.
+		 *
+		 * If metadata is included, we require it to be available on the
+		 * hash device after the hash blocks.
+		 */
+
+		u64 hash_blocks = v->hash_blocks - v->hash_start;
+
+		/*
+		 * Require matching block sizes for data and hash devices for
+		 * simplicity.
+		 */
+		if (v->data_dev_block_bits != v->hash_dev_block_bits) {
+			ti->error = "Block sizes must match to use FEC";
+			r = -EINVAL;
+			goto bad;
+		}
+
+		if (!v->fec_roots) {
+			ti->error = "Missing " DM_VERITY_OPT_FEC_ROOTS;
+			r = -EINVAL;
+			goto bad;
+		}
+
+		v->fec_rsn = DM_VERITY_FEC_RSM - v->fec_roots;
+
+		if (!v->fec_blocks) {
+			ti->error = "Missing " DM_VERITY_OPT_FEC_BLOCKS;
+			r = -EINVAL;
+			goto bad;
+		}
+
+		v->fec_rounds = v->fec_blocks;
+
+		if (do_div(v->fec_rounds, v->fec_rsn))
+			v->fec_rounds++;
+
+		/*
+		 * Due to optional metadata, fec_blocks can be larger than
+		 * data_blocks and hash_blocks combined.
+		 */
+		if (v->fec_blocks < v->data_blocks + hash_blocks ||
+				!v->fec_rounds) {
+			ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
+			r = -EINVAL;
+			goto bad;
+		}
+
+		/*
+		 * Metadata is accessed through the hash device, so we require
+		 * it to be large enough.
+		 */
+		v->fec_hash_blocks = v->fec_blocks - v->data_blocks;
+
+		if (dm_bufio_get_device_size(v->hash_bufio) <
+				v->fec_hash_blocks) {
+			ti->error = "Hash device is too small for "
+					DM_VERITY_OPT_FEC_BLOCKS;
+			r = -E2BIG;
+			goto bad;
+		}
+
+		v->fec_bufio = dm_bufio_client_create(v->fec_dev->bdev,
+					1 << v->data_dev_block_bits,
+					1, 0, NULL, NULL);
+
+		if (IS_ERR(v->fec_bufio)) {
+			ti->error = "Cannot initialize dm-bufio";
+			r = PTR_ERR(v->fec_bufio);
+			v->fec_bufio = NULL;
+			goto bad;
+		}
+
+		if (dm_bufio_get_device_size(v->fec_bufio) <
+				(v->fec_start + v->fec_rounds * v->fec_roots)
+				>> v->data_dev_block_bits) {
+			ti->error = "FEC device is too small";
+			r = -E2BIG;
+			goto bad;
+		}
+
+		v->data_bufio = dm_bufio_client_create(v->data_dev->bdev,
+					1 << v->data_dev_block_bits,
+					1, 0, NULL, NULL);
+
+		if (IS_ERR(v->data_bufio)) {
+			ti->error = "Cannot initialize dm-bufio";
+			r = PTR_ERR(v->data_bufio);
+			v->data_bufio = NULL;
+			goto bad;
+		}
+
+		if (dm_bufio_get_device_size(v->data_bufio) < v->data_blocks) {
+			ti->error = "Data device is too small";
+			r = -E2BIG;
+			goto bad;
+		}
+	}
+
 	return 0;
 
 bad:
@@ -1037,5 +1635,6 @@ module_exit(dm_verity_exit);
 MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
 MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
 MODULE_AUTHOR("Will Drewry <wad@chromium.org>");
+MODULE_AUTHOR("Sami Tolvanen <samitolvanen@google.com>");
 MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity checking");
 MODULE_LICENSE("GPL");
-- 
2.6.0.rc2.230.g3dd15c0
