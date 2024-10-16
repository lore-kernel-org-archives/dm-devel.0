Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780BB1D5156;
	Wed, 16 Oct 2024 23:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729121310; cv=none; b=T1I9DGFJThGTQD3Ad+0GpxMh36ltwhQDV/ZBtTFeAjNnHxjSnVybjQNKG8M5rFdqjNQAcL6EXiwGM9Ee8iIQYBanTZLhtf3IikCD/gfcH4GSsmtkrI0yyIG0Uom6buDcdsK2PO5HXZbrPKwA9gJkIw6bj3hhFVVPTyKm2Rxqzb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729121310; c=relaxed/simple;
	bh=nI7UrqLsLdKByKriwY6w1+7j3MiucjYgOBqPVYBKIWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0kNkuNoYfv1l6UklgDxU+1m48ZJQGnnJygZQ1Xrbamoo48FhCabPEKKdPTcqNaUAZlfBskdLvWejW1POU2RrYf8bPrtuKXF7D1tuPBZm4x8lDHG6gLWget4cMqCNVPU4XRjRw2K/Mlgf74C4NfFgHVpsIyDT9YxWNpRC9Jne+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdBFIHum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdBFIHum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A81C4CEC7;
	Wed, 16 Oct 2024 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729121310;
	bh=nI7UrqLsLdKByKriwY6w1+7j3MiucjYgOBqPVYBKIWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdBFIHumrDC1qXlga//Rb95nQRIC2Ax5pmEUNpeVJ0MpoTpb4Ma9La6p+TLEQj7C3
	 BFB2Z1e57iyiBoCqpKhjoF5WN3sF+8AUGkZC2GCrMrFYNxnd73Kmw4Dkf72gNDkzpt
	 vmzhIP105zi7/1tsfdRhZ7luDAqfrvVqTHIz5NATxzqbJ92N7ZAMhiccQqgk6P7CsA
	 qQtwaPt2eHgEpiqwRTXhQI6NZA43ZcF7cG4NTOj+U8vbi8FAQVYDkKKQBZdeXCgzHM
	 zAwdKCLEHZuRHtMVKKa69QMaxIZUk/zPqIIa1mDHFABxDtbCvZhNpgqWkwqoiKWphP
	 VTD57w/whGwEQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [RFC PATCH v2 1/2] block: export blk-crypto symbols required by dm-inlinecrypt
Date: Wed, 16 Oct 2024 16:27:47 -0700
Message-ID: <20241016232748.134211-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241016232748.134211-1-ebiggers@kernel.org>
References: <20241016232748.134211-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

bio_crypt_set_ctx(), blk_crypto_init_key(), and
blk_crypto_start_using_key() are needed to use inline encryption; see
Documentation/block/inline-encryption.rst.  Export them so that
dm-inlinecrypt can use them.  The only reason these weren't exported
before was that inline encryption was previously used only by fs/crypto/
which is built-in code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb9..5a121b1292f9a 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -104,10 +104,11 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 	bc->bc_key = key;
 	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
 
 	bio->bi_crypt_context = bc;
 }
+EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
 
 void __bio_crypt_free_ctx(struct bio *bio)
 {
 	mempool_free(bio->bi_crypt_context, bio_crypt_ctx_pool);
 	bio->bi_crypt_context = NULL;
@@ -354,10 +355,11 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	blk_key->size = mode->keysize;
 	memcpy(blk_key->raw, raw_key, mode->keysize);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_init_key);
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg)
 {
 	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
@@ -396,10 +398,11 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 {
 	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
+EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
 
 /**
  * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
  * @bdev: a block_device on which I/O using the key may have been done
  * @key: the key to evict
-- 
2.47.0

