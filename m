Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FCAC77B61
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680667;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6XusNNgPye6YWNO8uR7HXXGvCeN2EUngVHyjX/W7QXA=;
	b=bRcogCUVnBW/+3tvp8aGLBX4BckBKuVdWGnzSLQexkKo/ENhsOT5jBt64dd2YCtaArQyuZ
	Jq8K0Q9oN19UjTEzDGzXolfwakNJnUJSl0QhG9IiguSgqeMuUINAD089fTO+EMDZAM+iyn
	i6ffkBqvhU08I/TadRwSPCUeW05kBaY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-qPf9gqXDN2mgIsXV9OTT_Q-1; Fri, 24 Mar 2023 13:57:42 -0400
X-MC-Unique: qPf9gqXDN2mgIsXV9OTT_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C388802D2E;
	Fri, 24 Mar 2023 17:57:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4A8CB40C6E67;
	Fri, 24 Mar 2023 17:57:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6ADF19472DC;
	Fri, 24 Mar 2023 17:57:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0747519472C2
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE0D040C6E68; Fri, 24 Mar 2023 17:57:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E59A840C6E67
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC573886463
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:13 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-3e1bOS_pORmrxmbfocu_1g-2; Fri, 24 Mar 2023 13:57:11 -0400
X-MC-Unique: 3e1bOS_pORmrxmbfocu_1g-2
Received: by mail-qv1-f47.google.com with SMTP id 31so2202565qvc.1
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680630;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=7GATmDpp2LqxaO3YBsTr83VB1ZcPRtnkKD4xtYp0nm8=;
 b=RH7Smex85kYIo+6ejdYeJleCckkdXUnXF4t+avFOQtK5tr4hYM1tebxh0kPOYUj0cw
 D5TA91jQ/hlIZNvBwgcnN2hrtK6EYRzNvtEyPx4FWwbUSxgbZABI4bc9xYUtIC3ajgsP
 bKySMvp4vgTi/0dWAjPN1nwWUlHFaA391a7IIraD3MZhjc5kCKvNHoA30vM8PAEF0hMI
 QbicCfMNVnEDW9+DR4CmkqlsowAUHWwMbfi+VrW5+TH1UjAk5ggYDQeDoUX7dVvLwEz1
 eHdLHp9XLdEsbEI0N18HVNY4RUsum/tXFsZXe8oNd6caviG2SPXQ1bveYjmIKmxeO8aH
 fIFA==
X-Gm-Message-State: AAQBX9duTRd2YYmHt/1j5saD7H2Uzenco7HaksGWrueEQaR47E95c6Nv
 mSjT0jaF8mDAs5j7p5wnV319PlUudFcB8j69e/TmnBTabIiIgD+wGHi49MkerigGJ5HTXl+VoQN
 W7ttEfYGN1sYMMbZyjb5G/3XAawlYcffCQ/i5/R4QvhgYXIpA3zZIkSBVR0JGvelLwg5tMRNxW/
 Q=
X-Google-Smtp-Source: AKy350ZtoK3QhI7V4jQoKyRj8RRPy+HsVSg5fhN94i68TW8ZYwcPzF6HgFN8Nykpq82YzgyFXcllwg==
X-Received: by 2002:a05:6214:2303:b0:5c6:cd00:aaa1 with SMTP id
 gc3-20020a056214230300b005c6cd00aaa1mr6249028qvb.39.1679680630706; 
 Fri, 24 Mar 2023 10:57:10 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 6-20020a05620a040600b006f9f3c0c63csm3541115qkp.32.2023.03.24.10.57.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:10 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:54 -0400
Message-Id: <20230324175656.85082-8-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH v2 7/9] dm thin: speed up
 cell_defer_no_holder()
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
Cc: ebiggers@kernel.org, keescook@chromium.org, heinzm@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Joe Thornber <ejt@redhat.com>

Reduce the time that a spinlock is held in cell_defer_no_holder().

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-thin.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 13d4677baafd..00323428919e 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -883,15 +883,17 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
 {
 	struct pool *pool = tc->pool;
 	unsigned long flags;
-	int has_work;
+	struct bio_list bios;
 
-	spin_lock_irqsave(&tc->lock, flags);
-	cell_release_no_holder(pool, cell, &tc->deferred_bio_list);
-	has_work = !bio_list_empty(&tc->deferred_bio_list);
-	spin_unlock_irqrestore(&tc->lock, flags);
+	bio_list_init(&bios);
+	cell_release_no_holder(pool, cell, &bios);
 
-	if (has_work)
+	if (!bio_list_empty(&bios)) {
+		spin_lock_irqsave(&tc->lock, flags);
+		bio_list_merge(&tc->deferred_bio_list, &bios);
+		spin_unlock_irqrestore(&tc->lock, flags);
 		wake_worker(pool);
+	}
 }
 
 static void thin_defer_bio(struct thin_c *tc, struct bio *bio);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

