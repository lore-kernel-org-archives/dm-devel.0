Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A7737FF76;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781869496; cv=none; b=e/TZaMGMkNK0z6GQrNjA3HHYCj205IzE31gRbXLO8UCYmuny7NiWLZVm1R7XWmyErwUP1UsV7aDgs3/FH5QW2l+9gSGKvHMdMpSO+w2y06mvzYUHSpyPgRXAypIgxwInNdmyzefU1LQ/yXH3FTFXxZXpiSjC5dC3Mi/+1FimiSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781869496; c=relaxed/simple;
	bh=SPXTsD27GCZ3yIoAET6XG6gK5Zvmcd7gnoh5S/4wPwQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h5kQeJiZAqpRpgYhwcOprFdv9fHSr34uKj+N6H0M3zCQBYInwfnNrCD/3Fude7JiQaphpQmM6atq4M51EmrZffbbM+861uxqav/dUu+Kn1FdZ03ZV2EEkoiFBKaRzshVtQfshvbdRWe6x9BaGqhhutrPU3THSASlGKtE6ahY8Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ETVE5Bcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ETVE5Bcm"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E3D6C2BCC9;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781869496;
	bh=SPXTsD27GCZ3yIoAET6XG6gK5Zvmcd7gnoh5S/4wPwQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ETVE5BcmVl6pyMUTBDpvCmE8PKvhBQrGw7M0g+rgOcTWHiLvXTo1xQjdjMR0swGYs
	 sOaWLCNSuH0hR4kDTGc+whPVXZmy4Jk/yaV4FtHnlvy4BTilOpFnPvkXwlAFmtAvI1
	 jSyjm1ufNjITY5q2ZWFN0cVDVhH3440xpQye8zCYKcBrYebmO0pX7i7PBQJn8rSUxf
	 Bo3GUadAjOkgbIpiRONHrUH1Kj4Jkpc1smAKriqqUyxEGZCV18kPtABibqyK7W7YTP
	 8TQClx2uBBzIEOm8RbidlxUoyh08zZ+dbG/IuoWen+GhdXOOpfjd3etESfOKC9tgEF
	 6xk+sSTvGmadQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2388ACD98F2;
	Fri, 19 Jun 2026 11:44:56 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 19 Jun 2026 06:44:56 -0500
Subject: [PATCH 2/3] dm-pcache: validate geometry fields from on-disk
 cache_info
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260619-b4-disp-997773a1-v1-2-14df8aedb323@proton.me>
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
In-Reply-To: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
To: Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, 
 dm-devel@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781869494; l=2084;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=bb6DrPNz+Bfj+QxSSibZlFjrtYBvqCnc6cN4V9NacuA=;
 b=4pml7tRY5d1LmqKNrj6uCcpKEWNTF9ovhDPkfHBNoohwbnAyzW7IQERPzklSPIoz62bj7Y3zy
 JPIlv/KkPiSAtBhAuWPknFGeTZLLWHM92OCnFprWcsReSfCuZYJejDl
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

cache_segs_init() iterates cache_info->n_segs times indexing
cache->segments[], which is sized to the cache device geometry, and
get_seg_id() takes each segment id from the on-media cache_info and the
per-segment next_seg link. Both come from cache device metadata that is
only CRC-protected with a fixed public seed, so whoever supplies the
cache device on a table load (CAP_SYS_ADMIN) controls them: an oversized
n_segs or an out-of-range id drives an out-of-bounds access of
cache->segments[] and a wild CACHE_DEV_SEGMENT() pointer into the device
mapping -- an out-of-bounds read and write from on-disk data.

Reject an n_segs that exceeds the device segment count and a segment id
that is out of range before either is used. Valid metadata is unaffected.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index e6a2f4460f6e..08decbebd238 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -250,6 +250,13 @@ static int get_seg_id(struct pcache_cache *cache,
 		} else {
 			*seg_id = cache->cache_info.seg_id;
 		}
+
+		if (*seg_id >= cache_dev->seg_num) {
+			pcache_dev_err(pcache, "invalid segment id %u from cache device (seg_num %u)\n",
+				       *seg_id, cache_dev->seg_num);
+			ret = -EIO;
+			goto err;
+		}
 	}
 	return 0;
 err:
@@ -265,6 +272,13 @@ static int cache_segs_init(struct pcache_cache *cache)
 	int ret;
 	u32 i;
 
+	if (cache_info->n_segs > cache->cache_dev->seg_num) {
+		pcache_dev_err(CACHE_TO_PCACHE(cache),
+			       "cache_info n_segs %u exceeds cache device segments %u\n",
+			       cache_info->n_segs, cache->cache_dev->seg_num);
+		return -EIO;
+	}
+
 	for (i = 0; i < cache_info->n_segs; i++) {
 		ret = get_seg_id(cache, prev_cache_seg, new_cache, &seg_id);
 		if (ret)

-- 
2.43.0


