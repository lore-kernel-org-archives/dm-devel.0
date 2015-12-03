From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH v2 1/2] dm verity: add support for forward error correction
Date: Thu,  3 Dec 2015 14:26:30 +0000
Message-ID: <1449152791-33586-2-git-send-email-samitolvanen@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <1449152791-33586-1-git-send-email-samitolvanen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449152791-33586-1-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>, Sami Tolvanen <samitolvanen@google.com>
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
 Documentation/device-mapper/verity.txt         |  25 +
 drivers/md/Kconfig                             |  12 +
 drivers/md/Makefile                            |   5 +
 drivers/md/dm-verity-fec.c                     | 830 +++++++++++++++++++++++++
 drivers/md/dm-verity-fec.h                     | 146 +++++
 drivers/md/{dm-verity.c => dm-verity-target.c} | 244 ++++----
 drivers/md/dm-verity.h                         | 128 ++++
 7 files changed, 1259 insertions(+), 131 deletions(-)
 create mode 100644 drivers/md/dm-verity-fec.c
 create mode 100644 drivers/md/dm-verity-fec.h
 rename drivers/md/{dm-verity.c => dm-verity-target.c} (84%)
 create mode 100644 drivers/md/dm-verity.h

diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
index e15bc1a..1058f36 100644
--- a/Documentation/device-mapper/verity.txt
+++ b/Documentation/device-mapper/verity.txt
@@ -79,6 +79,31 @@ restart_on_corruption
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
 
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 1b69359..0a2e727 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -467,6 +467,18 @@ config DM_VERITY
 
 	  If unsure, say N.
 
+config DM_VERITY_FEC
+	bool "Verity forward error correction support"
+	depends on DM_VERITY
+	select REED_SOLOMON
+	select REED_SOLOMON_DEC8
+	---help---
+	  Add forward error correction support to dm-verity. This option
+	  makes it possible to use pre-generated error correction data to
+	  recover from corrupted blocks.
+
+	  If unsure, say N.
+
 config DM_SWITCH
 	tristate "Switch target support (EXPERIMENTAL)"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index f34979c..62a6576 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -16,6 +16,7 @@ dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-smq-y   += dm-cache-policy-smq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 dm-era-y	+= dm-era-target.o
+dm-verity-y	+= dm-verity-target.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o raid5-cache.o
 
@@ -63,3 +64,7 @@ obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
 endif
