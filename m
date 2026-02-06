Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C6933D6C2;
	Fri,  6 Feb 2026 05:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354118; cv=none; b=FCZ02cfAvZIh9sR4ING4w9GGLlZAVAUdmF10mPaaKnT7xLo02h92Bl5KC4yCxG/H+FnqP2SINtD07HMV+KxfnqkvowtJ8f7oDDv7imeAP8xTfmCsaH7UeveT0qlBm6uhG8nyPk7jzKS4KK8aDUEE/d+JA3RJzPYaaAugYtCRFPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354118; c=relaxed/simple;
	bh=0+BZxKuKZeUs+WBhbuBBTQwZHtqoL7AOSTxD/oy7SJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAZyGim41MhpayHp1wO3J6VgzxN3rwmwb2UBDJEqjZ9mM66g6ATxwVDBmD7FocyARgvYLzXxX9GrEHZkCeVzQJVHrlYxF6iezcfmS9LaYzSDHpxTUmeJmYdzdeOj+IpnHvQ8CELgFgK35waFSFgsyB6GKPm+cSiuWJq9QJ6oYNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uGGs8Y0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uGGs8Y0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC7DC4AF09;
	Fri,  6 Feb 2026 05:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354118;
	bh=0+BZxKuKZeUs+WBhbuBBTQwZHtqoL7AOSTxD/oy7SJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGGs8Y0rGBxiObjAD68WKduXPfx1GyZBCJvJ4oSF98Jz+MYt54gHsXqb9WhtYN7xt
	 Fb776b82jVyT9CE7PFYDx21FlcSgk5Yjb97lN58+JT68xziBblHE1Zt83oCRP+H23i
	 4P/vu0L6YTDE1Zq8S5R6O4t6+BCbVeGGgf4Ly9JajD6EMvfkACM8HlID5cQawjNJOc
	 /AXV9K11vTfbl6pEwaFrZG3RXhq2HweJAC/iOYH+gk3Sxcc2aRo5OlsPLKXpbtqx1t
	 lT7husKZZ5UuTfLwsGPmY/0tv6hR/RfZvIdDZuUCIR/DxQkQ3g2vpvdNGG3hBbX6z3
	 rilOK6VOnTZAg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/22] dm-verity-fec: rename "RS block" to "RS codeword"
Date: Thu,  5 Feb 2026 20:59:29 -0800
Message-ID: <20260206045942.52965-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The literature refers to the unit of a Reed-Solomon (RS) code as either
a "block" or a "codeword".

dm-verity's source code uses "RS block".  Unfortunately, that's really
confusing because "block" already means something else in dm-verity.
Especially problematic is the fact that dm-verity sometimes uses "RS
block" to mean an RS codeword and sometimes to mean some dm-verity block
that's related to the RS decoding process, for example one of the blocks
that shares its RS codewords with the target block.

Let's use "RS codeword" instead, or "RS message" when referring to just
the message part of the codeword.  Update some comments, function names,
macro names, and variable names accordingly.  No functional change.

There are still some remaining comments where "RS block" refers to a
dm-verity block.  Later commits will handle these cases.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 58 ++++++++++++++++++++------------------
 drivers/md/dm-verity-fec.h | 10 +++----
 2 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 8e9482a6df4a1..619645edaf509 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -9,15 +9,16 @@
 #include <linux/math64.h>
 
 #define DM_MSG_PREFIX	"verity-fec"
 
 /*
- * When correcting a data block, the FEC code performs optimally when it can
- * collect all the associated RS blocks at the same time.  As each byte is part
- * of a different RS block, there are '1 << data_dev_block_bits' RS blocks.
- * There are '1 << DM_VERITY_FEC_BUF_RS_BITS' RS blocks per buffer, so that
- * gives '1 << (data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS)' buffers.
+ * When correcting a block, the FEC implementation performs optimally when it
+ * can collect all the associated RS codewords at the same time.  As each byte
+ * is part of a different codeword, there are '1 << data_dev_block_bits'
+ * codewords.  Each buffer has space for the message bytes for
+ * '1 << DM_VERITY_FEC_BUF_RS_BITS' codewords, so that gives
+ * '1 << (data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS)' buffers.
  */
 static inline unsigned int fec_max_nbufs(struct dm_verity *v)
 {
 	return 1 << (v->data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS);
 }
@@ -35,48 +36,49 @@ static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
 
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
 	for (__i = 0; __i < (io)->nbufs; __i++)
 
-/* Loop over each RS block in each allocated buffer. */
-#define fec_for_each_buffer_rs_block(io, __i, __j) \
+/* Loop over each RS message in each allocated buffer. */
+/* To stop early, use 'goto', not 'break' (since this uses nested loops). */
+#define fec_for_each_buffer_rs_message(io, __i, __j) \
 	fec_for_each_buffer(io, __i) \
 		for (__j = 0; __j < 1 << DM_VERITY_FEC_BUF_RS_BITS; __j++)
 
 /*
- * Return a pointer to the current RS block when called inside
- * fec_for_each_buffer_rs_block.
+ * Return a pointer to the current RS message when called inside
+ * fec_for_each_buffer_rs_message.
  */
