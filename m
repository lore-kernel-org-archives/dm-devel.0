Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC73C7EE22
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 01:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683597051;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GucYW9B4V7wfPAQbowdd+ItyxPa28/qD6FZegOf0erw=;
	b=Bt/RzaDtaHi40Pa5LFDU9ZURkOr4gen2p7MYQysymnqf3YFfoc6Rw7a6oTptoQDgx2N+9L
	Rs43S0CBmkwP+4zsBfvpTzDSkwf/X1Cj1Q7t2B8fSP328Ay4Nw3o+6CdPCHqLYvVeANouX
	yJBJHXMgZSgb7ol3mtz4ZmTBqd2eIOE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-6UOiP-FoPt2jHRMyJwu4Gw-1; Mon, 08 May 2023 21:50:48 -0400
X-MC-Unique: 6UOiP-FoPt2jHRMyJwu4Gw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 608EA185A790;
	Tue,  9 May 2023 01:50:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D0E61121314;
	Tue,  9 May 2023 01:50:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DCBAE19452C5;
	Tue,  9 May 2023 01:50:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 33B1D19452C4
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 01:50:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5AAF2166B41; Tue,  9 May 2023 01:50:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DD47B2166B40
 for <dm-devel@redhat.com>; Tue,  9 May 2023 01:50:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93D4B85A5B1
 for <dm-devel@redhat.com>; Tue,  9 May 2023 01:50:44 +0000 (UTC)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-eSIg6IblM1mk-N5_R6N_gw-1; Mon, 08 May 2023 21:50:43 -0400
X-MC-Unique: eSIg6IblM1mk-N5_R6N_gw-1
Received: by mail-pg1-f180.google.com with SMTP id
 41be03b00d2f7-51b4ef5378bso4801068a12.1; 
 Mon, 08 May 2023 18:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683597041; x=1686189041;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
 :to:cc:subject:date:message-id:reply-to;
 bh=iNyRxdWCADhD9rUKa2TrMn4tF/rgjlUTD8AJ6N7yTPI=;
 b=CxwSDGsWHMUjLLiNGGCi31sDF3a9cMCJiFP8ffBWQTJF8Yo5vV3ksQcbrX8ityV7IQ
 Z/PaqOfvclAiNzLlzcrSEvm9GDyFT6JxJz7CX0N4RLgEKjvQFofB2jmMYF95YE4R57ql
 p0NhHPfV64hUOmDzBdYJRDXQHBIZnU++nBhPBEqpuv3Ppnq4mq3NaydRdMYAb6o+SK1p
 3NG2Swm/A0/G31xRq88OwpHf9d/Xxvi+z/5SajGviz7zz84oC0SdgIBlQDGkOFwuTdNc
 Bhz3FuUMBGoqS583TNLDpv8UhROoqQ5gkPEEsSN2f/jAR5HN3KxzaCPpdzgfEafbv72q
 0YHw==
X-Gm-Message-State: AC+VfDwCtps7PFz/o7x6GgPyXYSV1HFoMDCBX8nqXG2UCM96efH8N4wg
 TARqlxLeZssAnQU6bawuMTyxXZnXbcQ=
X-Google-Smtp-Source: ACHHUZ7nldx8UeT/R4azQMvNmEw7AIvCa83fBwYQtaNq8RV+v9QFejd53ePEVKYVGY1AcFYXmQiTgA==
X-Received: by 2002:a05:6a21:32a0:b0:ff:f2c3:c103 with SMTP id
 yt32-20020a056a2132a000b000fff2c3c103mr10292465pzb.18.1683597041398; 
 Mon, 08 May 2023 18:50:41 -0700 (PDT)
Received: from localhost
 (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com.
 [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
 by smtp.gmail.com with ESMTPSA id
 p36-20020a634f64000000b0050f56964426sm145085pgl.54.2023.05.08.18.50.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 08 May 2023 18:50:41 -0700 (PDT)
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Date: Mon,  8 May 2023 15:50:22 -1000
Message-Id: <20230509015032.3768622-4-tj@kernel.org>
In-Reply-To: <20230509015032.3768622-1-tj@kernel.org>
References: <20230509015032.3768622-1-tj@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 03/13] dm integrity: Use
 alloc_ordered_workqueue() to create ordered workqueues
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
Cc: kernel-team@meta.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

BACKGROUND
==========

When multiple work items are queued to a workqueue, their execution order
doesn't match the queueing order. They may get executed in any order and
simultaneously. When fully serialized execution - one by one in the queueing
order - is needed, an ordered workqueue should be used which can be created
with alloc_ordered_workqueue().

However, alloc_ordered_workqueue() was a later addition. Before it, an
ordered workqueue could be obtained by creating an UNBOUND workqueue with
@max_active==1. This originally was an implementation side-effect which was
broken by 4c16bd327c74 ("workqueue: restore WQ_UNBOUND/max_active==1 to be
ordered"). Because there were users that depended on the ordered execution,
5c0338c68706 ("workqueue: restore WQ_UNBOUND/max_active==1 to be ordered")
made workqueue allocation path to implicitly promote UNBOUND workqueues w/
@max_active==1 to ordered workqueues.

While this has worked okay, overloading the UNBOUND allocation interface
this way creates other issues. It's difficult to tell whether a given
workqueue actually needs to be ordered and users that legitimately want a
min concurrency level wq unexpectedly gets an ordered one instead. With
planned UNBOUND workqueue updates to improve execution locality and more
prevalence of chiplet designs which can benefit from such improvements, this
isn't a state we wanna be in forever.

This patch series audits all callsites that create an UNBOUND workqueue w/
@max_active==1 and converts them to alloc_ordered_workqueue() as necessary.

WHAT TO LOOK FOR
================

The conversions are from

  alloc_workqueue(WQ_UNBOUND | flags, 1, args..)

to

  alloc_ordered_workqueue(flags, args...)

which don't cause any functional changes. If you know that fully ordered
execution is not ncessary, please let me know. I'll drop the conversion and
instead add a comment noting the fact to reduce confusion while conversion
is in progress.

If you aren't fully sure, it's completely fine to let the conversion
through. The behavior will stay exactly the same and we can always
reconsider later.

As there are follow-up workqueue core changes, I'd really appreciate if the
patch can be routed through the workqueue tree w/ your acks. Thanks.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/md/dm-integrity.c | 4 ++--
 drivers/md/dm.c           | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 31838b13ea54..63ec502fcb12 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4268,10 +4268,10 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 	}
 
 	/*
-	 * If this workqueue were percpu, it would cause bio reordering
+	 * If this workqueue weren't ordered, it would cause bio reordering
 	 * and reduced performance.
 	 */
-	ic->wait_wq = alloc_workqueue("dm-integrity-wait", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	ic->wait_wq = alloc_ordered_workqueue("dm-integrity-wait", WQ_MEM_RECLAIM);
 	if (!ic->wait_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b694ba3a106..9599d76cc9a9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -207,7 +207,7 @@ static int __init local_init(void)
 	if (r)
 		return r;
 
-	deferred_remove_workqueue = alloc_workqueue("kdmremove", WQ_UNBOUND, 1);
+	deferred_remove_workqueue = alloc_ordered_workqueue("kdmremove", 0);
 	if (!deferred_remove_workqueue) {
 		r = -ENOMEM;
 		goto out_uevent_exit;
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

