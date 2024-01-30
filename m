Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E950762C6
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 20:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646419; cv=none; b=JEqfS0ihML+HnoK1Ia1q7gEBkRoMKTS2NJcPpvaUthfD6/hFuafHJMXefnl+UH+iY9FBGre852mtNy7L2T4AAkAWSrKZM4dLHRDdESUghdkReTDF3tfo7Wnw4OW+V1PIYBOaTCePZoyAg1+n7mCVe6+UqDKztkkYxH28dx2sQWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646419; c=relaxed/simple;
	bh=0/nonK+3x9ZAw5il78dtGUxoWCdBo2YW75DIdQip12E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZbOqZdYKFH6XvdKhYi9v5U9zYslapVMZ/4TYZCsWYAocB48g0ty3YZNy1jdS+mhT46zsp+ulY3JD+4nKRk39zto/8yPMxePV3cXllV6NA8ExykHUBar/j5ViXy0w6ovLG/u5rsWsqwArK9yOKuAQe1uFgKw+CoHB3RIhJTfin7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-68c3ac1fdb9so26262396d6.2
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 12:26:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706646416; x=1707251216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yuJ7rklVnb6zynFmpDpaOUXBFRs9cBV+/QmDCVUwxAo=;
        b=DpK5qYy2tBVUjSdyIe6rzNn+g8Hh8Fc1enwkmui27HvPkOYFi+ho0qdWS3D7A5XdDx
         SnY1BRGjqvBI2lzm2VumpqImoyhYLO48WWgluvoWetQJiyhb1mzMhy4fH9wXwqq1lN8z
         VzQd41g9l+IGsWWnNMnShzBhvI888pl3bJvf911dNe3SL23jzfZJFfhF4hUAK+YDijyN
         mto0duVJpr8aZ3IZyTAUmeo1Y1NZPLhnTf5NbWccKcCT+2dyLEG+nvvxygQkgjlEdZLS
         2qBXK+GmjLyqhxxNlZxh3ix6aPxj5txw7tn0PlUqfJYvD9jpb+cRwb0NMyhfsdR7onxC
         4gUg==
X-Gm-Message-State: AOJu0YxBm0g0RPvJoVTY8dHLoVSbp2fI9I/joaSvGaq9wDi6j/a7EMa5
	Np+FQRptbCCGHbr+6DtSfkDHT2kK015/ZuLcafRIo9WvAe26o635Tpf6L9aYWQ==
X-Google-Smtp-Source: AGHT+IG3BF8IQv6gX+z0PSbaFy3AKr4IsTHx3l6picP03EBzUxUsN3+QgAhIsZqS0qOiCiSPqGjcyg==
X-Received: by 2002:a05:6214:19e2:b0:68c:59cf:7bc9 with SMTP id q2-20020a05621419e200b0068c59cf7bc9mr695429qvc.3.1706646416279;
        Tue, 30 Jan 2024 12:26:56 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id pd1-20020a056214490100b0068c5b3a7f2fsm1392511qvb.37.2024.01.30.12.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 12:26:55 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk,
	hongyu.jin.cn@gmail.com
Cc: ebiggers@kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	Yibin Ding <yibin.ding@unisoc.com>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH v9 2/5] dm io: Support IO priority
Date: Tue, 30 Jan 2024 15:26:35 -0500
Message-Id: <20240130202638.62600-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240130202638.62600-1-snitzer@kernel.org>
References: <20240130202638.62600-1-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

Some IO will dispatch from kworker with different io_context settings
than the submitting task, we may need to specify a priority to avoid
losing priority.

Add IO priority parameter to dm_io() and update all callers.

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c           |  6 +++---
 drivers/md/dm-integrity.c       | 10 +++++-----
 drivers/md/dm-io.c              | 23 +++++++++++++----------
 drivers/md/dm-kcopyd.c          |  4 ++--
 drivers/md/dm-log.c             |  4 ++--
 drivers/md/dm-raid1.c           |  6 +++---
 drivers/md/dm-snap-persistent.c |  4 ++--
 drivers/md/dm-writecache.c      |  8 ++++----
 include/linux/dm-io.h           |  3 ++-
 9 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 13c65b7e1ed6..f5541b8f6320 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1315,7 +1315,7 @@ static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
 		io_req.mem.ptr.vma = (char *)b->data + offset;
 	}
 
