Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8831C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644615883;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6MVucP/fDF8ZS1CBgTadW3aoe5MIX4xlizuAfl7d5iA=;
	b=ZShO5aVzSI/wPNM89inZqCuqLDMlhrWZLMF2xTS72GP9mnWcscU0bzdvC7W5U/qnPNWvoB
	na07woeIkzOjJAjGOap6vNeuypizCaYk6VFNOY39jX/KY0FD3QWtnrmsyQxdv4lrf72pxb
	FuKVPuI5bj5q28ZdvZQVH4KU/q29rZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-QGcDsAOqPAOoKdpUQGo2TA-1; Fri, 11 Feb 2022 16:44:40 -0500
X-MC-Unique: QGcDsAOqPAOoKdpUQGo2TA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F6131091DA2;
	Fri, 11 Feb 2022 21:44:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 823BA61095;
	Fri, 11 Feb 2022 21:44:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 57A601809CB9;
	Fri, 11 Feb 2022 21:44:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLffLs024810 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 302902024CBC; Fri, 11 Feb 2022 21:41:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C1A82027EB4
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E2A580280A
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:34 +0000 (UTC)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
	[209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-354-dkv78D7qPPSqB0lMkrfNGA-1; Fri, 11 Feb 2022 16:41:22 -0500
X-MC-Unique: dkv78D7qPPSqB0lMkrfNGA-1
Received: by mail-ot1-f71.google.com with SMTP id
	l34-20020a0568302b2200b005a22eb442daso6020271otv.15
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=/xjT8ts7rFxVnWvoCjYqEguiAAMtKDyhhIzyuUrbQZc=;
	b=Vg4+uSDMrLtovSNQnDBQp/qMi/moK4kg/NhQEn5TH25Rxc3c1EV27NslmUmQ5Ign4A
	YrCZ7yAtusSrz3kO42BIlgXWku5/xwXrSOroH/iFUGGmQKdZp1KSUpIWY/EspRwY3uGd
	WwdWVEfrYTIoH1d9Pwa+Y2bWEAYODHQDSzHeCn5TGGvLGEQZ4jsZnIl7F/zOEiw/J6RW
	f/T3nis+lZKwY7Uc3fBg4P9UWZC/lj0Hlc70xS4icouS+ZHQi1Y5u72Zt9YGOllZZnVl
	O3l0BaiEQm5a9wDfklgR44wAg3oqw4rFyGE/FqLpUMah2aG+MFtE2SyfuOjgWYiGXwbk
	z9jQ==
X-Gm-Message-State: AOAM532ZmxfIz4FeE4ln1fIFel4ieKpXmZjiWrMsLW6f/rxXuTny7Znt
	Fm6gk92mw1bx0K48ZGjO2fy562Pq8fOFpQ9TtNen+kFoZhGYy0dx1hEoujTws2mpT0EtGePYLMY
	pqKgVOwd2eIvLWQsIiKqfS7NHiIfYWmXfEnxdmN0hL4ojOOp4D1Q87EI/nwFpHz4bsw==
X-Received: by 2002:a05:6808:154:: with SMTP id
	h20mr1184676oie.103.1644615681707; 
	Fri, 11 Feb 2022 13:41:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHoO/6sjs/LcgGlmXM+T/Mc5GkMP/b9FDb0SWRQu9wbHgj1CE1v/5gDlYkTPnYQty7DeOZug==
X-Received: by 2002:a05:6808:154:: with SMTP id
	h20mr1184665oie.103.1644615681470; 
	Fri, 11 Feb 2022 13:41:21 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id z4sm2876168oad.21.2022.02.11.13.41.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:21 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:53 -0500
Message-Id: <20220211214057.40612-11-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 10/14] block: add bio_start_io_acct_remapped
	for the benefit of DM
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

DM needs the ability to account a clone bio's IO to the original
block_device. So add @orig_bdev argument to bio_start_io_acct_time.

Rename bio_start_io_acct_time to bio_start_io_acct_remapped.

Also, follow bio_end_io_acct and bio_end_io_acct_remapped pattern by
moving bio_start_io_acct to blkdev.h and have it call
bio_start_io_acct_remapped.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 24 ++++++++----------------
 drivers/md/dm.c        |  3 ++-
 include/linux/blkdev.h | 16 ++++++++++++++--
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index be8812f5489d..8f23be96c737 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1077,29 +1077,21 @@ static unsigned long __part_start_io_acct(struct block_device *part,
 }
 
 /**
- * bio_start_io_acct_time - start I/O accounting for bio based drivers
+ * bio_start_io_acct_remapped - start I/O accounting for bio based drivers
  * @bio:	bio to start account for
  * @start_time:	start time that should be passed back to bio_end_io_acct().
- */
-void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
-{
-	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-			     bio_op(bio), start_time);
-}
-EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
-
-/**
- * bio_start_io_acct - start I/O accounting for bio based drivers
- * @bio:	bio to start account for
+ * @orig_bdev:	block device that I/O must be accounted to.
  *
  * Returns the start time that should be passed back to bio_end_io_acct().
  */
-unsigned long bio_start_io_acct(struct bio *bio)
+unsigned long bio_start_io_acct_remapped(struct bio *bio,
+				unsigned long start_time,
+				struct block_device *orig_bdev)
 {
-	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
-				    bio_op(bio), jiffies);
+	return __part_start_io_acct(orig_bdev, bio_sectors(bio),
+				    bio_op(bio), start_time);
 }
-EXPORT_SYMBOL_GPL(bio_start_io_acct);
+EXPORT_SYMBOL_GPL(bio_start_io_acct_remapped);
 
 unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 				 unsigned int op)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 72686329f91e..c0177552b471 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -489,7 +489,8 @@ static void start_io_acct(struct dm_io *io)
 {
 	struct bio *bio = io->orig_bio;
 
-	bio_start_io_acct_time(bio, io->start_time);
+	bio_start_io_acct_remapped(bio, io->start_time,
+				   io->orig_bio->bi_bdev);
 
 	if (unlikely(dm_stats_used(&io->md->stats)))
 		dm_stats_account_io(&io->md->stats, bio_data_dir(bio),
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3bfc75a2a450..31d055d4a17e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1512,11 +1512,23 @@ unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
-void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
-unsigned long bio_start_io_acct(struct bio *bio);
+unsigned long bio_start_io_acct_remapped(struct bio *bio,
+				unsigned long start_time,
+				struct block_device *orig_bdev);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 		struct block_device *orig_bdev);
 
+/**
+ * bio_start_io_acct - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ *
+ * Returns the start time that should be passed back to bio_end_io_acct().
+ */
+static inline unsigned long bio_start_io_acct(struct bio *bio)
+{
+	return bio_start_io_acct_remapped(bio, jiffies, bio->bi_bdev);
+}
+
 /**
  * bio_end_io_acct - end I/O accounting for bio based drivers
  * @bio:	bio to end account for
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

