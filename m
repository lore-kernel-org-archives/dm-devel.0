Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CD3143881;
	Thu, 30 May 2024 05:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717047641; cv=none; b=jME1TmsHmu4VWNsQ9kcjWLmkHXUFd8j0xjG3hWtolc679P0ZiW8BJ3VYOr26L58S0xdNK5QJ/WqXxMAuar5W35+OjRGiiGBenvgm5BKNpGOPEissABhXeVtDQ68pLb1gNjTYNq+/J300uTzk775mMJKfH4B5qqD2LXArwGz6Pho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717047641; c=relaxed/simple;
	bh=zq1flJzo4D0ydTL1aUlxX2XBynuRm4rgunyI1ebwP08=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNa4UGzuRPqys4VPR1vxNiMrktVGiEVLhNOEu/MnmhZxwZ4q+Qdkm1W28/FGF6UClgmsc61CujCKsmrFyhfqt26ohq+pSUSHhEG4+AgTQ8IZZi6MTZWpSqn/Eu4cSUDlGzLQ5A5AhxoYT70gH+BS+SsIn2obtKmWU3xm7/bxiCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLp1E3Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLp1E3Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27B3C32782;
	Thu, 30 May 2024 05:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717047640;
	bh=zq1flJzo4D0ydTL1aUlxX2XBynuRm4rgunyI1ebwP08=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WLp1E3EuhJDAd7CakbVSPLFrQkRvLxHC+AELe/GqRIX4v0etrO3Hl+mSXrpjftjIc
	 lHDr7fbkmB9nHc+jaHv7N0AdwjHBwBJ2UtNlyWq/+Gt+NT8FO13F2Fyf1jESZqAODq
	 6Os1mIPolaUd72ojF65lAaPrqXq51s3shGqPDp/EZKGs9uND3FBj9F/9tNpSZoGc+c
	 LxdjkaJOJoKOTq1etStk7IWwoLoKWfVqkFPPPlkzAAH43VjXzPQ7MO9tvKHpE0nUke
	 XF/dwfqrXqkgWoqy2p4CfYku/nj4mtFyp3rqjkLBgj/uwqsomyf+ag51uT+n2uoZLE
	 HHud5JYTVe1Zg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] null_blk: Do not allow runt zone with zone capacity smaller then zone size
Date: Thu, 30 May 2024 14:40:32 +0900
Message-ID: <20240530054035.491497-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240530054035.491497-1-dlemoal@kernel.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A zoned device with a smaller last zone together with a zone capacity
smaller than the zone size does make any sense as that does not
correspond to any possible setup for a real device:
1) For ZNS and zoned UFS devices, all zones are always the same size.
2) For SMR HDDs, all zones always have the same capacity.
In other words, if we have a smaller last runt zone, then this zone
capacity should always be equal to the zone size.

Add a check in null_init_zoned_dev() to prevent a configuration to have
both a smaller zone size and a zone capacity smaller than the zone size.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 79c8e5e99f7f..f118d304f310 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -74,6 +74,17 @@ int null_init_zoned_dev(struct nullb_device *dev,
 		return -EINVAL;
 	}
 
+	/*
+	 * If a smaller zone capacity was requested, do not allow a smaller last
+	 * zone at the same time as such zone configuration does not correspond
+	 * to any real zoned device.
+	 */
+	if (dev->zone_capacity != dev->zone_size &&
+	    dev->size & (dev->zone_size - 1)) {
+		pr_err("A smaller last zone is not allowed with zone capacity smaller than zone size.\n");
+		return -EINVAL;
+	}
+
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
-- 
2.45.1

