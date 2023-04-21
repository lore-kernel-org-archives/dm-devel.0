Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 576CAC7618E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 02:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682045472;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ve66uNqzyal7ZHAKwJjP3mkBKj147i/m3IvA/T/wMjQ=;
	b=Ukl02Y/SHnNLjun0n0uGkF+Q2hU+/Pw9oGTz0+1kIFdB8DgwBTw5XCQih6pT5FyMuTX7Yo
	KCtmABnNeRF+u+nSXvW9J4AjGyYWaLKdcIYbLkGuBUbm61/03bErhTq2GfV/5FO0occjOc
	jVUqDnhUCQbmmQExFPSpBnyoHFJ3P+Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-Vqlmt6glMjCy8CCRspO9sA-1; Thu, 20 Apr 2023 22:51:09 -0400
X-MC-Unique: Vqlmt6glMjCy8CCRspO9sA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DB7F2A59544;
	Fri, 21 Apr 2023 02:51:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C576340C2064;
	Fri, 21 Apr 2023 02:51:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1E0A1946A40;
	Fri, 21 Apr 2023 02:51:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E1B919466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Apr 2023 02:51:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5CAACC16026; Fri, 21 Apr 2023 02:51:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5428DC16024
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 02:51:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 389082A59563
 for <dm-devel@redhat.com>; Fri, 21 Apr 2023 02:51:02 +0000 (UTC)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-lEBZOECnPJO6MmkOlg8rYQ-1; Thu, 20 Apr 2023 22:50:59 -0400
X-MC-Unique: lEBZOECnPJO6MmkOlg8rYQ-1
Received: by mail-pg1-f174.google.com with SMTP id
 41be03b00d2f7-518d325b8a2so1726248a12.0; 
 Thu, 20 Apr 2023 19:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682045458; x=1684637458;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
 :to:cc:subject:date:message-id:reply-to;
 bh=Kmxq/N/H4rwg524LDGOZfm1KVVcee8vyb3VSvQP8F5Y=;
 b=CEbY0EL+DJ2KFBajAQrIpacObY9qFDjdNOvPQx0FllOBw1ZIY/GxAx2f8sS++NmGlt
 aCXVNyfCgHAq3/afVpiotWyxjMCe/PjOt/FtM5l0qGBTMij12SaONCqCHr5WAwM2fq2Y
 CS3TO1+ZmSxkGetdhHbfLZOI8ZlfgAauD0r5VHRzsHFeaSkGnTfmgfLg43N6DEnVw7eE
 X9Ki8bVIpRRtk6CKvBRuAoIvMKectMTnXlsAAWhuG7Jzk/AGIw18x+Ai+0AIGVnTvcyW
 4lR1/+wWGXY/4H9O0uGM6f7nF61XtifQoHnru6aaj3R8cct6ZUpiamz2TfLfF0ifmheP
 ni5g==
X-Gm-Message-State: AAQBX9djIcZIvv2bIcdVWbOO3rJs60JetP7M3lqu/b7nvXj+93vJCODw
 GjcNHXxVmSE9s5a6cvHi0MU=
X-Google-Smtp-Source: AKy350aqDpfwIiNBxQVsj/SwKpAWaUrT+Zg1S2t7A6JKHmkdLX6vogU3qmIOHjok4Zu0N2ZogY9SQg==
X-Received: by 2002:a17:902:ceca:b0:19e:665b:2514 with SMTP id
 d10-20020a170902ceca00b0019e665b2514mr4741371plg.43.1682045458279; 
 Thu, 20 Apr 2023 19:50:58 -0700 (PDT)
Received: from localhost
 (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com.
 [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
 by smtp.gmail.com with ESMTPSA id
 q92-20020a17090a756500b00246f73a994esm1767145pjk.32.2023.04.20.19.50.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 19:50:57 -0700 (PDT)
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Date: Thu, 20 Apr 2023 16:50:28 -1000
Message-Id: <20230421025046.4008499-5-tj@kernel.org>
In-Reply-To: <20230421025046.4008499-1-tj@kernel.org>
References: <20230421025046.4008499-1-tj@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 04/22] dm integrity: Use
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
index b0d5057fbdd9..6b36554f9103 100644
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
index dfde0088147a..bd3342613e4c 100644
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
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