+
+ifeq ($(CONFIG_DM_VERITY_FEC),y)
+dm-verity-objs			+= dm-verity-fec.o
+endif
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
new file mode 100644
index 0000000..c3a2531
--- /dev/null
+++ b/drivers/md/dm-verity-fec.c
@@ -0,0 +1,830 @@
+/*
+ * Copyright (C) 2015 Google, Inc.
+ *
+ * Author: Sami Tolvanen <samitolvanen@google.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include "dm-verity-fec.h"
+
+#define DM_MSG_PREFIX	"verity-fec"
+
+/*
+ * If error correction has been configured, returns true.
+ */
+bool verity_fec_is_enabled(struct dm_verity *v)
+{
+	return v->fec && v->fec->dev;
+}
+
+/*
+ * Return a pointer to dm_verity_fec_io after dm_verity_io and its variable
+ * length fields.
+ */
+static inline struct dm_verity_fec_io *fec_io(struct dm_verity_io *io)
+{
+	return (struct dm_verity_fec_io *) verity_io_digest_end(io->v, io);
+}
+
+/*
+ * Return an interleaved offset for a byte in RS block.
+ */
+static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
+{
+	u32 mod;
+
+	mod = do_div(offset, v->fec->rsn);
+	return offset + mod * (v->fec->rounds << v->data_dev_block_bits);
+}
+
+/*
+ * Decode an RS block using Reed-Solomon.
+ */
+static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
+			  u8 *data, u8 *fec, int neras)
+{
+	int i;
+	uint16_t par[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+
+	for (i = 0; i < v->fec->roots; i++)
+		par[i] = fec[i];
+
+	return decode_rs8(fio->rs, data, par, v->fec->rsn, NULL, neras,
+			  fio->erasures, 0, NULL);
+}
+
+/*
+ * Read error-correcting codes for the requested RS block. Returns a pointer
+ * to the data block. Caller is responsible for releasing buf.
+ */
+static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
+			   unsigned *offset, struct dm_buffer **buf)
+{
+	u64 position, block;
+	u8 *res;
+
+	position = (index + rsb) * v->fec->roots;
+	block = position >> v->data_dev_block_bits;
+
+	*offset = (unsigned)(position - (block << v->data_dev_block_bits));
+
+	res = dm_bufio_read(v->fec->bufio, v->fec->start + block, buf);
+
+	if (unlikely(IS_ERR(res))) {
+		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+		      v->data_dev->name, (unsigned long long)rsb,
+		      (unsigned long long)(v->fec->start + block),
+		      PTR_ERR(res));
+		*buf = NULL;
+		return NULL;
+	}
+
+	return res;
+}
+
+/* Loop over each preallocated buffer slot. */
+#define fec_for_each_prealloc_buffer(__i) \
+	for (__i = 0; __i < DM_VERITY_FEC_BUF_PREALLOC; __i++)
+
+/* Loop over each extra buffer slot. */
+#define fec_for_each_extra_buffer(io, __i) \
+	for (__i = DM_VERITY_FEC_BUF_PREALLOC; __i < DM_VERITY_FEC_BUF_MAX; \
+		__i++)
+
+/* Loop over each allocated buffer. */
+#define fec_for_each_buffer(io, __i) \
+	for (__i = 0; __i < (io)->nbufs; __i++)
+
+/* Loop over each RS block in each allocated buffer. */
+#define fec_for_each_buffer_rs_block(io, __i, __j) \
+	fec_for_each_buffer(io, __i) \
+		for (__j = 0; __j < 1 << DM_VERITY_FEC_BUF_RS_BITS; __j++)
+
+/*
+ * Return a pointer to the current RS block when called inside
+ * fec_for_each_buffer_rs_block.
+ */
+static inline u8 *fec_buffer_rs_block(struct dm_verity *v,
+				      struct dm_verity_fec_io *fio,
+				      unsigned i, unsigned j)
+{
+	return &fio->bufs[i][j * v->fec->rsn];
+}
+
+/*
+ * Return an index to the current RS block when called inside
+ * fec_for_each_buffer_rs_block.
+ */
+static inline unsigned fec_buffer_rs_index(unsigned i, unsigned j)
+{
+	return (i << DM_VERITY_FEC_BUF_RS_BITS) + j;
+}
+
+/*
+ * Decode all RS blocks from buffers and copy corrected bytes into fio->output
+ * starting from block_offset.
+ */
+static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
+			   u64 rsb, int byte_index, unsigned block_offset,
+			   int neras)
+{
+	int r = -1, corrected = 0, res;
+	struct dm_buffer *buf;
+	unsigned n, i, offset;
+	u8 *par, *block;
+
+	par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
+	if (unlikely(!par))
+		return r;
+
+	/*
+	 * Decode the RS blocks we have in bufs. Each RS block results in
+	 * one corrected target byte and consumes fec->roots parity bytes.
+	 */
+	fec_for_each_buffer_rs_block(fio, n, i) {
+		block = fec_buffer_rs_block(v, fio, n, i);
+		res = fec_decode_rs8(v, fio, block, &par[offset], neras);
+
+		if (res < 0)
+			goto error;
+
+		corrected += res;
+		fio->output[block_offset] = block[byte_index];
+
+		block_offset++;
+		if (block_offset >= 1 << v->data_dev_block_bits)
+			goto done;
+
+		/* read the next block when we run out of parity bytes */
+		offset += v->fec->roots;
+		if (offset >= 1 << v->data_dev_block_bits) {
+			dm_bufio_release(buf);
+
+			par = fec_read_parity(v, rsb, block_offset, &offset,
+					      &buf);
+			if (unlikely(!par))
+				return r;
+		}
+	}
+
+done:
+	r = corrected;
+error:
+	dm_bufio_release(buf);
+
+	if (r < 0 && neras)
+		DMERR_LIMIT("%s: FEC %llu: failed to correct: %d",
+			    v->data_dev->name, (unsigned long long)rsb, r);
+	else if (r > 0)
+		DMWARN_LIMIT("%s: FEC %llu: corrected %d errors",
+			     v->data_dev->name, (unsigned long long)rsb,
+			     r);
+
+	return r;
+}
+
+/*
+ * Locate data block erasures using verity hashes.
+ */
+static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
+			  u8 *want_digest, u8 *data)
+{
+	if (unlikely(verity_hash(v, verity_io_hash_desc(v, io),
+				 data, 1 << v->data_dev_block_bits,
+				 verity_io_real_digest(v, io))))
+		return 0;
+
+	return memcmp(verity_io_real_digest(v, io), want_digest,
+		      v->digest_size) != 0;
+}
+
+/*
+ * Read data blocks that are part of the RS block and deinterleave as much as
+ * fits into buffers. Check for erasure locations if neras is non-NULL.
+ */
+static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
+			 u64 rsb, u64 target, unsigned block_offset,
+			 int *neras)
+{
+	int i, j, target_index = -1;
+	struct dm_buffer *buf;
+	struct dm_bufio_client *bufio;
+	struct dm_verity_fec_io *fio = fec_io(io);
+	u64 block, ileaved;
+	u8 *bbuf, *rs_block;
+	u8 want_digest[v->digest_size];
+	unsigned n, k;
+
+	if (neras)
+		*neras = 0;
+
+	/*
+	 * read each of the rsn data blocks that are part of the RS block, and
+	 * interleave contents to available bufs
+	 */
+	for (i = 0; i < v->fec->rsn; i++) {
+		ileaved = fec_interleave(v, rsb * v->fec->rsn + i);
+
+		/*
+		 * target is the data block we want to correct, target_index is
+		 * the index of this block within the rsn RS blocks
+		 */
+		if (ileaved == target)
+			target_index = i;
+
+		block = ileaved >> v->data_dev_block_bits;
+		bufio = v->fec->data_bufio;
+
+		if (block >= v->data_blocks) {
+			block -= v->data_blocks;
+
+			/*
+			 * blocks outside the area were assumed to contain
+			 * zeros when encoding data was generated
+			 */
+			if (unlikely(block >= v->fec->hash_blocks))
+				continue;
+
+			block += v->hash_start;
+			bufio = v->bufio;
+		}
+
+		bbuf = dm_bufio_read(bufio, block, &buf);
+
+		if (unlikely(IS_ERR(bbuf))) {
+			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
+				     v->data_dev->name,
+				     (unsigned long long)rsb,
+				     (unsigned long long)block, PTR_ERR(bbuf));
+
+			/* assume the block is corrupted */
+			if (neras && *neras <= v->fec->roots)
+				fio->erasures[(*neras)++] = i;
+
+			continue;
+		}
+
+		/* locate erasures if the block is on the data device */
+		if (bufio == v->fec->data_bufio &&
+		    verity_hash_for_block(v, io, block, want_digest) == 0) {
+			/*
+			 * skip if we have already found the theoretical
+			 * maximum number (i.e. fec->roots) of erasures
+			 */
+			if (neras && *neras <= v->fec->roots &&
+			    fec_is_erasure(v, io, want_digest, bbuf))
+				fio->erasures[(*neras)++] = i;
+		}
+
+		/*
+		 * deinterleave and copy the bytes that fit into bufs,
+		 * starting from block_offset
+		 */
+		fec_for_each_buffer_rs_block(fio, n, j) {
+			k = fec_buffer_rs_index(n, j) + block_offset;
+
+			if (k >= 1 << v->data_dev_block_bits)
+				goto done;
+
+			rs_block = fec_buffer_rs_block(v, fio, n, j);
+			rs_block[i] = bbuf[k];
+		}
+
+done:
+		dm_bufio_release(buf);
+	}
+
+	return target_index;
+}
+
+/*
+ * Allocate RS control structure and FEC buffers from preallocated mempools,
+ * and attempt to allocate as many extra buffers as available.
+ */
+static int fec_alloc_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
+{
+	unsigned n;
+
+	if (!fio->rs) {
+		fio->rs = mempool_alloc(v->fec->rs_pool, 0);
+
+		if (unlikely(!fio->rs)) {
+			DMERR("failed to allocate RS");
+			return -ENOMEM;
+		}
+	}
+
+	fec_for_each_prealloc_buffer(n) {
+		if (fio->bufs[n])
+			continue;
+
+		fio->bufs[n] = mempool_alloc(v->fec->prealloc_pool, GFP_NOIO);
+
+		if (unlikely(!fio->bufs[n])) {
+			DMERR("failed to allocate FEC buffer");
+			return -ENOMEM;
+		}
+	}
+
+	/* try to allocate the maximum number of buffers */
+	fec_for_each_extra_buffer(fio, n) {
+		if (fio->bufs[n])
+			continue;
+
+		fio->bufs[n] = mempool_alloc(v->fec->extra_pool, GFP_NOIO);
+
+		/* we can manage with even one buffer if necessary */
+		if (unlikely(!fio->bufs[n]))
+			break;
+	}
+
+	fio->nbufs = n;
+
+	if (!fio->output) {
+		fio->output = mempool_alloc(v->fec->output_pool, GFP_NOIO);
+
+		if (!fio->output) {
+			DMERR("failed to allocate FEC page");
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize buffers and clear erasures. fec_read_bufs assumes buffers are
+ * zeroed before deinterleaving.
+ */
+static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
+{
+	unsigned n;
+
+	fec_for_each_buffer(fio, n)
+		memset(fio->bufs[n], 0,
+		       v->fec->rsn << DM_VERITY_FEC_BUF_RS_BITS);
+
+	memset(fio->erasures, 0, sizeof(fio->erasures));
+}
+
+/*
+ * Decode all RS blocks in a single data block and return the target block
+ * (indicated by "offset") in fio->output. If use_erasures is non-zero, uses
+ * hashes to locate erasures.
+ */
+static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
+			  struct dm_verity_fec_io *fio, u64 rsb, u64 offset,
+			  int use_erasures)
+{
+	int r, neras = 0;
+	unsigned pos;
+
+	r = fec_alloc_bufs(v, fio);
+	if (unlikely(r < 0))
+		return -1;
+
+	for (pos = 0; pos < 1 << v->data_dev_block_bits; ) {
+		fec_init_bufs(v, fio);
+
+		r = fec_read_bufs(v, io, rsb, offset, pos,
+				  use_erasures ? &neras : NULL);
+		if (unlikely(r < 0))
+			return r;
+
+		r = fec_decode_bufs(v, fio, rsb, r, pos, neras);
+		if (r < 0)
+			return r;
+
+		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
+	}
+
+	/* Always re-validate the corrected block against the expected hash */
+	r = verity_hash(v, verity_io_hash_desc(v, io), fio->output,
+			1 << v->data_dev_block_bits,
+			verity_io_real_digest(v, io));
+	if (unlikely(r < 0))
+		return r;
+
+	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
+		   v->digest_size)) {
+		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
+			    v->data_dev->name, (unsigned long long)rsb,
+			    neras);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int fec_bv_copy(struct dm_verity *v, struct dm_verity_io *io, u8 *data,
+		       size_t len)
+{
+	struct dm_verity_fec_io *fio = fec_io(io);
+
+	memcpy(data, &fio->output[fio->output_pos], len);
+	fio->output_pos += len;
+
+	return 0;
+}
+
+/*
+ * Correct errors in a block. Copies corrected block to dest if non-NULL,
+ * otherwise to a bio_vec starting from iter.
+ */
+int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
+		      enum verity_block_type type, sector_t block, u8 *dest,
+		      struct bvec_iter *iter)
+{
+	int r = -1;
+	struct dm_verity_fec_io *fio = fec_io(io);
+	u64 offset, res, rsb;
+
+	if (!verity_fec_is_enabled(v))
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
+	 * Each byte of the block is covered by a different RS(M, N) code,
+	 * and each code is interleaved over N blocks to make it less likely
+	 * that bursty corruption will leave us in unrecoverable state.
+	 */
+
+	offset = block << v->data_dev_block_bits;
+
+	res = offset;
+	do_div(res, v->fec->rounds << v->data_dev_block_bits);
+
+	/*
+	 * The base RS block we can feed to the interleaver to find out all
+	 * blocks required for decoding.
+	 */
+	rsb = offset - res * (v->fec->rounds << v->data_dev_block_bits);
+
+	/*
+	 * Locating erasures is slow, so attempt to recover the block without
+	 * them first. Do a second attempt with erasures if the corruption is
+	 * bad enough.
+	 */
+	r = fec_decode_rsb(v, io, fio, rsb, offset, 0);
+	if (r < 0)
+		r = fec_decode_rsb(v, io, fio, rsb, offset, 1);
+
+	if (r < 0)
+		return r;
+
+	if (dest)
+		memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
+	else if (iter) {
+		fio->output_pos = 0;
+		r = verity_for_bv_block(v, io, iter, fec_bv_copy);
+	}
+
+	return r;
+}
+
+/*
+ * Clean up per-bio data.
+ */
+void verity_fec_finish_io(struct dm_verity_io *io)
+{
+	unsigned n;
+	struct dm_verity_fec *f = io->v->fec;
+	struct dm_verity_fec_io *fio = fec_io(io);
+
+	if (!verity_fec_is_enabled(io->v))
+		return;
+
+	mempool_free(fio->rs, f->rs_pool);
+
+	fec_for_each_prealloc_buffer(n)
+		mempool_free(fio->bufs[n], f->prealloc_pool);
+
+	fec_for_each_extra_buffer(fio, n)
+		mempool_free(fio->bufs[n], f->extra_pool);
+
+	mempool_free(fio->output, f->output_pool);
+}
+
+/*
+ * Initialize per-bio data.
+ */
+void verity_fec_init_io(struct dm_verity_io *io)
+{
+	struct dm_verity_fec_io *fio = fec_io(io);
+
+	if (!verity_fec_is_enabled(io->v))
+		return;
+
+	fio->rs = NULL;
+	memset(fio->bufs, 0, sizeof(fio->bufs));
+	fio->nbufs = 0;
+	fio->output = NULL;
+}
+
+/*
+ * Append feature arguments and values to the status table.
+ */
+unsigned verity_fec_status_table(struct dm_verity *v, unsigned sz,
+				 char *result, unsigned maxlen)
+{
+	if (!verity_fec_is_enabled(v))
+		return sz;
+
+	DMEMIT(" " DM_VERITY_OPT_FEC_DEV " %s "
+	       DM_VERITY_OPT_FEC_BLOCKS " %llu "
+	       DM_VERITY_OPT_FEC_START " %llu "
+	       DM_VERITY_OPT_FEC_ROOTS " %d",
+	       v->fec->dev->name,
+	       (unsigned long long)v->fec->blocks,
+	       (unsigned long long)v->fec->start,
+	       v->fec->roots);
+
+	return sz;
+}
+
+void verity_fec_dtr(struct dm_verity *v)
+{
+	struct dm_verity_fec *f = v->fec;
+
+	if (!verity_fec_is_enabled(v))
+		goto out;
+
+	mempool_destroy(f->rs_pool);
+	mempool_destroy(f->prealloc_pool);
+	mempool_destroy(f->extra_pool);
+	kmem_cache_destroy(f->cache);
+
+	if (f->data_bufio)
+		dm_bufio_client_destroy(f->data_bufio);
+	if (f->bufio)
+		dm_bufio_client_destroy(f->bufio);
+
+	if (f->dev)
+		dm_put_device(v->ti, f->dev);
+
+out:
+	kfree(f);
+	v->fec = NULL;
+}
+
+static void *fec_rs_alloc(gfp_t gfp_mask, void *pool_data)
+{
+	struct dm_verity *v = (struct dm_verity *)pool_data;
+
+	return init_rs(8, 0x11d, 0, 1, v->fec->roots);
+}
+
+static void fec_rs_free(void *element, void *pool_data)
+{
+	struct rs_control *rs = (struct rs_control *)element;
+
+	if (rs)
+		free_rs(rs);
+}
+
+int verity_fec_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
+			      unsigned *argc, const char *arg_name)
+{
+	int r;
+	const char *arg_value;
+	unsigned long long num_ll;
+	unsigned char num_c;
+	char dummy;
+
+	/* All feature arguments require a value */
+	if (!*argc)
+		return -EINVAL;
+
+	arg_value = dm_shift_arg(as);
+	(*argc)--;
+
+	if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_DEV)) {
+		r = dm_get_device(v->ti, arg_value, FMODE_READ, &v->fec->dev);
+		if (r) {
+			v->ti->error = "FEC device lookup failed";
+			return r;
+		}
+
+		return 0;
+	} else if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_BLOCKS)) {
+		if (sscanf(arg_value, "%llu%c", &num_ll, &dummy) != 1 ||
+		    (sector_t)(num_ll <<
+				(v->data_dev_block_bits - SECTOR_SHIFT))
+		    >> (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll) {
+			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
+			return -EINVAL;
+		}
+
+		v->fec->blocks = num_ll;
+		return 0;
+	} else if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_START)) {
+		if (sscanf(arg_value, "%llu%c", &num_ll, &dummy) != 1 ||
+		    (sector_t)(num_ll <<
+				(v->data_dev_block_bits - SECTOR_SHIFT))
+		    >> (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll) {
+			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_START;
+			return -EINVAL;
+		}
+
+		v->fec->start = num_ll;
+		return 0;
+	} else if (!strcasecmp(arg_name, DM_VERITY_OPT_FEC_ROOTS)) {
+		if (sscanf(arg_value, "%hhu%c", &num_c, &dummy) != 1 ||
+		    !num_c ||
+		    num_c < (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MAX_RSN) ||
+		    num_c > (DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN)) {
+			v->ti->error = "Invalid " DM_VERITY_OPT_FEC_ROOTS;
+			return -EINVAL;
+		}
+
+		v->fec->roots = num_c;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+/*
+ * Allocate dm_verity_fec for v->fec. Must be called before verity_fec_ctr.
+ */
+int verity_fec_ctr_alloc(struct dm_verity *v)
+{
+	struct dm_verity_fec *f;
+
+	f = kzalloc(sizeof(struct dm_verity_fec), GFP_KERNEL);
+	if (!f) {
+		v->ti->error = "Cannot allocate FEC structure";
+		return -ENOMEM;
+	}
+
+	v->fec = f;
+	return 0;
+}
+
+/*
+ * Validate arguments and preallocate memory. Must be called after arguments
+ * have been parsed using verity_fec_parse_opt_args.
+ */
+int verity_fec_ctr(struct dm_verity *v)
+{
+	struct dm_verity_fec *f = v->fec;
+	u64 hash_blocks;
+
+	if (!verity_fec_is_enabled(v)) {
+		verity_fec_dtr(v);
+		return 0;
+	}
+
+	/*
+	 * FEC is computed over data blocks, possible metadata, and
+	 * hash blocks. In other words, FEC covers total of fec_blocks
+	 * blocks consisting of the following:
+	 *
+	 *  data blocks | hash blocks | metadata (optional)
+	 *
+	 * We allow metadata after hash blocks to support a use case
+	 * where all data is stored on the same device and FEC covers
+	 * the entire area.
+	 *
+	 * If metadata is included, we require it to be available on the
+	 * hash device after the hash blocks.
+	 */
+
+	hash_blocks = v->hash_blocks - v->hash_start;
+
+	/*
+	 * Require matching block sizes for data and hash devices for
+	 * simplicity.
+	 */
+	if (v->data_dev_block_bits != v->hash_dev_block_bits) {
+		v->ti->error = "Block sizes must match to use FEC";
+		return -EINVAL;
+	}
+
+	if (!f->roots) {
+		v->ti->error = "Missing " DM_VERITY_OPT_FEC_ROOTS;
+		return -EINVAL;
+	}
+
+	f->rsn = DM_VERITY_FEC_RSM - f->roots;
+
+	if (!f->blocks) {
+		v->ti->error = "Missing " DM_VERITY_OPT_FEC_BLOCKS;
+		return -EINVAL;
+	}
+
+	f->rounds = f->blocks;
+
+	if (do_div(f->rounds, f->rsn))
+		f->rounds++;
+
+	/*
+	 * Due to optional metadata, f->blocks can be larger than
+	 * data_blocks and hash_blocks combined.
+	 */
+	if (f->blocks < v->data_blocks + hash_blocks || !f->rounds) {
+		v->ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
+		return -EINVAL;
+	}
+
+	/*
+	 * Metadata is accessed through the hash device, so we require
+	 * it to be large enough.
+	 */
+	f->hash_blocks = f->blocks - v->data_blocks;
+
+	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+		v->ti->error = "Hash device is too small for "
+				DM_VERITY_OPT_FEC_BLOCKS;
+		return -E2BIG;
+	}
+
+	f->bufio = dm_bufio_client_create(f->dev->bdev,
+				1 << v->data_dev_block_bits,
+				1, 0, NULL, NULL);
+
+	if (IS_ERR(f->bufio)) {
+		v->ti->error = "Cannot initialize dm-bufio";
+		return PTR_ERR(f->bufio);
+	}
+
+	if (dm_bufio_get_device_size(f->bufio) <
+			(f->start + f->rounds * f->roots)
+				>> v->data_dev_block_bits) {
+		v->ti->error = "FEC device is too small";
+		return -E2BIG;
+	}
+
+	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev,
+				1 << v->data_dev_block_bits,
+				1, 0, NULL, NULL);
+
+	if (IS_ERR(f->data_bufio)) {
+		v->ti->error = "Cannot initialize dm-bufio";
+		return PTR_ERR(f->data_bufio);
+	}
+
+	if (dm_bufio_get_device_size(f->data_bufio) < v->data_blocks) {
+		v->ti->error = "Data device is too small";
+		return -E2BIG;
+	}
+
+	/* Preallocate an rs_control structure for each worker thread */
+	f->rs_pool = mempool_create(num_online_cpus(), fec_rs_alloc,
+				fec_rs_free, (void *) v);
+
+	if (!f->rs_pool) {
+		v->ti->error = "Cannot allocate RS pool";
+		return -ENOMEM;
+	}
+
+	f->cache = kmem_cache_create("dm_verity_fec_buffers",
+				f->rsn << DM_VERITY_FEC_BUF_RS_BITS,
+				0, 0, NULL);
+
+	if (!f->cache) {
+		v->ti->error = "Cannot create FEC buffer cache";
+		return -ENOMEM;
+	}
+
+	/* Preallocate DM_VERITY_FEC_BUF_PREALLOC buffers for each thread */
+	f->prealloc_pool = mempool_create_slab_pool(num_online_cpus() *
+						DM_VERITY_FEC_BUF_PREALLOC,
+					f->cache);
+
+	if (!f->prealloc_pool) {
+		v->ti->error = "Cannot allocate FEC buffer prealloc pool";
+		return -ENOMEM;
+	}
+
+	f->extra_pool = mempool_create_slab_pool(0, f->cache);
+
+	if (!f->extra_pool) {
+		v->ti->error = "Cannot allocate FEC buffer extra pool";
+		return -ENOMEM;
+	}
+
+	/* Preallocate an output buffer for each thread */
+	f->output_pool = mempool_create_kmalloc_pool(num_online_cpus(),
+					1 << v->data_dev_block_bits);
+
+	if (!f->output_pool) {
+		v->ti->error = "Cannot allocate FEC output pool";
+		return -ENOMEM;
+	}
+
+	/* Reserve space for our per-bio data */
+	v->ti->per_bio_data_size += sizeof(struct dm_verity_fec_io);
+
+	return 0;
+}
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
new file mode 100644
index 0000000..420c97c
--- /dev/null
+++ b/drivers/md/dm-verity-fec.h
@@ -0,0 +1,146 @@
+/*
+ * Copyright (C) 2015 Google, Inc.
+ *
+ * Author: Sami Tolvanen <samitolvanen@google.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#ifndef DM_VERITY_FEC_H
+#define DM_VERITY_FEC_H
+
+#include "dm-verity.h"
+#include <linux/rslib.h>
+
+/* Reed-Solomon(M, N) parameters */
+#define DM_VERITY_FEC_RSM		255
+#define DM_VERITY_FEC_MAX_RSN		253
+#define DM_VERITY_FEC_MIN_RSN		231	/* ~10% space overhead */
+
+/* buffers for deinterleaving and decoding */
+#define DM_VERITY_FEC_BUF_PREALLOC	1	/* buffers to preallocate */
+#define DM_VERITY_FEC_BUF_RS_BITS	4	/* 1 << RS blocks per buffer */
+/* we need buffers for at most 1 << block size RS blocks */
+#define DM_VERITY_FEC_BUF_MAX \
+	(1 << (PAGE_SHIFT - DM_VERITY_FEC_BUF_RS_BITS))
+
+#define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
+#define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
+#define DM_VERITY_OPT_FEC_START		"fec_start"
+#define DM_VERITY_OPT_FEC_ROOTS		"fec_roots"
+
+/* configuration */
+struct dm_verity_fec {
+	struct dm_dev *dev;	/* parity data device */
+	struct dm_bufio_client *data_bufio;	/* for data dev access */
+	struct dm_bufio_client *bufio;		/* for parity data access */
+	sector_t start;		/* parity data start in blocks */
+	sector_t blocks;	/* number of blocks covered */
+	sector_t rounds;	/* number of interleaving rounds */
+	sector_t hash_blocks;	/* blocks covered after v->hash_start */
+	unsigned char roots;	/* number of parity bytes, M-N of RS(M, N) */
+	unsigned char rsn;	/* N of RS(M, N) */
+	mempool_t *rs_pool;	/* mempool for fio->rs */
+	mempool_t *prealloc_pool;	/* mempool for preallocated buffers */
+	mempool_t *extra_pool;	/* mempool for extra buffers */
+	mempool_t *output_pool;	/* mempool for output */
+	struct kmem_cache *cache;	/* cache for buffers */
+};
+
+/* per-bio data */
+struct dm_verity_fec_io {
+	struct rs_control *rs;	/* Reed-Solomon state */
+	int erasures[DM_VERITY_FEC_MAX_RSN];	/* erasures for decode_rs8 */
+	u8 *bufs[DM_VERITY_FEC_BUF_MAX];	/* bufs for deinterleaving */
+	unsigned nbufs;		/* number of buffers allocated */
+	u8 *output;		/* buffer for corrected output */
+	size_t output_pos;
+};
+
+#ifdef CONFIG_DM_VERITY_FEC
+
+/* each feature parameter requires a value */
+#define DM_VERITY_OPTS_FEC	8
+
+extern bool verity_fec_is_enabled(struct dm_verity *v);
+
+extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
+			     enum verity_block_type type, sector_t block,
+			     u8 *dest, struct bvec_iter *iter);
+
+extern unsigned verity_fec_status_table(struct dm_verity *v, unsigned sz,
+					char *result, unsigned maxlen);
+
+extern void verity_fec_finish_io(struct dm_verity_io *io);
+extern void verity_fec_init_io(struct dm_verity_io *io);
+
+extern int verity_fec_parse_opt_args(struct dm_arg_set *as,
+				     struct dm_verity *v, unsigned *argc,
+				     const char *arg_name);
+
+extern void verity_fec_dtr(struct dm_verity *v);
+
+extern int verity_fec_ctr_alloc(struct dm_verity *v);
+extern int verity_fec_ctr(struct dm_verity *v);
+
+#else /* !CONFIG_DM_VERITY_FEC */
+
+#define DM_VERITY_OPTS_FEC	0
+
+static inline bool verity_fec_is_enabled(struct dm_verity *v)
+{
+	return false;
+}
+
+static inline int verity_fec_decode(struct dm_verity *v,
+				    struct dm_verity_io *io,
+				    enum verity_block_type type,
+				    sector_t block, u8 *dest,
+				    struct bvec_iter *iter)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline unsigned verity_fec_status_table(struct dm_verity *v,
+					       unsigned sz, char *result,
+					       unsigned maxlen)
+{
+	return sz;
+}
+
+static inline void verity_fec_finish_io(struct dm_verity_io *io)
+{
+}
+
+static inline void verity_fec_init_io(struct dm_verity_io *io)
+{
+}
+
+static inline int verity_fec_parse_opt_args(struct dm_arg_set *as,
+					    struct dm_verity *v,
+					    unsigned *argc,
+					    const char *arg_name)
+{
+	return -EINVAL;
+}
+
+static inline void verity_fec_dtr(struct dm_verity *v)
+{
+}
+
+static inline int verity_fec_ctr_alloc(struct dm_verity *v)
+{
+	return 0;
+}
+
+static inline int verity_fec_ctr(struct dm_verity *v)
+{
+	return 0;
+}
+
+#endif /* CONFIG_DM_VERITY_FEC */
+
+#endif /* DM_VERITY_FEC_H */
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity-target.c
similarity index 84%
rename from drivers/md/dm-verity.c
rename to drivers/md/dm-verity-target.c
index b0a53c3..ca5857b 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity-target.c
@@ -14,12 +14,11 @@
  * access behavior.
  */
 
