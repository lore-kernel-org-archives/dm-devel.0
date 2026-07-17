Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CD13D9536;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287615; cv=none; b=FBudCvHjFvy8IwrgIAn0qohBdgTI46Ym50aDWLgJuemsXPvIvR6ZduYtZ+jp13gasz27+p1kRlJMO2e2/hyz4p0gYlYalQz0F1roLj+40H551C4KWvfgzCp+eX4jZBSnPUeNpBexd39fhn3kQUsk9HZbX41by3mfpE2vHGXJ2Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287615; c=relaxed/simple;
	bh=FU4TB9foOjTAzfRZBxEplTNJb811gkIkuYzaTO0yq48=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sWpQeTiFQae8A7FbTKLNuOTyNSqpY4yPFm9Y/oBbuTDPG3Ei2J0UM3g8bnN7wkzLcf42e5ZfXkdS8XNnNK0xG7R2tX81fnXwJrYJ4wCyLMfuRyTQMUmqoKwoRxmIAV85uCv2vGnRF4h/L6wUfNMAgwpp605n4ITjkn+Kc2w9J78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QhnYq2cD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QhnYq2cD"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FF75C2BCF4;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=FU4TB9foOjTAzfRZBxEplTNJb811gkIkuYzaTO0yq48=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QhnYq2cDp8uze6laRAKffOpD/HGdfkDpnpRHQ0uESM/eJSOlK5v6rHecOIWG73bnv
	 kCRd1WRpNvX30zKsWcxf3e3q3KMe2FHK3pmcDDZACNQ6T4nbv9mA4gyOSgm1MLs0IQ
	 nqH6btYqHaIVY7yKYJcbPEFfHUWZTUcbTS6wpN8iZkYjxaKsboCjP83YaTsGHkMV+y
	 8yBfQxlCyWJOQWrT6AFDxyycDu0Y/P+m5dPH4DchEoAKPdqcFcOqBvlFeTo7LcTOJj
	 v0PeylQt/13okE7cBBOhc6jzUftU5bYrOf6bHdEhiauPKZIszBDPi7m835WEcPDNrV
	 orA9+qaJ4DfsQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E856AC44520;
	Fri, 17 Jul 2026 11:26:54 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:26:55 -0500
Subject: [PATCH v2 02/11] dm-pcache: validate geometry fields from on-disk
 cache_info
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-2-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=2084;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=GCHE1PL/rUxoLoC9YQBxjQe4fFzhqS5ltYxbiHXbkRg=;
 b=SqdujfX6WK0cZuhU3P+/HjIYYk/pnJEoHQNxbOtE7SY5MSzZq5lkwa00RVFxttWRR0BIiJKG5
 GBcD3GTe0eBDE1LYvPEK1QE5ycjrq75kJvibXYGPDRVQWoalvewntKq
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
index e9d2b87174d7..e4784578b9af 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -251,6 +251,13 @@ static int get_seg_id(struct pcache_cache *cache,
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
@@ -266,6 +273,13 @@ static int cache_segs_init(struct pcache_cache *cache)
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


