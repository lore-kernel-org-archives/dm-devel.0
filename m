Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADBF315AF
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 11:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H95Earca"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5c699b44dddso1858316a12.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Dec 2023 03:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701862807; x=1702467607; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/5Im8T69tBkh1p61afrmuv70bVw9DmqyEOdARijz3w=;
        b=H95EarcauFELzIkUUZy5pXsEYl4ETTYGmMWukNQBKgT/4VPpXWjYVpmjxLOhLqGhKb
         lcTA5wz4eMQ2b03B+pmQi10u6DjErRVGFNraykJx8pzrvZBSvi4NS3X4wGnP91gRdNkO
         c89J3DqdCo3YPR4Wr1Dv/XJ/0JQOPFNnjRFm1CuYCMtz7ZYsDJtSuOvLjfOhI3T2q9oa
         Z/RT4PJ5vsAOe+RY5Za6u1Zp0iiIHWekTrtlkWVp1aXD/0nmji2Z4kAUnFomEQQRwD86
         lDT10RdtKpUkePRJPcTSNsIG7O311Cj1l35bmYNGR0FiarYRZgZhcetpg3Ii3SpgUfAn
         g8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701862807; x=1702467607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/5Im8T69tBkh1p61afrmuv70bVw9DmqyEOdARijz3w=;
        b=Xf7cD/tps4LHI+jhN9TElgbxanOo5TKPgA8AWlGW6VDanzFpnPPQGBOqxDH+Ll3mQ+
         WawuQ9TEaPTnlXwFezO/XfIUhaNoXp5RJfPkgLyst9NywEk2Oj/SYtHtgvSRWnm3bRV7
         D1jrsCqpiCR4VR6NqB1QvpPVV8CAD+ZNAONahkt6ZJV8le2o02tVlz3FNzQ9kRzODLmL
         rLIZNunGbIC0prw3MTogP/PO01VOgimpfbBo/gRYt7BanfH0qUpr01NzSVjNQXwot53Y
         hul+d4EHx1eIPJTfMxC1JQu8C2zLyYdQ42z1d3ZopGcdIkzpdecSuWf/EdL9Niv/mXXA
         nhLw==
X-Gm-Message-State: AOJu0YyKxCSAKWMuyEKeNT0AVQh6lDQ23NUo1QZ+qf6Ig8e+yE2H/xRO
	Y0eW8fj8Wh9a8bEO2QqDJpd7LvKtrQzXUQ==
X-Google-Smtp-Source: AGHT+IFDsYhXar/N0GRnoivAe6mFbBGJnnTqHsRQyoSxvMr30UTcepu7xhqm1odGDW6P45O0jCS+0A==
X-Received: by 2002:a05:6a20:6a0f:b0:18f:97c:4f34 with SMTP id p15-20020a056a206a0f00b0018f097c4f34mr394157pzk.64.1701862807420;
        Wed, 06 Dec 2023 03:40:07 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id kh14-20020a17090b34ce00b002859a1d9fb7sm11044811pjb.2.2023.12.06.03.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 03:40:07 -0800 (PST)
From: Hongyu Jin <hongyu.jin.cn@gmail.com>
To: hongyu.jin.cn@gmail.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com,
	yibin.ding@unisoc.com,
	hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH v2] dm verity: Inherit I/O priority from data I/O when read FEC and hash from disk
Date: Wed,  6 Dec 2023 19:39:35 +0800
Message-Id: <20231206113935.9705-1-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <83e8ea6c-1d9-36d5-1c23-da686dbfaf80@redhat.com>
References: <83e8ea6c-1d9-36d5-1c23-da686dbfaf80@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

when read FEC and hash from disk, I/O priority are inconsistent
 with data block and blocked by other I/O with low I/O priority.

Add dm_bufio_prefetch_by_ioprio() and dm_bufio_read_by_ioprio(),
can pecific I/O priority for some I/O.
Make I/O for FEC and hash has same I/O priority with data I/O.

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>

---
Changes in v2:
  - Add ioprio field in struct dm_io_region
  - Initial struct dm_io_region::ioprio to IOPRIO_DEFAULT
  - Add two interface
