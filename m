Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E10F8C7EE2F
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685539798;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gVWJ/HtgZ9E1bvYrrargGMzps8pBtoPmYd7ig55lL4A=;
	b=Mo2loIMsqG+DZuvCvKzKfoyzHAz53ZNjmsxR4mqXBNfCd5CLWEZZp6zi4ygZH0bxDlbXtF
	nl5l8Ww273nQD5t/qDz8lPBw5QdwpMNS3nOrN+G/UrwZTQ1TIoVTDDy2dwpkq7jk1lIj7d
	DR0t1yapBSV0mazeZg25kEyg0pYNAPw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-VQurYyzPO3akj_RA-7GhRg-1; Wed, 31 May 2023 09:29:55 -0400
X-MC-Unique: VQurYyzPO3akj_RA-7GhRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4F8A3C14AC1;
	Wed, 31 May 2023 13:29:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 848251121330;
	Wed, 31 May 2023 13:29:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 552891946A44;
	Wed, 31 May 2023 13:29:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A2271946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 12:57:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57A16400DFF; Wed, 31 May 2023 12:57:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FBA2492B00
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:38 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3186C101A531
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:38 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-bG51V8XANRyT5vYBkkHPdA-1; Wed, 31 May 2023 08:57:36 -0400
X-MC-Unique: bG51V8XANRyT5vYBkkHPdA-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LOK-00HS6f-0D; Wed, 31 May 2023 12:57:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:33 +0200
Message-Id: <20230531125535.676098-23-hch@lst.de>
In-Reply-To: <20230531125535.676098-1-hch@lst.de>
References: <20230531125535.676098-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 22/24] mtd: block2mtd: factor the early block
 device open logic into a helper
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
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Simplify add_device a bit by splitting out the cumbersome early boot logic
into a separate helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/devices/block2mtd.c | 53 +++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 4c21e9f13bead5..182eed68c75634 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -215,34 +215,18 @@ static void block2mtd_free_device(struct block2mtd_dev *dev)
 	kfree(dev);
 }
 
-
-static struct block2mtd_dev *add_device(char *devname, int erase_size,
-		char *label, int timeout)
+static struct block_device *mdtblock_early_get_bdev(const char *devname,
+		fmode_t mode, int timeout, struct block2mtd_dev *dev)
 {
+	struct block_device *bdev = ERR_PTR(-ENODEV);
 #ifndef MODULE
 	int i;
-#endif
-	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
-	struct block_device *bdev;
-	struct block2mtd_dev *dev;
-	char *name;
-
-	if (!devname)
-		return NULL;
-
-	dev = kzalloc(sizeof(struct block2mtd_dev), GFP_KERNEL);
-	if (!dev)
-		return NULL;
 
-	/* Get a handle on the device */
-	bdev = blkdev_get_by_path(devname, mode, dev);
-
-#ifndef MODULE
 	/*
 	 * We might not have the root device mounted at this point.
 	 * Try to resolve the device name by other means.
 	 */
-	for (i = 0; IS_ERR(bdev) && i <= timeout; i++) {
+	for (i = 0; i <= timeout; i++) {
 		dev_t devt;
 
 		if (i)
@@ -254,12 +238,35 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size,
 			msleep(1000);
 		wait_for_device_probe();
 
-		if (early_lookup_bdev(devname, &devt))
-			continue;
-		bdev = blkdev_get_by_dev(devt, mode, dev);
+		if (!early_lookup_bdev(devname, &devt)) {
+			bdev = blkdev_get_by_dev(devt, mode, dev);
+			if (!IS_ERR(bdev))
+				break;
+		}
 	}
 #endif
+	return bdev;
+}
+
+static struct block2mtd_dev *add_device(char *devname, int erase_size,
+		char *label, int timeout)
+{
+	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
+	struct block_device *bdev;
+	struct block2mtd_dev *dev;
+	char *name;
 
+	if (!devname)
+		return NULL;
+
+	dev = kzalloc(sizeof(struct block2mtd_dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	/* Get a handle on the device */
+	bdev = blkdev_get_by_path(devname, mode, dev);
+	if (IS_ERR(bdev))
+		bdev = mdtblock_early_get_bdev(devname, mode, timeout, dev);
 	if (IS_ERR(bdev)) {
 		pr_err("error: cannot open device %s\n", devname);
 		goto err_free_block2mtd;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

