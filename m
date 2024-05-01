Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F91F10A19;
	Wed,  1 May 2024 00:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522190; cv=none; b=XRcheh6DoJAwBOiVatIrxB9r8pPP3qGKCku70HR5kiSztp/Wtr99M2pfroIyGPasvOi9xIUA3nGW+7FlWvR7oynm/iZrwIV+CpvcI5kIWw0J7i/VQJ3lwzFejS810V8Xfl0LYSeZux9YFyZUC4h+uUtoy0l3dbptQSGZHAqhybw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522190; c=relaxed/simple;
	bh=3EJwT+FRWdpdyQ6Z8AavgxjHs8UUT7vn5tXPlKnBZ6w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azc2y+AEoTRvZdBEIsvSA1hW8NKrME8iVfQ1nFVcwhybb7tz5B+RJWUv7X5ssP+Mpx99fkQPehvrG5aTFaDt2GliogEXem7XcIUhjpajT6aUs3CdkV42Z/hEYeDG68sp4B8v9s8qYVK2cEf/5RYQdUa26xUf4nIgSi6jMaNFzlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZhgX0tF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZhgX0tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B5C4AF19;
	Wed,  1 May 2024 00:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522190;
	bh=3EJwT+FRWdpdyQ6Z8AavgxjHs8UUT7vn5tXPlKnBZ6w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=AZhgX0tFaVyLGaqRLdcJne+pFqV+lu2mMvXMLWpe7o36Dho8T9DktcOYvWsA3M8Vx
	 rz/3RB/UjKZn862lQiLqjsPtQvth70LW9h8+1MbvDKTe7NiDW35XxD0w+F4BcOPVU2
	 +H+EeWOGr/NZQyXKp2oPDCpO3v/73JcMO8kW2Pccf/osQyTEH9z6sulHOyTHijPFAF
	 FFYuawRnuiw7VmbSJYt8ZqT2wOqyeycSGP71Qq/Wkz58HqEiyLbi8iYJb21CB43qYB
	 HuFboqQ14vfN7xWA4cDDzPHCI0O3qzTC7E1R2W/oowVmAmavJc3jNlICicsdA/7abv
	 ESwR8wGtEdiAQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 12/14] block: Simplify blk_zone_write_plug_bio_endio()
Date: Wed,  1 May 2024 09:09:33 +0900
Message-ID: <20240501000935.100534-13-dlemoal@kernel.org>
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

We already have the disk variable obtained from the bio when calling
disk_get_zone_wplug(). So use that variable instead of dereferencing the
bio bdev again for the disk argument of disk_get_zone_wplug().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index e590403504a6..a578d6784445 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1222,8 +1222,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 	struct blk_zone_wplug *zwplug =
-		disk_get_zone_wplug(bio->bi_bdev->bd_disk,
-				    bio->bi_iter.bi_sector);
+		disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
 	unsigned long flags;
 
 	if (WARN_ON_ONCE(!zwplug))
-- 
2.44.0

