Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E28EC43219
	for <dm-devel@archiver.kernel.org>; Wed, 19 Oct 2022 06:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666160329;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CC4i8d8HFHVl/woSOdS4EFzyoa91H/tPJZwgCtnw36w=;
	b=aGdAufgQSpcgHm50dXDUNL42+Y6WAwywOwUYJcPNKHu/cvRhmYGzL2VviYDOiShe3JHQpd
	ANRMSZHzN9a7jVCZouWvtj5Dym7wiqkuCxuEf810jkn6b2HK92wPLnWDjoLj19wteTXn2g
	Hj1LIX1BSIAeCqHWD3FE99iWVoNA/uY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-eiQ2m1SaOLuUZ6cMqjaXMg-1; Wed, 19 Oct 2022 02:18:45 -0400
X-MC-Unique: eiQ2m1SaOLuUZ6cMqjaXMg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59EC185A59D;
	Wed, 19 Oct 2022 06:18:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07FACC15BA5;
	Wed, 19 Oct 2022 06:18:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E23EF1946595;
	Wed, 19 Oct 2022 06:18:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5839F194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Oct 2022 15:48:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 370BB40C2065; Tue, 18 Oct 2022 15:48:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FDAE40C2064
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 15:48:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15DCD2999B33
 for <dm-devel@redhat.com>; Tue, 18 Oct 2022 15:48:32 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-6jSvP5EnNWene-8gqf8cgQ-1; Tue, 18 Oct 2022 11:48:19 -0400
X-MC-Unique: 6jSvP5EnNWene-8gqf8cgQ-1
Received: by mail-wm1-f47.google.com with SMTP id e18so11020266wmq.3;
 Tue, 18 Oct 2022 08:48:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Kc2UL3oN9PPfeSBBUmmfy9LYW7xOBidoFqGgLYVlKcA=;
 b=PykpHBe0gb4WHerJXcqkaGJTvsriH4PE2xi6bm17N4WNabKxo27Nm1S4moqpFHo3jl
 96+UqXCg5Not9HhvNxLpO0aYEBj8uAvlZIm4ZOjRuerVT9/3eQqQzgCwac9H5mU3wIrJ
 ssyc1ujk3rfbGg8KA5G/XdtT1ApHprbYhWI1Bf1p+4CzdJE4jO/oGcSwERqngb31RktS
 VaRkxOgIBeF6NTkdtSQwox4ltFeKCS63qhW+7q2MgzlVJWA4yWXNtv67NedV+w2wzSDP
 GA85Qpz91xE61iw+sDXrYVfTCKCiQ4AF7OzAvkaoUn09BfVuru7An2iiXILo/wCvIU8p
 Zx7Q==
X-Gm-Message-State: ACrzQf1JNef8JIzg44SCHSqkNSf92ol8wuufcuFOA8jPL7J5QUQuzut8
 dWJJGGBwu1D5GekrpROotUnebD7GBdmWOVcd
X-Google-Smtp-Source: AMsMyM4dTruaicUT8XNa3C6PP05o/J4zMO34InV/LERpEWhfnsNk8WiCIcj9E4p2iSMt2tAXo6neOA==
X-Received: by 2002:a05:600c:4449:b0:3c6:fb65:2463 with SMTP id
 v9-20020a05600c444900b003c6fb652463mr2532149wmn.128.1666108096131; 
 Tue, 18 Oct 2022 08:48:16 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net.
 [80.193.200.194]) by smtp.gmail.com with ESMTPSA id
 r124-20020a1c2b82000000b003bf3fe1d0c4sm14030316wmr.22.2022.10.18.08.48.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Oct 2022 08:48:15 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 18 Oct 2022 16:48:15 +0100
Message-Id: <20221018154815.943209-1-colin.i.king@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 19 Oct 2022 06:18:39 +0000
Subject: [dm-devel] [PATCH] dm thin: make const array descs static
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
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Don't populate the read-only const array ramp_base on the stack but
instead make it static. Add in a const to clean up checkpatch warning
too since the data and the pointer are const. Also makes the object
code a little smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e76c96c760a9..d228177fdf35 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -293,7 +293,7 @@ static enum pool_mode get_pool_mode(struct pool *pool)
 
 static void notify_of_pool_mode_change(struct pool *pool)
 {
-	const char *descs[] = {
+	static const char * const descs[] = {
 		"write",
 		"out-of-data-space",
 		"read-only",
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