-#include "dm-bufio.h"
+#include "dm-verity.h"
+#include "dm-verity-fec.h"
 
 #include <linux/module.h>
-#include <linux/device-mapper.h>
 #include <linux/reboot.h>
-#include <crypto/hash.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -28,84 +27,17 @@
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
 
-#define DM_VERITY_MAX_LEVELS		63
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
 
-#define DM_VERITY_OPTS_MAX		1
+#define DM_VERITY_OPTS_MAX		(1 + DM_VERITY_OPTS_FEC)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
 
-enum verity_mode {
-	DM_VERITY_MODE_EIO,
-	DM_VERITY_MODE_LOGGING,
-	DM_VERITY_MODE_RESTART
-};
-
-enum verity_block_type {
-	DM_VERITY_BLOCK_TYPE_DATA,
-	DM_VERITY_BLOCK_TYPE_METADATA
-};
-
-struct dm_verity {
-	struct dm_dev *data_dev;
-	struct dm_dev *hash_dev;
-	struct dm_target *ti;
-	struct dm_bufio_client *bufio;
-	char *alg_name;
-	struct crypto_shash *tfm;
-	u8 *root_digest;	/* digest of the root block */
-	u8 *salt;		/* salt: its size is salt_size */
-	unsigned salt_size;
-	sector_t data_start;	/* data offset in 512-byte sectors */
-	sector_t hash_start;	/* hash start in blocks */
-	sector_t data_blocks;	/* the number of data blocks */
-	sector_t hash_blocks;	/* the number of hash blocks */
-	unsigned char data_dev_block_bits;	/* log2(data blocksize) */
-	unsigned char hash_dev_block_bits;	/* log2(hash blocksize) */
-	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
-	unsigned char levels;	/* the number of tree levels */
-	unsigned char version;
-	unsigned digest_size;	/* digest size for the current hash algorithm */
-	unsigned shash_descsize;/* the size of temporary space for crypto */
-	int hash_failed;	/* set to 1 if hash of any block failed */
-	enum verity_mode mode;	/* mode for handling verification errors */
-	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
-
-	struct workqueue_struct *verify_wq;
-
-	/* starting blocks for each tree level. 0 is the lowest level. */
-	sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
-};
-
-struct dm_verity_io {
-	struct dm_verity *v;
-
-	/* original value of bio->bi_end_io */
-	bio_end_io_t *orig_bi_end_io;
-
-	sector_t block;
-	unsigned n_blocks;
-
-	struct bvec_iter iter;
-
-	struct work_struct work;
-
-	/*
-	 * Three variably-size fields follow this struct:
-	 *
-	 * u8 hash_desc[v->shash_descsize];
-	 * u8 real_digest[v->digest_size];
-	 * u8 want_digest[v->digest_size];
-	 *
-	 * To access them use: io_hash_desc(), io_real_digest() and io_want_digest().
-	 */
-};
-
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
@@ -113,21 +45,6 @@ struct dm_verity_prefetch_work {
 	unsigned n_blocks;
 };
 
