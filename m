Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F65C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644615858;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0/f7zuaFzOJLcUwbkrUrbw2L7OtuRMfHaEdsJ9jfmxE=;
	b=P/boYegJ8Ysl71zsfmbS3g+7pVtIp4yLoIdWD44WTOgVardFgvdLa+Obo3U3krgWILba2h
	IKly147Mn2B9oV5MWqC9c+ENgKC/FAHdAud9w1xL8jEqbcgar7KssG5/GHX991fhNpmjD9
	d4T6s5iSejcg+9oDf2JPb2aE9OYZnhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-iaMe-I_iOROLTtEqESTftg-1; Fri, 11 Feb 2022 16:44:17 -0500
X-MC-Unique: iaMe-I_iOROLTtEqESTftg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C4971091DA1;
	Fri, 11 Feb 2022 21:44:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13606E729;
	Fri, 11 Feb 2022 21:44:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 606734BB7C;
	Fri, 11 Feb 2022 21:44:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfILK024718 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 365F740E7F17; Fri, 11 Feb 2022 21:41:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 321AA40E7F0B
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A3DD1C07855
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:15 +0000 (UTC)
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
	[209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-614-XPtFDTBiMIeXMcW6O-DD7Q-1; Fri, 11 Feb 2022 16:41:13 -0500
X-MC-Unique: XPtFDTBiMIeXMcW6O-DD7Q-1
Received: by mail-oo1-f72.google.com with SMTP id
	t16-20020a4ae9b0000000b0031877e91c80so2775722ood.13
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=91++qBctEBqt/WcCJjsVysQVehP+OlczjZE5uyGHky0=;
	b=x/3Z4vhdUzCHLysKtTWTzQLIB2cpLlfLSaywNt49NlHuyoQ4VW+8lwMW5lMUciwX/7
	nnUC75vbuRFPPdUh58r5VEFc4e3qsvh3TvC9I5ALKGqH06MLg72nbFARu+XizerwUoj3
	lKj/7c5z4c0MSYMhvMhJ1UR7U1lO2SOai8mJn2GcR7J1pk99zwyI9vWbT8qNfWrbfVNg
	KwXQpHbAPm4LTyxD5GlaxglNVBLsrjvi/RWI+KpeFIkZxLURTNgOwMi0bI8U4uq8GuQy
	26YgaGIfEo8OwCTBJf6zpelMsLtgxLWAKjDIAFMEJ3ZLhhvhzMdzNnJhzV99JT6T95MF
	zoXA==
X-Gm-Message-State: AOAM533yQxlo6gHlqeIW1+tGK9XUarFM8zUTFxCBLP9axuESiAooJjAX
	9nJMcteLYgvxBtD4lUTF7EdebnGgnaielKEGUM1iwciUjyViJU5LzoygnTylj5FBnsMFUPv4U4R
	zSv2uLGs5R2meXe1hxFVhGNF9+wNbwAstuIsQMjTMQ8JDbornPKYFoU4qlvVsiuMKJg==
X-Received: by 2002:a05:6808:bcb:: with SMTP id
	o11mr1188061oik.2.1644615670577; 
	Fri, 11 Feb 2022 13:41:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjJHjKjIojAV77eZvxdta7gUDgvuGSRfVHpC7eifGNL5o3XbrHtskQjvhxdmdPuuAqN+mUCw==
X-Received: by 2002:a05:6808:bcb:: with SMTP id
	o11mr1188019oik.2.1644615669127; 
	Fri, 11 Feb 2022 13:41:09 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id p5sm9852027oou.39.2022.02.11.13.41.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:08 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:46 -0500
Message-Id: <20220211214057.40612-4-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 03/14] dm: refactor dm_split_and_process_bio a
	bit
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove needless branching and indentation. Leaves code to catch
malformed op_is_zone_mgmt bios (they shouldn't have a payload).

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 54 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2f1942b61d48..60a047de620f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1375,7 +1375,13 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 {
 	ci->map = map;
 	ci->io = alloc_io(md, bio);
+	ci->bio = bio;
 	ci->sector = bio->bi_iter.bi_sector;
+	ci->sector_count = bio_sectors(bio);
+
+	/* Shouldn't happen but sector_count was being set to 0 so... */
+	if (WARN_ON_ONCE(op_is_zone_mgmt(bio_op(bio)) && ci->sector_count))
+		ci->sector_count = 0;
 }
 
 /*
@@ -1385,6 +1391,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 				     struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
+	struct bio *b;
 	int error = 0;
 
 	init_clone_info(&ci, md, map, bio);
@@ -1392,34 +1399,29 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	if (bio->bi_opf & REQ_PREFLUSH) {
 		error = __send_empty_flush(&ci);
 		/* dm_io_dec_pending submits any data associated with flush */
-	} else if (op_is_zone_mgmt(bio_op(bio))) {
-		ci.bio = bio;
-		ci.sector_count = 0;
-		error = __split_and_process_bio(&ci);
-	} else {
-		ci.bio = bio;
-		ci.sector_count = bio_sectors(bio);
-		error = __split_and_process_bio(&ci);
-		if (ci.sector_count && !error) {
-			/*
-			 * Remainder must be passed to submit_bio_noacct()
-			 * so that it gets handled *after* bios already submitted
-			 * have been completely processed.
-			 * We take a clone of the original to store in
-			 * ci.io->orig_bio to be used by end_io_acct() and for
-			 * dm_io_dec_pending() to use for completion handling.
-			 */
-			struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
-						  GFP_NOIO, &md->queue->bio_split);
-			ci.io->orig_bio = b;
-
-			bio_chain(b, bio);
-			trace_block_split(b, bio->bi_iter.bi_sector);
-			submit_bio_noacct(bio);
-		}
+		goto out;
 	}
-	start_io_acct(ci.io);
 
+	error = __split_and_process_bio(&ci);
+	if (error || !ci.sector_count)
+		goto out;
+
+	/*
+	 * Remainder must be passed to submit_bio_noacct() so it gets handled
+	 * *after* bios already submitted have been completely processed.
+	 * We take a clone of the original to store in ci.io->orig_bio to be
+	 * used by end_io_acct() and for dm_io_dec_pending() to use for
+	 * completion handling.
+	 */
+	b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
+		      GFP_NOIO, &md->queue->bio_split);
+	ci.io->orig_bio = b;
+
+	bio_chain(b, bio);
+	trace_block_split(b, bio->bi_iter.bi_sector);
+	submit_bio_noacct(bio);
+out:
+	start_io_acct(ci.io);
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
 }
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

