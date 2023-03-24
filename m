Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC66C77B61
	for <dm-devel@archiver.kernel.org>; Fri, 24 Mar 2023 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679680670;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MeQ4yi1LIZD14GTNugdnfd5Mpz9/CMJODyQ9uydjL0g=;
	b=bsiwDAYEmZbo7LfmsvEx90rVcVdeGvR2vFyAz4zyc5BRpfvKSYfuG8jIzvVZGDrW2yw+R0
	9TSi9430MjOcSsUiIlxQR59n5Rh+4xn9+hhLYg2b46dbQO3meT+6VWdYRd2kwsVpZ13Yxy
	2tDV1GQG3bsy9tjoQDMfo6OSvLCXSSU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-xIvvvyd1Oo6_PnHpw96d2Q-1; Fri, 24 Mar 2023 13:57:47 -0400
X-MC-Unique: xIvvvyd1Oo6_PnHpw96d2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 526C3185A790;
	Fri, 24 Mar 2023 17:57:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4345640C6E67;
	Fri, 24 Mar 2023 17:57:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9593C19472D6;
	Fri, 24 Mar 2023 17:57:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87EA51946A6D
 for <dm-devel@listman.corp.redhat.com>; Fri, 24 Mar 2023 17:57:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68EAA1121315; Fri, 24 Mar 2023 17:57:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 618D01121314
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43D31855300
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 17:57:10 +0000 (UTC)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-9SFcFrIVOWOORL4pBDHy-A-2; Fri, 24 Mar 2023 13:57:08 -0400
X-MC-Unique: 9SFcFrIVOWOORL4pBDHy-A-2
Received: by mail-qv1-f43.google.com with SMTP id q88so2047718qvq.13
 for <dm-devel@redhat.com>; Fri, 24 Mar 2023 10:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679680628;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Zqo5mDL6nva3zDOWLYglj1LiFa9S7ZuvdxIC0/waJHU=;
 b=oA3UTntnZezyhH0Jvt1+lauj1N/X0m4+jxvda+cqk1chJfpi9Nth14ycSaoG9oYoww
 ZVIvC9ThK5gD3laC1JCkgb89BZ3gK3iTcN5UxExMFMVrm/FLx7LaMlKQ5/GkABCEhWAc
 DH/Y7JVl+JgtYxW0zY+sEGgO1ILQ3J1lBUQZU8OOCgcOsvyXZWtUsKG8rOJyPecGtSU5
 peWVeDp3FdbVrZGUJUIfe0GfEsRfKykxQszZWqbkvOliNM6jcVSFgTNEuLPnEwHg88q6
 2JPorAapgQKeTtVrCtM0U8OlNDZfXUk/Mx7hEsA9CeGgl2hophrUEx/rrAdErayYAnhk
 2P0g==
X-Gm-Message-State: AAQBX9eSOQBK59tfU9o+cwejVM0WmogyfmdNXd5KnkUqaSq9BG1586rm
 bYK84JJQv4i6kK8iz4ts6snroKbhOF83uIiOocrQI1sRPFIhX66rJld5V3MdG5Z8wJiOT7K/DEv
 c5Ej83L3r7GTlgl3Nvtb/p0Q6ozs4QPSVByXHpxYPxiGGVNcOifhMJTZCZolSUs1RUBl7dI3vsa
 Y=
X-Google-Smtp-Source: AKy350YkDjOVwxQq5CsRXiq/M1DJwMWot5uR1CYpqeERo5DD5gy1/o7k1G+5FpU3S2CJjb8y2fcZ6Q==
X-Received: by 2002:a05:6214:62e:b0:56e:a96a:2bdc with SMTP id
 a14-20020a056214062e00b0056ea96a2bdcmr4564204qvx.40.1679680627786; 
 Fri, 24 Mar 2023 10:57:07 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 kr15-20020a0562142b8f00b005dd8b93456csm843213qvb.4.2023.03.24.10.57.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 24 Mar 2023 10:57:07 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 24 Mar 2023 13:56:52 -0400
Message-Id: <20230324175656.85082-6-snitzer@kernel.org>
In-Reply-To: <20230324175656.85082-1-snitzer@kernel.org>
References: <20230324175656.85082-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [dm-6.4 PATCH v2 5/9] dm bufio: use waitqueue_active in
 __free_buffer_wake
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

From: Mikulas Patocka <mpatocka@redhat.com>

Save one spinlock by using waitqueue_active. We hold the bufio lock at
this place, so no one can add entries to the waitqueue at this point.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 929685011e02..b638ddd161b4 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1669,7 +1669,12 @@ static void __free_buffer_wake(struct dm_buffer *b)
 		c->need_reserved_buffers--;
 	}
 
-	wake_up(&c->free_buffer_wait);
+	/*
+	 * We hold the bufio lock here, so no one can add entries to the
+	 * wait queue anyway.
+	 */
+	if (unlikely(waitqueue_active(&c->free_buffer_wait)))
+		wake_up(&c->free_buffer_wait);
 }
 
 static enum evict_result cleaned(struct dm_buffer *b, void *context)
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

