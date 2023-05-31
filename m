Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A30C7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 13:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685539408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W4FfsTBFW+jw0ordWtPEqDX0KiisUTMwSeS08743b0o=;
	b=E4kN+qsvWqVgjMVImyJnm2B4WBVVcJnp7YbMrX+aTNbnzr3jUT3j9SRRSDVhjqY83K/bgv
	BAktNLkpvJr6R0pWHofLfwyYP/x6W1lVeGzOe7/sInKTvIKcxcDm2Tm34InvrnEcjF/9fx
	FW7r67S5sOqT2WFFrn7Mz5/qkIO+I2I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-cvHl7HbFP8uomc4k9gxIfQ-1; Wed, 31 May 2023 09:23:26 -0400
X-MC-Unique: cvHl7HbFP8uomc4k9gxIfQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EA531C06930;
	Wed, 31 May 2023 13:23:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B849492B0B;
	Wed, 31 May 2023 13:23:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B34919465B9;
	Wed, 31 May 2023 13:23:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7439D19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 12:57:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 562EA40C6CD0; Wed, 31 May 2023 12:57:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EDCB40C6EC4
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:29 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F85E3C14AB1
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:29 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-4yEoglpFMGyY7mIxI7jmJA-1; Wed, 31 May 2023 08:57:26 -0400
X-MC-Unique: 4yEoglpFMGyY7mIxI7jmJA-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LO9-00HRzk-0U; Wed, 31 May 2023 12:57:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:30 +0200
Message-Id: <20230531125535.676098-20-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Open code dm_get_dev_t in the only remaining caller, and propagate the
exact error code from lookup_bdev and early_lookup_bdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c         | 22 +++++-----------------
 include/linux/device-mapper.h |  2 --
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 05aa16da43b0d5..1576b408768d4b 100644
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
@@ -359,9 +345,11 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		if (MAJOR(dev) != major || MINOR(dev) != minor)
 			return -EOVERFLOW;
 	} else {
-		dev = dm_get_dev_t(path);
-		if (!dev)
-			return -ENODEV;
+		r = lookup_bdev(path, &dev);
+		if (r)
+			r = early_lookup_bdev(path, &dev);
+		if (r)
+			return r;
 	}
 	if (dev == disk_devt(t->md->disk))
 		return -EINVAL;
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

