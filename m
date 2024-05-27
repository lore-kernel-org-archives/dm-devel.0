Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A06C22064;
	Mon, 27 May 2024 08:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716797084; cv=none; b=n0eTnYQoUxp2kCKexKD1Pg77pWXYlcxcAgeT1iLrkIX4cDUXEMrIWvwzJWkPTGMZjxp1aTHo/5W2ZZRX4nwM06L8Uo+ts4f6OPlaIGMwEEmaCkwH6LCNO71dTo1Euwc3rzDI7sGLmCQZXiaIiWr198kFE01KeS8hcAq2SjB4g1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716797084; c=relaxed/simple;
	bh=jJb0qV+yVo0T50ZIbb1/KCaU079vCvkA/B8vzd4PZEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6RyKWpdYX3IBPPgxWDLQRA9nnju7IkarwLboUY8fvLKoztuJFmq14BauI+xcnDsyUq5t7sInYoJD9CoVOVBE3ahH/npErpg6D2kk7fOM/s36EM3PVxUfoTpS/qj0WkEkPz2rG7qXuzpn3ZYDEfq+7FEcj97FqH1TX5GXws9rig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LUPhVlxZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LUPhVlxZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mgE9BnxU8T58RflXXWmwBrZKZXCTN0gf1+ADme25Lc0=; b=LUPhVlxZIgQxnwlOonV+t84Ekd
	xwZLYZ4Hy/xUQJcq/DePNzkYJNXqYsoJyNvuDt0Ub0cKtwLEBpgCBofDaO/GLq48xX8OWfFahKZci
	ty1DjFA2uS1u2RSgGgQRvA/Cc4a8TFfDBVz/timMis/QHBQPWpEPi5zYrRJXFB76XqegU+RGB3Hip
	rhXTod7WJgYNZGymjk88K+gXwEkIGXHf6ilNiRRTFa2m+QdLVotHvDnKCmIGHijAotN1LZJnh9HiO
	XAhzgrBixMAEb8pX+Vkqawvy4Jj1ckIxtQYIt5Yos4qD7jzLcH/4Z+my5apg9qZiyyQS/kku0Qfg9
	3i7MSv1A==;
Received: from 2a02-8389-2341-5b80-3177-e4c1-2108-f294.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3177:e4c1:2108:f294] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBVLV-0000000EAhj-2LCo;
	Mon, 27 May 2024 08:04:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH 1/3] dm: move setting zoned_enabled to dm_table_set_restrictions
Date: Mon, 27 May 2024 10:04:24 +0200
Message-ID: <20240527080435.1029612-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240527080435.1029612-1-hch@lst.de>
References: <20240527080435.1029612-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Keep it together with the rest of the zoned code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c | 3 ---
 drivers/md/dm-zone.c  | 8 +++++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index cc66a27c363a65..e291b78b307b13 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2040,9 +2040,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		r = dm_set_zones_restrictions(t, q);
 		if (r)
 			return r;
-		if (blk_queue_is_zoned(q) &&
-		    !static_key_enabled(&zoned_enabled.key))
-			static_branch_enable(&zoned_enabled);
 	}
 
 	dm_update_crypto_profile(q, t);
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 8e6bcb0d786a1a..3103360ce7f040 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -287,7 +287,13 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
 		       queue_emulates_zone_append(q) ? "emulated" : "native");
 	}
 
-	return dm_revalidate_zones(md, t);
+	ret = dm_revalidate_zones(md, t);
+	if (ret < 0)
+		return ret;
+
+	if (!static_key_enabled(&zoned_enabled.key))
+		static_branch_enable(&zoned_enabled);
+	return 0;
 }
 
 /*
-- 
2.43.0

