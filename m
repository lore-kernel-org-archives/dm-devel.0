Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B333CEAF;
	Fri,  6 Feb 2026 05:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354117; cv=none; b=pRiesBw6gTdcWT+sEd0tTwydoW9RrG+/0xRShECg3SWfTWVJLC1t72gM6tPQdy5d6tOhKoLmU4wmJ1QEFOqERXalAJco/msWgyVglrnUQGuz/8XJ2CFBgOurll5BljSjcsPwKspr+1jkYjAn4Kk2cVAooxsnqc7a/5c9YJH2IQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354117; c=relaxed/simple;
	bh=UmBnnJD5gutfSn3AllzRmWoVzM59iVB0G7xY9DxeVR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHYr79+oWyOuI9jcj+GZLzkp2GHKJ3vzOnQD6TBIAaOHZrGbS58sJCMjHx2oIt0A7ItgetKi14sht3zaydKiq+XpqRtoBiP5ni5o/Kk4o5kFSM4NCMVdm2IZEU5PNZQGZRAVSYEJ05UZN+EPfy3vWLYrkZjPMa1FA8rCLrY6Jd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRQFpMcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRQFpMcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C104C19425;
	Fri,  6 Feb 2026 05:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354117;
	bh=UmBnnJD5gutfSn3AllzRmWoVzM59iVB0G7xY9DxeVR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRQFpMcyBGGEyYYa4ijosyzDSG7/WtIWHwM9AJhkQp+4UyFGEsaeAHmCMmvCMvwq1
	 cxKuzKyJulPY/zRmOWtyebBmJDaWjLKZ1HNFgsNI8y2kjZl2AAbqCp27gocFGX/87k
	 S5u5d/X9vsOXT57pwyxGtren7IV3FwSkdW82TK77+cD7BzrmeKFFkawHXZ0DDzMjWR
	 ur6IwgJeiMLN/3Zi3RpjlpHpKW50evCoeVW8nInuY8cL6+QdVSykLl+sKD6IkcBJ6T
	 CjasXrCc6Z2WDoQ1FPTM4QicKxhWmS+cSQFUx14tvNRX03JIJrVFMtW+7ERehPXND6
	 mSurCE0bqJlPw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/22] dm-verity-fec: use standard names for Reed-Solomon parameters
Date: Thu,  5 Feb 2026 20:59:28 -0800
Message-ID: <20260206045942.52965-10-ebiggers@kernel.org>
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

"RS(n, k)" is by far the most common and standard notation for
describing Reed-Solomon codes.  Each RS codeword consists of 'n'
symbols, divided into 'k' message symbols and 'n - k' parity symbols.
'n - k' is also the number of roots of the generator polynomial.

dm-verity uses "RS(M, N)" instead.  I haven't been able to find any
other source that uses this convention.  This quirk makes the code
harder to understand than necessary, especially due to dm-verity's 'N'
meaning something different from the standard 'n'.

Therefore, update dm-verity-fec.c and dm-verity-fec.h to use the
standard parameter names.  No functional changes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 30 +++++++++++++++---------------
 drivers/md/dm-verity-fec.h |  8 ++++----
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index c5f97a49e5b79..8e9482a6df4a1 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -27,11 +27,11 @@ static inline unsigned int fec_max_nbufs(struct dm_verity *v)
  */
 static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
 {
 	u32 mod;
 
-	mod = do_div(offset, v->fec->rsn);
+	mod = do_div(offset, v->fec->rs_k);
 	return offset + mod * (v->fec->rounds << v->data_dev_block_bits);
 }
 
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
@@ -48,11 +48,11 @@ static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
  */
 static inline u8 *fec_buffer_rs_block(struct dm_verity *v,
 				      struct dm_verity_fec_io *fio,
 				      unsigned int i, unsigned int j)
 {
-	return &fio->bufs[i][j * v->fec->rsn];
+	return &fio->bufs[i][j * v->fec->rs_k];
 }
 
 /*
  * Return an index to the current RS block when called inside
  * fec_for_each_buffer_rs_block.
@@ -127,11 +127,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			for (; j < v->fec->roots; j++)
 				par_buf[j] = par[parity_pos++];
 		}
 
 		/* Decode an RS block using Reed-Solomon */
