Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7453F44D0;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287615; cv=none; b=KwjkyqL0EsSB3P+UqM0G5EdDJ073LgmrZFx7ZHFrSwyRsrjnAxn7HnpLKFwIOKkBNkkZFZbKN6qhg0+lqrPVAOP+I66M+LLvppX+yAv2c3GmGywRlqUtBUaHQbK2hMlCqzM6Uv62otjJatPfsGJ2fDDTHwFuDV0nrTV5e64ch1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287615; c=relaxed/simple;
	bh=jvADCg6nk8lQ0L9apmZVhJQvCS/k+/aUVaN8asyYCdg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T6TCIBm8KPw2JXeqbT+d0QW2nITKAUGVV/J+ZGNnBtwvX8oiQLnpQTTA0mbh89gcVJYMgEMf184m+K0bNZm8bkN3zT8Wf9jeyPnWantVcvvHg7aFIqavRrW2futtGJPhjWARLzH4TcE6pRBhkaW8x0F14CR0s0sfX4d7JQ8mBp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=shnjWP6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="shnjWP6g"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C301C2BCF5;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=jvADCg6nk8lQ0L9apmZVhJQvCS/k+/aUVaN8asyYCdg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=shnjWP6gneALulcbmZpzQhDm83zyDHXHH1DsKgyVOhUSeIqHH9Wa9mbtGqJFt5hmD
	 6QSLr7MPEhZRiea01Nl75ynDe/dr9Jg4H2tH/9+ocIK0vSEbBqFhgn/KiPzkL+N9jZ
	 Q2Ev6AMmQyxLBoW+vWwRedIXl2lEPFWyegfJf3R5Jdvw1pvoljIMU+IFeaoVfltcld
	 hUXYp6xLa+UOI7MFmHSDxCO3a2yQdYOPO8nzKgpjagu1qTxZ22gfrPZi4fBBkAkEHV
	 FizZSmH1Ui5iQ/aj6wLT0XqIGaq0Z+f2Xg2nrAAAOKStOKc6/XcKUfliWb8585I2eJ
	 3oqG3qoM8iG2Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003D4C44521;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:26:56 -0500
Subject: [PATCH v2 03/11] dm-pcache: validate kset key_num and
 intra-segment bounds
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-3-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=5615;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=vmHcXjyHD4CeDO70qCWNVMIG5lczK7IUtU3PlSvOgfs=;
 b=6vpkyJtIgh2eYee7sOcg2BFaSEU49E6MKyEVe3qIh7Ux2SQsKo9XJEed+RS0vZfHsvMgAJHk7
 RUK8wYbe4KXCMZh2nK1NgmFJ6PzB7CyI3lGyjiatG4Gs/sMACwvU/0s
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

Two more fields decoded from the cache device go unbounded. The kset
key_num drives cache_kset_crc() and the replay loop in cache_replay(),
the writeback worker and the GC worker, but only the magic and a
fixed-seed CRC are checked first, so a non-last kset whose key_num exceeds
the PCACHE_KSET_KEYS_MAX buffer reads past its end before the CRC compare.
A key's intra-segment offset and length in cache_key_decode() are taken
verbatim, so a key running past its segment is replayed into the cache
tree and the data CRC check and every later read hit then copy adjacent
persistent memory into the caller's bio -- an out-of-bounds read that
leaks to user space. Both fields are controlled by whoever supplies the
cache device (CAP_SYS_ADMIN); the CRC seed is public.

Add kset_onmedia_valid() to bound key_num before any kset read, and
reject a key whose offset plus length, computed in 64 bits, exceeds the
segment data_size. Valid metadata is unaffected.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache.h           | 21 +++++++++++++++++++++
 drivers/md/dm-pcache/cache_gc.c        |  8 ++++----
 drivers/md/dm-pcache/cache_key.c       | 10 +++++++++-
 drivers/md/dm-pcache/cache_writeback.c |  8 ++++----
 4 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index 919736379b76..d9e3e09f18e3 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -506,6 +506,27 @@ static inline u32 cache_key_data_crc(struct pcache_cache_key *key)
 	return crc32c(PCACHE_CRC_SEED, data, key->len);
 }
 
