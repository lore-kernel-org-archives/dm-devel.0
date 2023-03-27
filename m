Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B5EC6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948010;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tRatwY+TYZxRkLdO/ss4BQCgdJBqNUssHPPPaZrIFR0=;
	b=WroG9JPMDLCwnSChQlXV/XWx5zGqC7Ega1ljK5X3rljibjeYJpvWNd9beoc4m21XL4+tel
	Xrx8mB76jyTAq2Y1t0gY/BxOAK4/MIIzlL9m6ALyUd4DlVciZldT0AdTDe3F1rMBfJdC+q
	ezWsJUdZx0JiJGucyEHvwbaG5+zrfVc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-u4u-6YDlPlu8qsam2PM7gQ-1; Mon, 27 Mar 2023 16:13:28 -0400
X-MC-Unique: u4u-6YDlPlu8qsam2PM7gQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9199E802D32;
	Mon, 27 Mar 2023 20:13:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4281D202701F;
	Mon, 27 Mar 2023 20:13:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DF2419465A2;
	Mon, 27 Mar 2023 20:13:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7C0C319465B9
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60E3D4020C85; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 594AC4020C82
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D8393C0E44A
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-0mQhJb7zOP-LA3iJKqHCBQ-1; Mon, 27 Mar 2023 16:13:13 -0400
X-MC-Unique: 0mQhJb7zOP-LA3iJKqHCBQ-1
Received: by mail-qt1-f174.google.com with SMTP id cj15so2315900qtb.5
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679947993;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=hmqlLAmAcoDYlM73GWg+waCa1PP8Bn6cws6QITx68xo=;
 b=Bbxo4b4mPuDMGnyHqrfz4rrjuykQP8uJqh4WmYd1VVZ8UM0AU2ctz8X6D5QzKq2gZO
 ZPBroTmBBoCDrHZA15ZMB8l4y5gg1bP8KC/YYlVHqFQt1dO8osbDC4Uyu/ZnNXEgC/zE
 eNaBjfSfozpIQjuafZgnJUHXJ7i1iJ18G6CbDjmZpe8kJsJZ7apzWw4qgFxS69u5bww0
 PkNfDihGugJXW//09iANTxWM3ZKV0xPdNVr2ify4lw2euqGg+DtDa50xEo+ezhIPcXA6
 OfR4W/WFrYRzyXsFyfwr1t1EHBq0TTsUWRyUPcNj3SsGgUJ4cPLAL3Ai3j/X0YD5/GUj
 JowQ==
X-Gm-Message-State: AAQBX9coA3kcvQ5YoT8jlhHBxCyQ/JrKdhcqFCczoeNlNVtS61agB3jl
 92mHfeffJXjmiGIjkrYwUQUWcxS7JaCgHNkOn54V3+siTnc2B/Xyk3UvUhaO0va7Oh8zB3WWpjL
 4TSjsujHxLYC8VaXzijYOTJERasBCxZWnPV9R8vBi+mgbGjY1qs+oy8c8b3zh16xh0BDVkuKso7
 k=
X-Google-Smtp-Source: AKy350b9yynzcGT7R923zG1Nqhk3Mn4VUNQG7FVDF/2AYEYBKvcrKmzGtyrZXsaF2wG0qO6dp7ngxQ==
X-Received: by 2002:a05:622a:1002:b0:3e4:dbfa:ee2b with SMTP id
 d2-20020a05622a100200b003e4dbfaee2bmr15465044qte.17.1679947992941; 
 Mon, 27 Mar 2023 13:13:12 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 141-20020a370793000000b0074672975d5csm12784571qkh.91.2023.03.27.13.13.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:12 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:27 -0400
Message-Id: <20230327201143.51026-5-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH v3 04/20] dm bufio: don't bug for clear
 developer oversight
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reasonable to relax to WARN_ON because these are easily avoided but do
offer some assurance future coding mistakes won't occur (if changes
tested properly).

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index d63f94ab1d9f..64fb5fd39bd9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -378,8 +378,10 @@ static void adjust_total_allocated(struct dm_buffer *b, bool unlink)
  */
 static void __cache_size_refresh(void)
 {
-	BUG_ON(!mutex_is_locked(&dm_bufio_clients_lock));
-	BUG_ON(dm_bufio_client_count < 0);
+	if (WARN_ON(!mutex_is_locked(&dm_bufio_clients_lock)))
+		return;
+	if (WARN_ON(dm_bufio_client_count < 0))
+		return;
 
 	dm_bufio_cache_size_latch = READ_ONCE(dm_bufio_cache_size);
 
@@ -1536,7 +1538,8 @@ static void drop_buffers(struct dm_bufio_client *c)
 	int i;
 	bool warned = false;
 
-	BUG_ON(dm_bufio_in_request());
+	if (WARN_ON(dm_bufio_in_request()))
+		return; /* should never happen */
 
 	/*
 	 * An optimization so that the buffers are not written one-by-one.
@@ -1556,7 +1559,7 @@ static void drop_buffers(struct dm_bufio_client *c)
 			      (unsigned long long)b->block, b->hold_count, i);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 			stack_trace_print(b->stack_entries, b->stack_len, 1);
-			/* mark unclaimed to avoid BUG_ON below */
+			/* mark unclaimed to avoid WARN_ON below */
 			b->hold_count = 0;
 #endif
 		}
@@ -1567,7 +1570,7 @@ static void drop_buffers(struct dm_bufio_client *c)
 #endif
 
 	for (i = 0; i < LIST_SIZE; i++)
-		BUG_ON(!list_empty(&c->lru[i]));
+		WARN_ON(!list_empty(&c->lru[i]));
 
 	dm_bufio_unlock(c);
 }
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

