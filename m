Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1C03F44F6;
	Fri, 17 Jul 2026 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287616; cv=none; b=XemC9wH1CjoHTGG0uKsg1n2+RM/+ok92uPt/lZgcAZWgc8EQFmSrVvX/MQEwcqju8Vh6n82V4zJZMV2v2gDhirOIrlbdGsfWoBg54DozS8zPEGiqv7fAKJ3+77BbaEsBH1iVRp8y/rijh+GbzxG009UsrdIHyDPTpSmRYtHn4uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287616; c=relaxed/simple;
	bh=Usa3x/tTafYQCV7IO1VV/mtgaTzMSkOJweMxgvUeN0k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Rs+uyKWiW34AV2NpeXjl312pDeXXCWmTjfsOCQsWpzVR4bBdQFRtha0GaeoF0VKTXB7SXrhk0x3R898Zob3Tqdg558LGzp7x4hNQyOFMmC4wNahMYJuC9/1S9u8yVU4qQ1gzvoxDBWyUdqw7z65rHzTfQK/runbHbc0EhyWi/DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxA99hsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxA99hsR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53BCBC2BCFF;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=Usa3x/tTafYQCV7IO1VV/mtgaTzMSkOJweMxgvUeN0k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LxA99hsRcP4h2PmYQWNLSM90u6u2sDj3Ro+cSFrFGz5Zd6Ek9aOLTNN0/m1y0Bexb
	 y6XZCrTadj1x0RVLoy9/mGir8aHb+qURXaFIHueCQCaCRDhd2EUy3x0s/Ggf9Sf/BT
	 VFBjqSO+Cw3qD/z9zCxQRec8OvPJm0ZwYvYJD6e085AAEn/aC9G2Sli0Cwgk7gsYNk
	 bTOY0jMCEN9DSk3qvPZTy/p//9T4UgfO+ZK9R2Xr+doOqtvNw0IMNnW1DetyG4xyr8
	 pFHCOYRiKkH5+g+Q1bzFXYPfgJ04/tx75oRDYU57qJ9IvzeaUCd7aPjIzwxZvhg7jY
	 UgoJBWvm4H7PA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44246C44521;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:27:01 -0500
Subject: [PATCH v2 08/11] dm-pcache: clamp the tail kset read to the
 segment data region
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-8-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=2745;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=E5WY/heNRdOuUSIYPvzHn8WEjCPo/EDvLcmW1MLvc+Y=;
 b=p2edeCDryLm/44W8WP1BxLnQnCv9Uio2larwFqIGpC5JBK1XhzAG/W2Z9dyv14Cx4yq/r+LIz
 gbEzP4R+KccDbf6Ej2690rQ98s9NcmcV5rObP42Kfp7P/AB8VWka+cg
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

The tail-kset read in cache_replay(), the writeback worker and the GC
worker bounds its length by PCACHE_SEG_SIZE - seg_off, the raw segment
size rather than the data region. A tail near the segment end reads past
the segment data into the following control area.

Clamp the read to cache_seg_remain(), the data region.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache_gc.c        | 2 +-
 drivers/md/dm-pcache/cache_key.c       | 2 +-
 drivers/md/dm-pcache/cache_writeback.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
index c483c7a3afaf..d551848912b4 100644
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -37,7 +37,7 @@ static bool need_gc(struct pcache_cache *cache, struct pcache_cache_pos *dirty_t
 
 	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->gc_kset_onmedia_buf;
 
-	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - key_tail->seg_off);
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, cache_seg_remain(key_tail));
 	ret = copy_mc_to_kernel(kset_onmedia, key_addr, to_copy);
 	if (ret) {
 		pcache_dev_err(pcache, "error to read kset: %d", ret);
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index 86cc9565ffc7..f3ce319037be 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -794,7 +794,7 @@ int cache_replay(struct pcache_cache *cache)
 	__set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
 
 	while (true) {
-		to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - pos->seg_off);
+		to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, cache_seg_remain(pos));
 		ret = copy_mc_to_kernel(kset_onmedia, cache_pos_addr(pos), to_copy);
 		if (ret) {
 			ret = -EIO;
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index 7a85a9aed18e..c8a4c8110a58 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -48,7 +48,7 @@ static inline bool is_cache_clean(struct pcache_cache *cache, struct pcache_cach
 	addr = cache_pos_addr(dirty_tail);
 	kset_onmedia = (struct pcache_cache_kset_onmedia *)cache->wb_kset_onmedia_buf;
 
-	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, PCACHE_SEG_SIZE - dirty_tail->seg_off);
+	to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, cache_seg_remain(dirty_tail));
 	ret = copy_mc_to_kernel(kset_onmedia, addr, to_copy);
 	if (ret) {
 		pcache_dev_err(pcache, "error to read kset: %d", ret);

-- 
2.43.0


