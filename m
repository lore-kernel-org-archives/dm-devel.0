Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50399C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 13:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685539797;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W9TFeGTFg1jgdeTdU6Pl3olI+f2ZbHSVuv6glni06C4=;
	b=WMsOpispeIIfWgH2djY/cT6FablzUIun1ghQYS9xALAQOH5IYLn5DeofdUkGsAucxcUBvz
	ZvjZxDKHVsm+xx3blqipYCsjS129mgrFyNoScp8vUA/BtzzmF910VaDDkjuP1zglFXux1u
	ONcV36FQFiznWLPhbxdHv7n7QAekmiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-260-PLip0w09MYOP5Mo8qNOIIw-1; Wed, 31 May 2023 09:29:55 -0400
X-MC-Unique: PLip0w09MYOP5Mo8qNOIIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECA0D8028B2;
	Wed, 31 May 2023 13:29:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA0271121331;
	Wed, 31 May 2023 13:29:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F32219452C5;
	Wed, 31 May 2023 13:29:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D4D419465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 12:57:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3637220296C8; Wed, 31 May 2023 12:57:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EF8E20296C6
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:45 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F4408007D9
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:45 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-oNz0goxkNzqs7hVl1LKNZw-1; Wed, 31 May 2023 08:57:43 -0400
X-MC-Unique: oNz0goxkNzqs7hVl1LKNZw-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LOQ-00HSDd-2L; Wed, 31 May 2023 12:57:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:34 +0200
Message-Id: <20230531125535.676098-24-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 23/24] mtd: block2mtd: don't call
 early_lookup_bdev after the system is running
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

early_lookup_bdev is supposed to only be called from the early boot
code, but mdtblock_early_get_bdev is called as a general fallback when
lookup_bdev fails, which is problematic because early_lookup_bdev
bypasses all normal path based permission checking, and might cause
problems with certain container environments renaming devices.

Switch to only call early_lookup_bdev when block2mtd is built-in and the
system state in not running yet.

Note that this strictly speaking changes the kernel ABI as the PARTUUID=
and PARTLABEL= style syntax is now not available during a running
systems.  They never were intended for that, but this breaks things
we'll have to figure out a way to make them available again.  But if
avoidable in any way I'd rather avoid that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/devices/block2mtd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 182eed68c75634..59e4c71cfc6f53 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -215,13 +215,23 @@ static void block2mtd_free_device(struct block2mtd_dev *dev)
 	kfree(dev);
 }
 
-static struct block_device *mdtblock_early_get_bdev(const char *devname,
+/*
+ * This function is marked __ref because it calls the __init marked
+ * early_lookup_bdev when called from the early boot code.
+ */
+static struct block_device __ref *mdtblock_early_get_bdev(const char *devname,
 		fmode_t mode, int timeout, struct block2mtd_dev *dev)
 {
 	struct block_device *bdev = ERR_PTR(-ENODEV);
 #ifndef MODULE
 	int i;
 
+	/*
+	 * We can't use early_lookup_bdev from a running system.
+	 */
+	if (system_state >= SYSTEM_RUNNING)
+		return bdev;
+
 	/*
 	 * We might not have the root device mounted at this point.
 	 * Try to resolve the device name by other means.
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

