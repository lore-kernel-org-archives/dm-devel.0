Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD2B2C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-qHpG7ApWMBOnH5Wqh42abg-1; Sun, 17 Apr 2022 22:27:44 -0400
X-MC-Unique: qHpG7ApWMBOnH5Wqh42abg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AE3E1C06905;
	Mon, 18 Apr 2022 02:27:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE234409B410;
	Mon, 18 Apr 2022 02:27:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD2F519451F1;
	Mon, 18 Apr 2022 02:27:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1150919466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D570B145D47D; Mon, 18 Apr 2022 02:27:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1A37145D47B
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B86EA85A5A8
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:40 +0000 (UTC)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com
 [209.85.222.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-4tGr78UFMGaaI47o-rzZdA-2; Sun, 17 Apr 2022 22:27:39 -0400
X-MC-Unique: 4tGr78UFMGaaI47o-rzZdA-2
Received: by mail-qk1-f176.google.com with SMTP id j6so10360941qkp.9
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=nTMLvTBZjvCiZ8xZQzAZx3bpDW2Nvakfab8Lt7hGF4E=;
 b=T0HnfTwe4VniqY6vIy5/5jVqvAvMu5mhd9jM4iSrHm89j5alJdgW+fKiNb3txKjZtf
 nxDF52FnfkMg3mINm9jWWwDtaZkNI32d2JlHJh5n5zP8tgAuLDPJ/vDDwo7Bfn30vPO1
 T0zGWMBPa2xq3Fr73ZfLwEywdPioecklE84SpYmuAsCHZZAeHiTjFrahmbibB+kkuoeO
 aUyZ5USyZRzNDznvLGGs5r8ZnhiXznZWXgMsLy+o9gFIEmN9Td5mjrWmqn8uOF9dQH2r
 X3Mpd5jMr7Xy/eXe1fS+8mkO7uqHNIoKw9grcC2cnY9Kd+GE6t/ZmZYITn7C9DWtp6eu
 1skA==
X-Gm-Message-State: AOAM532vWx2GkI2tci1Wcw8aA5JcSu4KHFL13BAQZL/qzLdbxxEhMK7N
 qRnQsUCnUIjHH6MmBF/hqAe+9yUYpYm2TESxmi+SlhWlov3FPFLmQlS6/093VNbVIGUWh2St3ej
 OH+nPy8OvtlS00G69++cLuFCVV637GZIxK4nOAw7xPGkF0fip+WfINiv6757Db/8rWEc=
X-Google-Smtp-Source: ABdhPJw53mPa8ndPtEAMnUaQuJmvjpey9EmJnB2XnC19jwW20PkQClilfF6gaLMd/M2JFY9lT/veOA==
X-Received: by 2002:a05:620a:199d:b0:67d:14e0:1267 with SMTP id
 bm29-20020a05620a199d00b0067d14e01267mr5222220qkb.521.1650248858515; 
 Sun, 17 Apr 2022 19:27:38 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w6-20020a05620a424600b0069be4806911sm6228589qko.90.2022.04.17.19.27.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:38 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:15 -0400
Message-Id: <20220418022733.56168-4-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [dm-5.19 PATCH 03/21] dm: factor out dm_io_set_error and
 __dm_io_dec_pending
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Also eliminate need to use errno_to_blk_status().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 64 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 61a52f585966..88ff5c3311aa 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -578,7 +578,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 
 	io = container_of(tio, struct dm_io, tio);
 	io->magic = DM_IO_MAGIC;
-	io->status = 0;
+	io->status = BLK_STS_OK;
 	atomic_set(&io->io_count, 1);
 	this_cpu_inc(*md->pending_io);
 	io->orig_bio = NULL;
@@ -933,20 +933,31 @@ static inline bool dm_tio_is_normal(struct dm_target_io *tio)
  * Decrements the number of outstanding ios that a bio has been
  * cloned into, completing the original io if necc.
  */
-void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
+static inline void __dm_io_dec_pending(struct dm_io *io)
+{
+	if (atomic_dec_and_test(&io->io_count))
+		dm_io_complete(io);
+}
+
+static void dm_io_set_error(struct dm_io *io, blk_status_t error)
 {
+	unsigned long flags;
+
 	/* Push-back supersedes any I/O errors */
-	if (unlikely(error)) {
-		unsigned long flags;
-		spin_lock_irqsave(&io->lock, flags);
-		if (!(io->status == BLK_STS_DM_REQUEUE &&
-		      __noflush_suspending(io->md)))
-			io->status = error;
-		spin_unlock_irqrestore(&io->lock, flags);
+	spin_lock_irqsave(&io->lock, flags);
+	if (!(io->status == BLK_STS_DM_REQUEUE &&
+	      __noflush_suspending(io->md))) {
+		io->status = error;
 	}
+	spin_unlock_irqrestore(&io->lock, flags);
+}
 
-	if (atomic_dec_and_test(&io->io_count))
-		dm_io_complete(io);
+void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
+{
+	if (unlikely(error))
+		dm_io_set_error(io, error);
+
+	__dm_io_dec_pending(io);
 }
 
 void disable_discard(struct mapped_device *md)
@@ -1429,7 +1440,7 @@ static bool is_abnormal_io(struct bio *bio)
 }
 
 static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
-				  int *result)
+				  blk_status_t *status)
 {
 	unsigned num_bios = 0;
 
@@ -1453,11 +1464,11 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 	 * reconfiguration might also have changed that since the
 	 * check was performed.
 	 */
-	if (!num_bios)
-		*result = -EOPNOTSUPP;
+	if (unlikely(!num_bios))
+		*status = BLK_STS_NOTSUPP;
 	else {
 		__send_changing_extent_only(ci, ti, num_bios);
-		*result = 0;
+		*status = BLK_STS_OK;
 	}
 	return true;
 }
