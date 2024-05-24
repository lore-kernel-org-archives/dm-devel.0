Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53AADDC7;
	Fri, 24 May 2024 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716547618; cv=none; b=hLacI7kPNDxPv9tzvMAnfoDOSAKSjRZ3EBtt1rVAFEn1Bm131KnMjPF285H/xKH+7ubRRHi1xc34SIB6r6cEzHDPN4DqQ2vst3JvdmGJ/ZeOP3QGMjZ3OgxfwxZVZoBJyxKcF9sUvY3Kb5CY1nJMu+74MpAcq7JCtWkK/0PLXp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716547618; c=relaxed/simple;
	bh=El40fFKvSQA62aQn3lWxFdNTsiyC/RjddEVEMtvh7I4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=K3+TgbHZV38onEC9I3/dISHbQ2dTIhjv+LhpAiToJB8YMCY7pmRt9Vy4BQa8z89yl3tao8jaPaMePFjgjYJKEn+SGidNrOug9Y9/0JxAqdFcSYb9AXXscTjuXBmYp7VdYm/ZG2GeNho+6ltD8piDsGd0T3gC5Nfte6xrpGoLME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSRXLMq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSRXLMq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE9AC3277B;
	Fri, 24 May 2024 10:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716547618;
	bh=El40fFKvSQA62aQn3lWxFdNTsiyC/RjddEVEMtvh7I4=;
	h=From:To:Cc:Subject:Date:From;
	b=VSRXLMq5UsTTn2fa3tOgqf85AOP5Dy544dhMmEIKgfplepBVEoDmMlgLuqK6/TVAe
	 aPB5b0Y+SooZsTYmyjSD32o/xvcgSziKC6aGpVah9WBpWtKr6UA8bsYY8G/6UI80hT
	 WdLqks5tfx6CxkrsknrxXUatNyTNeB6wjOYm2ER34VGy9VX84jJ0Xg0tKC3ONOrAdk
	 D/2MKBtlGRyj2Nfs92EDoGS+f5y/Bq9aKYcLSciCnLptEuHfuXzOBy+/Pyf9ZyU+H5
	 Loyx3BgieOKf8oBouOUgsZAQHh2+UkM1d2it6lFwh9Q0Gr/lMABt73XpPdkh0NkBeH
	 DQkhys9GbhKwg==
From: Hannes Reinecke <hare@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCHv2] block: check for max_hw_sectors underflow
Date: Fri, 24 May 2024 12:46:51 +0200
Message-Id: <20240524104651.92506-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The logical block size need to be smaller than the max_hw_sector
setting, otherwise we can't even transfer a single LBA.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 block/blk-settings.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d2731843f2fc..030afb597183 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -104,6 +104,7 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 static int blk_validate_limits(struct queue_limits *lim)
 {
 	unsigned int max_hw_sectors;
+	unsigned int logical_block_sectors;
 
 	/*
 	 * Unless otherwise specified, default to 512 byte logical blocks and a
@@ -134,8 +135,11 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	if (WARN_ON_ONCE(lim->max_hw_sectors < PAGE_SECTORS))
 		return -EINVAL;
+	logical_block_sectors = lim->logical_block_size >> SECTOR_SHIFT;
+	if (WARN_ON_ONCE(logical_block_sectors > lim->max_hw_sectors))
+		return -EINVAL;
 	lim->max_hw_sectors = round_down(lim->max_hw_sectors,
-			lim->logical_block_size >> SECTOR_SHIFT);
+			logical_block_sectors);
 
 	/*
 	 * The actual max_sectors value is a complex beast and also takes the
@@ -153,7 +157,7 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->max_sectors = min(max_hw_sectors, BLK_DEF_MAX_SECTORS_CAP);
 	}
 	lim->max_sectors = round_down(lim->max_sectors,
-			lim->logical_block_size >> SECTOR_SHIFT);
+			logical_block_sectors);
 
 	/*
 	 * Random default for the maximum number of segments.  Driver should not
-- 
2.35.3

