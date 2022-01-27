Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40ECAC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 19:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643310481;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cxrj+N7P9hq3A4mfqICWctBXmjAbOF8vvuTVH51yicA=;
	b=A4jippUx+WB5q54F3GmCanICQWvzQsaZrr4qVadNy9ogDo4zuXc9e6t7xnHy4M/w/n9wra
	6I602+PUHZQvzhikYmQEBwVg5QPEQxBlgtMqIR4INTyMe4ERCSzUL03+LWYMwN3C8mO02s
	acK3nck7Bo5BfbsZ0phqQkehIm8Us30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-_n5JLmc5NH2SZwiiznUWGw-1; Thu, 27 Jan 2022 14:07:57 -0500
X-MC-Unique: _n5JLmc5NH2SZwiiznUWGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12E4D18C8C04;
	Thu, 27 Jan 2022 19:07:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E965F5D9DE;
	Thu, 27 Jan 2022 19:07:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 91A1E4BB7C;
	Thu, 27 Jan 2022 19:07:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RJ7pL1004312 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 14:07:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B180D2026609; Thu, 27 Jan 2022 19:07:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD78E2026614
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 737731044561
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 19:07:48 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
	[209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-346-5jpb89BYNDek7LNHV5pTEQ-1; Thu, 27 Jan 2022 14:07:47 -0500
X-MC-Unique: 5jpb89BYNDek7LNHV5pTEQ-1
Received: by mail-qt1-f198.google.com with SMTP id
	22-20020ac85656000000b002d2426b6fc1so2913467qtt.15
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 11:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=Mcb+ktGUGJ4HlzXNV8rq6rWy920OMZnuBuYL0YqXQLQ=;
	b=5scRQj2QPuDYcE2qGy3RxXGMMtvic1x+GSyv1ynGTl7mSqPqdSaIXaMAUjLkqFV21c
	SowqYnBvnh91tHR2lTdK1P1fFl8WyG8rYYwXfwL4HeQvY2gMVyx9MIKQZitfpp7vJgqc
	1UFfImxtV8tnhY9atkmOZBqpPzagY6/RVX1RToxspWmY3VcxZDmV/zKwHIGIJUUxlydU
	xKsPbC4tl22Bfy01m0cktblH0h0ntq/RTEYicD/slYbOHYWtNDy/leJE4yqk0Az+Y7jO
	On2FRHiMcNCyZBcCiYPXaXBDTB1VicqzHd1J+r1ssZKbij3kdESY7jtartL/c/0s4Fy4
	UhLQ==
X-Gm-Message-State: AOAM531xLEh/J8VbXRAR25h5f7jv4U6sjcwKI7Xx4I42DTKYdYgdExar
	lUmnwLElHb19vn/PggW7tcR2SahaSWHHk3H+t+35EoFEtEqeEv4/Myi4XD+A/vNGlIPZ+OQcFTP
	OBOF1wlUeaFxXgA==
X-Received: by 2002:a05:6214:c66:: with SMTP id
	t6mr4716134qvj.19.1643310466552; 
	Thu, 27 Jan 2022 11:07:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXHG1MTwpN3KTgGPH5X5OglQEa0u195K9rFWI52LePU9Dx+L87Vn0bG74FauJJTD6KSNMkRg==
X-Received: by 2002:a05:6214:c66:: with SMTP id
	t6mr4716108qvj.19.1643310466185; 
	Thu, 27 Jan 2022 11:07:46 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	d13sm1891974qte.77.2022.01.27.11.07.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 11:07:45 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 14:07:40 -0500
Message-Id: <20220127190742.12776-2-snitzer@redhat.com>
In-Reply-To: <20220127190742.12776-1-snitzer@redhat.com>
References: <20220127190742.12776-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 1/3] block: add __bio_start_io_acct() to control
	start_time
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

__bio_start_io_acct() interface is like bio_start_io_acct() that
allows start_time to be passed in. This gives drivers the ability to
defer starting accounting until after IO is issued (but possibily not
entirely due to bio splitting).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 27 ++++++++++++++++++++-------
 include/linux/blkdev.h |  1 +
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 97f8bc8d3a79..18cd12fee67d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1060,21 +1060,30 @@ void update_io_ticks(struct block_device *part, unsigned long now, bool end)
 	}
 }
 
-static unsigned long __part_start_io_acct(struct block_device *part,
-					  unsigned int sectors, unsigned int op)
+static void __part_start_io_acct(struct block_device *part, unsigned int sectors,
+				 unsigned int op, unsigned long start_time)
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
+}
 
-	return now;
+/**
+ * __bio_start_io_acct - start I/O accounting for bio based drivers
+ * @bio:	bio to start account for
+ * @start_time:	start time that should be passed back to bio_end_io_acct().
+ */
+void __bio_start_io_acct(struct bio *bio, unsigned long start_time)
+{
+	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
+			     bio_op(bio), start_time);
 }
+EXPORT_SYMBOL_GPL(__bio_start_io_acct);
 
 /**
  * bio_start_io_acct - start I/O accounting for bio based drivers
@@ -1084,14 +1093,18 @@ static unsigned long __part_start_io_acct(struct block_device *part,
  */
 unsigned long bio_start_io_acct(struct bio *bio)
 {
-	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio), bio_op(bio));
+	unsigned long now = READ_ONCE(jiffies);
+	__bio_start_io_acct(bio, now);
+	return now;
 }
 EXPORT_SYMBOL_GPL(bio_start_io_acct);
 
 unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 				 unsigned int op)
 {
-	return __part_start_io_acct(disk->part0, sectors, op);
+	unsigned long now = READ_ONCE(jiffies);
+	__part_start_io_acct(disk->part0, sectors, op, now);
+	return now;
 }
 EXPORT_SYMBOL(disk_start_io_acct);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9c95df26fc26..ed3cd5f7f984 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1258,6 +1258,7 @@ unsigned long disk_start_io_acct(struct gendisk *disk, unsigned int sectors,
 void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 		unsigned long start_time);
 
+void __bio_start_io_acct(struct bio *bio, unsigned long start_time);
 unsigned long bio_start_io_acct(struct bio *bio);
 void bio_end_io_acct_remapped(struct bio *bio, unsigned long start_time,
 		struct block_device *orig_bdev);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

