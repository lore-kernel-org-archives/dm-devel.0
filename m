Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 965CFC7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832133;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j/huFgdZTn8AeXnePeochMxE0oUSd9TMZa3TQOmlY0U=;
	b=Jp/c/SC45ovbcWncsIN460gjliimzKkTwkzUvrpAqt/U0uQbf1w/L0i3XnXZ+g8qsgzNwh
	moXtLF7PK8lwP/8o6DgcsEGPWn1C/DP/q71Vi3Qg+1RRPpt1FW+UyS3kUSf9J1UBqmN3pd
	aIWzsX0Ta/hbjK3+UDgeJHwecxarfr8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-CDBWWxOtNoCl_g2AFd_FTQ-1; Tue, 23 May 2023 04:55:30 -0400
X-MC-Unique: CDBWWxOtNoCl_g2AFd_FTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 933B7811E86;
	Tue, 23 May 2023 08:55:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80D831121315;
	Tue, 23 May 2023 08:55:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 34E2019465A0;
	Tue, 23 May 2023 08:55:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB0721946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:55:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8593C2166B26; Tue, 23 May 2023 08:55:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D9012166B25
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:55:27 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F7FB29ABA14
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:55:27 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-5yC0iO3bOd2SpjHR0gvPEg-1; Tue, 23 May 2023 04:55:25 -0400
X-MC-Unique: 5yC0iO3bOd2SpjHR0gvPEg-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1MiF-009GUU-0j; Tue, 23 May 2023 07:45:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:13 +0200
Message-Id: <20230523074535.249802-3-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Split the logic to find the resume device out software_resume and into
a separate helper to start unwindig the convoluted goto logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

