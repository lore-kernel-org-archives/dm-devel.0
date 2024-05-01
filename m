Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A813EAC7;
	Wed,  1 May 2024 00:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522188; cv=none; b=eHEloniO3CclwhbGtxpghHDKbzjExaRnOxLtOJDdG4KlXm+PInkyNyR7L4c+GXpNYpWSQh73dY0TuJzjHM+o+HENdvH8myDqx0L2qNHa2vFp63DthZN4mHCFDVAUYGnnZcz8PGGWHohZTzLZfb+h08a4ddagrN5ujVZGe8nKb9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522188; c=relaxed/simple;
	bh=XC2bM+ZkGdHP0BQoAi8mq38gQ4IUzXpjaBjM+7WZZeI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPihnCusop0kIds+AMu1mD8vcpAfLyLPH8UYm1tewFeWmfRT/EK8Ar/dgZUSF2WeVel/9FuhFnj47mQGFixusT8F9XrkR5lyLW/342c8Ya/YmL5Kmg0Nl/5BF9jGShgdrvbgnFxNSpdQ/yyPZzFItczZfTmJ5PRpcDx/X+/r5kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrYYx+hV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrYYx+hV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD28C32789;
	Wed,  1 May 2024 00:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522188;
	bh=XC2bM+ZkGdHP0BQoAi8mq38gQ4IUzXpjaBjM+7WZZeI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YrYYx+hVmZhvUsiSKyESHEx0sB1hq4Nwzjgm1B2qTMv+2HtvgWd2wUvIwL1jxtMNR
	 JbjdV9QPxTSzWjsO3agSZt8D+cbtFBiTvwgL+lChOt8FJFQc6fIcR9n1r7WhN/MRGO
	 8xde69A0sNYdXOIQCUzEZtU1HkSEK84if6KXkUVggHDg27DN9kDJIFZeSxunCxGtpY
	 0mBd3ViZlXiYPpjPybUn3gu1zK9LDV4K7/Nps1FqD34sGpWAk8FB0ZZ0wmRcFsNl7n
	 HtmlEQMndWlpTVUrBirWvH7ZWwA5Lm0u/ui1iQaBpfj5HHUnd1640/1+erHfGILVHS
	 ys0dYgGOlrGtw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 10/14] block: Improve blk_zone_write_plug_bio_merged()
Date: Wed,  1 May 2024 09:09:31 +0900
Message-ID: <20240501000935.100534-11-dlemoal@kernel.org>
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

Improve blk_zone_write_plug_bio_merged() to check that we succefully get
a reference on the zone write plug of the merged BIO, as expected since
for a merge we already have at least one request and one BIO referencing
the zone write plug. Comments in this function are also improved to
better explain the references to the BIO zone write plug.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 5a5803ca031c..d26b5bb432d1 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -885,11 +885,16 @@ void blk_zone_write_plug_bio_merged(struct bio *bio)
 	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 
 	/*
-	 * Increase the plug reference count and advance the zone write
-	 * pointer offset.
+	 * Get a reference on the zone write plug of the target zone and advance
+	 * the zone write pointer offset. Given that this is a merge, we already
+	 * have at least one request and one BIO referencing the zone write
+	 * plug. So this should not fail.
 	 */
 	zwplug = disk_get_zone_wplug(bio->bi_bdev->bd_disk,
 				     bio->bi_iter.bi_sector);
+	if (WARN_ON_ONCE(!zwplug))
+		return;
+
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwplug->wp_offset += bio_sectors(bio);
 	spin_unlock_irqrestore(&zwplug->lock, flags);
-- 
2.44.0

