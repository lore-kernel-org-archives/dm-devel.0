Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CB8342505;
	Fri,  6 Feb 2026 05:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354121; cv=none; b=moaBn93iYJ/XA4YzKCsnD9LbiORhhImJxudxATlfMGZRDzMJqWSBp/+SwObGLooBLaOAnhfaTyRQjPKHOZnIdB5xQzGmc93+hYYq0BHwJSKerN0Q2HXkuhBJVC9J0umFOwu/0t6eqIFaJy5wOckFrRFMH8Ep+3fIchgIyc8TAUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354121; c=relaxed/simple;
	bh=9lLlz3z9s/vvSc0JN+a5VnYUBnydoxuxrX8yNCkyfyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TN9bIbg2NaxcrQz8/SVsh0bonRhSfhB52SEE9lOhiU0bloXQm+6XSti7r/f7ApYDXfxjE39N3p/pAK0Ph379mojTFlyNiPUJm7dQ4+2MW2LVLEQM7UkTPCcyHeeq+2v/LMalV6TIsRNpGeM9fFDY7LgS/K4fVyr1X+3LcONLj60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iT95Zvqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iT95Zvqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D99AC116C6;
	Fri,  6 Feb 2026 05:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354121;
	bh=9lLlz3z9s/vvSc0JN+a5VnYUBnydoxuxrX8yNCkyfyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iT95ZvqbipvmO67SazFYneVoeInYWlH4gtZo/TN+AqyQs8uSmcugRwtL7ApmKNmTT
	 P1nVAcWyHUt7OXm2o9Gl0Wm/O/H4HqAJG6PnrsvRc6YQQuxvQ4wTiVR/g6mgeAOvRX
	 PJg0lUcfmp8wmhPIrrMMVT/lfTRU5GX260D3HNypgaOWyEUarwoeMwObCjKB6ya/8K
	 20TS13YKj0HvHmok9DsDvUsFo+SrQDSRGr0AYU0jWqK8s1bxWtq8pja/XuWxiwn4eF
	 pqeFpqXG/Fqdeu/oNGpHtxZui/CZ2gD7DFKsPe0SuaSdHNT8agcCFmHNOa4ILi+53R
	 oUlm3P8D2gVbQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 18/22] dm-verity-fec: compute target region directly
Date: Thu,  5 Feb 2026 20:59:37 -0800
Message-ID: <20260206045942.52965-19-ebiggers@kernel.org>
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

Instead of determining the target block's region by checking which block
of the k blocks being iterated over in fec_read_bufs() is equal to the
target block, instead just directly use the quotient of the division of
target_block by region_blocks.

This is the same value, just derived in a more straightforward way.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 91670f7d0ea16..1b5052ba4f5a5 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -47,12 +47,12 @@ static inline u8 *fec_buffer_rs_message(struct dm_verity *v,
 /*
  * Decode all RS codewords whose message bytes were loaded into fio->bufs.  Copy
  * the corrected bytes into fio->output starting from out_pos.
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			   struct dm_verity_fec_io *fio, u64 rsb, int byte_index,
-			   unsigned int out_pos, int neras)
+			   struct dm_verity_fec_io *fio, u64 rsb,
+			   int target_region, unsigned int out_pos, int neras)
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
 	unsigned int n, i, j, parity_pos, to_copy;
 	uint16_t par_buf[DM_VERITY_FEC_MAX_ROOTS];
@@ -118,11 +118,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			r = res;
 			goto error;
 		}
 
 		corrected += res;
-		fio->output[out_pos++] = msg_buf[byte_index];
+		fio->output[out_pos++] = msg_buf[target_region];
 
 		if (out_pos >= v->fec->block_size)
 			goto done;
 	}
 done:
@@ -156,14 +156,14 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 /*
  * Read data blocks that are part of the RS block and deinterleave as much as
  * fits into buffers. Check for erasure locations if @neras is non-NULL.
  */
 static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
-			 u64 rsb, u64 target, unsigned int out_pos, int *neras)
+			 u64 rsb, unsigned int out_pos, int *neras)
 {
 	bool is_zero;
-	int i, j, target_index = -1;
+	int i, j;
 	struct dm_buffer *buf;
 	struct dm_bufio_client *bufio;
 	struct dm_verity_fec_io *fio = io->fec_io;
 	u64 block, ileaved;
 	u8 *bbuf;
@@ -181,18 +181,10 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	 * read each of the rs_k data blocks that are part of the RS block, and
 	 * interleave contents to available bufs
 	 */
 	for (i = 0; i < v->fec->rs_k; i++) {
 		ileaved = rsb + i * (v->fec->region_blocks << v->data_dev_block_bits);
-
-		/*
-		 * target is the data block we want to correct, target_index is
-		 * the index of this block within the rs_k RS blocks
-		 */
-		if (ileaved == target)
-			target_index = i;
-
 		block = ileaved >> v->data_dev_block_bits;
 		bufio = v->fec->data_bufio;
 
 		if (block >= v->data_blocks) {
 			block -= v->data_blocks;
@@ -250,12 +242,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			fec_buffer_rs_message(v, fio, n, j)[i] = bbuf[src_pos++];
 		}
 done:
 		dm_bufio_release(buf);
 	}
-
-	return target_index;
+	return 0;
 }
 
 /*
  * Allocate and initialize a struct dm_verity_fec_io to use for FEC for a bio.
  * This runs the first time a block needs to be corrected for a bio.  In the
@@ -318,26 +309,30 @@ static void fec_init_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio)
 static int fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 		      struct dm_verity_fec_io *fio, u64 target_block,
 		      const u8 *want_digest, bool use_erasures)
 {
 	int r, neras = 0;
-	unsigned int out_pos;
-	u64 offset = target_block << v->data_dev_block_bits;
+	unsigned int target_region, out_pos;
 	u64 rsb;
 
-	div64_u64_rem(offset, v->fec->region_blocks << v->data_dev_block_bits,
-		      &rsb);
+	target_region = div64_u64_rem(
+		target_block << v->data_dev_block_bits,
+		v->fec->region_blocks << v->data_dev_block_bits, &rsb);
+	if (WARN_ON_ONCE(target_region >= v->fec->rs_k))
+		/* target_block is out-of-bounds.  Should never happen. */
+		return -EIO;
 
 	for (out_pos = 0; out_pos < v->fec->block_size;) {
 		fec_init_bufs(v, fio);
 
-		r = fec_read_bufs(v, io, rsb, offset, out_pos,
+		r = fec_read_bufs(v, io, rsb, out_pos,
 				  use_erasures ? &neras : NULL);
 		if (unlikely(r < 0))
 			return r;
 
-		r = fec_decode_bufs(v, io, fio, rsb, r, out_pos, neras);
+		r = fec_decode_bufs(v, io, fio, rsb, target_region,
+				    out_pos, neras);
 		if (r < 0)
 			return r;
 
 		out_pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
-- 
2.52.0

