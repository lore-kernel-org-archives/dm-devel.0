Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBAE1C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532996;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=to49Ck+IW95x8PnNGyiwKPzpyaQrwnMCLRbTMqvVj1Q=;
	b=HfVYwB6Qmtb1bM4TZ3V+njDibjf/hVb8q8KHMc8p6RA5tVpA89gGVTn6Bz64L/NXSgYwNY
	TrIww2j7h5HxxaWCs1NJqEpdQLdNho7+RDD1kmCbU5r4FFpfigOK1QILm4X+daAIq+c7zQ
	ge9XGCsIsG9I+qkFOsdYDNz70Deyo34=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-G7dqHsr_PTuMM4ZKpukU9w-1; Thu, 10 Feb 2022 17:43:15 -0500
X-MC-Unique: G7dqHsr_PTuMM4ZKpukU9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E921D18C8C01;
	Thu, 10 Feb 2022 22:43:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C70DEE715;
	Thu, 10 Feb 2022 22:43:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A270B4A700;
	Thu, 10 Feb 2022 22:43:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcedY014786 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8A4C5401E7B; Thu, 10 Feb 2022 22:38:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86976401E9F
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BDC61066559
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:40 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-561-n1wKq_K5MEGG9ruqB_jyjQ-1; Thu, 10 Feb 2022 17:38:39 -0500
X-MC-Unique: n1wKq_K5MEGG9ruqB_jyjQ-1
Received: by mail-qt1-f197.google.com with SMTP id
	w25-20020ac84d19000000b002d2966d66a8so5518307qtv.18
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=Dmbgb58sJS1NVsv2MiEVE8minE/+DuIbbyXB20Z/ekE=;
	b=4l1SHxZxuCohKZlAdMT79pUGhoOb98H5AoywL8v3hWPIg6k2p0FlD46Nxk95aN6XUI
	M9ka+XSrUXCKDx7MP77KZkvSnv+/D8sQe1wDapcTlpSeHNj8ps/bwjsx+asil2JXMwaY
	M/XfddgR0v7wFUdHm6SBunnRKDwb2Eqzlv5PVShCJAAeB8INEo5JZP1Dm2orIxuUpwMz
	vtPK7BVZNQXze5iXPpIFoj+O4AT89pvu2j7X5DvFqZlOWefLdOtHcJW3Sfo5l5PSulbh
	fswqQ33niaTXuDKk4jJTieDmfCobVzWDU/CZ6ALX9j1H8vdo0uLa/rbwE+G4FZM7X8Mb
	5PhA==
X-Gm-Message-State: AOAM531zuYHXpypLnS+I5qCy9DGdssf+IMnM8HibtlkSqdWx98PPN8X4
	GF0prXfu0SzxEfZs28Oqnoz4Hvm1F0pFJnS0iIhhxpxEqMz9FS6USjM6JsJU6UAbrL8HyPGDrP3
	+ZRVwHqOxFLyj8Cs4+jfuSJ+VdHcnMSyMKipB8t9TBbCBRS2Wg+5Xylb2x3FAV41mjA==
X-Received: by 2002:a37:aac9:: with SMTP id t192mr4866680qke.118.1644532718361;
	Thu, 10 Feb 2022 14:38:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTEaXKZxCVPUG1VrVNIHN3jO/XBixkQ3uTQnAxaqJnd5AV3P7OpyaOaqfg8/NSZ6NUsUbCKA==
X-Received: by 2002:a37:aac9:: with SMTP id t192mr4866671qke.118.1644532718037;
	Thu, 10 Feb 2022 14:38:38 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	f4sm10753431qko.72.2022.02.10.14.38.37
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:37 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:21 -0500
Message-Id: <20220210223832.99412-4-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 03/14] dm: refactor dm_split_and_process_bio a bit
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

Remove needless branching. Leaves code to catch malformed
op_is_zone_mgmt bios (they shouldn't have a payload).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 51 ++++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2f1942b61d48..56734aae718d 100644
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
@@ -1392,34 +1398,29 @@ static void dm_split_and_process_bio(struct mapped_device *md,
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
+		goto out;
+	}
 
-			bio_chain(b, bio);
-			trace_block_split(b, bio->bi_iter.bi_sector);
-			submit_bio_noacct(bio);
-		}
+	error = __split_and_process_bio(&ci);
+	if (ci.sector_count && !error) {
+		/*
+		 * Remainder must be passed to submit_bio_noacct()
+		 * so that it gets handled *after* bios already submitted
+		 * have been completely processed.
+		 * We take a clone of the original to store in
+		 * ci.io->orig_bio to be used by end_io_acct() and for
+		 * dm_io_dec_pending() to use for completion handling.
+		 */
+		struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
+					  GFP_NOIO, &md->queue->bio_split);
+		ci.io->orig_bio = b;
+
+		bio_chain(b, bio);
+		trace_block_split(b, bio->bi_iter.bi_sector);
+		submit_bio_noacct(bio);
 	}
+out:
 	start_io_acct(ci.io);
-
 	/* drop the extra reference count */
 	dm_io_dec_pending(ci.io, errno_to_blk_status(error));
 }
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

