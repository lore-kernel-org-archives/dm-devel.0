Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5B833DEF7;
	Fri,  6 Feb 2026 05:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354118; cv=none; b=ZNMlI/QmfMQb0hZI1GnnRXaF2WvbBQnltbp9r5qulSOI5VIIKpJe64Bp9e7gC982G0dwnEodw1zcQSdY2wlDg414UpiqCGtG/4dJ28F1Y6wR2dJMxbBaAieDG0VpYkJJQ2+GX+zj7Lqu88AvmA3d/aBHBs/nE2P+PPnDcUs+Q1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354118; c=relaxed/simple;
	bh=d9stYeak2OGhlQrw6Kehk1/8I5GK23UT0p/tohYxgYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUPL8pFvg1i+DrhjExaNpBd1F5HVIZRqqnusfDdEp0mmaawqTuL8DPzmhQ2DQZ/R98ncYEtCr48y2DFZLwZjB/3cQNYMTjAbbfjK3ZmE+3rm8LKuEmUGsxQOooBWsvu1vw/MEazjDNbvilQya751k7YYhdclBTHbfG7d3/O71kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCnDMRV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCnDMRV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A300C116C6;
	Fri,  6 Feb 2026 05:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354118;
	bh=d9stYeak2OGhlQrw6Kehk1/8I5GK23UT0p/tohYxgYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCnDMRV30iwnHS6MCziivbFthqyxPgUPu3nNdszFD6N4+tTMZ1Qd362E1Qtofu9CV
	 RQRYWVPsB2G8OMGe8iuqhB/CkdQ2U5vAXoKIhbpDBWWmtEZpstWEm9WJrEk7CJwNuS
	 t9gDy+eqc8ZR4V2mCg/e7acojUjnGEidlyiuJdU8pxLSKoO30nIuPMidMM6RxmpF7r
	 JiFJpszQt7X9tj+FAB/0HboNW9pI3FtSDiy2nKIXBaTgTWca3EJI6iR6WIoep16wr4
	 jp+1IhIctwpKPUKWl3d+TN+TVFLup9g9RBJuVQeUvEPx7YPBdOSUh4MVgrFXhu+fBA
	 yQj4yaMXg4QJQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/22] dm-verity-fec: replace io_size with block_size
Date: Thu,  5 Feb 2026 20:59:30 -0800
Message-ID: <20260206045942.52965-12-ebiggers@kernel.org>
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

dm-verity's FEC implementation assumes that data_block_size ==
hash_block_size, and it accesses the FEC device in units of the same
size.  Many places in the code want that size and compute it on-demand
as '1 << v->data_dev_block_bits'.  However, it's actually already
available in v->fec->io_size.  Rename that field to block_size,
initialize it a bit earlier, and use it in the appropriate places.

Note that while these sizes could in principle be different, that case
is not supported.  So there's no need to complicate the code for it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 30 +++++++++++++-----------------
 drivers/md/dm-verity-fec.h |  2 +-
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 619645edaf509..6ba9a1e039be3 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -82,15 +82,15 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 	/*
 	 * Compute the index of the first parity block that will be needed and
 	 * the starting position in that block.  Then read that block.
 	 *
-	 * io_size is always a power of 2, but roots might not be.  Note that
+	 * block_size is always a power of 2, but roots might not be.  Note that
 	 * when it's not, a codeword's parity bytes can span a block boundary.
 	 */
 	parity_block = (rsb + block_offset) * v->fec->roots;
