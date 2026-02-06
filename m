Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AC333E362;
	Fri,  6 Feb 2026 05:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354119; cv=none; b=gBZPmC/uhvSqW9zKyRuMEmPpLDjJD4NLh1Zj7mzZenAgOsgRBf3nb5HneJ/PUsNVQkGiYgU092Ag2xypplXyVtiU/4acscWQiQ5GWvy50DzXaOqEZ5G/SSWUYwTKG2R5y7jCKvyvap5nTWyeeMwfA4849HBRV1yQvNGOgjVmp+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354119; c=relaxed/simple;
	bh=JrIa7qVjgco23oEdNk11fbBPh6eb3JlTnlJk1zebbOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBOYv0DzurLJckyF2/BYWqDqb5NgQ/w17TXQ7TBBknOonWNLdK+SLJGKq08ey31gcpw5I4Zj17OGhuG6myRlj70ZWQiMnxJQy/OUgcddue2T/ZxX8dwk7OfHSD8ZSndbnJ07G/mczl3MG7iXYJMKTs7bNSnHXdiXZsZiHIJmojE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOFHYNJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOFHYNJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBC5C19422;
	Fri,  6 Feb 2026 05:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354118;
	bh=JrIa7qVjgco23oEdNk11fbBPh6eb3JlTnlJk1zebbOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOFHYNJW3bEFPhHNOyMlL7yBpDBMjQaf70zEdryOu0pGuRV88GZ2pY+LYZeo1yab9
	 S7CGv3Kiy4SIyqlCcxsU0VqpXPRS59msEkXAS10vgBl7TBBNyqd+NqGduB1QLbZIl3
	 F8LefsEQ1lhOCkdobQ8Ca+E/SrPUN+SjLKiAv/RZi086M+gdkVELpGTBc/IDYcQKtx
	 qqbFPH5I2XaaF4I7dyEhGRRkzTzy3B6h/S5F++9oxx8wj77VBTb7VbN6k6u0zd7hlp
	 4BTbqkm+NEWC2RMIokcNg6Eg9QeJQtHMJVOYKaBCzFxJTSmggoFu/mWWLZcbW0QnVz
	 qIFJtLxsYhxIw==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/22] dm-verity-fec: rename rounds to region_blocks
Date: Thu,  5 Feb 2026 20:59:31 -0800
Message-ID: <20260206045942.52965-13-ebiggers@kernel.org>
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

It's hard to reconcile the value stored in dm_verity_fec::rounds with
its name and documentation.  Most likely "rounds" is being used as an
alias for what is more commonly called the interleaving degree or
"number of ways".  But the interleaving is done at the byte level,
whereas the units of "rounds" are blocks.  So it's not really that.

In practice, the reason the code needs this value is that it expresses
the number of blocks in each "region" of the message data, where each
region contains the bytes from a particular index in the RS codewords.

Rename it to region_blocks to make the code a bit more understandable.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 16 ++++++++--------
 drivers/md/dm-verity-fec.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 6ba9a1e039be3..28b47497c3d3f 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -29,11 +29,11 @@ static inline unsigned int fec_max_nbufs(struct dm_verity *v)
 static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
 {
 	u32 mod;
 
 	mod = do_div(offset, v->fec->rs_k);
-	return offset + mod * (v->fec->rounds << v->data_dev_block_bits);
+	return offset + mod * (v->fec->region_blocks << v->data_dev_block_bits);
 }
 
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
 	for (__i = 0; __i < (io)->nbufs; __i++)
@@ -403,17 +403,17 @@ int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
 	 * and each code is interleaved over k blocks to make it less likely
 	 * that bursty corruption will leave us in unrecoverable state.
 	 */
 
 	offset = block << v->data_dev_block_bits;
-	res = div64_u64(offset, v->fec->rounds << v->data_dev_block_bits);
+	res = div64_u64(offset, v->fec->region_blocks << v->data_dev_block_bits);
 
 	/*
 	 * The base RS block we can feed to the interleaver to find out all
 	 * blocks required for decoding.
 	 */
-	rsb = offset - res * (v->fec->rounds << v->data_dev_block_bits);
+	rsb = offset - res * (v->fec->region_blocks << v->data_dev_block_bits);
 
 	/*
 	 * Locating erasures is slow, so attempt to recover the block without
 	 * them first. Do a second attempt with erasures if the corruption is
 	 * bad enough.
@@ -657,19 +657,19 @@ int verity_fec_ctr(struct dm_verity *v)
 	if (!f->blocks) {
 		ti->error = "Missing " DM_VERITY_OPT_FEC_BLOCKS;
 		return -EINVAL;
 	}
 
-	f->rounds = f->blocks;
-	if (sector_div(f->rounds, f->rs_k))
-		f->rounds++;
+	f->region_blocks = f->blocks;
+	if (sector_div(f->region_blocks, f->rs_k))
+		f->region_blocks++;
 
 	/*
 	 * Due to optional metadata, f->blocks can be larger than
 	 * data_blocks and hash_blocks combined.
 	 */
-	if (f->blocks < v->data_blocks + hash_blocks || !f->rounds) {
+	if (f->blocks < v->data_blocks + hash_blocks || !f->region_blocks) {
 		ti->error = "Invalid " DM_VERITY_OPT_FEC_BLOCKS;
 		return -EINVAL;
 	}
 
 	/*
@@ -691,11 +691,11 @@ int verity_fec_ctr(struct dm_verity *v)
 		return PTR_ERR(f->bufio);
 	}
 
 	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
 
-	if (dm_bufio_get_device_size(f->bufio) < f->rounds * f->roots) {
+	if (dm_bufio_get_device_size(f->bufio) < f->region_blocks * f->roots) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}
 
 	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev, f->block_size,
diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
index 49d43894ea746..50b5e187d5cc1 100644
--- a/drivers/md/dm-verity-fec.h
+++ b/drivers/md/dm-verity-fec.h
@@ -30,11 +30,11 @@ struct dm_verity_fec {
 	struct dm_bufio_client *data_bufio;	/* for data dev access */
 	struct dm_bufio_client *bufio;		/* for parity data access */
 	size_t block_size;	/* size of data, hash, and parity blocks in bytes */
 	sector_t start;		/* parity data start in blocks */
 	sector_t blocks;	/* number of blocks covered */
-	sector_t rounds;	/* number of interleaving rounds */
+	sector_t region_blocks; /* blocks per region: ceil(blocks / rs_k) */
 	sector_t hash_blocks;	/* blocks covered after v->hash_start */
 	unsigned char roots;	/* parity bytes per RS codeword, n-k of RS(n, k) */
 	unsigned char rs_k;	/* message bytes per RS codeword, k of RS(n, k) */
 	mempool_t fio_pool;	/* mempool for dm_verity_fec_io */
 	mempool_t rs_pool;	/* mempool for fio->rs */
-- 
2.52.0

