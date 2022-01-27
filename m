Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52BB1C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 22:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643324227;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LPWr3ykwkO/t93MmEQqErnSDVP8tnNk02jNvCVJlyMY=;
	b=ZqqzWWcHIDxtMThTZYde+AdGQyk2xQUm/OiIVDwYflc8c/7AUcoZEW6Pj/+BEqoBFlRsMK
	x3OWoZb/SnwP/+6Op5ZsClrZ51yOo01SfPKGp/gMUhx+FuHG4A8yCD0xaNLUdbf3g4daKu
	hPvVyD5ILHWwNkxklbnTn/blKFph+oI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-pf2rKCZOOk-cyHQ8Uyd7Zw-1; Thu, 27 Jan 2022 17:57:03 -0500
X-MC-Unique: pf2rKCZOOk-cyHQ8Uyd7Zw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF4D3187666D;
	Thu, 27 Jan 2022 22:56:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4599856F8B;
	Thu, 27 Jan 2022 22:56:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B70C11809C87;
	Thu, 27 Jan 2022 22:56:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RMurPn019699 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 17:56:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4559240885BD; Thu, 27 Jan 2022 22:56:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 417F040885BC
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 280D1800B29
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:53 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-267-dd5h5prvNd2Zq5PWjfCYgA-1; Thu, 27 Jan 2022 17:56:52 -0500
X-MC-Unique: dd5h5prvNd2Zq5PWjfCYgA-1
Received: by mail-qv1-f69.google.com with SMTP id
	t2-20020ad45bc2000000b00424bc599ef3so4488277qvt.22
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 14:56:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=LPT/xXbA8dMnjNDPrd3foEhpTUzqW1ZlXYJLQcHQMDc=;
	b=b5o8sHx0fQu1Vn0O8J1XyE/fjXhnYE8OpXIpYM9pdh+rRd1j2CMyGKhlv1tnDYmTq1
	2EaJIxtoiJhkJ0WlverXDxl17OIxopfEFOPRfQDOzBzPPq80YLh+62dOyO18apTzmKfW
	bAjKIfV9o321LXGIf/GPLVNetc8nQuKrgaSrP6Yn6mwoL2gOiPU90ZYNPfqq5u5tgudX
	xsq8vsb2jKzEHYybOiVR3duuvNbSzr5iXz8jrYirtpAv+G8Cqz92b3Dg37sYiyMD0qdR
	zh0XsCrkADMOjFLdkrqLOqsZYL8Ni/ekwNLUJtiqw3aJtezjD9iffev9NzXClVXdSBUf
	KTBw==
X-Gm-Message-State: AOAM533fbr80JfnVu7At265PUAdudEiAjwoFH74MWYNNKkoOPNd/Don3
	rExpQoEzcUpPQAO4aiAFnW6vprj+ZOQLRIrjrHUg3u448eF55rAUy+kxF4Fh8rgg1/EWDo0Wy4u
	885icGepoLbF2Wg==
X-Received: by 2002:a05:620a:141a:: with SMTP id
	d26mr4086406qkj.403.1643324211287; 
	Thu, 27 Jan 2022 14:56:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvpuCni4WvV5PNyzRGhC0OXvCVSabWWqJ2hiDnj4Ya0PLPWe4YLLKbvK6oGvLtvu8SjLW8yw==
X-Received: by 2002:a05:620a:141a:: with SMTP id
	d26mr4086396qkj.403.1643324211073; 
	Thu, 27 Jan 2022 14:56:51 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id i5sm2205277qkn.19.2022.01.27.14.56.50
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 14:56:50 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 17:56:46 -0500
Message-Id: <20220127225648.28729-2-snitzer@redhat.com>
In-Reply-To: <20220127225648.28729-1-snitzer@redhat.com>
References: <20220127225648.28729-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v2 1/3] block: add bio_start_io_acct_time() to
	control start_time
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

bio_start_io_acct_time() interface is like bio_start_io_acct() that
allows start_time to be passed in. This gives drivers the ability to
defer starting accounting until after IO is issued (but possibily not
entirely due to bio splitting).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 25 +++++++++++++++++++------
 include/linux/blkdev.h |  1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 97f8bc8d3a79..d93e3bb9a769 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1061,20 +1061,32 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 }
 
 static unsigned long __part_start_io_acct(struct block_device *part,
-					  unsigned int sectors, unsigned int op)
+					  unsigned int sectors, unsigned int op,
+					  unsigned long start_time)
 {
 	const int sgrp = op_stat_group(op);
-	unsigned long now = READ_ONCE(jiffies);
 
 	part_stat_lock();
-	update_io_ticks(part, now, false);
+	update_io_ticks(part, start_time, false);
 	part_stat_inc(part, ios[sgrp]);
 	part_stat_add(part, sectors[sgrp], sectors);
 	part_stat_local_inc(part, in_flight[op_is_write(op)]);
 	part_stat_unlock();
 
-	return now;
+	return start_time;
+}
+
+/**
+ * bio_start_io_acct_time - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ * @start_time:	start time that should be passed back to bio_end_io_acct().
+ */
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time)
+{
+	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+			     bio_op(bio), start_time);
 }
+EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
 
 /**
  * bio_start_io_acct - start I/O accounting for bio based drivers
@@ -1084,14 +1096,15 @@ static unsigned long __part_start_io_acct(struct block_device *part,
  */
 unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio), bio_op(bio));
+	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+				    bio_op(bio), jiffies);
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 				 unsigned int op)
 {
-	return __part_start_io_acct(disk->part0, sectors, op);
+	return __part_start_io_acct(disk->part0, sectors, op, jiffies);
 }
 EXPORT_SYMBOL(disk_start_io_acct);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9c95df26fc26..f35aea98bc35 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1258,6 +1258,7 @@ unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
+void bio_start_io_acct_time(struct bio *bio, unsigned long start_time);
 unsigned long bio_start_io_acct(struct bio *bio);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 		struct block_device *orig_bdev);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

