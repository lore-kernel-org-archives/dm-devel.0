Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB7B1272B2;
	Wed,  1 May 2024 11:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561762; cv=none; b=lKdVtlAiO8+vDpzwFCkaoWXDnBpfay9wJFMlq4lhlSkXPajgWbbqvosF0meArY0iHt8ojQt+pRj5Hfs/rQ2jVabQGPqKwkZpRzpcunNt42fqzFKSF6Eg5abw4C2itV9OrhyZr+woiC5sGe5m3qeysBV1eZhBRO+NK0uFv65FKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561762; c=relaxed/simple;
	bh=L+X96VxgbkwKggOBQa+tLoVPvex50waYmdSk+LFHb5A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn2QF1j+vifgxZJsgexyYc7zQ2i3GyfM1rjUJNY0ocz2MbfSzBUcCOoP+aQHG8mAsyMv/sAQzzG9tGozcMd/ZYaPMA19RA2gdk/8DnpeBfoZPAiuz0B/EuWUExeVdWdKYg8MEos/vYqzTTmI23S9tRNtTZCZX3hbcx6P6rvPj8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqWVOktS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqWVOktS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56127C113CC;
	Wed,  1 May 2024 11:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561762;
	bh=L+X96VxgbkwKggOBQa+tLoVPvex50waYmdSk+LFHb5A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hqWVOktSFFPozWIdbQjJV5GYq0LX7PiqWvpc1F4R7B5e1ppzcg4bKQnIVySI5uLoI
	 efnK537hdQpVTdkGdGRonwTK27pEc80gVtOxktHuxeDxFLuKrd/RwVs6ibu6cMyCGK
	 A/YTXxEtOBGFNWCMJ9xQUe3roFj9oyVgt7apdiWavaFembveS3H63N7Y+iVsmZ0vnf
	 g+0pu6xTSjDPWCCt+wr27yCNgb2HUSussL9gERgIhJGT1pqPzK0wyn7YVzZ/62feiQ
	 PsA4ClStVXrlp1ofm1RimIwbrC0fOE3xrxIr3URHYoHaJjCCpRW1Nz+rRiXKhDnK+r
	 FnKhXysLlaYWQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 11/14] block: Improve zone write request completion handling
Date: Wed,  1 May 2024 20:09:04 +0900
Message-ID: <20240501110907.96950-12-dlemoal@kernel.org>
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

blk_zone_complete_request() must be called to handle the completion of a
zone write request handled with zone write plugging. This function is
called from blk_complete_request(), blk_update_request() and also in
blk_mq_submit_bio() error path. Improve this by moving this function
call into blk_mq_finish_request() as all requests are processed with
this function when they complete as well as when they are freed without
being executed. This also improves blk_update_request() used by scsi
devices as these may repeatedly call this function to handle partial
completions.

To be consistent with this change, blk_zone_complete_request() is
renamed to blk_zone_finish_request() and
blk_zone_write_plug_complete_request() is renamed to
blk_zone_write_plug_finish_request().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-mq.c    |  6 ++----
 block/blk-zoned.c | 11 ++++++-----
 block/blk.h       |  8 ++++----
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0fae9bd0ecd4..9f677ea85a52 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -691,6 +691,8 @@ static void blk_mq_finish_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
+	blk_zone_finish_request(rq);
+
 	if (rq->rq_flags & RQF_USE_SCHED) {
 		q->elevator->type->ops.finish_request(rq);
 		/*
@@ -828,8 +830,6 @@ static void blk_complete_request(struct request *req)
 		bio = next;
 	} while (bio);
 
-	blk_zone_complete_request(req);
-
 	/*
 	 * Reset counters so that the request stacking driver
 	 * can find how many bytes remain in the request
@@ -940,7 +940,6 @@ bool blk_update_request(struct request *req, blk_status_t error,
 	 * completely done
 	 */
 	if (!req->bio) {
-		blk_zone_complete_request(req);
 		/*
 		 * Reset counters so that the request stacking driver
 		 * can find how many bytes remain in the request
@@ -2996,7 +2995,6 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (ret != BLK_STS_OK) {
 		bio->bi_status = ret;
 		bio_endio(bio);
-		blk_zone_complete_request(rq);
 		blk_mq_free_request(rq);
 		return;
 	}
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 1890b6d55d8b..759e85e9167c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -531,7 +531,7 @@ static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
 	/*
 	 * Completions of BIOs with blk_zone_write_plug_bio_endio() may
 	 * happen after handling a request completion with
-	 * blk_zone_write_plug_complete_request() (e.g. with split BIOs
+	 * blk_zone_write_plug_finish_request() (e.g. with split BIOs
 	 * that are chained). In such case, disk_zone_wplug_unplug_bio()
 	 * should not attempt to remove the zone write plug until all BIO
 	 * completions are seen. Check by looking at the zone write plug
@@ -921,7 +921,7 @@ void blk_zone_write_plug_init_request(struct request *req)
 
 	/*
 	 * Indicate that completion of this request needs to be handled with
-	 * blk_zone_write_plug_complete_request(), which will drop the reference
+	 * blk_zone_write_plug_finish_request(), which will drop the reference
 	 * on the zone write plug we took above on entry to this function.
 	 */
 	req->rq_flags |= RQF_ZONE_WRITE_PLUGGING;
@@ -1255,7 +1255,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	disk_put_zone_wplug(zwplug);
 
 	/*
-	 * For BIO-based devices, blk_zone_write_plug_complete_request()
+	 * For BIO-based devices, blk_zone_write_plug_finish_request()
 	 * is not called. So we need to schedule execution of the next
 	 * plugged BIO here.
 	 */
@@ -1266,11 +1266,12 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	disk_put_zone_wplug(zwplug);
 }
 
-void blk_zone_write_plug_complete_request(struct request *req)
+void blk_zone_write_plug_finish_request(struct request *req)
 {
 	struct gendisk *disk = req->q->disk;
-	struct blk_zone_wplug *zwplug = disk_get_zone_wplug(disk, req->__sector);
+	struct blk_zone_wplug *zwplug;
 
+	zwplug = disk_get_zone_wplug(disk, req->__sector);
 	if (WARN_ON_ONCE(!zwplug))
 		return;
 
diff --git a/block/blk.h b/block/blk.h
index 8a62b861453c..ee4f782d1496 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -453,11 +453,11 @@ static inline void blk_zone_bio_endio(struct bio *bio)
 		blk_zone_write_plug_bio_endio(bio);
 }
 
-void blk_zone_write_plug_complete_request(struct request *rq);
-static inline void blk_zone_complete_request(struct request *rq)
+void blk_zone_write_plug_finish_request(struct request *rq);
+static inline void blk_zone_finish_request(struct request *rq)
 {
 	if (rq->rq_flags & RQF_ZONE_WRITE_PLUGGING)
-		blk_zone_write_plug_complete_request(rq);
+		blk_zone_write_plug_finish_request(rq);
 }
 int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
 		unsigned long arg);
@@ -491,7 +491,7 @@ static inline void blk_zone_update_request_bio(struct request *rq,
 static inline void blk_zone_bio_endio(struct bio *bio)
 {
 }
-static inline void blk_zone_complete_request(struct request *rq)
+static inline void blk_zone_finish_request(struct request *rq)
 {
 }
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
-- 
2.44.0

