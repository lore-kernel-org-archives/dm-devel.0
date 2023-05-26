Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4653C77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 07:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685086460;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rf5KumRxPtJgqo1xic4CtFZQrhBEZG+MJyt/caVpKBc=;
	b=X1cuZ35in1AfWYcuT+frsKqQyRjw8oq1DnP+5exGEUDbBUteGWKEBQ32Psg7smfxjpMYZ8
	L4n00a5aP5BFDk6wgqZ0b4Kj9mrTmNRJF4IGtBNffSN8y1tGiT4wfS/V7qmSl4mp9rwnc+
	KFnI37+QHsydDGGiJ7Lhmbp53ayDBek=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-H5-lpM8wOeyF14E9jLOYRQ-1; Fri, 26 May 2023 03:34:16 -0400
X-MC-Unique: H5-lpM8wOeyF14E9jLOYRQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D765858F19;
	Fri, 26 May 2023 07:34:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE4EC112131B;
	Fri, 26 May 2023 07:34:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0479819459F1;
	Fri, 26 May 2023 07:34:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5ABE919465B2
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 07:33:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4B32840102D; Fri, 26 May 2023 07:33:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43288492B00
 for <dm-devel@redhat.com>; Fri, 26 May 2023 07:33:43 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C0CB3C0D185
 for <dm-devel@redhat.com>; Fri, 26 May 2023 07:33:43 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-5SqW50m9MRG10WVyMhGHHA-1; Fri, 26 May 2023 03:33:39 -0400
X-MC-Unique: 5SqW50m9MRG10WVyMhGHHA-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red
 Hat Linux)) id 1q2RxA-001RdR-3D; Fri, 26 May 2023 07:33:37 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, djwong@kernel.org,
 minchan@kernel.org, senozhatsky@chromium.org
Date: Fri, 26 May 2023 00:33:32 -0700
Message-Id: <20230526073336.344543-2-mcgrof@kernel.org>
In-Reply-To: <20230526073336.344543-1-mcgrof@kernel.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v2 1/5] block: annotate bdev_disk_changed()
 deprecation with a symbol namespace
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
Cc: p.raghav@samsung.com, linux-xfs@vger.kernel.org, rohan.puri@samsung.com,
 da.gomez@samsung.com, mcgrof@kernel.org, patches@lists.linux.dev,
 willy@infradead.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
 rpuri.linux@gmail.com, kbusch@kernel.org, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This ensures no other users pop up by mistake easily and provides
us a with an easy vehicle to do the same with other routines should
we need it later.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 block/partitions/core.c         | 6 +-----
 drivers/block/loop.c            | 2 ++
 drivers/s390/block/dasd_genhd.c | 2 ++
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 49e0496ff23c..6f18444be4fe 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -690,11 +690,7 @@ int bdev_disk_changed(struct gendisk *disk, bool invalidate)
 
 	return ret;
 }
-/*
- * Only exported for loop and dasd for historic reasons.  Don't use in new
- * code!
- */
-EXPORT_SYMBOL_GPL(bdev_disk_changed);
+EXPORT_SYMBOL_NS_GPL(bdev_disk_changed, BLOCK_DEPRECATED);
 
 void *read_part_sector(struct parsed_partitions *state, sector_t n, Sector *p)
 {
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index bc31bb7072a2..50aa5b4c0c56 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -37,6 +37,8 @@
 #include <linux/spinlock.h>
 #include <uapi/linux/loop.h>
 
+MODULE_IMPORT_NS(BLOCK_DEPRECATED);
+
 /* Possible states of device */
 enum {
 	Lo_unbound,
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 998a961e1704..5ea244aec534 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -25,6 +25,8 @@
 
 #include "dasd_int.h"
 
+MODULE_IMPORT_NS(BLOCK_DEPRECATED);
+
 static unsigned int queue_depth = 32;
 static unsigned int nr_hw_queues = 4;
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

