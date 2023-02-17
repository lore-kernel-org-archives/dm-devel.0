Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B5AC05027
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 20:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676664509;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oIQ4JJg3bheGX2mSyAlZpY5ELu3hdjSVFDXoQ+fGqV8=;
	b=EXf32YYGe6Xt24MqpECu4KPKnh4hiHo1EbuC79XNH8/ZOYxaciue2ppqNvsQmYQFkyzoHS
	JcShvBL2GMh3KwkcBc/vRQjhAsmquQHbIsflYE5UZpHTf2D5fylU0ljn5LYF6VZkfz+KUb
	WLX/26l2NcO26SU0YOqPj3vQbWW/Vfg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-RbQR2Om3OFqHwdVUs1Xejw-1; Fri, 17 Feb 2023 15:08:26 -0500
X-MC-Unique: RbQR2Om3OFqHwdVUs1Xejw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6061C04B7E;
	Fri, 17 Feb 2023 20:08:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AEF4175AD;
	Fri, 17 Feb 2023 20:08:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 393961946589;
	Fri, 17 Feb 2023 20:08:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CCAF71946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 20:08:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B890E40B40E4; Fri, 17 Feb 2023 20:08:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0C4C40B40C9
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:08:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DEAF83B9DD
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:08:23 +0000 (UTC)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-575-0EyIDXvCN0WMLGU9kDuIDA-1; Fri, 17 Feb 2023 15:07:48 -0500
X-MC-Unique: 0EyIDXvCN0WMLGU9kDuIDA-1
Received: by mail-qv1-f44.google.com with SMTP id e17so2219430qvw.8
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 12:07:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=EnC0ho3TMfOzHT8SCGdIGjy9L/3TOsau5F7yz4GT7rM=;
 b=iyi3JviC5oig9gG47qDwbybBjuMNMx7hsB26+gNQ4F7Ojs2LWbzg6nO1NIeZWkTMjB
 N5tn1tXRTOeWQehd+h383ebG3AUw/S/JgcEAJU1KCCzLaJHlSPYeASBy07YybqBgPcFK
 SRp8SVCXL7OAO4rYkhZEui/AF0fmwDK4qzpxwQB+jbdWh/y1hrnIyWzTxEqM44ZYy1Hp
 i56w1udb+wQoGcl1Q18+O2Yz0UYt5e5Px7dE/TpDVkZWg38yjKxPli94KIGEweZYiUXR
 8LgydXO1eu+Wn04QXPVFHUqcEjZCWLGK3j8vITj2L05wVf/l3Mawnvb0lkTbLc69+l60
 CUgg==
X-Gm-Message-State: AO0yUKWz3jAFPi8VtavBWkFSr/E1Sh3vVTbfdBQu3f+xOsepEwZJWaAk
 +rjZuFp7hAB5jX5+Ty7cjAY4Q03Sux1l2M2INckgw9h7rs4ZG/zeQ9PHXgCZmB/ipLnHl5E76DD
 H3q0KrpDPrsMiFqCYhpQipYQGQssD9QA626IXF2lkHeKrTKp5dokiTQKDwxGoGJPRlmcw2Q==
X-Google-Smtp-Source: AK7set826ypbmlbh1FQKcwTFbqxnLVxLukx7QPHWYyXldNdEc0kSdq2/kqC25VBvhMej89n+5Ktg9A==
X-Received: by 2002:ad4:5d67:0:b0:56f:87f:d92c with SMTP id
 fn7-20020ad45d67000000b0056f087fd92cmr8382472qvb.0.1676664462247; 
 Fri, 17 Feb 2023 12:07:42 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a138-20020ae9e890000000b0072396cb73cdsm3938226qkg.13.2023.02.17.12.07.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 12:07:41 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 17 Feb 2023 15:07:33 -0500
Message-Id: <20230217200737.12481-3-snitzer@kernel.org>
In-Reply-To: <20230217200737.12481-1-snitzer@kernel.org>
References: <20230217200737.12481-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 2/6] dm: add cond_resched() to
 dm_wq_requeue_work()
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
Cc: Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Otherwise the while() loop in dm_wq_requeue_work() can result in a
"dead loop" on systems that have preemption disabled. This is
particularly problematic on single cpu systems.

Fixes: 8b211aaccb915 ("dm: add two stage requeue mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 15b91959e433..adb002b8648d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1009,6 +1009,7 @@ static void dm_wq_requeue_work(struct work_struct *work)
 		io->next = NULL;
 		__dm_io_complete(io, false);
 		io = next;
+		cond_resched();
 	}
 }
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

