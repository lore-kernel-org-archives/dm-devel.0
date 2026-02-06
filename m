Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF39433F8B7;
	Fri,  6 Feb 2026 05:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354119; cv=none; b=iVVAl5DG842pQK7ivtC5YxUc7V989jD9CKqkLHVM3/l0c4FcIuCrk2oDN8HbITuuAY20Grr08BAqa3p9EEd79mg6zSWOedFTLwdK/HTZ2JcPYJ05Ky+WwzOtQ4+a1DLzp+8lwsD0nzExyswTSOrQD7wLjTdBisrepxZCkXzvF3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354119; c=relaxed/simple;
	bh=q12ukdq0V7Gw2F67fSDK+zMw1si1jmRuVzdXOJkXwZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGsdWUcECcXmm6V06PQ4pol+9p0LAljP5Mo81GYsDURR0Zz1oRYVaVynz3GtHG7ujTnXxYeo3vqvU+VnVG2k3VmuGIAF/B9Zcq9gqM/zd2lhTiT3vJOz5wIVcDsleDFgGPdZFcGj87hUFJSR+vV6e1FtkHzitE4xnpj+kSFVoo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6TgFLqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6TgFLqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EA7C19425;
	Fri,  6 Feb 2026 05:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354119;
	bh=q12ukdq0V7Gw2F67fSDK+zMw1si1jmRuVzdXOJkXwZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6TgFLqkFiPkoJA2yzN9EMlKE7Db5v+wM4sXrvjaAOr30h5g71I366HONEQHf0BOs
	 GY+l7ebGIfQrvz9rwZOTtBn42t4pz9uaRmiuZgMDrIUVq8qzNQr4w4p3B+4bVhndGq
	 kMNjcZ0igkFU5FtwCiTYjoulGQEh4vhTXHGuOKL3GTR36evQ2NTWpONlVWxVCwJDzm
	 P5O5hUUHbhOs05piW0J3LDQXgHm05P2YgDaEpXdMJUS+WsVr0cKnjYjgdKiVGQ9QNx
	 0emY+LjPZcBwYEJG4K9ChoInM9mril1WjrbF2D1E9B/BNoZLC8766X/X6RMeZVYcR+
	 KTaKbsiyGEB2g==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 14/22] dm-verity-fec: simplify computation of ileaved
Date: Thu,  5 Feb 2026 20:59:33 -0800
Message-ID: <20260206045942.52965-15-ebiggers@kernel.org>
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

fec_read_bufs() just iterates over a sequence of message blocks with
step size region_blocks.  At each step, 'ileaved' is just the offset (in
bytes) to one of these blocks.  Compute it in the straightforward way,
eliminating fec_interleave().

In more detail, previously the code computed
'ileaved = (n / k) + (n % k) * (region_blocks * block_size)'
where n = rsb * k + i and 0 <= i < k.  Substituting 'n' gives:

    ileaved = ((rsb * k + i) / k) + ((rsb * k + i) % k) * region_blocks * block_size
            = rsb + (i * region_blocks * block_size)

The result is more efficient and easier to understand.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 63eeef26a3999..3122017569718 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -21,21 +21,10 @@
 static inline unsigned int fec_max_nbufs(struct dm_verity *v)
 {
 	return 1 << (v->data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS);
 }
 
-/*
- * Return an interleaved offset for a byte in RS block.
- */
-static inline u64 fec_interleave(struct dm_verity *v, u64 offset)
-{
-	u32 mod;
-
-	mod = do_div(offset, v->fec->rs_k);
-	return offset + mod * (v->fec->region_blocks << v->data_dev_block_bits);
-}
-
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
 	for (__i = 0; __i < (io)->nbufs; __i++)
 
 /* Loop over each RS message in each allocated buffer. */
@@ -202,11 +191,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	/*
 	 * read each of the rs_k data blocks that are part of the RS block, and
 	 * interleave contents to available bufs
 	 */
 	for (i = 0; i < v->fec->rs_k; i++) {
-		ileaved = fec_interleave(v, rsb * v->fec->rs_k + i);
+		ileaved = rsb + i * (v->fec->region_blocks << v->data_dev_block_bits);
 
 		/*
 		 * target is the data block we want to correct, target_index is
 		 * the index of this block within the rs_k RS blocks
 		 */
-- 
2.52.0

