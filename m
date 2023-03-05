Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586D4C678DB
	for <dm-devel@archiver.kernel.org>; Sun,  5 Mar 2023 04:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677988943;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zfMylNd/Wz/5pbtf7MyIDKmDlThfe+qlQ9cGAAO93a8=;
	b=Qxm1TzcYLxxcDl5d3ZHq1MPJFGwXPf47rS6Mg9n9C60efIiZ373WMVrrtVPXY/mr6YqHby
	iKY+TWw+88IyH9HmSU2SGcbpKRq4g97fOA0vUAIhN1oTnv6x0nEaEGpyv1eZnaCeW3ODz+
	ZxI42weHhRWUHQezrjYlAFVaGISOyVw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-kiDRU7FuPT-nEO13jr3BAw-1; Sat, 04 Mar 2023 23:02:19 -0500
X-MC-Unique: kiDRU7FuPT-nEO13jr3BAw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A7F03C0256C;
	Sun,  5 Mar 2023 04:02:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16C3D2026D76;
	Sun,  5 Mar 2023 04:02:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB00C1946594;
	Sun,  5 Mar 2023 04:02:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8264E1946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 04:02:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 571791415117; Sun,  5 Mar 2023 04:02:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FCBE140EBF6
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 04:02:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 311E329AA3B8
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 04:02:16 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-uBAfWIcpN96npTKAs0T3hw-1; Sat, 04 Mar 2023 23:02:14 -0500
X-MC-Unique: uBAfWIcpN96npTKAs0T3hw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3BC10B80924;
 Sun,  5 Mar 2023 04:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820DDC433D2;
 Sun,  5 Mar 2023 04:02:11 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	snitzer@kernel.org
Date: Sat,  4 Mar 2023 23:02:09 -0500
Message-Id: <20230305040209.1786774-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] Patch "dm: remove flush_scheduled_work() during
 local_exit()" has been added to the 4.14-stable tree
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: remove flush_scheduled_work() during local_exit()

to the 4.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-remove-flush_scheduled_work-during-local_exit.patch
and it can be found in the queue-4.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit d9f3508d7786ed25d0ec93da42c4c5d73d420dd2
Author: Mike Snitzer <snitzer@kernel.org>
Date:   Tue Feb 14 13:06:05 2023 -0500

    dm: remove flush_scheduled_work() during local_exit()
    
    [ Upstream commit 0b22ff5360f5c4e11050b89206370fdf7dc0a226 ]
    
    Commit acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred
    device removal") switched from using system workqueue to a single
    workqueue local to DM.  But it didn't eliminate the call to
    flush_scheduled_work() that was introduced purely for the benefit of
    deferred device removal with commit 2c140a246dc ("dm: allow remove to
    be deferred").
    
    Since DM core uses its own workqueue (and queue_work) there is no need
    to call flush_scheduled_work() from local_exit().  local_exit()'s
    destroy_workqueue(deferred_remove_workqueue) handles flushing work
    started with queue_work().
    
    Fixes: acfe0ad74d2e1 ("dm: allocate a special workqueue for deferred device removal")
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e6689fd22730..e3facf14f6149 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -220,7 +220,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	kmem_cache_destroy(_rq_cache);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

