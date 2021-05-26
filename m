Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBE0C47082
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 14:18:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44F25613D7
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 14:18:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44F25613D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1622038702;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=T8Zyfbzb0ilf1inlft4Lot7z6LrGZFi6wlRnFo8zhZk=;
	b=S05IQu2upvf2sRTdGfBKni/V4TYVuatd/+1eGFB+X/udWrM79cbvIafiGjOF60YGuuq9pV
	MhWZHHQdfmRy35VbzjpqBQNJfwPh5nJIyM7XlOQ4DPhr/BIr8A13wYvBLD5VKSBV4xAJkK
	RRJ9atILk+kMkV6Su1zCFQ9CALj5Fnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-DHhA4n47Ol-jwKkd59vtEw-1; Wed, 26 May 2021 10:18:18 -0400
X-MC-Unique: DHhA4n47Ol-jwKkd59vtEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91632189C450;
	Wed, 26 May 2021 14:18:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70DDF61094;
	Wed, 26 May 2021 14:18:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 062B555345;
	Wed, 26 May 2021 14:18:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14QEIAZ7028180 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 May 2021 10:18:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7C3DF2C01B; Wed, 26 May 2021 14:18:10 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFCB2136F5;
	Wed, 26 May 2021 14:18:06 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 14QEI6UV026572; Wed, 26 May 2021 10:18:06 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 14QEI6tE026568; Wed, 26 May 2021 10:18:06 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 26 May 2021 10:18:06 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2105261016290.25928@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: [dm-devel] [PATCH] dm-kcopyd avoid spin_lock_irqsave from process
	context
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The functions "pop", "push_head", "do_work" can only be called from
process context. Therefore, we can replace
spin_lock_irqsave/spin_unlock_irqrestore with
spin_lock_irq/spin_unlock_irq.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-kcopyd.c
+++ linux-2.6/drivers/md/dm-kcopyd.c
@@ -437,9 +437,8 @@ static struct kcopyd_job *pop(struct lis
 			      struct dm_kcopyd_client *kc)
 {
 	struct kcopyd_job *job = NULL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&kc->job_lock, flags);
+	spin_lock_irq(&kc->job_lock);
 
 	if (!list_empty(jobs)) {
 		if (jobs == &kc->io_jobs)
@@ -449,7 +448,7 @@ static struct kcopyd_job *pop(struct lis
 			list_del(&job->list);
 		}
 	}
-	spin_unlock_irqrestore(&kc->job_lock, flags);
+	spin_unlock_irq(&kc->job_lock);
 
 	return job;
 }
@@ -467,12 +466,11 @@ static void push(struct list_head *jobs,
 
 static void push_head(struct list_head *jobs, struct kcopyd_job *job)
 {
-	unsigned long flags;
 	struct dm_kcopyd_client *kc = job->kc;
 
-	spin_lock_irqsave(&kc->job_lock, flags);
+	spin_lock_irq(&kc->job_lock);
 	list_add(&job->list, jobs);
-	spin_unlock_irqrestore(&kc->job_lock, flags);
+	spin_unlock_irq(&kc->job_lock);
 }
 
 /*
@@ -655,7 +653,6 @@ static void do_work(struct work_struct *
 	struct dm_kcopyd_client *kc = container_of(work,
 					struct dm_kcopyd_client, kcopyd_work);
 	struct blk_plug plug;
-	unsigned long flags;
 
 	/*
 	 * The order that these are called is *very* important.
@@ -664,9 +661,9 @@ static void do_work(struct work_struct *
 	 * list.  io jobs call wake when they complete and it all
 	 * starts again.
 	 */
-	spin_lock_irqsave(&kc->job_lock, flags);
+	spin_lock_irq(&kc->job_lock);
 	list_splice_tail_init(&kc->callback_jobs, &kc->complete_jobs);
-	spin_unlock_irqrestore(&kc->job_lock, flags);
+	spin_unlock_irq(&kc->job_lock);
 
 	blk_start_plug(&plug);
 	process_jobs(&kc->complete_jobs, kc, run_complete_job);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

