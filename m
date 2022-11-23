Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB9CC3A59F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669209408;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Dw3EIQHBbrE/GPQcAsh5T1e4x2RuMNyDvzK9kE9fUd8=;
	b=G1PseSVQRYtlvj4cN4mJrGRDJOa1xtHtJRub1y/z8E2zsKreohvT1vRgdC9GB3M219B/OG
	rIjrv1yRo+JcuW5heGD0XammmOfsekXi9wBB79khgPG+ZjXJYY+e9avhOgCY7MctD4p6t1
	6rirgZETM8mwK9fWuReEe2zcsqeyFTY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-7dQHMoO2PLCNHqcKuXYZvw-1; Wed, 23 Nov 2022 08:16:44 -0500
X-MC-Unique: 7dQHMoO2PLCNHqcKuXYZvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57C833C0F25A;
	Wed, 23 Nov 2022 13:16:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 412E6111CB81;
	Wed, 23 Nov 2022 13:16:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7B4319466DF;
	Wed, 23 Nov 2022 13:16:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 511A91946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 12:44:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 33F534B3FCD; Wed, 23 Nov 2022 12:44:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CB3A4B3FC6
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 12:44:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1204C1C07824
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 12:44:59 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-ScRmP4odOEq1-0CHimahuQ-1; Wed, 23 Nov 2022 07:44:57 -0500
X-MC-Unique: ScRmP4odOEq1-0CHimahuQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 704EF61CBB;
 Wed, 23 Nov 2022 12:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DECBC43470;
 Wed, 23 Nov 2022 12:44:55 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Date: Wed, 23 Nov 2022 07:44:25 -0500
Message-Id: <20221123124427.266286-15-sashal@kernel.org>
In-Reply-To: <20221123124427.266286-1-sashal@kernel.org>
References: <20221123124427.266286-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH AUTOSEL 5.4 15/15] dm integrity: flush the
 journal on suspend
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
Cc: Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 5e5dab5ec763d600fe0a67837dd9155bdc42f961 ]

This commit flushes the journal on suspend. It is prerequisite for the
next commit that enables activating dm integrity devices in read-only mode.

Note that we deliberately didn't flush the journal on suspend, so that the
journal replay code would be tested. However, the dm-integrity code is 5
years old now, so that journal replay is well-tested, and we can make this
change now.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b0f4311cb418..4f3622b11163 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2346,10 +2346,6 @@ static void integrity_writer(struct work_struct *w)
 
 	unsigned prev_free_sectors;
 
-	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
-		return;
-
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
 	write_sections = ic->n_committed_sections;
@@ -2858,8 +2854,7 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 	drain_workqueue(ic->commit_wq);
 
 	if (ic->mode == 'J') {
-		if (ic->meta_dev)
-			queue_work(ic->writer_wq, &ic->writer_work);
+		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
 	}
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