-		res = decode_rs8(fio->rs, block, par_buf, v->fec->rsn,
+		res = decode_rs8(fio->rs, block, par_buf, v->fec->rs_k,
 				 NULL, neras, fio->erasures, 0, NULL);
 		if (res < 0) {
 			r = res;
 			goto error;
 		}
@@ -195,19 +195,19 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 	if (WARN_ON(v->digest_size > sizeof(want_digest)))
 		return -EINVAL;
 
 	/*
-	 * read each of the rsn data blocks that are part of the RS block, and
+	 * read each of the rs_k data blocks that are part of the RS block, and
 	 * interleave contents to available bufs
 	 */
-	for (i = 0; i < v->fec->rsn; i++) {
-		ileaved = fec_interleave(v, rsb * v->fec->rsn + i);
+	for (i = 0; i < v->fec->rs_k; i++) {
+		ileaved = fec_interleave(v, rsb * v->fec->rs_k + i);
 
 		/*
 		 * target is the data block we want to correct, target_index is
-		 * the index of this block within the rsn RS blocks
+		 * the index of this block within the rs_k RS blocks
 		 */
 		if (ileaved == target)
 			target_index = i;
 
 		block = ileaved >> v->data_dev_block_bits;
@@ -320,11 +320,11 @@ static struct dm_verity_fec_io *fec_alloc_and_init_io(struct dm_verity *v)
 static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 {
 	unsigned int n;
 
 	fec_for_each_buffer(fio, n)
-		memset(fio->bufs[n], 0, v->fec->rsn << DM_VERITY_FEC_BUF_RS_BITS);
+		memset(fio->bufs[n], 0, v->fec->rs_k << DM_VERITY_FEC_BUF_RS_BITS);
 
 	memset(fio->erasures, 0, sizeof(fio->erasures));
 }
 
 /*
@@ -392,16 +392,16 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 
 	if (type == DM_VERITY_BLOCK_TYPE_METADATA)
 		block = block - v->hash_start + v->data_blocks;
 
 	/*
-	 * For RS(M, N), the continuous FEC data is divided into blocks of N
-	 * bytes. Since block size may not be divisible by N, the last block
+	 * For RS(n, k), the continuous FEC data is divided into blocks of k
+	 * bytes. Since block size may not be divisible by k, the last block
 	 * is zero padded when decoding.
 	 *
-	 * Each byte of the block is covered by a different RS(M, N) code,
-	 * and each code is interleaved over N blocks to make it less likely
+	 * Each byte of the block is covered by a different RS(n, k) code,
+	 * and each code is interleaved over k blocks to make it less likely
 	 * that bursty corruption will leave us in unrecoverable state.
 	 */
 
 	offset = block << v->data_dev_block_bits;
 	res = div64_u64(offset, v->fec->rounds << v->data_dev_block_bits);
@@ -648,19 +648,19 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	if (!f->roots) {
 		ti->error = "Missing " DM_VERITY_OPT_FEC_ROOTS;
 		return -EINVAL;
 	}
-	f->rsn = DM_VERITY_FEC_RSM - f->roots;
+	f->rs_k = DM_VERITY_FEC_RS_N - f->roots;
 
 	if (!f->blocks) {
 		ti->error = "Missing " DM_VERITY_OPT_FEC_BLOCKS;
 		return -EINVAL;
 	}
 
 	f->rounds = f->blocks;
-	if (sector_div(f->rounds, f->rsn))
+	if (sector_div(f->rounds, f->rs_k))
 		f->rounds++;
 
 	/*
 	 * Due to optional metadata, f->blocks can be larger than
 	 * data_blocks and hash_blocks combined.
@@ -728,11 +728,11 @@ int verity_fec_ctr(struct dm_verity *v)
 		ti->error = "Cannot allocate RS pool";
 		return ret;
 	}
 
 	f->cache = kmem_cache_create("dm_verity_fec_buffers",
-				     f->rsn << DM_VERITY_FEC_BUF_RS_BITS,
+				     f->rs_k << DM_VERITY_FEC_BUF_RS_BITS,
 				     0, 0, NULL);
 	if (!f->cache) {
 		ti->error = "Cannot create FEC buffer cache";
 		return -ENOMEM;
 	}
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index d8d0e81da2701..5afa93f2f1fc7 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -9,12 +9,12 @@
 #define DM_VERITY_FEC_H
 
 #include "dm-verity.h"
 #include <linux/rslib.h>
 
-/* Reed-Solomon(M, N) parameters */
-#define DM_VERITY_FEC_RSM		255
+/* Reed-Solomon(n, k) parameters */
+#define DM_VERITY_FEC_RS_N	255
 #define DM_VERITY_FEC_MIN_ROOTS	2	/* RS(255, 253): ~0.8% space overhead */
 #define DM_VERITY_FEC_MAX_ROOTS	24	/* RS(255, 231): ~10% space overhead */
 
 /* buffers for deinterleaving and decoding */
 #define DM_VERITY_FEC_BUF_RS_BITS	4	/* 1 << RS blocks per buffer */
@@ -32,12 +32,12 @@ struct dm_verity_fec {
 	size_t io_size;		/* IO size for roots */
 	sector_t start;		/* parity data start in blocks */
 	sector_t blocks;	/* number of blocks covered */
 	sector_t rounds;	/* number of interleaving rounds */
 	sector_t hash_blocks;	/* blocks covered after v->hash_start */
-	unsigned char roots;	/* number of parity bytes, M-N of RS(M, N) */
-	unsigned char rsn;	/* N of RS(M, N) */
+	unsigned char roots;	/* parity bytes per RS codeword, n-k of RS(n, k) */
+	unsigned char rs_k;	/* message bytes per RS codeword, k of RS(n, k) */
 	mempool_t fio_pool;	/* mempool for dm_verity_fec_io */
 	mempool_t rs_pool;	/* mempool for fio->rs */
 	mempool_t prealloc_pool;	/* mempool for preallocated buffers */
 	mempool_t output_pool;	/* mempool for output */
 	struct kmem_cache *cache;	/* cache for buffers */
-- 
2.52.0

