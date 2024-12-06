Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0933514830F;
	Fri,  6 Dec 2024 01:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733449989; cv=none; b=Qf7DYSsImq5azMntzpQYUJpFPrwR/kHYhb01VjZLbYXcCrdxVFDyzcoL1dWK17OeoAP7cPSLb7pDl7p6u8dVEzIZvfpLCrDtJDhKz3AQCnP0Zuqd3r/drzcD/SQ5gyYLl9hMN/J59ey3h6Wx0EgK28QCBUchDLxvFeGkdP8C9eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733449989; c=relaxed/simple;
	bh=tvwEJa+HuxJwJKXdyVG4h7yXxY+ifQcs5H+f/smRLtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IziFpVmonDdT1AFBnMzK5m2AoH/lNX1majYFUi/Ti7wL9sIBL4pXwwR0S/Zb40K288ml8hSw1SbJXuvt9+gVKFBMUQgi8IYtCmp6QYaPvtN/oiHsTNaPZNGmcEAQmrBr9CDFwO9WJaO3kIAhoTHToixN2UPHaDRMa4KACtMY/CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TaQK8+ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TaQK8+ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450DDC4CEDD;
	Fri,  6 Dec 2024 01:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733449988;
	bh=tvwEJa+HuxJwJKXdyVG4h7yXxY+ifQcs5H+f/smRLtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaQK8+ffr2Q3hupSDiPEkGNaAoTQJw4jf1HA1oOwJ2C4x/51esGggfaXK6UMQu/S5
	 tut4oSqePD4z0NkN6x2Y8TblSgsqsQ6NU436cgoaI831FHfmZaFyO+vk7szWufQJ8N
	 1DfUU11S+6bi7GJRPHeNXMLx43PYNW/xC7dlq/xf98oxJ1PTUTQZl1/0UVQF0Oemne
	 oZkLz+WRRw2lUL3yPvg+vm3lmiaKOlpX3ILtjty8bwacg0io3mEl4rvRet+K3Oar0W
	 PpPJErOmC7Cs/9hxTEYDadv5iXZTzqGLg1pDWWFhifWEgTSZclIyw7Ts7pvvfNwNGO
	 jTfY1h55xnA0Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/4] block: Ignore REQ_NOWAIT for zone reset and zone finish operations
Date: Fri,  6 Dec 2024 10:52:38 +0900
Message-ID: <20241206015240.6862-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206015240.6862-1-dlemoal@kernel.org>
References: <20241206015240.6862-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are currently any issuer of REQ_OP_ZONE_RESET and
REQ_OP_ZONE_FINISH operations that set REQ_NOWAIT. However, as we cannot
handle this flag correctly due to the potential request allocation
failure that may happen in blk_mq_submit_bio() after blk_zone_plug_bio()
has handled the zone write plug write pointer updates for the targeted
zones, modify blk_zone_wplug_handle_reset_or_finish() to warn if this
flag is set and ignore it.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7982b9494d63..ee9c67121c6c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -707,6 +707,15 @@ static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
 		return true;
 	}
 
+	/*
+	 * No-wait reset or finish BIOs do not make much sense as the callers
+	 * issue these as blocking operations in most cases. To avoid issues
+	 * the BIO execution potentially failing with BLK_STS_AGAIN, warn about
+	 * REQ_NOWAIT being set and ignore that flag.
+	 */
+	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT))
+		bio->bi_opf &= ~REQ_NOWAIT;
+
 	/*
 	 * If we have a zone write plug, set its write pointer offset to 0
 	 * (reset case) or to the zone size (finish case). This will abort all
-- 
2.47.0

