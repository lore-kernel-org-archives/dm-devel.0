Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D436FC7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832189;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N8RornZmP11j+4BMKedNXmjOO8S6/nsAeuIQxfmw2sk=;
	b=YLFyTPycjc4OfwBvxCsjm9yi+uOvzhz10aBkvxLuZMTG7QNQ+gl6Y7sTM4iTDsQcYcLGLh
	TmcdqIRowME9IIcN0OgqSIuq5hwcCk5P4VqT6sjYZPFt6pVzer8n/d7brGPwJSStTBvSCV
	GlWMKKISe+UkgWgyViDs9mVdCuKAjM4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-0OdodPZVMHiEeX3110hoaQ-1; Tue, 23 May 2023 04:56:26 -0400
X-MC-Unique: 0OdodPZVMHiEeX3110hoaQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7144800141;
	Tue, 23 May 2023 08:56:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 942E5492B0A;
	Tue, 23 May 2023 08:56:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E57E19465A0;
	Tue, 23 May 2023 08:56:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C7D521946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:56:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B8FA32166B27; Tue, 23 May 2023 08:56:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0B512166B26
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:56:23 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94C7F802A55
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:56:23 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-IZ6-OKUsNBKTFpkVt5m4yw-1; Tue, 23 May 2023 04:56:21 -0400
X-MC-Unique: IZ6-OKUsNBKTFpkVt5m4yw-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1Mj1-009HBv-1X; Tue, 23 May 2023 07:46:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:30 +0200
Message-Id: <20230523074535.249802-20-hch@lst.de>
In-Reply-To: <20230523074535.249802-1-hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 19/24] dm: remove dm_get_dev_t
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Open code dm_get_dev_t in the only remaining caller, and propagate the
exact error code from lookup_bdev and early_lookup_bdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c         | 20 ++++----------------
 include/linux/device-mapper.h |  2 --
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 05aa16da43b0d5..e997f4322a9967 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -323,20 +323,6 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
 	return 0;
 }
 
-/*
- * Convert the path to a device
- */
-dev_t dm_get_dev_t(const char *path)
-{
-	dev_t dev;
-
-	if (lookup_bdev(path, &dev) &&
-	    early_lookup_bdev(path, &dev))
-		return 0;
-	return dev;
-}
-EXPORT_SYMBOL_GPL(dm_get_dev_t);
-
 /*
  * Add a device to the list, or just increment the usage count if
  * it's already present.
@@ -359,8 +345,10 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		if (MAJOR(dev) != major || MINOR(dev) != minor)
 			return -EOVERFLOW;
 	} else {
-		dev = dm_get_dev_t(path);
-		if (!dev)
+		r = lookup_bdev(path, &dev);
+		if (r)
+			r = early_lookup_bdev(path, &dev);
+		if (r)
 			return -ENODEV;
 	}
 	if (dev == disk_devt(t->md->disk))
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a52d2b9a68460a..c27b84002d8382 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -170,8 +170,6 @@ struct dm_dev {
 	char name[16];
 };
 
-dev_t dm_get_dev_t(const char *path);
-
 /*
  * Constructors should call these functions to ensure destination devices
  * are opened/closed correctly.
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

