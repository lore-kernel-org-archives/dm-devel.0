Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728863DDB02;
	Fri, 17 Jul 2026 11:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287617; cv=none; b=oqE1btVIg6apjfnqSh8j938HOCamHHsyGiXhY9THzrpC9bS2X/DAtPefQcypdCbpEwyyVyW0CgEhb+uKrWMpNliby+6/RVpiOMC2xqczL6l4IhYB8bbGQ7GcZLCjUyly4R6bvB9vYpGqNfgCCZ7t3n67DT1l483hStnqABLkS7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287617; c=relaxed/simple;
	bh=qZgHoupFF7+MLm4NslKOOanE3bOGe4JYnq1g8Efs/tM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NJTT8rw+KqZTFgeuS72RpdB8ookSpm/oipyCXT3dHT7PBBYVI8QAxH20QE0W06GhIUmZ1ftSywHGbPzczVm/ihGgDzXIff6EYhG1pi/uEo4IW8LKSVReUDk52pI5M4szAgaDPgbxK6+3aeCTQQ2OLoRO2iuVGUpA6GqqWi3k7lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcUXXeEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcUXXeEN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39C95C2BCFC;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=qZgHoupFF7+MLm4NslKOOanE3bOGe4JYnq1g8Efs/tM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pcUXXeENpoQD/guG0NVM2eZxHfvzqGOablch7U49PB9wR+coq4B+bdQjUyTIW/dar
	 VvzlooTTpHlrRnHEuleNl+Z2LUVkMRUxY3pcwdvq4V3kRf7OB01hpofrLHMIDrZgnI
	 pto/yWIRu3tgnGIZjC391sN7b41ubb2qyi1P47d/5Jjgs0i1bJdjmcKYR9lCaisxfn
	 tUesXvjkMghjbhwOlrjKrKkuazl2N7P84fPRVbg93WueuC2ocx+Xn5hJ0D+slXCl3U
	 Yda7PgKwOR6PEeEUGaINlR79478eq2Q8r0076baxSfMyBJQ6Wjfw1GWtV7A0pQI1+7
	 ND28HcEuqu4jA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A20BC44520;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:26:59 -0500
Subject: [PATCH v2 06/11] dm-pcache: detect a cycle in the last-kset chain
 during replay
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-6-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=1415;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=ZwCcFfHgFT+HQDBZxOs1rAKOfWWhRa9VFuMd2jR4RIs=;
 b=2QfF3AR5XbVtkeYQvFhpMG0sqALSKUkx498zGe5TuNgDe9Quf9uV1zxQIIq85/+9UkYdd/y0d
 RPSpPZV7Vx1BUAyHYLrbyuso+MYylindUlaDZckla5kiJbUkmjQKUOC
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

cache_replay() follows the on-media last-kset chain by next_cache_seg_id
with no cond_resched(). A forged chain that points back into a segment it
has already visited makes the replay loop follow it forever.

Cap the last-kset hops at cache->n_segs; a valid chain visits each segment
at most once.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache_key.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index d00497f9e462..2284dbc0807b 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -768,7 +768,7 @@ int cache_replay(struct pcache_cache *cache)
 	struct pcache_cache_pos pos_tail;
 	struct pcache_cache_pos *pos;
 	struct pcache_cache_kset_onmedia *kset_onmedia;
-	u32 to_copy, count = 0;
+	u32 to_copy, count = 0, last_hops = 0;
 	int ret = 0;
 
 	kset_onmedia = kzalloc(PCACHE_KSET_ONMEDIA_SIZE_MAX, GFP_KERNEL);
@@ -808,6 +808,11 @@ int cache_replay(struct pcache_cache *cache)
 				goto out;
 			}
 
+			if (++last_hops > cache->n_segs) {
+				ret = -EIO;
+				goto out;
+			}
+
 			next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
 
 			pos->cache_seg = next_seg;

-- 
2.43.0


