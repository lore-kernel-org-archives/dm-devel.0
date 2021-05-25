Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BED6C47086
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 19:53:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6612610FC
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 19:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6612610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621972424;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TW9SoPR/JWFwpGx39VeXyJULO3xdxm4ml1DkzsaeOFA=;
	b=SrgPec6EzUGcSUpFd5lsQqGRvviA3tkmJi04skheFCXuiRJw1g8ETj1VB9mzeqkr4a2TjF
	Q0Q2wvHCPvlJOSyTN9ArHqkdo3AF1IAN7V9ViawMEBkDAD7gyrFPz8Ae8p5RepiS0hmIH4
	ThlGYtTevhU4j9s4tiKwWlCJrE0HPPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-V-oqzTLFP429f4nqfI9X4w-1; Tue, 25 May 2021 15:53:42 -0400
X-MC-Unique: V-oqzTLFP429f4nqfI9X4w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F357319251A1;
	Tue, 25 May 2021 19:53:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D71196060F;
	Tue, 25 May 2021 19:53:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5730055345;
	Tue, 25 May 2021 19:53:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PJrbAD027022 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 15:53:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2E9485C1D0; Tue, 25 May 2021 19:53:37 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F4255C1A1;
	Tue, 25 May 2021 19:53:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 14PJrWuf031017; Tue, 25 May 2021 15:53:32 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 14PJrWYs031013; Tue, 25 May 2021 15:53:32 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 25 May 2021 15:53:32 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <alpine.LRH.2.02.2105251550110.29706@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] improve kcopyd latency
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I've made this patch that improves kcopyd latency. When we set the bit 
DM_KCOPYD_EARLY_CALLBACK, the completion is called from the interrupt 
context instead of process context.

I'd like to ask if you can benchmark it and test if it improves 
performance of dm-thin and dm-cache.

Mikulas



Index: linux-2.6/drivers/md/dm-cache-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-target.c
+++ linux-2.6/drivers/md/dm-cache-target.c
@@ -1171,9 +1171,9 @@ static void copy(struct dm_cache_migrati
 	c_region.count = cache->sectors_per_block;
 
 	if (promote)
-		dm_kcopyd_copy(cache->copier, &o_region, 1, &c_region, 0, copy_complete, &mg->k);
+		dm_kcopyd_copy(cache->copier, &o_region, 1, &c_region, 1UL << DM_KCOPYD_EARLY_CALLBACK, copy_complete, &mg->k);
 	else
-		dm_kcopyd_copy(cache->copier, &c_region, 1, &o_region, 0, copy_complete, &mg->k);
+		dm_kcopyd_copy(cache->copier, &c_region, 1, &o_region, 1UL << DM_KCOPYD_EARLY_CALLBACK, copy_complete, &mg->k);
 }
 
 static void bio_drop_shared_lock(struct cache *cache, struct bio *bio)
Index: linux-2.6/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-kcopyd.c
+++ linux-2.6/drivers/md/dm-kcopyd.c
@@ -512,6 +512,10 @@ static int run_complete_job(struct kcopy
 	return 0;
 }
 
+static void null_completion(int read_err, unsigned long write_err, void *context)
+{
+}
+
 static void complete_io(unsigned long error, void *context)
 {
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
@@ -532,10 +536,13 @@ static void complete_io(unsigned long er
 		}
 	}
 
-	if (op_is_write(job->rw))
+	if (op_is_write(job->rw)) {
+		if (test_bit(DM_KCOPYD_EARLY_CALLBACK, &job->flags)) {
+			job->fn(job->read_err, job->write_err, job->context);
+			job->fn = null_completion;
+		}
 		push(&kc->complete_jobs, job);
-
-	else {
+	} else {
 		job->rw = WRITE;
 		push(&kc->io_jobs, job);
 	}
@@ -735,6 +742,7 @@ static void segment_complete(int read_er
 			sub_job->dests[i].count = count;
 		}
 
+		sub_job->flags &= ~(1UL << DM_KCOPYD_EARLY_CALLBACK);
 		sub_job->fn = segment_complete;
 		sub_job->context = sub_job;
 		dispatch_job(sub_job);
Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c
+++ linux-2.6/drivers/md/dm-thin.c
@@ -1359,7 +1359,7 @@ static void schedule_copy(struct thin_c
 		to.count = len;
 
 		dm_kcopyd_copy(pool->copier, &from, 1, &to,
-			       0, copy_complete, m);
+			       1UL << DM_KCOPYD_EARLY_CALLBACK, copy_complete, m);
 
 		/*
 		 * Do we need to zero a tail region?
Index: linux-2.6/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.orig/include/linux/dm-kcopyd.h
+++ linux-2.6/include/linux/dm-kcopyd.h
@@ -19,8 +19,9 @@
 /* FIXME: make this configurable */
 #define DM_KCOPYD_MAX_REGIONS 8
 
-#define DM_KCOPYD_IGNORE_ERROR 1
-#define DM_KCOPYD_WRITE_SEQ    2
+#define DM_KCOPYD_IGNORE_ERROR		1
+#define DM_KCOPYD_WRITE_SEQ		2
+#define DM_KCOPYD_EARLY_CALLBACK	3
 
 struct dm_kcopyd_throttle {
 	unsigned throttle;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

