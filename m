Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60F6C636D7
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 20:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676664477;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0gTXaiZkp6GF3s23GYczv+1tWMIG+khlLZpPQPxW1Y4=;
	b=XEhlExPDTHkqUpjtPM9AkN+iBGlKFLPZ82XK1MsS8r6N55QxxxfDbbnEid+6QUv0hVuBNk
	nkOTz8rKSR6u9o9alNrPepW2EtQtR9IZO9pzYX2PoVzAXui1tGZ3nbU5gTAvTd0qRK+CSv
	YVRQjNvZn1jgkhJV4nwSGJa60orB6Yc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-TjiWhhdFMIqJrDQ5xmxYWA-1; Fri, 17 Feb 2023 15:07:54 -0500
X-MC-Unique: TjiWhhdFMIqJrDQ5xmxYWA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D443780D0E9;
	Fri, 17 Feb 2023 20:07:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF061492C3E;
	Fri, 17 Feb 2023 20:07:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A8E9A1946589;
	Fri, 17 Feb 2023 20:07:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4E511946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 20:07:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9BB01C16021; Fri, 17 Feb 2023 20:07:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94709C15BAD
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A54E2A2AD4A
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:50 +0000 (UTC)
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com
 [209.85.219.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-627-68UcaOs9MR2-Z898xmASGw-1; Fri, 17 Feb 2023 15:07:47 -0500
X-MC-Unique: 68UcaOs9MR2-Z898xmASGw-1
Received: by mail-qv1-f45.google.com with SMTP id j10so1863247qvc.1
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 12:07:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=04ECuPnChQJ8NzfEi+Tvo1Ht/YIvPbjtCCgFUEEZIbo=;
 b=r/8mho/du/utXuOIvVED5lctjSl653gx2HoR3RNNOfEb9N6In01gr4lR9admViBIRu
 /k4IvLbG6cXdZXu12jSWRYlF4eDTaC15/rf/yOB4iKJJBhkj7vvmuzoC3qzEfOwlsw8F
 t9U7XUDpXhITHlE9WZIo/WcJX1JLErId1mRcWc8k/R15FxilB0wmDeL6lp3j+ULwxVQt
 4zUD4pqrUukImekAWsN64tlDk5Mnl1j/FMDsmiYytoXkLJkJlWKMc6pYG5zcQZahQ37s
 M0d7rl+ZLSPD+4+QrJJNkhW3wHyJ/AIcvnZV6/TaVBNOSydqPrWAJw5Z03bJarE/4OWg
 v7zw==
X-Gm-Message-State: AO0yUKW7OiFoDfEPzy159lHcW06FOHqoruwBa4cHotqDR4UdKLdcocL3
 29iTXoRe63sA+RQg61N64eZQO5Gqk6EhtA4QUbyYgZmU0ULt+FH+E9g9XHw00Qlw3OMmY12teR5
 K6hlwLOftfuE9UMg5ujxk7npeYpWpurHBiJh6z4alqAqwrK3csn9wZ25J92KTFRx1Zg6B1w==
X-Google-Smtp-Source: AK7set+HJEpooJYK4Fs6wkBEUsnX5oAghDOCi9Lc1hCRtueiFQrdqCwhamPCH6E73V1F/g20IiC4DQ==
X-Received: by 2002:a05:6214:1948:b0:56e:ae9f:a503 with SMTP id
 q8-20020a056214194800b0056eae9fa503mr3802040qvk.31.1676664465269; 
 Fri, 17 Feb 2023 12:07:45 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 q8-20020a05620a024800b0073b8745fd39sm3910424qkn.110.2023.02.17.12.07.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 12:07:44 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 17 Feb 2023 15:07:35 -0500
Message-Id: <20230217200737.12481-5-snitzer@kernel.org>
In-Reply-To: <20230217200737.12481-1-snitzer@kernel.org>
References: <20230217200737.12481-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH 4/6] dm cache: add cond_resched() to various
 workqueue loops
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-cache-target.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 23195701dc15..dbbcfa580078 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1829,6 +1829,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1852,6 +1853,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1892,6 +1894,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