-	r = dm_io(&io_req, 1, &region, NULL);
+	r = dm_io(&io_req, 1, &region, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		b->end_io(b, errno_to_blk_status(r));
 }
@@ -2167,7 +2167,7 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
 		return -EINVAL;
 
-	return dm_io(&io_req, 1, &io_reg, NULL);
+	return dm_io(&io_req, 1, &io_reg, NULL, IOPRIO_DEFAULT);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_issue_flush);
 
@@ -2191,7 +2191,7 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
 		return -EINVAL; /* discards are optional */
 
-	return dm_io(&io_req, 1, &io_reg, NULL);
+	return dm_io(&io_req, 1, &io_reg, NULL, IOPRIO_DEFAULT);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_issue_discard);
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index c5f03aab4552..ed45411eb68d 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -553,7 +553,7 @@ static int sync_rw_sb(struct dm_integrity_c *ic, blk_opf_t opf)
 		}
 	}
 
-	r = dm_io(&io_req, 1, &io_loc, NULL);
+	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		return r;
 
@@ -1071,7 +1071,7 @@ static void rw_journal_sectors(struct dm_integrity_c *ic, blk_opf_t opf,
 	io_loc.sector = ic->start + SB_SECTORS + sector;
 	io_loc.count = n_sectors;
 
-	r = dm_io(&io_req, 1, &io_loc, NULL);
+	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r)) {
 		dm_integrity_io_error(ic, (opf & REQ_OP_MASK) == REQ_OP_READ ?
 				      "reading journal" : "writing journal", r);
@@ -1188,7 +1188,7 @@ static void copy_from_journal(struct dm_integrity_c *ic, unsigned int section, u
 	io_loc.sector = target;
 	io_loc.count = n_sectors;
 
-	r = dm_io(&io_req, 1, &io_loc, NULL);
+	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r)) {
 		WARN_ONCE(1, "asynchronous dm_io failed: %d", r);
 		fn(-1UL, data);
@@ -1517,7 +1517,7 @@ static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_dat
 		fr.io_reg.count = 0,
 		fr.ic = ic;
 		init_completion(&fr.comp);
-		r = dm_io(&fr.io_req, 1, &fr.io_reg, NULL);
+		r = dm_io(&fr.io_req, 1, &fr.io_reg, NULL, IOPRIO_DEFAULT);
 		BUG_ON(r);
 	}
 
@@ -2740,7 +2740,7 @@ static void integrity_recalc(struct work_struct *w)
 	io_loc.sector = get_data_sector(ic, area, offset);
 	io_loc.count = n_sectors;
 
-	r = dm_io(&io_req, 1, &io_loc, NULL);
+	r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r)) {
 		dm_integrity_io_error(ic, "reading data", r);
 		goto err;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index f053ce245814..7409490259d1 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -305,7 +305,7 @@ static void km_dp_init(struct dpages *dp, void *data)
  */
 static void do_region(const blk_opf_t opf, unsigned int region,
 		      struct dm_io_region *where, struct dpages *dp,
-		      struct io *io)
+		      struct io *io, unsigned short ioprio)
 {
 	struct bio *bio;
 	struct page *page;
@@ -354,6 +354,7 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 				       &io->client->bios);
 		bio->bi_iter.bi_sector = where->sector + (where->count - remaining);
 		bio->bi_end_io = endio;
