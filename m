Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB7BC636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319346;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aGG0A0xkJQsP2K6h0xCIvtGpJUyplyefEwhAwRIJCJw=;
	b=EUIl4XxRqBhBDVDp56D1qVJFYUMrbdH6Oy06iwkH3HNRr/qO/4nJsE8RXAQdqEPrkQ738c
	1hSbZdQVdw54ZgaC99a1+76Ar+yf6T9eYqW4OwQ0ZgaKZeVQV8TANNbR8P0V+AKju9ztWZ
	k7Qlx7cxK/mEbN0Ify6e4fBCWPYPIfk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-206-WSven6GBMdmlYlNjQTO5rQ-1; Mon, 13 Feb 2023 15:15:42 -0500
X-MC-Unique: WSven6GBMdmlYlNjQTO5rQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E9FD3C025C7;
	Mon, 13 Feb 2023 20:15:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8C7D9140EBF6;
	Mon, 13 Feb 2023 20:15:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6990C1946595;
	Mon, 13 Feb 2023 20:15:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 125D61946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0857C492B03; Mon, 13 Feb 2023 20:15:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 01C11492B04
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBA8780D0F4
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:35 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-102-JYL1gww0NhCh0Ec1WF0Q4w-3; Mon, 13 Feb 2023 15:15:32 -0500
X-MC-Unique: JYL1gww0NhCh0Ec1WF0Q4w-3
Received: by mail-qt1-f178.google.com with SMTP id h24so15159068qta.12
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=v+LGtazCPPAW3+dWgu0cu8E0iNwLzfk9qdjgd+57dZk=;
 b=QLTU4PPqsFM6R06G0Cf9tu6Tv3x+thevv9fQZMS4SXJuQbH4Z5Ep9y5v9r1qJRs7vL
 F4MeHyV2F+KRYsdxcN/VzHCEc4AGJbO+6Gvwyv4u9v3Y3uyNsZPHOM/L2jXJY1ePJGh/
 WE6aJ5PdMhpD198zZxbzUUT5yPuQST5fA/Niv1CBqYmdtez/J65omgPhPidb4B9h4Fmd
 32tekxR0x9etAJaypehEDQGuTFpWcZABGINkK1BrOPGHqXwUnNKib1oT00oIzWnWo1fj
 KCDLPOrAhHCZ3LZmawwEEewikssv/dm4FShkDXqIFptRmvf9z9fhqw7KG/t59+5fZReY
 H0Kw==
X-Gm-Message-State: AO0yUKWkZjSWA7aTx9DnkWPs22vlmApRhJB4T6j1sJrf2nPukG6A2xt/
 kUjDOj2bJOsfb4jcXm2GFbQ+AEgFVFaRZHaiWmLBMkRwvyM062aVZjrZ33CEvagC9iS7dUzMTDp
 On9AVqAH93l5iw8QT70mkZvZWGpOQC12oYM5ir+RU37Tb9mjBDAnd+C6OdLL3qpxsbP5zmQ==
X-Google-Smtp-Source: AK7set9/TLmmf/Bn5VElSSoozCOkouPtzMgC1gmJUTrNrU/sTGzE7/8ioPa5y4ToI5S2aivsx+FtLg==
X-Received: by 2002:ac8:5bcb:0:b0:3b9:bf43:fccd with SMTP id
 b11-20020ac85bcb000000b003b9bf43fccdmr41294093qtb.10.1676319331969; 
 Mon, 13 Feb 2023 12:15:31 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 y16-20020ac85f50000000b003ba1ccba523sm10037536qta.93.2023.02.13.12.15.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:31 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:14:01 -0500
Message-Id: <20230213201401.45973-40-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 39/39] dm clone: prefer kvmalloc_array()
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-clone-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 29e0b85eeaf0..f38a27604c7a 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -580,7 +580,7 @@ static int hash_table_init(struct clone *clone)
 
 	sz = 1 << HASH_TABLE_BITS;
 
-	clone->ht = kvmalloc(sz * sizeof(struct hash_table_bucket), GFP_KERNEL);
+	clone->ht = kvmalloc_array(sz, sizeof(struct hash_table_bucket), GFP_KERNEL);
 	if (!clone->ht)
 		return -ENOMEM;
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