---
 drivers/md/dm-bufio.c           | 50 ++++++++++++++++++++++-----------
 drivers/md/dm-integrity.c       |  5 ++++
 drivers/md/dm-io.c              |  1 +
 drivers/md/dm-log.c             |  1 +
 drivers/md/dm-raid1.c           |  2 ++
 drivers/md/dm-snap-persistent.c |  2 ++
 drivers/md/dm-verity-fec.c      |  3 +-
 drivers/md/dm-verity-target.c   | 10 +++++--
 drivers/md/dm-writecache.c      |  4 +++
 include/linux/dm-bufio.h        |  6 ++++
 include/linux/dm-io.h           |  2 ++
 11 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 62eb27639c9b..f1f89b89ff6d 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1256,7 +1256,7 @@ static void dmio_complete(unsigned long error, void *context)
 }
 
 static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
-		     unsigned int n_sectors, unsigned int offset)
+		     unsigned int n_sectors, unsigned int offset, unsigned short ioprio)
 {
 	int r;
 	struct dm_io_request io_req = {
@@ -1269,6 +1269,7 @@ static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
 		.bdev = b->c->bdev,
 		.sector = sector,
 		.count = n_sectors,
+		.ioprio = ioprio,
 	};
 
 	if (b->data_mode != DATA_MODE_VMALLOC) {
@@ -1295,7 +1296,7 @@ static void bio_complete(struct bio *bio)
 }
 
 static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
-		    unsigned int n_sectors, unsigned int offset)
+		    unsigned int n_sectors, unsigned int offset, unsigned short ioprio)
 {
 	struct bio *bio;
 	char *ptr;
@@ -1303,13 +1304,14 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 
 	bio = bio_kmalloc(1, GFP_NOWAIT | __GFP_NORETRY | __GFP_NOWARN);
 	if (!bio) {
-		use_dmio(b, op, sector, n_sectors, offset);
+		use_dmio(b, op, sector, n_sectors, offset, ioprio);
 		return;
 	}
 	bio_init(bio, b->c->bdev, bio->bi_inline_vecs, 1, op);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = bio_complete;
 	bio->bi_private = b;
+	bio->bi_ioprio = ioprio;
 
 	ptr = (char *)b->data + offset;
 	len = n_sectors << SECTOR_SHIFT;
@@ -1332,7 +1334,7 @@ static inline sector_t block_to_sector(struct dm_bufio_client *c, sector_t block
 	return sector;
 }
 
-static void submit_io(struct dm_buffer *b, enum req_op op,
+static void submit_io(struct dm_buffer *b, enum req_op op, unsigned short ioprio,
 		      void (*end_io)(struct dm_buffer *, blk_status_t))
 {
 	unsigned int n_sectors;
@@ -1362,9 +1364,9 @@ static void submit_io(struct dm_buffer *b, enum req_op op,
 	}
 
 	if (b->data_mode != DATA_MODE_VMALLOC)
-		use_bio(b, op, sector, n_sectors, offset);
+		use_bio(b, op, sector, n_sectors, offset, ioprio);
 	else
-		use_dmio(b, op, sector, n_sectors, offset);
+		use_dmio(b, op, sector, n_sectors, offset, ioprio);
 }
 
 /*
@@ -1420,7 +1422,7 @@ static void __write_dirty_buffer(struct dm_buffer *b,
 	b->write_end = b->dirty_end;
 
 	if (!write_list)
-		submit_io(b, REQ_OP_WRITE, write_endio);
+		submit_io(b, REQ_OP_WRITE, IOPRIO_DEFAULT, write_endio);
 	else
 		list_add_tail(&b->write_list, write_list);
 }
@@ -1434,7 +1436,7 @@ static void __flush_write_list(struct list_head *write_list)
 		struct dm_buffer *b =
 			list_entry(write_list->next, struct dm_buffer, write_list);
 		list_del(&b->write_list);
-		submit_io(b, REQ_OP_WRITE, write_endio);
+		submit_io(b, REQ_OP_WRITE, IOPRIO_DEFAULT, write_endio);
 		cond_resched();
 	}
 	blk_finish_plug(&plug);
@@ -1816,7 +1818,7 @@ static void read_endio(struct dm_buffer *b, blk_status_t status)
  * and uses dm_bufio_mark_buffer_dirty to write new data back).
  */
 static void *new_read(struct dm_bufio_client *c, sector_t block,
-		      enum new_flag nf, struct dm_buffer **bp)
+		      enum new_flag nf, struct dm_buffer **bp, unsigned short ioprio)
 {
 	int need_submit = 0;
 	struct dm_buffer *b;
@@ -1869,7 +1871,7 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 		return NULL;
 
 	if (need_submit)
-		submit_io(b, REQ_OP_READ, read_endio);
+		submit_io(b, REQ_OP_READ, ioprio, read_endio);
 
 	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
 
@@ -1889,19 +1891,26 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 void *dm_bufio_get(struct dm_bufio_client *c, sector_t block,
 		   struct dm_buffer **bp)
 {
-	return new_read(c, block, NF_GET, bp);
+	return new_read(c, block, NF_GET, bp, IOPRIO_DEFAULT);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get);
 
 void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
 		    struct dm_buffer **bp)
+{
+	return dm_bufio_read_by_ioprio(c, block, bp, IOPRIO_DEFAULT);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_read);
+
+void *dm_bufio_read_by_ioprio(struct dm_bufio_client *c, sector_t block,
+		    struct dm_buffer **bp, unsigned short ioprio)
 {
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
 		return ERR_PTR(-EINVAL);
 
-	return new_read(c, block, NF_READ, bp);
+	return new_read(c, block, NF_READ, bp, ioprio);
 }
-EXPORT_SYMBOL_GPL(dm_bufio_read);
+EXPORT_SYMBOL_GPL(dm_bufio_read_by_ioprio);
 
 void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 		   struct dm_buffer **bp)
