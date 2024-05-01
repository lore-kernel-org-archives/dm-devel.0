Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A83DD52E;
	Wed,  1 May 2024 00:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522187; cv=none; b=LtWEEL/wHzEbnOc5nlthkK2s5NrgQaINBBbh7LAZAlWSQsQLVJyxBhK18GOiXxSunHgR12gsuK7JF0wb9KAc9LjUy52CpiF0WTMoxtqDoeC24koGsrICrfpOyEYrzQ0aFmHTLRts/5Nf9fJaHmrHVk0jc++DK82Tw1JntGBPF78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522187; c=relaxed/simple;
	bh=PT2HeYywBuUJ388cI4SBmbA/o2T4+Y7N0I/yohoQX0g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsS8m6n9273XPdG9EvGd+u8lJ32FamX5EysrZYbCNJF/gx/W9C7/cp0uzQEjMB6Bp8c2hxMlxs921Jjm1m0ES3oRgXfKQlvoCLZxRvJVg9HDwNjBfscD7SQFuFQJ8zujobGtIoWHLh5YbALjZT+aZC+Wp4XkfoGELT6yh0oHr0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sePT+eIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sePT+eIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEBDC4AF19;
	Wed,  1 May 2024 00:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522187;
	bh=PT2HeYywBuUJ388cI4SBmbA/o2T4+Y7N0I/yohoQX0g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=sePT+eIolKOZP5ffC2t9C+KGN34Z1q50dAHgjb71zva63ZD68AQD7LGzRBBVWKOA+
	 4vhPYDvjIH72uT9x+WOp3GQ5eeEYWoASpnKH+AdpzDVRmv9v7t+zo7kfoRReS6ZpZq
	 h4pFFJttc91MgIh+ouWKYC+LsEC17Z3YogmYcQyNyGC7qQXyJLUCZUFCSK1sOa7jSZ
	 yrSh8MiH69X5mAa+fIqTK4qbqpKZDspj2zbzvljhaY7TrHUJpOs4MRSuxJNND1k/q9
	 5/MQzzcNgJr5NiATMIOcMigYyxGK7OzP/RC8ZwiWdqKMnSZ8+YE8L9eOlXHmOnY4gR
	 Efx1aGZEsHaEg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 09/14] block: Fix handling of non-empty flush write requests to zones
Date: Wed,  1 May 2024 09:09:30 +0900
Message-ID: <20240501000935.100534-10-dlemoal@kernel.org>
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

Zone write plugging ignores empty (no data) flush operations but handles
flush BIOs that have data to ensure that the flush machinery generated
write is processed in order. However, the call to
blk_zone_write_plug_attempt_merge() which sets a request
RQF_ZONE_WRITE_PLUGGING flag is called after blk_insert_flush(), thus
missing indicating that a non empty flush request completion needs
handling by zone write plugging.

Fix this by moving the call to blk_zone_write_plug_attempt_merge()
before blk_insert_flush(). And while at it, rename that function as
blk_zone_write_plug_init_request() to be clear that it is not just about
merging plugged BIOs in the request. While at it, also add a WARN_ONCE()
check that the zone write plug for the request is not NULL.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-mq.c    |  6 +++---
 block/blk-zoned.c | 12 ++++++++----
 block/blk.h       |  4 ++--
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 434d45219e23..0fae9bd0ecd4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3001,12 +3001,12 @@ void blk_mq_submit_bio(struct bio *bio)
 		return;
 	}
 
+	if (bio_zone_write_plugging(bio))
+		blk_zone_write_plug_init_request(rq);
+
 	if (op_is_flush(bio->bi_opf) && blk_insert_flush(rq))
 		return;
 
-	if (bio_zone_write_plugging(bio))
-		blk_zone_write_plug_attempt_merge(rq);
-
 	if (plug) {
 		blk_add_rq_to_plug(plug, rq);
 		return;
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 96ea97ad80a9..5a5803ca031c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -874,8 +874,9 @@ void blk_zone_write_plug_bio_merged(struct bio *bio)
 
 	/*
 	 * If the BIO was already plugged, then we were called through
-	 * blk_zone_write_plug_attempt_merge() -> blk_attempt_bio_merge().
-	 * For this case, blk_zone_write_plug_attempt_merge() will handle the
+	 * blk_zone_write_plug_init_request() -> blk_attempt_bio_merge().
+	 * For this case, we already hold a reference on the zone write plug for
+	 * the BIO and blk_zone_write_plug_init_request() will handle the
 	 * zone write pointer offset update.
 	 */
 	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
@@ -899,7 +900,7 @@ void blk_zone_write_plug_bio_merged(struct bio *bio)
  * already went through zone write plugging (either a new BIO or one that was
  * unplugged).
  */
-void blk_zone_write_plug_attempt_merge(struct request *req)
+void blk_zone_write_plug_init_request(struct request *req)
 {
 	sector_t req_back_sector = blk_rq_pos(req) + blk_rq_sectors(req);
 	struct request_queue *q = req->q;
@@ -910,6 +911,9 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 	unsigned long flags;
 	struct bio *bio;
 
+	if (WARN_ON_ONCE(!zwplug))
+		return;
+
 	/*
 	 * Indicate that completion of this request needs to be handled with
 	 * blk_zone_write_plug_complete_request(), which will drop the reference
@@ -1269,7 +1273,7 @@ void blk_zone_write_plug_complete_request(struct request *req)
 
 	/*
 	 * Drop the reference we took when the request was initialized in
-	 * blk_zone_write_plug_attempt_merge().
+	 * blk_zone_write_plug_init_request().
 	 */
 	disk_put_zone_wplug(zwplug);
 
diff --git a/block/blk.h b/block/blk.h
index 1140c4a0be03..8a62b861453c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -427,7 +427,7 @@ static inline bool bio_is_zone_append(struct bio *bio)
 		bio_flagged(bio, BIO_EMULATES_ZONE_APPEND);
 }
 void blk_zone_write_plug_bio_merged(struct bio *bio);
-void blk_zone_write_plug_attempt_merge(struct request *rq);
+void blk_zone_write_plug_init_request(struct request *rq);
 static inline void blk_zone_update_request_bio(struct request *rq,
 					       struct bio *bio)
 {
@@ -481,7 +481,7 @@ static inline bool bio_is_zone_append(struct bio *bio)
 static inline void blk_zone_write_plug_bio_merged(struct bio *bio)
 {
 }
-static inline void blk_zone_write_plug_attempt_merge(struct request *rq)
+static inline void blk_zone_write_plug_init_request(struct request *rq)
 {
 }
 static inline void blk_zone_update_request_bio(struct request *rq,
-- 
2.44.0

