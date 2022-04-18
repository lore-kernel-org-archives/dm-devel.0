Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF109C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-tDxvvwHUNMK-Qs5HDSodDg-1; Sun, 17 Apr 2022 22:27:50 -0400
X-MC-Unique: tDxvvwHUNMK-Qs5HDSodDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED5F3C00104;
	Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E7A6145BA54;
	Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6229D1940352;
	Mon, 18 Apr 2022 02:27:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E259D19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A353C145BA7F; Mon, 18 Apr 2022 02:27:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FB0A145BA58
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 868E7811E75
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:45 +0000 (UTC)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com
 [209.85.219.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-rYEfYQOUNNisY7sihohfUw-1; Sun, 17 Apr 2022 22:27:43 -0400
X-MC-Unique: rYEfYQOUNNisY7sihohfUw-1
Received: by mail-qv1-f49.google.com with SMTP id a10so10122072qvm.8
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=qhLGn0P/em094u6w/6iytQ1PifZ1yufbl67xG96utn4=;
 b=g8v0I9lrnj+rwQK5VqWkjDbGzhRMA6EuF1L0nCuRVR403lv19yMUDNxAwZ70URgd1h
 5Zt9bnkrk9uXD+YO+RFtY26dIIyq5BrkSQlEvK1Lh4LUyCRrcja1zEyc6bJrd98L7Eqa
 KwgSV/EtbMQG0scIn/en4/tA6ob9oXIiiVKcBO6Zacq4I4aLTzZ18PjYYB1ARr1D1Nej
 LZvwnux4zLQ1G3pxKHFz2vCQrKDnFAfhpdPYLVSAHHqQlOPGB1vCr0CF0Iygm9lNXfae
 Qs9ej9XVSZxLhHvVLgBASEISbQnK204lX73oe6KI+AUoRMmMji972KjkJkExB7pYbIKV
 2tCg==
X-Gm-Message-State: AOAM5324uh/oZmpLF92duHSuYOAATXl38HZsZXwP3WVL1IcDgFlJ1PiR
 KVu02/VCsx1+YuW3FUShvao+IQQJ1T5GaQgZD3LJ8uRR2NOXABDXrJy6lTUxd9qxfgFRnB9x3yd
 2ThVPFiqtNzBmS9uB7XMoQBIsfDWSMz6ruPEO/oOKkROevMwuEbj99IbpxEHF5GEXM8I=
X-Google-Smtp-Source: ABdhPJxszTzG1DQSunqNl/epFooK+PqaH6ADGGpQBeBL22Frhbz29PSvoTcnuZ5y4lnQPe5vlOdMMg==
X-Received: by 2002:a05:6214:1bcd:b0:446:662e:ea81 with SMTP id
 m13-20020a0562141bcd00b00446662eea81mr141940qvc.100.1650248863154; 
 Sun, 17 Apr 2022 19:27:43 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 c131-20020a379a89000000b0069c903625absm4833128qke.102.2022.04.17.19.27.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:42 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:19 -0400
Message-Id: <20220418022733.56168-8-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [dm-5.19 PATCH 07/21] dm: add local variables to
 clone_endio and __map_bio
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Avoid redundant dereferences in both functions.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 630c1880023a..4793225722dd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -977,11 +977,12 @@ static bool swap_bios_limit(struct dm_target *ti, struct bio *bio)
 static void clone_endio(struct bio *bio)
 {
 	blk_status_t error = bio->bi_status;
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	struct dm_target_io *tio = clone_to_tio(bio);
+	struct dm_target *ti = tio->ti;
+	dm_endio_fn endio = ti->type->end_io;
 	struct dm_io *io = tio->io;
-	struct mapped_device *md = tio->io->md;
-	dm_endio_fn endio = tio->ti->type->end_io;
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+	struct mapped_device *md = io->md;
 
 	if (unlikely(error == BLK_STS_TARGET)) {
 		if (bio_op(bio) == REQ_OP_DISCARD &&
@@ -996,7 +997,7 @@ static void clone_endio(struct bio *bio)
 		dm_zone_endio(io, bio);
 
 	if (endio) {
-		int r = endio(tio->ti, bio, &error);
+		int r = endio(ti, bio, &error);
 		switch (r) {
 		case DM_ENDIO_REQUEUE:
 			/*
@@ -1020,10 +1021,8 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
-	if (unlikely(swap_bios_limit(tio->ti, bio))) {
-		struct mapped_device *md = io->md;
+	if (unlikely(swap_bios_limit(ti, bio)))
 		up(&md->swap_bios_semaphore);
-	}
 
 	free_tio(bio);
 	dm_io_dec_pending(io, error);
@@ -1264,9 +1263,10 @@ static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
 static void __map_bio(struct bio *clone)
 {
 	struct dm_target_io *tio = clone_to_tio(clone);
-	int r;
-	struct dm_io *io = tio->io;
 	struct dm_target *ti = tio->ti;
+	struct dm_io *io = tio->io;
+	struct mapped_device *md = io->md;
+	int r;
 
 	clone->bi_end_io = clone_endio;
 
@@ -1277,7 +1277,6 @@ static void __map_bio(struct bio *clone)
 	tio->old_sector = clone->bi_iter.bi_sector;
 
 	if (unlikely(swap_bios_limit(ti, clone))) {
-		struct mapped_device *md = io->md;
 		int latch = get_swap_bios();
 		if (unlikely(latch != md->swap_bios))
 			__set_swap_bios_limit(md, latch);
@@ -1289,7 +1288,7 @@ static void __map_bio(struct bio *clone)
 	 * on zoned target. In this case, dm_zone_map_bio() calls the target
 	 * map operation.
 	 */
-	if (unlikely(dm_emulate_zone_append(io->md)))
+	if (unlikely(dm_emulate_zone_append(md)))
 		r = dm_zone_map_bio(tio);
 	else
 		r = ti->type->map(ti, clone);
@@ -1305,14 +1304,14 @@ static void __map_bio(struct bio *clone)
 		 * the bio has been remapped so dispatch it, but defer
 		 * dm_start_io_acct() until after possible bio_split().
 		 */
-		__dm_submit_bio_remap(clone, disk_devt(io->md->disk),
+		__dm_submit_bio_remap(clone, disk_devt(md->disk),
 				      tio->old_sector);
 		dm_io_set_flag(io, DM_IO_START_ACCT);
 		break;
 	case DM_MAPIO_KILL:
 	case DM_MAPIO_REQUEUE:
 		if (unlikely(swap_bios_limit(ti, clone)))
-			up(&io->md->swap_bios_semaphore);
+			up(&md->swap_bios_semaphore);
 		free_tio(clone);
 		if (r == DM_MAPIO_KILL)
 			dm_io_dec_pending(io, BLK_STS_IOERR);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