+/**
+ * kset_onmedia_valid - Validate a kset header read from the cache device.
+ * @kset_onmedia: Pointer to the kset copied from on-media metadata.
+ *
+ * The magic and CRC are attacker-computable (fixed public seed). A non-last
+ * kset stores key_num keys inline, and cache_kset_crc() and the replay loop
+ * read struct_size(.., data, key_num) bytes from a buffer sized for
+ * PCACHE_KSET_KEYS_MAX keys, so key_num must be bounded before any such use.
+ */
+static inline bool kset_onmedia_valid(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC)
+		return false;
+
+	if (!(kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) &&
+	    kset_onmedia->key_num > PCACHE_KSET_KEYS_MAX)
+		return false;
+
+	return true;
+}
+
 static inline u32 cache_kset_crc(struct pcache_cache_kset_onmedia *kset_onmedia)
 {
 	u32 crc_size;
diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
index 02fa0ce03134..1ed513745023 100644
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -44,11 +44,11 @@ static bool need_gc(struct pcache_cache *cache, struct pcache_cache_pos *dirty_t
 		return false;
 	}
 
-	/* Check if kset_onmedia is corrupted */
-	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
-		pcache_dev_debug(pcache, "gc error: magic is not as expected. key_tail: %u:%u magic: %llx, expected: %llx\n",
+	/* Reject a corrupted or out-of-bounds kset before reading its keys */
+	if (!kset_onmedia_valid(kset_onmedia)) {
+		pcache_dev_debug(pcache, "gc error: invalid kset. key_tail: %u:%u magic: %llx, key_num: %u\n",
 					key_tail->cache_seg->cache_seg_id, key_tail->seg_off,
-					kset_onmedia->magic, PCACHE_KSET_MAGIC);
+					kset_onmedia->magic, kset_onmedia->key_num);
 		return false;
 	}
 
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index 8eec5238c5da..f4459b2e1b3b 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -103,6 +103,14 @@ int cache_key_decode(struct pcache_cache *cache,
 	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
 	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
 
+	if ((u64)key->cache_pos.seg_off + key->len >
+			key->cache_pos.cache_seg->segment.data_size) {
+		pcache_dev_err(pcache, "key seg_off %u + len %u exceeds segment data size %u\n",
+				key->cache_pos.seg_off, key->len,
+				key->cache_pos.cache_seg->segment.data_size);
+		return -EIO;
+	}
+
 	key->seg_gen = key_onmedia->seg_gen;
 	key->flags = key_onmedia->flags;
 
@@ -784,7 +792,7 @@ int cache_replay(struct pcache_cache *cache)
 			goto out;
 		}
 
-		if (kset_onmedia->magic != PCACHE_KSET_MAGIC ||
+		if (!kset_onmedia_valid(kset_onmedia) ||
 				kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
 			break;
 		}
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index 7751468d5118..34c34b448e04 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -55,11 +55,11 @@ static inline bool is_cache_clean(struct pcache_cache *cache, struct pcache_cach
 		return true;
 	}
 
-	/* Check if the magic number matches the expected value */
-	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
-		pcache_dev_debug(pcache, "dirty_tail: %u:%u magic: %llx, not expected: %llx\n",
+	/* Reject a corrupted or out-of-bounds kset before reading its keys */
+	if (!kset_onmedia_valid(kset_onmedia)) {
+		pcache_dev_debug(pcache, "dirty_tail: %u:%u invalid kset magic: %llx, key_num: %u\n",
 				dirty_tail->cache_seg->cache_seg_id, dirty_tail->seg_off,
-				kset_onmedia->magic, PCACHE_KSET_MAGIC);
+				kset_onmedia->magic, kset_onmedia->key_num);
 		return true;
 	}
 

-- 
2.43.0


