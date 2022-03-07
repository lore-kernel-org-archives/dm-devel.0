Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20720C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646679195;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GFz+Bm1YWWtOFUcB9jnK+hDzUJtyBMvpomM/aj1VXl8=;
	b=GEpcmSe8jva7aBnBPquGY8DJ050bUqJ8HvLffahfSNQQQ3klkvBf9WEBsFDyC+y5PD/0/n
	m5vCsf+LC9HgtMUWkHUStjS10QTGxGzcI/NxduztKpLDxMYEIPg41VN/UsXV/Rb1rm/j7A
	Q6nda63NoD4NFBAMqBSew9vualmMV/U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-rDpuIbM2Ob6ehrWxg0pH8w-1; Mon, 07 Mar 2022 13:53:12 -0500
X-MC-Unique: rDpuIbM2Ob6ehrWxg0pH8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0509D811E76;
	Mon,  7 Mar 2022 18:53:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E50240CFD06;
	Mon,  7 Mar 2022 18:53:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2445319305AF;
	Mon,  7 Mar 2022 18:53:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 29DF319305AF
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 18:53:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E06E5E3A33; Mon,  7 Mar 2022 18:53:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09EC25B2957
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 18:53:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2FD0857051
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 18:53:07 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-Xo8fNY8UPE2ZZRTny9DCOA-1; Mon, 07 Mar 2022 13:53:06 -0500
X-MC-Unique: Xo8fNY8UPE2ZZRTny9DCOA-1
Received: by mail-qk1-f198.google.com with SMTP id
 s71-20020a37a94a000000b00648c7f2b289so12231904qke.12
 for <dm-devel@redhat.com>; Mon, 07 Mar 2022 10:53:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=2B5SMd3ysspU+OxmnlZrCO2H0toLWPZVLN6f+cgeOE8=;
 b=MJThhXOPsA05/iRPf+u2UjcaB/ShntsfEU0VPnuYucSA7STDdYSohAoBVP1jOHWNKC
 G7YbB4O04G1XfubipLXEFV6IyWCJg5+V3BIdRAfiq8xhNoaSKyA5/DXLszGfTK2FPPaM
 eQn4Vq1mzjiubd81fM7xBeLohfjVwGtzfgtuDvaoETSzfPHw7cbkgkktUiXhTICE9R6V
 wmAC5vOg9e6Wdbqp88gl+D2FB2BFq3bCEHNfUU3w07B//JlZO7tFURJXu05dkDRnppVA
 opiTzIQp9a4Wfaw49yYb2ttLP0igCNRheXOA1i0Q55EkcJVpjS7zwsl0GapyC7xMFAGB
 nbBA==
X-Gm-Message-State: AOAM532JyrOxscojECM20dKMc8DktNXcbBJ95B8Gk/0XSOQGpvy28Oei
 Mf0bdh4xQuY6oBBgmtmp94lqVvdb38bYcgSVjmWH+MFuxybQv8a8fuqtBWviCBimPfeAA1nfmRP
 1EM3V3xPdX8WkYQ==
X-Received: by 2002:a05:620a:430b:b0:67b:13fa:c50e with SMTP id
 u11-20020a05620a430b00b0067b13fac50emr4945514qko.18.1646679186082; 
 Mon, 07 Mar 2022 10:53:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkcWlcshZ/U52q1Ww7b4h8TdCYhTr+j3ZU6fcVu10IBVPZ+Eh+d9No/laKNH5+9bDdV6MNBA==
X-Received: by 2002:a05:620a:430b:b0:67b:13fa:c50e with SMTP id
 u11-20020a05620a430b00b0067b13fac50emr4945498qko.18.1646679185528; 
 Mon, 07 Mar 2022 10:53:05 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 f19-20020ac859d3000000b002de4d014733sm9217609qtf.13.2022.03.07.10.53.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Mar 2022 10:53:05 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Mon,  7 Mar 2022 13:53:02 -0500
Message-Id: <20220307185303.71201-2-snitzer@redhat.com>
In-Reply-To: <20220307185303.71201-1-snitzer@redhat.com>
References: <20220307185303.71201-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v6 1/2] block: add ->poll_bio to
 block_device_operations
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
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

From: Ming Lei <ming.lei@redhat.com>

Prepare for supporting IO polling for bio-based driver.

Add ->poll_bio callback so that bio-based driver can provide their own
logic for polling bio.

Also fix ->submit_bio_bio typo in comment block above
__submit_bio_noacct.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 14 +++++++++-----
 block/genhd.c          |  4 ++++
 include/linux/blkdev.h |  2 ++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 94bf37f8e61d..ce08f0aa9dfc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -708,7 +708,7 @@ static void __submit_bio(struct bio *bio)
  *
  * bio_list_on_stack[0] contains bios submitted by the current ->submit_bio.
  * bio_list_on_stack[1] contains bios that were submitted before the current
- *	->submit_bio_bio, but that haven't been processed yet.
+ *	->submit_bio, but that haven't been processed yet.
  */
 static void __submit_bio_noacct(struct bio *bio)
 {
@@ -975,7 +975,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
-	int ret;
+	int ret = 0;
 
 	if (cookie == BLK_QC_T_NONE ||
 	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
@@ -985,10 +985,14 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 
 	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
 		return 0;
-	if (WARN_ON_ONCE(!queue_is_mq(q)))
-		ret = 0;	/* not yet implemented, should not happen */
-	else
+	if (queue_is_mq(q)) {
 		ret = blk_mq_poll(q, cookie, iob, flags);
+	} else {
+		struct gendisk *disk = q->disk;
+
+		if (disk && disk->fops->poll_bio)
+			ret = disk->fops->poll_bio(bio, iob, flags);
+	}
 	blk_queue_exit(q);
 	return ret;
 }
diff --git a/block/genhd.c b/block/genhd.c
index e351fac41bf2..1ed46a6f94f5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -410,6 +410,10 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	struct device *ddev = disk_to_dev(disk);
 	int ret;
 
+	/* Only makes sense for bio-based to set ->poll_bio */
+	if (queue_is_mq(disk->queue) && disk->fops->poll_bio)
+		return -EINVAL;
+
 	/*
 	 * The disk queue should now be all set with enough information about
 	 * the device for the elevator code to pick an adequate default
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f757f9c2871f..51f1b1ddbed2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1455,6 +1455,8 @@ enum blk_unique_id {
 
 struct block_device_operations {
 	void (*submit_bio)(struct bio *bio);
+	int (*poll_bio)(struct bio *bio, struct io_comp_batch *iob,
+			unsigned int flags);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

