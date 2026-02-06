Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6B340A47;
	Fri,  6 Feb 2026 05:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354120; cv=none; b=oFy4fjTBNl+Hsck8NgGzxpFV6Qwb87PvYqTzbfe5teKS5NgY+LbdMfoZHJ1rxB5xuDdtDhH6hkPQ12vKIyKqJOe2uFghrSAkZPfaoEnV6mn968ZxLh107s3STWawzgg1X4ns1qCY0xA6LjywW4g7DGu8de8MG6vSKl/AFEuFG0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354120; c=relaxed/simple;
	bh=Us/3A/uVIpXU4eoqytLGpmeBBcgd8JSB5lx6TRXvCoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkjnOQN7QiIxqZYtokIY9tqR39V3Syb/ghXdm5ExV/ViBE9eKoHrc+/No82PI+Nu52NvB2rml6bG4RZGhNZLvzm37sLOY2RRmufrRS6evgghdUjUF7u14WNVmzkiH2bGdJxOx6Nu5n5mUy8SPxr1UDpfXp3Q1/I9cgm0ZDHwgMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwYV3WzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwYV3WzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F04C16AAE;
	Fri,  6 Feb 2026 05:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354120;
	bh=Us/3A/uVIpXU4eoqytLGpmeBBcgd8JSB5lx6TRXvCoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwYV3WzBq7DiPyapUyaMqDUtFMuRHMle2OXx8nzy/+q5mp4N7VshIzSGE0xGECNCx
	 AgkTKunwRcDbMc+ngN4ixita4dH2YNUCfGQJvUAzXhBXbYso+200RdEXeTaxvgc06p
	 TC7Iq2oOt3I6o8r2GObwncQz4rzzBPBoRpIo8VMJpnKCrh5AT8TlM7lYkYVTlbArgA
	 agqIzlSdw/jc37st2q2N31LKVW+vtydK3FUZJj72k6xM1XbnFXAccxtJ4dds8O3PVO
	 IZ3o6VEa+H9K6Cdv3bvTRTGYbkD3PtXH0LiBYnRTG20E4Lj8XgjaWi3oPPG/UrFFM9
	 lhw4NLuKabVWA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 15/22] dm-verity-fec: simplify deinterleaving
Date: Thu,  5 Feb 2026 20:59:34 -0800
Message-ID: <20260206045942.52965-16-ebiggers@kernel.org>
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

Since fec_read_bufs() deinterleaves the bytes from 'bbuf' sequentially
starting from 'block_offset', it can just do simple increments instead
of the more complex fec_buffer_rs_index() computation.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 3122017569718..a49c43ca07763 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -42,19 +42,10 @@ static inline u8 *fec_buffer_rs_message(struct dm_verity *v,
 					unsigned int i, unsigned int j)
 {
 	return &fio->bufs[i][j * v->fec->rs_k];
 }
 
-/*
- * Return the index of the current RS message when called inside
- * fec_for_each_buffer_rs_message.
- */
-static inline unsigned int fec_buffer_rs_index(unsigned int i, unsigned int j)
-{
-	return (i << DM_VERITY_FEC_BUF_RS_BITS) + j;
-}
-
 /*
  * Decode all RS codewords whose message bytes were loaded into fio->bufs.  Copy
  * the corrected bytes into fio->output starting from block_offset.
  */
 static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
@@ -177,11 +168,11 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	struct dm_bufio_client *bufio;
 	struct dm_verity_fec_io *fio = io->fec_io;
 	u64 block, ileaved;
 	u8 *bbuf;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
-	unsigned int n, k;
+	unsigned int n, src_pos;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	if (neras)
 		*neras = 0;
 
@@ -252,17 +243,15 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 
 		/*
 		 * deinterleave and copy the bytes that fit into bufs,
 		 * starting from block_offset
 		 */
+		src_pos = block_offset;
 		fec_for_each_buffer_rs_message(fio, n, j) {
-			k = fec_buffer_rs_index(n, j) + block_offset;
-
-			if (k >= v->fec->block_size)
+			if (src_pos >= v->fec->block_size)
 				goto done;
-
-			fec_buffer_rs_message(v, fio, n, j)[i] = bbuf[k];
+			fec_buffer_rs_message(v, fio, n, j)[i] = bbuf[src_pos++];
 		}
 done:
 		dm_bufio_release(buf);
 	}
 
-- 
2.52.0

