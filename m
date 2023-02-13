Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E55C6FA8E
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319336;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iAN6n/PHiyfwvd+Qy/9VGWjxwdCHvFPYfheXJcG+QyA=;
	b=Be+IU2uPHx3BbUqpkA6Lz5nAml1KJtKIQP9TmhIgLtu3fH7xUAtnuZgVOKoP3W/UbxjmhW
	62pNN75lgB3a4VpFSMyZ7qQrXpVmtDF/+9AApsFGgjMR7r/BHkHxu0y2tFh7lmbCLl+ew0
	R1EjAYuf9PJDVopAuxfY40r9KKZF1ik=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-N1ZfZf6QNn2kc-oObb0oBg-1; Mon, 13 Feb 2023 15:15:34 -0500
X-MC-Unique: N1ZfZf6QNn2kc-oObb0oBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A886C97108D;
	Mon, 13 Feb 2023 20:15:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9315F112131B;
	Mon, 13 Feb 2023 20:15:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C1861946588;
	Mon, 13 Feb 2023 20:15:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D79981946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CD6262166B29; Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C6DAE2166B26
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8A1585570E
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:21 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-5II26GfdP1--1bG9J5HwOw-2; Mon, 13 Feb 2023 15:15:17 -0500
X-MC-Unique: 5II26GfdP1--1bG9J5HwOw-2
Received: by mail-qv1-f50.google.com with SMTP id d13so9095781qvj.8
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=eaembEZx0YR9+lF9Bp2pMR6xtvo3+MaZ/4eSTBw5ljo=;
 b=PT0edfLPAxDM7BLyhrrL9HIAzunODcun4bnobblakZRTp/IG6fOQA7KgRBhPTivxlR
 a4z8PFA8x4tJD5hr3Kv+DUN0Jhyvu1SrTiANHkpMd9cY9+/M2w9NabHap+FU2mbyTbzI
 dBhgEXl1jxWj0VyNOREgjY2lOA1BWO/CeTgS+tWAe5HXrjKuMgX/Z60uu+u+cR+fZogy
 4xhyGovzaaD2NQdQ4wFkhEnVK2jpTQcJP3DlPYBkrsZYKxlJE4mFhB2k9e0C5TcawZ2w
 VRVrV14j/wnnW56T1OMwkGMAdWpn33JjCP/MWBKqPor709xAP1utIqReX74QY0OJSP/y
 yP0A==
X-Gm-Message-State: AO0yUKVUG+C5BdiTdAcbu1ISVX+f0IvJPNT+baIu957G7CpcXbMtvV6N
 cINHHxwv+ztHvjAresFvCiRRRyxiC2a1Y3xVvS+7lMUFiA21sSmQXmoRZnUXCf0JCtMk6IVFUpj
 j4Uc0N+oSGAGmOxQZSdMe88HryeB/toVSe8HWnPikW5BvnU0fpMWtcbmxZkKSRuWw+PKnwQ==
X-Google-Smtp-Source: AK7set8NNo6mb1jwBmUkYVSeDP8rimA0E0Khh7ITk9pt7VyUbntQqAFwEs6Y3l8cU+VCSGyG0MdUpQ==
X-Received: by 2002:a05:6214:20a8:b0:56e:c19f:2f01 with SMTP id
 8-20020a05621420a800b0056ec19f2f01mr279801qvd.29.1676319316751; 
 Mon, 13 Feb 2023 12:15:16 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 e7-20020a378207000000b0071a49ac0e05sm10315742qkd.111.2023.02.13.12.15.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:16 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:52 -0500
Message-Id: <20230213201401.45973-31-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 30/39] dm log: avoid trailing semicolon in macro
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index f1bc14b6fd7c..94c5d8a19231 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -789,7 +789,7 @@ static region_t core_get_sync_count(struct dm_dirty_log *log)
 	do { \
 		if (lc->sync != DEFAULTSYNC) \
 			DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : ""); \
-	} while (0);
+	} while (0)
 
 static int core_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

