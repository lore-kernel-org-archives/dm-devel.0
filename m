Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E54085636;
	Wed,  1 May 2024 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561759; cv=none; b=sRD38z1hlP+P/Fej2XgDWWMiUyBSR7D07hwLg1dxA1mtVLke688fLohiF9tOFodFR/uAZueteOiw2MRVTG21K7FoFuoL0AOpwTh9efH0V+f7TDe0eqSBnSl1PW5NNZnqisoBIPhiThzlIA/2vgT5Qndj8pVSAicm6UjRH6tkXic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561759; c=relaxed/simple;
	bh=F9wHY06hqfCHb1rrEjbYbLMUrUQ6FGujt9xlHLsvE2Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsYUunNBuy2Lq4epqO/N/9NSaX/HjyNL5klVx5u70YrrsAKdZb6DxE+TVMMoojcIgrXmBDu6MiIgnY1zIrt7C+ItGmMq44gBCv/nMx4G9sCHFfnVFdof6k/eqornhsv7ooyY8Ntlv3nnoE5chq3sWJFhlX8p1hAtZ9u10Yjc+6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ArX3Nvv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ArX3Nvv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76FCC4AF14;
	Wed,  1 May 2024 11:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561758;
	bh=F9wHY06hqfCHb1rrEjbYbLMUrUQ6FGujt9xlHLsvE2Q=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ArX3Nvv96mTdWfmDivLcy0G6fpEWb26FFhSuoujsg6KUuRliziKwkj4X/iNSN8NL2
	 kvDxt5r211EA8OKxh0hH/m1YsLtAujmkSTk2lmPPkGmV+YbcwqTxplzjg9u+plLFlK
	 iuxrHzE2dSDBQf3R+KaLf4j0m/pqlSE4eSw1dR9/ZB3kBDBEiWK/Q0xBHxuHWXkKTJ
	 ciu9yUKzn8HVNyINC20RZzLSVRSG4w8udnbtDtpAdQAyuf9L/MKLjHG8WTVpmMo+Z3
	 4eTFVC91EDSX/fH/BRXJEGnHUCw7TXizazUC25vdO0JtgBHcyN8GAGZ5yvKcu8n+pa
	 9Pbz7wJKmv50w==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 08/14] block: Fix flush request sector restore
Date: Wed,  1 May 2024 20:09:01 +0900
Message-ID: <20240501110907.96950-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501110907.96950-1-dlemoal@kernel.org>
References: <20240501110907.96950-1-dlemoal@kernel.org>
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

