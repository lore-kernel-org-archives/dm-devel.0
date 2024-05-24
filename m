Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA89128366;
	Fri, 24 May 2024 06:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716531695; cv=none; b=h713Vc6Qe18hLb4Z6M8zsjiq06IXrTeEb4z9lup1pkvv83sVzbk6ofBY8/596uVZzSdYaRTelK/85TVpElF4ybaI6/f8ypsXtCL2QqHXceVbrneafMvEXQHtDwk9uPe//Gebbo0nA/w4BtLXv49+fnUJKeV/slk22ATlMKeMJdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716531695; c=relaxed/simple;
	bh=BEf2OWBifTIQDQmlAhuZpF8jqHJDTmoMduSAppR0FUk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Bv+73fYcfrEOx4U4rdGLxi/efc8x6dyuVgILAowMJMAjyUo2ERHtG1V8tQ4/PwkC+7gmnb452KEUgZk/eMpfSNHQKz0xmOnVQYiKMVYJsNM+GYOZK58XWwTLPbMoAbTMfwnHf2c8GKAuD2ydFK18DZY4F1DdoIdmPY576wOSvAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUJlwPc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUJlwPc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF09C2BBFC;
	Fri, 24 May 2024 06:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716531695;
	bh=BEf2OWBifTIQDQmlAhuZpF8jqHJDTmoMduSAppR0FUk=;
	h=From:To:Cc:Subject:Date:From;
	b=CUJlwPc3l654HKcPdrBWwJFT6sktLzH0q7LyiznZyH7jfA+d70fJXPRE+DDZwlJDm
	 NRGbFEreDC6wLRCNFiVHtFgJ7ES4cPMD0zqMJipTpcmya+IGzNiypwb3LmO8CbxbC7
	 5xYEWh+fpHGCCsyBMuGuG2ryIwQydXb7q+ojjYCtlGLf1jfHtdm1d8tuPw387I5ylc
	 J/5dxOyv/kNJxycz4SqIw/8SS2Dpc8ML9Sc/fC3NeqCP1B4cEigWSsGjfYN5LJEg4Q
	 fyMykgchDl8jzlnwk31EWGjQ+aghswy91wpWsvsRwVS05eU8w1vpn39++rGkqvlBGE
	 2fusgrFMvnQTw==
From: Hannes Reinecke <hare@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH] block: blk_set_stacking_limits() doesn't validate
Date: Fri, 24 May 2024 08:21:19 +0200
Message-Id: <20240524062119.143788-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

blk_validate_zoned_limits() checks whether any of the zoned limits
are set for non-zoned limits. As blk_set_stacking_limits() sets
max_zone_append_sectors() it'll fail to validate.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 block/blk-settings.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d2731843f2fc..524cf597b2e9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -50,7 +50,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_sectors = UINT_MAX;
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
-	lim->max_zone_append_sectors = UINT_MAX;
 	lim->max_user_discard_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
-- 
2.35.3

