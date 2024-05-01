Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C806248CE0;
	Wed,  1 May 2024 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561764; cv=none; b=C6tGmsgsnvpXxl6a67xu8Uzd0BO5APcq8VDqV9DPuiQvor2LoFP9k+CPt6ZltMBZXXn4MhCUypYA53dqj2IRJ9KxCROBMRtmPvgzrjeCAj3XAPCTNXGhNzbqpkYIbngWGvGSKNPVmB4OLJD/UMR4liyLd5HdXxhyPjXS8PYTm94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561764; c=relaxed/simple;
	bh=27PB5f7AhgKyTW6mOdWAwqEITdKwhAB/CvgOhVpWLjQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHRHSx4UpQ2V1HpFx41zvC/dHxGDzy8aSAA3XUukcACOtvS1NSRtddbMHiheRNdj7gi9LfaYScbanbu8y57HuBkB1d1Z5HumTOhNNdOMwyA917xusWcF2TctuJUlLNir1aB5cNPPDTGlFORn9eaoYhlAY6QHVNLAG31xvKbSGJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kz5dd4kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kz5dd4kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E0EC113CC;
	Wed,  1 May 2024 11:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561764;
	bh=27PB5f7AhgKyTW6mOdWAwqEITdKwhAB/CvgOhVpWLjQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kz5dd4kQA/9cLF9Wlru2tmY4JGf/WPBwBoPliuZOBQ1vyoxhp1mSgwa1LHh97CgPY
	 bUE3RsM7KXzXKa85MszjIVo94kc3wXE5sLlljmdIOYMBcQLNhdHD2zpnxVXSyJjeMV
	 wGOSOr0qUXQK1xNLxK07ZguD3aDZEi4ch5zB6dcgqiI419k2qWf2eZjWbWHKvTtDGW
	 qGx7ug/EbLeLsGnFJOSXyO1hmdBYoDdLFTv9ZuOacLP3atekUB9iy6cPbZrFnXeapO
	 SXnhEgI+1tYhAoAhhRbhudfKsksHd0OXFYBSDJTugDyzh2M48tQkZ+W1aKG7l2+Zi6
	 xvsb27GuADZ8g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 13/14] block: Simplify zone write plug BIO abort
Date: Wed,  1 May 2024 20:09:06 +0900
Message-ID: <20240501110907.96950-14-dlemoal@kernel.org>
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
index 132eb988f4d7..15e4e14e16f7 100644
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

