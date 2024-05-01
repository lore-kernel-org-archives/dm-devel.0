Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B421513ADA;
	Wed,  1 May 2024 00:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522191; cv=none; b=KI/CxN0cYGbp45RRTpU/8hCOoFR6vUWhPyyZbBUbZDin7ahY0FhMgUciIfOHrCqMcxPTHIfySB2m4APe1zmeqcqXukBLfZJLCMkHuHBTFSa3yvtlU2/C9r0li/dYu30ZUfu1bdA22czIPLWEA4VJwZfJh/SRx9JidyMFr/Y+BJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522191; c=relaxed/simple;
	bh=GPtKqZiD9+8HwuaGBRXWPns1vmljSTWBxFLY5KfOtkU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxM6IYcEtNLSa81UZItrGsNuJuutK9LfiS2LHMDn4LXszOzeutdw4HyK30w/TIgAnr+3F19CWs686rDPRsztqsbLt6xu4QsFFCF09bwOrPanDS0GMW35ZqqN5XIlWD2dJ+cqG57FA6b7/rbq/WEf4tRyC1G8vW+lRLMnVlX1cMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJKn4zmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJKn4zmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1ACC32789;
	Wed,  1 May 2024 00:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522191;
	bh=GPtKqZiD9+8HwuaGBRXWPns1vmljSTWBxFLY5KfOtkU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MJKn4zmHT14t1rXzNQ6ydjmPmTRgbNQm3zKKJs/drtTI/FSQrVrEncGs1ae7+Q/vT
	 IeBXfF8COaO+FfratDoYA1Kefq767pZoOdPEyu/eGrkUbDLckt2H1devR8R3ptzR5G
	 itfZDMiwVQZ4CVdtFe2Zlzb8fkmWE4rhpjxLk6diYrT+1Pua3l7vFEplzP55wz3Awx
	 xa4IxvQIHTizQJPoZ8gpJuia0+vgv4aaW8o9OnNh+z2zAut2WRlf0dCl4X4oHwHeL8
	 BqMsP1A7RSeuXLB4ynovAE9xZzkSzKs7naS6S/6l9X+JfG1II1wzPMVdu/CvAHbreM
	 IY6j89qjA+VlA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 13/14] block: Simplify zone write plug BIO abort
Date: Wed,  1 May 2024 09:09:34 +0900
Message-ID: <20240501000935.100534-14-dlemoal@kernel.org>
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

When BIOs plugged in a zone write plug are aborted,
blk_zone_wplug_bio_io_error() clears the BIO BIO_ZONE_WRITE_PLUGGING
flag so that bio_io_error(bio) does not end up calling
blk_zone_write_plug_bio_endio() and we thus need to manually drop the
reference on the zone write plug held by the aborted BIO.

Move the call to disk_put_zone_wplug() that is alwasy following the call
to blk_zone_wplug_bio_io_error() inside that function to simplify the
code.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a578d6784445..9026e83e0746 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -634,12 +634,14 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
 	return zwplug;
 }
 
-static inline void blk_zone_wplug_bio_io_error(struct bio *bio)
+static inline void blk_zone_wplug_bio_io_error(struct blk_zone_wplug *zwplug,
+					       struct bio *bio)
 {
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct request_queue *q = zwplug->disk->queue;
 
 	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 	bio_io_error(bio);
+	disk_put_zone_wplug(zwplug);
 	blk_queue_exit(q);
 }
 
@@ -650,10 +652,8 @@ static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
 {
 	struct bio *bio;
 
-	while ((bio = bio_list_pop(&zwplug->bio_list))) {
-		blk_zone_wplug_bio_io_error(bio);
-		disk_put_zone_wplug(zwplug);
-	}
+	while ((bio = bio_list_pop(&zwplug->bio_list)))
+		blk_zone_wplug_bio_io_error(zwplug, bio);
 }
 
 /*
@@ -673,8 +673,7 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
 		if (wp_offset >= zone_capacity ||
 		    (bio_op(bio) != REQ_OP_ZONE_APPEND &&
 		     bio_offset_from_zone_start(bio) != wp_offset)) {
-			blk_zone_wplug_bio_io_error(bio);
-			disk_put_zone_wplug(zwplug);
+			blk_zone_wplug_bio_io_error(zwplug, bio);
 			continue;
 		}
 
-- 
2.44.0

