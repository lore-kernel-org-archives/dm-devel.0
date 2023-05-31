Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6680C7EE2F
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685542902;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kOt4S6vhWyrGuwzb3HEu6gTHrfhb5fuiuoacQpreYiQ=;
	b=EWe+Q1zm9apxeLsBF6W7r5PzWjQzfgCKiWRQ2Cx4r/oiVNpi3Z8AzEwWTPyy0GzR3tCqrp
	z2yAhk8XWn1FDv0Y7yb+Yb0h9Qd9ujYhoKpgwayydMiNW/RRzXT/umDS8B++j9/cyaw2Sz
	zrA8c+RC1tW+XL6AH9Kr/8Sx0fNjYGQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-leAAWI9tM4e3voU1bmvpag-1; Wed, 31 May 2023 10:21:39 -0400
X-MC-Unique: leAAWI9tM4e3voU1bmvpag-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E99F280AA28;
	Wed, 31 May 2023 14:21:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CD1840C6EC4;
	Wed, 31 May 2023 14:21:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6AED19452C8;
	Wed, 31 May 2023 14:21:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8168C1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:53:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 73751140E963; Wed, 31 May 2023 13:53:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B92D140E962
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:53:35 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49B3728237C2
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:53:35 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-kkJpASRRNLKkAGDaNH5OiA-1; Wed, 31 May 2023 09:53:33 -0400
X-MC-Unique: kkJpASRRNLKkAGDaNH5OiA-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LMk-00HQwo-2V; Wed, 31 May 2023 12:55:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:13 +0200
Message-Id: <20230531125535.676098-3-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 02/24] PM: hibernate: factor out a helper to find
 the resume device
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Split the logic to find the resume device out software_resume and into
a separate helper to start unwindig the convoluted goto logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
---
 kernel/power/hibernate.c | 72 +++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 30d1274f03f625..07279506366255 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -910,6 +910,41 @@ int hibernate_quiet_exec(int (*func)(void *data), void *data)
 }
 EXPORT_SYMBOL_GPL(hibernate_quiet_exec);
 
+static int find_resume_device(void)
+{
+	if (!strlen(resume_file))
+		return -ENOENT;
+
+	pm_pr_dbg("Checking hibernation image partition %s\n", resume_file);
+
+	if (resume_delay) {
+		pr_info("Waiting %dsec before reading resume device ...\n",
+			resume_delay);
+		ssleep(resume_delay);
+	}
+
+	/* Check if the device is there */
+	swsusp_resume_device = name_to_dev_t(resume_file);
+	if (swsusp_resume_device)
+		return 0;
+
+	/*
+	 * Some device discovery might still be in progress; we need to wait for
+	 * this to finish.
+	 */
+	wait_for_device_probe();
+	if (resume_wait) {
+		while (!(swsusp_resume_device = name_to_dev_t(resume_file)))
+			msleep(10);
+		async_synchronize_full();
+	}
+
+	swsusp_resume_device = name_to_dev_t(resume_file);
+	if (!swsusp_resume_device)
+		return -ENODEV;
+	return 0;
+}
+
 /**
  * software_resume - Resume from a saved hibernation image.
  *
@@ -949,45 +984,12 @@ static int software_resume(void)
 
 	snapshot_test = false;
 
-	if (swsusp_resume_device)
-		goto Check_image;
-
-	if (!strlen(resume_file)) {
-		error = -ENOENT;
-		goto Unlock;
-	}
-
-	pm_pr_dbg("Checking hibernation image partition %s\n", resume_file);
-
-	if (resume_delay) {
-		pr_info("Waiting %dsec before reading resume device ...\n",
-			resume_delay);
-		ssleep(resume_delay);
-	}
-
-	/* Check if the device is there */
-	swsusp_resume_device = name_to_dev_t(resume_file);
 	if (!swsusp_resume_device) {
-		/*
-		 * Some device discovery might still be in progress; we need
-		 * to wait for this to finish.
-		 */
-		wait_for_device_probe();
-
-		if (resume_wait) {
-			while ((swsusp_resume_device = name_to_dev_t(resume_file)) == 0)
-				msleep(10);
-			async_synchronize_full();
-		}
-
-		swsusp_resume_device = name_to_dev_t(resume_file);
-		if (!swsusp_resume_device) {
-			error = -ENODEV;
+		error = find_resume_device();
+		if (error)
 			goto Unlock;
-		}
 	}
 
- Check_image:
 	pm_pr_dbg("Hibernation image partition %d:%d present\n",
 		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

