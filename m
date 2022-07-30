Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE168C04A68
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jul 2022 05:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659158016;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Mxe13tn1Lxer/WMKq81cEdOMgAjehFGmQFUEa3mLsCs=;
	b=VXNSNIYJUkjAaDrge7RxWfnIwlcyd9IKw+Afm3I54fyzOMvJVnuyPi7v6Eh4c4Gmv0Gg/V
	6Mc2NHMOzQ0WuIyH/cQX6K8nTGSN1OZzJVmg1hV9Mb4Yp0HnD8PLAIrkvhhKuCXlvaTZhO
	1pvO7fhf0Wo1629grqRI+cFCGjBCuEA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-XH5OzOaxOUejci7yKkRZjg-1; Sat, 30 Jul 2022 01:13:32 -0400
X-MC-Unique: XH5OzOaxOUejci7yKkRZjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88043811E76;
	Sat, 30 Jul 2022 05:13:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 875C51121314;
	Sat, 30 Jul 2022 05:13:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3ECF1194E32A;
	Sat, 30 Jul 2022 05:13:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 873FB194D6FF
 for <dm-devel@listman.corp.redhat.com>; Sat, 30 Jul 2022 05:13:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 477F4403160; Sat, 30 Jul 2022 05:13:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 377A5492C3B;
 Sat, 30 Jul 2022 05:13:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 26U5D25R024123;
 Sat, 30 Jul 2022 00:13:03 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 26U5D255024122;
 Sat, 30 Jul 2022 00:13:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Sat, 30 Jul 2022 00:12:55 -0500
Message-Id: <1659157980-24079-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
References: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/6] multipathd: Use regular pthread_mutex_t for
 waiter_lock
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
Cc: Wu Guanghao <wuguanghao3@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

waiter_lock doesn't need any special lock handing. Also make it static.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/waiter.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 2a221465..52793698 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -24,7 +24,7 @@
 #include "main.h"
 
 pthread_attr_t waiter_attr;
-struct mutex_lock waiter_lock = { .mutex = PTHREAD_MUTEX_INITIALIZER };
+static pthread_mutex_t waiter_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static struct event_thread *alloc_waiter (void)
 {
@@ -65,11 +65,11 @@ void stop_waiter_thread (struct multipath *mpp)
 		(unsigned long)mpp->waiter);
 	thread = mpp->waiter;
 	mpp->waiter = (pthread_t)0;
-	pthread_cleanup_push(cleanup_lock, &waiter_lock);
-	lock(&waiter_lock);
+	pthread_cleanup_push(cleanup_mutex, &waiter_lock);
+	pthread_mutex_lock(&waiter_lock);
 	pthread_kill(thread, SIGUSR2);
 	pthread_cancel(thread);
-	lock_cleanup_pop(&waiter_lock);
+	pthread_cleanup_pop(1);
 }
 
 /*
@@ -126,10 +126,10 @@ static int waiteventloop (struct event_thread *waiter)
 	waiter->dmt = NULL;
 
 	if (!r)	{ /* wait interrupted by signal. check for cancellation */
-		pthread_cleanup_push(cleanup_lock, &waiter_lock);
-		lock(&waiter_lock);
+		pthread_cleanup_push(cleanup_mutex, &waiter_lock);
+		pthread_mutex_lock(&waiter_lock);
 		pthread_testcancel();
-		lock_cleanup_pop(&waiter_lock);
+		pthread_cleanup_pop(1);
 		return 1; /* If we weren't cancelled, just reschedule */
 	}
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

