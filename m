Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE7CC433EF
	for <dm-devel@archiver.kernel.org>; Sat,  5 Mar 2022 02:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646446101;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bwuuxAIyg0g0VfLsElOdsdeRc2AmTzr+j+8sEgVYkiI=;
	b=SxaRxnQwY98p+NGvUiRivuOqpTYy7R7JKCRiXepiBKVKQpROR31Z7sflby2+4VwfcUTWNg
	jJ10ShO5781P1HDCz6Dj9k9jD0Q5DMUZavZLcm05RBkwLYa9UxEqJehgSXfVX8C5+HXXOT
	gTFP8rhe2a0+Rix/9tksxhwiYxh7Poo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-185-i5elujX5P1WcKLTnBgzupg-1; Fri, 04 Mar 2022 21:08:17 -0500
X-MC-Unique: i5elujX5P1WcKLTnBgzupg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 578731006AA5;
	Sat,  5 Mar 2022 02:08:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA5EA5F4FE;
	Sat,  5 Mar 2022 02:08:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4AA2A1809C98;
	Sat,  5 Mar 2022 02:08:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2252896o029093 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 21:08:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D61124328DA; Sat,  5 Mar 2022 02:08:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D258F4328C0
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:08:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B95C8811E78
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:08:09 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
	[209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-391-EYqbpZtaOmCgzwrA3ldXkQ-1; Fri, 04 Mar 2022 21:08:08 -0500
X-MC-Unique: EYqbpZtaOmCgzwrA3ldXkQ-1
Received: by mail-qk1-f199.google.com with SMTP id
	134-20020a37088c000000b0067af418b2f1so143507qki.16
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 18:08:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=kVWmWgbDLTD3/ZaHC1HftVSSj9oMx7XhGSZ/C09Jmt4=;
	b=Uwg9trEuZ+evrhQ3M0s+hLXHSORXpOxWkLudhwEsuI+xievCm3bZyyDXqZcaxagWGE
	GtSpi4BmLooyfw4ftr0z9ysOTGcHpV9kqGfo3wY0eYlvLKuVJtgSAx9ym7/NDUoQja+s
	+qeaZWe2hWR1cpKWaJ9TCjRnaZ8ki9uouH9mhAhaS+25t4k0sm5c4gkav5s1ga8CNWOR
	MB5fp5nPhAfWCRvDdpSNLFCBT85/uIv80GIfbomz5fyxFXoydaHbjcFtIdIFjJ148nJA
	GFaX80byrUXDGuE0W5k0fLnMioUeVTsymewKnDa0iLIZqjYPe3bUx+u8QQOjE0subbXp
	MPQQ==
X-Gm-Message-State: AOAM533hPeF9jfieShLGe0lzoWTp0YwrFM8NAbtlSzSEdrPpwHoS5uFt
	2nbinuTWdVwpgaXj/oF4hNR5Z07nBUPzWsb/lasw9C6C/kn1r15XWfz856OMUwCrMH9eQO4Wj5V
	I19Uo2aB466KykQ==
X-Received: by 2002:a05:622a:246:b0:2de:8d73:dd0f with SMTP id
	c6-20020a05622a024600b002de8d73dd0fmr1391666qtx.650.1646446088001;
	Fri, 04 Mar 2022 18:08:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyr2VaGp9pPfltICqCfX6F+ZJRP2Non3wbaYp1PLuwyJwHknB3GBJo2GW5pQUlbApKqmIl1qw==
X-Received: by 2002:a05:622a:246:b0:2de:8d73:dd0f with SMTP id
	c6-20020a05622a024600b002de8d73dd0fmr1391652qtx.650.1646446087760;
	Fri, 04 Mar 2022 18:08:07 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	f14-20020ac8068e000000b002dd1bc00eadsm4006757qth.93.2022.03.04.18.08.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Mar 2022 18:08:07 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Fri,  4 Mar 2022 21:08:03 -0500
Message-Id: <20220305020804.54010-2-snitzer@redhat.com>
In-Reply-To: <20220305020804.54010-1-snitzer@redhat.com>
References: <20220305020804.54010-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
	ming.lei@redhat.com
Subject: [dm-devel] [PATCH v5 1/2] block: add ->poll_bio to
	block_device_operations
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

