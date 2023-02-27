Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628C1C64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 02:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677463900;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ouR/LRux+VbKv3cWUADOhg3XSpsybkRUAkau0UjKRlU=;
	b=Fr+BWMbXidbR6l10TOW6h9o6pMDXd5vHjr8k0Pi8f4VZYyIk5HKk9tn3XJkMv4kjBHR7Rt
	CouncqY3RKVXGUYSDj5fVBTXXLhVighN0JpXgHtcOhoSbfk/UBCgsRxBPsMU0fw6mCp7Hm
	U+CoZglDeN7BOCTzPnFfT0yP8Q6odZY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-o8LSokKHOEqJNxm6EOas6A-1; Sun, 26 Feb 2023 21:11:36 -0500
X-MC-Unique: o8LSokKHOEqJNxm6EOas6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 774BA882824;
	Mon, 27 Feb 2023 02:11:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65A4A140EBF6;
	Mon, 27 Feb 2023 02:11:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 47B851946594;
	Mon, 27 Feb 2023 02:11:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5DEB01946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 02:11:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E978C15BAE; Mon, 27 Feb 2023 02:11:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 36EC4C15BAD
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 02:11:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18D8795D600
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 02:11:34 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-Zzfibmk9NkG9cPZPVcbsyw-1; Sun, 26 Feb 2023 21:11:32 -0500
X-MC-Unique: Zzfibmk9NkG9cPZPVcbsyw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E4C63B80D23;
 Mon, 27 Feb 2023 02:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C00C4339B;
 Mon, 27 Feb 2023 02:11:28 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Date: Sun, 26 Feb 2023 21:11:06 -0500
Message-Id: <20230227021110.1053474-9-sashal@kernel.org>
In-Reply-To: <20230227021110.1053474-1-sashal@kernel.org>
References: <20230227021110.1053474-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH AUTOSEL 4.19 09/10] dm thin: add cond_resched()
 to various workqueue loops
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
Cc: Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e4f80303c2353952e6e980b23914e4214487f2a6 ]

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 386cb33953783..969ea013c74e4 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2222,6 +2222,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2305,6 +2306,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

