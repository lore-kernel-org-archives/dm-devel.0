Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4876BC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-oLU718R9PEiDMzTaowteTA-1; Sun, 17 Apr 2022 22:27:46 -0400
X-MC-Unique: oLU718R9PEiDMzTaowteTA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81C50811E78;
	Mon, 18 Apr 2022 02:27:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7002D574771;
	Mon, 18 Apr 2022 02:27:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EFF8C19451F1;
	Mon, 18 Apr 2022 02:27:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 57F0219466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47A51145BA58; Mon, 18 Apr 2022 02:27:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43D04145BA54
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A70180418A
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:42 +0000 (UTC)
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
 [209.85.222.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-4Yl3YKECN4SIPHn9h9yczQ-1; Sun, 17 Apr 2022 22:27:40 -0400
X-MC-Unique: 4Yl3YKECN4SIPHn9h9yczQ-1
Received: by mail-qk1-f169.google.com with SMTP id c1so10333853qkf.13
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=WC4/CipdzgTN3se8d+L028AZTt4ZJzV49kXsLuFQgrs=;
 b=o+U1rpMaZc316p5nPZgA7mb5iwWZBjYVYkPNuM/EYCwT7Y58fDMu085kOYBteYXh16
 l0dPqW6HzhREzKMb0WQ96gu08KU6WEWCua/yy83mHq/CTil9HR0S8XSFbbQPGsy574kP
 2Dlrl/I01maUtUuzl5NVrJwrCivjEoxMQe0qGbFLNry1AyJ4jx3gj2AfovsovROlAmUb
 4n0yuAR0ddn28cKcJqlKageOUcZyam0sDeCQPFvtNM7aGQ4qYvjHpEIJDhObVnux3q+f
 waY+k4+scd1R/JaAYR9mrel4+FhS9VGThAtvoeosp2Zc6yVDZdeQ8O2jq0tdMxVNGzID
 cq8Q==
X-Gm-Message-State: AOAM530Wy+5X2IuOStVPelKUdFhXNeoV5pU+pa5KH05A+xgidD2GLgoJ
 FqUxaBkv0zHEIZ3U0O1Q2VTMCzzlxkVDeaz15ZXKGa4iCIv6kH3JNpMqrThi0vGEdFD74KLDUJL
 +kl4SRMfaTqPKZYBpSBMNH+FdnNZz95OPaG4RqinydX/YWUk7uDy/fhTf3C8LQHq+cXo=
X-Google-Smtp-Source: ABdhPJz4n4y68aJDDFsswEA//XUAbPWLiUmjKKXE4RCNiC0p6NUvBHon5kuWKFkPj9sBF6992edKfQ==
X-Received: by 2002:a05:620a:448c:b0:67d:4fe3:2b96 with SMTP id
 x12-20020a05620a448c00b0067d4fe32b96mr5288849qkp.663.1650248859720; 
 Sun, 17 Apr 2022 19:27:39 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 t198-20020a3746cf000000b0069c51337badsm6014134qka.45.2022.04.17.19.27.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:39 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:16 -0400
Message-Id: <20220418022733.56168-5-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [dm-5.19 PATCH 04/21] dm: simplify dm_io access in
 dm_split_and_process_bio
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use local variable instead of redudant access using ci.io

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 88ff5c3311aa..48f93c55c992 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1566,10 +1566,12 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 				     struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
+	struct dm_io *io;
 	struct bio *orig_bio = NULL;
 	blk_status_t error = BLK_STS_OK;
 
 	init_clone_info(&ci, md, map, bio);
+	io = ci.io;
 
 	if (bio->bi_opf & REQ_PREFLUSH) {
 		__send_empty_flush(&ci);
@@ -1578,14 +1580,14 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	}
 
 	error = __split_and_process_bio(&ci);
-	ci.io->map_task = NULL;
+	io->map_task = NULL;
 	if (error || !ci.sector_count)
 		goto out;
 
 	/*
 	 * Remainder must be passed to submit_bio_noacct() so it gets handled
 	 * *after* bios already submitted have been completely processed.
-	 * We take a clone of the original to store in ci.io->orig_bio to be
+	 * We take a clone of the original to store in io->orig_bio to be
 	 * used by dm_end_io_acct() and for dm_io_complete() to use for
 	 * completion handling.
 	 */
@@ -1597,9 +1599,9 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 out:
 	if (!orig_bio)
 		orig_bio = bio;
-	smp_store_release(&ci.io->orig_bio, orig_bio);
-	if (dm_io_flagged(ci.io, DM_IO_START_ACCT))
-		dm_start_io_acct(ci.io, NULL);
+	smp_store_release(&io->orig_bio, orig_bio);
+	if (dm_io_flagged(io, DM_IO_START_ACCT))
+		dm_start_io_acct(io, NULL);
 
 	/*
 	 * Drop the extra reference count for non-POLLED bio, and hold one
@@ -1611,7 +1613,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	if (error || !ci.submit_as_polled)
 		dm_io_dec_pending(ci.io, error);
 	else
-		dm_queue_poll_io(bio, ci.io);
+		dm_queue_poll_io(bio, io);
 }
 
 static void dm_submit_bio(struct bio *bio)
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

