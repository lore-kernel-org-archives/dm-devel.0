Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCDC3D75A0
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 07:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791962367; cv=none; b=tnbWP6LxYhR1QKHwwYTPcmKe5NWBy9N+THSgqo4bNUC/FCJuHOvTjaNjQxBp11VQXJIVW+FnJ6KZsDQflb6eQ/2JMPOQPiguKrjm1NCevYExgzUkbiFQ31O1wAr3b1qDqPfdNj+sQBK5b9lOicWT3q5MIZXQJ4A3U79/LPMM9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791962367; c=relaxed/simple;
	bh=rI7Zz7xBqW2wJLCECQhv6Ip3ZDKb0sk2Wb0JhgxUeEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdOpCOgUmooAeAj5S941HkmAJ5WJ5ppeT597TDa+V/U/junbHJBKuAf+Cg4AUCKQM+R1wEc4sneGZ9gJ2h/9sUgrew8T5W2d+3rr5gKou0bUy8I3jFTo0t1GAX/bYIGJtY3Ns+QuwdYiNW9Ikxipov52g0ccJHZlHvP8F3NFYzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ESfiw6mG; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ESfiw6mG"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791962357; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=F9+DkmIqnvCA+PRQcmDzoeOEggv2+N0ViaEa0bb8/0A=;
	b=ESfiw6mG2MiMDryBI+DmHq5Pi1LcTD160c75XBBfLs7kBzirCDv+IngZoWP3l/jYReukmA3CUuQNjI4JWRrHWiXY7Wsro+FRYQzV5afNwp584IQpQPWof65E0rh1+SDUf8rxie0BvvVDIipIj5OWQt1yqWKM5E515M8Es6FBiNc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XCoKYVE_1791962355;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XCoKYVE_1791962355 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Oct 2026 15:19:15 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org
Cc: ebiggers@kernel.org,
	linux-fscrypt@vger.kernel.org,
	hch@lst.de,
	dm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	sweettea-kernel@dorminy.me,
	satyat@google.com,
	libaokun@linux.alibaba.com,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] blk-crypto: fix missing smp_load_acquire() for tfms_inited[]
Date: Wed, 14 Oct 2026 15:18:46 +0800
Message-ID: <20261014071846.3666398-2-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261014071846.3666398-1-libaokun@linux.alibaba.com>
References: <20261014071846.3666398-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

blk_crypto_fallback_start_using_mode() sets tfms_inited[] with
smp_store_release(), but blk_crypto_fallback_bio_prep() reads it
without smp_load_acquire() and without any lock protection.

Most callers are covered by blk-crypto itself: a task whose key needs
the fallback acquires the flag in the fast path of
blk_crypto_fallback_start_using_mode(), and its slow path is
serialized by tfms_init_lock.

But the problem can still be actually triggered: a task can inherit a
key without ever calling blk_crypto_start_using_key() itself, e.g. on
the lockless per-mode key cache hit in setup_per_mode_enc_key().  And
bios reach the dm target via srcu_dereference()/rcu_dereference(),
neither of which provides an acquire for tfms_inited[].

As a result, on a weakly ordered machine, the flag can be seen as
false and fail I/O, or as true while the tfms[] and fallback profile
initialization ordered before it is still invisible, and the reads
that follow can crash in the fallback I/O path.

Fix this by pairing the read with the release in
blk_crypto_fallback_start_using_mode() using smp_load_acquire(), and
hoist bc->bc_key->crypto_cfg into a local variable.

The plain read dates back to commit 488f6682c832 ("block:
blk-crypto-fallback for Inline Encryption") in v5.8, but was masked by
the smp_load_acquire() in fscrypt_is_key_prepared(); commit dd015b566d50
("fscrypt: Fix key setup in edge case with multiple data unit sizes")
in v7.2 replaced that with RCU publish/subscribe.

Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 block/blk-crypto-fallback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index b5dbb092caea..31f76d117593 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -488,15 +488,17 @@ static void blk_crypto_fallback_decrypt_endio(struct bio *bio)
 bool blk_crypto_fallback_bio_prep(struct bio *bio)
 {
 	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
+	const struct blk_crypto_config *cfg = &bc->bc_key->crypto_cfg;
 	struct bio_fallback_crypt_ctx *f_ctx;
 
-	if (WARN_ON_ONCE(!tfms_inited[bc->bc_key->crypto_cfg.crypto_mode])) {
+	/* Pairs with the release in blk_crypto_fallback_start_using_mode(). */
+	if (WARN_ON_ONCE(!smp_load_acquire(&tfms_inited[cfg->crypto_mode]))) {
 		/* User didn't call blk_crypto_start_using_key() first */
 		bio_io_error(bio);
 		return false;
 	}
 
-	if (bc->bc_key->crypto_cfg.key_type != BLK_CRYPTO_KEY_TYPE_RAW) {
+	if (cfg->key_type != BLK_CRYPTO_KEY_TYPE_RAW) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		return false;
 	}
-- 
2.43.7

