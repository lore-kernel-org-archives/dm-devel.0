Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B488B3F44F0;
	Fri, 17 Jul 2026 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784287616; cv=none; b=eEFoBo3eK907CyeQH1+KzgWZWyRQV6VDNFVlFbJ7edQfD1UaDTLzM4FxS9BSsLGMqwSYZZJcZfTD26zw1CBRER96GTY/AARI0VaRT462Clv/nt83+qTzk/AytnRwe3Bb1VOGgrDH8mut/PV71oTe7B4x7hVlPyGd02sNvTpG3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784287616; c=relaxed/simple;
	bh=toOq+vx1LshhMROiRD+qXw+ukIgvO0pG1BBImQ4T9qg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c4kLuB96+Yn+PZ4lhqbKmwdfRoJBL95iw1/4yA+7D+fGpTFqbabodHrzTKZqty9OpakAYpsi8HpJCb1D6TSN59CuyDq3LdEuk3QDs57afxYncbghT8C6K2fnVa02iE+rdzg6x3weFg6k4hg3jC83IMR3zrIeFbIFt2TudtMocXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBt2NZLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBt2NZLr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62CADC2BD01;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784287615;
	bh=toOq+vx1LshhMROiRD+qXw+ukIgvO0pG1BBImQ4T9qg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DBt2NZLriGsjLNSWX01WUAskzCUgDDsxhuJHvjRYb5yh1x6UllowNYFe5KRt/rVxT
	 +iA3dfsTcYNSD/057R1Y0pSeJMp12lcDf6AzRRN2ZtbUOJSCRXckHdTYrzYIHK+hiv
	 GymfTwR8V0YCXG7Qu6vpMfyPLLHZ0blvBabAfHVyHm3GJ2aaUraqejRLPdbvLGf1tE
	 YeiDWcrc0Ee4OzwZD/zRQ+PuReTcp/5/aGaDWpaYcFd+dwe26FJHVfnPpbf9m7uOrX
	 vxZH1ExAGglPW0mXHCYp5b62lHsZagfgQwTQWXHdybXEnZ7+UbpProMjOc6iRcogpi
	 tEyNQyGhBfhuw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51489C44520;
	Fri, 17 Jul 2026 11:26:55 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 17 Jul 2026 06:27:02 -0500
Subject: [PATCH v2 09/11] dm-pcache: validate on-media seg_num against the
 cache device size
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-disp-4c0a0039-v2-9-19227d6e313c@proton.me>
References: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
In-Reply-To: <20260717-b4-disp-4c0a0039-v2-0-19227d6e313c@proton.me>
To: Zheng Gu <cengku@gmail.com>, Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784287613; l=2643;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=GthnvJEXiCUPMv2Rfmb/8dJm5Xyaa9i+Wnb6pzB7iBk=;
 b=HVS2YD+agpjZ6SfKOPiAwIPHvjqy//dbl2WTXDLjTpn8J4iYH8AxlVB48mgszmjljCmH1BYmj
 scXSqd9+hSrA5vYD7BZnK11/pd9xneoZhnmvPdhPViJBvDZ9ryhEm1l
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

seg_num is read from the crc32c-only superblock, so whoever supplies the
cache device on a table load (CAP_SYS_ADMIN) controls it. It sizes
cache->segments[] and is the value every later on-media segment id is
bounded against, yet it is never checked against the device. Because
cache_dev->mapping is the direct map of the pmem, CACHE_DEV_SEGMENT() for
a segment id past the device resolves to ordinary kernel memory beyond
the mapping; a new-cache init reaching such an id has cache_seg_init() ->
cache_dev_zero_range() memset() 12 KiB over that memory -- an
out-of-bounds write into the kernel heap at table load. A zero seg_num
makes the segment allocations ZERO_SIZE_PTR.

Reject a seg_num that is zero, larger than the device can hold, or larger
than PCACHE_CACHE_SEGS_MAX before it is used.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/dm-pcache/cache_dev.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_dev.c b/drivers/md/dm-pcache/cache_dev.c
index ece689e6ce59..f0259353ee39 100644
--- a/drivers/md/dm-pcache/cache_dev.c
+++ b/drivers/md/dm-pcache/cache_dev.c
@@ -242,6 +242,8 @@ int cache_dev_start(struct dm_pcache *pcache)
 	struct pcache_cache_dev *cache_dev = &pcache->cache_dev;
 	struct pcache_sb sb;
 	bool format = false;
+	u32 seg_num;
+	u64 max_segs;
 	int ret;
 
 	mutex_init(&cache_dev->seg_lock);
@@ -269,7 +271,25 @@ int cache_dev_start(struct dm_pcache *pcache)
 		goto dax_release;
 
 	cache_dev->sb_flags = le32_to_cpu(sb.flags);
-	ret = cache_dev_init(cache_dev, le32_to_cpu(sb.seg_num));
+
+	/*
+	 * seg_num is read from the crc32c-only superblock, so whoever supplies
+	 * the cache device controls it. It is the ceiling every later on-media
+	 * segment id is validated against, so bound it against what the device
+	 * physically holds before it is trusted, or a forged seg_num lets a
+	 * segment id address past the DAX mapping.
+	 */
+	seg_num = le32_to_cpu(sb.seg_num);
+	max_segs = (bdev_nr_bytes(cache_dev->dm_dev->bdev) - PCACHE_SEGMENTS_OFF) /
+		   PCACHE_SEG_SIZE;
+	if (seg_num == 0 || seg_num > max_segs || seg_num > PCACHE_CACHE_SEGS_MAX) {
+		pcache_dev_err(pcache, "invalid seg_num %u from cache device (device holds %llu, max %u)\n",
+			       seg_num, max_segs, (u32)PCACHE_CACHE_SEGS_MAX);
+		ret = -EIO;
+		goto dax_release;
+	}
+
+	ret = cache_dev_init(cache_dev, seg_num);
 	if (ret)
 		goto dax_release;
 

-- 
2.43.0


