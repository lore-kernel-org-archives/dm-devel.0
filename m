Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62DDAC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-Cb9iOO__PnGcHhFjiXrj1g-1; Sun, 17 Apr 2022 22:28:03 -0400
X-MC-Unique: Cb9iOO__PnGcHhFjiXrj1g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5578E185A7BA;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4376E41636A;
	Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E554C19451F3;
	Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CDF919466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60B80574775; Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D0A0574776
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4549838035A7
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:59 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-cjJpHXRwOIS8h6gUBuX-og-1; Sun, 17 Apr 2022 22:27:57 -0400
X-MC-Unique: cjJpHXRwOIS8h6gUBuX-og-1
Received: by mail-qv1-f47.google.com with SMTP id x20so10111849qvl.10
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=GNcw3xAgsQN5mPHUurWFw9gPtsM2cDJn56O6M42+2rE=;
 b=fdonv+pvyp6OmXIJoWUHBXRs3YX1nuJBbIWFoIOyMeClxNNURieb3ooMFUz6OJEyiv
 QzIdCw3aBLl9gV8v2PNMTDhS5XjFuVRdDZWRbDz+HPRom6GMEjal9ERx/gx++pSeCAfB
 Ig2sFEgA+kly+0E0CdDiFJxyzzae6zuLLoWb6OKVwqY4S+UB5RCvZCKIKpibGPfm/Dnx
 IgJLeOx3+stJxhXS0AHduiklezgSnjGbFk47Mq+uA+7WZClYkLqFi1AoPQda20+3nMsi
 ikMD041YgizbCNlq/OesLdq0Ai6OVWSJZDaU8eMVa/MRQgu95pXRV+Obz5fGPlCZ22SP
 KCCQ==
X-Gm-Message-State: AOAM532UzmCHtt0p0yVLpFaTvUwfmlqKcASisofRPEGaXZTlDBsXHiBk
 sxtDMD+7y4AwWVCYwBFG5NanmGkhmEsw7mSHxn6cZ5PH4Bdigxfj+0SE0DlazhiZvlfLdMih2p7
 bqBw/LGo4bElcbxcwFK/nqzSDOQswkbHd1YdPa3cQ2JNaWufurrYgBJ+yT2D0kbl0CkE=
X-Google-Smtp-Source: ABdhPJxWtTb1WOnkrb9Tas1kDy3//DyDDD/EqlBhNFkHc8Tfr9Mdwc0q3duUHgTeKJ3/AT1EkaaFMA==
X-Received: by 2002:a05:6214:625:b0:441:1578:620b with SMTP id
 a5-20020a056214062500b004411578620bmr6770004qvx.126.1650248876949; 
 Sun, 17 Apr 2022 19:27:56 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 l18-20020a37f512000000b0069e73cde8b1sm2869251qkk.118.2022.04.17.19.27.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:56 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:30 -0400
Message-Id: <20220418022733.56168-19-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [dm-5.19 PATCH 18/21] dm: improve dm_io reference
 counting
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6240393758633908272=="

--===============6240393758633908272==
Content-Type: application/octet-stream; x-default=true

From: Ming Lei <ming.lei@redhat.com>

Currently each dm_io's reference counter is grabbed before calling
__map_bio(), this way isn't efficient since we can move this grabbing
to initialization time inside alloc_io().

Meantime it becomes typical async io reference counter model: one is
for submission side, the other is for completion side, and the io won't
be completed until both sides are done.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 53 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e4ccd0cce8f3..9b5cdd4b734d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -590,7 +590,9 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	io = container_of(tio, struct dm_io, tio);
 	io->magic = DM_IO_MAGIC;
 	io->status = BLK_STS_OK;
-	atomic_set(&io->io_count, 1);
+
+	/* one ref is for submission, the other is for completion */
+	atomic_set(&io->io_count, 2);
 	this_cpu_inc(*md->pending_io);
 	io->orig_bio = bio;
 	io->md = md;
@@ -955,11 +957,6 @@ static void dm_io_complete(struct dm_io *io)
 	}
 }
 
-static void dm_io_inc_pending(struct dm_io *io)
-{
-	atomic_inc(&io->io_count);
-}
-
 /*
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
@@ -1317,7 +1314,6 @@ static void __map_bio(struct bio *clone)
 	/*
 	 * Map the clone.
 	 */
-	dm_io_inc_pending(io);
 	tio->old_sector = clone->bi_iter.bi_sector;
 
 	if (static_branch_unlikely(&swap_bios_enabled) &&
@@ -1427,11 +1423,12 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 	}
 }
 
-static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
+static int __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 				  unsigned num_bios, unsigned *len)
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
 	struct bio *clone;
+	int ret = 0;
 
 	switch (num_bios) {
 	case 0:
@@ -1441,6 +1438,7 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 			setup_split_accounting(ci, *len);
 		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 		__map_bio(clone);
+		ret = 1;
 		break;
 	default:
 		/* dm_accept_partial_bio() is not supported with shared tio->len_ptr */
@@ -1448,9 +1446,12 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 		while ((clone = bio_list_pop(&blist))) {
 			dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
 			__map_bio(clone);
+			ret += 1;
 		}
 		break;
 	}
+
+	return ret;
 }
 
 static void __send_empty_flush(struct clone_info *ci)
@@ -1471,8 +1472,19 @@ static void __send_empty_flush(struct clone_info *ci)
 	ci->sector_count = 0;
 	ci->io->tio.clone.bi_iter.bi_size = 0;
 
-	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
+	while ((ti = dm_table_get_target(ci->map, target_nr++))) {
+		int bios;
+
+		atomic_add(ti->num_flush_bios, &ci->io->io_count);
+		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
+		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+	}
+
+	/*
+	 * alloc_io() takes one extra reference for submission, so the
+	 * reference won't reach 0 without the following subtraction
+	 */
+	atomic_sub(1, &ci->io->io_count);
 
 	bio_uninit(ci->bio);
 }
@@ -1481,11 +1493,18 @@ static void __send_changing_extent_only(struct clone_info *ci, struct dm_target
 					unsigned num_bios)
 {
 	unsigned len;
+	int bios;
 
 	len = min_t(sector_t, ci->sector_count,
 		    max_io_len_target_boundary(ti, dm_target_offset(ti, ci->sector)));
 
-	__send_duplicate_bios(ci, ti, num_bios, &len);
+	atomic_add(num_bios, &ci->io->io_count);
+	bios = __send_duplicate_bios(ci, ti, num_bios, &len);
+	/*
+	 * alloc_io() takes one extra reference for submission, so the
+	 * reference won't reach 0 without the following (+1) subtraction
+	 */
+	atomic_sub(num_bios - bios + 1, &ci->io->io_count);
 
 	ci->sector += len;
 	ci->sector_count -= len;
@@ -1670,9 +1689,15 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	 * Add every dm_io instance into the hlist_head which is stored in
 	 * bio->bi_private, so that dm_poll_bio can poll them all.
 	 */
-	if (error || !ci.submit_as_polled)
-		dm_io_dec_pending(ci.io, error);
-	else
+	if (error || !ci.submit_as_polled) {
+		/*
+		 * In case of submission failure, the extra reference for
+		 * submitting io isn't consumed yet
+		 */
+		if (error)
+			atomic_dec(&io->io_count);
+		dm_io_dec_pending(io, error);
+	} else
 		dm_queue_poll_io(bio, io);
 }
 
-- 
2.15.0


--===============6240393758633908272==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6240393758633908272==--

