Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC8B2557B
	for <dm-devel@lists.linux.dev>; Wed, 20 Dec 2023 10:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kBP0FoVm"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d3cfb1568eso21265215ad.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Dec 2023 02:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703066649; x=1703671449; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKixK6wUub2oT9F5UaVSCIFPs2y49HxiR7qbfx7aLFI=;
        b=kBP0FoVmiF9l2f0JTFUg/YNndcEDqWnjELZdKrQAs1+DnUjvb91MngvzPVUcZUmsGU
         vALro04jKAdSvogAglKr3f++QuO5SBhFZ6lwKmp+afFXfzCVhdpv2FhBYSrzBglKdRDe
         Q8yZqVV+eZw+lQ7FckMVwmfEN2/Y0QqveXl658ggFXVrjFg+lH4l1qzLKTfK7JDIvwY/
         7XHI5DdUfPgWVTI4yaAW7urYYobHNEQJp72snORBjiNMAXgLWOugeSPbrLd51ARkWs31
         2RMdESgPvz1mz2q/dBKEL/ua7/oxEndoVm8AxLLiyDjD2q1jnrpcNJ13M2MqUz5KZjJc
         dsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703066649; x=1703671449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VKixK6wUub2oT9F5UaVSCIFPs2y49HxiR7qbfx7aLFI=;
        b=k+m/YdTyP44FlIa8Nvqk2rpWSWolqXSnKNa3xljYZJS0x7lAKqjuRZJLgZbb46uY9A
         suCLZjnSEZ6KLMzfCIqHPO4gVSWrjHegM0oa5LFCedFCPSzzolcryUph/9DLdqHJUHEu
         FubWRKzoWVfZZzMUjOA3jjv2WY3McaNeIfUuZFHOchBtK5KULewviEiDCXp3XY2MKPXQ
         iRze61+8xIeGgCKUf7T/9NGgKI0phwKCRx2UiSQ/JUii16m3kleVP2MitEi1uCfBS9u+
         awM9mGbh0cOB6YdvVnf8Xvox2AiPfzEOrXzbdJkjGV/maqJlYpwylUydUmd8Dgqieph4
         y57Q==
X-Gm-Message-State: AOJu0Yz3CALbLO0YCXyYKghYRNV7WmvclGGoF5xKacn0BSP70WRp3OD7
	N8E0RxMoXugA6TjROIwvKFs=
X-Google-Smtp-Source: AGHT+IFabCSqyIt8lz3m6J0SFYAwUgp81oPaC68zoxOYUq1maSe7wd77aP6b0jRPmSk+ln/GSwHG/A==
X-Received: by 2002:a17:903:120e:b0:1d3:2a94:cb53 with SMTP id l14-20020a170903120e00b001d32a94cb53mr19156798plh.5.1703066649017;
        Wed, 20 Dec 2023 02:04:09 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902fe8300b001d3b7c5776asm5721619plm.160.2023.12.20.02.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Dec 2023 02:04:08 -0800 (PST)
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
Subject: [PATCH v6 3/5] dm-bufio: Support I/O priority
Date: Wed, 20 Dec 2023 18:03:31 +0800
Message-Id: <20231220100333.107049-4-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220100333.107049-1-hongyu.jin.cn@gmail.com>
References: <20231213104216.27845-6-hongyu.jin.cn@gmail.com>
 <20231220100333.107049-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

Some I/O will dispatch from kworker with different io_context settings
than the submitting task, we may need to specify a priority to avoid
losing priority.

Add I/O priority parameter for dm_bufio_read() and
dm_bufio_prefetch().

Co-developed-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Yibin Ding <yibin.ding@unisoc.com>
Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 drivers/md/dm-bufio.c                         | 39 +++++++++++--------
 drivers/md/dm-ebs-target.c                    |  8 ++--
 drivers/md/dm-integrity.c                     |  2 +-
 drivers/md/dm-snap-persistent.c               |  4 +-
 drivers/md/dm-verity-fec.c                    |  4 +-
 drivers/md/dm-verity-target.c                 |  5 ++-
 drivers/md/persistent-data/dm-block-manager.c |  6 +--
 include/linux/dm-bufio.h                      |  5 ++-
 8 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 4f2808ef387f..a6974ecab68e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1292,7 +1292,8 @@ static void dmio_complete(unsigned long error, void *context)
 }
 
 static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
