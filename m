Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB64FC6FD1F
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 18:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679509198;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HdUGUXjd5BrWgXdo1dsReiyw+SbAAvjdiV3Me7BBE0k=;
	b=Xs2HMlpJHGEqe8Go6++aYpI7O25pUrP69pfgEGEpS/x+iwHabSTu+4p76lvKDzgvGRjlCt
	TU+FRLHahC1NFodKLZiSuPck+SmDzATJYoqL9ELMvvlhQbLNF/FJWpACKbhegf+vKcoWeb
	C98Rn4tvBhEBoovvPkVtLVDqvb1cwKw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-wccAQL12NpmLEV6U8Y96UA-1; Wed, 22 Mar 2023 14:19:55 -0400
X-MC-Unique: wccAQL12NpmLEV6U8Y96UA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 118881C0758F;
	Wed, 22 Mar 2023 18:19:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 008C740C6E67;
	Wed, 22 Mar 2023 18:19:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 56F151946A4F;
	Wed, 22 Mar 2023 18:19:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BE82819465BB
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A256F43FBD; Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A39A175AD
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E5353C0F666
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 18:19:35 +0000 (UTC)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com
 [209.85.160.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-2pqBI4xyPXWrhPUy6QoBPw-3; Wed, 22 Mar 2023 14:19:34 -0400
X-MC-Unique: 2pqBI4xyPXWrhPUy6QoBPw-3
Received: by mail-qt1-f172.google.com with SMTP id c19so23792807qtn.13
 for <dm-devel@redhat.com>; Wed, 22 Mar 2023 11:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679509173;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=n5A5Y/Y8LHcxD0wMnNVqZPjKuUEzLnZMKi0wNkDICVE=;
 b=Btww2aYLExX4NuJX+GsYhQ6NbWqWuI7eMTvl4VKl/MmvTZ2tLP+OquowB8bnCRVcT4
 1Wj8gPDBsO/XDkppBOtRNz4Y/TfTJNbLA5WFsbbRBRCCQTYi9peAOeHzyBGoLkBP1b4t
 wsqdsYCGvA4GeKHNlRR9LNcPyCZi5NdrTuu7TxAtsdIL9sdLBVwMemSNCcRuH49Mlsab
 Te4YkQyjhrRmcPnME8wXSfFfSYaeTcNJE4XjZdXylZo/r4McN/H+H+Zm3vqbpvi2xd9U
 nsjf5Rhsz/xVvG7GZW0TJKbeE6+5syuuA8hQe14aj2yA58EQNLHkBQmnYMDtagb6amzW
 tGvw==
X-Gm-Message-State: AO0yUKVruo9hAD+1BXvSCSIZKPvbLK5endS/WbFfzdo/6nEvn7m5vGPC
 jnz6yWvDSKaRhZUaYZYuo+z8Ns3mt7gacHiOOQr9UvMZK6hOk+cxglUGPpZCmxd+m6JEkbNw2zw
 BHlbq6w76DPCqlcnYANpcwt6TfeXHIYpS21SdibRiXXYSo8Luj/wKxrZi2WovCBuGF59vU6k9U6
 A=
X-Google-Smtp-Source: AK7set+BENVP4cjIGugoDAvYshyb2nqbfz61AugE1yIkpYFzNWYhAmJQ5MNipu9LxkLQm27WeqY2Zw==
X-Received: by 2002:a05:622a:488:b0:3db:7f42:ab19 with SMTP id
 p8-20020a05622a048800b003db7f42ab19mr7374407qtx.15.1679509173552; 
 Wed, 22 Mar 2023 11:19:33 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 j185-20020a37b9c2000000b007465ad44891sm10722346qkf.102.2023.03.22.11.19.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 22 Mar 2023 11:19:33 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Wed, 22 Mar 2023 14:18:45 -0400
Message-Id: <20230322181845.29848-9-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-1-snitzer@kernel.org>
References: <20230322181845.29848-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [dm-6.4 PATCH 8/8] dm thin: speed up
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
Cc: keescook@chromium.org, heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 nhuck@google.com, ebiggers@kernel.org, ejt@redhat.com, mpatocka@redhat.com,
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
index 286e4d9e45c8..583159dc8084 100644
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

