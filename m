Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE810FB
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 19:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-66d11fec9a5so723296d6.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 12:34:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698262482; x=1698867282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XCzuOX6PTMmp7MGcu79eWR9tyAHW4o6NyzbZbsdajiI=;
        b=K9HKFfZKMTM//7ZhaiVZNSeZPONti0vTO2SR5hKhuSgPJBr31ORvTrt8yVsi+HtqP0
         OZsQWNbihqMGw5jfNqtopU5KO2dXy9btRa7zRtJ+9JtYgb6n6PaEJJHhw+oH14DkOGjR
         jhq/g5g4Zhgo4zdTP4OjyTpmfbbom4CeRe7j2/8+wSXO2fq/aK9p9tO7IGAE4r3F61VE
         /aeL5KLHL6B6NrTDp4CnuOutessjxIdTQ0rPXkbnzYLIRrslOp19ELx+0FwPZ7zKXSeb
         6icj/2uztwRMsmaIemCccH0gAplbv8kJyYW72pBaM8cpd0zPwUJL5w8EY0I2ML23P3Dx
         fwzw==
X-Gm-Message-State: AOJu0YzqwFhI0J+KePZJlI8driFvxfpHsteH7vZpr9OHldaTTIHiWVk2
	shGFo3zFkBGQQ3jENZXRnZyR
X-Google-Smtp-Source: AGHT+IFuIafyHAjB6V8k0G6wNhDErvIvCTGqr/C5NwpNGANT5qt7OhwCGV4BdymJTO7WnUnCsovOKw==
X-Received: by 2002:a05:6214:d6f:b0:66d:57ca:fa59 with SMTP id 15-20020a0562140d6f00b0066d57cafa59mr18543431qvs.37.1698262482578;
        Wed, 25 Oct 2023 12:34:42 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id 10-20020ac84e8a000000b0041520676966sm4464019qtp.47.2023.10.25.12.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 12:34:42 -0700 (PDT)
Date: Wed, 25 Oct 2023 15:34:40 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH v2] dm: respect REQ_NOWAIT flag in bios issued to DM
Message-ID: <ZTlt0HPbVZf0gYcI@redhat.com>
References: <15ca26cc-174a-d4e8-9780-d09f8e5a6ea5@redhat.com>
 <ZTgFtseG3m3WPWn/@redhat.com>
 <e796de8-bac1-8f7a-c6eb-74d39aad8a2b@redhat.com>
 <ZTgb3lkNmEUIYpsl@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTgb3lkNmEUIYpsl@redhat.com>

From: Mikulas Patocka <mpatocka@redhat.com>

Update DM core's IO submission to allocate required memory using
GFP_NOWAIT if REQ_NOWAIT is set.  Lone exception is in the error path
where DM's requeue support needs to allocate a clone bio in
dm_io_rewind() to allow the IO to be resubmitted: GFP_NOWAIT is used
first but if it fails GFP_NOIO is used as a last resort.

Tested with simple test provided in commit a9ce385344f916 ("dm: don't
attempt to queue IO under RCU protection") that was enhanced to check
error codes.  Also tested using fio's pvsync2 with nowait=1.

But testing with induced GFP_NOWAIT allocation failures wasn't
performed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Co-developed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-io-rewind.c | 13 ++++++--
 drivers/md/dm.c           | 66 ++++++++++++++++++++++++++++++++-------
 2 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index 6155b0117c9d..bde5a53e2d88 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -143,8 +143,17 @@ static void dm_bio_rewind(struct bio *bio, unsigned int bytes)
 void dm_io_rewind(struct dm_io *io, struct bio_set *bs)
 {
 	struct bio *orig = io->orig_bio;
-	struct bio *new_orig = bio_alloc_clone(orig->bi_bdev, orig,
-					       GFP_NOIO, bs);
+	struct bio *new_orig;
+
+	new_orig = bio_alloc_clone(orig->bi_bdev, orig, GFP_NOWAIT, bs);
+	if (unlikely(!new_orig)) {
+		/*
+		 * Returning early and failing rewind isn't an option, even
+		 * if orig has REQ_NOWAIT set, so retry alloc with GFP_NOIO.
+		 */
+		new_orig = bio_alloc_clone(orig->bi_bdev, orig, GFP_NOIO, bs);
+	}
+
 	/*
 	 * dm_bio_rewind can restore to previous position since the
 	 * end sector is fixed for original bio, but we still need
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1113a8da3c47..b0e1425af475 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -87,6 +87,8 @@ struct clone_info {
 	unsigned int sector_count;
 	bool is_abnormal_io:1;
 	bool submit_as_polled:1;
+	bool is_nowait:1;
+	bool nowait_failed:1;
 };
 
 static inline struct dm_target_io *clone_to_tio(struct bio *clone)
@@ -576,7 +578,13 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
+	if (unlikely(bio->bi_opf & REQ_NOWAIT)) {
+		clone = bio_alloc_clone(NULL, bio, GFP_NOWAIT, &md->mempools->io_bs);
+		if (!clone)
+			return NULL;
+	} else {
+		clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
+	}
 	tio = clone_to_tio(clone);
 	tio->flags = 0;
 	dm_tio_set_flag(tio, DM_TIO_INSIDE_DM_IO);
@@ -1500,9 +1508,17 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 			mutex_unlock(&ci->io->md->table_devices_lock);
 		if (bio_nr == num_bios)
 			return;
-
+		/*
+		 * Failed to allocate all bios, all or nothing, so rewind partial
+		 * allocations and short-circuit retry with GFP_NOIO if 'is_nowait'
+		 */
 		while ((bio = bio_list_pop(blist)))
 			free_tio(bio);
+
+		if (ci->is_nowait) {
+			ci->nowait_failed = true;
+			return;
+		}
 	}
 }
 
