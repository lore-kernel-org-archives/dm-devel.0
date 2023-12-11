Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB81210E3
	for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 09:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+/B4juE"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-35d725ac060so19761715ab.2
        for <dm-devel@lists.linux.dev>; Mon, 11 Dec 2023 01:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702285252; x=1702890052; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3C4XGNOSQh2qdBXT10pq8W1umCRdPJt9fc3zqaA6RvE=;
        b=b+/B4juEY8cENc3EmPnp9nGWJ1XoYuWp3A4V4MXGzRSN36MZoSQ7Y+sHPJ1Ewhbtpk
         l1IrRmnTxiKsDKxa4laD/tEiwQDU+C9dB31rpyAkSa6UCAYSb93RWHcERpBLXxoyl9/I
         32UXstb/kUE4ICOf9aa91+TD+wejD5MuRW9vc6WEYRFbTrPzhn3cszxghX7PlS1r6Mju
         pG9pbt/BveZu//Mgqob25UDnMim/amssNwxMRet3ZBTzWxZ3RwnMCAusRFp9Ec8Keu9K
         GLpIzH2wyLSdm/Kr1Ogmvx2vT0f/Wo2/M42tGThHk4l2Cn4+s9MEL7Fcc7GKRH4ZWHa8
         kJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702285252; x=1702890052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3C4XGNOSQh2qdBXT10pq8W1umCRdPJt9fc3zqaA6RvE=;
        b=HJ9moZpNe8cBq/pMz5fMGJJ3Ck/ztKY5jeQlbkfUmYKRtz9s92QbogoUtY/+UH9IIv
         CmxJ1udX/hJkwtnHhtfgM5YaK/1O6PHb628kXhqUgCuymLo8MRnzO75xAHYmcP+Qbbzd
         RkuvfwrGy9YWQ8l7CfGp4COtWC2PZTouFBmhUP5tOrgsXvirKt3cuFCs7FozAg6h0e+7
         grvBdtAeRUCQfe/NQ9RYr1JZjaIgYgEiReSobWlOiBIMJ4Y1Atf9/ipfyz2KNGwoGeVN
         Wx9EFD4VldkebdvMssR2CLkJyjNVzn62XjsZinMX1KZmGJyMryql0QEcpKZWpi8fQ5kk
         y4qA==
X-Gm-Message-State: AOJu0YyApdb3ywt4iNELsUPJ3eGFcU5cwZdhl5rrIe7GAGQcPCcRH7Fz
	dNEETVxo9VmjrbuOcKgUOqQ=
X-Google-Smtp-Source: AGHT+IEyCY3ErGWmI8LoIrEOhonz6hBK3ptUyoziGLGE/0Z406ge/Sd7ExzYhLFDiYo6/zx9zBAXTw==
X-Received: by 2002:a92:d150:0:b0:35d:6220:ac8b with SMTP id t16-20020a92d150000000b0035d6220ac8bmr5172666ilg.58.1702285251875;
        Mon, 11 Dec 2023 01:00:51 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id f14-20020a056e020b4e00b0035b0b05189bsm2211216ilu.38.2023.12.11.01.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 01:00:51 -0800 (PST)
From: Hongyu Jin <hongyu.jin.cn@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk,
	ebiggers@kernel.org
Cc: zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com,
	yibin.ding@unisoc.com,
	hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH v3 2/5] dm: Support I/O priority for dm_io()
Date: Mon, 11 Dec 2023 16:59:57 +0800
Message-Id: <20231211090000.9578-3-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231211090000.9578-1-hongyu.jin.cn@gmail.com>
References: <df68c38e-3e38-eaf1-5c32-66e43d68cae3@ewheeler.net>
 <20231211090000.9578-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

Add ioprio field in struct dm_io_region, by this field
specific I/O priority when call dm_io().

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 drivers/md/dm-bufio.c           | 3 +++
 drivers/md/dm-integrity.c       | 5 +++++
 drivers/md/dm-io.c              | 1 +
 drivers/md/dm-log.c             | 1 +
 drivers/md/dm-raid1.c           | 2 ++
 drivers/md/dm-snap-persistent.c | 1 +
 drivers/md/dm-writecache.c      | 4 ++++
 include/linux/dm-io.h           | 2 ++
 8 files changed, 19 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 62eb27639c9b..7f82262aed54 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1269,6 +1269,7 @@ static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
 		.bdev = b->c->bdev,
 		.sector = sector,
 		.count = n_sectors,
+		.ioprio = IOPRIO_DEFAULT,
 	};
 
 	if (b->data_mode != DATA_MODE_VMALLOC) {
@@ -2125,6 +2126,7 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 		.bdev = c->bdev,
 		.sector = 0,
 		.count = 0,
+		.ioprio = IOPRIO_DEFAULT,
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
@@ -2149,6 +2151,7 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
 		.count = block_to_sector(c, count),
+		.ioprio = IOPRIO_DEFAULT,
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e85c688fd91e..7cba183abdce 100644
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
+	io_loc.ioprio = IOPRIO_DEFAULT;
 
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
index 15649921f2a9..4aa70b71f1da 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -236,6 +236,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, blk_opf_t opf,
 		.bdev = dm_snap_cow(ps->store->snap)->bdev,
 		.sector = ps->store->chunk_size * chunk,
 		.count = ps->store->chunk_size,
+		.ioprio = IOPRIO_DEFAULT,
 	};
 	struct dm_io_request io_req = {
 		.bi_opf = opf,
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

