Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDCDC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 09:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832489;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qhYOmYhtxFStThKUR2pXooKN6VYSz1Ab8jouP/+lb1s=;
	b=iV8zXw5V9AYBLUouTdOW26FBKrJxoVMe3PyaUZbTYV5SJzcDd7VsH5FI5KoJf2wW6Vq5kl
	IpMeeyXTzyjDVwJMJCKbycad1g4E5Wxqmaw7c6n+X7E0cL01IqRQedm0+FZFyBM9Ut22BA
	37cPZJUpme8js/2YU/fd3E1rWV36E30=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-YnKbafD5Nfek8rG7IrJn3Q-1; Tue, 23 May 2023 05:01:28 -0400
X-MC-Unique: YnKbafD5Nfek8rG7IrJn3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 838BD3802134;
	Tue, 23 May 2023 09:01:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 289E9112131B;
	Tue, 23 May 2023 09:01:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 014A319465A8;
	Tue, 23 May 2023 09:01:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED77419465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 09:01:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C6E3C20296C8; Tue, 23 May 2023 09:01:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BFBD420296C6
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:01:24 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A368D185A791
 for <dm-devel@redhat.com>; Tue, 23 May 2023 09:01:24 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-W-qAbBZFPaKutnhJTsE4fw-1; Tue, 23 May 2023 05:01:23 -0400
X-MC-Unique: W-qAbBZFPaKutnhJTsE4fw-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1MiH-009GVg-31; Tue, 23 May 2023 07:45:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:14 +0200
Message-Id: <20230523074535.249802-4-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 03/24] PM: hibernate: remove the global
 snapshot_test variable
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

Passing call dependent variable in global variables is a huge
antipattern.  Fix it up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/power/hibernate.c | 17 ++++++-----------
 kernel/power/power.h     |  3 +--
 kernel/power/swap.c      |  2 +-
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 07279506366255..78696aa04f5ca3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -64,7 +64,6 @@ enum {
 static int hibernation_mode = HIBERNATION_SHUTDOWN;
 
 bool freezer_test_done;
-bool snapshot_test;
 
 static const struct platform_hibernation_ops *hibernation_ops;
 
@@ -684,7 +683,7 @@ static void power_down(void)
 		cpu_relax();
 }
 
-static int load_image_and_restore(void)
+static int load_image_and_restore(bool snapshot_test)
 {
 	int error;
 	unsigned int flags;
@@ -721,6 +720,7 @@ static int load_image_and_restore(void)
  */
 int hibernate(void)
 {
+	bool snapshot_test = false;
 	unsigned int sleep_flags;
 	int error;
 
@@ -748,9 +748,6 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
-	/* protected by system_transition_mutex */
-	snapshot_test = false;
-
 	lock_device_hotplug();
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
@@ -792,9 +789,9 @@ int hibernate(void)
 	unlock_device_hotplug();
 	if (snapshot_test) {
 		pm_pr_dbg("Checking hibernation image\n");
-		error = swsusp_check();
+		error = swsusp_check(snapshot_test);
 		if (!error)
-			error = load_image_and_restore();
+			error = load_image_and_restore(snapshot_test);
 	}
 	thaw_processes();
 
@@ -982,8 +979,6 @@ static int software_resume(void)
 	 */
 	mutex_lock_nested(&system_transition_mutex, SINGLE_DEPTH_NESTING);
 
-	snapshot_test = false;
-
 	if (!swsusp_resume_device) {
 		error = find_resume_device();
 		if (error)
@@ -994,7 +989,7 @@ static int software_resume(void)
 		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
 
 	pm_pr_dbg("Looking for hibernation image.\n");
-	error = swsusp_check();
+	error = swsusp_check(false);
 	if (error)
 		goto Unlock;
 
@@ -1022,7 +1017,7 @@ static int software_resume(void)
 		goto Close_Finish;
 	}
 
-	error = load_image_and_restore();
+	error = load_image_and_restore(false);
 	thaw_processes();
  Finish:
 	pm_notifier_call_chain(PM_POST_RESTORE);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index b83c8d5e188dec..978189fcafd124 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -59,7 +59,6 @@ asmlinkage int swsusp_save(void);
 
 /* kernel/power/hibernate.c */
 extern bool freezer_test_done;
-extern bool snapshot_test;
 
 extern int hibernation_snapshot(int platform_mode);
 extern int hibernation_restore(int platform_mode);
@@ -174,7 +173,7 @@ extern int swsusp_swap_in_use(void);
 #define SF_HW_SIG		8
 
 /* kernel/power/hibernate.c */
-extern int swsusp_check(void);
+int swsusp_check(bool snapshot_test);
 extern void swsusp_free(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 92e41ed292ada8..efed11568bfc72 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1514,7 +1514,7 @@ int swsusp_read(unsigned int *flags_p)
  *      swsusp_check - Check for swsusp signature in the resume device
  */
 
-int swsusp_check(void)
+int swsusp_check(bool snapshot_test)
 {
 	int error;
 	void *holder;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