+		bio->bi_ioprio = ioprio;
 		store_io_and_region_in_bio(bio, io, region);
 
 		if (op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES) {
@@ -383,7 +384,7 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 
 static void dispatch_io(blk_opf_t opf, unsigned int num_regions,
 			struct dm_io_region *where, struct dpages *dp,
-			struct io *io, int sync)
+			struct io *io, int sync, unsigned short ioprio)
 {
 	int i;
 	struct dpages old_pages = *dp;
@@ -400,7 +401,7 @@ static void dispatch_io(blk_opf_t opf, unsigned int num_regions,
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
 		if (where[i].count || (opf & REQ_PREFLUSH))
-			do_region(opf, i, where + i, dp, io);
+			do_region(opf, i, where + i, dp, io, ioprio);
 	}
 
 	/*
@@ -425,7 +426,7 @@ static void sync_io_complete(unsigned long error, void *context)
 
 static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 		   struct dm_io_region *where, blk_opf_t opf, struct dpages *dp,
-		   unsigned long *error_bits)
+		   unsigned long *error_bits, unsigned short ioprio)
 {
 	struct io *io;
 	struct sync_io sio;
@@ -447,7 +448,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
-	dispatch_io(opf, num_regions, where, dp, io, 1);
+	dispatch_io(opf, num_regions, where, dp, io, 1, ioprio);
 
 	wait_for_completion_io(&sio.wait);
 
@@ -459,7 +460,8 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 static int async_io(struct dm_io_client *client, unsigned int num_regions,
 		    struct dm_io_region *where, blk_opf_t opf,
-		    struct dpages *dp, io_notify_fn fn, void *context)
+		    struct dpages *dp, io_notify_fn fn, void *context,
+		    unsigned short ioprio)
 {
 	struct io *io;
 
@@ -479,7 +481,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
-	dispatch_io(opf, num_regions, where, dp, io, 0);
+	dispatch_io(opf, num_regions, where, dp, io, 0, ioprio);
 	return 0;
 }
 
@@ -521,7 +523,8 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
 }
 
 int dm_io(struct dm_io_request *io_req, unsigned int num_regions,
-	  struct dm_io_region *where, unsigned long *sync_error_bits)
+	  struct dm_io_region *where, unsigned long *sync_error_bits,
+	  unsigned short ioprio)
 {
 	int r;
 	struct dpages dp;
@@ -532,11 +535,11 @@ int dm_io(struct dm_io_request *io_req, unsigned int num_regions,
 
 	if (!io_req->notify.fn)
 		return sync_io(io_req->client, num_regions, where,
-			       io_req->bi_opf, &dp, sync_error_bits);
+			       io_req->bi_opf, &dp, sync_error_bits, ioprio);
 
 	return async_io(io_req->client, num_regions, where,
 			io_req->bi_opf, &dp, io_req->notify.fn,
-			io_req->notify.context);
+			io_req->notify.context, ioprio);
 }
 EXPORT_SYMBOL(dm_io);
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 36bcfdccae04..6ea75436a433 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -578,9 +578,9 @@ static int run_io_job(struct kcopyd_job *job)
 	io_job_start(job->kc->throttle);
 
 	if (job->op == REQ_OP_READ)
-		r = dm_io(&io_req, 1, &job->source, NULL);
+		r = dm_io(&io_req, 1, &job->source, NULL, IOPRIO_DEFAULT);
 	else
-		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
+		r = dm_io(&io_req, job->num_dests, job->dests, NULL, IOPRIO_DEFAULT);
 
 	return r;
 }
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index f9f84236dfcd..f7f9c2100937 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -300,7 +300,7 @@ static int rw_header(struct log_c *lc, enum req_op op)
 {
 	lc->io_req.bi_opf = op;
 
-	return dm_io(&lc->io_req, 1, &lc->header_location, NULL);
+	return dm_io(&lc->io_req, 1, &lc->header_location, NULL, IOPRIO_DEFAULT);
 }
 
 static int flush_header(struct log_c *lc)
@@ -313,7 +313,7 @@ static int flush_header(struct log_c *lc)
 
 	lc->io_req.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 
-	return dm_io(&lc->io_req, 1, &null_location, NULL);
+	return dm_io(&lc->io_req, 1, &null_location, NULL, IOPRIO_DEFAULT);
 }
 
 static int read_header(struct log_c *log)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ddcb2bc4a617..9511dae5b556 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -278,7 +278,7 @@ static int mirror_flush(struct dm_target *ti)
 	}
 
 	error_bits = -1;
-	dm_io(&io_req, ms->nr_mirrors, io, &error_bits);
+	dm_io(&io_req, ms->nr_mirrors, io, &error_bits, IOPRIO_DEFAULT);
 	if (unlikely(error_bits != 0)) {
 		for (i = 0; i < ms->nr_mirrors; i++)
 			if (test_bit(i, &error_bits))
@@ -554,7 +554,7 @@ static void read_async_bio(struct mirror *m, struct bio *bio)
 
 	map_region(&io, m, bio);
 	bio_set_m(bio, m);
-	BUG_ON(dm_io(&io_req, 1, &io, NULL));
+	BUG_ON(dm_io(&io_req, 1, &io, NULL, IOPRIO_DEFAULT));
 }
 
 static inline int region_in_sync(struct mirror_set *ms, region_t region,
@@ -681,7 +681,7 @@ static void do_write(struct mirror_set *ms, struct bio *bio)
 	 */
 	bio_set_m(bio, get_default_mirror(ms));
 
-	BUG_ON(dm_io(&io_req, ms->nr_mirrors, io, NULL));
+	BUG_ON(dm_io(&io_req, ms->nr_mirrors, io, NULL, IOPRIO_DEFAULT));
 }
 
 static void do_writes(struct mirror_set *ms, struct bio_list *writes)
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 15649921f2a9..568d10842b1f 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -223,7 +223,7 @@ static void do_metadata(struct work_struct *work)
 {
 	struct mdata_req *req = container_of(work, struct mdata_req, work);
 
-	req->result = dm_io(req->io_req, 1, req->where, NULL);
+	req->result = dm_io(req->io_req, 1, req->where, NULL, IOPRIO_DEFAULT);
 }
 
 /*
@@ -247,7 +247,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, blk_opf_t opf,
 	struct mdata_req req;
 
 	if (!metadata)
-		return dm_io(&io_req, 1, &where, NULL);
+		return dm_io(&io_req, 1, &where, NULL, IOPRIO_DEFAULT);
 
 	req.where = &where;
 	req.io_req = &io_req;
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index b463c28c39ad..01ab141bc51e 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -531,7 +531,7 @@ static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 		req.notify.context = &endio;
 
 		/* writing via async dm-io (implied by notify.fn above) won't return an error */
