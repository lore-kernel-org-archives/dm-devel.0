Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502DB163
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 00:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-66cfd0b2d58so2147736d6.2
        for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 17:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698279127; x=1698883927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wM1CuLYSLgK5vRspdwUuj4+qi4lx2wTNFAv8LpnsP6U=;
        b=r9s3C5Ff+31NkGYJmv+7Is3AP0wExJgSte9P/v9oSX7IkRfCATjdPdIn0/O0CwhJpa
         udoXPHQHfs3fcsbUCTyp2N8oXob3QkkIeFFzybHEynV+Ljc4veZq+ujg6Lwbm3Nfejm/
         u4lN9VZeYNKjtO4zTgh7KOQJUY9lj26Xhzj/Q4hgYd+Vd9zy8kmaNR/Tk17fu2sGn35z
         oeeodqggVX98uVYW7Eo2ouoPcthr/wc7Bl1xI6OnlSUvgfB5ZG01KuyCCHPHQ03HCuyI
         Gkd8NcORDs2CNYIArpBORxrq0ysIZbW8+5yiAMo631h2uxYswusKKM7jg9BCF1yHYaKX
         FUMg==
X-Gm-Message-State: AOJu0YzBGpWIt3l3PxCyOjK2jon2IDTOERHFccX6PjqxzjgAui1qEM9e
	5/ONENQb7WoQ4NoJzR8YYLJ8
X-Google-Smtp-Source: AGHT+IGpaNv543+vA9hjg88Wqz6YHfzDYTdd3puDcDZzuQGAnhETLGe5B/WQ21YpUSjN+oUDl4MQpQ==
X-Received: by 2002:a05:6214:21a5:b0:66d:173a:aca7 with SMTP id t5-20020a05621421a500b0066d173aaca7mr17010829qvc.55.1698279127195;
        Wed, 25 Oct 2023 17:12:07 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id f7-20020ad45587000000b0066d1b4ce863sm4795191qvx.31.2023.10.25.17.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 17:12:06 -0700 (PDT)
Date: Wed, 25 Oct 2023 20:12:05 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH v3] dm: respect REQ_NOWAIT flag in normal bios issued to DM
Message-ID: <ZTmu1T5mf3Xgf0tR@redhat.com>
References: <15ca26cc-174a-d4e8-9780-d09f8e5a6ea5@redhat.com>
 <ZTgFtseG3m3WPWn/@redhat.com>
 <e796de8-bac1-8f7a-c6eb-74d39aad8a2b@redhat.com>
 <ZTgb3lkNmEUIYpsl@redhat.com>
 <ZTlt0HPbVZf0gYcI@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTlt0HPbVZf0gYcI@redhat.com>

Update DM core's normal IO submission to allocate required memory
using GFP_NOWAIT if REQ_NOWAIT is set.

Tested with simple test provided in commit a9ce385344f916 ("dm: don't
attempt to queue IO under RCU protection") that was enhanced to check
error codes.  Also tested using fio's pvsync2 with nowait=1.

But testing with induced GFP_NOWAIT allocation failures wasn't
performed (yet).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 50 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)

v3:
- followed Mikulas's suggestion of only supporting NOWAIT for normal IO
- changed attribution to me since basically all the code was rewritten
- removed dm_io_rewind() changes thanks to Ming's reminder that DM's
  requeue won't block IO submission because it is called from worker
  (so it using GFP_NOIO is fine).

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1113a8da3c47..609c68287158 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -570,13 +570,15 @@ static void dm_end_io_acct(struct dm_io *io)
 	dm_io_acct(io, true);
 }
 
-static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
+static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio, gfp_t gfp_mask)
 {
 	struct dm_io *io;
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
+	clone = bio_alloc_clone(NULL, bio, gfp_mask, &md->mempools->io_bs);
+	if (unlikely(!clone))
+		return NULL;
 	tio = clone_to_tio(clone);
 	tio->flags = 0;
 	dm_tio_set_flag(tio, DM_TIO_INSIDE_DM_IO);
@@ -1714,10 +1716,6 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	if (unlikely(!ti))
 		return BLK_STS_IOERR;
 
-	if (unlikely((ci->bio->bi_opf & REQ_NOWAIT) != 0) &&
-	    unlikely(!dm_target_supports_nowait(ti->type)))
-		return BLK_STS_NOTSUPP;
-
 	if (unlikely(ci->is_abnormal_io))
 		return __process_abnormal_io(ci, ti);
 
@@ -1729,7 +1727,17 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 	setup_split_accounting(ci, len);
-	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+
+	if (unlikely(ci->bio->bi_opf & REQ_NOWAIT)) {
+		if (unlikely(!dm_target_supports_nowait(ti->type)))
+			return BLK_STS_NOTSUPP;
+
+		clone = alloc_tio(ci, ti, 0, &len, GFP_NOWAIT);
+		if (unlikely(!clone))
+			return BLK_STS_AGAIN;
+	} else {
+		clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+	}
 	__map_bio(clone);
 
 	ci->sector += len;
@@ -1738,11 +1746,11 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	return BLK_STS_OK;
 }
 
-static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
+static void init_clone_info(struct clone_info *ci, struct dm_io *io,
 			    struct dm_table *map, struct bio *bio, bool is_abnormal)
 {
 	ci->map = map;
-	ci->io = alloc_io(md, bio);
+	ci->io = io;
 	ci->bio = bio;
 	ci->is_abnormal_io = is_abnormal;
 	ci->submit_as_polled = false;
@@ -1764,7 +1772,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	struct clone_info ci;
 	struct dm_io *io;
 	blk_status_t error = BLK_STS_OK;
-	bool is_abnormal;
+	bool is_abnormal, is_preflush = !!(bio->bi_opf & REQ_PREFLUSH);
 
 	is_abnormal = is_abnormal_io(bio);
 	if (unlikely(is_abnormal)) {
@@ -1777,10 +1785,26 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 			return;
 	}
 
-	init_clone_info(&ci, md, map, bio, is_abnormal);
-	io = ci.io;
+	if (unlikely(bio->bi_opf & REQ_NOWAIT)) {
+		/* Only support nowait for normal IO */
+		if (unlikely(is_preflush || is_abnormal)) {
+			bio->bi_status = BLK_STS_NOTSUPP;
+			bio_endio(bio);
+			return;
+		}
 
-	if (bio->bi_opf & REQ_PREFLUSH) {
+		io = alloc_io(md, bio, GFP_NOWAIT);
+		if (unlikely(!io)) {
+			/* Unable to do anything without dm_io. */
+			bio_wouldblock_error(bio);
+			return;
+		}
+	} else {
+		io = alloc_io(md, bio, GFP_NOIO);
+	}
+	init_clone_info(&ci, io, map, bio, is_abnormal);
+
+	if (is_preflush) {
 		__send_empty_flush(&ci);
 		/* dm_io_complete submits any data associated with flush */
 		goto out;
-- 
2.40.0

