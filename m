Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B718C678DB
	for <dm-devel@archiver.kernel.org>; Sun,  5 Mar 2023 02:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677984776;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eg7ITHv2XCAFiRvpIqkV4RaHRSNGTJnf9EDnLOuDuCA=;
	b=Dnny+jw2rFCHJn9hEU1F5SNKXw6WASNntLymtup6V6GOobFDj+5wN7OJzBmcNV0VRuK6BU
	0IDGs8/c8xl6kJiVwkkAST83i1E3H/sM1d8iSI7YzP7Ed1Ef3rbwc7u5MS34gclY6im4ul
	J7IKSgUSnPuLzHA3XKf1/Rv8mS7g1EU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-HSDACuZyMB2ol0YySfDVNA-1; Sat, 04 Mar 2023 21:52:52 -0500
X-MC-Unique: HSDACuZyMB2ol0YySfDVNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C400185A78B;
	Sun,  5 Mar 2023 02:52:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B4DA40C6EC4;
	Sun,  5 Mar 2023 02:52:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1829A1946594;
	Sun,  5 Mar 2023 02:52:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F21D81946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 02:52:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E53DD492B00; Sun,  5 Mar 2023 02:52:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDFA8492C3E
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 02:52:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFBFB1C05AF3
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 02:52:48 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-nGuk_r1HMfSaXKkb-YFPCw-1; Sat, 04 Mar 2023 21:52:47 -0500
X-MC-Unique: nGuk_r1HMfSaXKkb-YFPCw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 9F7D2B8010F;
 Sun,  5 Mar 2023 02:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E73C433D2;
 Sun,  5 Mar 2023 02:52:43 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	snitzer@kernel.org
Date: Sat,  4 Mar 2023 21:52:42 -0500
Message-Id: <20230305025242.1730363-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] Patch "dm: remove flush_scheduled_work() during
 local_exit()" has been added to the 6.1-stable tree
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a note to let you know that I've just added the patch titled

    dm: remove flush_scheduled_work() during local_exit()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-remove-flush_scheduled_work-during-local_exit.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit ea54b05e6203ae8a3716b57f71046d8182515922
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
index d49809e9db96e..2ce16e6c1e357 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -231,7 +231,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	unregister_blkdev(_major, _name);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