-static struct shash_desc *io_hash_desc(struct dm_verity *v, struct dm_verity_io *io)
-{
-	return (struct shash_desc *)(io + 1);
-}
-
-static u8 *io_real_digest(struct dm_verity *v, struct dm_verity_io *io)
-{
-	return (u8 *)(io + 1) + v->shash_descsize;
-}
-
-static u8 *io_want_digest(struct dm_verity *v, struct dm_verity_io *io)
-{
-	return (u8 *)(io + 1) + v->shash_descsize + v->digest_size;
-}
-
 /*
  * Auxiliary structure appended to each dm-bufio buffer. If the value
  * hash_verified is nonzero, hash of the block has been verified.
@@ -236,8 +153,8 @@ static int verity_hash_final(struct dm_verity *v, struct shash_desc *desc,
 	return r;
 }
 
-static int verity_hash(struct dm_verity *v, struct shash_desc *desc,
-		       const u8 *data, size_t len, u8 *digest)
+int verity_hash(struct dm_verity *v, struct shash_desc *desc,
+		const u8 *data, size_t len, u8 *digest)
 {
 	int r;
 
@@ -325,12 +242,12 @@ out:
  * Verify hash of a metadata block pertaining to the specified data block
  * ("block" argument) at a specified level ("level" argument).
  *
- * On successful return, io_want_digest(v, io) contains the hash value for
- * a lower tree level or for the data block (if we're at the lowest leve).
+ * On successful return, verity_io_want_digest(v, io) contains the hash value
+ * for a lower tree level or for the data block (if we're at the lowest level).
  *
  * If "skip_unverified" is true, unverified buffer is skipped and 1 is returned.
  * If "skip_unverified" is false, unverified buffer is hashed and verified
- * against current value of io_want_digest(v, io).
+ * against current value of verity_io_want_digest(v, io).
  */
 static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			       sector_t block, int level, bool skip_unverified,