-		(void) dm_io(&req, 1, &region, NULL);
+		(void) dm_io(&req, 1, &region, NULL, IOPRIO_DEFAULT);
 		i = j;
 	}
 
@@ -568,7 +568,7 @@ static void ssd_commit_superblock(struct dm_writecache *wc)
 	req.notify.fn = NULL;
 	req.notify.context = NULL;
 
-	r = dm_io(&req, 1, &region, NULL);
+	r = dm_io(&req, 1, &region, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		writecache_error(wc, r, "error writing superblock");
 }
@@ -596,7 +596,7 @@ static void writecache_disk_flush(struct dm_writecache *wc, struct dm_dev *dev)
 	req.client = wc->dm_io;
 	req.notify.fn = NULL;
 
-	r = dm_io(&req, 1, &region, NULL);
+	r = dm_io(&req, 1, &region, NULL, IOPRIO_DEFAULT);
 	if (unlikely(r))
 		writecache_error(wc, r, "error flushing metadata: %d", r);
 }
@@ -990,7 +990,7 @@ static int writecache_read_metadata(struct dm_writecache *wc, sector_t n_sectors
 	req.client = wc->dm_io;
 	req.notify.fn = NULL;
 
-	return dm_io(&req, 1, &region, NULL);
+	return dm_io(&req, 1, &region, NULL, IOPRIO_DEFAULT);
 }
 
 static void writecache_resume(struct dm_target *ti)
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index 7595142f3fc5..7b2968612b7e 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -80,7 +80,8 @@ void dm_io_client_destroy(struct dm_io_client *client);
  * error occurred doing io to the corresponding region.
  */
 int dm_io(struct dm_io_request *io_req, unsigned int num_regions,
-	  struct dm_io_region *region, unsigned int long *sync_error_bits);
+	  struct dm_io_region *region, unsigned int long *sync_error_bits,
+	  unsigned short ioprio);
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_IO_H */
-- 
2.40.0

