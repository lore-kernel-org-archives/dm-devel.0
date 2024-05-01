Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C04C8CE;
	Wed,  1 May 2024 00:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522186; cv=none; b=T77ixYZM+aghIt+YgdbifqseTN/payiLEralf88gAKRdDcWkKdyMrsVl1fNVQaaWcYY1H0S5mI/vQH2jGZpnuaszNa3bqMu3Z+roGYj6vdfJq44k4T38sc2yq4gAgbd9JJZ++z86Ry6gwBIB5Y1c4GO2YxAyQPbR4Dwwmy4U6gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522186; c=relaxed/simple;
	bh=F9wHY06hqfCHb1rrEjbYbLMUrUQ6FGujt9xlHLsvE2Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dW1M33jLjOwguXuwdV9pH1NU7KpM7Lyb+6ava9Ie47kLGceU6rs8vXHEI0pB40iyUW4lR6WhuX0HE/3D+w/Tpc8Db/qCDCG/1tjjn0eURNDPRQtSZDt3QZI6RLFwYFkdsKv/LRsrWDzbHoYytV6xgBBk0tqjtb7FO1HQoEdU+Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HeAJvzZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HeAJvzZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361A5C4AF1A;
	Wed,  1 May 2024 00:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522185;
	bh=F9wHY06hqfCHb1rrEjbYbLMUrUQ6FGujt9xlHLsvE2Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HeAJvzZWG8/wWBF7TkW6X1LPWL2zq0iWl+j4UE4vIm7J0zHHmnFtBiyYlrM2UEERp
	 lFl0OffmMBthPOig16QaomVeXOa0PL5NEMSdHcK/0VClPvjoZdpCy5+XVyb85IcoP1
	 iOt/30yeYhnkLm7fESKBj4YO+hmqe8YIi9lRYMtIbf4lQc2aeAygngbBusLWl0skwW
	 X9jhHBHACecNDJclJYoJaPOc7wduvuChws9anxv2zfbTAMF/KdsoJvm6jb4+sLVnk0
	 d/zjD/M3+philoDrL0w1jc8cHEt1eekogiIy6Sp+ENGs9g7DTfkLMal0+zz4r0zMh9
	 sHDiPqwyRRDEw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 08/14] block: Fix flush request sector restore
Date: Wed,  1 May 2024 09:09:29 +0900
Message-ID: <20240501000935.100534-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501000935.100534-1-dlemoal@kernel.org>
References: <20240501000935.100534-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure that a request bio is not NULL before trying to restore the
request start sector.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Fixes: 6f8fd758de63 ("block: Restore sector of flush requests")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-flush.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 2f58ae018464..c17cf8ed8113 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,7 +130,8 @@ static void blk_flush_restore_request(struct request *rq)
 	 * original @rq->bio.  Restore it.
 	 */
 	rq->bio = rq->biotail;
-	rq->__sector = rq->bio->bi_iter.bi_sector;
+	if (rq->bio)
+		rq->__sector = rq->bio->bi_iter.bi_sector;
 
 	/* make @rq a normal request */
 	rq->rq_flags &= ~RQF_FLUSH_SEQ;
-- 
2.44.0