@@ -1519,7 +1535,15 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
 	case 1:
 		if (len)
 			setup_split_accounting(ci, *len);
-		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
+		if (unlikely(ci->is_nowait)) {
+			clone = alloc_tio(ci, ti, 0, len, GFP_NOWAIT);
+			if (!clone) {
+				ci->nowait_failed = true;
+				return 0;
+			}
+		} else {
+			clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
+		}
 		__map_bio(clone);
 		ret = 1;
 		break;
@@ -1539,7 +1563,7 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
 	return ret;
 }
 
-static void __send_empty_flush(struct clone_info *ci)
+static blk_status_t __send_empty_flush(struct clone_info *ci)
 {
 	struct dm_table *t = ci->map;
 	struct bio flush_bio;
@@ -1572,6 +1596,8 @@ static void __send_empty_flush(struct clone_info *ci)
 	atomic_sub(1, &ci->io->io_count);
 
 	bio_uninit(ci->bio);
+
+	return likely(!ci->nowait_failed) ? BLK_STS_OK : BLK_STS_AGAIN;
 }
 
 static void __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
@@ -1656,7 +1682,7 @@ static blk_status_t __process_abnormal_io(struct clone_info *ci,
 
 	__send_changing_extent_only(ci, ti, num_bios,
 				    max_granularity, max_sectors);
-	return BLK_STS_OK;
+	return likely(!ci->nowait_failed) ? BLK_STS_OK : BLK_STS_AGAIN;
 }
 
 /*
@@ -1714,7 +1740,7 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	if (unlikely(!ti))
 		return BLK_STS_IOERR;
 
-	if (unlikely((ci->bio->bi_opf & REQ_NOWAIT) != 0) &&
+	if (unlikely(ci->is_nowait) &&
 	    unlikely(!dm_target_supports_nowait(ti->type)))
 		return BLK_STS_NOTSUPP;
 
@@ -1729,7 +1755,15 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 	setup_split_accounting(ci, len);
-	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+	if (unlikely(ci->is_nowait)) {
+		clone = alloc_tio(ci, ti, 0, &len, GFP_NOWAIT);
+		if (unlikely(!clone)) {
+			ci->nowait_failed = true; /* unchecked, set for consistency */
+			return BLK_STS_AGAIN;
+		}
+	} else {
+		clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+	}
 	__map_bio(clone);
 
 	ci->sector += len;
@@ -1738,11 +1772,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	return BLK_STS_OK;
 }
 
-static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
+static void init_clone_info(struct clone_info *ci, struct dm_io *io,
 			    struct dm_table *map, struct bio *bio, bool is_abnormal)
 {
+	ci->is_nowait = !!(bio->bi_opf & REQ_NOWAIT);
+	ci->nowait_failed = false;
 	ci->map = map;
-	ci->io = alloc_io(md, bio);
+	ci->io = io;
 	ci->bio = bio;
 	ci->is_abnormal_io = is_abnormal;
 	ci->submit_as_polled = false;
@@ -1777,11 +1813,17 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 			return;
 	}
 
-	init_clone_info(&ci, md, map, bio, is_abnormal);
-	io = ci.io;
+	io = alloc_io(md, bio);
+	if (!io) {
+		/* Unable to do anything without dm_io. */
+		bio_wouldblock_error(bio);
+		return;
+	}
+
+	init_clone_info(&ci, io, map, bio, is_abnormal);
 
 	if (bio->bi_opf & REQ_PREFLUSH) {
-		__send_empty_flush(&ci);
+		error = __send_empty_flush(&ci);
 		/* dm_io_complete submits any data associated with flush */
 		goto out;
 	}
-- 
2.40.0