-		     unsigned int n_sectors, unsigned int offset)
+		     unsigned int n_sectors, unsigned int offset,
+		     unsigned short ioprio)
 {
 	int r;
 	struct dm_io_request io_req = {
@@ -1315,7 +1316,7 @@ static void use_dmio(struct dm_buffer *b, enum req_op op, sector_t sector,
 		io_req.mem.ptr.vma = (char *)b->data + offset;
 	}
 
-	r = dm_io(&io_req, 1, &region, NULL, IOPRIO_DEFAULT);
+	r = dm_io(&io_req, 1, &region, NULL, ioprio);
 	if (unlikely(r))
 		b->end_io(b, errno_to_blk_status(r));
 }
@@ -1331,7 +1332,8 @@ static void bio_complete(struct bio *bio)
 }
 
 static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
-		    unsigned int n_sectors, unsigned int offset)
+		    unsigned int n_sectors, unsigned int offset,
+		    unsigned short ioprio)
 {
 	struct bio *bio;
 	char *ptr;
@@ -1339,13 +1341,14 @@ static void use_bio(struct dm_buffer *b, enum req_op op, sector_t sector,
 
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
@@ -1368,7 +1371,7 @@ static inline sector_t block_to_sector(struct dm_bufio_client *c, sector_t block
 	return sector;
 }
 
-static void submit_io(struct dm_buffer *b, enum req_op op,
+static void submit_io(struct dm_buffer *b, enum req_op op, unsigned short ioprio,
 		      void (*end_io)(struct dm_buffer *, blk_status_t))
 {
 	unsigned int n_sectors;
@@ -1398,9 +1401,9 @@ static void submit_io(struct dm_buffer *b, enum req_op op,
 	}
 
 	if (b->data_mode != DATA_MODE_VMALLOC)
-		use_bio(b, op, sector, n_sectors, offset);
+		use_bio(b, op, sector, n_sectors, offset, ioprio);
 	else
-		use_dmio(b, op, sector, n_sectors, offset);
+		use_dmio(b, op, sector, n_sectors, offset, ioprio);
 }
 
 /*
@@ -1456,7 +1459,7 @@ static void __write_dirty_buffer(struct dm_buffer *b,
 	b->write_end = b->dirty_end;
 
 	if (!write_list)
-		submit_io(b, REQ_OP_WRITE, write_endio);
+		submit_io(b, REQ_OP_WRITE, IOPRIO_DEFAULT, write_endio);
 	else
 		list_add_tail(&b->write_list, write_list);
 }
@@ -1470,7 +1473,7 @@ static void __flush_write_list(struct list_head *write_list)
 		struct dm_buffer *b =
 			list_entry(write_list->next, struct dm_buffer, write_list);
 		list_del(&b->write_list);
-		submit_io(b, REQ_OP_WRITE, write_endio);
+		submit_io(b, REQ_OP_WRITE, IOPRIO_DEFAULT, write_endio);
 		cond_resched();
 	}
 	blk_finish_plug(&plug);
@@ -1852,7 +1855,8 @@ static void read_endio(struct dm_buffer *b, blk_status_t status)
  * and uses dm_bufio_mark_buffer_dirty to write new data back).
  */
 static void *new_read(struct dm_bufio_client *c, sector_t block,
-		      enum new_flag nf, struct dm_buffer **bp)
+		      enum new_flag nf, struct dm_buffer **bp,
+		      unsigned short ioprio)
 {
 	int need_submit = 0;
 	struct dm_buffer *b;
@@ -1905,7 +1909,7 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 		return NULL;
 
 	if (need_submit)
-		submit_io(b, REQ_OP_READ, read_endio);
+		submit_io(b, REQ_OP_READ, ioprio, read_endio);
 
 	if (nf != NF_GET)	/* we already tested this condition above */
 		wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
@@ -1926,17 +1930,17 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 void *dm_bufio_get(struct dm_bufio_client *c, sector_t block,
 		   struct dm_buffer **bp)
 {
-	return new_read(c, block, NF_GET, bp);
+	return new_read(c, block, NF_GET, bp, IOPRIO_DEFAULT);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get);
 
 void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
-		    struct dm_buffer **bp)
+		    struct dm_buffer **bp, unsigned short ioprio)
 {
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
 		return ERR_PTR(-EINVAL);
 
-	return new_read(c, block, NF_READ, bp);
+	return new_read(c, block, NF_READ, bp, ioprio);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_read);
 
@@ -1946,12 +1950,13 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 	if (WARN_ON_ONCE(dm_bufio_in_request()))
 		return ERR_PTR(-EINVAL);
 
-	return new_read(c, block, NF_FRESH, bp);
+	return new_read(c, block, NF_FRESH, bp, IOPRIO_DEFAULT);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_new);
 
 void dm_bufio_prefetch(struct dm_bufio_client *c,
-		       sector_t block, unsigned int n_blocks)
+		       sector_t block, unsigned int n_blocks,
+		       unsigned short ioprio)
 {
 	struct blk_plug plug;
 
@@ -1987,7 +1992,7 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 			dm_bufio_unlock(c);
 
 			if (need_submit)
-				submit_io(b, REQ_OP_READ, read_endio);
+				submit_io(b, REQ_OP_READ, ioprio, read_endio);
 			dm_bufio_release(b);
 
 			cond_resched();
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 435b45201f4d..8198c8a7b416 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -84,7 +84,7 @@ static int __ebs_rw_bvec(struct ebs_c *ec, enum req_op op, struct bio_vec *bv,
 
 		/* Avoid reading for writes in case bio vector's page overwrites block completely. */
 		if (op == REQ_OP_READ || buf_off || bv_len < dm_bufio_get_block_size(ec->bufio))
-			ba = dm_bufio_read(ec->bufio, block, &b);
+			ba = dm_bufio_read(ec->bufio, block, &b, IOPRIO_DEFAULT);
 		else
 			ba = dm_bufio_new(ec->bufio, block, &b);
 
@@ -194,13 +194,13 @@ static void __ebs_process_bios(struct work_struct *ws)
 	bio_list_for_each(bio, &bios) {
 		block1 = __sector_to_block(ec, bio->bi_iter.bi_sector);
 		if (bio_op(bio) == REQ_OP_READ)
-			dm_bufio_prefetch(ec->bufio, block1, __nr_blocks(ec, bio));
+			dm_bufio_prefetch(ec->bufio, block1, __nr_blocks(ec, bio), IOPRIO_DEFAULT);
 		else if (bio_op(bio) == REQ_OP_WRITE && !(bio->bi_opf & REQ_PREFLUSH)) {
 			block2 = __sector_to_block(ec, bio_end_sector(bio));
 			if (__block_mod(bio->bi_iter.bi_sector, ec->u_bs))
-				dm_bufio_prefetch(ec->bufio, block1, 1);
+				dm_bufio_prefetch(ec->bufio, block1, 1, IOPRIO_DEFAULT);
 			if (__block_mod(bio_end_sector(bio), ec->u_bs) && block2 != block1)
-				dm_bufio_prefetch(ec->bufio, block2, 1);
+				dm_bufio_prefetch(ec->bufio, block2, 1, IOPRIO_DEFAULT);
 		}
 	}
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 9ffd093ad6cc..1e40e712bcd7 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1418,7 +1418,7 @@ static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, se
 		if (unlikely(r))
 			return r;
 
-		data = dm_bufio_read(ic->bufio, *metadata_block, &b);
+		data = dm_bufio_read(ic->bufio, *metadata_block, &b, IOPRIO_DEFAULT);
 		if (IS_ERR(data))
 			return PTR_ERR(data);
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 568d10842b1f..a2072b95e28c 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -524,7 +524,7 @@ static int read_exceptions(struct pstore *ps,
 
 				if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
 					break;
-				dm_bufio_prefetch(client, pf_chunk, 1);
+				dm_bufio_prefetch(client, pf_chunk, 1, IOPRIO_DEFAULT);
 				prefetch_area++;
 				if (unlikely(!prefetch_area))
 					break;
@@ -533,7 +533,7 @@ static int read_exceptions(struct pstore *ps,
 
 		chunk = area_location(ps, ps->current_area);
 
-		area = dm_bufio_read(client, chunk, &bp);
+		area = dm_bufio_read(client, chunk, &bp, IOPRIO_DEFAULT);
 		if (IS_ERR(area)) {
 			r = PTR_ERR(area);
 			goto ret_destroy_bufio;
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index b475200d8586..49db19e537f9 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -69,7 +69,7 @@ static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
 	block = div64_u64_rem(position, v->fec->io_size, &rem);
 	*offset = (unsigned int)rem;
 
-	res = dm_bufio_read(v->fec->bufio, block, buf);
+	res = dm_bufio_read(v->fec->bufio, block, buf, IOPRIO_DEFAULT);
 	if (IS_ERR(res)) {
 		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
 		      v->data_dev->name, (unsigned long long)rsb,
@@ -248,7 +248,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			bufio = v->bufio;
 		}
 
-		bbuf = dm_bufio_read(bufio, block, &buf);
+		bbuf = dm_bufio_read(bufio, block, &buf, IOPRIO_DEFAULT);
 		if (IS_ERR(bbuf)) {
 			DMWARN_LIMIT("%s: FEC %llu: read failed (%llu): %ld",
 				     v->data_dev->name,
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 14e58ae70521..4758bfe2c156 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -308,7 +308,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 			return -EAGAIN;
 		}
 	} else
-		data = dm_bufio_read(v->bufio, hash_block, &buf);
+		data = dm_bufio_read(v->bufio, hash_block, &buf, IOPRIO_DEFAULT);
 
 	if (IS_ERR(data))
 		return PTR_ERR(data);
@@ -719,7 +719,8 @@ static void verity_prefetch_io(struct work_struct *work)
 		}
 no_prefetch_cluster:
 		dm_bufio_prefetch(v->bufio, hash_block_start,
-				  hash_block_end - hash_block_start + 1);
+				  hash_block_end - hash_block_start + 1,
+				  IOPRIO_DEFAULT);
 	}
 
 	kfree(pw);
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 0e010e1204aa..86a4f73d2f3d 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -474,7 +474,7 @@ int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
 	void *p;
 	int r;
 
-	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
+	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result, IOPRIO_DEFAULT);
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
@@ -510,7 +510,7 @@ int dm_bm_write_lock(struct dm_block_manager *bm,
 	if (dm_bm_is_read_only(bm))
 		return -EPERM;
 
-	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
+	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result, IOPRIO_DEFAULT);
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
@@ -624,7 +624,7 @@ EXPORT_SYMBOL_GPL(dm_bm_flush);
 
 void dm_bm_prefetch(struct dm_block_manager *bm, dm_block_t b)
 {
-	dm_bufio_prefetch(bm->bufio, b, 1);
+	dm_bufio_prefetch(bm->bufio, b, 1, IOPRIO_DEFAULT);
 }
 
 bool dm_bm_is_read_only(struct dm_block_manager *bm)
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 75e7d8cbb532..256a246c7b97 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -62,7 +62,7 @@ void dm_bufio_set_sector_offset(struct dm_bufio_client *c, sector_t start);
  * it dirty.
  */
 void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
-		    struct dm_buffer **bp);
+		    struct dm_buffer **bp, unsigned short ioprio);
 
 /*
  * Like dm_bufio_read, but return buffer from cache, don't read
@@ -84,7 +84,8 @@ void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
  * I/O to finish.
  */
 void dm_bufio_prefetch(struct dm_bufio_client *c,
-		       sector_t block, unsigned int n_blocks);
+		       sector_t block, unsigned int n_blocks,
+		       unsigned short ioprio);
 
 /*
  * Release a reference obtained with dm_bufio_{read,get,new}. The data
-- 
2.34.1

