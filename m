Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B63F44FF;
	Fri, 17 Jul 2026 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287616; cv=none; b=Qy9ru3yda02RDggSU5F5KeaFgyg9KDdTi2a15/fXdeeOqBcEIIolSycxme99IyDTL30C9xh8W/VIYpQf/MVmRcoiizFa34bChKHv42F0wQ31ZBeedRaGLC9mNP5YPXLu/ckp053RJbmHvD/Fo5sIKVyU81vivi25XuIlpO1RMJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287616; c=relaxed/simple;
	bh=mPI64MmYZoWWQXNsbHfgB7P2LGr5N2K3QKdxlYPucYw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YWkOl5bVIICqD1MKqccFt7Iixv7bOEmx4DtpEykXoo4S0ZkOW9gCTKjpnsu0WwL8AxP4fj9yfcddEgKwB6poKygobiskM1aRYR0taHycyEQVjfkFesLU5WkG/3tkfO/PqAzANAgH4MGNs74Vf9CiJIz+xUY0dKqAYWfDG1iN6NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOuP+UyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOuP+UyI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48BEFC2BCFD;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=mPI64MmYZoWWQXNsbHfgB7P2LGr5N2K3QKdxlYPucYw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BOuP+UyIDyWOJHxBNBtwskSIUUtPi+m4pptJgwmlLSIjnwMijM0hC+M44URR8xoi2
	 KaeyAaSK24JPzGIk8rXQGjKLnsTHGT1X1e49OTIhT/1fSMb1ax6HtL83sIcLDg5zSt
	 1JGiDV+hwNt/iT42c208tkqmgwgTEMIXJA7/WTJm6zbKx0TeNO2dNNSfelb258L6Vs
	 +IwUfRx1Mj0mAg640JZUvTviiYxOXR65X2dNGmPcQmU/MuYnCAmvkDLHcvSel3Y42G
	 vlF8vlmsgo9SEjLD2fP9EHV5mV9kUw9ULX90FNUqMk8SEwE8L6YwGUx6aoXvlzQFuI
	 +yeO0tJwThshA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368EAC4451C;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:27:00 -0500
Subject: [PATCH v2 07/11] dm-pcache: bound the logical key offset from
 persistent memory
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-7-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=1598;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=GP1/4GJNnNWJdMna2c7wHajzFf/3a0JDLm0ELeLq69s=;
 b=0XhksriEfsf3e91wOyEQ7BqAw66e85dX2S/LsXvGVVzRpelMQJ7wQnKWj/oPOiHVzm+S7tVDb
 A9KKsTuQBYIAxJLeaNjUZA7hnWXOJiYs/lYqgfQ5bHMGRyZeCs74zYv
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

cache_key_decode() takes a key's logical off from the cache device and
later indexes req_key_tree->subtrees[] by it in get_subtree(). An off
past the device forms a subtree pointer outside the array, which
rb_insert() writes through during replay.

Reject a key of zero length, or whose off+len (computed in 64 bits)
exceeds the device size, before it is used.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache_key.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index 2284dbc0807b..86cc9565ffc7 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -90,10 +90,19 @@ int cache_key_decode(struct pcache_cache *cache,
 			struct pcache_cache_key *key)
 {
 	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
+	u64 dev_bytes = (u64)cache->dev_size << SECTOR_SHIFT;
 
 	key->off = key_onmedia->off;
 	key->len = key_onmedia->len;
 
+	if (key_onmedia->len == 0 ||
+	    key_onmedia->len > dev_bytes ||
+	    key_onmedia->off > dev_bytes - key_onmedia->len) {
+		pcache_dev_err(pcache, "key off %llu + len %u exceeds device size\n",
+				key_onmedia->off, key_onmedia->len);
+		return -EIO;
+	}
+
 	if (!cache_seg_id_valid(cache, key_onmedia->cache_seg_id)) {
 		pcache_dev_err(pcache, "invalid cache_seg_id %u in cache key (n_segs %u)\n",
 				key_onmedia->cache_seg_id, cache->n_segs);

-- 
2.43.0


