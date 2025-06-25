Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6722D1F099A;
	Wed, 25 Jun 2025 06:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750831276; cv=none; b=LmUdRKMnN2YtZDSfRpPxkJPTguTSdT9uUc/c/dUI5bTty1b1nHFPyYOorEUY/ukPqQO2cPsWSMqyRL2og/vgk5HubHjWxtoRYnhNRmJgcaJIjddiQHniSVCs0q4NExM0A3XtNs76nceMHUtzKA8lSTt0j/tT0rk6RIb8t+pAWRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750831276; c=relaxed/simple;
	bh=vD1cVnNdJh2PrIEVgUDoGwZ9nquNk/4+wpY5bDJISlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYEBV9C/yaF5TvMuhaSBeqIginyGRB0RjfQEaH3Svb5Ra2HbRZMw44EtE/YGFLJPvVFkJwS4c90WtmpJTUcQL9ELt1CgoTVyq5i20SfBqsKll8ehFIqAvMYcQ02b0ekYlrJ5mQL5hpCzotYo64EqkHNqxGwcZuYyWbWRIVrqxps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CQtzcjAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CQtzcjAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1FDC4CEEE;
	Wed, 25 Jun 2025 06:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750831274;
	bh=vD1cVnNdJh2PrIEVgUDoGwZ9nquNk/4+wpY5bDJISlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQtzcjAnQHkBpzkFeAt3ulh2bZpc7+nlvM3hT1pNCmdW8lxxojZgANmZva0CAwsyy
	 KdmvStzRcm1QAxSm2RrvcNJPwVDpxVId30BLS6UDUhep2QKDNboJN5aKEKGYoXHuL6
	 A3RceT/bnxIz2rHJJVzJdOruREozKWTBCWK7FEEPxFzHUrgfbw564Mpag82qjTDSy1
	 DQAX8iUc8//3EQTLJcFeoEjuomtVDHsp1jPP/oOX2bgmHmteEm3SENRYPO29KUKbo6
	 3fUYL+UAyfkNmmuRrYuukpDr2Lsx/b0Yse1Fb9zI7t5S0CgQxw7izFU5ujc00++2WR
	 EYPS5aPunsDAQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 1/4] block: Introduce bio_needs_zone_write_plugging()
Date: Wed, 25 Jun 2025 14:59:05 +0900
Message-ID: <20250625055908.456235-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250625055908.456235-1-dlemoal@kernel.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for fixing device mapper zone write handling, introduce
the helper function bio_needs_zone_write_plugging() to test if a BIO
requires handling through zone write plugging. This function returns
true for any write operation to a zoned block device. For zone append
opertions, true is returned only if the device requires zone append
emulation with regular writes.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |  9 +++++++++
 2 files changed, 49 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 55e64ca869d7..9d38b94cad0d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1129,6 +1129,46 @@ static void blk_zone_wplug_handle_native_zone_append(struct bio *bio)
 	disk_put_zone_wplug(zwplug);
 }
 
+/**
+ * bio_needs_zone_write_plugging - Check if a BIO needs to be handled with zone
+ *				   write plugging
+ * @bio: The BIO being submitted
+ *
+ * Return true whenever @bio execution needs to be handled through zone
+ * write plugging. Return false otherwise.
+ */
+bool bio_needs_zone_write_plugging(struct bio *bio)
+{
+	enum req_op op = bio_op(bio);
+
+	if (!bdev_is_zoned(bio->bi_bdev) || !op_is_write(op))
+		return false;
+
+	/* Already handled ? */
+	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
+		return false;
+
+	/* Ignore empty flush */
+	if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
+		return false;
+
+	/*
+	 * Regular writes and write zeroes need to be handled through zone
+	 * write plugging. Zone append operations only need zone write plugging
+	 * if they are emulated.
+	 */
+	switch (op) {
+	case REQ_OP_ZONE_APPEND:
+		return bdev_emulates_zone_append(bio->bi_bdev);
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_ZEROES:
+		return true;
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL_GPL(bio_needs_zone_write_plugging);
+
 /**
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c2b3ddea8b6d..d455057bfaa3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -848,6 +848,9 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return disk->nr_zones;
 }
+
+bool bio_needs_zone_write_plugging(struct bio *bio);
+
 bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
 
 /**
@@ -877,6 +880,12 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return 0;
 }
+
+static inline bool bio_needs_zone_write_plugging(struct bio *bio)
+{
+	return false;
+}
+
 static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 {
 	return false;
-- 
2.49.0

