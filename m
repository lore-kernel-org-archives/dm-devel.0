Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90E0C432BE
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:08:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0462F61053
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0462F61053
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-hJ0J9aOYOEWjHMY7dIIZgg-1; Fri, 20 Aug 2021 11:08:23 -0400
X-MC-Unique: hJ0J9aOYOEWjHMY7dIIZgg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C72E6190A7A1;
	Fri, 20 Aug 2021 15:08:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0916D5D741;
	Fri, 20 Aug 2021 15:08:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5C781819AC2;
	Fri, 20 Aug 2021 15:08:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KF8B16027358 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 11:08:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CDE371182DD; Fri, 20 Aug 2021 15:08:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2E36116725
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 15:08:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 249CD80100E
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 15:08:09 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-202-x6PrLjuAPOaVIvnEkmMWEA-1;
	Fri, 20 Aug 2021 11:08:06 -0400
X-MC-Unique: x6PrLjuAPOaVIvnEkmMWEA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 20D2D6736F; Fri, 20 Aug 2021 17:08:04 +0200 (CEST)
Date: Fri, 20 Aug 2021 17:08:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20210820150803.GA490@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
	<20210804094147.459763-5-hch@lst.de>
	<20210814211309.GA616511@roeck-us.net>
	<20210815070724.GA23276@lst.de>
	<a8d66952-ee44-d3fa-d699-439415b9abfe@roeck-us.net>
	<20210816072158.GA27147@lst.de>
	<20210816141702.GA3449320@roeck-us.net>
MIME-Version: 1.0
In-Reply-To: <20210816141702.GA3449320@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
 registration
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Please try the patch below:

---
>From 7609266da56160d211662cd2fbe26570aad11b15 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 20 Aug 2021 17:00:11 +0200
Subject: mtd_blkdevs: don't hold del_mtd_blktrans_dev in
 blktrans_{open,release}

There is nothing that this protects against except for slightly reducing
the window when new opens can appear just before calling del_gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/mtd_blkdevs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 44bea3f65060..6b81a1c9ccbe 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -207,7 +207,6 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 	if (!dev)
 		return -ERESTARTSYS; /* FIXME: busy loop! -arnd*/
 
-	mutex_lock(&mtd_table_mutex);
 	mutex_lock(&dev->lock);
 
 	if (dev->open)
@@ -233,7 +232,6 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 unlock:
 	dev->open++;
 	mutex_unlock(&dev->lock);
-	mutex_unlock(&mtd_table_mutex);
 	blktrans_dev_put(dev);
 	return ret;
 
@@ -244,7 +242,6 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 	module_put(dev->tr->owner);
 	kref_put(&dev->ref, blktrans_dev_release);
 	mutex_unlock(&dev->lock);
-	mutex_unlock(&mtd_table_mutex);
 	blktrans_dev_put(dev);
 	return ret;
 }
@@ -256,7 +253,6 @@ static void blktrans_release(struct gendisk *disk, fmode_t mode)
 	if (!dev)
 		return;
 
-	mutex_lock(&mtd_table_mutex);
 	mutex_lock(&dev->lock);
 
 	if (--dev->open)
@@ -272,7 +268,6 @@ static void blktrans_release(struct gendisk *disk, fmode_t mode)
 	}
 unlock:
 	mutex_unlock(&dev->lock);
-	mutex_unlock(&mtd_table_mutex);
 	blktrans_dev_put(dev);
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