@@ -357,15 +274,19 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			goto release_ret_r;
 		}
 
-		r = verity_hash(v, io_hash_desc(v, io),
+		r = verity_hash(v, verity_io_hash_desc(v, io),
 				data, 1 << v->hash_dev_block_bits,
-				io_real_digest(v, io));
+				verity_io_real_digest(v, io));
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
-		if (likely(memcmp(io_real_digest(v, io), want_digest,
+		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
+		else if (verity_fec_decode(v, io,
+					   DM_VERITY_BLOCK_TYPE_METADATA,
+					   hash_block, data, NULL) == 0)
+			aux->hash_verified = 1;
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
 					   hash_block)) {
@@ -387,8 +308,8 @@ release_ret_r:
  * Find a hash for a given block, write it to digest and verify the integrity
  * of the hash tree if necessary.
  */
-static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
-				 sector_t block, u8 *digest)
+int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
+			  sector_t block, u8 *digest)
 {
 	int i;
 	int r;
@@ -418,22 +339,65 @@ static int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 }
 
 /*
+ * Calls function process for 1 << v->data_dev_block_bits bytes in the bio_vec
+ * starting from iter.
+ */
+int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
+			struct bvec_iter *iter,
+			int (*process)(struct dm_verity *v,
+				       struct dm_verity_io *io, u8 *data,
+				       size_t len))
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
+	return verity_hash_update(v, verity_io_hash_desc(v, io), data, len);
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
-		struct shash_desc *desc = io_hash_desc(v, io);
+		struct shash_desc *desc = verity_io_hash_desc(v, io);
 
 		r = verity_hash_for_block(v, io, io->block + b,
-					  io_want_digest(v, io));
+					  verity_io_want_digest(v, io));
 		if (unlikely(r < 0))
 			return r;
 
