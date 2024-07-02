Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA7D146010;
	Tue,  2 Jul 2024 06:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902985; cv=none; b=ossyeBeAZsi3jkvap6IcRtLZ2Gs8clSKQcfDne+eoErRQU+Os2iwrydCLq3RgDexKZMJWQ4mHGy9A1h35SuBaFO3FcvGGUzECDUYPU/7RZInG0ZbHtQdF0fHJk8adOISjf5LWk9HVplSnAcG3flT6Voy20s3H1Nx/HHbTA7CeFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902985; c=relaxed/simple;
	bh=V0k62jEzU2JMobLfaZ0TRIW0f9VCrDHDAVQoQebijdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLvcUPDLtf6ZpY1CJHogCprzIsRCag2KQPAHsJ9coNOPftiezt9GrAQJALlArwJMdmBC1h9v5p+fqyXoOPvCsop5ULnEQmDYrrYVVHM3FBpgwdTyWvmostkrEaPZwZEldDLw8yKKl/RmfBt221gCRwPHknqwZG6/QPpVx9oOMuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KF9Hj4fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KF9Hj4fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0397AC116B1;
	Tue,  2 Jul 2024 06:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719902985;
	bh=V0k62jEzU2JMobLfaZ0TRIW0f9VCrDHDAVQoQebijdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF9Hj4fvb3ROqmVkqEEE16kaCINRw/ttHpMGp8mKYOV3m9CSMavrxr141mMC+VF/O
	 yJnDOIKFvz6QBB1axkvFb28iLInSbSSDGMYkMnaqUZMTYmNkFhGbn9L1Y9uOzai624
	 eGp/H4iG4oq0y11SJ/vLMg+DG+Y5gILvsyYWE/1KcVR19whg33imKfMCZDmMHIqI/M
	 miKXYeXolO6JwTLXYvtSCXLYmLR4AD7zPm53tJ8PkWm/6ln32iLZhRQUi3dQJjQrIm
	 1xZh9l7weA0aQPwNQpsY2jm4/Uuf5Z4mIvi/zLBEs4FmLHPbmOGfaAHqJaHj+AMjUl
	 oO+xUdGc5ImWg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6/7] dm-verity: make verity_hash() take dm_verity_io instead of ahash_request
Date: Mon,  1 Jul 2024 23:48:34 -0700
Message-ID: <20240702064835.120541-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702064835.120541-1-ebiggers@kernel.org>
References: <20240702064835.120541-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In preparation for adding shash support to dm-verity, change
verity_hash() to take a pointer to a struct dm_verity_io instead of a
pointer to the ahash_request embedded inside it.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-fec.c    |  6 ++----
 drivers/md/dm-verity-target.c | 21 ++++++++++-----------
 drivers/md/dm-verity.h        |  2 +-
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index b838d21183b5..62b1a44b8dd2 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -184,12 +184,11 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_io *io,
  * Locate data block erasures using verity hashes.
  */
 static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *want_digest, u8 *data)
 {
-	if (unlikely(verity_hash(v, verity_io_hash_req(v, io),
-				 data, 1 << v->data_dev_block_bits,
+	if (unlikely(verity_hash(v, io, data, 1 << v->data_dev_block_bits,
 				 verity_io_real_digest(v, io), true)))
 		return 0;
 
 	return memcmp(verity_io_real_digest(v, io), want_digest,
 		      v->digest_size) != 0;
@@ -386,12 +385,11 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
 
 		pos += fio->nbufs << DM_VERITY_FEC_BUF_RS_BITS;
 	}
 
 	/* Always re-validate the corrected block against the expected hash */
-	r = verity_hash(v, verity_io_hash_req(v, io), fio->output,
-			1 << v->data_dev_block_bits,
+	r = verity_hash(v, io, fio->output, 1 << v->data_dev_block_bits,
 			verity_io_real_digest(v, io), true);
 	if (unlikely(r < 0))
 		return r;
 
 	if (memcmp(verity_io_real_digest(v, io), verity_io_want_digest(v, io),
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 3e2e4f41714c..4aa140751166 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -178,13 +178,14 @@ static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
 	r = crypto_wait_req(crypto_ahash_final(req), wait);
 out:
 	return r;
 }
 
-int verity_hash(struct dm_verity *v, struct ahash_request *req,
+int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		const u8 *data, size_t len, u8 *digest, bool may_sleep)
 {
+	struct ahash_request *req = verity_io_hash_req(v, io);
 	int r;
 	struct crypto_wait wait;
 
 	r = verity_hash_init(v, req, &wait, may_sleep);
 	if (unlikely(r < 0))
@@ -323,12 +324,11 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (skip_unverified) {
 			r = 1;
 			goto release_ret_r;
 		}
 
-		r = verity_hash(v, verity_io_hash_req(v, io),
-				data, 1 << v->hash_dev_block_bits,
+		r = verity_hash(v, io, data, 1 << v->hash_dev_block_bits,
 				verity_io_real_digest(v, io), !io->in_bh);
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
@@ -426,12 +426,11 @@ static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
 	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
 	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		goto free_ret;
 
-	r = verity_hash(v, verity_io_hash_req(v, io), buffer,
-			1 << v->data_dev_block_bits,
+	r = verity_hash(v, io, buffer, 1 << v->data_dev_block_bits,
 			verity_io_real_digest(v, io), true);
 	if (unlikely(r))
 		goto free_ret;
 
 	if (memcmp(verity_io_real_digest(v, io),
@@ -542,11 +541,11 @@ static int verity_verify_io(struct dm_verity_io *io)
 			memset(data, 0, block_size);
 			kunmap_local(data);
 			continue;
 		}
 
-		r = verity_hash(v, verity_io_hash_req(v, io), data, block_size,
+		r = verity_hash(v, io, data, block_size,
 				verity_io_real_digest(v, io), !io->in_bh);
 		if (unlikely(r < 0)) {
 			kunmap_local(data);
 			return r;
 		}
@@ -983,33 +982,33 @@ static int verity_alloc_most_once(struct dm_verity *v)
 }
 
 static int verity_alloc_zero_digest(struct dm_verity *v)
 {
 	int r = -ENOMEM;
-	struct ahash_request *req;
+	struct dm_verity_io *io;
 	u8 *zero_data;
 
 	v->zero_digest = kmalloc(v->digest_size, GFP_KERNEL);
 
 	if (!v->zero_digest)
 		return r;
 
-	req = kmalloc(v->ahash_reqsize, GFP_KERNEL);
+	io = kmalloc(sizeof(*io) + v->ahash_reqsize, GFP_KERNEL);
 
-	if (!req)
+	if (!io)
 		return r; /* verity_dtr will free zero_digest */
 
 	zero_data = kzalloc(1 << v->data_dev_block_bits, GFP_KERNEL);
 
 	if (!zero_data)
 		goto out;
 
-	r = verity_hash(v, req, zero_data, 1 << v->data_dev_block_bits,
+	r = verity_hash(v, io, zero_data, 1 << v->data_dev_block_bits,
 			v->zero_digest, true);
 
 out:
-	kfree(req);
+	kfree(io);
 	kfree(zero_data);
 
 	return r;
 }
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index bd461c28b710..0e1dd02a916f 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -114,11 +114,11 @@ static inline u8 *verity_io_want_digest(struct dm_verity *v,
 					struct dm_verity_io *io)
 {
 	return io->want_digest;
 }
 
-extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
+extern int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
 		       const u8 *data, size_t len, u8 *digest, bool may_sleep);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
-- 
2.45.2

