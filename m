Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37CE2C6379F
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319323;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GWOrZ2l9tSfbVjcpaZu4IRg4DkuwugdmRWTBGFU27io=;
	b=DC8bVCNuw1Dkr5eE2MKUApV5cZQe5iIpw3sv1haRC7pDsPLgUQ7Ob//GNiLRq7snkuJ8zw
	ud6se7K05tCFdHetjT/EpwF/+hbPomIwfIWlM73+QP5wEBpMFpJ1H+nnJQrqnWUSpF8fRP
	lV1aEDxB3YowVRCdMvvz4akGKr4VFn0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-JLhtY3HDMcanp86vko0DsA-1; Mon, 13 Feb 2023 15:15:16 -0500
X-MC-Unique: JLhtY3HDMcanp86vko0DsA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 831F63C025C7;
	Mon, 13 Feb 2023 20:14:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71E5C492B15;
	Mon, 13 Feb 2023 20:14:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 61D041946588;
	Mon, 13 Feb 2023 20:14:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E595B1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DD126492B05; Mon, 13 Feb 2023 20:14:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D583F492B03
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB31A3815F63
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:52 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332-5wjOj5J-NOOVOsgMm5SUVw-2; Mon, 13 Feb 2023 15:14:51 -0500
X-MC-Unique: 5wjOj5J-NOOVOsgMm5SUVw-2
Received: by mail-qt1-f180.google.com with SMTP id g8so15148466qtq.13
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=c91WK1OyBDyiq3MB3FsSwG/0GPFzMHXw/9vheAFvUMI=;
 b=z0sCNw57AJ7ny8GdAOiNC/yBq3mOkhF91z47BoN+fmenuCwX67idVswcU/WDDFDKJH
 wTOhuf7ustskb6/f3pS9KWjwlwyK3RvCEB2BqdsuHchYxm3J11BckQy7V9yPMLTclWhL
 BhdudD+6s2YflgCy+jmrmGMcsCA5lnZCUiupbsgKL41Yc4a3bpxPQa3pIELMQOrvNr9G
 jIigfzYii+iiZZ+vB1l+aT8fpHAlx4yTlYIZO/bZ+D03818NJlUwlohSNHImAA7LMw8q
 PI0Zeb7ZgZOcG22WXv3LZSNkQ3RtyLtpPXZ4CoHTt+CIQ/2nunw1qSJAu1R7yGsKsMwy
 YZZw==
X-Gm-Message-State: AO0yUKXvg5oIi5QmiTBJcFuSZbYU8RpvHgN2iH2sOENmrzrw5VbwGvL2
 jZL+hAqK3obqk6Rk0gKHjMOpXmJelp4Y8ln7iF6Nlo8KzOzhn80HzwcMj7P0Tz/Zws4Tf2XSP0D
 avkqW5ruhQz8336cQoFAKbpYhDgCVh8t8fB6z+Ue7D6Ztag3lpXdQmkn5Uqk3rYEJ6/RV2Q==
X-Google-Smtp-Source: AK7set9abdhPUf3AGLMQP1l65Mms9enKuzbUL4B/DrXc8ZXNsHxYhQksoO6njQICVj1DIKHh+sqTCw==
X-Received: by 2002:ac8:5a54:0:b0:3ba:1acd:4f8 with SMTP id
 o20-20020ac85a54000000b003ba1acd04f8mr47180548qta.42.1676319290713; 
 Mon, 13 Feb 2023 12:14:50 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 k17-20020a05622a03d100b003bb7af2125fsm10060210qtx.90.2023.02.13.12.14.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:50 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:36 -0500
Message-Id: <20230213201401.45973-15-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 14/39] dm block-manager: avoid not required
 parentheses
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/persistent-data/dm-block-manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 741a1a90bdee..f8e364a034fc 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -620,7 +620,7 @@ void dm_bm_prefetch(struct dm_block_manager *bm, dm_block_t b)
 
 bool dm_bm_is_read_only(struct dm_block_manager *bm)
 {
-	return (bm ? bm->read_only : true);
+	return bm ? bm->read_only : true;
 }
 EXPORT_SYMBOL_GPL(dm_bm_is_read_only);
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