@@ -441,36 +405,25 @@ static int verity_verify_io(struct dm_verity_io *io)
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
 
-		r = verity_hash_final(v, desc, io_real_digest(v, io));
+		r = verity_hash_final(v, desc, verity_io_real_digest(v, io));
 		if (unlikely(r < 0))
 			return r;
 
-		if (likely(memcmp(io_real_digest(v, io),
-				io_want_digest(v, io), v->digest_size) == 0))
+		if (likely(memcmp(verity_io_real_digest(v, io),
+				  verity_io_want_digest(v, io),
+				  v->digest_size) == 0))
+			continue;
+		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
+					   io->block + b, NULL, &start) == 0)
 			continue;
 		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-				io->block + b))
+					   io->block + b))
 			return -EIO;
 	}
 
@@ -488,6 +441,8 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_error = error;
 
+	verity_fec_finish_io(io);
+
 	bio_endio(bio);
 }
 
@@ -502,7 +457,7 @@ static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
 
-	if (bio->bi_error) {
+	if (bio->bi_error && !verity_fec_is_enabled(io->v)) {
 		verity_finish_io(io, bio->bi_error);
 		return;
 	}
@@ -605,6 +560,8 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	bio->bi_private = io;
 	io->iter = bio->bi_iter;
 
+	verity_fec_init_io(io);
+
 	verity_submit_prefetch(v, io);
 
 	generic_make_request(bio);
@@ -619,6 +576,7 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct dm_verity *v = ti->private;
+	unsigned args = 0;
 	unsigned sz = 0;
 	unsigned x;
 
@@ -645,8 +603,15 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 		else
 			for (x = 0; x < v->salt_size; x++)
 				DMEMIT("%02x", v->salt[x]);
+		if (v->mode != DM_VERITY_MODE_EIO)
+			args++;
+		if (verity_fec_is_enabled(v))
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
@@ -658,6 +623,7 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 				BUG();
 			}
 		}