-static inline u8 *fec_buffer_rs_block(struct dm_verity *v,
-				      struct dm_verity_fec_io *fio,
-				      unsigned int i, unsigned int j)
+static inline u8 *fec_buffer_rs_message(struct dm_verity *v,
+					struct dm_verity_fec_io *fio,
+					unsigned int i, unsigned int j)
 {
 	return &fio->bufs[i][j * v->fec->rs_k];
 }
 
 /*
- * Return an index to the current RS block when called inside
- * fec_for_each_buffer_rs_block.
+ * Return the index of the current RS message when called inside
+ * fec_for_each_buffer_rs_message.
  */
 static inline unsigned int fec_buffer_rs_index(unsigned int i, unsigned int j)
 {
 	return (i << DM_VERITY_FEC_BUF_RS_BITS) + j;
 }
 
 /*
- * Decode all RS blocks from buffers and copy corrected bytes into fio->output
- * starting from block_offset.
+ * Decode all RS codewords whose message bytes were loaded into fio->bufs.  Copy
+ * the corrected bytes into fio->output starting from block_offset.
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			   struct dm_verity_fec_io *fio, u64 rsb, int byte_index,
 			   unsigned int block_offset, int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
 	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
-	u8 *par, *block;
+	u8 *par, *msg_buf;
 	u64 parity_block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	/*
 	 * Compute the index of the first parity block that will be needed and
@@ -95,15 +97,16 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		      v->data_dev->name, rsb, parity_block, PTR_ERR(par));
 		return PTR_ERR(par);
 	}
 
 	/*
-	 * Decode the RS blocks we have in bufs. Each RS block results in
-	 * one corrected target byte and consumes fec->roots parity bytes.
+	 * Decode the RS codewords whose message bytes are in bufs. Each RS
+	 * codeword results in one corrected target byte and consumes fec->roots
+	 * parity bytes.
 	 */
-	fec_for_each_buffer_rs_block(fio, n, i) {
-		block = fec_buffer_rs_block(v, fio, n, i);
+	fec_for_each_buffer_rs_message(fio, n, i) {
+		msg_buf = fec_buffer_rs_message(v, fio, n, i);
 
 		/*
 		 * Copy the next 'roots' parity bytes to 'par_buf', reading
 		 * another parity block if needed.
 		 */
@@ -126,20 +129,20 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			}
 			for (; j < v->fec->roots; j++)
 				par_buf[j] = par[parity_pos++];
 		}
 
-		/* Decode an RS block using Reed-Solomon */
-		res = decode_rs8(fio->rs, block, par_buf, v->fec->rs_k,
+		/* Decode an RS codeword using the Reed-Solomon library. */
+		res = decode_rs8(fio->rs, msg_buf, par_buf, v->fec->rs_k,
 				 NULL, neras, fio->erasures, 0, NULL);
 		if (res < 0) {
 			r = res;
 			goto error;
 		}
 
 		corrected += res;
-		fio->output[block_offset] = block[byte_index];
+		fio->output[block_offset] = msg_buf[byte_index];
 
 		block_offset++;
 		if (block_offset >= 1 << v->data_dev_block_bits)
 			goto done;
 	}
@@ -183,11 +186,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	int i, j, target_index = -1;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
 	struct dm_verity_fec_io *fio = io->fec_io;
 	u64 block, ileaved;
-	u8 *bbuf, *rs_block;
+	u8 *bbuf;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 	unsigned int n, k;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	if (neras)
@@ -260,18 +263,17 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 		/*
 		 * deinterleave and copy the bytes that fit into bufs,
 		 * starting from block_offset
 		 */
-		fec_for_each_buffer_rs_block(fio, n, j) {
+		fec_for_each_buffer_rs_message(fio, n, j) {
 			k = fec_buffer_rs_index(n, j) + block_offset;
 
 			if (k >= 1 << v->data_dev_block_bits)
 				goto done;
 
-			rs_block = fec_buffer_rs_block(v, fio, n, j);
-			rs_block[i] = bbuf[k];
+			fec_buffer_rs_message(v, fio, n, j)[i] = bbuf[k];
 		}
 done:
 		dm_bufio_release(buf);
 	}
 
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 5afa93f2f1fc7..257a609274c7c 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -15,11 +15,11 @@
 #define DM_VERITY_FEC_RS_N	255
 #define DM_VERITY_FEC_MIN_ROOTS	2	/* RS(255, 253): ~0.8% space overhead */
 #define DM_VERITY_FEC_MAX_ROOTS	24	/* RS(255, 231): ~10% space overhead */
 
 /* buffers for deinterleaving and decoding */
-#define DM_VERITY_FEC_BUF_RS_BITS	4	/* 1 << RS blocks per buffer */
+#define DM_VERITY_FEC_BUF_RS_BITS	4 /* log2(RS messages per buffer) */
 
 #define DM_VERITY_OPT_FEC_DEV		"use_fec_from_device"
 #define DM_VERITY_OPT_FEC_BLOCKS	"fec_blocks"
 #define DM_VERITY_OPT_FEC_START		"fec_start"
 #define DM_VERITY_OPT_FEC_ROOTS		"fec_roots"
@@ -50,14 +50,14 @@ struct dm_verity_fec_io {
 	int erasures[DM_VERITY_FEC_MAX_ROOTS + 1]; /* erasures for decode_rs8 */
 	u8 *output;		/* buffer for corrected output */
 	unsigned int level;		/* recursion level */
 	unsigned int nbufs;		/* number of buffers allocated */
 	/*
-	 * Buffers for deinterleaving RS blocks.  Each buffer has space for
-	 * the data bytes of (1 << DM_VERITY_FEC_BUF_RS_BITS) RS blocks.  The
-	 * array length is fec_max_nbufs(v), and we try to allocate that many
-	 * buffers.  However, in low-memory situations we may be unable to
+	 * Buffers for deinterleaving RS codewords.  Each buffer has space for
+	 * the message bytes of (1 << DM_VERITY_FEC_BUF_RS_BITS) RS codewords.
+	 * The array length is fec_max_nbufs(v), and we try to allocate that
+	 * many buffers.  However, in low-memory situations we may be unable to
 	 * allocate all buffers.  'nbufs' holds the number actually allocated.
 	 */
 	u8 *bufs[];
 };
 
-- 
2.52.0