@@ -1909,12 +1918,19 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
 		return ERR_PTR(-EINVAL);
 
-	return new_read(c, block, NF_FRESH, bp);
+	return new_read(c, block, NF_FRESH, bp, IOPRIO_DEFAULT);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_new);
 
 void dm_bufio_prefetch(struct dm_bufio_client *c,
 		       sector_t block, unsigned int n_blocks)
+{
+	return dm_bufio_prefetch_by_ioprio(c, block, n_blocks, IOPRIO_DEFAULT);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_prefetch);
+
+void dm_bufio_prefetch_by_ioprio(struct dm_bufio_client *c,
+		       sector_t block, unsigned int n_blocks, unsigned short ioprio)
 {
 	struct blk_plug plug;
 
@@ -1950,7 +1966,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 			dm_bufio_unlock(c);
 
 			if (need_submit)
-				submit_io(b, REQ_OP_READ, read_endio);
+				submit_io(b, REQ_OP_READ, ioprio, read_endio);
 			dm_bufio_release(b);
 
 			cond_resched();
@@ -1965,7 +1981,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 flush_plug:
 	blk_finish_plug(&plug);
 }
-EXPORT_SYMBOL_GPL(dm_bufio_prefetch);
+EXPORT_SYMBOL_GPL(dm_bufio_prefetch_by_ioprio);
 
 void dm_bufio_release(struct dm_buffer *b)
 {
@@ -2125,6 +2141,7 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 		.bdev = c->bdev,
 		.sector = 0,
 		.count = 0,
+		.ioprio = IOPRIO_DEFAULT,
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
@@ -2149,6 +2166,7 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
 		.count = block_to_sector(c, count),
+		.ioprio = IOPRIO_DEFAULT,
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e85c688fd91e..4bbfaf8f5230 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -543,6 +543,7 @@ static int sync_rw_sb(struct dm_integrity_c *ic, blk_opf_t opf)
 	io_loc.bdev = ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev;
 	io_loc.sector = ic->start;
 	io_loc.count = SB_SECTORS;
+	io_loc.ioprio = IOPRIO_DEFAULT;
 
 	if (op == REQ_OP_WRITE) {
 		sb_set_version(ic);
@@ -1070,6 +1071,7 @@ static void rw_journal_sectors(struct dm_integrity_c *ic, blk_opf_t opf,
 	io_loc.bdev = ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev;
 	io_loc.sector = ic->start + SB_SECTORS + sector;
 	io_loc.count = n_sectors;
+	io_loc.ioprio = IOPRIO_DEFAULT;
 
 	r = dm_io(&io_req, 1, &io_loc, NULL);
 	if (unlikely(r)) {
@@ -1187,6 +1189,7 @@ static void copy_from_journal(struct dm_integrity_c *ic, unsigned int section, u
 	io_loc.bdev = ic->dev->bdev;
 	io_loc.sector = target;
 	io_loc.count = n_sectors;
+	io_loc.IOPRIO_DEFAULT = IOPRIO_DEFAULT;
 
 	r = dm_io(&io_req, 1, &io_loc, NULL);
 	if (unlikely(r)) {
@@ -1515,6 +1518,7 @@ static void dm_integrity_flush_buffers(struct dm_integrity_c *ic, bool flush_dat
 		fr.io_reg.bdev = ic->dev->bdev,
 		fr.io_reg.sector = 0,
 		fr.io_reg.count = 0,
+		fr.io_reg.ioprio = IOPRIO_DEFAULT,
 		fr.ic = ic;
 		init_completion(&fr.comp);
 		r = dm_io(&fr.io_req, 1, &fr.io_reg, NULL);
@@ -2738,6 +2742,7 @@ static void integrity_recalc(struct work_struct *w)
 	io_loc.bdev = ic->dev->bdev;
 	io_loc.sector = get_data_sector(ic, area, offset);
 	io_loc.count = n_sectors;
+	io_loc.ioprio = IOPRIO_DEFAULT;
 
 	r = dm_io(&io_req, 1, &io_loc, NULL);
 	if (unlikely(r)) {
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index f053ce245814..b40f0a432981 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -354,6 +354,7 @@ static void do_region(const blk_opf_t opf, unsigned int region,
 				       &io->client->bios);
 		bio->bi_iter.bi_sector = where->sector + (where->count - remaining);
 		bio->bi_end_io = endio;
+		bio->bi_ioprio = where->ioprio;
 		store_io_and_region_in_bio(bio, io, region);
 
 		if (op == REQ_OP_DISCARD || op == REQ_OP_WRITE_ZEROES) {
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index f9f84236dfcd..e0dacdcd94f1 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -309,6 +309,7 @@ static int flush_header(struct log_c *lc)
 		.bdev = lc->header_location.bdev,
 		.sector = 0,
 		.count = 0,
+		.ioprio = IOPRIO_DEFAULT,
 	};
 
 	lc->io_req.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ddcb2bc4a617..2de9b1377de3 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -275,6 +275,7 @@ static int mirror_flush(struct dm_target *ti)
 		io[i].bdev = m->dev->bdev;
 		io[i].sector = 0;
 		io[i].count = 0;
+		io[i].ioprio = IOPRIO_DEFAULT;
 	}
 
 	error_bits = -1;
@@ -475,6 +476,7 @@ static void map_region(struct dm_io_region *io, struct mirror *m,
 	io->bdev = m->dev->bdev;
 	io->sector = map_sector(m, bio);
 	io->count = bio_sectors(bio);
+	io->ioprio = bio_prio(bio);
 }
 
 static void hold_bio(struct mirror_set *ms, struct bio *bio)
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 15649921f2a9..d8f911727058 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -236,6 +236,8 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, blk_opf_t opf,
 		.bdev = dm_snap_cow(ps->store->snap)->bdev,
 		.sector = ps->store->chunk_size * chunk,
 		.count = ps->store->chunk_size,
+		.ioprio = IOPRIO_DEFAULT,
+
 	};
 	struct dm_io_request io_req = {
 		.bi_opf = opf,
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 3ef9f018da60..160a4de56b28 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -209,6 +209,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 	u8 *bbuf, *rs_block;
 	u8 want_digest[HASH_MAX_DIGESTSIZE];
 	unsigned int n, k;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	if (neras)
 		*neras = 0;
@@ -247,7 +248,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			bufio = v->bufio;
 		}
 
-		bbuf = dm_bufio_read(bufio, block, &buf);
+		bbuf = dm_bufio_read_by_ioprio(bufio, block, &buf, bio->bi_ioprio);
 		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
 				     v->data_dev->name,
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 26adcfea0302..5945ac1dfdff 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -51,6 +51,7 @@ static DEFINE_STATIC_KEY_FALSE(use_tasklet_enabled);
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
+	struct dm_verity_io *io;
 	sector_t block;
 	unsigned int n_blocks;
 };
@@ -293,6 +294,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 	int r;
 	sector_t hash_block;
 	unsigned int offset;
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
@@ -307,7 +309,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			return -EAGAIN;
 		}
 	} else
-		data = dm_bufio_read(v->bufio, hash_block, &buf);
+		data = dm_bufio_read_by_ioprio(v->bufio, hash_block, &buf, bio->bi_ioprio);
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -692,6 +694,7 @@ static void verity_prefetch_io(struct work_struct *work)
 		container_of(work, struct dm_verity_prefetch_work, work);
 	struct dm_verity *v = pw->v;
 	int i;
+	struct bio *bio = dm_bio_from_per_bio_data(pw->io, v->ti->per_io_data_size);
 
 	for (i = v->levels - 2; i >= 0; i--) {
 		sector_t hash_block_start;
@@ -716,8 +719,8 @@ static void verity_prefetch_io(struct work_struct *work)
 				hash_block_end = v->hash_blocks - 1;
 		}
 no_prefetch_cluster:
-		dm_bufio_prefetch(v->bufio, hash_block_start,
-				  hash_block_end - hash_block_start + 1);
+		dm_bufio_prefetch_by_ioprio(v->bufio, hash_block_start,
+				  hash_block_end - hash_block_start + 1, bio->bi_ioprio);
 	}
 
 	kfree(pw);
@@ -751,6 +754,7 @@ static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
 	pw->v = v;
 	pw->block = block;
 	pw->n_blocks = n_blocks;
+	pw->io = io;
 	queue_work(v->verify_wq, &pw->work);
 }
 
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 074cb785eafc..135d1268246f 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -515,6 +515,7 @@ static void ssd_commit_flushed(struct dm_writecache *wc, bool wait_for_ios)
 		region.bdev = wc->ssd_dev->bdev;
 		region.sector = (sector_t)i * (BITMAP_GRANULARITY >> SECTOR_SHIFT);
 		region.count = (sector_t)(j - i) * (BITMAP_GRANULARITY >> SECTOR_SHIFT);
+		region.ioprio = IOPRIO_DEFAULT;
 
 		if (unlikely(region.sector >= wc->metadata_sectors))
 			break;
@@ -555,6 +556,7 @@ static void ssd_commit_superblock(struct dm_writecache *wc)
 	region.bdev = wc->ssd_dev->bdev;
 	region.sector = 0;
 	region.count = max(4096U, wc->block_size) >> SECTOR_SHIFT;
+	region.ioprio = IOPRIO_DEFAULT;
 
 	if (unlikely(region.sector + region.count > wc->metadata_sectors))
 		region.count = wc->metadata_sectors - region.sector;
@@ -590,6 +592,7 @@ static void writecache_disk_flush(struct dm_writecache *wc, struct dm_dev *dev)
 	region.bdev = dev->bdev;
 	region.sector = 0;
 	region.count = 0;
+	region.ioprio = IOPRIO_DEFAULT;
 	req.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 	req.mem.type = DM_IO_KMEM;
 	req.mem.ptr.addr = NULL;
@@ -984,6 +987,7 @@ static int writecache_read_metadata(struct dm_writecache *wc, sector_t n_sectors
 	region.bdev = wc->ssd_dev->bdev;
 	region.sector = wc->start_sector;
 	region.count = n_sectors;
+	region.ioprio = IOPRIO_DEFAULT;
 	req.bi_opf = REQ_OP_READ | REQ_SYNC;
 	req.mem.type = DM_IO_VMA;
 	req.mem.ptr.vma = (char *)wc->memory_map;
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 75e7d8cbb532..39e939bf0419 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -11,6 +11,7 @@
 #define _LINUX_DM_BUFIO_H
 
 #include <linux/blkdev.h>
+#include <linux/ioprio.h>
 #include <linux/types.h>
 
 /*----------------------------------------------------------------*/
@@ -64,6 +65,9 @@ void dm_bufio_set_sector_offset(struct dm_bufio_client *c, sector_t start);
 void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
 		    struct dm_buffer **bp);
 
+void *dm_bufio_read_by_ioprio(struct dm_bufio_client *c, sector_t block,
+		    struct dm_buffer **bp, unsigned short ioprio);
+
 /*
  * Like dm_bufio_read, but return buffer from cache, don't read
  * it. If the buffer is not in the cache, return NULL.
@@ -86,6 +90,8 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 void dm_bufio_prefetch(struct dm_bufio_client *c,
 		       sector_t block, unsigned int n_blocks);
 
+void dm_bufio_prefetch_by_ioprio(struct dm_bufio_client *c,
+		       sector_t block, unsigned int n_blocks, unsigned short ioprio);
 /*
  * Release a reference obtained with dm_bufio_{read,get,new}. The data
  * pointer and dm_buffer pointer is no longer valid after this call.
diff --git a/include/linux/dm-io.h b/include/linux/dm-io.h
index 7595142f3fc5..227ee6d77c70 100644
--- a/include/linux/dm-io.h
+++ b/include/linux/dm-io.h
@@ -20,6 +20,8 @@ struct dm_io_region {
 	struct block_device *bdev;
 	sector_t sector;
 	sector_t count;		/* If this is zero the region is ignored. */
+	/* Set it to IOPRIO_DEFAULT if you don't know what value to set */
+	unsigned short ioprio;
 };
 
 struct page_list {
-- 
2.34.1

