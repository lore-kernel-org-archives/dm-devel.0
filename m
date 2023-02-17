Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA37C64ED9
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 20:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676664474;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=15z/ExdBrKoFwj6SvsDWgvdQg/HLl9GmwjarexBYf7U=;
	b=WmkW3Y91wtlCYq1ODu9bVoSlHfO4ZQohK/30WujbTBvCovxPoUdtjlw8uMcrt3xZnJ1Oas
	3cUtol7Fp1qtxZ1oeHhkQqhkf7tPzj1lxmb76rkjr17hBO6NBR5cgp10EQgFO0/Z47PfEx
	0FU2gAq+PKceqYoQoEg4+j202KTWUsc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-8D4MMTyxPu6xSTzzN-p5Nw-1; Fri, 17 Feb 2023 15:07:52 -0500
X-MC-Unique: 8D4MMTyxPu6xSTzzN-p5Nw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3C6B185A7A4;
	Fri, 17 Feb 2023 20:07:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91E0E43FBA;
	Fri, 17 Feb 2023 20:07:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 64BFC1946589;
	Fri, 17 Feb 2023 20:07:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B332E1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 20:07:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95060C15BAD; Fri, 17 Feb 2023 20:07:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E0DEC15BA0
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E5A1101156F
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:49 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-135-93In_jFUNO-rhO3nmdru3A-2; Fri, 17 Feb 2023 15:07:47 -0500
X-MC-Unique: 93In_jFUNO-rhO3nmdru3A-2
Received: by mail-qt1-f178.google.com with SMTP id v3so1880619qta.2
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 12:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=2BlYLBOK4DUQVRhoEhjUSWik18bEgWdPa8QwAVD7ty8=;
 b=TZk030Yw9cAtf5M78sFfge2btBaudqzuYNHnV45fPhQb0nbw1GwgU2fZ6IUf9bP/Of
 I5ta92rNRSGEiGSW3O8AjOrdQcu4wNLRVkBxQgZP8gLQPYbhxWR7VtyIvLd7W5JbBseE
 Tun0ECrJvq7sPUawY/m90obJUMJ4YoGJ6JlbNctPgF9FOeM9JpO3gIGqYd7zen/DmYKR
 KUSli1O6FEG28f51seDVn89MOi60A8kZa6AbHaXOwuhy9u1OCgl25v5PbRz1JRdWPxAq
 bUaglm2pbXR1e4cJ41zAWMoWqcfbG1C5u2+m/5BERW5a7V6BB8E8i3JFiHtB/2ljzCBM
 kTSg==
X-Gm-Message-State: AO0yUKV11DScbfWVFYoq9TTQI/y9xmZ3j+AJJhvVxfYLTWraAjriRl6C
 zQVuNwZkpKCgeZsQvZilffTVZ3V8bXCzkwMNI991cr6dGg19m15kPORBQ9tQgByxNZ1YN3Tf1SJ
 UJirJPy3qTJCgxX3ICQctdxZbW4WqMqAEN5y8BMjwbuYS7/V/TWjnX7y7V9uAt4APLBdv0g==
X-Google-Smtp-Source: AK7set9X98bufMtiXPRysxuJ0eNDOtmCVPR3rdu2OA4rgcM8oRt5jkBGXYs5k/FYj6YbFbR2mDwdfA==
X-Received: by 2002:a05:622a:15d0:b0:3b9:bd1f:1de6 with SMTP id
 d16-20020a05622a15d000b003b9bd1f1de6mr542301qty.40.1676664466782; 
 Fri, 17 Feb 2023 12:07:46 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 w10-20020ac86b0a000000b003b8484fdfccsm3783450qts.42.2023.02.17.12.07.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 12:07:46 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 17 Feb 2023 15:07:36 -0500
Message-Id: <20230217200737.12481-6-snitzer@kernel.org>
In-Reply-To: <20230217200737.12481-1-snitzer@kernel.org>
References: <20230217200737.12481-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 5/6] dm ioctl: assert _hash_lock is held in
 __hash_remove
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

Also update dm_early_create() to take _hash_lock when calling both
__get_name_cell and __hash_remove -- given dm_early_create()'s early
boot usecase this locking isn't about correctness but it allows
lockdep_assert_held() to be added to __hash_remove.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f34d36a4b4a1..067dfc08d4c3 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -310,6 +310,8 @@ static struct dm_table *__hash_remove(struct hash_cell *hc)
 	struct dm_table *table;
 	int srcu_idx;
 
+	lockdep_assert_held(&_hash_lock);
+
 	/* remove from the dev trees */
 	__unlink_name(hc);
 	__unlink_uuid(hc);
@@ -2263,7 +2265,9 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 err_destroy_table:
 	dm_table_destroy(t);
 err_hash_remove:
+	down_write(&_hash_lock);
 	(void) __hash_remove(__get_name_cell(dmi->name));
+	up_write(&_hash_lock);
 	/* release reference from __get_name_cell */
 	dm_put(md);
 err_destroy_dm:
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

