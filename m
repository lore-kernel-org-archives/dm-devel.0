Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F513F413D;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287615; cv=none; b=H4cTAoFXjMFStr7wsRcNlKW39a0PtyB4D8Ztz13ipet3eWBeR/hiS5IcMWbe6Xxon/NQx0jmv8doDJsO0o7bZMcsMrOcrpbV34atSVVPzdv57I1Z6xmPDHnS9sSGUDNWiKstYcsEPdUVTRD6mePQU+CJ1/QiKPgO0u0DSDmMy18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287615; c=relaxed/simple;
	bh=ZJBA5lMyaRfZ5DRdvY28maqTnwsC+q/oQgWf5cSx6EE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=keuilez8hstVWCA7dKSHyfZsNGkvlhBkagYyfV6oce1fK0KHqZZieRo3OSKBunATmSjWeBFj0I9q8ApusrESkWp0udUPOYdzmqz26IOPK68drU+Zx3/c1CWPW+NwwC+Z7EtzjksBT7cITyju1NGM2g7h7qJG+qGZEfYI6JFBPvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uq/H1l4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uq/H1l4D"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2219BC2BCF6;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=ZJBA5lMyaRfZ5DRdvY28maqTnwsC+q/oQgWf5cSx6EE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uq/H1l4D6pDQDn61RzQ5wvaZ0w8FOrAsT3aS+A+BpnhatEmYmn+Jnz62SREI17k/Q
	 NjE848KS4iIN9Y+xZzGWFYEeWsNPR5FHpt2I2jV8y1rPD3pJ7uuUMcaWid+uvoCMR5
	 OEm7H7B51jJvlyOJiEhYMLEYWOHN6rOp0OJdM4S8es7MwbZggaPiMmE5LTsJSUR4aV
	 f4oaSK1T+c8qsnO/3ukA+arDwjTPOQnvTtn3dCvptPQCDC5pfcaLq0PbRjWBuyfW9Z
	 s/SVIF6SOr1/TGf8kkz6FtHPdoR2Xa0A3pLbg+uVjrJxgb674n4u5xBl1NEN+CmkVj
	 lYX4ExJBQcI2Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD3EC4451F;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:26:57 -0500
Subject: [PATCH v2 04/11] dm-pcache: bound the persisted tail-position
 offset
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-4-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=1129;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=hN9K2tznX8h1QG7GfDCqM9oGo/1YYUnmVCUIvgXpICk=;
 b=c2HibsNGq9PxA8UzqkT0stULoj1gCQtVqGCnfhMPLoa9x4nKTbuPlkhkC+6Y4Dl+KKaXJXibs
 WAOkYPB93BED92xic8EJWQN1a3dkwaVS6AtP8IhcgtK6I33AZgxv6IW
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

cache_pos_decode() takes the persisted key_tail and dirty_tail seg_off from
the cache device and addresses within the segment with it. A seg_off at or
past the segment data_size, controllable by whoever supplies the device
(CAP_SYS_ADMIN), reads past the segment data.

Reject a decoded seg_off that is not below the segment data_size.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index e4784578b9af..a94eadb7affd 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -122,6 +122,10 @@ int cache_pos_decode(struct pcache_cache *cache,
 		return -EIO;
 
 	pos->cache_seg = &cache->segments[latest.cache_seg_id];
+
+	if (latest.seg_off >= pos->cache_seg->segment.data_size)
+		return -EIO;
+
 	pos->seg_off = latest.seg_off;
 	*seq = latest.header.seq;
 	*index = (latest_addr - pos_onmedia);

-- 
2.43.0


