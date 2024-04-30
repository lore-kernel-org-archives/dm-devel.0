Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A55B172786;
	Tue, 30 Apr 2024 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481508; cv=none; b=l4kfPZiLjcj5vNJ4Oz2QqDOlMQGEnsDPY93N2oNdjLONoxp2KuDGc0EdostDA/08U1kH4dlj5BU1kagfOU3EfaNRWRQVc+a9UnzPctj2bknbTWaFTDK/23cNMvR62/QGi7tgr15FTv8Wjki1WOwCpqnIgHRv1Bykar7PjOlX3o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481508; c=relaxed/simple;
	bh=MRdsW+P27msNbM9tQINbf8dXSKB5x61YZFCUVVelG0s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu2WIk0d64GBkeeieeNMv4r6SPkS3/Hs0J99XoNI66Ohbzx8zRmNW4klHiGXYxPh9OKEK/ijbKqZwzwZQ2pTmcWJkD/YJZGSN+h+x90yZJSqlibaIOoHTcoVNoQZWG6Hd+URuWN17uaqkaPQYMnlUTv9sZRawcne151yvHC1iKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+c0XlHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+c0XlHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913D6C4AF1A;
	Tue, 30 Apr 2024 12:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481508;
	bh=MRdsW+P27msNbM9tQINbf8dXSKB5x61YZFCUVVelG0s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=c+c0XlHHCFAY3y7MdcnsytME+c7zoExZBJc36mzxXfobcxFBvf3bbsp+10sISLbyN
	 wUtOm31n+fUVNN0iyxixEbahBWhqOKIRICR0lfE6HR1/TMD/wyQh8qiSMxLMi8YBy9
	 J8QMdhff6QwkFgrVD8YYVOJIxCnXLVS8teSZ3BPcfNPQozHJ5CmRm+SNBqAhEBWzg8
	 ItNCD6Gv3Uj5umlql5BtQwx80Y5mniiZtWnEqaVQD3wRZ2YJ7FlrWzqwsQAtNKIW6P
	 US7ckcadrwnHVVO7VqxgqXV5i7dqPs8nNn+C0xKLTVUzaMaCwAWJlXKvrmpoHvQ2OJ
	 ww+UuDTqvD5SQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 13/13] block: Simplify zone write plug BIO abort
Date: Tue, 30 Apr 2024 21:51:31 +0900
Message-ID: <20240430125131.668482-14-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
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
---
 block/blk-zoned.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index c819e3cc7a20..ed180fdf66f4 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -616,12 +616,14 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
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
 
@@ -632,10 +634,8 @@ static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
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
@@ -655,8 +655,7 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
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