@@ -1506,19 +1517,16 @@ static void dm_queue_poll_io(struct bio *bio, struct dm_io *io)
 /*
  * Select the correct strategy for processing a non-flush bio.
  */
-static int __split_and_process_bio(struct clone_info *ci)
+static blk_status_t __split_and_process_bio(struct clone_info *ci)
 {
 	struct bio *clone;
 	struct dm_target *ti;
 	unsigned len;
-	int r;
+	blk_status_t error = BLK_STS_IOERR;
 
 	ti = dm_table_find_target(ci->map, ci->sector);
-	if (!ti)
-		return -EIO;
-
-	if (__process_abnormal_io(ci, ti, &r))
-		return r;
+	if (unlikely(!ti || __process_abnormal_io(ci, ti, &error)))
+		return error;
 
 	/*
 	 * Only support bio polling for normal IO, and the target io is
@@ -1533,7 +1541,7 @@ static int __split_and_process_bio(struct clone_info *ci)
 	ci->sector += len;
 	ci->sector_count -= len;
 
-	return 0;
+	return BLK_STS_OK;
 }
 
 static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
@@ -1559,7 +1567,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 {
 	struct clone_info ci;
 	struct bio *orig_bio = NULL;
-	int error = 0;
+	blk_status_t error = BLK_STS_OK;
 
 	init_clone_info(&ci, md, map, bio);
 
@@ -1601,7 +1609,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	 * bio->bi_private, so that dm_poll_bio can poll them all.
 	 */
 	if (error || !ci.submit_as_polled)
-		dm_io_dec_pending(ci.io, errno_to_blk_status(error));
+		dm_io_dec_pending(ci.io, error);
 	else
 		dm_queue_poll_io(bio, ci.io);
 }
@@ -1682,10 +1690,10 @@ static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
 		if (dm_poll_dm_io(io, iob, flags)) {
 			hlist_del_init(&io->node);
 			/*
-			 * clone_endio() has already occurred, so passing
-			 * error as 0 here doesn't override io->status
+			 * clone_endio() has already occurred, so no
+			 * error handling is needed here.
 			 */
-			dm_io_dec_pending(io, 0);
+			__dm_io_dec_pending(io);
 		}
 	}
 
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