+		sz = verity_fec_status_table(v, sz, result, maxlen);
 		break;
 	}
 }
@@ -720,6 +686,8 @@ static void verity_dtr(struct dm_target *ti)
 	if (v->data_dev)
 		dm_put_device(ti, v->data_dev);
 
+	verity_fec_dtr(v);
+
 	kfree(v);
 }
 
@@ -752,10 +720,12 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART)) {
 			v->mode = DM_VERITY_MODE_RESTART;
 			continue;
+		} else {
+			r = verity_fec_parse_opt_args(as, v, &argc, arg_name);
 		}
 
-		ti->error = "Unrecognized verity feature request";
-		return -EINVAL;
+		if (r && !ti->error)
+			ti->error = "Unrecognized verity feature request";
 	} while (argc && !r);
 
 	return r;
@@ -794,6 +764,10 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->private = v;
 	v->ti = ti;
 
+	r = verity_fec_ctr_alloc(v);
+	if (r)
+		goto bad;
+
 	if ((dm_table_get_mode(ti->table) & ~FMODE_READ)) {
 		ti->error = "Device must be readonly";
 		r = -EINVAL;
@@ -982,8 +956,6 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	ti->per_bio_data_size = roundup(sizeof(struct dm_verity_io) + v->shash_descsize + v->digest_size * 2, __alignof__(struct dm_verity_io));
-
 	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
 	v->verify_wq = alloc_workqueue("kverityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
 	if (!v->verify_wq) {
@@ -992,6 +964,16 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
+	ti->per_bio_data_size = sizeof(struct dm_verity_io) +
+				v->shash_descsize + v->digest_size * 2;
+
+	r = verity_fec_ctr(v);
+	if (r)
+		goto bad;
+
+	ti->per_bio_data_size = roundup(ti->per_bio_data_size,
+					__alignof__(struct dm_verity_io));
+
 	return 0;
 
 bad:
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
new file mode 100644
index 0000000..8e85372
--- /dev/null
+++ b/drivers/md/dm-verity.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2015 Google, Inc.
+ *
+ * Author: Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * Based on Chromium dm-verity driver (C) 2011 The Chromium OS Authors
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef DM_VERITY_H
+#define DM_VERITY_H
+
+#include "dm-bufio.h"
+#include <linux/device-mapper.h>
+#include <crypto/hash.h>
+
+#define DM_VERITY_MAX_LEVELS		63
+
+enum verity_mode {
+	DM_VERITY_MODE_EIO,
+	DM_VERITY_MODE_LOGGING,
+	DM_VERITY_MODE_RESTART
+};
+
+enum verity_block_type {
+	DM_VERITY_BLOCK_TYPE_DATA,
+	DM_VERITY_BLOCK_TYPE_METADATA
+};
+
+struct dm_verity_fec;
+
+struct dm_verity {
+	struct dm_dev *data_dev;
+	struct dm_dev *hash_dev;
+	struct dm_target *ti;
+	struct dm_bufio_client *bufio;
+	char *alg_name;
+	struct crypto_shash *tfm;
+	u8 *root_digest;	/* digest of the root block */
+	u8 *salt;		/* salt: its size is salt_size */
+	unsigned salt_size;
+	sector_t data_start;	/* data offset in 512-byte sectors */
+	sector_t hash_start;	/* hash start in blocks */
+	sector_t data_blocks;	/* the number of data blocks */
+	sector_t hash_blocks;	/* the number of hash blocks */
+	unsigned char data_dev_block_bits;	/* log2(data blocksize) */
+	unsigned char hash_dev_block_bits;	/* log2(hash blocksize) */
+	unsigned char hash_per_block_bits;	/* log2(hashes in hash block) */
+	unsigned char levels;	/* the number of tree levels */
+	unsigned char version;
+	unsigned digest_size;	/* digest size for the current hash algorithm */
+	unsigned shash_descsize;/* the size of temporary space for crypto */
+	int hash_failed;	/* set to 1 if hash of any block failed */
+	enum verity_mode mode;	/* mode for handling verification errors */
+	unsigned corrupted_errs;/* Number of errors for corrupted blocks */
+
+	struct workqueue_struct *verify_wq;
+
+	/* starting blocks for each tree level. 0 is the lowest level. */
+	sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
+
+	struct dm_verity_fec *fec;	/* forward error correction */
+};
+
+struct dm_verity_io {
+	struct dm_verity *v;
+
+	/* original value of bio->bi_end_io */
+	bio_end_io_t *orig_bi_end_io;
+
+	sector_t block;
+	unsigned n_blocks;
+
+	struct bvec_iter iter;
+
+	struct work_struct work;
+
+	/*
+	 * Three variably-size fields follow this struct:
+	 *
+	 * u8 hash_desc[v->shash_descsize];
+	 * u8 real_digest[v->digest_size];
+	 * u8 want_digest[v->digest_size];
+	 *
+	 * To access them use: verity_io_hash_desc(), verity_io_real_digest()
+	 * and verity_io_want_digest().
+	 */
+};
+
+static inline struct shash_desc *verity_io_hash_desc(struct dm_verity *v,
+						     struct dm_verity_io *io)
+{
+	return (struct shash_desc *)(io + 1);
+}
+
+static inline u8 *verity_io_real_digest(struct dm_verity *v,
+					struct dm_verity_io *io)
+{
+	return (u8 *)(io + 1) + v->shash_descsize;
+}
+
+static inline u8 *verity_io_want_digest(struct dm_verity *v,
+					struct dm_verity_io *io)
+{
+	return (u8 *)(io + 1) + v->shash_descsize + v->digest_size;
+}
+
+static inline u8 *verity_io_digest_end(struct dm_verity *v,
+				       struct dm_verity_io *io)
+{
+	return verity_io_want_digest(v, io) + v->digest_size;
+}
+
+extern int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
+			       struct bvec_iter *iter,
+			       int (*process)(struct dm_verity *v,
+					      struct dm_verity_io *io,
+					      u8 *data, size_t len));
+
+extern int verity_hash(struct dm_verity *v, struct shash_desc *desc,
+		       const u8 *data, size_t len, u8 *digest);
+
+extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
+				 sector_t block, u8 *digest);
+
+#endif /* DM_VERITY_H */
-- 
2.6.0.rc2.230.g3dd15c0
