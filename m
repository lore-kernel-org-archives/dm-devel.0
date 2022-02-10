Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB0FC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532996;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1NNstZck6QaNsyN+snY++Z1Od1f/LlrQ/HE5U2jnNCo=;
	b=THGzmr/cykU6OCExcFcgC2vU7x/bgNBK3nqLyIdVYvVvAhOh5/P4gZAf/MuzKZ0Hj0DoAP
	8czwKDM7NrpmtDNR0DnHyuCEZgAMfqGvQJMEm4Eb3IHChMA5Kt7N5rv67ydamYITsy4wPo
	3qOQJUYjKKtbJ+Lz0LE1yd2Gq4QLW+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-w-j5xipeM5WcI2_LS7Xy0w-1; Thu, 10 Feb 2022 17:43:13 -0500
X-MC-Unique: w-j5xipeM5WcI2_LS7Xy0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08AB483DD20;
	Thu, 10 Feb 2022 22:43:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E43CC46983;
	Thu, 10 Feb 2022 22:43:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BA70A1806D2D;
	Thu, 10 Feb 2022 22:43:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMccU5014767 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F2F4CC080AE; Thu, 10 Feb 2022 22:38:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF2EEC07F5D
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D58983803916
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:37 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
	[209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-538-3bfscm5xOiyQB-riMzQDsA-1; Thu, 10 Feb 2022 17:38:36 -0500
X-MC-Unique: 3bfscm5xOiyQB-riMzQDsA-1
Received: by mail-qt1-f198.google.com with SMTP id
	z1-20020ac87ca1000000b002d11bc8d795so5506865qtv.17
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=Aelm5YgrbgtRcjh/7giXHAljK3Fp2NuUOh2H4+pquFs=;
	b=CzGreNh8pVsS00ghq1rKvm4fnJRtOG7HqeXjSE4SK0wN0UD5QqzB8FK+QwblpxpfTq
	ZXTIlj83bnB+ED/h3QB2a6/s93gHX+Ylyg/CoK/9GWRM/jWtcbQapFrQ+Aeo66me3s6I
	DvL0brMd+s2DqF7BwVR7Z7zoJHKY9FypeJYAasFg7swScItvEnmubXAqJtDQkJcNkeKq
	2JyqwOuS03UVhSrG7nmt1S3AxNxF6AgKeSeAeQaVGbriHpnpv/xTJ62X00OYjKBkh82g
	0n/HhJbegVI0UuFgTyszKhlKddBuHkrLWBfcbqE4ejwS5xA0vm1aT/7/UK7EPkmCv0mp
	XXTg==
X-Gm-Message-State: AOAM533H3s4v26h6X1UY5ucKSD37Qfy/Zs3fueO9F+eXNJlcERVd8xwe
	yqVUJ1t7VeAKukFG2318e2VMwKwneK5+aEEqsXWYtWxQgEoMR1SFKupIYohLba2JOvlUXNK91DP
	i1CKJMpKXStLNeqib7BArucx0dA+sKXTwunlph7ZwIMepLYKebM57zc4FLsoBmAWuHA==
X-Received: by 2002:a37:aa08:: with SMTP id t8mr5051598qke.773.1644532715689; 
	Thu, 10 Feb 2022 14:38:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQixOwmD12PZY5UkjFPZ06AUK+aTARpLaV0mdw92GohG9RThiH7FoXYWT3NRL1ycsq0RFu0w==
X-Received: by 2002:a37:aa08:: with SMTP id t8mr5051585qke.773.1644532715338; 
	Thu, 10 Feb 2022 14:38:35 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	w5sm10477933qko.34.2022.02.10.14.38.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:34 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:19 -0500
Message-Id: <20220210223832.99412-2-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 01/14] dm: rename split functions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Rename __split_and_process_bio to dm_split_and_process_bio.
Rename __split_and_process_non_flush to __split_and_process_bio.

Also fix a stale comment and whitespace.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab9cc91931f9..2cecb8832936 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1359,7 +1359,7 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 /*
  * Select the correct strategy for processing a non-flush bio.
  */
-static int __split_and_process_non_flush(struct clone_info *ci)
+static int __split_and_process_bio(struct clone_info *ci)
 {
 	struct dm_target *ti;
 	unsigned len;
@@ -1395,8 +1395,8 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
-static void __split_and_process_bio(struct mapped_device *md,
-					struct dm_table *map, struct bio *bio)
+static void dm_split_and_process_bio(struct mapped_device *md,
+				     struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
 	int error = 0;
@@ -1409,19 +1409,19 @@ static void __split_and_process_bio(struct mapped_device *md,
 	} else if (op_is_zone_mgmt(bio_op(bio))) {
 		ci.bio = bio;
 		ci.sector_count = 0;
-		error = __split_and_process_non_flush(&ci);
+		error = __split_and_process_bio(&ci);
 	} else {
 		ci.bio = bio;
 		ci.sector_count = bio_sectors(bio);
-		error = __split_and_process_non_flush(&ci);
+		error = __split_and_process_bio(&ci);
 		if (ci.sector_count && !error) {
 			/*
 			 * Remainder must be passed to submit_bio_noacct()
 			 * so that it gets handled *after* bios already submitted
 			 * have been completely processed.
 			 * We take a clone of the original to store in
-			 * ci.io->orig_bio to be used by end_io_acct() and
-			 * for dec_pending to use for completion handling.
+			 * ci.io->orig_bio to be used by end_io_acct() and for
+			 * dm_io_dec_pending() to use for completion handling.
 			 */
 			struct bio *b = bio_split(bio, bio_sectors(bio) - ci.sector_count,
 						  GFP_NOIO, &md->queue->bio_split);
@@ -1470,7 +1470,7 @@ static void dm_submit_bio(struct bio *bio)
 	if (is_abnormal_io(bio))
 		blk_queue_split(&bio);
 
-	__split_and_process_bio(md, map, bio);
+	dm_split_and_process_bio(md, map, bio);
 out:
 	dm_put_live_table(md, srcu_idx);
 }
@@ -2283,11 +2283,11 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	/*
 	 * Here we must make sure that no processes are submitting requests
 	 * to target drivers i.e. no one may be executing
-	 * __split_and_process_bio from dm_submit_bio.
+	 * dm_split_and_process_bio from dm_submit_bio.
 	 *
-	 * To get all processes out of __split_and_process_bio in dm_submit_bio,
+	 * To get all processes out of dm_split_and_process_bio in dm_submit_bio,
 	 * we take the write lock. To prevent any process from reentering
-	 * __split_and_process_bio from dm_submit_bio and quiesce the thread
+	 * dm_split_and_process_bio from dm_submit_bio and quiesce the thread
 	 * (dm_wq_work), we set DMF_BLOCK_IO_FOR_SUSPEND and call
 	 * flush_workqueue(md->wq).
 	 */
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

