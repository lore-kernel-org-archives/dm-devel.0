Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98694C7EE2F
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685542079;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QbAOnljyCbThR57J1LEDhCUZRWwlcFropKTo+JhOEjw=;
	b=GwnRe8DKMu0aGFCbts/7gVLRcGyjQMWkWWmlTXN32kOqBDBVL/UzwqA4szwuRge1VWp8lc
	aAT/VsceD1xtn1K59FvcnB6UX3gqRbhMnq1zEtjjjy+USOh86Ny94D+cUdUyN5Cp8IdUhY
	PXYlxjFzgtVH5SsAKj1rZmEFtsx25yU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-gHkbXH2LPZ-D7-afQ7venA-1; Wed, 31 May 2023 10:07:57 -0400
X-MC-Unique: gHkbXH2LPZ-D7-afQ7venA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 592153801FF6;
	Wed, 31 May 2023 14:07:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0B09421C5;
	Wed, 31 May 2023 14:07:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59C0619465A0;
	Wed, 31 May 2023 14:07:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 767F11946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:52:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 36E1E421D7; Wed, 31 May 2023 13:52:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F9EE421E0
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:52:21 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 034458028B1
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:52:21 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-EcI-GO87MHa1RtGXUQA1oQ-1; Wed, 31 May 2023 09:52:19 -0400
X-MC-Unique: EcI-GO87MHa1RtGXUQA1oQ-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LNX-00HRRM-1M; Wed, 31 May 2023 12:56:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:22 +0200
Message-Id: <20230531125535.676098-12-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 11/24] init: factor the root_wait logic in
 prepare_namespace into a helper
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The root_wait logic is a bit obsfucated right now.  Expand it and move it
into a helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index be6d14733ba02f..d5c06c1546e82c 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -606,6 +606,26 @@ void __init mount_root(char *root_device_name)
 	}
 }
 
+/* wait for any asynchronous scanning to complete */
+static void __init wait_for_root(char *root_device_name)
+{
+	if (ROOT_DEV != 0)
+		return;
+
+	pr_info("Waiting for root device %s...\n", root_device_name);
+
+	for (;;) {
+		if (driver_probe_done()) {
+			ROOT_DEV = name_to_dev_t(root_device_name);
+			if (ROOT_DEV)
+				break;
+		}
+		msleep(5);
+	}
+	async_synchronize_full();
+
+}
+
 static dev_t __init parse_root_device(char *root_device_name)
 {
 	if (!strncmp(root_device_name, "mtd", 3) ||
@@ -642,16 +662,8 @@ void __init prepare_namespace(void)
 	if (initrd_load(saved_root_name))
 		goto out;
 
-	/* wait for any asynchronous scanning to complete */
-	if ((ROOT_DEV == 0) && root_wait) {
-		printk(KERN_INFO "Waiting for root device %s...\n",
-			saved_root_name);
-		while (!driver_probe_done() ||
-			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
-			msleep(5);
-		async_synchronize_full();
-	}
-
+	if (root_wait)
+		wait_for_root(saved_root_name);
 	mount_root(saved_root_name);
 out:
 	devtmpfs_mount();
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

