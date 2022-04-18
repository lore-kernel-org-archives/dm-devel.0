Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 369FEC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-lIbmiMwlOpmO0xIdGtfoPg-1; Sun, 17 Apr 2022 22:28:07 -0400
X-MC-Unique: lIbmiMwlOpmO0xIdGtfoPg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23A6986B8A3;
	Mon, 18 Apr 2022 02:28:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D491F40F4941;
	Mon, 18 Apr 2022 02:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C23B19451F1;
	Mon, 18 Apr 2022 02:28:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A7BB19451F1
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1B29040F4961; Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 170C940F495E
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F327E802803
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:28:02 +0000 (UTC)
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com
 [209.85.222.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-xzMKaOmaO32udE9XbGm4Zw-1; Sun, 17 Apr 2022 22:28:01 -0400
X-MC-Unique: xzMKaOmaO32udE9XbGm4Zw-1
Received: by mail-qk1-f180.google.com with SMTP id b189so10343446qkf.11
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=NuBmusRcYZ8vy1ZOUpah3OMFQUXOduiGLe+I2jdiJHQ=;
 b=R3Cbwba4JXVl7IEvRcrbpwkLmmU/G5TDDgr1SwwPumgE0N9mKox4xvqX2M22qoEFNA
 nh1e11tEMzRtxO8bpVoWyTmgNI9KPaJ5kJMW0uW4GOWHmMWNzE+BwkCAhLhL3Cd+esDB
 MuWfcGVrC6R/uKwH75o9699vNMbZeQjAg76TeWqKphunE4xPRxouHt4dhfY/jz6ZzD7t
 6lQLseBqx6VgwfD4HCZm1muK1qRodc40PtDbOVnMqLOf33bhQjlxmChX9653sCK4vi8n
 IskRTX4nX/dykKFJKrqyZ2g4cbHCTCRcKTo3MhBZYaY5ndMZBEbZfA2/CuvQppSqftea
 E45w==
X-Gm-Message-State: AOAM533lKasd2ZcPhsEZXWU11uHs8Mx9QbxrgOrqfxY0ODGDraEMen/7
 4Cz1AIo0FXaN0I8M76uJ9VTl6p9rvjgK7FdJnkknTxisOnDSNbLUB0wXGRVdNRZV7AsYP3mcvtV
 m19377ThBAR440usBC25X3dzz62+QPpAznTOMh79CH6ibDIePdnGWnn+q/MRi/UnBbB4=
X-Google-Smtp-Source: ABdhPJwfN204IauglDk5QITa4xxZNYH466YiQID/iW3N77FqQkr5I/mWSRDi6MhDWUvhCn5kab0flg==
X-Received: by 2002:a05:620a:1a25:b0:69c:4a3c:4ffd with SMTP id
 bk37-20020a05620a1a2500b0069c4a3c4ffdmr5466422qkb.340.1650248880487; 
 Sun, 17 Apr 2022 19:28:00 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 c17-20020ac85a91000000b002e1dd8ae44bsm6965977qtc.29.2022.04.17.19.28.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:28:00 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:33 -0400
Message-Id: <20220418022733.56168-22-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [dm-5.19 PATCH 21/21] dm: improve abnormal bio processing
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Read/write/flush are the most common operations, optimize switch in
is_abnormal_io() for those cases. Follows same pattern established in
block perf-wip commit ("block: optimise blk_may_split for normal rw")

Also, push is_abnormal_io() check and blk_queue_split() down from
dm_submit_bio() to dm_split_and_process_bio() and set new
'is_abnormal_io' flag in clone_info. Optimize __split_and_process_bio
and __process_abnormal_io by leveraging ci.is_abnormal_io flag.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 60 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b87d151ef88..b9c30dfe0f2a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -84,7 +84,8 @@ struct clone_info {
 	struct dm_io *io;
 	sector_t sector;
 	unsigned sector_count;
-	bool submit_as_polled;
+	bool is_abnormal_io:1;
+	bool submit_as_polled:1;
 };
 
 #define DM_TARGET_IO_BIO_OFFSET (offsetof(struct dm_target_io, clone))
@@ -1492,21 +1493,24 @@ static void __send_changing_extent_only(struct clone_info *ci, struct dm_target
 
 static bool is_abnormal_io(struct bio *bio)
 {
-	bool r = false;
+	unsigned int op = bio_op(bio);
 
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		r = true;
-		break;
+	if (op != REQ_OP_READ && op != REQ_OP_WRITE && op != REQ_OP_FLUSH) {
+		switch (op) {
+		case REQ_OP_DISCARD:
+		case REQ_OP_SECURE_ERASE:
+		case REQ_OP_WRITE_ZEROES:
+			return true;
+		default:
+			break;
+		}
 	}
 
-	return r;
+	return false;
 }
 
-static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
-				  blk_status_t *status)
+static blk_status_t __process_abnormal_io(struct clone_info *ci,
+					  struct dm_target *ti)
 {
 	unsigned num_bios = 0;
 
@@ -1520,8 +1524,6 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 	case REQ_OP_WRITE_ZEROES:
 		num_bios = ti->num_write_zeroes_bios;
 		break;
-	default:
-		return false;
 	}
 
 	/*
@@ -1531,12 +1533,10 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 	 * check was performed.
 	 */
 	if (unlikely(!num_bios))
-		*status = BLK_STS_NOTSUPP;
-	else {
-		__send_changing_extent_only(ci, ti, num_bios);
-		*status = BLK_STS_OK;
-	}
-	return true;
+		return BLK_STS_NOTSUPP;
+
+	__send_changing_extent_only(ci, ti, num_bios);
+	return BLK_STS_OK;
 }
 
 /*
@@ -1589,11 +1589,12 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	struct bio *clone;
 	struct dm_target *ti;
 	unsigned len;
-	blk_status_t error = BLK_STS_IOERR;
 
 	ti = dm_table_find_target(ci->map, ci->sector);
-	if (unlikely(!ti || __process_abnormal_io(ci, ti, &error)))
-		return error;
+	if (unlikely(!ti))
+		return BLK_STS_IOERR;
+	else if (unlikely(ci->is_abnormal_io))
+		return __process_abnormal_io(ci, ti);
 
 	/*
 	 * Only support bio polling for normal IO, and the target io is
@@ -1618,6 +1619,7 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 	ci->map = map;
 	ci->io = alloc_io(md, bio);
 	ci->bio = bio;
+	ci->is_abnormal_io = false;
 	ci->submit_as_polled = false;
 	ci->sector = bio->bi_iter.bi_sector;
 	ci->sector_count = bio_sectors(bio);
@@ -1645,6 +1647,13 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 		__send_empty_flush(&ci);
 		/* dm_io_complete submits any data associated with flush */
 		goto out;
+	} else if (unlikely(is_abnormal_io(bio))) {
+		/*
+		 * Use blk_queue_split() for abnormal IO (e.g. discard, etc)
+		 * otherwise associated queue_limits won't be imposed.
+		 */
+		blk_queue_split(&bio);
+		ci.is_abnormal_io = true;
 	}
 
 	error = __split_and_process_bio(&ci);
@@ -1698,13 +1707,6 @@ static void dm_submit_bio(struct bio *bio)
 		goto out;
 	}
 
-	/*
-	 * Use blk_queue_split() for abnormal IO (e.g. discard, writesame, etc)
-	 * otherwise associated queue_limits won't be imposed.
-	 */
-	if (unlikely(is_abnormal_io(bio)))
-		blk_queue_split(&bio);
-
 	dm_split_and_process_bio(md, map, bio);
 out:
 	dm_put_live_table_bio(md, srcu_idx, bio);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

