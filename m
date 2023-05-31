Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F544C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685542900;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GBEtUH1zZdUC3dxm7qaOZIuh8iEvDBgdXH8l4cl6DNM=;
	b=U4diQuwvQDPQzA2qyTcjx5Vt3Hx358gBvNefkU7P1yZ6jgmvP36M2go4+u299boGnTWEQV
	ZjxTnbnzchGcLVHlkcB0LM9v4cFijus8cLHw/dsXVa+QizPtURgGrMPlqAYiimZXcRkzVn
	6s7L5JYJGRB7hpR+2Urt4YNeTvrkMy0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-3s29pBIbMmic-QJsh3PaJg-1; Wed, 31 May 2023 10:21:37 -0400
X-MC-Unique: 3s29pBIbMmic-QJsh3PaJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C1033849526;
	Wed, 31 May 2023 14:21:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B4D7140E963;
	Wed, 31 May 2023 14:21:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1C7319465BA;
	Wed, 31 May 2023 14:21:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 722E61946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:52:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 500C3112132E; Wed, 31 May 2023 13:52:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 49160112132C
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:52:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E0943850558
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:52:05 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-nP1NJS0zP8enxFBHZTwTzA-1; Wed, 31 May 2023 09:52:03 -0400
X-MC-Unique: nP1NJS0zP8enxFBHZTwTzA-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LMx-00HR1a-1s; Wed, 31 May 2023 12:56:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:15 +0200
Message-Id: <20230531125535.676098-5-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 04/24] PM: hibernate: move finding the resume
 device out of software_resume
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

software_resume can be called either from an init call in the boot code,
or from sysfs once the system has finished booting, and the two
invocation methods this can't race with each other.

For the latter case we did just parse the suspend device manually, while
the former might not have one.  Split software_resume so that the search
only happens for the boot case, which also means the special lockdep
nesting annotation can go away as the system transition mutex can be
taken a little later and doesn't have the sysfs locking nest inside it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
---
 kernel/power/hibernate.c | 80 ++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 78696aa04f5ca3..45e24b02cd50b6 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -907,7 +907,7 @@ int hibernate_quiet_exec(int (*func)(void *data), void *data)
 }
 EXPORT_SYMBOL_GPL(hibernate_quiet_exec);
 
-static int find_resume_device(void)
+static int __init find_resume_device(void)
 {
 	if (!strlen(resume_file))
 		return -ENOENT;
@@ -942,53 +942,16 @@ static int find_resume_device(void)
 	return 0;
 }
 
-/**
- * software_resume - Resume from a saved hibernation image.
- *
- * This routine is called as a late initcall, when all devices have been
- * discovered and initialized already.
- *
- * The image reading code is called to see if there is a hibernation image
- * available for reading.  If that is the case, devices are quiesced and the
- * contents of memory is restored from the saved image.
- *
- * If this is successful, control reappears in the restored target kernel in
- * hibernation_snapshot() which returns to hibernate().  Otherwise, the routine
- * attempts to recover gracefully and make the kernel return to the normal mode
- * of operation.
- */
 static int software_resume(void)
 {
 	int error;
 
-	/*
-	 * If the user said "noresume".. bail out early.
-	 */
-	if (noresume || !hibernation_available())
-		return 0;
-
-	/*
-	 * name_to_dev_t() below takes a sysfs buffer mutex when sysfs
-	 * is configured into the kernel. Since the regular hibernate
-	 * trigger path is via sysfs which takes a buffer mutex before
-	 * calling hibernate functions (which take system_transition_mutex)
-	 * this can cause lockdep to complain about a possible ABBA deadlock
-	 * which cannot happen since we're in the boot code here and
-	 * sysfs can't be invoked yet. Therefore, we use a subclass
-	 * here to avoid lockdep complaining.
-	 */
-	mutex_lock_nested(&system_transition_mutex, SINGLE_DEPTH_NESTING);
-
-	if (!swsusp_resume_device) {
-		error = find_resume_device();
-		if (error)
-			goto Unlock;
-	}
-
 	pm_pr_dbg("Hibernation image partition %d:%d present\n",
 		MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
 
 	pm_pr_dbg("Looking for hibernation image.\n");
+
+	mutex_lock(&system_transition_mutex);
 	error = swsusp_check(false);
 	if (error)
 		goto Unlock;
@@ -1035,7 +998,39 @@ static int software_resume(void)
 	goto Finish;
 }
 
-late_initcall_sync(software_resume);
+/**
+ * software_resume_initcall - Resume from a saved hibernation image.
+ *
+ * This routine is called as a late initcall, when all devices have been
+ * discovered and initialized already.
+ *
+ * The image reading code is called to see if there is a hibernation image
+ * available for reading.  If that is the case, devices are quiesced and the
+ * contents of memory is restored from the saved image.
+ *
+ * If this is successful, control reappears in the restored target kernel in
+ * hibernation_snapshot() which returns to hibernate().  Otherwise, the routine
+ * attempts to recover gracefully and make the kernel return to the normal mode
+ * of operation.
+ */
+static int __init software_resume_initcall(void)
+{
+	/*
+	 * If the user said "noresume".. bail out early.
+	 */
+	if (noresume || !hibernation_available())
+		return 0;
+
+	if (!swsusp_resume_device) {
+		int error = find_resume_device();
+
+		if (error)
+			return error;
+	}
+
+	return software_resume();
+}
+late_initcall_sync(software_resume_initcall);
 
 
 static const char * const hibernation_modes[] = {
@@ -1176,6 +1171,9 @@ static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
 	char *name;
 	dev_t res;
 
+	if (!hibernation_available())
+		return 0;
+
 	if (len && buf[len-1] == '\n')
 		len--;
 	name = kstrndup(buf, len, GFP_KERNEL);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

