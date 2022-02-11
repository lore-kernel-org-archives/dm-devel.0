Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB390C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616029;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p0QlBlVKaBM0QSSBukV5sCW9u5BU22NyYI2a1jEWO5s=;
	b=gkkM9VkZcmj0D3zxwJoVdHjGCclHhG+U1Svp02werad9AN5Q9m9uxtXf+GCDDi8wyHMl4U
	ldo3s5R/iVrVUfxwI5htVs90aOQftmGAZ7Fk43sNFsF5Ugc15cbnql1f5dfCK1ojMN8s00
	UOF5jk0Bkouys1ax8UqeO0rs1jWJUdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-YcGDz_TsPSGO5Qa43ZfYkQ-1; Fri, 11 Feb 2022 16:47:05 -0500
X-MC-Unique: YcGDz_TsPSGO5Qa43ZfYkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E272A94DD6;
	Fri, 11 Feb 2022 21:46:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8C514EC7E;
	Fri, 11 Feb 2022 21:46:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A27014CA93;
	Fri, 11 Feb 2022 21:46:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfDNX024707 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 48834111142C; Fri, 11 Feb 2022 21:41:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44A0B1111424
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88DAD899ED4
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:07 +0000 (UTC)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
	[209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-20-p6LYesHnOciViPBlRcN69w-1; Fri, 11 Feb 2022 16:41:05 -0500
X-MC-Unique: p6LYesHnOciViPBlRcN69w-1
Received: by mail-ot1-f71.google.com with SMTP id
	j2-20020a9d7d82000000b005a12a0fb4b0so6043571otn.5
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=pWHYMVDLAmByoRC12NPUdmnY+6Z0+I5UDqE1eD4oqHM=;
	b=2qOGJdlYadbIh6TWk5in6Al/RICBgez6TyfzrgNMmY0EFe+WjBZGNh0IcU5LCiGS6E
	xKaq/I1deomfHA5i0ZHHmVE+QhlQlQGarq/0YUYt1brvfuKYNxn10ua5gWXzilAROQxF
	eRsNf8LaVgunvRkzznuPhcSYInYF/elsQ+X2tTJz4eBwDQhXJohc0qUO15f+Ou63XM3F
	2zO9EV7LylGRHCSY/09E64Odf67rLcnqVO/bmb8xGob36Nws2UhwY8NHjRhK2v6PBX6M
	wrmzkxWvr+cpUBvtNerpMIYtuq/F1hNqLV0TM9VtmSa3XHcXAuJrX5X2gQo8tETr2ghh
	rAnw==
X-Gm-Message-State: AOAM533emdM4JNfXyfGQTmYDwLkEnZoXvpIckbNT0t0Men69upp+cHnK
	kUOMI5CzGLcDMePgFpGaXzO3Iu4Qv9PD6JIqfbX7Yg+MbVPRpuUaAIsptNvbC5BB5B4qpCrDkYk
	axd98XSb/dxqUCTXLAkl822k4hDAn7L1DCxnDt0V1Q60t9mfzzR9ElP5ztTVV0qPQjw==
X-Received: by 2002:a05:6870:1318:: with SMTP id
	24mr771265oab.28.1644615664795; 
	Fri, 11 Feb 2022 13:41:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgWYNb7rgOCq30q5kQSDDFSZce9nmYQDDcneTKvKmUg8mfutDHI9Zx5YMSBZTnPEY38/Irbg==
X-Received: by 2002:a05:6870:1318:: with SMTP id
	24mr771259oab.28.1644615664550; 
	Fri, 11 Feb 2022 13:41:04 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id q4sm9500794otk.39.2022.02.11.13.41.03
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:03 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:44 -0500
Message-Id: <20220211214057.40612-2-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 01/14] dm: rename split functions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Rename __split_and_process_bio to dm_split_and_process_bio.
Rename __split_and_process_non_flush to __split_and_process_bio.

Also fix a stale comment and whitespace.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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

