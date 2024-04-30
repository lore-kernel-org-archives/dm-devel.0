Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C013CFA0;
	Tue, 30 Apr 2024 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481506; cv=none; b=M6LtQzA36mbKqoDd7/RRy2tThRJs53UdXdwXwT5CnMXlHGHxEZeR5ioXJK7ICZNf9BDJRukxFk1prRRucFL3VyQNUjZ4Fbw45YQKE8OQeZw0JqWYALui+PXUCyQVsc44VQPBzilltiemrfsZwXgr9b+AvbZPQJsl17Byqh9wUps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481506; c=relaxed/simple;
	bh=zWCBQX5xIG5+9dYZKYbqfTHDPqTpZPTih+lmg8lWlFA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR6pFjSDaMfeiPOL5Pz7rqf1lN1Y0jgqG6l2J+1D9RK9jfSQdwQzS1x9NOYnQwVStt7DZFIJIn6hLUJug3g23SKdp/agmv9wdc2g4XcI/n5zlmrUlJQ26f0mSaT3QC5dsMcPjgfi2/EGTOM+qzPdAqs59lYaYkF2cPFs38mjQNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i01wZ2Pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i01wZ2Pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C333C4AF1B;
	Tue, 30 Apr 2024 12:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481506;
	bh=zWCBQX5xIG5+9dYZKYbqfTHDPqTpZPTih+lmg8lWlFA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=i01wZ2PkUaAKDz+d+HrnvzBg6G8mKjBovWnuZfPXQuaRWcr8HoaQPNk7T9O36ieSz
	 sqCMEzy1VgryLboXaKVMuQyU5QSS4M3+XX488Xue/lsLrjFHgK28CisMXDvmoEbtHE
	 Z+OyBIWSi76s6Jld/ASCjNlTD7sLdf1tEnGyt5udwcScDrlfee8u9XiGsgO6bl8jaW
	 Xsp/pP2paZXC3z9Sqx9kAWqnBs4Zks7HFm/mrg4JOcnucb8Qa9bYofKsGDMrVzVD0x
	 Pcmphu14evKKnkZUaDe0Iih8RnLrJGo9mMgoSoPkuQOzvA6fZX4mhEHKOGwgRzga8T
	 1OBw2mW64hgvQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 11/13] block: Improve zone write request completion handling
Date: Tue, 30 Apr 2024 21:51:29 +0900
Message-ID: <20240430125131.668482-12-dlemoal@kernel.org>
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
---
 block/blk-mq.c    | 6 ++----
 block/blk-zoned.c | 9 +++++----
 block/blk.h       | 8 ++++----
 3 files changed, 11 insertions(+), 12 deletions(-)

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
index d962ba7c9ae1..0047fe66f22d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -902,7 +902,7 @@ void blk_zone_write_plug_init_request(struct request *req)
 
 	/*
 	 * Indicate that completion of this request needs to be handled with
-	 * blk_zone_write_plug_complete_request(), which will drop the reference
+	 * blk_zone_write_plug_finish_request(), which will drop the reference
 	 * on the zone write plug we took above on entry to this function.
 	 */
 	req->rq_flags |= RQF_ZONE_WRITE_PLUGGING;
@@ -1236,7 +1236,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	disk_put_zone_wplug(zwplug);
 
 	/*
-	 * For BIO-based devices, blk_zone_write_plug_complete_request()
+	 * For BIO-based devices, blk_zone_write_plug_finish_request()
 	 * is not called. So we need to schedule execution of the next
 	 * plugged BIO here.
 	 */
@@ -1247,11 +1247,12 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
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