-	parity_pos = parity_block & (v->fec->io_size - 1);
+	parity_pos = parity_block & (v->fec->block_size - 1);
 	parity_block >>= v->data_dev_block_bits;
 	par = dm_bufio_read_with_ioprio(v->fec->bufio, parity_block, &buf,
 					bio->bi_ioprio);
 	if (IS_ERR(par)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
@@ -108,11 +108,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 		/*
 		 * Copy the next 'roots' parity bytes to 'par_buf', reading
 		 * another parity block if needed.
 		 */
-		to_copy = min(v->fec->io_size - parity_pos, v->fec->roots);
+		to_copy = min(v->fec->block_size - parity_pos, v->fec->roots);
 		for (j = 0; j < to_copy; j++)
 			par_buf[j] = par[parity_pos++];
 		if (to_copy < v->fec->roots) {
 			parity_block++;
 			parity_pos = 0;
@@ -141,11 +141,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 		corrected += res;
 		fio->output[block_offset] = msg_buf[byte_index];
 
 		block_offset++;
-		if (block_offset >= 1 << v->data_dev_block_bits)
+		if (block_offset >= v->fec->block_size)
 			goto done;
 	}
 done:
 	r = corrected;
 error:
@@ -165,11 +165,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
  * Locate data block erasures using verity hashes.
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  const u8 *want_digest, const u8 *data)
 {
-	if (unlikely(verity_hash(v, io, data, 1 << v->data_dev_block_bits,
+	if (unlikely(verity_hash(v, io, data, v->fec->block_size,
 				 io->tmp_digest)))
 		return 0;
 
 	return memcmp(io->tmp_digest, want_digest, v->digest_size) != 0;
 }
@@ -266,11 +266,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 		 * starting from block_offset
 		 */
 		fec_for_each_buffer_rs_message(fio, n, j) {
 			k = fec_buffer_rs_index(n, j) + block_offset;
 
-			if (k >= 1 << v->data_dev_block_bits)
+			if (k >= v->fec->block_size)
 				goto done;
 
 			fec_buffer_rs_message(v, fio, n, j)[i] = bbuf[k];
 		}
 done:
@@ -339,11 +339,11 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 			  const u8 *want_digest, bool use_erasures)
 {
 	int r, neras = 0;
 	unsigned int pos;
 
-	for (pos = 0; pos < 1 << v->data_dev_block_bits; ) {
+	for (pos = 0; pos < v->fec->block_size;) {
 		fec_init_bufs(v, fio);
 
 		r = fec_read_bufs(v, io, rsb, offset, pos,
 				  use_erasures ? &neras : NULL);
 		if (unlikely(r < 0))
@@ -355,12 +355,11 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 
 		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
-	r = verity_hash(v, io, fio->output, 1 << v->data_dev_block_bits,
-			io->tmp_digest);
+	r = verity_hash(v, io, fio->output, v->fec->block_size, io->tmp_digest);
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(io->tmp_digest, want_digest, v->digest_size)) {
 		DMERR_LIMIT("%s: FEC %llu: failed to correct (%d erasures)",
@@ -424,11 +423,11 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		r = fec_decode_rsb(v, io, fio, rsb, offset, want_digest, true);
 		if (r < 0)
 			goto done;
 	}
 
-	memcpy(dest, fio->output, 1 << v->data_dev_block_bits);
+	memcpy(dest, fio->output, v->fec->block_size);
 	atomic64_inc(&v->fec->corrected);
 
 done:
 	fio->level--;
 	return r;
@@ -645,10 +644,11 @@ int verity_fec_ctr(struct dm_verity *v)
 	 */
 	if (v->data_dev_block_bits != v->hash_dev_block_bits) {
 		ti->error = "Block sizes must match to use FEC";
 		return -EINVAL;
 	}
+	f->block_size = 1 << v->data_dev_block_bits;
 
 	if (!f->roots) {
 		ti->error = "Missing " DM_VERITY_OPT_FEC_ROOTS;
 		return -EINVAL;
 	}
@@ -682,14 +682,11 @@ int verity_fec_ctr(struct dm_verity *v)
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;
 	}
 
-	f->io_size = 1 << v->data_dev_block_bits;
-
-	f->bufio = dm_bufio_client_create(f->dev->bdev,
-					  f->io_size,
+	f->bufio = dm_bufio_client_create(f->dev->bdev, f->block_size,
 					  1, 0, NULL, NULL, 0);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
 		return PTR_ERR(f->bufio);
 	}
@@ -699,12 +696,11 @@ int verity_fec_ctr(struct dm_verity *v)
 	if (dm_bufio_get_device_size(f->bufio) < f->rounds * f->roots) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}
 
-	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev,
-					       1 << v->data_dev_block_bits,
+	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev, f->block_size,
 					       1, 0, NULL, NULL, 0);
 	if (IS_ERR(f->data_bufio)) {
 		ti->error = "Cannot initialize FEC data bufio client";
 		return PTR_ERR(f->data_bufio);
 	}
@@ -747,11 +743,11 @@ int verity_fec_ctr(struct dm_verity *v)
 		return ret;
 	}
 
 	/* Preallocate an output buffer for each thread */
 	ret = mempool_init_kmalloc_pool(&f->output_pool, num_online_cpus(),
-					1 << v->data_dev_block_bits);
+					f->block_size);
 	if (ret) {
 		ti->error = "Cannot allocate FEC output pool";
 		return ret;
 	}
 
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 257a609274c7c..49d43894ea746 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -27,11 +27,11 @@
 /* configuration */
 struct dm_verity_fec {
 	struct dm_dev *dev;	/* parity data device */
 	struct dm_bufio_client *data_bufio;	/* for data dev access */
 	struct dm_bufio_client *bufio;		/* for parity data access */
-	size_t io_size;		/* IO size for roots */
+	size_t block_size;	/* size of data, hash, and parity blocks in bytes */
 	sector_t start;		/* parity data start in blocks */
 	sector_t blocks;	/* number of blocks covered */
 	sector_t rounds;	/* number of interleaving rounds */
 	sector_t hash_blocks;	/* blocks covered after v->hash_start */
 	unsigned char roots;	/* parity bytes per RS codeword, n-k of RS(n, k) */
-- 
2.52.0

